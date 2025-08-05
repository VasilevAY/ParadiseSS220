#define SALARY_FOR_NISHEBROD 60

/datum/job/civilian
	title = JOB_TITLE_CIVILIAN
	flag = JOB_FLAG_CIVILIAN
	department_flag = JOBCAT_SUPPORT
	total_positions = -1
	spawn_positions = -1
	supervisors = "the head of personnel"
	department_head = list(JOB_TITLE_HOP)
	selection_color = "#e6e6e6"
	access = list(ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MAINT_TUNNELS)
	alt_titles = list("Tourist","Businessman","Trader","Assistant")
	outfit = /datum/outfit/job/assistant
	insurance_type = INSURANCE_TYPE_BUDGETARY

	salary = SALARY_FOR_NISHEBROD
	min_start_money = 10
	max_start_money = 200


/datum/outfit/job/assistant
	name = "Civilian"
	jobtype = /datum/job/civilian

	uniform = /obj/item/clothing/under/color/random
	shoes = /obj/item/clothing/shoes/black



/datum/job/civilian/prisoner
	title = JOB_TITLE_PRISONER
	flag = JOB_FLAG_PRISONER
	department_flag = JOBCAT_SUPPORT
	total_positions = 4
	spawn_positions = 4
	supervisors = "the warden"
	department_head = list(JOB_TITLE_WARDEN)
	selection_color = "#e6e6e6"
	access = list()
	minimal_access = list()
	alt_titles = list("Arrestee")
	outfit = /datum/outfit/job/assistant/prisoner
	insurance_type = INSURANCE_TYPE_NONE
	salary = 0
	min_start_money = 10
	max_start_money = 50

/datum/outfit/job/assistant/prisoner
	name = "Заключенный"
	allow_loadout = FALSE
	jobtype = /datum/job/civilian/prisoner
	id = /obj/item/card/id/prisoner/random
	head = /obj/item/clothing/head/prison
	uniform = /obj/item/clothing/under/prison
	shoes = /obj/item/clothing/shoes/prison
	l_ear = /obj/item/radio/headset/prisoner
	pda = null
	box = null
	allow_backbag_choice = FALSE
	back = null

/datum/job/civilian/team1
	title = JOB_TITLE_TEAM1
	flag = JOB_FLAG_TEAM1
	department_flag = JOBCAT_SUPPORT
	total_positions = 20
	spawn_positions = 20
	supervisors = "the head of personnel"
	department_head = list(JOB_TITLE_HOP)
	selection_color = "#09ff00"
	access = list(ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MAINT_TUNNELS)
	alt_titles = list()
	outfit = /datum/outfit/job/assistant/team1
	insurance_type = INSURANCE_TYPE_NONE
	salary = SALARY_FOR_NISHEBROD
	min_start_money = 0
	max_start_money = 10

/datum/outfit/job/assistant/team1
	name = "Команда 1"
	jobtype = /datum/job/civilian/team1

	uniform = /obj/item/clothing/under/color/green
	shoes = /obj/item/clothing/shoes/green

/datum/job/civilian/team2
	title = JOB_TITLE_TEAM2
	flag = JOB_FLAG_TEAM2
	department_flag = JOBCAT_SUPPORT
	total_positions = 20
	spawn_positions = 20
	supervisors = "the head of personnel"
	department_head = list(JOB_TITLE_HOP)
	selection_color = "#1100ff"
	access = list(ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MAINT_TUNNELS)
	alt_titles = list()
	outfit = /datum/outfit/job/assistant/team2
	insurance_type = INSURANCE_TYPE_NONE
	salary = SALARY_FOR_NISHEBROD
	min_start_money = 0
	max_start_money = 10

/datum/outfit/job/assistant/team2
	name = "Команда 2"
	jobtype = /datum/job/civilian/team2

	uniform = /obj/item/clothing/under/color/blue
	shoes = /obj/item/clothing/shoes/blue

/datum/job/civilian/team3
	title = JOB_TITLE_TEAM3
	flag = JOB_FLAG_TEAM3
	department_flag = JOBCAT_SUPPORT
	total_positions = 20
	spawn_positions = 20
	supervisors = "the head of personnel"
	department_head = list(JOB_TITLE_HOP)
	selection_color = "#ff0000"
	access = list(ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MAINT_TUNNELS)
	alt_titles = list()
	outfit = /datum/outfit/job/assistant/team2
	insurance_type = INSURANCE_TYPE_NONE
	salary = SALARY_FOR_NISHEBROD
	min_start_money = 0
	max_start_money = 10

/datum/outfit/job/assistant/team3
	name = "Команда 3"
	jobtype = /datum/job/civilian/team3

	uniform = /obj/item/clothing/under/color/red
	shoes = /obj/item/clothing/shoes/red

/datum/job/civilian/prisoner/after_spawn(mob/living/carbon/human/human)
	. = ..()
	var/datum/data/record/record = find_security_record("name", human.real_name)
	if(!record) //record not exists, create record with temporary identifier
		record = CreateSecurityRecord(human.real_name, -1)
	record.fields["criminal"] = SEC_RECORD_STATUS_INCARCERATED
	var/crimes = generate_prisoner_role_crimes()
	human.mind.store_memory("Меня посадили за: [crimes]")
	record.fields["comments"] += "Заключён в пермабриг за: [crimes]"

/datum/job/civilian/prisoner/proc/generate_prisoner_role_crimes()
	var/list/major_crimes = list("400", "402", "407")
	. = pick(major_crimes)
	var/count = rand(1, 3)
	var/list/minor_crimes = list("101", "303", "204", "205", "306", "308")
	for(var/i = 0; i < count; i++)
		var/crime = pick(minor_crimes)
		minor_crimes -= crime
		. += ", [crime]"
	. += "."

#undef SALARY_FOR_NISHEBROD
