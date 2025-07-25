
/datum/job/vamp/vtr/hierophant
	title = "Hierophant"
	department_head = list("Seneschal")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Beast Within"
	selection_color = "#19571e"

	outfit = /datum/outfit/job/hierophant

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	exp_type = EXP_TYPE_CRONE
	exp_type_department = EXP_TYPE_CRONE
	
	endorsement_required = TRUE
	
	my_contact_is_important = TRUE
	display_order = JOB_DISPLAY_ORDER_HIEROPHANT
	v_duty = "You are the Hierophant, defacto leader of the Circle of the Crone. Carry out blood rituals. Protect your territory, the Queen Lilith. Ensure that the Circle's interests are respected by the Seneschal."
	minimum_vamp_rank = VAMP_RANK_ANCILLAE
	allowed_species = list("Vampire")
	experience_addition = 20
	known_contacts = list("Keeper of Elysium", "Sheriff", "Page")

/datum/outfit/job/hierophant
	name = "Hierophant"
	jobtype = /datum/job/vamp/vtr/hierophant

	id = /obj/item/card/id/hierophant
	shoes = /obj/item/clothing/shoes/vampire
	uniform = /obj/item/clothing/under/vampire/emo
	l_pocket = /obj/item/vamp/phone/hierophant
	backpack_contents = list(/obj/item/vamp/creditcard/head=1, /obj/item/vamp/keys/hierophant=1)

/datum/outfit/job/hierophant/pre_equip(mob/living/carbon/human/H)
	..()

/obj/effect/landmark/start/vtr/hierophant
	name = "Hierophant"
	icon_state = "Dealer"
