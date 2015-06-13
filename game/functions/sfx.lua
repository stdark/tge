sfx = {};

function sfx.castSound ()
	if missle_type=="flamearrow" then
		love.audio.play(media.sounds["spell_flamearrow"], 0);
	elseif missle_type=="coldbeam" then
		love.audio.play(media.sounds["spell_coldbeam"], 0);
	elseif missle_type=="acidburst" then
		love.audio.play(media.sounds["spell_acidburst"], 0);
	elseif missle_type=="poisonedspit" then
		love.audio.play(media.sounds["spell_poisonedspit"], 0);
	elseif missle_type=="rockblast" then
		love.audio.play(media.sounds["spell_rockblast"], 0);
	elseif missle_type=="toxiccloud" then
		love.audio.play(media.sounds["spell_toxiccloud"], 0);
	elseif missle_type=="dragonbreath" then
		love.audio.play(media.sounds["spell_dragonbreath"], 0);
	elseif missle_type=="wizardeye" then
		love.audio.play(media.sounds["spell_wizardeye"], 0);	
	elseif missle_type=="protfromfire" then
		love.audio.play(media.sounds["spell_rezfrom"], 0);
	elseif missle_type=="protfromfire" then
		love.audio.play(media.sounds["spell_rezfrom"], 0);
	elseif missle_type=="protfromcold" then
		love.audio.play(media.sounds["spell_rezfrom"], 0);
	elseif missle_type=="protfromstatic" then
		love.audio.play(media.sounds["spell_rezfrom"], 0);
	elseif missle_type=="protfromacid" then
		love.audio.play(media.sounds["spell_rezfrom"], 0);
	elseif missle_type=="protfrompoison" then
		love.audio.play(media.sounds["spell_rezof"], 0);
	elseif missle_type=="protfromdisease" then
		love.audio.play(media.sounds["spell_rezof"], 0);
	elseif missle_type=="protofmind" then
		love.audio.play(media.sounds["spell_rezof"], 0);
	elseif missle_type=="protofspirit" then
		love.audio.play(media.sounds["spell_rezof"], 0);
	elseif missle_type=="stoneskin" then
		love.audio.play(media.sounds["spell_stoneskin"], 0);
	elseif missle_type=="torchlight" then
		love.audio.play(media.sounds["spell_torchlight"], 0);
	end;
end;


function sfx.boomSound ()
	if missle_type == "bottle" then
		love.audio.play(media.sounds["glass_broken"],0);
	end;
	if missle_type=="flamearrow" then
		love.audio.play(media.sounds["spell_flamearrowimpact"], 0);
	elseif missle_type=="coldbeam" then
		love.audio.play(media.sounds["spell_coldbeamimpact"], 0);
	elseif missle_type=="acidburst" then
		love.audio.play(media.sounds["spell_acidburstimpact"], 0);
	elseif missle_type=="shockring" then
		love.audio.play(media.sounds["spell_shocker"], 0);
	elseif missle_type=="heal" then
		love.audio.play(media.sounds["spell_heal"], 0);
	elseif missle_type=="fireball" then
		love.audio.play(media.sounds["spell_fireballimpact"], 0);
	elseif missle_type=="firebomb" or missle_subtype=="firebomb" then
		love.audio.play(media.sounds["spell_fireballimpact"], 0);
	elseif missle_type=="iceball" then
		love.audio.play(media.sounds["spell_iceballimpact"], 0);
	elseif missle_type=="rockblast" then
		love.audio.play(media.sounds["spell_rockimpact"], 0);
	elseif missle_type=="deathblossom" then
		love.audio.play(media.sounds["spell_rockimpact"], 0);
	elseif missle_type=="comete" then
		love.audio.play(media.sounds["spell_rockimpact"], 0);
	elseif missle_type=="toxiccloud" then
		love.audio.play(media.sounds["spell_toxicimpact"], 0);
	elseif missle_type=="meteorshower" then
		love.audio.play(media.sounds["spell_meteorsimpact"], 0);
	elseif missle_type=="starburst" then
		love.audio.play(media.sounds["spell_meteorsimpact"], 0);
	elseif missle_type=="armageddon" then
		love.audio.play(media.sounds["spell_meteorsimpact"], 0);
	elseif missle_type=="powerheal" then
		love.audio.play(media.sounds["spell_heal"], 0);
	elseif missle_type=="fireball" then
		love.audio.play(media.sounds["spell_fireballimpact"], 0);
	end;
end;

function sfx.soundsOfInv(soi_switcher,sorttarget)
	local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false);
	if soi_switcher=="take" then
		if inventory_ttx[list[holding_smth].ttxid].class == "sword" then
			love.audio.play(media.sounds["inv_sword_take"],0);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "axe" then
			love.audio.play(media.sounds["inv_axe_take"],0);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "flagpole" then
			love.audio.play(media.sounds["inv_spear_take"],0);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "staff" then
			love.audio.play(media.sounds["inv_staff_take"],0);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "crushing" then
			love.audio.play(media.sounds["inv_wood_take"],0);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "shield" then
			love.audio.play(media.sounds["inv_wood_take"],0);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "boots" then
			love.audio.play(media.sounds["inv_boots_take"],0);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "boottle" then
			love.audio.play(media.sounds["inv_bottle_take"],0);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "belt" then
			love.audio.play(media.sounds["inv_belt_take"],0);
		elseif inventory_ttx[list[holding_smth].ttxid].class == "helm" then
			love.audio.play(media.sounds["inv_helmet_take"],0);
		elseif inventory_ttx[list[holding_smth].ttxid].subclass == "ring" then
			love.audio.play(media.sounds["inv_ring_take"],0);
		end
	elseif soi_switcher == "put" then
		if holding_class == "sword" then
			love.audio.play(media.sounds["inv_sword_put"],0);
		elseif holding_class == "axe" then
			love.audio.play(media.sounds["inv_axe_put"],0);
		elseif holding_class == "flagpole" then
			love.audio.play(media.sounds["inv_spear_put"],0);
		elseif holding_class == "staff" then
			love.audio.play(media.sounds["inv_staff_put"],0);
		elseif holding_class == "crushing" then
			love.audio.play(media.sounds["inv_wood_put"],0);
		elseif holding_class == "shield" then
			love.audio.play(media.sounds["inv_wood_put"],0);
		elseif holding_class == "boots" then
			love.audio.play(media.sounds["inv_boots_put"],0);
		elseif holding_class == "boottle" then
			love.audio.play(media.sounds["inv_bottle_put"],0);
		elseif holding_class == "belt" then
			love.audio.play(media.sounds["inv_belt_put"],0);
		elseif holding_class == "helm" then
			love.audio.play(media.sounds["inv_helmet_put"],0);
		elseif holding_subclass == "ring" then
			love.audio.play(media.sounds["inv_ring_put"],0);
		end;
	end;
end;
