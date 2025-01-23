// code/
// └── modules/
//    ├── achievements/
//    │   ├── achievements.dm        Логика достижений
//    │   ├── achievements_list.dm   Реестр достижений
//    │   ├── triggers.dm            Триггеры событий
//    │   ├── achievements_db.dm     Работа с базой данных
//    │   └── ui.dm                  Интерфейс
//    ├── mob/
//    │   └── mob_triggers.dm        Интеграция с персонажами (если нужно)
// icons/
// └── achievements/
//    └── achievements.dmi           Иконки достижений

/datum/achievement
    var/name
    var/description
    var/icon
    var/criteria  // Условия выполнения (функция)
    var/reward

/datum/achievement/proc/check(mob/player)
    if (criteria(player))
        award(player)

/datum/achievement/proc/award(mob/player)
    if (player.achievements[name]) return  // Уже выдано
    player.achievements[name] = TRUE
    save_player_achievement(player, name)  // Сохранение в БД
    player << "Achievement unlocked: [name]!"
    if (reward) player.give_reward(reward)
