/obj/item/ammo_casing/proc/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from)
	distro += variance
	var/targloc = get_turf(target)
	ready_proj(target, user, quiet, zone_override, fired_from)
	if(pellets == 1)
		if(distro) //We have to spread a pixel-precision bullet. throw_proj was called before so angles should exist by now...
			if(randomspread)
				spread = round((rand() - 0.5) * distro)
			else //Smart spread
				spread = round(1 - 0.5) * distro
		if(!throw_proj(target, targloc, user, params, spread))
			return FALSE
	else
		if(isnull(BB))
			return FALSE
		AddComponent(/datum/component/pellet_cloud, projectile_type, pellets)
		SEND_SIGNAL(src, COMSIG_PELLET_CLOUD_INIT, target, user, fired_from, randomspread, spread, zone_override, params, distro)

	if(click_cooldown_override)
		if((click_cooldown_override > CLICK_CD_RAPID) && HAS_TRAIT(user, TRAIT_GUNFIGHTER))
			user.changeNext_move(max(CLICK_CD_RAPID, round(click_cooldown_override/2)))
		else
			user.changeNext_move(click_cooldown_override)
	else
		if(HAS_TRAIT(user, TRAIT_GUNFIGHTER))
			user.changeNext_move(CLICK_CD_RAPID)
		else
			user.changeNext_move(CLICK_CD_RANGE)
	user.newtonian_move(get_dir(target, user))
	update_icon()
	return TRUE

/obj/item/ammo_casing/proc/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	if (!BB)
		return
	BB.original = target
	BB.firer = user
	BB.fired_from = fired_from
	if (zone_override)
		BB.def_zone = zone_override
	else
		BB.def_zone = user.zone_selected
	BB.suppressed = quiet

	if(isgun(fired_from))
		var/obj/item/gun/G = fired_from
		BB.damage *= G.projectile_damage_multiplier

	if(reagents && BB.reagents)
		reagents.trans_to(BB, reagents.total_volume, transfered_by = user) //For chemical darts/bullets
		qdel(reagents)

/obj/item/ammo_casing/proc/throw_proj(atom/target, turf/targloc, mob/living/user, params, spread)
	var/turf/curloc = get_turf(user)
	if (!istype(targloc) || !istype(curloc) || !BB)
		return FALSE

	var/firing_dir
	if(BB.firer)
		firing_dir = BB.firer.dir
	if(!BB.suppressed && firing_effect_type)
		var/witness_count
		for(var/mob/living/carbon/human/npc/NEPIC in viewers(7, usr))
			if(NEPIC && NEPIC.stat != DEAD)
				witness_count++
			if(witness_count > 1)
				for(var/obj/item/police_radio/P in GLOB.police_radios)
					P.announce_crime("shooting", get_turf(user))
				for(var/obj/machinery/p25transceiver/police/radio in GLOB.p25_tranceivers)
					if(radio.p25_network == "police")
						radio.announce_crime("shooting", get_turf(src))
						break
		var/atom/A = new firing_effect_type(get_turf(src), firing_dir)
		var/atom/movable/shit = new(A.loc)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.remove_overlay(FIRING_EFFECT_LAYER)
			var/mutable_appearance/firing_overlay = mutable_appearance('icons/wod13/icons.dmi', "firing", -PROTEAN_LAYER)
			H.overlays_standing[FIRING_EFFECT_LAYER] = firing_overlay
			H.apply_overlay(FIRING_EFFECT_LAYER)
			shit.set_light(3, 2, "#ffedbb")
//			animate(firing_overlay, alpha = 0, time = 2)
			spawn(2)
				H.remove_overlay(FIRING_EFFECT_LAYER)
				qdel(shit)

	var/direct_target
	if(targloc == curloc)
		if(target) //if the target is right on our location we'll skip the travelling code in the proj's fire()
			direct_target = target
	if(!direct_target)
		BB.preparePixelProjectile(target, user, params, spread)
	BB.fire(null, direct_target)
	BB = null
	return TRUE

/obj/item/ammo_casing/proc/spread(turf/target, turf/current, distro)
	var/dx = abs(target.x - current.x)
	var/dy = abs(target.y - current.y)
	return locate(target.x + round(gaussian(0, distro) * (dy+2)/8, 1), target.y + round(gaussian(0, distro) * (dx+2)/8, 1), target.z)
