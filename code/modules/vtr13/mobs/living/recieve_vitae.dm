/mob/living/proc/recieve_vitae(mob/living/carbon/human/giver)
	adjustBloodPool(1)
	adjustBruteLoss(-10)
	blood_volume = min(BLOOD_VOLUME_NORMAL, blood_volume+50)
	adjustFireLoss(-5)
