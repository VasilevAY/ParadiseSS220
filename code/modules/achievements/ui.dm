/mob/verb/view_achievements()
    set category = "Player"
    var/list/achievements_display = list()
    for (var/datum/achievement/A in global_achievements)
        var/status = (usr.achievements[A.name]) ? "Unlocked" : "Locked"
        achievements_display += "[A.name]: [status]"
    usr << browse(output_text(achievements_display), "Achievements")
