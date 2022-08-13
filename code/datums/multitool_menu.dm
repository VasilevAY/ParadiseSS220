/datum/multitool_menu_host
	/// The multitool
	var/obj/item/multitool/multitool
	/// multitool_menu datum of an attached object
	var/datum/multitool_menu/attached_menu

/datum/multitool_menu_host/New(obj/item/multitool/_multitool)
	..()
	if(!istype(_multitool))
		CRASH("My multitool is null/the wrong type!")
	multitool = _multitool

/datum/multitool_menu_host/Destroy()
	disconnect()
	multitool = null
	return ..()

/datum/multitool_menu_host/proc/disconnect()
	attached_menu = null

/datum/multitool_menu_host/proc/get_menu_id(mob/user)
	// Which menu should be opened for the currently attached object
	var/my_menu_id
	if(!attached_menu)
		// No thing to configure
		my_menu_id = "default_no_machine"
	else if(get_dist(user, attached_menu.holder) > 1)
		// User is too far away from the thing
		disconnect()
		my_menu_id = "default_no_machine"
	if(attached_menu)
		// Multitool is still attached to the thing
		if(attached_menu.allowed_to_be_configured(user))
			my_menu_id = attached_menu.menu_id
		else
			my_menu_id = "access_denied"
	return my_menu_id

/datum/multitool_menu_host/proc/interact(mob/user, datum/multitool_menu/_attached_menu)
	attached_menu = _attached_menu ? _attached_menu : null
	ui_interact(user)

/datum/multitool_menu_host/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "Multitool", multitool.name, 300, 200, master_ui, state)
		ui.open()

/datum/multitool_menu_host/ui_act(action, list/params)
	if(..())
		return
	. = TRUE
	switch(action)
		if("buffer_add")
			multitool.ui_act_set_buffer(attached_menu.holder)
		if("buffer_flush")
			multitool.ui_act_clear_buffer()
		else
			attached_menu?._ui_act(usr, action, params)

/datum/multitool_menu_host/ui_data(mob/user)
	var/list/data = list()
	. = data
	// Multitool data
	data["buffer"] = multitool.buffer ? TRUE : FALSE
	data["bufferName"] = multitool.buffer?.name
	// Other object's data
	var/menu_id = get_menu_id(user)
	data["multitoolMenuId"] = menu_id
	data["configureName"] = attached_menu?.holder.name
	if(menu_id == "access_denied" || menu_id == "default_no_machine")
		return
	var/list/menu_data = attached_menu?._ui_data()
	if(!menu_data)
		return
	data.Add(menu_data)
	return

/datum/multitool_menu_host/ui_close(mob/user)
	disconnect()
	return ..()

/datum/multitool_menu_host/ui_host()
	return multitool


/datum/multitool_menu
	/// The object the state of which can be changed via the multitool menu.
	var/obj/holder
	/// The holder type; used to make sure that the holder is the correct type.
	var/holder_type
	/// Which menu should be opened for the holder. For example "default_no_machine".
	var/menu_id
	/// This allows to have a separate access to open the multitool menu
	var/use_alt_access = FALSE
	var/list/req_access_alt
	var/list/req_one_access_alt

/datum/multitool_menu/New(obj/_holder)
	..()
	if(!istype(_holder, holder_type))
		CRASH("My holder is null/the wrong type!")
	holder = _holder

/datum/multitool_menu/Destroy()
	holder = null
	return ..()

/datum/multitool_menu/proc/allowed_to_be_configured(mob/user)
	if(!user)
		return FALSE
	if(!use_alt_access)
		return holder.allowed(user)
	var/user_access = user.get_access()
	if(user_access == IGNORE_ACCESS || user.can_admin_interact())
		// Mob ignores access
		return TRUE
	if(!user_access)
		return FALSE
	if(!istype(user_access, /list))
		return FALSE
	var/list/my_req_access = req_access_alt ? req_access_alt : list()
	var/list/my_req_one_access = req_one_access_alt ? req_one_access_alt : list()
	return has_access(my_req_access, my_req_one_access, user_access)

/datum/multitool_menu/proc/interact(mob/user, obj/item/multitool/my_multitool)
	if(!menu_id)
		return
	if(!(user && istype(user)))
		return
	if(!(my_multitool && istype(my_multitool)))
		return
	//holder.add_fingerprint(user)
	my_multitool.menu.interact(user, src)

/datum/multitool_menu/proc/_ui_act(mob/user, action, list/params)
	//holder.update_icon()

/datum/multitool_menu/proc/_ui_data()
	var/list/data = list()
	return data

/datum/multitool_menu/emitter
	holder_type = /obj/machinery/power/emitter
	menu_id = "no_options"
