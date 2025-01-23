/obj/item/weapon/proc/trigger_kill(mob/killer, mob/victim)
    if (!killer || !istype(killer, /mob/living)) return
    var/mob/player = killer
    check_achievements(player)

/proc/check_achievements(mob/player)
    for (var/datum/achievement/A in global_achievements)
        A.check(player)
