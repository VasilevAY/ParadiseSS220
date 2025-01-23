#include "sql_helpers.dm"  // Подключение стандартных функций работы с БД

// Процедура загрузки достижений игрока из базы данных
/proc/load_player_achievements(mob/player)
    // Проверяем подключение к базе данных
    if (!sql_is_connected())
        sql_connect()

    // Выполняем запрос на получение достижений игрока
    var/list/results = sql_query(
        "SELECT achievement_id FROM player_achievements WHERE player_id = ?",
        player.ckey
    )
    if (results)
        // Заполняем список достижений игрока
        for (var/row in results)
            var/achievement_id = row["achievement_id"]
            player.achievements[achievement_id] = TRUE

// Процедура сохранения нового достижения игрока
/proc/save_player_achievement(mob/player, achievement_id)
    // Проверяем подключение к базе данных
    if (!sql_is_connected())
        sql_connect()

    // Выполняем запрос на добавление достижения
    sql_execute(
        "INSERT INTO player_achievements (player_id, achievement_id) VALUES (?, ?)",
        player.ckey, achievement_id
    )

// Процедура проверки подключения к базе данных
/proc/sql_is_connected()
    return istype(global_db_connection, /datum/sql_connection) && global_db_connection.connected

// Процедура подключения к базе данных (если еще не подключено)
/proc/sql_connect()
    if (!global_db_connection)
        global_db_connection = new()
    if (!global_db_connection.connect("dbname=paradise user=admin password=pass host=localhost"))
        CRASH("Unable to connect to the database. Check configuration.")
