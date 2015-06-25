sfx = {};

function sfx.castSound ()
	if missle_type=="flamearrow" then
		utils.playSfx(media.sounds["spell_flamearrow"], 1);
	elseif missle_type=="coldbeam" then
		utils.playSfx(media.sounds["spell_coldbeam"], 1);
	elseif missle_type=="acidburst" then
		utils.playSfx(media.sounds["spell_acidburst"], 1);
	elseif missle_type=="poisonedspit" then
		utils.playSfx(media.sounds["spell_poisonedspit"], 1);
	elseif missle_type=="rockblast" then
		utils.playSfx(media.sounds["spell_rockblast"], 1);
	elseif missle_type=="toxiccloud" then
		utils.playSfx(media.sounds["spell_toxiccloud"], 1);
	elseif missle_type=="dragonbreath" then
		utils.playSfx(media.sounds["spell_dragonbreath"], 1);
	elseif missle_type=="wizardeye" then
		utils.playSfx(media.sounds["spell_wizardeye"], 1);	
	elseif missle_type=="protfromfire" then
		utils.playSfx(media.sounds["spell_rezfrom"], 1);
	elseif missle_type=="protfromfire" then
		utils.playSfx(media.sounds["spell_rezfrom"], 1);
	elseif missle_type=="protfromcold" then
		utils.playSfx(media.sounds["spell_rezfrom"], 1);
	elseif missle_type=="protfromstatic" then
		utils.playSfx(media.sounds["spell_rezfrom"], 1);
	elseif missle_type=="protfromacid" then
		utils.playSfx(media.sounds["spell_rezfrom"], 1);
	elseif missle_type=="protfrompoison" then
		utils.playSfx(media.sounds["spell_rezof"], 1);
	elseif missle_type=="protfromdisease" then
		utils.playSfx(media.sounds["spell_rezof"], 1);
	elseif missle_type=="protofmind" then
		utils.playSfx(media.sounds["spell_rezof"], 1);
	elseif missle_type=="protofspirit" then
		utils.playSfx(media.sounds["spell_rezof"], 1);
	elseif missle_type=="stoneskin" then
		utils.playSfx(media.sounds["spell_stoneskin"], 1);
	elseif missle_type=="torchlight" then
		utils.playSfx(media.sounds["spell_torchlight"], 1);
	end;
end;


function sfx.boomSound ()
	if missle_type == "bottle" then
		utils.playSfx(media.sounds["glass_broken"],1);
	end;
	if missle_type=="flamearrow" then
		utils.playSfx(media.sounds["spell_flamearrowimpact"], 1);
	elseif missle_type=="coldbeam" then
		utils.playSfx(media.sounds["spell_coldbeamimpact"], 1);
	elseif missle_type=="acidburst" then
		utils.playSfx(media.sounds["spell_acidburstimpact"], 1);
	elseif missle_type=="shockring" then
		utils.playSfx(media.sounds["spell_shocker"], 1);
	elseif missle_type=="heal" then
		utils.playSfx(media.sounds["spell_heal"], 1);
	elseif missle_type=="fireball" then
		utils.playSfx(media.sounds["spell_fireballimpact"], 1);
	elseif missle_type=="firebomb" or missle_subtype=="firebomb" then
		utils.playSfx(media.sounds["spell_fireballimpact"], 1);
	elseif missle_type=="iceball" then
		utils.playSfx(media.sounds["spell_iceballimpact"], 1);
	elseif missle_type=="rockblast" then
		utils.playSfx(media.sounds["spell_rockimpact"], 1);
	elseif missle_type=="deathblossom" then
		utils.playSfx(media.sounds["spell_rockimpact"], 1);
	elseif missle_type=="comete" then
		utils.playSfx(media.sounds["spell_rockimpact"], 1);
	elseif missle_type=="toxiccloud" then
		utils.playSfx(media.sounds["spell_toxicimpact"], 1);
	elseif missle_type=="meteorshower" then
		utils.playSfx(media.sounds["spell_meteorsimpact"], 1);
	elseif missle_type=="starburst" then
		utils.playSfx(media.sounds["spell_meteorsimpact"], 1);
	elseif missle_type=="armageddon" then
		utils.playSfx(media.sounds["spell_meteorsimpact"], 1);
	elseif missle_type=="powerheal" then
		utils.playSfx(media.sounds["spell_heal"], 1);
	elseif missle_type=="fireball" then
		utils.playSfx(media.sounds["spell_fireballimpact"], 1);
	end;
end;

function sfx.soundsOfInv(soi_switcher,sorttarget)
	local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false);
	if soi_switcher=="take" then
		if inventory_ttx[list[holding_smth].ttxid].class == "sword" then
			utils.playSfx(media.sounds["inv_sword_take"],1);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "axe" then
			utils.playSfx(media.sounds["inv_axe_take"],1);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "flagpole" then
			utils.playSfx(media.sounds["inv_spear_take"],1);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "staff" then
			utils.playSfx(media.sounds["inv_staff_take"],1);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "crushing" then
			utils.playSfx(media.sounds["inv_wood_take"],1);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "shield" then
			utils.playSfx(media.sounds["inv_wood_take"],1);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "boots" then
			utils.playSfx(media.sounds["inv_boots_take"],1);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "boottle" then
			utils.playSfx(media.sounds["inv_bottle_take"],1);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "belt" then
			utils.playSfx(media.sounds["inv_belt_take"],1);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "helm" then
			utils.playSfx(media.sounds["inv_helmet_take"],1);
		elseif inventory_ttx[list[holding_smth].ttxid].subclass == "ring" then
			utils.playSfx(media.sounds["inv_ring_take"],1);
		end
	elseif soi_switcher == "put" then
		if holding_class == "sword" then
			utils.playSfx(media.sounds["inv_sword_put"],1);
		elseif holding_class == "axe" then
			utils.playSfx(media.sounds["inv_axe_put"],1);
		elseif holding_class == "flagpole" then
			utils.playSfx(media.sounds["inv_spear_put"],1);
		elseif holding_class == "staff" then
			utils.playSfx(media.sounds["inv_staff_put"],1);
		elseif holding_class == "crushing" then
			utils.playSfx(media.sounds["inv_wood_put"],1);
		elseif holding_class == "shield" then
			utils.playSfx(media.sounds["inv_wood_put"],1);
		elseif holding_class == "boots" then
			utils.playSfx(media.sounds["inv_boots_put"],1);
		elseif holding_class == "boottle" then
			utils.playSfx(media.sounds["inv_bottle_put"],1);
		elseif holding_class == "belt" then
			utils.playSfx(media.sounds["inv_belt_put"],1);
		elseif holding_class == "helm" then
			utils.playSfx(media.sounds["inv_helmet_put"],1);
		elseif holding_subclass == "ring" then
			utils.playSfx(media.sounds["inv_ring_put"],1);
		end;
	end;
end;
