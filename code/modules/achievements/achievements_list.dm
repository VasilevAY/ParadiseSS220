/var/list/global_achievements = list()

/datum/achievement/New(name, description, icon, criteria, reward)
    src.name = name
    src.description = description
    src.icon = icon
    src.criteria = criteria
    src.reward = reward
    global_achievements += src

// Пример достижений
/datum/achievement
    new("First Blood", "Kill your first enemy.", 'first_blood.dmi', /datum/achievement/check_kills(1), "100 credits")
    new("Survivor", "Survive a critical condition.", 'survivor.dmi', /datum/achievement/check_survival(), NULL)
