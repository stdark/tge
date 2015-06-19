damage = {};
 --stone and freeze (ac + resistanses + crits);
function damage.mobCanMove(mob)
	if mob.status == 1 and mob.paralyze == 0 and mob.stun == 0 and mob.sleep == 0 then
		return true;
	end;
	return false;
end;

function damage.mobCanBeDamaged(mob)
	if mob.freeze == 0 and mob.stone == 0 then
		return true;
	end;
	return false;
end;

function damage.mobIsAlive(mob)
	if mob.status >= 0 then
		return true;
	end;
	return false;
end;

function damage.mobIsActive(mob)
	if damage.mobCanMove(mob) and damage.mobCanBeDamaged(mob) then
		return true;
	end;
	return false;
end;

function damage.physicalRes (index,damage,hitzone) --FIXME weapon passives and hitzones
	if not hitzone then
		hitzone = chars_mobs_npcs[index]["hitzones"][global.hex][math.random(1,#chars_mobs_npcs[index]["hitzones"][global.hex])];	
	end;
	local bodyArmorPieces = {armor=0,belt=0,cloak=0};
	local newDamage = 0;
	local rollShield = math.random(1,100);
	local rollArmor = math.random(1,100);
	local protection = helpers.countProtection (index);
	local ac = math.ceil(protection[1]/2);
	local dt = math.ceil(protection[2]/2);
	local dr = math.ceil(protection[3]/2);
	local dmg2armor = 0;
	if chars_mobs_npcs[index].shield > 0 and rollShield <= 50 then
		--power shield anim
		return 0;	
	end;
	if ac > rollArmor then
		newDamage = damage - dt;
		if chars_mobs_npcs[index].dr > 0 then
			newDamage = math.ceil(newDamage*chars_mobs_npcs[index].dr/100);
		elseif chars_mobs_npcs[index].dr == 0 then
			newDamage = damage;
		end;
		if chars_mobs_npcs[index].shieldoflight > 0 then
			return 0;
		end;
	else
		newDamage = damage;
	end;
	return newDamage;
end;

function damage.statRes (index,damage,stat,inverse)
	local newDamage = 0;
	local rollStat = math.random(1,100);
	if stat > 0 and not inverse and chars_mobs_npcs[index].stat > rollStat then
		newDamage = math.ceil(damage*chars_mobs_npcs[index].stat/100);
	elseif stat > 0 and stat < 0 and inverse and chars_mobs_npcs[index].stat < rollStat then
		newDamage = math.ceil(damage*chars_mobs_npcs[index].stat/(100 - stat));
	elseif stat == 0 and not inverse then
		newDamage = damage;
	elseif stat >= 100 and inverse then
		newDamage = damage;
	end;
	if chars_mobs_npcs[index].shieldoflight > 0 then
		return 0;
	end;
	return newDamage;
end;


function damage.magicalRes (index,damage,element)
	local newDamage = 0;
	if chars_mobs_npcs[index]["rez" .. element] > 0 then
		newDamage = math.ceil(damage*chars_mobs_npcs[index]["rez" .. element]/100);
	elseif chars_mobs_npcs[index]["rez" .. element] == 0 then
		newDamage = damage;
	end;
	if chars_mobs_npcs[index].shieldoflight > 0 then
		return 0;
	end;
	return newDamage;
end;

function damage.applyDoT (index,lvl,num,c1,c2,c3,c4,element,luck)
	local luckfactorCaster = 1;
	local luckfactorTarget = 1;
	if luck then
		luckfactorCaster = chars_mobs_npcs[current_mob].luk;
		luckfactorTarget = chars_mobs_npcs[index].luk;
	end;
	if lvl*num*luckfactorCaster > chars_mobs_npcs[index]["rez" .. element]*luckfactorTarget then
		local dot_power = math.ceil((c1*num + c2)*chars_mobs_npcs[index]["rez" .. element]/100);
		local dot_dur = math.ceil((c3*lvl+c4)*chars_mobs_npcs[index]["rez" .. element]/100);
		return dot_power, dot_dur;
	else
		return 0, 0;
	end;
end;

function damage.applyCondition (index,lvl,num,condition,element,stat,skill,coff,luck)
	local roll = math.random(1,100);
	local luckfactorCaster = 1;
	local luckfactorTarget = 1;
	local condition = 0;
	if luck then
		luckfactorCaster = chars_mobs_npcs[current_mob].luk;
		luckfactorTarget = chars_mobs_npcs[index].luk;
	end;
	if element and num*lvl*luckfactorCaster > chars_mobs_npcs[index]["rez" .. element]*luckfactorTarget then
		condition =  math.ceil(coff*num);
	elseif stat and lvl*num > chars_mobs_npcs[current_mob][stat] then
		condition = math.ceil(num*coff);
	elseif skill and lvl*num > chars_mobs_npcs[current_mob].skill then
		condition = math.ceil(num*coff);
	else
		condition = math.ceil(num*coff);
	end;
	if condition == "bleeding" and not helpers.traumaNature(index) then
		condition = 0;
	end;
	if condition > 0 then
		chars_mobs_npcs[index][condition] = condtion; --FIXME
	end;
	return condition;
end;

function damage.applyConditionTwoFactors (index,lvl,num,condition,element,stat,skill,coff,luck)
	local roll = math.random(1,100);
	local luckfactorCaster = 1;
	local luckfactorTarget = 1;
	local condition_power = condition .. "_power";
	local condition_dur = condition .. "_dur";
	if luck then
		luckfactorCaster = chars_mobs_npcs[current_mob].luk;
		luckfactorTarget = chars_mobs_npcs[index].luk;
	end;
	if element and num*lvl*luckfactorCaster > chars_mobs_npcs[index]["rez" .. element]*luckfactorTarget then
		condition_power = math.ceil(num*coff);
		condition_dur = math.ceil(lvl*coff);
	elseif stat and lvl*num > chars_mobs_npcs[current_mob].stat then
		condition_power = math.ceil(num*coff);
		condition_dur = math.ceil(lvl*coff);
	elseif skill and lvl*num > chars_mobs_npcs[current_mob].skill then
		condition_power = math.ceil(num*coff);
		condition_dur = math.ceil(lvl*coff);
	else
		condition_power = math.ceil(num*coff);
		condition_dur = math.ceil(lvl*coff);
	end;
	return condition_power,condition_dur;
end;

function damage.mobDamaged(index,damager,damage) -- FIXME: add var of damageHP real only for painreflection
	chars_mobs_npcs[index].stun = 0;
	chars_mobs_npcs[index].sleep = 0;
	chars_mobs_npcs[index].charm = 0;
	chars_mobs_npcs[index].invisibility = 0;
	if chars_mobs_npcs[index].control == "ai" and chars_mobs_npcs[index].ai == "away" and chars_mobs_npcs[index].hp <= chars_mobs_npcs[index].hp_max*0.1 then
		chars_mobs_npcs[index].ai = "agr";
	end;
	if chars_mobs_npcs[index].control == "ai" and ((chars_mobs_npcs[index].ai == "away" and chars_mobs_npcs[index].hp + math.ceil(chars_mobs_npcs[index].moral/5) > chars_mobs_npcs[index].hp_max*0.1) or chars_mobs_npcs[index].ai == "stay" or chars_mobs_npcs[index].ai == "cruiser" or chars_mobs_npcs[index].ai == "called") then
		chars_mobs_npcs[index].ai = chars_mobs_npcs[index].dangerai;
	end;
	if chars_mobs_npcs[index].aggro < damage then
		chars_mobs_npcs[index].aggressor = chars_mobs_npcs[damager].id;
		chars_mobs_npcs[index].aggro = damage;
	end;
	local tmpfrac = chars_mobs_npcs[index].fraction;
	local tmpfrac2 = chars_mobs_npcs[damager].fraction;
	local fraccond2 = loadstring("return " .. "fractions." .. tmpfrac .. "." .. tmpfrac2)();
	if fraccond2 > 100 then
		fraccond2=fraccond2 - 1;
	end;
	if chars_mobs_npcs[index].painreflection > 0 then
		local selfdamage = damage.magicalRes (damager,newDamage,"darkness")
		damage.HPminus(damager,selfdamage,true);
	end;
	helpers.recalcBattleStats(index);
	helpers.protectionOff (index);
end;

function damage.mobsAlive()
	local counter = 0;
	for i=1, #chars_mobs_npcs do
		if chars_mobs_npcs[i].status >=0 and chars_mobs_npcs[i].ai ~= "building" then
			counter = counter + 1;
		end;
	end;
	return counter;
end;

function damage.singledamage () -- missle_type, missle_drive,current_mob,victim (all globals)
	global.hex = 1; --FIXME
	utils.printDebug("damaging called");
	-- This function calculates damage and buffs/debuffs/dots from ranged weapon and direct single-target spells.
	helpers.clearMissleLight ();
	helpers.clearBoomLight ();
	draw.shaderIrradiation ();
	dodge=0;
	block=0;
	hands = 0;
	parry=0;
	local agressor_name = helpers.mobName(current_mob);
	local victim_name = helpers.mobName(victim);
	local iflucky = 0; -- success or miss
	local chance_to_hit = 0; -- skill
	local dice = 0; -- weapon
	local random_chance = 0; -- rnd
	local lvl = {};
	local num = {};
	local crit = 0;
	local array_of_chances = {};
	local chance_to_hit = 0;
	local chance_to_crit = 0;
	local chance_to_dodge = 0;
	local chance_to_hands = 0;
	local chance_to_block = 0;
	local chance_to_parry = 0;
	local chance_to_handblock = 0;
	local random_chance = 0;
	local block_dir_coff = 0;
	local hitzone = 0;
	local AC = 0;
	local DT = 0;
	local DR = 0;
	local recovery = 0;
	local tmp = 0;
	local dmghp = 0;
	local dmgsp = 0;
	local dmgrt = 0;
	local dmgst = 0;
	local add_dmghp = 0;
	local alldmg = 0;
	local debuff = 0;
	local debuffdur = 1;
	local debuffdur2 = 1;
	local dotdur = 0;
	local dotpower = 0;
	local total_fate = 0;
	local hitResult = 0;
	local fulldamage = 0;
	local incoming_physical_dmg = 0;
	local delta_spd = 0;
	local bodyArmorPieces = {armor=0,belt=0,cloak=0};
	local selfadd_hp = 0;
	local selfadd_sp = 0;
	local selfadd_st = 0;
	local selfadd_rt = 0;
	local selfrem_hp = 0;
	local selfrem_sp = 0;
	local selfrem_st = 0;
	local selfrem_rt = 0;
	helpers.recalcBattleStats (current_mob);
	if helpers.missleIsAweapon () and missle_type ~= "bottle" then
		love.audio.play(media.sounds.arrow_impact,0); -- FIXME: different sounds for different missles
		local wpEffect,wpChance = damage.weaponPassives(current_mob,victim,missle_type);
		local attacked_from = helpers.attackDirection(current_mob,victim);
		if helpers.mobCanDefendHimself (victim) and chars_mobs_npcs[victim].immobilize == 0 then
			delta_spd = chars_mobs_npcs[current_mob].spd + chars_mobs_npcs[victim].spd;
		else
			delta_spd = 100;
		end;
		chance_to_hit = math.ceil(50*helpers.sizeModifer(victim))+chars_mobs_npcs[current_mob].atkr+(chars_mobs_npcs[current_mob].spd-chars_mobs_npcs[victim].spd)+chars_mobs_npcs[current_mob].acu + delta_spd;
		if shot_line[#shot_line-1] and not helpers.passCheck(shot_line[#shot_line-1][1],shot_line[#shot_line-1][2]) 
		and missle_type ~= "parabolicshot"
		then
			helpers.addToActionLog( lognames.actions.targetpartlyhided);
			chance_to_hit = math.ceil(chance_to_hit/2);
		end;
		--tricks
		if missle_type == "carefulaimnig" then
			chance_to_hit =	chance_to_hit*chars_mobs_npcs[current_mob].lvl_crossbow;
		elseif missle_type == "eagleseye" then
			chance_to_hit =	chance_to_hit*chars_mobs_npcs[current_mob].lvl_bow;
		elseif missle_type == "maximumstreght" then
			chance_to_hit =	math.ceil(chance_to_hit/2);
		end;
		--/tricks
		if helpers.likeAStar () then
			chance_to_hit = math.ceil(chance_to_hit*(chars_mobs_npcs[current_mob].leye + chars_mobs_npcs[current_mob].reye)/2);
		elseif helpers.likeABow () then
			if chars_mobs_npcs[current_mob].reye == 0 then
				chance_to_hit = 0;
			end;
		elseif helpers.likeAGun () then
			if chars_mobs_npcs[current_mob].reye == 0 and chars_mobs_npcs[current_mob].leye == 1 then
				chance_to_hit = math.ceil(0.25*chance_to_hit);
			end;
		end;
		utils.randommore ();
		random_chance = math.random(1,100)-50;
		total_fate = chars_mobs_npcs[current_mob].fateself + chars_mobs_npcs[victim].fate - (chars_mobs_npcs[victim].fateself + chars_mobs_npcs[current_mob].fate);
		chance_to_hit = chance_to_hit + random_chance + total_fate;
		chars_mobs_npcs[current_mob].fate = 0;
		chars_mobs_npcs[current_mob].fateself = 0;
		chars_mobs_npcs[victim].fate = 0;
		chars_mobs_npcs[victim].fateself = 0;
		
		chance_to_crit = math.ceil((chars_mobs_npcs[current_mob].luk-chars_mobs_npcs[victim].luk)/10); --FIX add weapon mastery
		if attacked_from == "back" then
			chance_to_crit = chance_to_crit*2;
		end;
		if shot_line[#shot_line-1] and not helpers.passCheck(shot_line[#shot_line-1][1],shot_line[#shot_line-1][2]) and missle_type ~= "parabolicshot" then --partly covered
			chance_to_crit = 0;
		end;
		if chance_to_hit <= 0 then
			iflucky = 0;
			--love.audio.play(media.sounds.sword_miss,0);
			helpers.addToActionLog( agressor_name .. lognames.actions.atk[chars_mobs_npcs[current_mob].gender] .. victim_name .. lognames.actions.miss[chars_mobs_npcs[current_mob].gender]);
		else
			iflucky = 1;
			utils.randommore ();
			hitzone = chars_mobs_npcs[victim]["hitzones"][global.hex][math.random(1,#chars_mobs_npcs[victim]["hitzones"][global.hex])];
--tricks
			if missle_type == "blinding" and helpers.mobHasHitZoneAtHex(victim,global.hex,"head") then
				hitzone = "head";
			elseif missle_type == "nailing" and helpers.randomLimb(victim,global.hex,true) then
				hitzone = helpers.randomLimb(victim,global.hex);
			elseif missle_type == "carefulaiming" or missle_type == "eagleseye" or missle_type == "finishing" then
				if helpers.mobHasHitZoneAtHex(victim,global.hex,"head") then
					hitzone = "head";
				elseif helpers.mobHasHitZoneAtHex(victim,global.hex,"body") then
					hitzone = "body";
				end;
			end;
--/tricks
			utils.randommore ();
			if chars_mobs_npcs[current_mob].curse == 0 and chars_mobs_npcs[current_mob].bless == 0 then
				dice = math.random(chars_mobs_npcs[current_mob].brng);
			elseif chars_mobs_npcs[current_mob].curse > 0 and chars_mobs_npcs[current_mob].bless == 0 then
				dice = 1;
			elseif chars_mobs_npcs[current_mob].curse == 0 and chars_mobs_npcs[current_mob].bless == 0 then
				dice = chars_mobs_npcs[current_mob].brng;
			elseif chars_mobs_npcs[current_mob].curse > 0 and chars_mobs_npcs[current_mob].bless > 0 then
				dice = math.random(chars_mobs_npcs[current_mob].brng);
			end;
			incoming_physical_dmg = (dice*chars_mobs_npcs[current_mob].arng+chars_mobs_npcs[current_mob].crng+chars_mobs_npcs[current_mob].acu);
			--trick
			if missle_type == "blinding" and not helpers.mobHasHitZoneAtHex(victim,global.hex,"head") then
				incoming_physical_dmg = incoming_physical_dmg*2;
			elseif missle_type == "maximumstreght" then
				incoming_physical_dmg = incoming_physical_dmg + incoming_physical_dmg*chars_mobs_npcs[current_mob].mgt/100;
			end;
			--/trick
		-- DODGE
			if chars_mobs_npcs[victim].num_dodging > 0 and helpers.mobCanDefendHimself (victim) and missle_type ~= "hiddenstrike" then
				chance_to_dodge = chars_mobs_npcs[victim].num_dodging*chars_mobs_npcs[victim].lvl_dodging;
				if chars_mobs_npcs[victim].lvl_dodging >= 4 and chars_mobs_npcs[victim]["equipment"].cloak > 0 
				and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].cloak].q > 0 then
					chance_to_dodge = chance_to_dodge + inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].dg;
				end;
				if chars_mobs_npcs[victim].lvl_dodging < 3
				and chars_mobs_npcs[victim]["equipment"].armor > 0
				and  (inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].subclass == "leather"
				or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].subclass == "fur"
				or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].subclass == "skin"
				) then
					chance_to_dodge = 0;
				elseif chars_mobs_npcs[victim].lvl_dodging < 4
				and chars_mobs_npcs[victim]["equipment"].armor > 0
				and  inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].subclass == "chain" 
				then
					chance_to_dodge = 0;
				elseif chars_mobs_npcs[victim].lvl_dodging < 5
				and chars_mobs_npcs[victim]["equipment"].armor > 0
				and  inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].subclass == "plate" 
				then
					chance_to_dodge = 0;
				end;
				local dodge_dir_coff=0
				if attacked_from=="front" then
					dodge_dir_coff=1;
				elseif attacked_from=="lh" then
					dodge_dir_coff=1;
				elseif attacked_from=="rh" then
					dodge_dir_coff=1;
				elseif attacked_from=="lback" then
					dodge_dir_coff=0.75;
				elseif attacked_from=="rback" then
					dodge_dir_coff=0.75;
				elseif attacked_from=="back" then
					dodge_dir_coff=0.5;
				end;
				chance_to_dodge = chance_to_dodge*dodge_dir_coff;
				if chars_mobs_npcs[victim].protectionmode == "block" then
					chance_to_dodge = 0;
				end;
				if chars_mobs_npcs[victim].protectionmode == "hands" then
					chance_to_dodge = 0;
				end;
				if chars_mobs_npcs[victim].protectionmode == "dodge" then
					chance_to_dodge = chance_to_dodge*2;
				end;
				if chars_mobs_npcs[victim].protectionmode == "parry" then
					chance_to_dodge = 0;
				end;
			end;
			if chance_to_dodge > 0 then
				for i=1,chance_to_dodge do
					array_of_chances[i] = "dodge";	
				end;
			end;
		--/DODGE
		--HANDBLOCK
			if attacked_from=="front" then
				hands_dir_coff=1;
			elseif attacked_from=="lh" then
				hands_dir_coff=1;
			elseif attacked_from=="rh" then
				hands_dir_coff=1;
			elseif attacked_from=="lback" then
				hands_dir_coff=0;
			elseif attacked_from=="rback" then
				hands_dir_coff=0;
			elseif attacked_from=="back" then
				hands_dir_coff=0;
			end;
			if helpers.mobHasHandblock (victim) and helpers.mobCanDefendHimself (victim)
			and (chars_mobs_npcs[victim].rh > 0 or chars_mobs_npcs[victim].lh > 0)
			and chars_mobs_npcs[victim].lvl_unarmed >= 3
			and missle_type == "throwing"
			and helpers.mobCanDefendHimself(victim) then
				chance_to_hands = math.ceil(chars_mobs_npcs[victim].lvl_unarmed*chars_mobs_npcs[victim].num_unarmed*hands_dir_coff/2);	
			end;	
			if helpers.mobHasHandblock (victim) and helpers.mobCanDefendHimself (victim)
			and chars_mobs_npcs[victim].lvl_unarmed >= 4
			and missle_type == "arrow"
			and helpers.mobCanDefendHimself(victim) then
				chance_to_hands = math.ceil(chars_mobs_npcs[victim].lvl_unarmed*chars_mobs_npcs[victim].num_unarmed*hands_dir_coff/2);	
			end;
			if helpers.mobHasHandblock (victim) and helpers.mobCanDefendHimself (victim)
			and chars_mobs_npcs[victim].lvl_unarmed >= 4
			and missle_type == "bolt"
			and helpers.mobCanDefendHimself(victim) then
				chance_to_hands = math.ceil(chars_mobs_npcs[victim].lvl_unarmed*chars_mobs_npcs[victim].num_unarmed*hands_dir_coff/2);	
			end;
			if missle_type == "bullet" or missle_type == "ray" then
				chance_to_hands = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "block" then
				chance_to_hands = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "hands" then
				chance_to_hands = chance_to_hands*2;
			end;
			if chars_mobs_npcs[victim].protectionmode == "dodge" then
				chance_to_hands = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "parry" then
				chance_to_hands = 0;
			end;
			if chance_to_hands > 0 then
				for i=#array_of_chances+1,chance_to_hands do
					array_of_chances[i] = "hands";	
				end;
			end;
		--/HANDBLOCK
		--BLOCK
			if chars_mobs_npcs[victim]["equipment"].lh > 0 and helpers.mobCanDefendHimself (victim)
			and chars_mobs_npcs[victim].lh > 0
			and inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].class == "shield"
			and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q > 0
			and missle_type ~= "hiddenstrike"
			and helpers.mobCanDefendHimself (victim) then
				local block_dir_coff=0
				if attacked_from=="front" then
					block_dir_coff=1;
				elseif attacked_from=="lh" then
					block_dir_coff=0.5;
				elseif attacked_from=="rh" then
					block_dir_coff=0.35;
				elseif attacked_from=="lback" then
					block_dir_coff=0.25;
				elseif attacked_from=="rback" then
					block_dir_coff=0;
				elseif attacked_from=="back" then
					block_dir_coff=0;
				end;
				chance_to_block = block_dir_coff*(math.ceil(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].ac+chars_mobs_npcs[victim].num_shield*chars_mobs_npcs[victim].lvl_shield)-chars_mobs_npcs[current_mob].atkr);
				utils.randommore ();
				random_chance = math.random(1,100);
				if chars_mobs_npcs[victim].protectionmode == "block" then
					chance_to_block = chance_to_block*2;
				end;
				if chars_mobs_npcs[victim].protectionmode == "hands" then
					chance_to_block = 0;
				end
				if chars_mobs_npcs[victim].protectionmode == "dodge" then
					chance_to_block = 0;
				end;
				if chars_mobs_npcs[victim].protectionmode == "parry" then
					chance_to_block = 0;
				end;
				if chance_to_block > 0 then
					for i=#array_of_chances+1,chance_to_block do
						array_of_chances[i] = "block";	
					end;
				end;
			end;
		--/BLOCK
		--PARRY
			if helpers.mobCanDefendHimself (victim) -- RIGHT HAND
			and missle_type ~= "ray"
			and chars_mobs_npcs[victim].rh > 0
			and chars_mobs_npcs[victim]["equipment"].rh > 0 and chars_mobs_npcs[victim]["equipment"].rh > 0 
			and (inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "sword"
			or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "dagger"
			or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "staff")
			and (missle_type == "throwing" or missle_type == "arrow" or missle_type == "bolt")
			and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].q > 0
			and (attacked_from == "front" or attacked_from == "rh" or attacked_from == "lh")
			and helpers.mobCanDefendHimself (victim) and missle_type ~= "hiddenstrike" then
				if inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "sword" then
					if chars_mobs_npcs[victim].lvl_sword >= 3 then
						chance_to_parry = math.ceil(chars_mobs_npcs[victim].num_sword/2);
					end;
				end;
				if inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "dagger" then
					if chars_mobs_npcs[victim].lvl_dagger >= 4 then
						chance_to_parry = math.ceil(chars_mobs_npcs[victim].num_dagger/2);
					end;
				end;
				if inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "staff" then
					if chars_mobs_npcs[victim].lvl_staff >= 2 then
						chance_to_parry = math.ceil(chars_mobs_npcs[victim].num_staff/2);
					end;
				end;
				if chars_mobs_npcs[victim].protectionmode == "block" then
					chance_to_parry = 0;
				end;
				if chars_mobs_npcs[victim].protectionmode == "hands" then
					chance_to_parry = 0;
				end;
				if chars_mobs_npcs[victim].protectionmode == "dodge" then
					chance_to_parry = 0;
				end;
				if chars_mobs_npcs[victim].protectionmode == "parry" then
					chance_to_parry = chance_to_parry*2;
				end;
			end;
			if chance_to_parry > 0 then
				for i=#array_of_chances+1,chance_to_parry do
					array_of_chances[i] = "parrr";	
				end;
			end;
			if  helpers.mobCanDefendHimself (victim) -- LEFT HAND
			and missle_type ~= "ray" and missle_type ~= "hiddenstrike"
			and chars_mobs_npcs[victim].lh > 0
			and chars_mobs_npcs[victim]["equipment"].lh > 0 and (inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].class == "sword" or
			inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].class == "dagger")
			and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q > 0
			and (attacked_from == "front" or attacked_from == "rh" or attacked_from == "lh")
			and helpers.mobCanDefendHimself (index) then
				if chars_mobs_npcs[victim].lvl_sword > 1 then
					chance_to_parry = math.ceil(chars_mobs_npcs[victim].num_sword/2);
				end;
				if inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "dagger" then
					if chars_mobs_npcs[victim].lvl_dagger >= 4 then
						chance_to_parry =  math.ceil(chars_mobs_npcs[victim].num_dagger/2);
					end;
				end;
			end;
			if chance_to_parry > 0 then
				for i=#array_of_chances+1,chance_to_parry do
					array_of_chances[i] = "parrl";	
				end;
			end;
		--/PARRY
		--AC
			local add_ac,add_dt,add_dr = damage.calcArmorStats(victim,hitzone,attacked_from);
			AC = AC + add_ac + chars_mobs_npcs[victim].ac;
			DT = DT + add_dt + chars_mobs_npcs[victim].dt;
			DR = DR + add_dr + chars_mobs_npcs[victim].dr;
			if wpEffect == "through" and wpChance > math.random(1,100) then
				AC = 0;
				DT = 0;
				DR = 0;
				helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.armorpenetrated[chars_mobs_npcs[current_mob].gender]);
			end;
			if AC > 0 then
				for i=#array_of_chances+1,AC do
					if missle_type ~= "shieldpenetration" or missle_type ~= "hiddenstrike" then
						array_of_chances[i] = "ac";
					end;
				end;
			end
			--/AC
			
			--add rings, amulets, artifacts, modifers of armor pieces and melee weapon,
			
			if #array_of_chances > chance_to_hit then
				fulldamage = 0;
				hitResult = array_of_chances[chance_to_hit];
				if hitResult == "dodge" then
					--critical dodge
					dodge = 1;
					helpers.addToActionLog( victim_name .. lognames.actions.dodge[chars_mobs_npcs[current_mob].gender]);
				elseif hitResult == "hands" then
					--hammerhands and self-damage		
					helpers.addToActionLog( victim_name .. lognames.actions.block[chars_mobs_npcs[current_mob].gender]);
					hands = 1;
					local incoming_physical_dmg_before_armor = incoming_physical_dmg;
					incoming_physical_dmg = incoming_physical_dmg - DT;
					incoming_physical_dmg = incoming_physical_dmg*DR/100;
					if incoming_physical_dmg < 0 then
						incoming_physical_dmg = 0;
					end;
					local deltaDMG = incoming_physical_dmg_before_armor - incoming_physical_dmg;
					if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].h == 0 and inventory[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].ttxid].material < deltaDMG then
						chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].q - deltaDMG;
						if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].q == 0 then
							--gloves destroyed
						end;
					end;
					
				elseif hitResult == "block" then
					love.audio.play(media.sounds.block,0);		
					helpers.addToActionLog( victim_name .. lognames.actions.block[chars_mobs_npcs[current_mob].gender]);
					if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].h == 0 then
						chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q - math.max(0,math.abs(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].material-incoming_physical_dmg));
						if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q == 0 then
							--shield destroyed
						end;
					end;
					block = 1;
				elseif hitResult == "parrr" then
					if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].h == 0 then
						chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].q - math.max(0,math.abs(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].material-incoming_physical_dmg));
						if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].q == 0 then
							--weapon destroyed
						end;
					end;
					helpers.addToActionLog( victim_name .. lognames.actions.parry[chars_mobs_npcs[current_mob].gender]);
					parry = 1;
				elseif hitResult == "parrl" then
					chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q - math.max(0,math.abs(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].material-incoming_physical_dmg));
					chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].q = chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].q - math.max(0,math.abs(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].material-incoming_physical_dmg));
					if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].h == 0 then
						if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q == 0 then
							--weapon destroyed
						end;
					end;
					helpers.addToActionLog( victim_name .. lognames.actions.parry[chars_mobs_npcs[current_mob].gender]);
					parry = 1;
				elseif hitResult == "ac" then
					local incoming_physical_dmg_before_armor = incoming_physical_dmg;
					incoming_physical_dmg = incoming_physical_dmg - DT;
					incoming_physical_dmg = incoming_physical_dmg*DR/100;
					if incoming_physical_dmg < 0 then
						incoming_physical_dmg = 0;
					end;
					local deltaDMG = incoming_physical_dmg_before_armor - incoming_physical_dmg;
					damage.armorDestroying (hitzone,attacked_from,deltaDMG);
					--
				end;
			else
				fulldamage = 1;
			end;
			if hitResult == "ac" or fulldamage == 1 then
				--CRIT
				utils.randommore ();
				random_chance = math.random(1,100);
				if chance_to_crit >= random_chance then
					crit = 2;
					--love.audio.play(media.sounds.sword_crit,0);
				elseif chance_to_crit < random_chance then
					crit = 1;
					--love.audio.play(media.sounds.sword_impact,0);
				end;
				--/CRIT
				incoming_physical_dmg = incoming_physical_dmg*crit;
				incoming_physical_dmg = math.ceil(math.max(0,incoming_physical_dmg - chars_mobs_npcs[victim].ironshirt_power)*(100-chars_mobs_npcs[victim].stoneskin_power)/100);
				local mob_genocide = 1;
	
				--weapon modifers
				if chars_mobs_npcs[current_mob]["equipment"]["ranged"] > 0 and chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"]["ranged"]].w > 0 then			
					if chars_mobs_npcs[current_mob]["equipment"]["ranged"] > 0 then
							--damage
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ranged"]].w].damage) do
							local dmg = damage.magicalRes (victim,value[value],value[element]);
							if key == "hp" then
								add_dmghp = dmg;
								if value[vampirism] then
									selfadd_hp = selfaddhp + math.ceil(dmg*value[vampirism_power]);
								end;
							elseif key == "sp" then 
								dmgsp = dmg;
								if value[vampirism] then
									selfadd_sp = selfaddsp + math.ceil(dmg*value[vampirism_power]);
								end;
							elseif key == "st" then
								dmgst = dmg;
								if value[vampirism] then
									selfadd_st = selfaddst + math.ceil(dmg*value[vampirism_power]);
								end;
							elseif key == "rt" then 
								dmgrt = dmg;
								if value[vampirism] then
									selfadd_rt = selfaddrt + math.ceil(dmg*value[vampirism_power]);
								end;
							end;
						end;
						--/damage
						--dots
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ranged"]].w].dots) do
							local power,duration = damage.applyDoT (victim,value[lvl],value[num],1,0,1,0,value[element],true);
							if power > 0 and suration > 0 then
								local power_str = tostring(key) .. "_power";
								local duration_str = tostring(key) .. "_dur";
								chars_mobs_npcs[victim][power_str] = math.max(power,chars_mobs_npcs[victim][power_str]);
								chars_mobs_npcs[victim][duration_str] = math.max(duration,chars_mobs_npcs[victim][duration_str]);
							end;
						end;
						--/dots
						--conditions
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ranged"]].w].conditions) do
							local power = damage.applyCondition (victim,value[lvl],value[num],value[element],false,false,1,true);
							if power > 0 then
								chars_mobs_npcs[victim][tostring(key)] = math.max(power,chars_mobs_npcs[victim][tostring(key)]);
							end;
						end;
						--/conditions
						--twofactorconditions
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ranged"]].w].twofactorconditions) do
							local power,duration = damage.applyDoT (victim,value[lvl],value[num],tostring(key),value[element],false,false,1,true);
							if power > 0 and suration > 0 then
								local power_str = tostring(key) .. "_power";
								local duration_str = tostring(key) .. "_dur";
								chars_mobs_npcs[victim][power_str] = math.max(power,chars_mobs_npcs[victim][power_str]);
								chars_mobs_npcs[victim][duration_str] = math.max(duration,chars_mobs_npcs[victim][duration_str]);
							end;
						end;
						--/twofactorconditions
						--addself
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ranged"]].w].addself) do
							local dmg = damage.magicalRes (victim,value[value],value[element]);
							if key == "hp" then
								selfadd_hp = selfaddhp + value;
							elseif key == "sp" then 
								selfadd_sp = selfaddsp + value;
							elseif key == "st" then
								selfadd_st = selfaddst + value;
							elseif key == "rt" then 
								selfadd_rt = selfaddrt + value;
							end;
						end;
						--/selfadd
						--selfrem
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ranged"]].w].remself) do
							local dmg = damage.magicalRes (victim,value[value],value[element]);
							if key == "hp" then
								selfrem_hp = selfremhp + value;
							elseif key == "sp" then 
								selfrem_sp = selfremsp + value;
							elseif key == "st" then
								selfrem_st = selfremst + value;
							elseif key == "rt" then 
								selfrem_rt = selfremrt + value;
							end;
						end;	
						--/selfrem
						--genocide
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ranged"]].w].genocide) do
							if key == mobs_stats[chars_mobs_npcs[victim].class]
							or key == mobs_stats[chars_mobs_npcs[victim].race]
							or key == mobs_stats[chars_mobs_npcs[victim].size]
							or key == mobs_stats[chars_mobs_npcs[victim].nature]
							or key == mobs_stats[chars_mobs_npcs[victim].gender]
							then
								mob_genocide = value;
								break;
							end;
						end;
						--/genocide
					end;	
				end;
				--/weapon modifers
				
				--ammo modifers
				if chars_mobs_npcs[current_mob]["equipment"]["ammo"] > 0 and chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"]["ammo"]].w > 0 then			
					if chars_mobs_npcs[current_mob]["equipment"]["ammo"] > 0 then
							--damage
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ammo"]].w].damage) do
							local dmg = damage.magicalRes (victim,value[value],value[element]);
							if key == "hp" then
								add_dmghp = dmg;
								if value[vampirism] then
									selfadd_hp = selfaddhp + math.ceil(dmg*value[vampirism_power]);
								end;
							elseif key == "sp" then 
								dmgsp = dmg;
								if value[vampirism] then
									selfadd_sp = selfaddsp + math.ceil(dmg*value[vampirism_power]);
								end;
							elseif key == "st" then
								dmgst = dmg;
								if value[vampirism] then
									selfadd_st = selfaddst + math.ceil(dmg*value[vampirism_power]);
								end;
							elseif key == "rt" then 
								dmgrt = dmg;
								if value[vampirism] then
									selfadd_rt = selfaddrt + math.ceil(dmg*value[vampirism_power]);
								end;
							end;
						end;
						--/damage
						--dots
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ammo"]].w].dots) do
							local power,duration = damage.applyDoT (victim,value[lvl],value[num],1,0,1,0,value[element],true);
							if power > 0 and suration > 0 then
								local power_str = tostring(key) .. "_power";
								local duration_str = tostring(key) .. "_dur";
								chars_mobs_npcs[victim][power_str] = math.max(power,chars_mobs_npcs[victim][power_str]);
								chars_mobs_npcs[victim][duration_str] = math.max(duration,chars_mobs_npcs[victim][duration_str]);
							end;
						end;
						--/dots
						--conditions
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ammo"]].w].conditions) do
							local power = damage.applyCondition (victim,value[lvl],value[num],value[element],false,false,1,true);
							if power > 0 then
								chars_mobs_npcs[victim][tostring(key)] = math.max(power,chars_mobs_npcs[victim][tostring(key)]);
							end;
						end;
						--/conditions
						--twofactorconditions
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ammo"]].w].twofactorconditions) do
							local power,duration = damage.applyDoT (victim,value[lvl],value[num],tostring(key),value[element],false,false,1,true);
							if power > 0 and suration > 0 then
								local power_str = tostring(key) .. "_power";
								local duration_str = tostring(key) .. "_dur";
								chars_mobs_npcs[victim][power_str] = math.max(power,chars_mobs_npcs[victim][power_str]);
								chars_mobs_npcs[victim][duration_str] = math.max(duration,chars_mobs_npcs[victim][duration_str]);
							end;
						end;
						--/twofactorconditions
						--addself
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ammo"]].w].addself) do
							local dmg = damage.magicalRes (victim,value[value],value[element]);
							if key == "hp" then
								selfadd_hp = selfaddhp + value;
							elseif key == "sp" then 
								selfadd_sp = selfaddsp + value;
							elseif key == "st" then
								selfadd_st = selfaddst + value;
							elseif key == "rt" then 
								selfadd_rt = selfaddrt + value;
							end;
						end;
						--/selfadd
						--selfrem
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ammo"]].w].remself) do
							local dmg = damage.magicalRes (victim,value[value],value[element]);
							if key == "hp" then
								selfrem_hp = selfremhp + value;
							elseif key == "sp" then 
								selfrem_sp = selfremsp + value;
							elseif key == "st" then
								selfrem_st = selfremst + value;
							elseif key == "rt" then 
								selfrem_rt = selfremrt + value;
							end;
						end;	
						--/selfrem
						--genocide
						for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"]["ammo"]].w].genocide) do
							if key == mobs_stats[chars_mobs_npcs[victim].class]
							or key == mobs_stats[chars_mobs_npcs[victim].race]
							or key == mobs_stats[chars_mobs_npcs[victim].size]
							or key == mobs_stats[chars_mobs_npcs[victim].nature]
							or key == mobs_stats[chars_mobs_npcs[victim].gender]
							then
								mob_genocide = value;
								break;
							end;
						end;
						--/genocide
					end;	
				end;
				--/ammo modifers
	
				dmghp = incoming_physical_dmg*mob_genocide + add_dmghp;
				
				if wpChance > math.random(1,100) then
					damage.weaponpEffect(victim,hitzone,wpEffect); -- weapon passives
				end;
			end;

			if missle_type == "blinding" then
				chars_mobs_npcs[victim].reye = 0;
				chars_mobs_npcs[victim].leye = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
			elseif missle_type == "nailing" then
				chars_mobs_npcs[victim].immobilize = chars_mobs_npcs[current_mob].lvl_crossbow;
			elseif missle_type == "shockingsparkle" then
				local _rtdmg = chars_mobs_npcs[current_mob].num_thrownig;
				damage.RTminus(victim,_rtdmg,true);
			elseif missle_type == "finishing" and chars_mpbs_npcs[victm].hp/chars_mpbs_npcs[victm].hp_max*100 <= 5 then
				damage.HPminus(victm,chars_mpbs_npcs[victm].hp,true);
			end;
			
			--dmghp = damage.physicalRes (victim,dice*chars_mobs_npcs[current_mob].arng+chars_mobs_npcs[current_mob].crng+chars_mobs_npcs[current_mob].acu/5) + add_dmghp; -- FIXME! Oil!
			random_chance = math.random(100);
			if missle_type == "bolt" or missle_type == "throwing" or missle_type == "bottle" or missle_type == "bullet" or missle_type == "battery" then --wasting ammo
				chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].q = chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].q - 1;
			elseif helpers.missleIsAweapon () then
				local _ammo = 0;
				if tricks.tricks_tips[missle_type].ammo and tricks.tricks_tips[missle_type].ammo > 0 then
					_ammo = tricks.tricks_tips[missle_type].ammo;
				end;
				chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].q = chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].q - _ammo;
			end;
			if chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].q == 0 then
				table.remove(chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo])
				chars_mobs_npcs[current_mob]["equipment"].ammo = 0;
			end;
			local penalty = 0;
			if helpers.aliveNature(current_mob) then
				penalty = 4*helpers.visualConditions(current_mob,chars_mobs_npcs[victim].x,chars_mobs_npcs[victim].y);
				if helpers.blindedWithLight (current_mob,chars_mobs_npcs[victim].x,chars_mobs_npcs[victim].y) then
					penalty = penalty*2;
				end;
			end
			if random_chance + chars_mobs_npcs[current_mob].fateself > (100 - chance_to_hit) + chars_mobs_npcs[current_mob].fate + penalty then
				iflucky = 1;
			else
				iflucky = 0;
			end;
			chars_mobs_npcs[current_mob].fate = 0;
			chars_mobs_npcs[current_mob].fateself = 0;
		end;
	else
		chance_to_hit = 100;
		iflucky = 1;
	end;
	if iflucky == 1 then
		if helpers.missleIsAweapon () and missle_type ~= "bottle" then
			if chars_mobs_npcs[victim].hp > 0 then
				damage.HPminus(victim,dmghp,true);
			end;
			if chars_mobs_npcs[victim].sp > 0 and dmgsp > 0 then
				damage.SPminus(victim,dmgsp);
			end;
			if chars_mobs_npcs[victim].st > 0 and dmgst > 0 then
				damage.STminus(victim,dmgst,false);
			end;
			if chars_mobs_npcs[victim].rt > 0 and dmgrt > 0 then
				damage.RTminus(victim,dmgrt,false);
			end;
			local mode,lvl,num,effect,element,stat,skill,coff,luck = damage.classPassives(current_mob);
			if mode and mode == "ranged" then
				if algorythm == "2factors" then
					damage.ApplyConditionTwoFactors(current_mob,lvl,num,effect,element,stat,skill,coff,luck);
				elseif algorythm == "1factor" then
					damage.ApplyCondition(current_mob,lvl,num,effect,element,stat,skill,coff,luck);
				elseif algorythm == "simple" then
					if effect == "hp" then
						damage.HPminus(victim,num,true);
					elseif effect == "sp" then
						damage.SPminus(victim,num,true);
					elseif effect == "st" then
						damage.STminus(victim,num,true);
					elseif effect == "rt" then
						damage.RTminus(victim,num,true);
					end;
				elseif algorythm == "vampirism" then
					if effect == "hp" then
						damage.HPplus(current_mob,num,true);
						damage.HPminus(victim,num,true);
					elseif effect == "sp" then
						damage.SPplus(current_mob,num,true);
						damage.SPminus(victim,num,true);
					elseif effect == "st" then
						damage.STplus(current_mob,num,true);
						damage.STminus(victim,num,true);
					elseif effect == "rt" then
						damage.RTplus(current_mob,num,true);
						damage.RTminus(victim,num,true);
					end;
				end;
			end;
		elseif missle_drive == "muscles" and  helpers.missleAtWarBook() then
			local _damage = chars_mobs_npcs[current_mob].lvl_unarmed*chars_mobs_npcs[current_mob].num_unarmed;
			local hitzone = false;
			local tempspellname = "tricks.tricks_tips." .. missle_type .. ".title";
			local spellname = loadstring("return " .. tempspellname)();
			if missle_type == "lotus" then
				if helpers.mobHasHitZoneAtHex(victim,global.hex,"head") then
					hitzone = "head";
				elseif helpers.mobHasHitZoneAtHex(victim,global.hex,"body") then
					hitzone = "body";
				end;
				dmghp = damage.physicalRes (victim,_damage,hitzone)
				damage.HPminus(victim,dmghp,true);
				helpers.addToActionLog( agressor_name .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. typo[1] .. spellname .. typo[2]);
			end;
		else -- magic
			local lvl,num = helpers.countBoomNumbers ();
			local tempspellname = "magic.spell_tips." .. missle_type .. ".title";
			local spellname = loadstring("return " .. tempspellname)();
			helpers.addToActionLog( agressor_name .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. typo[1] .. spellname .. typo[2]);
			if missle_type == "flamearrow" then
				dmghp = damage.magicalRes (victim,num[1]*damage.damageRandomizator(current_mob,1,8),"fire"); --FIXME nil
				damage.HPminus(victim,dmghp,true);
				helpers.addToActionLog( lognames.actions.dmg[chars_mobs_npcs[current_mob].gender] .. victim_name .. " " .. dmghp .. lognames.actions.metr .. lognames.actions.ofhp);
			end;
			if missle_type == "staticharge" then
				dmghp = damage.magicalRes (victim,num[1]*damage.damageRandomizator(current_mob,2,6),"static");
				tmp = damage.magicalRes (victim,num[1]*damage.damageRandomizator(current_mob,2,6),"static");
				dmgrt = -math.min(tmp,200-chars_mobs_npcs[victim].rt);
				damage.HPminus(victim,dmghp,true);
				damage.RTminus(victim,dmgrt,true);
			end;
			if missle_type == "poisonedspit" then
				dmghp = damage.magicalRes (victim,2+num[1]*damage.damageRandomizator(current_mob,1,2),"poison");
				local dot_power,dot_dur = damage.applyDoT (victim,lvl[1],num[1],1,0,1,0,"poison",false);
				if dot_power > 0 and dot_dur > 0 then
					chars_mobs_npcs[victim].poison_power = dot_power;
					chars_mobs_npcs[victim].poison_dur = dot_dur;
					helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.poisoned[chars_mobs_npcs[victim].gender]);
				end;
				chars_mobs_npcs[victim].poison_power = dotdur;
				chars_mobs_npcs[victim].poison_dur = dotpower;
				damage.HPminus(victim,dmghp,true);
				if dot_power > 0 and dot_dur > 0  then
					helpers.addToActionLog( victim_name .. lognames.actions.poisoned[chars_mobs_npcs[current_mob].gender]);
				end;
			end;
			if missle_type == "coldbeam" then
				dmghp = damage.magicalRes (victim,num[1]*damage.damageRandomizator(current_mob,1,7),"cold")
				dmgst = damage.magicalRes (victim,num[1]*damage.damageRandomizator(current_mob,1,7),"cold")
				damage.HPminus(victim,dmghp,true);
				damage.STminus(victim,dmgst,true);
			end;
			if missle_type == "harm" then
				if helpers.aliveNature(victim) then
					dmghp = (8 + math.random(1,2)*num[1]);
				else
					dmghp = 0;
				end;
				damage.HPminus(victim,dmghp,true);
			end;
			if missle_type == "spiritualarrow" then
				if helpers.soulNature(victim) then
					dmghp =  damage.magicalRes (victim,damage.damageRandomizator(current_mob,1,6)*num[1],"spirit");
				else
					dmghp = 0;
				end;
				damage.HPminus(victim,dmghp,true);
			end;
			if missle_type == "lightbolt" then
				dmghp =  damage.magicalRes (victim,damage.damageRandomizator(current_mob,1,4)*num[1],"light");
				if chars_mobs_npcs[victim].nature == "undead" then
					dmghp = v*2;
				end;
				damage.HPminus(victim,dmghp,true);
			end;
			if missle_type == "darkflame" then
				dmghp =  damage.magicalRes (victim,damage.damageRandomizator(current_mob,1,10)*num[1],"darkness")+damage.magicalRes (victim,damage.damageRandomizator(current_mob,1,10)*num[1],"fire");
				damage.HPminus(victim,dmghp,true);
			end;
			if missle_type == "mindblast" then
				dmghp =  damage.magicalRes (victim,math.random(1,3)*num[1],"mind");
				damage.HPminus(victim,dmghp,true);
			end;
			if missle_type == "deadlyswarm" then
				local _damage =  5 + damage.damageRandomizator(current_mob,1,3)*(num[1]+num[2]);
				dmghp = damage.physicalRes (victim,_damage,false)
				damage.HPminus(victim,dmghp,true);
				chars_mobs_npcs[victim].deadlyswarm = damage.applyCondition (victim,lvl[1],num[1],"deadlyswarm",false,"dex",false,1,false);
			end;
			if missle_type == "golemstopper" then
				if chars_mobs_npcs[victim].nature == "golem" then
					dmghp = damage.damageRandomizator(current_mob,1,10)*lvl[1]*num[2];
				else
					dmghp = 0;
				end;
				damage.HPminus(victim,dmghp,true);
			end;
			if missle_type == "destroyundead" then
				if chars_mobs_npcs[victim].nature == "undead" then
					dmghp =  damage.damageRandomizator(current_mob,1,10)*lvl[1]*num[1];
				else
					dmghp = 0;
				end;
				damage.HPminus(victim,dmghp,true);
			end;
			if missle_type == "windfist" and chars_mobs_npcs[victim].size ~= "giant" then
				chars_mobs_npcs[victim].stun = damage.applyCondition (victim,lvl[1],num[1],"stun",false,"enu",false,1,false);
				local dmgrt = math.max(chars_mobs_npcs[victim].rt,20 +  damage.damageRandomizator(current_mob,1,lvl[1]*num[1]));
				damage.RTminus(victim,dmgrt,true);
				local ring = boomareas.smallRingArea(chars_mobs_npcs[victim].x,chars_mobs_npcs[victim].y);
				if helpers.passCheck(ring[chars_mobs_npcs[current_mob].rot].x,ring[chars_mobs_npcs[current_mob].rot].y) then
					chars_mobs_npcs[victim].x = ring[chars_mobs_npcs[current_mob].rot].x;
					chars_mobs_npcs[victim].y = ring[chars_mobs_npcs[current_mob].rot].y;
				end;
				helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.stunned[chars_mobs_npcs[victim].gender]);
			end;
			if missle_type=="lightning" then
				dmghp = damage.magicalRes (victim,damage.damageRandomizator(current_mob,1,8)*num[1],"static");
				damage.HPminus(victim,dmghp,true);
				local tmp = math.ceil(dmghp/10);
				dmgrt = math.min(tmp,200-chars_mobs_npcs[victim].rt)
				damage.RTminus(victim,dmgrt,true);
			end;
			if missle_type=="sunray" then
				dmghp = 20 + damage.magicalRes (victim,damage.damageRandomizator(current_mob,1,20)*num[1],"light");
				damage.HPminus(victim,dmghp,true);
			end;
			if missle_type == "acidburst" then -- FIXME: not ac but debuff ac
				dmghp = damage.magicalRes (victim,damage.damageRandomizator(current_mob,2,18)*num[1],"acid");
				damage.HPminus(victim,dmghp,true);
				tmp = num[1];
				debuffpower = math.max(tmp,chars_mobs_npcs[victim].ac);
				debuffdur = lvl[1]*3
				chars_mobs_npcs[victim].ac_debuff_power = debuffpower;
				chars_mobs_npcs[victim].ac_debuff_dur = debuffdur;
				dotpower = num[1]; 
				dotdur = lvl[1]*3;
				chars_mobs_npcs[victim].acid_power = dotpower;
				chars_mobs_npcs[victim].acid_dur = dotdur;
				helpers.addToActionLog( victim_name .. lognames.actions.acided[chars_mobs_npcs[victim].gender]);
			end;
			
			-- continue from here
			if missle_type=="razors" and chars_mobs_npcs[victim].motion == "walking" then
				dmghp = math.ceil(damage.damageRandomizator(current_mob,1,5)*num[1]*(100-chars_mobs_npcs[victim].ac)/100)
				damage.HPminus(victim,dmghp,true);
				if helpers.traumaNature(victim) then
					dotpower = math.random(9);
					chars_mobs_npcs[victim].bleeding = math.max(chars_mobs_npcs[victim].bleeding,dotpower);
					helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[current_mob].gender]);
				end;
				--if chars_mobs_npcs[victim].legs > 0 then
					--trauma
				--end;
			end;
			
			if missle_type == "manaburn" then
				local debuff = math.min(chars_mobs_npcs[victim].sp,num[2]);
				damage.SPminus(victim,debuff,true);
				local _damage = damage.magicalRes (victim,debuff,"fire");
				damage.HPminus(victim,_damage,true);
				local damaged_mobs = {};
				table.insert(damaged_mobs,victim);
			end;
			
			if missle_type == "boilingblood" then
				local debuff = lvl[1]*num[1];
				local _damage = damage.magicalRes (victim,debuff,"fire");
				if _damage >= chars_mobs_npcs[victim].hp then
					chars_mobs_npcs[j].revenge_type = "acid";
					chars_mobs_npcs[j].revenge_power = lvl[2]*num[2];
				end; 
				damage.HPminus(victim,_damage,true);
				local damaged_mobs = {};
				table.insert(damaged_mobs,victim);
			end;
			
			if missle_type == "incineration" then
				chars_mobs_npcs[victim].cold_dur = 0;
				chars_mobs_npcs[victim].cold_power = 0;
				dotdmg = damage.damageRandomizator(current_mob,1,15)*(100-chars_mobs_npcs[victim].rezfire)/100;
				local dmglog = 0;
				local selfdmglog = 0;
				dmghp = chars_mobs_npcs[current_mob].num_fire*(100-chars_mobs_npcs[victim].rezfire)/100;
				chars_mobs_npcs[victim].hp= chars_mobs_npcs[victim].hp - dmghp;
				dmglog = dmglog + dmghp;
				while (chars_mobs_npcs[victim].hp >= 0 or chars_mobs_npcs[current_mob].sp >= 0) do
					chars_mobs_npcs[current_mob].sp = chars_mobs_npcs[current_mob].sp - 1;
					if chars_mobs_npcs[victim].shieldoflight == 0 then
						chars_mobs_npcs[victim].hp = chars_mobs_npcs[victim].hp - math.min(dotdmg,chars_mobs_npcs[victim].hp);
						dmglog = dmglog + dotdmg;
					end;
					if chars_mobs_npcs[victim].hp <= 0 or chars_mobs_npcs[current_mob].sp <= 0  or chars_mobs_npcs[current_mob].hp <= 0 then
						chars_mobs_npcs[victim].flame_power= chars_mobs_npcs[current_mob].num_fire*(100-chars_mobs_npcs[victim].rezfire)/100;
						chars_mobs_npcs[victim].flame_dur= chars_mobs_npcs[current_mob].lvl_fire;
						break;
					end;
				end;
				--damage.mobDamaged(victim,current_mob,dmglog);
				helpers.addToActionLog( lognames.actions.dmg[chars_mobs_npcs[current_mob].gender] .. victim_name .. " " .. dmglog .. lognames.actions.metr .. lognames.actions.ofhp);
				if selfdmglog > 0 then
					helpers.addToActionLog( lognames.actions.lost[chars_mobs_npcs[current_mob].gender] .. selfdmglog .. lognames.actions.metr .. lognames.actions.ofhp);	
				end;
				damage.HPcheck(victim);
			end;
					
			if missle_type == "implosion" then
				dmgst = math.min(chars_mobs_npcs[victim].st,lvl[1]*num[1]);
				dmgrt = math.min(chars_mobs_npcs[victim].rt,lvl[1]*num[1]);
				dmghp = math.min(chars_mobs_npcs[victim].hp,lvl[1]*num[1])+(chars_mobs_npcs[current_mob].lvl[1]*num[1]-dmgst);
				damage.STminus(victim,dmgst,true);
				damage.RTminus(victim,dmgrt,true);
				damage.HPminus(victim,dmghp,true);
			end;
			
			if missle_type=="massdistortion" then
				if chars_mobs_npcs[victim].shieldoflight == 0 then
					if chars_mobs_npcs[victim].person == "char" then
						dmghp = math.min(chars_mobs_npcs[victim].hp,math.ceil(0.25*chars_mobs_npcs[current_mob].hp_max)+2*num[1]);
					elseif  chars_mobs_npcs[victim].person == "mob" then
						mobmaxhp = chars_mobs_npcs[victim].hp_max;
						dmghp = math.min(chars_mobs_npcs[victim].hp,math.ceil(0.25*mobmaxhp.hp)+2*num[1]);
					end;
					damage.HPminus(victim,dmghp,true);
				end;
			end;
			
			if missle_type == "dehydratation" then
				if chars_mobs_npcs[victim].nature~="undead" 
				and chars_mobs_npcs[victim].nature~="golem" 
				and chars_mobs_npcs[victim].nature~="droid" and chars_mobs_npcs[victim].nature~="elemental" then
					local dmglog = 0;
					local dmglog2 = 0;
					dmghp = num[1];
					dmgst = damage.damageRandomizator(current_mob,1,12);
					chars_mobs_npcs[victim].hp = chars_mobs_npcs[victim].hp - dmghp;
					dmglog = dmglog + dmghp;
					dmglog2 = dmglog2 + dmgst;
					while (chars_mobs_npcs[victim].st >= 0 or chars_mobs_npcs[current_mob].sp >= 0) do
						chars_mobs_npcs[current_mob].sp = chars_mobs_npcs[current_mob].sp - 1;
						if chars_mobs_npcs[victim].shieldoflight == 0 then
							chars_mobs_npcs[victim].st = chars_mobs_npcs[victim].st - math.min(dmgst,chars_mobs_npcs[victim].st);
							dmghp = dmghp + dmgst;
						end;
						if chars_mobs_npcs[victim].st <= 0 or chars_mobs_npcs[current_mob].sp <= 0 or chars_mobs_npcs[current_mob].hp <= 0 then
							break;
						end;
					end;
					while (chars_mobs_npcs[victim].hp >= 0 or chars_mobs_npcs[current_mob].sp >= 0) do
						chars_mobs_npcs[current_mob].sp=  chars_mobs_npcs[current_mob].sp-1
						if chars_mobs_npcs[victim].shieldoflight == 0 then
							chars_mobs_npcs[victim].hp = chars_mobs_npcs[victim].hp-math.min(dotdmg,chars_mobs_npcs[victim].hp)
							dmglog = dmglog + dotdmg;
						end;
						if chars_mobs_npcs[victim].hp <= 0 or chars_mobs_npcs[current_mob].sp <= 0 or chars_mobs_npcs[current_mob].hp <= 0 then
							break;
						end;
					end;
				else
					dmghp = 0;
					dmglog = 0;
				end;
				--damage.mobDamaged(victim,current_mob,dmglog);
				helpers.addToActionLog( lognames.actions.dmg[chars_mobs_npcs[current_mob].gender] .. victim_name .. " " .. dmglog .. lognames.actions.metr .. lognames.actions.ofhp);
				helpers.addToActionLog( lognames.actions.dmg[chars_mobs_npcs[current_mob].gender] .. victim_name .. " " .. dmglog2 .. lognames.actions.metr .. lognames.actions.ofst);
				if selfdmglog > 0 then
					helpers.addToActionLog( lognames.actions.lost[chars_mobs_npcs[current_mob].gender] .. selfdmglog .. lognames.actions.metr .. lognames.actions.ofhp);	
				end;
				damage.HPcheck(victim);
			end;
		end;
	else
		helpers.addToActionLog( agressor_name .. lognames.actions.sht[chars_mobs_npcs[current_mob].gender] .. victim_name .. lognames.actions.miss[chars_mobs_npcs[current_mob].gender]);
	end;
	local alldmg = math.ceil(dmghp + dmgsp/2 + dmgst/4 + dmgrt/8);
	local _damager = current_mob;
	if missle_type == "hiddenstrike" and damage.falseDamager(chars_mobs.npcs[victim].x,chars_mobs.npcs[victim].y,3) then
		_damager = damage.falseDamager();
	end;
	
	damage.HPplus(current_mob,selfadd_hp,false);
	damage.SPplus(current_mob,selfadd_sp,false);
	damage.STplus(current_mob,selfadd_st,false);
	damage.RTplus(current_mob,selfadd_rt,false);
	
	damage.HPminus(current_mob,selfrem_hp,false);
	damage.SPminus(current_mob,selfrem_sp,false);
	damage.STminus(current_mob,selfrem_st,false);
	damage.RTminus(current_mob,selfrem_rt,false);

	damage.mobDamaged(victim,_damager,dmghp);
	local damaged_mobs = {};
	table.insert(damaged_mobs,victim);
	if chars_mobs_npcs[current_mob].person == "char" then
		exp_for_what(alldmg,current_mob);--recalc (all types of dmg/debuffs/etc)
	end;
	d_timer = 0;
	chars_mobs_npcs[current_mob].rage = 0;
end;

function damage.multidamage () --FIXME two hexes
	utils.printDebug("multidamage called");
	clear_elandscape();
	helpers.clearBoomLight ();
	draw.shaderIrradiation ();
	if missle_drive == "spellbook" then
		local tempspellname="magic.spell_tips." .. missle_type .. ".title";
		local spellname = loadstring("return " .. tempspellname)();
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. typo[1] .. spellname .. typo[2]);
	elseif missle_drive == "bottle" then
		local spellname = potionname;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.usepotion[chars_mobs_npcs[current_mob].gender] .. typo[1] .. spellname .. typo[2]);
	end;
	local damaged_mobs = {};
	local boomdur = 1;
	local boompower = 1;
	local lvl,num = helpers.countBoomNumbers ();
	
	if missle_type == "evilswarm" then
	end;
	
	if missle_type == "bitingfan" then
	end;
	
	if missle_type == "fireball" then
		boomareas.ashGround (boomx,boomy);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageHP = damage.magicalRes (j,damage.damageRandomizator(current_mob,1,6)*num[1] + lvl[1],"fire");
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				if missle_drive ~= "trap" then
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob);
				else
					damage.mobDamaged(j,global.trapindex,damageHP);
					exp_for_what(damageHP,global.trapindex);
				end;
				if lvl[1] >= 3 then
					local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"fire",false);
					if dot_power > 0 and dot_dur > 0 then
						chars_mobs_npcs[j].flame_power = dot_power;
						chars_mobs_npcs[j].flame_dur = dot_dur;
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.flamed[chars_mobs_npcs[j].gender]);
					end;
				end;
			end;
		end;
		if lvl[1] >= 4 then
			boomareas.fireGround(boomx,boomy,1,lvl[1],num[1]);
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				boomareas.ashGround (rings[h][i].x,rings[h][i].y);
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageHP = damage.magicalRes (j,damage.damageRandomizator(current_mob,1,6)*num[1],"fire");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						if missle_drive ~= "trap" then
							damage.mobDamaged(j,current_mob,damageHP);
							exp_for_what(damageHP,current_mob);
						else
							damage.mobDamaged(j,global.trapindex,damageHP);
							exp_for_what(damageHP,global.trapindex);
						end;
						if lvl[1] >= 3 then
							local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"fire",false);
							if dot_power > 0 and dot_dur > 0 then
								chars_mobs_npcs[j].flame_power = dot_power;
								chars_mobs_npcs[j].flame_dur = dot_dur;
								helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.flamed[chars_mobs_npcs[j].gender]);
							end;
						end;
					end;
				end;
				if lvl[1] >= 4 then
					boomareas.fireGround(rings[h][i].x,rings[h][i].y,2,lvl[1],num[1]);
				end;
			end;
		end;
	end;
	
	if missle_type == "dragonbreath" then
		local index = 1;
		local boompower = 3;
		boomareas.poisonAir(boomx,boomy,index,lvl[2],num[2]);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageHP = damage.magicalRes (j,damage.damageRandomizator(current_mob,1,25)*num[1] + lvl[1],"darkness");
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP);
				exp_for_what(damageHP,current_mob)
				local dot_power,dot_dur = damage.applyDoT (j,lvl[2],num[2],1,0,1,0,"poison",false);
				if dot_power > 0 and dot_dur > 0 then
					chars_mobs_npcs[j].flame_power = dot_power;
					chars_mobs_npcs[j].flame_dur = dot_dur;
					helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.poisoned[chars_mobs_npcs[j].gender]);
				end;
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageHP = damage.magicalRes (j,damage.damageRandomizator(current_mob,1,25)*num[1],"darkness");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob)
						local dot_power,dot_dur = damage.applyDoT (j,lvl[2],num[2],1,0,1,0,"poison",false);
							if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].flame_power = dot_power;
							chars_mobs_npcs[j].flame_dur = dot_dur;
							helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.poisoned[chars_mobs_npcs[j].gender]);
						end;
					end;
				end;
				if lvl[2] >= 4 then
					boomareas.poisonAir(rings[h][i].x,rings[h][i].y,index,lvl[2],num[2]);
				end;
			end;
		end;
	end;
	
	if missle_type == "firebelt" then
		local rings = boomareas.ringArea(boomx,boomy);
		for i=1,#rings[1] do
			for j=1,#chars_mobs_npcs do	
				if helpers.cursorAtCurrentMob (j,boomx,boomy) then
					local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"fire",false);
					if dot_power > 0 and dot_dur > 0 then
						chars_mobs_npcs[j].firebelt_power = dot_power;
						chars_mobs_npcs[j].firebelt_dur = dot_dur;
					end;
				end;
				if helpers.cursorAtCurrentMob (j,rings[h][1].x,rings[h][1].y) then
					local damageHP = damage.magicalRes (j,6+1*num[1],"fire");
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
					if lvl[1] >= 3 then
						local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"fire",false);
						if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].flame_power = dot_power;
							chars_mobs_npcs[j].flame_dur = dot_dur;
							helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.flamed[chars_mobs_npcs[j].gender]);
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "iceball" then
		local boompower = 2;
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageHP = damage.magicalRes (j,12 + damage.damageRandomizator(current_mob,1,3)*num[1] + lvl[1],"cold");
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP);
				exp_for_what(damageHP,current_mob)
				if chars_mobs_npcs[j].nature ~= "undead" and chars_mobs_npcs[j].nature ~= "golem" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "elemental" then
					local damageST = damage.magicalRes (j,12 + damage.damageRandomizator(current_mob,1,3)*num[1] + lvl[1],"cold");
					chars_mobs_npcs[j].st = chars_mobs_npcs[j].st - damageST;
					helpers.addToActionLog( lognames.actions.dmg[chars_mobs_npcs[current_mob].gender] .. helpers.mobName(j) .. " " .. damageST .. lognames.actions.metr .. " " .. lognames.actions.ofst);
					exp_for_what(math.ceil(damageST/2),current_mob)
				end;
				if lvl[1] >= 4 then
					local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"cold",false);
					if dot_power > 0 and dot_dur > 0 then
						chars_mobs_npcs[j].flame_power = dot_power;
						chars_mobs_npcs[j].flame_dur = dot_dur;
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.cooled[chars_mobs_npcs[j].gender]);
					end;
				end;
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageHP = damage.magicalRes (j,12 + damage.damageRandomizator(current_mob,1,2)*num[1],"cold");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob)
						if chars_mobs_npcs[j].nature ~= "undead" and chars_mobs_npcs[j].nature ~= "golem" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "elemental" then
							local damageST = damage.magicalRes (j,12 + damage.damageRandomizator(current_mob,1,2)*num[1],"cold");
							damage.STminus(j,damageST,true);
							exp_for_what(math.ceil(damageST/2),current_mob)
						end;
						if lvl[1] >= 4 then
							local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"cold",false);
							if dot_power > 0 and dot_dur > 0 then
								chars_mobs_npcs[j].flame_power = dot_power;
								chars_mobs_npcs[j].flame_dur = dot_dur;
								helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.cooled[chars_mobs_npcs[j].gender]);
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "toxiccloud" then
		local index = 1;
		local boompower = 1;
		boomareas.poisonAir(boomx,boomy,index,lvl[2],num[2]);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageHP = damage.magicalRes (j,25+damage.damageRandomizator(current_mob,1,10)*num[2] + num[1],"poison");
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP);
				exp_for_what(damageHP,current_mob)
				local dot_power,dot_dur = damage.applyDoT (j,lvl[2],num[2],1,0,1,0,"poison",false);
				if dot_power > 0 and dot_dur > 0 then
					chars_mobs_npcs[j].flame_power = dot_power;
					chars_mobs_npcs[j].flame_dur = dot_dur;
					helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.poisoned[chars_mobs_npcs[j].gender]);
				end;
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageHP = damage.magicalRes (j,25+damage.damageRandomizator(current_mob,1,10)*num[2],"poison");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob)
						local dot_power,dot_dur = damage.applyDoT (j,lvl[2],num[2],1,0,1,0,"poison",false);
							if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].flame_power = dot_power;
							chars_mobs_npcs[j].flame_dur = dot_dur;
							helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.poisoned[chars_mobs_npcs[j].gender]);
						end;
					end;
				end;
				if lvl[2] >= 4 then
					boomareas.poisonAir(rings[h][i].x,rings[h][i].y,index,lvl[2],num[2]);
				end;
			end;
		end;
	end;
	
	if missle_type == "rockblast" then
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageHP = damage.physicalRes (j,damage.damageRandomizator(current_mob,1,8)*num[1] + lvl[1]);
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP);
				exp_for_what(damageHP,current_mob)
				if lvl[1] >= 4 then
					local condition = damage.applyCondition (j,lvl[1],num[1],"stun",false,"enu",false,0.2,false);
					if condition > 0 then
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.stunned[chars_mobs_npcs[j].gender]);
					end;
				end;
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageHP = damage.physicalRes (j,damage.damageRandomizator(current_mob,1,8)*num[1]);
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						exp_for_what(damageHP,current_mob)
						if lvl[1] >= 4 then
							local condition = damage.applyCondition (j,lvl[1],num[1],"stun",false,"enu",false,0.2,false);
							if condition > 0 then
								helpers.addToActionLog( lognames.actions.stunned[chars_mobs_npcs[j].gender]);
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "deathblossom" then
		if helpers.cursorAtCurrentMob (j,cursor_world_x,cursor_world_y) and trace.arrowStatus(current_mob) then
			local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
			for h=1,2 do
				for i=1,#rings[h] do
					for j=1,#chars_mobs_npcs do
						if (helpers.cursorAtCurrentMob (j,boomx,boomy)) or (helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y)) then
							local damageHP = damage.physicalRes (j,20 + lvl[1]*num[1]);
							damage.HPminus(j,damageHP,true);
							table.insert(damaged_mobs,j);
							exp_for_what(damageHP,current_mob)
							local condition = damage.applyCondition (j,lvl[1],num[1],"stun",false,"enu",false,0.2,false);
							if condition > 0 then
								helpers.addToActionLog( lognames.actions.stunned[chars_mobs_npcs[j].gender]);
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "earthquake" then
		helpers.clearHlandscape(boomx,boomy);
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,3 do
			for i=1,#rings[h] do
				helpers.clearHlandscape(rings[h][i].x,rings[h][i].y);
				for j=1,#chars_mobs_npcs do
					if (helpers.cursorAtCurrentMob (j,boomx,boomy)) or (helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y)) and helpers.mobDependsGround(j) then
						local damageRT = chars_mobs_npcs[j].rt;
						damage.RTminus(j,damageRT,true);
						table.insert(damaged_mobs,j);
						exp_for_what(math.ceil(damageRT/4),current_mob)
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "deadlywave" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,3 do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if (helpers.cursorAtCurrentMob (j,boomx,boomy)) or (helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y)) and helpers.mobDependsGround(j) then
						local damageHP = 0;
						local damageHPD = damageHP + damage.magicalRes (j,damage.damageRandomizator(current_mob,10,lvl[2]),"darkness",false);
						local damageHPP = damageHP + damage.magicalRes (j,damage.damageRandomizator(current_mob,10,lvl[2]),"poison",false);
						local damageHP = damageHPD + damageHPP;
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						exp_for_what(damageHP,current_mob)
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "holyground" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,3 do
			for i=1,#rings[h] do	
				boomareas.holyGround (rings[h].x,rings[h],y,1,lvl[1],num[2])
			end;
		end;
	end;
	
	if missle_type == "comete" then
		if helpers.cursorAtCurrentMob (j,cursor_world_x,cursor_world_y) and trace.arrowStatus(current_mob) then
			local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
			for h=1,3 do
				for i=1,#rings[h] do
					for j=1,#chars_mobs_npcs do
						if (helpers.cursorAtCurrentMob (j,boomx,boomy)) or (helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y)) then
							local damageHP = damage.magicalRes (j,damage.damageRandomizator(current_mob,10,lvl[1]),"light",false);
							damageHP = damageHP + damage.magicalRes (j,damage.damageRandomizator(current_mob,10,lvl[2]),"fire",false);
							damageHP = damageHP + damage.magicalRes (j,damage.damageRandomizator(current_mob,10,lvl[3]),"cold",false);
							damageHP = damageHP + damage.magicalRes (j,damage.damageRandomizator(current_mob,10,lvl[4]),"static",false);
							damageHP = damageHP + damage.physicalRes (j,20);
							damage.HPminus(j,damageHP,true);
							table.insert(damaged_mobs,j);
							exp_for_what(damageHP,current_mob)
						end;
					end;
				end;
			end;
		end;
	end
	
	if missle_type == "jump" then
		local ringA = boomareas.smallRingArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
		local ringB = boomareas.smallRingArea(boomx,boomy);
		for j=1,#chars_mobs_npcs do
			for i=1,6 do
				if chars_mobs_npcs[j].x == ringA[i].x and chars_mobs_npcs[j].y == ringA[i].y and helpers.passCheck(ringB[i].x,ringB[i].y) and not helpers.cursorAtCurrentMob (j,ringB[i].x,ringB[i].y) then
					chars_mobs_npcs[j].x = ringB[i].x;
					chars_mobs_npcs[j].y = ringB[i].y;
					table.insert(damaged_mobs,j);
				end;
			end;
		end;
		for i=1,6 do
			if dlandscape_obj[ringA[i].y][ringA[i].x] == "fire" then
				dlandscape_obj[ringA[i].y][ringA[i].x] = 0;
				dlandscape_duration[ringA[i].y][ringA[i].x] = 0;
				dlandscape_power[ringA[i].y][ringA[i].x] = 0;
				if helpers.passCheck(ringB[i].x,ringB[i].y) then
					dlandscape_obj[ringB[i].y][ringB[i].x] = "fire";
					dlandscape_duration[ringB[i].y][ringB[i].x] = 1;
					dlandscape_power[ringB[i].y][ringB[i].x] = damage.damageRandomizator(current_mob,1,5);	
				end;
			end;
			
			if alandscape_obj[ringA[i].y][ringA[i].x] == "poison" then
				alandscape_obj[ringA[i].y][ringA[i].x] = 0;
				alandscape_duration[ringA[i].y][ringA[i].x] = 0;
				alandscape_power[ringA[i].y][ringA[i].x] = 0;
				if helpers.passCheck(ringB[i].x,ringB[i].y) then
					alandscape_obj[ringB[i].y][ringB[i].x] = "poison";
					alandscape_duration[ringB[i].y][ringB[i].x] = 1;
					alandscape_power[ringB[i].y][ringB[i].x] = damage.damageRandomizator(current_mob,1,5);	
				end;
			end;

		end;
		if helpers.passCheck(boomx,boomy) and not helpers.cursorAtCurrentMob (j,boomx,boomy)then
			chars_mobs_npcs[current_mob].x = boomx;
			chars_mobs_npcs[current_mob].y = boomy;	
		end;
	end;
	
	if missle_type == "fireblast" then
		local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,4,0);
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					local damageHP = damage.magicalRes (j,4+damage.damageRandomizator(current_mob,1,3)*num[1] + lvl[1],"fire",false);
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
					if lvl[1] >= 3 then
						local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"fire",false);
						if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].flame_power = dot_power;
							chars_mobs_npcs[j].flame_dur = dot_dur;
							helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.flamed[chars_mobs_npcs[j].gender]);
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "bell" then
		local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,7,0);
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					local debuff = damage.statRes (j,3 + lvl[1],"sns",true);
					if chars_mobs_npcs[j].stun == 0 then
						chars_mobs_npcs[j].stun = chars_mobs_npcs[j].stun + debuff;
						chars_mobs_npcs[j].sleep = 0;
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.dmg[chars_mobs_npcs[j].gender] .. helpers.mobName(j) .. " " .. lognames.actions.stun[chars_mobs_npcs[j].gender]);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(math.ceil(debuff/2),current_mob)	
					elseif chars_mobs_npcs[j].stun > 0 then
						chars_mobs_npcs[j].stun = 0;
					end;
					--table.insert(damaged_mobs,j);
				end;
			end;
		end;
	end;
	
	if missle_type == "megavolts" then
		local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,5,0);
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					local damageHP = damage.magicalRes (j,10+num[1]*(lvl[1]-2),"static",false);
					damageHP = damageHP + damage.magicalRes (j,10+num[1]*(lvl[1]-2),"fire",false);
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
				end;
			end;
		end;
	end;
	
	if missle_type == "shrapmetal" then
		local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,3+lvl[1],0);
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					local damageHP = damage.physicalRes (j,6+damage.damageRandomizator(current_mob,1,6)*num[2]);
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
					boomareas.bloodGround (boomarea[i].x,boomarea[i].y);
					local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"darkness",false);
					if dot_power > 0 and dot_dur > 0 and chars_mobs_npcs[j].nature ~= "undead" and chars_mobs_npcs[j].nature ~= "golem" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "elemental" then
						chars_mobs_npcs[j].flame_power = dot_power;
						chars_mobs_npcs[j].flame_dur = dot_dur;
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.bleeding[chars_mobs_npcs[j].gender]);
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "shockring" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for i=1,#rings[1] do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,rings[h][1].x,rings[h][1].y) then
					local damageRT = damage.magicalRes (j,damage.damageRandomizator(current_mob,1,2)*num[1]*num[2],"static");
					damage.RTminus(j,damageRT,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,math.ceil(damageRT/4));
					exp_for_what(math.ceil(damageRT/2),current_mob)
				end;
			end;
		end;
	end;
	
	if missle_type == "firering" then -- add dmg
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for i=1,#rings[3] do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == rings[3][i].x and chars_mobs_npcs[j].y == rings[3][i].y then
					local damageHP = damage.magicalRes (j,6 + num[1] + lvl[1],"fire");
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
					if lvl[1] >= 4 then
						local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"fire",false);
						if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].flame_power = dot_power;
							chars_mobs_npcs[j].flame_dur = dot_dur;
							helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.flamed[chars_mobs_npcs[j].gender]);
						end;
					end;
				end;
			end;
		end;
		for i=1,#rings[2] do
			if lvl[1] == 5 then
				for j=1,#chars_mobs_npcs do
					if chars_mobs_npcs[j].x == rings[3][i].x and chars_mobs_npcs[j].y == rings[3][i].y then
						local damageHP = damage.magicalRes (j,6 + num[1] + lvl[1],"fire");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob)
						local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"fire",false);
						if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].flame_power = dot_power;
							chars_mobs_npcs[j].flame_dur = dot_dur;
							helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.flamed[chars_mobs_npcs[j].gender]);
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "friendlyfire" then -- add dmg
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for i=h,#rings do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					local relations = ai.fractionRelations (current_mob,j);
					if chars_mobs_npcs[j].x == rings[h][i].x and chars_mobs_npcs[j].y == rings[h][i].y and relations < 0 then	
						local dmg1 = math.ceil(damage.magicalRes (j,num[1]*lvl[1],"light")*math.abs(relations)/100);
						local dmg2 = math.ceil(damage.magicalRes (j,num[1]*lvl[1],"fire")*math.abs(relations)/100);
						local damageHP = dmg1+dmg2;
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob);
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "coldring" then -- add dmg
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for i=1,#rings[3] do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == rings[2][i].x and chars_mobs_npcs[j].y == rings[2][i].y then
					local damageHP = damage.magicalRes (j,6 + num[1] + lvl[1],"cold");
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
					if chars_mobs_npcs[j].nature ~= "undead" and chars_mobs_npcs[j].nature ~= "golem" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "elemental" then
						local damageST = damage.magicalRes (j,12 + damage.damageRandomizator(current_mob,1,3)*num[1] + lvl[1],"cold");
						chars_mobs_npcs[j].st = chars_mobs_npcs[j].st - damageST;
						helpers.addToActionLog( lognames.actions.dmg[chars_mobs_npcs[current_mob].gender] .. helpers.mobName(j) .. " " .. damageST .. lognames.actions.metr .. " " .. lognames.actions.ofst);
						exp_for_what(math.ceil(damageST/2),current_mob)
						if lvl[1] == 5 then
							local freeze = damage.applyCondition (j,lvl[1],num[2],"freeze","cold",false,false,1,false);
							helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.freezed[chars_mobs_npcs[j].gender]);
						end;
					end;
					if lvl[1] >= 4 then
						local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"cold",false);
						if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].cold_power = dot_power;
							chars_mobs_npcs[j].cold_dur = dot_dur;
							helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.cooled[chars_mobs_npcs[j].gender]);
						end;
					end;
				end;
			end;
		end;
		for i=1,#rings[2] do
			if lvl[1] == 5 then
				for j=1,#chars_mobs_npcs do
					if chars_mobs_npcs[j].x == rings[3][i].x and chars_mobs_npcs[j].y == rings[3][i].y then
						local damageHP = damage.magicalRes (j,6 + num[1] + lvl[1],"cold");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob)
						if chars_mobs_npcs[j].nature ~= "undead" and chars_mobs_npcs[j].nature ~= "golem" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "elemental" then
							local damageST = damage.magicalRes (j,12 + damage.damageRandomizator(current_mob,1,3)*num[1] + lvl[1],"cold");
							damage.STminus(j,damageST,true);
							exp_for_what(math.ceil(damageST/2),current_mob)
							if lvl[1] == 5 then
								local freeze = damage.applyCondition (j,lvl[1],num[2],"freeze","cold",false,false,1,false);
								helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.freezed[chars_mobs_npcs[j].gender]);
							end;
						end;
						local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"cold",false);
						if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].cold_power = dot_power;
							chars_mobs_npcs[j].cold_dur = dot_dur;
							helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.cooled[chars_mobs_npcs[j].gender]);
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "firewall" then
		local boomarea = boomareas.wallArea(cursor_world_x,cursor_world_y,spell_rotation,1);
		for i=1,#boomarea do
			boomareas.fireGround(boomarea[i].y,boomarea[i].x,1,lvl[1],num[1]);
		end;
		array_of_map ();
	end;
	
	if missle_type == "stonewall" then
		local boomarea = boomareas.wallArea(cursor_world_x,cursor_world_y,spell_rotation,1);
		for i=1,#boomarea do
			boomareas.wallGround(boomarea[i].x,boomarea[i].y,1,lvl[1],num[1]);
			helpers.clearHlandscape(boomarea[i].x,boomarea[i].y);
		end;
		array_of_map ();
	end;
	
	if missle_type == "pitfall" then
		local boomarea = boomareas.wallArea(cursor_world_x,cursor_world_y,spell_rotation,1);
		for i=1,#boomarea do
			boomareas.pitGround(boomarea[i].x,boomarea[i].y,1,lvl[1],num[1]);
			helpers.clearHlandscape(boomarea[i].x,boomarea[i].y);
		end;
		array_of_map ();
	end;
	
	if missle_type == "twister" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,2 do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						chars_mobs_npcs[j].immobilize = 3+lvl[1];
						local damageHP = damage.physicalRes (j,damage.damageRandomizator(current_mob,1,4)*num[1] + lvl[1]);
						local damageST = damage.physicalRes (j,damage.damageRandomizator(current_mob,1,4)*num[1] + lvl[1]);
						damage.HPminus(j,damageHP,true);
						damage.STminus(j,damageST,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.immobilized[chars_mobs_npcs[j].gender]);
						exp_for_what(damageHP,current_mob);
						exp_for_what(math.ceil(damageST/2),current_mob);
						helpers.clearHlandscape(boomarea[i].x,boomarea[i].y);
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "powerheal" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,3 do
			for i=1,#rings[h] do
				if helpers.passJump(rings[h][i].y,rings[h][i].x) then
					for j=1,chars do
						if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) and chars_mobs_npcs[j].person == "char" then
							local healHP = 10 + 5*num[1];
							damage.HPplus(j,healHP);
							exp_for_what(healHP,current_mob)
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "pandemia" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,3 do
			for i=1,#rings[h] do
				if helpers.passJump(rings[h][i].y,rings[h][i].x) then
					for j=1,chars do
						if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) and helpers.aliveNature(j) and helpers.mobIsAlive(j) then
							debuff = damage.applyCondition (j,lvl[1],num[2],"disease","disease",false,false,1,false);
							chars_mobs_npcs[j].disease = math.max(chars_mobs_npcs[j].disease,debuff);
							exp_for_what(math.ceil(debuff/2),current_mob)
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "darkcontamination" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,3 do
			for i=1,#rings[h] do
				if helpers.passJump(rings[h][i].y,rings[h][i].x) then
					for j=1,chars do
						if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
							debuff = damage.applyCondition (j,lvl[1],num[2],"darkcontamination","darkness",false,false,1,false);
							chars_mobs_npcs[j].darkcontamination = math.max(chars_mobs_npcs[j].darkcontamination,debuff);
							exp_for_what(math.ceil(debuff/2),current_mob)
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "razors" then
		local boomarea = boomareas.pathArea(2,1);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) and chars_mobs_npcs[j].motion == "walking" then
				local dmg = damage.damageRandomizator(current_mob,1,9)*num[1];
				local damageHP = damage.physicalRes (j,dmg);
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP);
				
				--lala
				if helpers.aliveNature(j) then
					debuff = damage.applyCondition (j,lvl[1],1,"bleeding",false,false,false,2,true);
					boomareas.bloodGround (boomx,boomy);
					helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.bleeding[chars_mobs_npcs[j].gender]);
				end;
				--damage.applyCondition (j,lvl[1],num[1],"legstrauma",false,false,false,1,true);
			end;
		end;
	end;
	
	if missle_type == "spikes" then
		local boomarea = boomareas.pathArea(2,2);
		table.insert(boomarea,{x=boomy,y=boomx});
		for i=1,math.min(5+chars_mobs_npcs[current_mob].lvl_earth,#boomarea) do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) and chars_mobs_npcs[j].motion == "walking" then
					local dmg = damage.damageRandomizator(current_mob,2,6)*num[1];
					local damageHP = damage.physicalRes (j,dmg);
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					if helpers.aliveNature(j) then
						debuff = damage.applyCondition (j,lvl[1],1,"bleeding",false,false,false,2,true);
						boomareas.bloodGround (boomarea[i].x,boomarea[i].y);
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.bleeding[chars_mobs_npcs[j].gender]);
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "inferno" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
						local damageHP = damage.magicalRes (j,12+num[1],"fire");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob)
						local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"fire",false);
						if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].flame_power = dot_power;
							chars_mobs_npcs[j].flame_dur = dot_dur;
							helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.flamed[chars_mobs_npcs[j].gender]);
						end;
					end;	
				end;
			end;
		end;
	end;
	
	if missle_type == "prismaticlight" then
		local boomarea = boomareas.sightArea(); 
		for j=1,#chars_mobs_npcs do
			for i=1,#boomarea do
				local damageHP = damage.magicalRes (j,12+num[1],"light");
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP);
				exp_for_what(damageHP,current_mob)
			end;
		end;
	end;
	
	if missle_type == "violation" then
		local boomarea = boomareas.sightArea();
		local boomarea2 = {};
		for j=1,#chars_mobs_npcs do
			for i=1,#boomarea do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) and chars_mobs_npcs[j].person ~= "char" and chars_mobs_npcs[j].status <= 0 and helpers.aliveNature(j) then
					local rings = boomareas.ringArea(chars_mobs_npcs[i].x,chars_mobs_npcs[i].y);
					table.insert(boomarea2,{chars_mobs_npcs[j].x,chars_mobs_npcs[j].y,power=2});
					for i=1,rings do
						table.insert(boomarea2,{x=rings[1].x,y=rings[1].y,power=1});
					end;
					table.remove(chars_mobs_npcs,i);
				end;
			end;
		end;
		for j=1,#chars_mobs_npcs do
			if chars_mobs_npcs[j].x == boomarea2[i].x and chars_mobs_npcs[j].y == boomarea2[i].y and chars_mobs_npcs[j].status >= 0 and helpers.aliveNature(j) then
				local damageHP = damage.magicalRes (boomarea2[i].power*j,12+num[1],"darkness");
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP);
				exp_for_what(damageHP,current_mob)
			end;
		end;
	end;
	
	if missle_type == "souldrinker" then
		local boomarea = boomareas.sightArea(); 
		local gainedHP = 0;
		local partHP = 0;
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) and chars_mobs_npcs[j].person ~= "char" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "golem" then
					local damageHP =  damage.magicalRes (j,25 + damage.damageRandomizator(current_mob,1,8)*num[1],"darkness");
					damage.HPminus(j,damageHP,true);
					gainedHP = gainedHP + damageHP;
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
				end;
			end;
		end;
		partHP = math.ceil(gainedHP/chars);
		for i=1,chars do
			if chars_mobs_npcs[i].status >= 0 and chars_mobs_npcs[i].freeze == 0 and chars_mobs_npcs[i].stone == 0 then
				local healHP = math.min(partHP,chars_mobs_npcs[i].hp_max -chars_mobs_npcs[i].hp);
				chars_mobs_npcs[i].hp = chars_mobs_npcs[i].hp  + healHP;
				damage.HPplus(i,healHP);
				exp_for_what(healHP,current_mob)
			end;
		end;
	end;
	
	if missle_type == "masscurse" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) and chars_mobs_npcs[j].person ~= "char" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "golem" then
					local debuff = damage.applyCondition (j,lvl[1],num[1],"curse","darkness","luk",false,1,false);
					if debuff > 0 then
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,math.ceil(debuff/4));
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.cursed[chars_mobs_npcs[j].gender]);
						exp_for_what(math.ceil(debuff/3),current_mob);
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "misfortune" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) and chars_mobs_npcs[j].person ~= "char" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "golem" then
					local debuff,debuff2 = damage.applyConditionTwoFactors (j,lvl[1],num[1],"misfortune","darkness",false,false,1,false);
					if debuff > 0 then
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,math.ceil(debuff/4));
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.cursed[chars_mobs_npcs[j].gender]);
						exp_for_what(math.ceil(debuff*debuff2/300),current_mob)
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "despondency" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) and chars_mobs_npcs[j].person ~= "char" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "golem" then
					local debuff_power,debuff_dur = damage.applyConditionTwoFactors (j,lvl[1],num[2],"despondency","mind",false,false,1,false)
					if debuff_power > 0 and debuff_dur > 0 then
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,math.ceil(debuff_power/4));
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.desponded[chars_mobs_npcs[j].gender]);
						exp_for_what(math.ceil(debuff_power/3),current_mob)
					end;
				end;
			end;
		end;
	end
	
	if missle_type == "weakness" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) and chars_mobs_npcs[j].person ~= "char" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "golem" then
					local debuff_power,debuff_dur = damage.applyConditionTwoFactors (j,lvl[1],num[2],"weakness","spirit",false,false,1,false)
					if debuff_power > 0 and debuff_dur > 0 then
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,math.ceil(debuff_power/4));
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.desponded[chars_mobs_npcs[j].gender]);
						exp_for_what(math.ceil(debuff_power/3),current_mob)
					end;
				end;
			end;
		end;
	end
	
	if missle_type == "moonlight" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					if chars_mobs_npcs[j].person == "char" or chars_mobs_npcs[j].nature == "undead" then
						local healHP = damage.damageRandomizator(current_mob,1,4)*num[2];
						damage.HPminus(j,healHP,true);
						exp_for_what(healHP,current_mob)
					else
						local damageHP =  damage.magicalRes (j,damage.damageRandomizator(current_mob,1,4)*num[1],"darkness");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob)
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "genocide" then
		local boomarea = boomareas.signArea("class",genocidethem);
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y ==  boomarea[i].y then
					local damageHP = damage.magicalRes (j,damage.damageRandomizator(current_mob,2,6)*num[1],"darkness");
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
				end;
			end;
		end;
	end;
	
	if missle_drive == "revenge" and missle_type == "revenge" then
		local boomarea = {};
		for i=1,#mobs_revengers do
			local rings = boomareas.ringArea(chars_mobs_npcs[mobs_revengers[i]].x,chars_mobs_npcs[mobs_revengers[i]].y);
			for h=1,6 do
				for j=1,#chars_mobs_npcs do
					if chars_mobs_npcs[j].x == rings[1][h].x and chars_mobs_npcs[j].y == rings[1][h].y then
						if chars_mobs_npcs[j].revenge_type == "acid" then
							local damageHP = damage.magicalRes (j,15+math.random(1,10)*chars_mobs_npcs[mobs_revengers[i]].revenge_power,"acid");
							damage.HPminus(j,damageHP,true);
							table.insert(damaged_mobs,j);
							damage.mobDamaged(j,mobs_revengers[i],damageHP);
							exp_for_what(damageHP,current_mob)
							local dot_power,dot_dur = damage.applyDoT (j,chars_mobs_npcs[mobs_revengers[i]].revenge_power,chars_mobs_npcs[mobs_revengers[i]].revenge_power,1,0,1,0,"acid",false);
							if dot_power > 0 and dot_dur > 0 then
								chars_mobs_npcs[j].acid_power = dot_power;
								chars_mobs_npcs[j].acid_dur = dot_dur;
								helpers.addToActionLog( lognames.actions.acided[chars_mobs_npcs[j].gender]);
							end;
						elseif chars_mobs_npcs[j].revenge_type == "poison" then
							local damageHP = damage.magicalRes (j,15+math.random(1,10)*chars_mobs_npcs[mobs_revengers[i]].revenge_power,"poison");
							damage.HPminus(j,damageHP,true);
							table.insert(damaged_mobs,j);
							damage.mobDamaged(j,mobs_revengers[i],damageHP);
							exp_for_what(damageHP,current_mob)
							local dot_power,dot_dur = damage.applyDoT (j,chars_mobs_npcs[mobs_revengers[i]].revenge_power,chars_mobs_npcs[mobs_revengers[i]].revenge_power,1,0,1,0,"poison",false);
							if dot_power > 0 and dot_dur > 0 then
								chars_mobs_npcs[j].poison_power = dot_power;
								chars_mobs_npcs[j].poison_dur = dot_dur;
								helpers.addToActionLog( lognames.actions.poisoned[chars_mobs_npcs[j].gender]);
							end;
						elseif chars_mobs_npcs[j].revenge_type == "fire" then
							local damageHP = damage.magicalRes (j,15+math.random(1,10)*chars_mobs_npcs[mobs_revengers[i]].revenge_power,"fire");
							damage.HPminus(j,damageHP,true);
							table.insert(damaged_mobs,j);
							damage.mobDamaged(j,mobs_revengers[i],damageHP);
							exp_for_what(damageHP,current_mob)
							local dot_power,dot_dur = damage.applyDoT (j,chars_mobs_npcs[mobs_revengers[i]].revenge_power,chars_mobs_npcs[mobs_revengers[i]].revenge_power,1,0,1,0,"fire",false);
							if dot_power > 0 and dot_dur > 0 then
								chars_mobs_npcs[j].flame_power = dot_power;
								chars_mobs_npcs[j].flame_dur = dot_dur;
								helpers.addToActionLog( lognames.actions.flamed[chars_mobs_npcs[j].gender]);
							end;
						elseif chars_mobs_npcs[j].revenge_type == "light" then
							local damageHP = damage.magicalRes (j,15+math.random(1,10)*chars_mobs_npcs[mobs_revengers[i]].revenge_power,"light");
							damage.HPminus(j,damageHP,true);
							table.insert(damaged_mobs,j);
							damage.mobDamaged(j,mobs_revengers[i],damageHP);
							exp_for_what(damageHP,current_mob)
						elseif chars_mobs_npcs[j].revenge_type == "static" then
							local damageHP = damage.magicalRes (j,15+math.random(1,10)*chars_mobs_npcs[mobs_revengers[i]].revenge_power,"static");
							local damageRT = damage.magicalRes (j,15+math.random(1,10)*chars_mobs_npcs[mobs_revengers[i]].revenge_power,"static");
							damage.HPminus(j,damageHP,true);
							damage.RTminus(j,damageRT,true);
							table.insert(damaged_mobs,j);
							damage.mobDamaged(j,mobs_revengers[i],damageHP);
							exp_for_what(damageHP,current_mob)
							exp_for_what(math.ceil(damageRT/4),current_mob)
						elseif chars_mobs_npcs[j].revenge_type == "cold" then
							local damageHP = damage.magicalRes (j,15+math.random(1,10)*chars_mobs_npcs[mobs_revengers[i]].revenge_power,"cold");
							local damageST = damage.magicalRes (j,15+math.random(1,10)*chars_mobs_npcs[mobs_revengers[i]].revenge_power,"cold");
							damage.HPminus(j,damageHP,true);
							damage.STminus(j,damageST,true);
							table.insert(damaged_mobs,j);
							damage.mobDamaged(j,mobs_revengers[i],damageHP);
							exp_for_what(damageHP,current_mob)
							exp_for_what(math.ceil(damageST/2),current_mob)
							local dot_power,dot_dur = damage.applyDoT (j,chars_mobs_npcs[mobs_revengers[i]].revenge_power,chars_mobs_npcs[mobs_revengers[i]].revenge_power,1,0,1,0,"cold",false);
							if dot_power > 0 and dot_dur > 0 then
								chars_mobs_npcs[j].cold_power = dot_power;
								chars_mobs_npcs[j].cold_dur = dot_dur;
								helpers.addToActionLog( lognames.actions.colded[chars_mobs_npcs[j].gender]);
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "massdispell" then
		local boomarea = boomareas.sightArea(); 
		local counter = lvl[1]*num[1]+lvl[2]*num[2];
		local counterforexp = counter;
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) and chars_mobs_npcs[j].person ~= "char" and chars_mobs_npcs[j].nature ~= "droid" and chars_mobs_npcs[j].nature ~= "golem" then
						while counter > 0 do
							if chars_mobs_npcs[j].invisibility > 0 then	
								chars_mobs_npcs[j].invisibility = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].dayofgods_dur > 0 then
								chars_mobs_npcs[j].dayofgods_power = 0;
								chars_mobs_npcs[j].dayofgods_dur = 0;
							elseif chars_mobs_npcs[j].heroism_dur > 0 then
								chars_mobs_npcs[j].heroism_dur = 0;
								chars_mobs_npcs[j].heroism_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].bless > 0 then
								chars_mobs_npcs[j].bless = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].fate > 0 then
								chars_mobs_npcs[j].fate = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].fateself > 0 then
								chars_mobs_npcs[j].fateself = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].rage > 0 then
								chars_mobs_npcs[j].rage = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].haste > 0 then
								chars_mobs_npcs[j].haste = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].prayer_dur > 0 then
								chars_mobs_npcs[j].prayer_dur = 0;
								chars_mobs_npcs[j].prayer_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].myrth_dur > 0 then
								chars_mobs_npcs[j].myrth_dur = 0;
								chars_mobs_npcs[j].myrth_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].executor_dur > 0 then
								chars_mobs_npcs[j].executor_dur = 0;
								chars_mobs_npcs[j].executor_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].torch_dur > 0 then
								chars_mobs_npcs[j].torch_dur = 0;
								chars_mobs_npcs[j].torch_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].stoneskin_dur > 0 then
								chars_mobs_npcs[j].stoneskin_dur = 0;
								chars_mobs_npcs[j].stoneskin_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].shield > 0 then
								chars_mobs_npcs[j].shield = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].shieldoflight > 0 then
								chars_mobs_npcs[j].shieldoflight = 0;
								chars_mobs_npcs[j].shieldoflight = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].wingsoflight > 0 then
								chars_mobs_npcs[j].wingsoflight = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].protfromfire_dur > 0 then
								chars_mobs_npcs[j].protfromfire_dur = 0;
								chars_mobs_npcs[j].protfromfire_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].protfromcold_dur > 0 then
								chars_mobs_npcs[j].protfromcold_dur = 0;
								chars_mobs_npcs[j].protfromcold_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].protfromstatic_dur > 0 then
								chars_mobs_npcs[j].protfromstatic_dur = 0;
								chars_mobs_npcs[j].protfromstatic_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].protfromacid_dur > 0 then
								chars_mobs_npcs[j].protfromacid_dur = 0;
								chars_mobs_npcs[j].protfromacid_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].protfrompoison_dur > 0 then
								chars_mobs_npcs[j].protfrompoison_dur = 0;
								chars_mobs_npcs[j].protfrompoison_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].protfromdisease_dur > 0 then
								chars_mobs_npcs[j].protfromdisease_dur = 0;
								chars_mobs_npcs[j].protfromdisease_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].protofspirit_dur > 0 then
								chars_mobs_npcs[j].protofspirit_dur = 0;
								chars_mobs_npcs[j].protofspirit_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].protofmind_dur > 0 then
								chars_mobs_npcs[j].protofmind_dur = 0;
								chars_mobs_npcs[j].protofmind_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].might_dur > 0 then
								chars_mobs_npcs[j].might_dur = 0;
								chars_mobs_npcs[j].might_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].dash_dur > 0 then
								chars_mobs_npcs[j].dash_dur = 0;
								chars_mobs_npcs[j].dash_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].precision_dur > 0 then
								chars_mobs_npcs[j].precision_dur = 0;
								chars_mobs_npcs[j].precision_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].concentration_dur > 0 then
								chars_mobs_npcs[j].concentration_dur = 0;
								chars_mobs_npcs[j].concentration_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].glamour_dur > 0 then
								chars_mobs_npcs[j].glamour_dur = 0;
								chars_mobs_npcs[j].glamour_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].luckyday_dur > 0 then
								chars_mobs_npcs[j].luckyday_dur = 0;
								chars_mobs_npcs[j].luckyday_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].mobility_dur > 0 then
								chars_mobs_npcs[j].mobility_dur = 0;
								chars_mobs_npcs[j].mobility_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].dash_dur > 0 then
								chars_mobs_npcs[j].dash_dur = 0;
								chars_mobs_npcs[j].dash_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].regeneration_dur > 0 then
								chars_mobs_npcs[j].regeneration_dur = 0;
								chars_mobs_npcs[j].regeneration_power = 0;
								counter = counter - 1;
							elseif chars_mobs_npcs[j].holyblood_dur > 0 then
								chars_mobs_npcs[j].holyblood_dur = 0;
								chars_mobs_npcs[j].holyblood_power = 0;
								counter = counter - 1;	
							end;
							if chars_mobs_npcs[j].nature == "elemental" then
								local dmg = math.min(dmg,chars_mobs_npcs[j].hp);
								counter = counter - dmg;
								damage.HPminus(j,dmg,true);
							elseif chars_mobs_npcs[j].nature == "golem" then
								local dmg = math.min(dmg,chars_mobs_npcs[j].rt);
								counter = counter - dmg;
								damage.RTminus(j,dmg,true);
							end;
						end;
					if counterforexp > 0 and counterforexp ~= counter then
						local debuff = math.ceil(counterforexp-counter/3);
						exp_for_what(debuff,current_mob)
						damage.mobDamaged(j,current_mobdebuff);
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "icefield" then
		local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,11,0);
		for i=1,#boomarea do
			boomareas.iceGround(boomarea[i].x,boomarea[i].y,1,lvl[1],num[1]);
		end;
	end;
	
	if missle_type == "mud" then
		local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,11,0);
		for i=1,#boomarea do
			boomareas.mudGround(boomarea[i].x,boomarea[i].y,1,lvl[1],num[2]);
		end;
	end;
	
	if missle_type == "eyeofthestorm" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			elandscape[boomarea[i].y][boomarea[i].x] = "snow";	
		end;
	end;
	
	if missle_type == "coldray" then
		local boomarea = boomareas.rayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,11,0);
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					local damageHP = damage.magicalRes (j,8+num[1],"cold");
					local dot_power,dot_dur = damage.applyDoT (victim,lvl[2],num[2],1,0,1,0,"cold",false);
					if dot_power > 0 and dot_dur > 0 then
						chars_mobs_npcs[victim].cold_power = dot_power;
						chars_mobs_npcs[victim].cold_dur = dot_dur;
						helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.acided[chars_mobs_npcs[victim].gender]);
					end;
					local debuff = damage.applyCondition (j,lvl[1],num[2],"freeze","cold",false,false,1,false);
					if debuff > 0 then
						exp_for_what(math.ceil(debuff/3),current_mob);
					end;
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
				end;
			end;
		end;
	end;
	
	if missle_type == "meteorshower" then 
		local power = 1;
		local boomarea,sharea = boomareas.showerArea(cursor_world_x,cursor_world_y,12,power);
		for i=2, #boomarea[1] do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					local damageHP = damage.magicalRes (j,8+num[1],"fire");
					damageHP = damageHP + damage.physicalRes (num[1]);
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
				end;
			end;
		end;
		for i=1, #sharea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == sharea[i].x and chars_mobs_npcs[j].y == sharea[i].y then
					local damageHP = damage.magicalRes (j,8+num[1]+sharea[i].power,"fire");
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
				end;
			end;
			if helpers.passWalk(sharea[i].y,sharea[i].x) then
				boomareas.fireGround(sharea[i].y,sharea[i].x,i,lvl[1],num[1]);
			end;
		end;
	end;
	
	if missle_type == "starburst" then 
		local power = 1;
		local boomarea,sharea = boomareas.showerArea(cursor_world_x,cursor_world_y,12,power);
		for i=2, #boomarea[1] do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					local damageHP = damage.magicalRes (j,25+num[1],"static");
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
					local damageRT = damage.magicalRes (j,25+num[1],"static");
					damage.RTminus(j,damageRT,true);
				end;
			end;
		end;
		for i=1, #sharea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == sharea[i].x and chars_mobs_npcs[j].y == sharea[i].y then
					local damageHP = damage.magicalRes (j,20+num[1]+sharea[i].power,"static");
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					helpers.addToActionLog( lognames.actions.dmg[chars_mobs_npcs[current_mob].gender] .. helpers.mobName(j) .. " " .. damageHP .. lognames.actions.metr .. " " .. lognames.actions.ofhp);
					exp_for_what(damageHP,current_mob)
				end;
			end;
		end;
	end;
	
	if missle_type == "armageddon" then
		for j=1,#chars_mobs_npcs do
			local damageHP = damage.magicalRes (j,num[1],"darkness");
			damageHP = damageHP + damage.magicalRes (j,num[2],"fire");
			damageHP = damageHP + damage.physicalRes (j,damage.damageRandomizator(current_mob,1,20));
			damage.HPminus(j,damageHP,true);
			table.insert(damaged_mobs,j);
			damage.mobDamaged(j,current_mob,damageHP);
			exp_for_what(damageHP,current_mob)
		end;
	end;
	
	if missle_type == "acidrain" then 
		local power = 1;
		local boomarea,sharea = boomareas.showerArea(cursor_world_x,cursor_world_y,18,power);
		for i=2, #boomarea[1] do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					local damageHP = damage.magicalRes (j,8+num[1],"acid");
					local dot_power,dot_dur = damage.applyDoT (victim,lvl[1],num[1],1,0,1,0,"acid",false);
					if dot_power > 0 and dot_dur > 0 then
						chars_mobs_npcs[victim].acid_power = dot_power;
						chars_mobs_npcs[victim].acid_dur = dot_dur;
						helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.acided[chars_mobs_npcs[victim].gender]);
					end;
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
				end;
			end;
		end;
		for i=1, #sharea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == sharea[i].x and chars_mobs_npcs[j].y == sharea[i].y then
					local damageHP = damage.magicalRes (j,8+num[1]+sharea[i].power,"acid");
					local dot_power,dot_dur = damage.applyDoT (victim,lvl[1],num[1],1,0,1,0,"acid",false);
					if dot_power > 0 and dot_dur > 0 then
						chars_mobs_npcs[victim].acid_power = dot_power;
						chars_mobs_npcs[victim].acid_dur = dot_dur;
						helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.acided[chars_mobs_npcs[victim].gender]);
					end;
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					damage.mobDamaged(j,current_mob,damageHP);
					exp_for_what(damageHP,current_mob)
				end;
			end;
		end;
	end;
	
	if missle_type=="chainlightning" then
		local boomarea, linetable = boomareas.chainArea(cursor_world_x,cursor_world_y, lvl[1], 3);
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if helpers.cursorAtCurrentMob (j,boomarea[i].x,boomarea[i].y) then
					local damageHP = damage.magicalRes (j,damage.damageRandomizator(current_mob,1,8)*num[1] + lvl[1],"static");
					damage.mobDamaged(j,current_mob,damageHP);
					damage.HPminus(j,damageHP,true);
					table.insert(damaged_mobs,j);
					exp_for_what(damageHP,current_mob)
				end;
			end;
		end;
	end;
	
	if	(missle_type == "bottle" and missle_subtype == "firebomb") or missle_type == "firebomb" then
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageHP = damage.magicalRes (j,math.random(1,6)*num[1] + lvl[1],"fire");
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP);
				exp_for_what(damageHP,current_mob)
				if lvl[1] >= 3 then
					local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"fire",false);
					if dot_power > 0 and dot_dur > 0 then
						chars_mobs_npcs[j].flame_power = dot_power;
						chars_mobs_npcs[j].flame_dur = dot_dur;
						helpers.addToActionLog( lognames.actions.flamed[chars_mobs_npcs[j].gender]);
					end;
				end;
			end;
		end;
		boomareas.fireGround(boomy,boomx,1,lvl[1],num[1]);
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageHP = damage.magicalRes (j,math.random(1,6)*num[1],"fire");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob)
						if lvl[1] >= 3 then
							local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"fire",false);
							if dot_power > 0 and dot_dur > 0 then
								chars_mobs_npcs[j].flame_power = dot_power;
								chars_mobs_npcs[j].flame_dur = dot_dur;
								helpers.addToActionLog( lognames.actions.flamed[chars_mobs_npcs[j].gender]);
							end;
						end;
					end;
				end;
				boomareas.fireGround(rings[h][i].x,rings[h][i].y,2,lvl[1],num[1]);
			end;
		end;
	end;
	
	if (missle_type == "bottle" and missle_subtype == "toxicbomb") or missle_type == "toxicbomb" then
		local index = 1;
		local boompower = 1;
		boomareas.poisonAir(boomx,boomy,index,lvl[2],num[2]);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageHP = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"poison");
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP);
				exp_for_what(damageHP,current_mob)
				local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"poison",false);
				if dot_power > 0 and dot_dur > 0 then
					chars_mobs_npcs[j].flame_power = dot_power;
					chars_mobs_npcs[j].flame_dur = dot_dur;
					helpers.addToActionLog( lognames.actions.poisoned[chars_mobs_npcs[j].gender]);
				end;
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageHP = damage.magicalRes (j,25+math.random(1,10)*num[1],"poison");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob)
						local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"poison",false);
							if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].flame_power = dot_power;
							chars_mobs_npcs[j].flame_dur = dot_dur;
							helpers.addToActionLog( lognames.actions.poisoned[chars_mobs_npcs[j].gender]);
						end;
					end;
				end;
				if lvl[2] >= 4 then
					boomareas.poisonAir(rings[h][i].x,rings[h][i].y,index,lvl[1],num[1]);
				end;
			end;
		end;
	end;
	
	if (missle_type == "bottle" and missle_subtype == "acidbomb") or missle_type == "acidbomb" then
		local index = 1;
		local boompower = 1;
		--boomareas.poisonAir(boomx,boomy,index,lvl[2],num[2]);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageHP = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"acid");
				damage.HPminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP);
				exp_for_what(damageHP,current_mob)
				local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"acid",false);
				if dot_power > 0 and dot_dur > 0 then
					chars_mobs_npcs[j].acid_power = dot_power;
					chars_mobs_npcs[j].acid_dur = dot_dur;
					helpers.addToActionLog( lognames.actions.acided[chars_mobs_npcs[j].gender]);
				end;
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageHP = damage.magicalRes (j,25+math.random(1,10)*num[1],"acid");
						damage.HPminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP);
						exp_for_what(damageHP,current_mob)
						local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"acid",false);
							if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].acid_power = dot_power;
							chars_mobs_npcs[j].acid_dur = dot_dur;
							helpers.addToActionLog( lognames.actions.acided[chars_mobs_npcs[j].gender]);
						end;
					end;
				end;
			end;
		end;
	end;
	
	if (missle_type == "bottle" and missle_subtype == "frostbomb") or missle_type == "frostbomb" then
		local index = 1;
		local boompower = 1;
		--boomareas.poisonAir(boomx,boomy,index,lvl[2],num[2]);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageHP = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"cold");
				local damageST = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"cold");
				damage.HPminus(j,damageHP,true);
				damage.STminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP+math.ceil(damageST/2));
				exp_for_what(damageHP+math.ceil(damageST/2),current_mob)
				local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"cold",false);
				if dot_power > 0 and dot_dur > 0 then
					chars_mobs_npcs[j].acid_power = dot_power;
					chars_mobs_npcs[j].acid_dur = dot_dur;
					helpers.addToActionLog( lognames.actions.cooled[chars_mobs_npcs[j].gender]);
				end;
				local debuff = damage.applyCondition (j,lvl[1],num[2],"freeze","cold",false,false,1,false);
				if debuff > 0 then
					exp_for_what(math.ceil(debuff/3),current_mob);
				end;
				helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.freezed[chars_mobs_npcs[j].gender]);
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageHP = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"cold");
						local damageST = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"cold");
						damage.HPminus(j,damageHP,true);
						damage.STminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP+math.ceil(damageST/2));
						exp_for_what(damageHP+math.ceil(damageST/2),current_mob);
						local dot_power,dot_dur = damage.applyDoT (j,lvl[1],num[1],1,0,1,0,"cold",false);
							if dot_power > 0 and dot_dur > 0 then
							chars_mobs_npcs[j].acid_power = dot_power;
							chars_mobs_npcs[j].acid_dur = dot_dur;
							helpers.addToActionLog( lognames.actions.cooled[chars_mobs_npcs[j].gender]);
						end;
						local debuff = damage.applyCondition (j,lvl[1],num[2],"freeze","cold",false,false,1,false);
						if debuff > 0 then
							exp_for_what(math.ceil(debuff/3),current_mob);
						end;
						helpers.addToActionLog( helpers.mobName(j) .. lognames.actions.freezed[chars_mobs_npcs[j].gender]);
					end;
				end;
			end;
		end;
	end;
	
	if (missle_type == "bottle" and missle_subtype == "electricbomb") or missle_type == "electricbomb" then
		local index = 1;
		local boompower = 1;
		--boomareas.poisonAir(boomx,boomy,index,lvl[2],num[2]);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageHP = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
				local damageRT = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
				damage.HPminus(j,damageHP,true);
				damage.RTminus(j,damageRT,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP+math.ceil(damageRT/4));
				exp_for_what(damageHP+math.ceil(damageRT/4),current_mob);
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageHP = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
						local damageRT = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
						damage.HPminus(j,damageHP,true);
						damage.RTminus(j,damageRT,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP+math.ceil(damageRT/4));
						exp_for_what(damageHP+math.ceil(damageRT/4),current_mob);
					end;
				end;
			end;
		end;
	end;
	
	if (missle_type == "bottle" and missle_subtype == "resetbomb") or missle_type == "resetbomb" then
		local index = 1;
		local boompower = 1;
		--boomareas.poisonAir(boomx,boomy,index,lvl[2],num[2]);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageST = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
				local damageRT = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
				local damageSP = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
				damage.STminus(j,damageHP,true);
				damage.RTminus(j,damageRT,true);
				damage.SPminus(j,damageSP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,damageHP+math.ceil(damageSP/2)+math.ceil(damageST/2)+math.ceil(damageRT/4));
				exp_for_what(damageHP+math.ceil(damageSP/2)+math.ceil(damageST/2)+math.ceil(damageRT/4),current_mob);
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
						if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageST = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
						local damageRT = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
						local damageSP = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
						damage.STminus(j,damageHP,true);
						damage.RTminus(j,damageRT,true);
						damage.SPminus(j,damageSP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,damageHP+math.ceil(damageSP/2)+math.ceil(damageST/2)+math.ceil(damageRT/4));
						exp_for_what(damageHP+math.ceil(damageSP/2)+math.ceil(damageST/2)+math.ceil(damageRT/4),current_mob);
					end;
				end;
			end;
		end;
	end;
	
	if (missle_type == "bottle" and missle_subtype == "manabomb") or missle_type == "manabomb" then
		local index = 1;
		local boompower = 1;
		--boomareas.poisonAir(boomx,boomy,index,lvl[2],num[2]);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy)  and helpers.aliveNature(j) then
				local damageSP = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"poison");
				damage.RTminus(j,damageSP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,math.ceil(damageSP/2));
				exp_for_what(math.ceil(damageSP/2),current_mob);
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y)  and helpers.aliveNature(j) then
						local damageSP = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"poison");
						damage.SPminus(j,damageSP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,math.ceil(damageSP/2));
						exp_for_what(math.ceil(damageSP/2),current_mob);
					end;
				end;
			end;
		end;
	end;
	
	if (missle_type == "bottle" and missle_subtype == "shockbomb") or missle_type == "shockbomb" then
		local index = 1;
		local boompower = 1;
		--boomareas.poisonAir(boomx,boomy,index,lvl[2],num[2]);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) and (helpers.aliveNature(j) or helpers.droidNature(j)) then
				local damageRT = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
				damage.RTminus(j,damageRT,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,math.ceil(damageRT/4));
				exp_for_what(math.ceil(damageRT/4),current_mob);
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y)  and (helpers.aliveNature(j) or helpers.droidNature(j))  then
						local damageRT = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"static");
						damage.RTminus(j,damageRT,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,math.ceil(damageRT/4));
						exp_for_what(math.ceil(damageRT/4),current_mob);
					end;
				end;
			end;
		end;
	end;
	
	if (missle_type == "bottle" and missle_subtype == "oxybomb") or missle_type == "oxybomb" then
		local index = 1;
		local boompower = 1;
		--boomareas.poisonAir(boomx,boomy,index,lvl[2],num[2]);
		for j=1,#chars_mobs_npcs do
			if helpers.cursorAtCurrentMob (j,boomx,boomy) then
				local damageST = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"poison");
				damage.STminus(j,damageHP,true);
				table.insert(damaged_mobs,j);
				damage.mobDamaged(j,current_mob,math.ceil(damageST/2));
				exp_for_what(math.ceil(damageST/2),current_mob);
			end;
		end;
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if helpers.cursorAtCurrentMob (j,rings[h][i].x,rings[h][i].y) then
						local damageST = damage.magicalRes (j,25+math.random(1,10)*num[1] + num[1],"poison");
						damage.STminus(j,damageHP,true);
						table.insert(damaged_mobs,j);
						damage.mobDamaged(j,current_mob,math.ceil(damageST/2));
						exp_for_what(math.ceil(damageST/2),current_mob);
					end;
				end;
			end;
		end;
	end;
	
--charmbomb (bumba!)
--berserkbomb (int check)
--panicbomb
--fearbomb
--demoralizebomb
	
	for i = 1, #damaged_mobs do --mb powerheal should not be here? or just no dmg
		--damage.mobDamaged(damaged_mobs[i]);
	end;
	md_timer = 0;
	game_status = "multidamage";
	--damage.deathsWatcher(damaged_mobs);
	chars_mobs_npcs[current_mob].rage = 0;
	return damaged_mobs;
end;

function damage.ifBattleEnds()
	local endbattle = true;
	for j=1,#chars_mobs_npcs do
		if chars_mobs_npcs[j].ai ~= "building" then
			local tmpfrac = chars_mobs_npcs[j].fraction;
			local tmpfrac2 = "party";
			local fraccond = loadstring("return " .. "fractions." .. tmpfrac2 .. "." .. tmpfrac)();
			if chars_mobs_npcs[j].person == "mob" and chars_mobs_npcs[j].status == 1 and fraccond < 0 then
				endbattle = false;
			end;
			if chars_mobs_npcs[j].person == "char" and chars_mobs_npcs[j].status == 1 and (fraccond<0 or chars_mobs_npcs[j].enslave>0 or chars_mobs_npcs[j].berserk>0 or chars_mobs_npcs[j].charm>0) then
				endbattle = false;
			end;
			helpers.countMoral(j);
			if chars_mobs_npcs[j].moral > chars_mobs_npcs[j].base_moral*2 and chars_mobs_npcs[j].base_moral ~= 0 then
			local roll = math.random(1,2);
			if roll == 1 then
			else
				love.audio.play(media.sounds.highmoral, 0);
				helpers.addToActionLog( helpers.mobName(j) .. " " .. lognames.actions.hashighmoral[chars_mobs_npcs[j].gender]);
				chars_mobs_npcs[j].rt = math.min(200,chars_mobs_npcs[j].rt + 20);
			end;
			elseif chars_mobs_npcs[j].moral < -1*chars_mobs_npcs[j].base_moral and chars_mobs_npcs[j].base_moral ~= 0 then
				local roll = math.random(1,2);
				if roll == 1 then
				else
					love.audio.play(media.sounds.lowmoral, 0);
					helpers.addToActionLog( helpers.mobName(j) .. " " .. lognames.actions.haslowmoral[chars_mobs_npcs[j].gender]);
					chars_mobs_npcs[j].rt = math.max(0,chars_mobs_npcs[j].rt - 20);
				end;
			end;
		end;
	end;
	if endbattle then -- end of the battle, counting of exp
		local tmpchars = chars_around;
		letaBattleFinishes ();
		local quater_exp = tmpexp/chars^2;
		local sum_of_tmpexpdmg = 0;
		local sum_of_tmpexplost = 0;
		local sum_of_tmpexpdeaths = 0;
		for i=1,chars do
			sum_of_tmpexpdmg = sum_of_tmpexpdmg+chars_mobs_npcs[i].tmpexpdmg;
			sum_of_tmpexplost = sum_of_tmpexplost+chars_mobs_npcs[i].tmpexplost;
			sum_of_tmpexpdeaths = sum_of_tmpexpdeaths+chars_mobs_npcs[i].tmpexpdeaths;
		end;
		for i=1,chars do
			if sum_of_tmpexpdmg > 0 or sum_of_tmpexplost > 0 or sum_of_tmpexpdeaths > 0 then
				local countedexp=math.ceil(quater_exp+quater_exp*chars_mobs_npcs[i].tmpexpdmg/math.max(1,sum_of_tmpexpdmg)+quater_exp*chars_mobs_npcs[i].tmpexplost/math.max(1,chars_mobs_npcs[i].tmpexplost)+quater_exp*chars_mobs_npcs[i].tmpexpdeaths/math.max(1,sum_of_tmpexpdeaths));
				chars_stats[i].xp = chars_stats[i].xp+countedexp;
				helpers.addToActionLog( chars_stats[i].name .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. countedexp .. lognames.actions.ofexp);
				chars_mobs_npcs[i].tmpexpdmg = 0;
				chars_mobs_npcs[i].tmpexplost = 0;
				chars_mobs_npcs[i].tmpexpdeaths = 0;
			end;
		end;
	end;
	if not helpers.partyAlive () then
		game_status = "gameover";
	end;
end;

function damage.meleeAttack (attacking_hand) -- FIXME attack with what? RH,LH,(RH2,LH2,RH3,LH3),teeth,tail,horns
	utils.printDebug("attack!");
	global.hex = 1;
	if chars_mobs_npcs[current_mob].control == "player" and global.status == "peace" then
		letaBattleBegin ();
	end;
	if global.multiattack > 0 then
		global.multiattack = global.multiattack -1;
	end;
	victim = previctim;
	wheeled = 0;
	local agressor_name = helpers.mobName(current_mob);
	local victim_name = helpers.mobName(victim);
	dodge=0;
	block=0;
	hands = 0;
	parry=0;
	local crit = 0;
	local wpEffect,wpChance = damage.weaponPassives(current_mob,victim,"melee");
	local array_of_chances = {};
	local chance_to_hit = 0;
	local chance_to_crit = 0;
	local chance_to_dodge = 0;
	local chance_to_hands = 0;
	local chance_to_block = 0;
	local chance_to_parry = 0;
	local chance_to_handblock = 0;
	local random_chance = 0;
	local block_dir_coff = 0;
	local hitzone = 0;
	local AC = 0;
	local DT = 0;
	local DR = 0;
	local recovery = 0;
	local tmp = 0;
	local dmghp = 0;
	local dmgsp = 0;
	local dmgrt = 0;
	local dmgst = 0;
	local add_dmghp = 0;
	local alldmg = 0;
	local debuff = 0;
	local debuffdur = 1;
	local debuffdur2 = 1;
	local dotdur = 0;
	local dotpower = 0;
	local total_fate = 0;
	local hitResult = 0;
	local fulldamage = 0;
	local incoming_physical_dmg = 0;
	local delta_spd = 0;
	local bodyArmorPieces = {armor=0,belt=0,cloak=0};
	local handsMod = 1;
	local add_effect_st = 0;
	local _shored_index = helpers.ifUmbrella (); --shore trick (dodging skill)
	local whoshored = victim;
	local selfadd_hp = 0;
	local selfadd_sp = 0;
	local selfadd_st = 0;
	local selfadd_rt = 0;
	local selfrem_hp = 0;
	local selfrem_sp = 0;
	local selfrem_st = 0;
	local selfrem_rt = 0;
	if helpers.mobCanDefendHimself (victim) and _shored_index then
		if _shored_index > 1 then
			victim = _shored_index;
			point_to_go_x = chars_mobs_npcs[victim].x;
			point_to_go_y = chars_mobs_npcs[victim].y;
			helpers.turnMob (current_mob);
			chars_mobs_npcs[whoshored].trick = "none";
			chars_mobs_npcs[whoshored].protectionmode = "none";
			helpers.addToActionLog(helpers.mobName(whoshored) .. lognames.actions.hasshored[chars_mobs_npcs[whoshored].gender] .. helpers.mobName(vicitm));
		end;
	end;
	
	if helpers.MeleeMissle(missle_type) then --FIXME
		add_effect_st = tricks.tricks_tips[missle_type].stamina;			
	end;
	
	local currentMobWeaponClass,currentMobWeaponSubClass = damage.weaponClassInHand(current_mob,attacking_hand);
	helpers.recalcBattleStats (current_mob);
	local rings = boomareas.ringArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
	for i=1,6 do
		if chars_mobs_npcs[victim].x == rings[1][i].x and chars_mobs_npcs[victim].y == rings[1][i].y then
			atk_anim = i;
		end;
	end;
	local attacked_from = helpers.attackDirection(current_mob,victim);
	if helpers.mobCanDefendHimself (victim) and chars_mobs_npcs[victim].immobilize == 0 then
		delta_spd = chars_mobs_npcs[current_mob].spd + chars_mobs_npcs[victim].spd;
	else
		delta_spd = 100;
	end;
	helpers.recalcBattleStats (current_mob);
	chance_not_to_miss = math.ceil(50*helpers.sizeModifer(victim))+chars_mobs_npcs[current_mob]["melee_stats"][attacking_hand].atkm+(chars_mobs_npcs[current_mob].spd-chars_mobs_npcs[victim].spd)+chars_mobs_npcs[current_mob].acu + delta_spd;
	chance_to_hit_norandom = math.ceil(chance_not_to_miss*(chars_mobs_npcs[current_mob].leye + chars_mobs_npcs[current_mob].reye)/2);
	utils.randommore ();
	random_chance = math.random(1,100)-50;
	total_fate = chars_mobs_npcs[current_mob].fateself + chars_mobs_npcs[victim].fate - (chars_mobs_npcs[victim].fateself + chars_mobs_npcs[current_mob].fate);
	chance_to_hit = chance_to_hit_norandom + random_chance + total_fate + chars_mobs_npcs[current_mob].rage;
	if missle_type == "slash" then
		chance_to_hit = math.ceil(chance_to_hit/2);
	elseif missle_type == "smash" then
		chance_to_hit = math.ceil(chance_to_hit/3);
	elseif missle_type == "scullcrusher" then
		chance_to_hit = math.ceil(chance_to_hit/4);
	elseif missle_type == "lunge" then	
		chance_to_hit = math.ceil(chance_to_hit*2);
	end;
	chars_mobs_npcs[current_mob].fate = 0;
	chars_mobs_npcs[current_mob].fateself = 0;
	chars_mobs_npcs[victim].fate = 0;
	chars_mobs_npcs[victim].fateself = 0;
	chance_to_crit = math.ceil((chars_mobs_npcs[current_mob].luk-chars_mobs_npcs[victim].luk)/10); --FIX add weapon mastery
	if attacked_from == "back" then
		chance_to_crit = chance_to_crit*2;
	end;
	if missle_type == "vilehit" and (attacked_from == "back" or attacked_from == "rback" or attacked_from == "lback") then
		chance_to_crit = chance_to_crit*5;
	end;
	if missle_type == "lunge" then
		chance_to_crit = chance_to_crit*2;
	end;
	if chance_to_hit <= 0 then
		iflucky = 0;
		love.audio.play(media.sounds.sword_miss,0);
		helpers.addToActionLog( agressor_name .. lognames.actions.atk[chars_mobs_npcs[current_mob].gender] .. victim_name .. lognames.actions.miss[chars_mobs_npcs[current_mob].gender]);
	else
		iflucky = 1;
		utils.randommore ();
		hitzone = chars_mobs_npcs[victim]["hitzones"][global.hex][math.random(1,#chars_mobs_npcs[victim]["hitzones"][global.hex])];	
		if missle_type == "scullcrusher" and helpers.mobHasHitZoneAtHex(victim,global.hex,"head") then
			hitzone = "head";
			incoming_physical_dmg = math.ceil(incoming_physical_dmg*10);
		elseif missle_type == "woodcutter" and helpers.randomLimb(victim,global.hex,true) then
			hitzone = helpers.randomLimb(victim,global.hex);
		elseif (missle_type == "stomachhit" or missle_type == "ribbraker" or missle_type == "impale" or missle_type == "vilehit" or missle_type == "bitsouloutr") and helpers.mobHasHitZoneAtHex(victim,global.hex,"body") then
			hitzone = "body";
		elseif missle_type == "oblivion" and helpers.mobHasHitZoneAtHex(victim,global.hex,"head") then
			hitzone = "head";
		elseif missle_type == "stunner"  then
			if helpers.mobHasHitZoneAtHex(victim,global.hex,"head") then
				hitzone = "head";
			elseif helpers.mobHasHitZoneAtHex(victim,global.hex,"body") then
				hitzone = "body";
			end;
		end;
		local might_modifer = damage.mightModifer(current_mob,attacking_hand);
	--DAMAGE
		incoming_physical_dmg = damage.countDamage(current_mob,attacking_hand,nil);
		if missle_type == "slash" then
			incoming_physical_dmg = math.ceil(incoming_physical_dmg*3);
		elseif missle_type == "smash" then
			incoming_physical_dmg = math.ceil(incoming_physical_dmg*5);
		elseif missle_type == "lunge" then	
			incoming_physical_dmg = math.ceil(incoming_physical_dmg*1.5);
		end;	
	-- DODGE
	
		if chars_mobs_npcs[victim].num_dodging > 0 and helpers.mobCanDefendHimself (victim) and missle_type ~= "feint" and missle_type ~= "smarthit" then
			
			chance_to_dodge = math.ceil(chars_mobs_npcs[victim].dex/5)+chars_mobs_npcs[victim].num_dodging*chars_mobs_npcs[victim].lvl_dodging;
			if chars_mobs_npcs[victim].lvl_dodging >= 4 and chars_mobs_npcs[victim]["equipment"].cloak > 0 
			and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].cloak].q > 0 then
				chance_to_dodge = chance_to_dodge + inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].cloak].ttxid].dg; -- +CLOAK
			end;
			if chars_mobs_npcs[victim].lvl_dodging < 3
			and chars_mobs_npcs[victim]["equipment"].armor > 0
			and  (inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].subclass == "leather"
			or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].subclass == "fur"
			or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].subclass == "skin"
			) then
				chance_to_dodge = 0;
			elseif chars_mobs_npcs[victim].lvl_dodging < 4
			and chars_mobs_npcs[victim]["equipment"].armor > 0
			and  inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].subclass == "chain" 
			then
				chance_to_dodge = 0;
			elseif chars_mobs_npcs[victim].lvl_dodging < 5
			and chars_mobs_npcs[victim]["equipment"].armor > 0
			and  inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].subclass == "plate" 
			then
				chance_to_dodge = 0;
			end;
			local dodge_dir_coff=0
			if attacked_from=="front" then
				dodge_dir_coff=1;
			elseif attacked_from=="lh" then
				dodge_dir_coff=1;
			elseif attacked_from=="rh" then
				dodge_dir_coff=1;
			elseif attacked_from=="lback" then
				dodge_dir_coff=0.75;
			elseif attacked_from=="rback" then
				dodge_dir_coff=0.75;
			elseif attacked_from=="back" then
				dodge_dir_coff=0.5;
			end;
			chance_to_dodge = chance_to_dodge*dodge_dir_coff;
			if chars_mobs_npcs[victim].protectionmode == "block" then
				chance_to_dodge = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "hands" then
				chance_to_dodge = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "dodge" then
				chance_to_dodge = chance_to_dodge*2;
			end;
			if chars_mobs_npcs[victim].protectionmode == "parry" then
				chance_to_dodge = 0;
			end;
		end;
		if chance_to_dodge > 0 then
			for i=1,chance_to_dodge do
				array_of_chances[i] = "dodge";	
			end;
		end;
	--/DODGE
	--HANDBLOCK --ONLY for arms == 2, so no Sheevas!
		if missle_type ~= "feint" and missle_type ~= "smarthit" then
			if attacked_from=="front" then
				hands_dir_coff=1;
			elseif attacked_from=="lh" then
				hands_dir_coff=1;
			elseif attacked_from=="rh" then
				hands_dir_coff=1;
			elseif attacked_from=="lback" then
				hands_dir_coff=0;
			elseif attacked_from=="rback" then
				hands_dir_coff=0;
			elseif attacked_from=="back" then
				hands_dir_coff=0;
			end;
			if helpers.mobHasHandblock (victim) and helpers.mobCanDefendHimself (victim)
			and chars_mobs_npcs[victim].lvl_unarmed >= 2
			and helpers.mobHasHealthyHands(victim) > 0
			and (chars_mobs_npcs[current_mob]["equipment"][attacking_hand] == 0 or currentMobWeaponClass == "claws" or currentMobWeaponClass == "knuckle" or currentMobWeaponClass == "tentacle" or currentMobWeaponClass == "nipper")
			and helpers.mobCanDefendHimself(victim) then
				chance_to_hands = chars_mobs_npcs[victim].lvl_unarmed*chars_mobs_npcs[victim].num_unarmed*hands_dir_coff;	
			end;	
			if helpers.mobHasHandblock (victim) and helpers.mobCanDefendHimself (victim)
			and chars_mobs_npcs[victim].lvl_unarmed >= 3
			and helpers.mobHasHealthyHands(victim) > 0
			and chars_mobs_npcs[current_mob]["equipment"][attacking_hand] > 0 and (currentMobWeaponClass == "staff" or currentMobWeaponClass == "club" or currentMobWeaponClass == "dagger" )
			and helpers.mobCanDefendHimself (victim) then
				chance_to_hands = chars_mobs_npcs[victim].lvl_unarmed*chars_mobs_npcs[victim].num_unarmed*hands_dir_coff;
			end;
			if helpers.mobHasHandblock (victim) and helpers.mobCanDefendHimself (victim)
			and chars_mobs_npcs[victim].lvl_unarmed >= 3
			and helpers.mobHasHealthyHands(victim) > 0
			and chars_mobs_npcs[current_mob]["equipment"][attacking_hand] > 0 and currentMobWeaponClass == "flagpole"
			and helpers.mobCanDefendHimself (victim) then
				chance_to_hands = chars_mobs_npcs[victim].lvl_unarmed*chars_mobs_npcs[victim].num_unarmed*hands_dir_coff;
			end;
			if helpers.mobHasHandblock (victim) and helpers.mobCanDefendHimself (victim)
			and chars_mobs_npcs[victim].lvl_unarmed == 5
			and helpers.mobHasHealthyHands(victim) > 0
			and chars_mobs_npcs[current_mob]["equipment"][attacking_hand] > 0 and currentMobWeaponClass == "sword" and currentMobWeaponSubClass ~= "thsword"
			and helpers.mobCanDefendHimself (victim) then
				chance_to_hands = chars_mobs_npcs[victim].lvl_unarmed*chars_mobs_npcs[victim].num_unarmed*hands_dir_coff;
			end;
			if chars_mobs_npcs[victim].protectionmode == "block" then
				chance_to_hands = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "hands" then
				chance_to_hands = chance_to_hands*2;
			end;
			if chars_mobs_npcs[victim].protectionmode == "dodge" then
				chance_to_hands = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "parry" then
				chance_to_hands = 0;
			end;
			if chars_mobs_npcs[victim].mgt*1.5 < chars_mobs_npcs[current_mob].mgt then
				chance_to_hands = 0;
			end;
			if wpEffect == "deblock" and wpChance > math.random(1,100) then
				chance_to_hands = 0;
				helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.deblocked[chars_mobs_npcs[current_mob].gender]);
			end;
			if chance_to_hands > 0 then
				for i=#array_of_chances+1,chance_to_hands do
					array_of_chances[i] = "hands";	
				end;
			end;
		end;
	--/HANDBLOCK
	
	local _protector_index = helpers.ifUmbrella (); --umbrella trick (shield skill)
	local formervictim = victim; 
	if helpers.mobCanDefendHimself (victim) and _protector_index then
		if _protector_index > 1 then
			victim = _protector_index[1];
			point_to_go_x = chars_mobs_npcs[victim].x;
			point_to_go_y = chars_mobs_npcs[victim].y;
			helpers.turnMob (current_mob);
		else
			local _x = chars_mobs_npcs[victim].x;
			local _y = chars_mobs_npcs[victim].y;
			chars_mobs_npcs[victim].x = chars_mobs_npcs[_protector_index[1]].x;
			chars_mobs_npcs[victim].y = chars_mobs_npcs[_protector_index[1]].y;
			chars_mobs_npcs[_protector_index[1]].x = _x;
			chars_mobs_npcs[_protector_index[1]].y = _y;
			victim = _protector_index[1];
		end;
		chars_mobs_npcs[victim].trick = "none";
		chars_mobs_npcs[victim].protectionmode = "none";
		chars_mobs_npcs[victim].rot = helpers.antiDirection(chars_mobs_npcs[current_mob].rot);
		helpers.addToActionLog(helpers.mobName(victim) .. lognames.actions.covered[chars_mobs_npcs[victim].gender] .. helpers.mobName(formervictim));
	end;
	
	--BLOCK --only for two arms!
		if chars_mobs_npcs[victim]["equipment"].lh > 0 and helpers.mobCanDefendHimself (victim)
		and inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].class == "shield"
		and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q > 0
		and helpers.mobCanDefendHimself (victim) and chars_mobs_npcs[victim]["arms_health"].lh > 0 
		and missle_type ~= "feint" and missle_type ~= "smarthit" 
		then
			local block_dir_coff=0
			if attacked_from=="front" then
				block_dir_coff=1;
			elseif attacked_from=="lh" then
				block_dir_coff=1;
			elseif attacked_from=="rh" then
				block_dir_coff=0.75;
			elseif attacked_from=="lback" then
				block_dir_coff=0.5;
			elseif attacked_from=="rback" then
				block_dir_coff=0;
			elseif attacked_from=="back" then
				block_dir_coff=0;
			end;
			chance_to_block = block_dir_coff*(math.ceil(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].ac+chars_mobs_npcs[victim].num_shield*chars_mobs_npcs[victim].lvl_shield)-chars_mobs_npcs[current_mob]["melee_stats"][attacking_hand].atkm);
			if wpEffect == "deblock" and wpChance > math.random(1,100) then
				chance_to_block = 0;
				helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.deblocked[chars_mobs_npcs[current_mob].gender]);
			end;
			utils.randommore ();
			random_chance = math.random(1,100);
			
			if chars_mobs_npcs[victim].protectionmode == "block" then
				chance_to_block = chance_to_block*2;
			end;
			if chars_mobs_npcs[victim].protectionmode == "hands" then
				chance_to_block = 0;
			end
			if chars_mobs_npcs[victim].protectionmode == "dodge" then
				chance_to_block = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "parry" then
				chance_to_block = 0;
			end;
			if chars_mobs_npcs[victim].mgt*3 < chars_mobs_npcs[current_mob].mgt then
				chance_to_block = 0;
			end;
			if chance_to_block > 0 then
				for i=#array_of_chances+1,chance_to_block do
					array_of_chances[i] = "block";	
				end;
			end;
		end;
	--/BLOCK
	--PARRY --and nagas? -- need cycle for 4- and 6- handed creatures
		if helpers.mobCanDefendHimself (victim) -- RIGHT HAND
		and chars_mobs_npcs[victim]["equipment"].rh > 0 and chars_mobs_npcs[victim]["arms_health"][chars_mobs_npcs[victim]["arms"][1]] > 0 
		and (inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "sword"
		or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "flagpole"
		or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "dagger"
		or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "staff"
		or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].subclass == "hetchet")
		and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].q > 0
		and (attacked_from == "front" or attacked_from == "rh" or attacked_from == "lh") 
		and missle_type ~= "feint" and missle_type ~= "smarthit"
		then
			if inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "sword" then
				if chars_mobs_npcs[victim].lvl_sword > 1 then
					chance_to_parry = chars_mobs_npcs[victim].num_sword;
				end;
			end;
			if inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "dagger" then
				if chars_mobs_npcs[victim].lvl_dagger > 3 then
					chance_to_parry = chars_mobs_npcs[victim].num_dagger;
				end;
			end;
			if inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "staff" then
				if chars_mobs_npcs[victim].lvl_staff > 1 then
					chance_to_parry = chars_mobs_npcs[victim].num_staff;
				end;
			end;
			if inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "spear" and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q == 0 then
				if chars_mobs_npcs[victim].lvl_spear > 3 then
					chance_to_parry = chars_mobs_npcs[victim].num_spear;
				end;
			end;
			if (inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].subclass == "hetchet" or inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].subclass == "poleaxe") and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q == 0 then
				if chars_mobs_npcs[victim].lvl_axe > 1 then
					chance_to_parry = chars_mobs_npcs[victim].num_axe;
				end;
			end;
			if chars_mobs_npcs[victim].protectionmode == "block" then
				chance_to_parry = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "hands" then
				chance_to_parry = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "dodge" then
				chance_to_parry = 0;
			end;
			if chars_mobs_npcs[victim].protectionmode == "parry" then
				chance_to_parry = chance_to_parry*2;
			end;
			if chars_mobs_npcs[victim].mgt*2 < chars_mobs_npcs[current_mob].mgt then
				chance_to_parry = 0;
			end;
		end;
		if chance_to_parry > 0 then
			for i=#array_of_chances+1,chance_to_parry do
				array_of_chances[i] = "parrr";	
			end;
		end;
		if  helpers.mobCanDefendHimself (victim) -- LEFT HAND
		and chars_mobs_npcs[victim]["arms_health"][chars_mobs_npcs[victim]["arms"][2]] > 0  and chars_mobs_npcs[victim]["equipment"].lh > 0 and (inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].class == "sword" or
		inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].class == "dagger")
		and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q > 0
		and (attacked_from == "front" or attacked_from == "rh" or attacked_from == "lh")
		and helpers.mobCanDefendHimself (index) then
			if chars_mobs_npcs[victim].lvl_sword > 1 then
				chance_to_parry = chars_mobs_npcs[victim].num_sword;
			end;
			if inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].class == "dagger" then
				if chars_mobs_npcs[victim].lvl_dagger > 3 then
					chance_to_parry = chars_mobs_npcs[victim].num_dagger;
				end;
			end;
		end;
		if chance_to_parry > 0 then
			for i=#array_of_chances+1,chance_to_parry do
				array_of_chances[i] = "parrl";	
			end;
		end;
	--/PARRY
	--AC
		local add_ac,add_dt,add_dr = damage.calcArmorStats(victim,hitzone,attacked_from);
		AC = AC + add_ac + chars_mobs_npcs[victim].ac;
		DT = DT + add_dt + chars_mobs_npcs[victim].dt;
		DR = DR + add_dr + chars_mobs_npcs[victim].dr;
		
		if wpEffect == "through" and wpChance > math.random(1,100) then
			AC = 0;
			DT = 0;
			DR = 0;
			helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.armorpenetrated[chars_mobs_npcs[current_mob].gender]);
		end;
		
		if AC > 0 then
			for i=#array_of_chances+1,AC do
				if missle_type ~= "armorpenetration" and missle_type ~= "smarthit" then
					array_of_chances[i] = "ac";
				end;
			end;
		end
		--/AC
		
		--add rings, amulets, artifacts, modifers of armor pieces and melee weapon,
		
		if #array_of_chances > chance_to_hit then
			fulldamage = 0;
			hitResult = array_of_chances[chance_to_hit];
			local _x,_y = helpers.findPlaceBehindAnEnemy (current_mob);
			if (chars_mobs_npcs[victim].trick == "acrobat" and _x ~= 0) then
				hitResult = "dodge";
				chars_mobs_npcs[victim].trick = "none";
				chars_mobs_npcs[victim].x = x;
				chars_mobs_npcs[victim].y = y;
				chars_mobs_npcs[victim].rot = helpers.antiDirection(chars_mobs_npcs[current_mob].rot);
				helpers.addToActionLog(helpers.mobName(victim) .. lognames.actions.fooledwithdodge[chars_mobs_npcs[victim].gender] .. helpers.mobName(current_mob));
			end;
			local armorDmgMod = 1;
			if wpEffect == "destroy" and wpChance > math.random(1,100) then
				armorDmgMod = 2;
			end;
			if hitResult == "dodge" then
				if chars_mobs_npcs[victim].trick == "torero" then
					chars_mobs_npcs[victim].trick = "none";
					chars_mobs_npcs[current_mob].rt = 0;
				end;
				dodge = 1;
				helpers.addToActionLog( victim_name .. lognames.actions.dodge[chars_mobs_npcs[current_mob].gender]);
			elseif hitResult == "hands" then
				--hammerhands and self-damage		
				helpers.addToActionLog( victim_name .. lognames.actions.block[chars_mobs_npcs[current_mob].gender]);
				hands = 1;
				local incoming_physical_dmg_before_armor = incoming_physical_dmg;
				incoming_physical_dmg = incoming_physical_dmg - DT;
				incoming_physical_dmg = incoming_physical_dmg*DR/100;
				if incoming_physical_dmg < 0 then
					incoming_physical_dmg = 0;
				end;
				local deltaDMG = incoming_physical_dmg_before_armor - incoming_physical_dmg;
				if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].h == 0 and inventory[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].ttxid].material < deltaDMG then
					chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].q - deltaDMG;
					if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].q == 0 then
						--gloves destroyed
					end;
				end;	
			elseif hitResult == "block" then
				love.audio.play(media.sounds.block,0);		
				helpers.addToActionLog( victim_name .. lognames.actions.block[chars_mobs_npcs[current_mob].gender]);
				if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].h == 0 then
					chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q - math.max(0,math.abs(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].material-incoming_physical_dmg*armorDmgMod));
					if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q == 0 then
						--shield destroyed
					end;
					if chars_mobs_npcs[victim].trick == "bump" then
						chars_mobs_npcs[victim].trick = "none";
						local x,y = helpers.findPlaceBehindAnEnemy (current_mob);
						if x ~= 0 then
							chars_mobs_npcs[current_mob].x = x;
							chars_mobs_npcs[current_mob].y = y;
							chars_mobs_npcs[victim].rot = helpers.antiDirection(chars_mobs_npcs[current_mob].rot);
							helpers.addToActionLog(helpers.mobName(victim) .. lognames.actions.bumpedwithshield[chars_mobs_npcs[victim].gender] .. helpers.mobName(current_mob));
						end;
					end;
					if chars_mobs_npcs[victim].trick == "ribhit" then
						chars_mobs_npcs[victim].trick = "none";
						chars_mobs_npcs[current_mob].rt = 0;
						chars_mobs_npcs[current_mob].stun = chars_mobs_npcs[victim].lv_shield;
						helpers.addToActionLog(helpers.mobName(victim) .. lognames.actions.hitedwithshield[chars_mobs_npcs[victim].gender] .. helpers.mobName(current_mob));
					end;
				end;
				block = 1;
			elseif hitResult == "parrr" then --victim with 4/6 hands?
				if  chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].h then
					chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].q - math.max(0,math.abs(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].ttxid].material-incoming_physical_dmg));
					if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].rh].q == 0 then
						--weapon destroyed
					end;
				end;
				if chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][attacking_hand]].h == 0 then
					chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][attacking_hand]].q = chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][attacking_hand]].q - math.max(0,math.abs(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"][attacking_hand]].ttxid].material-incoming_physical_dmg*armorDmgMod));
					if chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][attacking_hand]].q then
						--weapon destroyed	
					end;
				end;
				helpers.addToActionLog( victim_name .. lognames.actions.parry[chars_mobs_npcs[current_mob].gender]);
				parry = 1;
			elseif hitResult == "parrl" then --victim with 4/6 hands?
				if  chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].h then
					chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q - math.max(0,math.abs(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].ttxid].material-incoming_physical_dmg));
					if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].lh].q == 0 then
						--weapon destroyed
					end;
				end;
				if chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][attacking_hand]].h == 0 then
					chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][attacking_hand]].q = chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][attacking_hand]].q - math.max(0,math.abs(inventory_ttx[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"][attacking_hand]].ttxid].material-incoming_physical_dmg*armorDmgMod));
					if chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][attacking_hand]].q then
						--weapon destroyed	
					end;
				end;
				helpers.addToActionLog( victim_name .. lognames.actions.parry[chars_mobs_npcs[current_mob].gender]);
				parry = 1;
			elseif hitResult == "ac" then
				local incoming_physical_dmg_before_armor = incoming_physical_dmg;
				incoming_physical_dmg = incoming_physical_dmg - DT;
				incoming_physical_dmg = incoming_physical_dmg*DR/100;
				if incoming_physical_dmg < 0 then
					incoming_physical_dmg = 0;
				end;
				local deltaDMG = incoming_physical_dmg_before_armor - incoming_physical_dmg;
				if missle_type == "nutchopper" then
					deltaDMG = deltaDMG*chars_mobs_npcs[current_mob].lvl_axe+chars_mobs_npcs[current_mob].num_axe;
				end;
				damage.armorDestroying (hitzone,attacked_from,deltaDMG);
				--
			end;
		else
			fulldamage = 1;
		end;
		if hitResult == "ac" or fulldamage == 1 then
			--CRIT
			utils.randommore ();
			random_chance = math.random(1,100);
			if chance_to_crit >= random_chance then
				crit = 2;
				love.audio.play(media.sounds.sword_crit,0);
			elseif chance_to_crit < random_chance then
				crit = 1;
				love.audio.play(media.sounds.sword_impact,0);
			end;
			--/CRIT
			incoming_physical_dmg = incoming_physical_dmg*crit;
			incoming_physical_dmg = math.ceil(math.max(0,incoming_physical_dmg - chars_mobs_npcs[victim].ironshirt_power)*(100-chars_mobs_npcs[victim].stoneskin_power)/100);
			if wpEffect == "bleeding" and wpChance > math.random(1,100) then
				chars_mobs_npcs[victim].bleeding = 	chars_mobs_npcs[victim].bleeding + math.random(1,10);
				helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[current_mob].gender]);
			end;
			if wpChance > math.random(1,100) then
				damage.weaponpEffect(victim,hitzone,wpEffect); -- weapon passives
				if missle_type == "woodcutter" and helpers.randomLimb(victim,global.hex,true) then
					damage.weaponpEffect(victim,hitzone,"chop");	
				end;
			end;
			local mob_genocide = 1;
			--tricks
			if missle_type == "stunner" then
				if helpers.aliveNature(victim) and chars_mobs_npcs[victim].stun == 0 and chars_mobs_npcs[victim].sleep == 0 then
					chars_mobs_npcs[victim].stun = chars_mobs_npcs[current_mob].lvl_crushing; 
				end;
			elseif missle_type == "decapitator" and chars_mpbs_npcs[victm].hp/chars_mpbs_npcs[victm].hp_max*100 <= 10 then
				damage.HPminus(victm,chars_mpbs_npcs[victm].hp,true);
			elseif missle_type == "coupdegrace" and chars_mpbs_npcs[victm].hp/chars_mpbs_npcs[victm].hp_max*100 <= 25 and (chars_mpbs_npcs[victm].paralyze > 0 or chars_mpbs_npcs[victm].stun > 0 or chars_mpbs_npcs[victm].sleep > 0 or chars_mpbs_npcs[victm].immobilize > 0) then
				damage.HPminus(victm,chars_mpbs_npcs[victm].hp,true);
			elseif missle_type == "stomachhit" then
				if helpers.aliveNature(victim) then
					chars_mobs_npcs[victim].rt = math.min(50,chars_mobs_npcs[current_mob].rt); 
				end;
			elseif missle_type == "sleepfinger" then
				if helpers.aliveNature(victim) and chars_mobs_npcs[victim].stun == 0 and chars_mobs_npcs[victim].sleep == 0 then
					chars_mobs_npcs[victim].sleep = chars_mobs_npcs[current_mob].lvl_unarmed; 
				end;
			elseif missle_type == "impale" then
				if helpers.aliveNature(victim) then
					chars_mobs_npcs[victim].pneumothorax = 1; 
				end;
			elseif missle_type == "pin" then
				chars_mobs_npcs[victim].immobilize = chars_mobs_npcs[current_mob].lvl_flagpole;
			elseif missle_type == "bitsoulout" then	
				if helpers.aliveNature(victim) then
					chars_mobs_npcs[victim].rt = 0; 
				end;
			elseif missle_type == "ribbreaker" then
				if helpers.aliveNature(victim) then
					chars_mobs_npcs[victim].st = math.min(50,chars_mobs_npcs[current_mob].st);  
				end;
			elseif missle_type == "spinalshock" then
				if helpers.aliveNature(victim) and chars_mobs_npcs[victim].stun == 0 and chars_mobs_npcs[victim].sleep == 0 then
					chars_mobs_npcs[victim].paralyze = chars_mobs_npcs[current_mob].lvl_crushing; 
				end;
			elseif missle_type == "backstab" then
				chars_mobs_npcs[victim].rt = 0;
				chars_mobs_npcs[victim].charm = chars_mobs_npcs[current_mob].lvl_staff;
			elseif missle_type == "oblivion" then
				chars_mobs_npcs[victim].sp = math.max(0,chars_mobs_npcs[victim].sp - math.ceil(chars_mobs_npcs[victim].sp*0.25));
				chars_mobs_npcs[victim].feeblemind = chars_mobs_npcs[current_mob].lvl_staff;
			elseif missle_type == "deafen" then	
				chars_mobs_npcs[victim].stun = chars_mobs_npcs[current_mob].lvl_staff;
			elseif missle_type == "bloodyhit" then
				if helpers.traumaNature(victim) then
					chars_mobs_npcs[victim].bleeding = chars_mobs_npcs[victim].bleeding + chars_mobs_npcs[current_mob].lvl_dagger;
				end;
			end;
			--weapon modifers
			if chars_mobs_npcs[current_mob]["equipment"][attacking_hand] > 0 and chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][attacking_hand]].w > 0 then			
				if chars_mobs_npcs[current_mob]["equipment"][attacking_hand] > 0 then
						--damage
					for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][attacking_hand]].w].damage) do
						local dmg = damage.magicalRes (victim,value[value],value[element]);
						if key == "hp" then
							add_dmghp = dmg;
							if value[vampirism] then
								selfadd_hp = selfaddhp + math.ceil(dmg*value[vampirism_power]);
							end;
						elseif key == "sp" then 
							dmgsp = dmg;
							if value[vampirism] then
								selfadd_sp = selfaddsp + math.ceil(dmg*value[vampirism_power]);
							end;
						elseif key == "st" then
							dmgst = dmg;
							if value[vampirism] then
								selfadd_st = selfaddst + math.ceil(dmg*value[vampirism_power]);
							end;
						elseif key == "rt" then 
							dmgrt = dmg;
							if value[vampirism] then
								selfadd_rt = selfaddrt + math.ceil(dmg*value[vampirism_power]);
							end;
						end;
					end;
					--/damage
					--dots
					for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][attacking_hand]].w].dots) do
						local power,duration = damage.applyDoT (victim,value[lvl],value[num],1,0,1,0,value[element],true);
						if power > 0 and suration > 0 then
							local power_str = tostring(key) .. "_power";
							local duration_str = tostring(key) .. "_dur";
							chars_mobs_npcs[victim][power_str] = math.max(power,chars_mobs_npcs[victim][power_str]);
							chars_mobs_npcs[victim][duration_str] = math.max(duration,chars_mobs_npcs[victim][duration_str]);
						end;
					end;
					--/dots
					--conditions
					for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][attacking_hand]].w].conditions) do
						local power = damage.applyCondition (victim,value[lvl],value[num],value[element],false,false,1,true);
						if power > 0 then
							chars_mobs_npcs[victim][tostring(key)] = math.max(power,chars_mobs_npcs[victim][tostring(key)]);
						end;
					end;
					--/conditions
					--twofactorconditions
					for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][attacking_hand]].w].twofactorconditions) do
						local power,duration = damage.applyDoT (victim,value[lvl],value[num],tostring(key),value[element],false,false,1,true);
						if power > 0 and suration > 0 then
							local power_str = tostring(key) .. "_power";
							local duration_str = tostring(key) .. "_dur";
							chars_mobs_npcs[victim][power_str] = math.max(power,chars_mobs_npcs[victim][power_str]);
							chars_mobs_npcs[victim][duration_str] = math.max(duration,chars_mobs_npcs[victim][duration_str]);
						end;
					end;
					--/twofactorconditions
					--addself
					for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][attacking_hand]].w].addself) do
						local dmg = damage.magicalRes (victim,value[value],value[element]);
						if key == "hp" then
							selfadd_hp = selfaddhp + value;
						elseif key == "sp" then 
							selfadd_sp = selfaddsp + value;
						elseif key == "st" then
							selfadd_st = selfaddst + value;
						elseif key == "rt" then 
							selfadd_rt = selfaddrt + value;
						end;
					end;
					--/selfadd
					--selfrem
					for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][attacking_hand]].w].remself) do
						local dmg = damage.magicalRes (victim,value[value],value[element]);
						if key == "hp" then
							selfrem_hp = selfremhp + value;
						elseif key == "sp" then 
							selfrem_sp = selfremsp + value;
						elseif key == "st" then
							selfrem_st = selfremst + value;
						elseif key == "rt" then 
							selfrem_rt = selfremrt + value;
						end;
					end;	
					--/selfrem
					--genocide
					for key,value in pairs (items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][attacking_hand]].w].genocide) do
						if key == mobs_stats[chars_mobs_npcs[victim].class]
						or key == mobs_stats[chars_mobs_npcs[victim].race]
						or key == mobs_stats[chars_mobs_npcs[victim].size]
						or key == mobs_stats[chars_mobs_npcs[victim].nature]
						or key == mobs_stats[chars_mobs_npcs[victim].gender]
						then
							mob_genocide = value;
							break;
						end;
					end;
					--/genocide
				end;	
			end;
			dmghp = incoming_physical_dmg*mob_genocide + add_dmghp;
			--/weapon modifers
			if chars_mobs_npcs[current_mob].executor_dur > 0 and chars_mobs_npcs[current_mob].size == "giant" then
				dmghp = dmghp+math.ceil(dmghp*(chars_mobs_npcs[current_mob].executor_power/20));
			end;
			if chars_mobs_npcs[victim].hp > 0 then
				damage.mobDamaged (victim,current_mob,dmghp);
				boomareas.bloodGround (chars_mobs_npcs[victim].x,chars_mobs_npcs[victim].y);
				if crit ==1 then
					helpers.addToActionLog( agressor_name .. lognames.actions.atk[chars_mobs_npcs[current_mob].gender] .. victim_name .. lognames.actions.dmg[chars_mobs_npcs[current_mob].gender] .. " " .. dmghp .. lognames.actions.metr .. lognames.actions.ofhp);
				else
					helpers.addToActionLog( agressor_name .. lognames.actions.atk[chars_mobs_npcs[current_mob].gender] .. victim_name .. lognames.actions.crit[chars_mobs_npcs[current_mob].gender] .. " " .. dmghp .. lognames.actions.metr .. lognames.actions.ofhp);
				end;
				damage.HPminus(victim,dmghp,false);
				if dmghp > 0 and chars_mobs_npcs[current_mob].thirstofblood > 0 then
					chars_mobs_npcs[current_mob].mgt_buff_power = chars_mobs_npcs[current_mob].thirstofblood;
					chars_mobs_npcs[current_mob].mgt_buff_dur = 1;
					chars_mobs_npcs[current_mob].spd_buff_power = chars_mobs_npcs[current_mob].thirstofblood;
					chars_mobs_npcs[current_mob].spd_buff_dur = 1;
					chars_mobs_npcs[current_mob].thirstofblood = chars_mobs_npcs[current_mob].thirstofblood + 3;
				else
					chars_mobs_npcs[current_mob].thirstofblood = 0;
				end;
			end;
			if chars_mobs_npcs[victim].sp > 0 and dmgsp > 0 then
				damage.mobDamaged (victim,current_mob,math.ceil(dmgsp/2));
				chars_mobs_npcs[victim].sp = math.max(0,chars_mobs_npcs[victim].sp - dmgsp);
				helpers.addToActionLog( lognames.actions.lost[chars_mobs_npcs[victim].gender] .. dmgsp .. lognames.actions.metr .. lognames.actions.ofsp);
			end;
			if chars_mobs_npcs[victim].st > 0 and dmgst > 0 then
				damage.mobDamaged (victim,current_mob,math.ceil(dmgst/3));
				chars_mobs_npcs[victim].st =  math.max(0,chars_mobs_npcs[victim].st - dmgst);
				helpers.addToActionLog( lognames.actions.lost[chars_mobs_npcs[victim].gender] .. dmgst .. lognames.actions.metr .. lognames.actions.ofst);
			end;
			if chars_mobs_npcs[victim].rt > 0 and dmgrt > 0 then
				damage.mobDamaged (victim,current_mob,math.ceil(dmgrt/4));
				chars_mobs_npcs[victim].rt =  math.max(0,chars_mobs_npcs[victim].rt - dmgrt);
				helpers.addToActionLog( lognames.actions.lost[chars_mobs_npcs[victim].gender] .. dmgrt .. lognames.actions.metr .. lognames.actions.ofrt);	
			end;
			local alldmg =  math.ceil(dmghp + dmgsp/2 + dmgst/4 + dmgrt/8);
			exp_for_what(alldmg,current_mob);
		end;
	end;
	
	
	local mode,lvl,num,effect,element,stat,skill,coff,luck = damage.classPassives(current_mob);
	if mode and mode == "melee" then
		if algorythm == "2factors" then
			damage.ApplyConditionTwoFactors(current_mob,lvl,num,effect,element,stat,skill,coff,luck);
		elseif algorythm == "1factor" then
			damage.ApplyCondition(current_mob,lvl,num,effect,element,stat,skill,coff,luck);
		elseif algorythm == "simple" then
			if effect == "hp" then
				damage.HPminus(victim,num,true);
			elseif effect == "sp" then
				damage.SPminus(victim,num,true);
			elseif effect == "st" then
				damage.STminus(victim,num,true);
			elseif effect == "rt" then
				damage.RTminus(victim,num,true);
			end;
		elseif algorythm == "vampirism" then
			if effect == "hp" then
				damage.HPplus(current_mob,num,true);
				damage.HPminus(victim,num,true);
			elseif effect == "sp" then
				damage.SPplus(current_mob,num,true);
				damage.SPminus(victim,num,true);
			elseif effect == "st" then
				damage.STplus(current_mob,num,true);
				damage.STminus(victim,num,true);
			elseif effect == "rt" then
				damage.RTplus(current_mob,num,true);
				damage.RTminus(victim,num,true);
			end;
		end;
	end;
	chars_mobs_npcs[current_mob].rot = atk_anim;
	recovery = helpers.countMeleeRecoveryChar (current_mob);
	local thirstofblood =  math.min(10,chars_mobs_npcs[current_mob].thirstofblood);
	chars_mobs_npcs[current_mob].st = chars_mobs_npcs[current_mob].st-recovery - add_effect_st;
	chars_mobs_npcs[current_mob].rt = chars_mobs_npcs[current_mob].rt-recovery + thirstofblood;
	global.timer200 = global.timer200 + recovery;
	
	damage.HPplus(current_mob,selfadd_hp,false);
	damage.SPplus(current_mob,selfadd_sp,false);
	damage.STplus(current_mob,selfadd_st,false);
	damage.RTplus(current_mob,selfadd_rt,false);
	
	damage.HPminus(current_mob,selfrem_hp,false);
	damage.SPminus(current_mob,selfrem_sp,false);
	damage.STminus(current_mob,selfrem_st,false);
	damage.RTminus(current_mob,selfrem_rt,false);
	
	tmp4= chars_mobs_npcs[current_mob].sprite .. "_atk1";
	mob_atk1=loadstring("return " .. tmp4)();
	animation_atk1 = anim8.newAnimation(mob_atk1[atk_anim]("1-8",1), 0.075,"pauseAtEnd");
	--for i=1,#chars_mobs_npcs do
		--helpers.countMoral(i);
	--end;
	a_timer = 0;
	
	if chars_mobs_npcs[victim].holyblood_dur>0 and chars_mobs_npcs[current_mob].nature == "undead" then
		local predmg = damage.magicalRes (current_mob,chars_mobs_npcs[victim].holyblood_power,"light");
		local dmg = predmg;
		if predmg >= chars_mobs_npcs[current_mob].hp then
			dmg = chars_mobs_npcs[current_mob].hp - 1;
		end;
		damage.HPminus(i,dmg,true);
		local power,dur = damage.applyConditionTwoFactors (index,math.random(1,chars_mobs_npcs[victim].holyblood_power),math.random(1,chars_mobs_npcs[victim].holyblood_dur),"holyblood","element",false,false,1,true);
		if power > 0 and dur > 0 then
			chars_mobs_npcs[current_mob].holyblood_power = math.max(chars_mobs_npcs[current_mob].holyblood_power,power);
			chars_mobs_npcs[current_mob].holyblood_power = math.max(chars_mobs_npcs[current_mob].holyblood_dur,dur);
		end;
	end;
	
	local damaged_mobs = {};
	table.insert(damaged_mobs,victim);
	--damage.deathsWatcher(damaged_mobs);
	chars_mobs_npcs[current_mob].rage = 0;
end;

function damage.shoot()
	utils.printDebug("Shoot!");
	--[[if (missle_drive == "spellbook" or missle_drive == "scroll" or missle_drive == "wand") then
		if magic.spell_tips[missle_type].startsbattle then
			letaBattleBegin ();
		end;
	else
		letaBattleBegin ();
	end;]]
	dodge = 0;
	block = 0;
	parry = 0;
	victim = previctim;
	local recovery = 0;
	local add_effect_st = 0;
	local add_effect_rt = 0;
	if victim ~= current_mob and missle_type ~= "inferno" and missle_type ~= "bottle" then  
		delx = shot_line[1][1]-shot_line[#shot_line][1]; --nil FIX: limit distance of fire
		dely = shot_line[1][2]-shot_line[#shot_line][2];
		step = (math.sqrt(delx^2+dely^2))*3;
		add_msl_x = -1*delx/step;
		add_msl_y = -1*dely/step;
		add_to_mslx = shot_line[1][1]-map_x;
		add_to_msly = shot_line[1][2]-map_y;
	end;
	if missle_type == "bottle" then
		delx = shot_line[1][1]-shot_line[#shot_line][1]; --nil FIX: limit distance of fire
		dely = shot_line[1][2]-shot_line[#shot_line][2];
		step = (math.sqrt(delx^2+dely^2))*3;
		add_msl_x = -1*delx/step;
		add_msl_y = -1*dely/step;
		add_to_mslx = shot_line[1][1]-map_x;
		add_to_msly = shot_line[1][2]-map_y;	
	end;
	atk_direction = chars_mobs_npcs[current_mob].view;
	tmpi = "media.images." .. chars_mobs_npcs[current_mob].sprite .. "_base";
	img_base = loadstring("return " .. tmpi)();
	if missle_drive == "muscles" or missle_drive == "alchemy" then
		local recovery = 0;
		if missle_type == "bolt" or missle_type == "arrow" then
			local tmp = chars_mobs_npcs[current_mob].sprite .. "_sht1";
			local mob_sht1 = loadstring("return " .. tmp	)();
			animation_sht1 = anim8.newAnimation(mob_sht1[atk_direction]("1-9",1), 0.075,"pauseAtEnd");
			recovery = helpers.countRangeRecoveryChar (current_mob);
			love.audio.play(media.sounds.crossbow_shot, 0);
		elseif missle_type == "throwing" then
			recovery = helpers.countRangeRecoveryChar (current_mob);
		elseif missle_type == "bottle" then
			local tmp = chars_mobs_npcs[current_mob].sprite .. "_launch";
			local mob_sht1 = loadstring("return " .. tmp)();
			animation_sht1 = anim8.newAnimation(mob_sht1[atk_direction]("1-9",1), 0.075,"pauseAtEnd");
			recovery = helpers.countBottleRecovery (current_mob);
		end;	
		if helpers.RangedMissle(missle_type) then --FIXME
			add_effect_st = tricks.tricks_tips[missle_type].stamina;
			add_effect_rt = tricks.tricks_tips[missle_type].recovery;			
		end;
		damage.STminus(current_mob,recovery+add_effect_st,false);
		damage.RTminus(current_mob,recovery+add_effect_rt,false);
		img_shoot = img_mob_war;
	elseif missle_drive=="spellbook" or missle_drive=="scroll" or missle_drive=="wand" then
		--love.audio.play(sfx.Sounds["spellbook"], 0)
		if magic.spell_tips[missle_type].form == "ball"
		or magic.spell_tips[missle_type].form == "arrow"
		or missle_type == "toxiccloud" then
			local r,g,b,n = magic.spell_tips[missle_type].shader[1],magic.spell_tips[missle_type].shader[2],magic.spell_tips[missle_type].shader[3],magic.spell_tips[missle_type].shader[4];
			local xx,yy = helpers.hexToPixels (chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
			table.insert(lights,{x=chars_mobs_npcs[current_mob].y,y=chars_mobs_npcs[current_mob].x,light=lightWorld.newLight(xx, yy, r, g, b, n),typ="missle"});
			lights[#lights]["light"].setGlowStrength(0.3);
		end;
		local recovery = helpers.countMagicRecovery (current_mob,missle_type,missle_drive);
		chars_mobs_npcs[current_mob].rt = chars_mobs_npcs[current_mob].rt-recovery;
		img_shoot=img_mob_war;
		if missle_drive=="spellbook" then
			tmp6= chars_mobs_npcs[current_mob].sprite .. "_cast1";
			mob_cast1=loadstring("return " .. tmp6)();
			animation_sht1 = anim8.newAnimation(mob_cast1[atk_direction]("1-9",1), 0.075,"pauseAtEnd");
		elseif missle_drive=="scroll" then
			img_shoot=img_mob_war;
			tmp6= chars_mobs_npcs[current_mob].sprite .. "_cast1";
			mob_cast1=loadstring("return " .. tmp6)();
			animation_sht1 = anim8.newAnimation(mob_cast1[atk_direction]("1-9",1), 0.075,"pauseAtEnd");
		elseif missle_drive=="wand" then
			img_shoot=img_mob_war;
			tmp6= chars_mobs_npcs[current_mob].sprite .. "_cast1";
			mob_cast1=loadstring("return " .. tmp6)();
			animation_sht1 = anim8.newAnimation(mob_cast1[atk_direction]("1-9",1), 0.075,"pauseAtEnd");
		elseif missle_type=="trigger" then
		end;
	end;
end;

function damage.instantCast () --FIXME use lvl, num
	utils.printDebug("instant cast called");
	sfx.castSound ();
	helpers.clearBoomLight ();
	draw.shaderIrradiation ();
	local dmg = 0;
	local buff = 0;
	local debuff = 0;
	local areadot = 0;
	local lvl,num = helpers.countBoomNumbers ();
	if missle_type ~= "wizardeye" then
		spellname =	magic.spell_tips[missle_type].title;
	end;
	victim = previctim
	local recovery = helpers.countMagicRecovery (current_mob,missle_type,missle_drive);
	chars_mobs_npcs[current_mob].rt = chars_mobs_npcs[current_mob].rt-recovery;
	
	if missle_type == "heal" then
		prebuff = damage.damageRandomizator(current_mob,1,5)*lvl[1]+num[1]*5;
		buff=math.min(prebuff,math.abs(chars_mobs_npcs[victim].hp_max-chars_mobs_npcs[victim].hp));
		chars_mobs_npcs[victim].hp= chars_mobs_npcs[victim].hp+buff;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( lognames.actions.andrestored[chars_mobs_npcs[current_mob].gender] .. helpers.mobName(victim) .. " " .. buff .. lognames.actions.metr .. lognames.actions.ofhp);
		helpers.mobAtBody (victim);
		if chars_mobs_npcs[victim].hp>0 and mobs_at_hex==0 then
			chars_mobs_npcs[victim].status=1;
		end;
	end;
	
	if missle_type == "restoreundead" then
		prebuff = damage.damageRandomizator(current_mob,1,5)*lvl[1]+num[2]*5;
		buff=math.min(prebuff,math.abs(chars_mobs_npcs[victim].hp_max-chars_mobs_npcs[victim].hp));
		chars_mobs_npcs[victim].hp= chars_mobs_npcs[victim].hp+buff;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( lognames.actions.andrestored[chars_mobs_npcs[current_mob].gender] .. helpers.mobName(victim) .. " " .. buff .. lognames.actions.metr .. lognames.actions.ofhp);
		helpers.mobAtBody (victim);
		if chars_mobs_npcs[victim].hp>0 and mobs_at_hex==0 then
			chars_mobs_npcs[victim].status=1;
		end;
	end;

	if missle_type == "wizardeye" then
		wlandscape[boomy][boomx] = 10;
	end;
	
	if missle_type == "torchlight" then
		chars_mobs_npcs[victim].torchlight_dur = num[1];
		chars_mobs_npcs[victim].torchlight_power = lvl[1];
		local xx,yy = helpers.hexToPixels (chars_mobs_npcs[victim].x,chars_mobs_npcs[victim].y);
		table.insert(lights,{x=chars_mobs_npcs[victim].x,y=chars_mobs_npcs[victim].y,light=lightWorld.newLight(xx, yy, 255, 127, 63, 128),typ="mob",index = victim});
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
	end;

	if missle_type == "charge" then
		prebuff = damage.damageRandomizator(current_mob,1,5)*num[1]+lvl[1]*5;
		buff = math.min(prebuff,math.abs(200-chars_mobs_npcs[victim].rt));
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		damage.RTplus(victim,buff,true);
	end;

	if missle_type == "encourage" then
		prebuff = damage.damageRandomizator(current_mob,1,5)*num[1]+lvl[1]*5;
		buff = math.min(prebuff,math.abs(chars_mobs_npcs[i].st_max-chars_mobs_npcs[victim].st));
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		damage.STplus(victim,buff);
	end;
	
	if missle_type == "executor" then
		buff_dur = lvl[1] + lvl[2];
		buff_power = num[1] + num[2];
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		if chars_mobs_npcs[victim].nature ~= "undead" then
			chars_mobs_npcs[vicim].executor_dur = buff_dur;
			chars_mobs_npcs[vicim].executor_power = buff_power;
		else
			local dmghp = damage.magicalRes (victim,buff_power,"light");
			damage.HPminus(victim,dmghp,true);
			helpers.addToActionLog( lognames.actions.lost[chars_mobs_npcs[current_mob].gender] .. dmghp .. lognames.actions.metr .. lognames.actions.ofhp);
		end;
	end;

	if missle_type == "regeneration" then
		buff = num[1];
		buff2= lvl[1];
		chars_mobs_npcs[victim].regen_dur=buff2;
		chars_mobs_npcs[victim].regen_power=buff;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.regen);
	end;

	if missle_type == "haste" then
		buff = math.ceil((num[1]*lvl[2]+num[1]*lvl[1])/2);
		chars_mobs_npcs[victim].haste = buff;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.inhaste);
	end;
	
	if missle_type == "hour_of_power" then
		buff_dur = chars_mobs_npcs[i].lvl_light + chars_mobs_npcs[i].lvl_spirit;
		buff_power = chars_mobs_npcs[i].num_body + chars_mobs_npcs[i].num_body;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		if helpers.aliveNature(vicim) and chars_mobs_npcs[vicim].hourofpower_dur == 0 then
			chars_mobs_npcs[vicim].hourofpower_dur = buff_dur;
			chars_mobs_npcs[vicim].hourofpower_power = buff_power;
		elseif chars_mobs_npcs[victim].nature == "undead" then
			local dmghp = damage.magicalRes (victim,buff_power,"light");
			damage.HPminus(victim,dmghp,true);
			helpers.addToActionLog( lognames.actions.lost[chars_mobs_npcs[current_mob].gender] .. dmghp .. lognames.actions.metr .. lognames.actions.ofhp);	
		end;
	end;

	if missle_type == "raisedead" then
		local addHP = math.min(chars_mobs_npcs[victim].hp_max,num[1]*lvl[1]);
		local addST = math.min(chars_mobs_npcs[victim].st_max,num[1]*lvl[1]);
		chars_mobs_npcs[victim].status = 1;
		chars_mobs_npcs[victim].hp = addHP;
		chars_mobs_npcs[victim].st = addST;
		chars_mobs_npcs[victim].rt = 200;
		chars_mobs_npcs[victim].nature = "undead";
		chars_mobs_npcs[victim].fraction = "party";
		chars_mobs_npcs[victim].summoned = true;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.raised[chars_mobs_npcs[current_mob].gender]);
	end

	if missle_type == "dash" then
		buff= num[1];
		dur= lvl[1]*10;
		chars_mobs_npcs[victim].dash_power=buff;
		chars_mobs_npcs[victim].dash_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.gotspeed[chars_mobs_npcs[current_mob].gender]);
	end;

	if missle_type	== "might" then
		buff = num[1];
		dur = lvl[1]*10;
		chars_mobs_npcs[victim].might_power=buff;
		chars_mobs_npcs[victim].might_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.gotstrenght[chars_mobs_npcs[current_mob].gender]);
	end;
	
	if missle_type	== "curetrauma" then
		local _total  = lvl[1]*num[1];
		if chars_mobs_npcs[victim].bleeding >= _total then
			buff = buff + _total;
			_total = 0;
		else
			buff = buff + chars_mobs_npcs[victim].bleeding;
			_total = _total - buff;
		end;
		chars_mobs_npcs[victim].bleeding = chars_mobs_npcs[victim].bleeding - buff;
		if chars_mobs_npcs[victim].pneumothorax > 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].pneumothorax = 0;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].leye == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].leye = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].reye == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].reye = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].rh and chars_mobs_npcs[victim].rh == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].rh = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].lh and chars_mobs_npcs[victim].lh == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].lh = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].rh1 and chars_mobs_npcs[victim].rh1 == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].rh1 = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].lh1 and chars_mobs_npcs[victim].lh1 == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].lh1 = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].rh2 and chars_mobs_npcs[victim].rh2 == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].rh2 = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].lh2 and chars_mobs_npcs[victim].lh2 == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].lh2 = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].rf and chars_mobs_npcs[victim].rf == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].rf = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].lf and chars_mobs_npcs[victim].lf == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].lf = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].rf1 and chars_mobs_npcs[victim].rf1 == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].rf1 = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].lf1 and chars_mobs_npcs[victim].lf1 == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].lf1 = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].rf2 and chars_mobs_npcs[victim].rf2 == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].rf2 = 1;
			_total = _total - buff;
		end;
		if chars_mobs_npcs[victim].lf2 and chars_mobs_npcs[victim].lf2 == 0 and _total >= 10 then
			buff = buff+10;
			chars_mobs_npcs[victim].lf2 = 1;
			_total = _total - buff;
		end;
	end;
	
	if missle_type == "invisibility" then
		if not  ai.enemyWatchesTheMob (victim) then
			buff = num[1]
			chars_mobs_npcs[victim].invisibility = buff;
			helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
			helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.invisible[chars_mobs_npcs[current_mob].gender]);
		else
			helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.in_enemies_FOV);
		end;
	end;

	if missle_type == "douse" then
		buff= lvl[1];
		chars_mobs_npcs[victim].flame_dur=math.max(chars_mobs_npcs[victim].flame_dur-buff,0);
		chars_mobs_npcs[victim].firebelt_dur=math.max(chars_mobs_npcs[victim].firebelt_dur-buff,0);
		chars_mobs_npcs[victim].fireprint_dur=math.max(chars_mobs_npcs[victim].firebelt_dur-buff,0);
		chars_mobs_npcs[victim].torch_dur=math.max(chars_mobs_npcs[victim].torch_dur-buff,0);
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.gotdoused[chars_mobs_npcs[current_mob].gender]);
	end;

	if missle_type == "mobility" then
		buff= lvl[1];
		dur= num[1]*lvl[1];
		chars_mobs_npcs[victim].mobility_power=buff;
		chars_mobs_npcs[victim].mobility_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.gotveh[chars_mobs_npcs[current_mob].gender]);
	end;

	if missle_type == "melt" then
		buff= num[1]+num[2];
		local result = chars_mobs_npcs[victim].freeze;
		chars_mobs_npcs[victim].freeze=math.max(chars_mobs_npcs[victim].freeze-buff,0);
		local buff2 = buff - result;
		chars_mobs_npcs[victim].cold_dur=math.max(chars_mobs_npcs[victim].cold_dur-buff2,0);
		--chars_mobs_npcs[victim].cold_power=math.max(chars_mobs_npcs[victim].cold_power-buff2,0);
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
	end;
	
	if missle_type == "curepoison" then
		local prebuff = lvl[1]*num[1];
		local delta = chars_mobs_npcs[victim].poison_dur - prebuff;
		if delta > 0 then
			buff = chars_mobs_npcs[victim].poison_dur - prebuff;
		else
			buff = prebuff+delta;
		end;
		chars_mobs_npcs[victim].poison_dur = chars_mobs_npcs[victim].poison_dur-buff;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.cured[chars_mobs_npcs[current_mob].gender]);
		love.audio.play(media.sounds.spell_freeze,0);
	end;
	
	if missle_type == "curedisease" then
		local prebuff = lvl[1]*num[1];
		local delta = chars_mobs_npcs[victim].disease - prebuff;
		if delta > 0 then
			buff = chars_mobs_npcs[victim].disease - prebuff;
		else
			buff = prebuff+delta;
		end;
		chars_mobs_npcs[victim].poison_dur = chars_mobs_npcs[victim].disease-buff;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.cured[chars_mobs_npcs[current_mob].gender]);
		love.audio.play(media.sounds.spell_freeze,0);
	end;
	
	if missle_type == "curemind" then
		local prebuff = lvl[1]*num[1];
		if num[1] == 5 then
			if chars_mobs_npcs[victim].enslave > 0 then
				local delta = chars_mobs_npcs[victim].enslave - prebuff;
				local _buff = 0;
				if delta > 0 then
					_buff = chars_mobs_npcs[victim].enslave - prebuff;
				else
					_buff = prebuff+delta;
				end;
				chars_mobs_npcs[victim].enslave = chars_mobs_npcs[victim].enslave-_buff;
				prebuff = prebuff-_buff;
				buff = buff + _buff;
			end;
		end;
		if num[1] >= 4 then
			if chars_mobs_npcs[victim].berserk > 0 then
				local delta = chars_mobs_npcs[victim].berserk - prebuff;
				local _buff = 0;
				if delta > 0 then
					_buff = chars_mobs_npcs[victim].berserk - prebuff;
				else
					_buff = prebuff+delta;
				end;
				chars_mobs_npcs[victim].berserk = chars_mobs_npcs[victim].berserk-_buff;
				prebuff = prebuff-_buff;
				buff = buff + _buff;
			end;
			if chars_mobs_npcs[victim].fear > 0 then
				local delta = chars_mobs_npcs[victim].paralyze - prebuff;
				local _buff = 0;
				if delta > 0 then
					_buff = chars_mobs_npcs[victim].paralyze - prebuff;
				else
					_buff = prebuff+delta;
				end;
				chars_mobs_npcs[victim].paralyze = chars_mobs_npcs[victim].paralyze-_buff;
				prebuff = prebuff-_buff;
				buff = buff + _buff;
			end;
		end;
		if num[1] >= 3 then
			if chars_mobs_npcs[victim].charm > 0 then
				local delta = chars_mobs_npcs[victim].charm - prebuff;
				local _buff = 0;
				if delta > 0 then
					_buff = chars_mobs_npcs[victim].charm - prebuff;
				else
					_buff = prebuff+delta;
				end;
				chars_mobs_npcs[victim].charm = chars_mobs_npcs[victim].charm-_buff;
				prebuff = prebuff-_buff;
				buff = buff + _buff;
			end;
			if chars_mobs_npcs[victim].feeblemind > 0 then
				local delta = chars_mobs_npcs[victim].feeblemind - prebuff;
				local _buff = 0;
				if delta > 0 then
					_buff = chars_mobs_npcs[victim].feeblemind - prebuff;
				else
					_buff = prebuff+delta;
				end;
				chars_mobs_npcs[victim].feeblemind = chars_mobs_npcs[victim].feeblemind-_buff;
				prebuff = prebuff-_buff;
				buff = buff + _buff;
			end;
		end;
		if num[1] >= 2 then
			if chars_mobs_npcs[victim].fear > 0 then
				local delta = chars_mobs_npcs[victim].fear - prebuff;
				local _buff = 0;
				if delta > 0 then
					_buff = chars_mobs_npcs[victim].fear - prebuff;
				else
					_buff = prebuff+delta;
				end;
				chars_mobs_npcs[victim].fear = chars_mobs_npcs[victim].fear-_buff;
				prebuff = prebuff-_buff;
				buff = buff + _buff;
			end;
			if chars_mobs_npcs[victim].sleep > 0 then
				local delta = chars_mobs_npcs[victim].sleep - prebuff;
				local _buff = 0;
				if delta > 0 then
					_buff = chars_mobs_npcs[victim].sleep - prebuff;
				else
					_buff = prebuff+delta;
				end;
				chars_mobs_npcs[victim].sleep = chars_mobs_npcs[victim].sleep-_buff;
				prebuff = prebuff-_buff;
				buff = buff + _buff;
			end;
		end;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.cured[chars_mobs_npcs[current_mob].gender]);
	end;
	
	if missle_type == "curecurse" then
		local prebuff = lvl[1]*num[1];
		if chars_mobs_npcs[victim].fingerofdeath > 0 then
			local delta = chars_mobs_npcs[victim].fingerofdeath - prebuff;
			local _buff = 0;
			if delta > 0 then
				_buff = chars_mobs_npcs[victim].fingerofdeath - prebuff;
			else
				_buff = prebuff+delta;
			end;
			chars_mobs_npcs[victim].fingerofdeath = chars_mobs_npcs[victim].fingerofdeath-_buff;
			prebuff = prebuff-_buff;
			buff = buff + _buff;
		end;
		if chars_mobs_npcs[victim].darkcontamination > 0 then
			local delta = chars_mobs_npcs[victim].darkcontamination - prebuff;
			local _buff = 0;
			if delta > 0 then
				_buff = chars_mobs_npcs[victim].darkcontamination - prebuff;
			else
				_buff = prebuff+delta;
			end;
			chars_mobs_npcs[victim].darkcontamination = chars_mobs_npcs[victim].darkcontamination-_buff;
			prebuff = prebuff-_buff;
			buff = buff + _buff;
		end;
		if chars_mobs_npcs[victim].curse > 0 then
			local delta = chars_mobs_npcs[victim].curse - prebuff;
			local _buff = 0;
			if delta > 0 then
				_buff = chars_mobs_npcs[victim].curse - prebuff;
			else
				_buff = prebuff+delta;
			end;
			chars_mobs_npcs[victim].curse = chars_mobs_npcs[victim].curse-_buff;
			prebuff = prebuff-_buff;
			buff = buff + _buff;
		end;
		if chars_mobs_npcs[victim].darkgasp > 0 then
			local delta = chars_mobs_npcs[victim].darkgasp - prebuff;
			local _buff = 0;
			if delta > 0 then
				_buff = chars_mobs_npcs[victim].darkgasp - prebuff;
			else
				_buff = prebuff+delta;
			end;
			chars_mobs_npcs[victim].darkgasp = chars_mobs_npcs[victim].darkgasp-_buff;
			prebuff = prebuff-_buff;
			buff = buff + _buff;
		end;
		if chars_mobs_npcs[victim].flith > 0 then
			local delta = chars_mobs_npcs[victim].flith_dur - prebuff;
			local _buff = 0;
			if delta > 0 then
				_buff = chars_mobs_npcs[victim].flith_dur - prebuff;
			else
				_buff = prebuff+delta;
			end;
			chars_mobs_npcs[victim].flith_dur = chars_mobs_npcs[victim].flith_dur-_buff;
			prebuff = prebuff-_buff;
			buff = buff + _buff;
		end;
		if chars_mobs_npcs[victim].misfortune > 0 then
			local delta = chars_mobs_npcs[victim].misfortune_dur - prebuff;
			local _buff = 0;
			if delta > 0 then
				_buff = chars_mobs_npcs[victim].misfortune_dur - prebuff;
			else
				_buff = prebuff+delta;
			end;
			chars_mobs_npcs[victim].misfortune_dur = chars_mobs_npcs[victim].misfortune_dur-_buff;
			prebuff = prebuff-_buff;
			buff = buff + _buff;
		end;
		if chars_mobs_npcs[victim].evileye > 0 then
			local delta = chars_mobs_npcs[victim].evileye - prebuff;
			local _buff = 0;
			if delta > 0 then
				_buff = chars_mobs_npcs[victim].evileye - prebuff;
			else
				_buff = prebuff+delta;
			end;
			chars_mobs_npcs[victim].evileye = chars_mobs_npcs[victim].evileye-_buff;
			prebuff = prebuff-_buff;
			buff = buff + _buff;
		end;
		if chars_mobs_npcs[victim].basiliskbreath > 0 then
			local delta = chars_mobs_npcs[victim].basiliskbreath - prebuff;
			local _buff = 0;
			if delta > 0 then
				_buff = chars_mobs_npcs[victim].basiliskbreath - prebuff;
			else
				_buff = prebuff+delta;
			end;
			chars_mobs_npcs[victim].basiliskbreath = chars_mobs_npcs[victim].basiliskbreath-_buff;
			prebuff = prebuff-_buff;
			buff = buff + _buff;
		end;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.cured[chars_mobs_npcs[current_mob].gender]);
	end;
	
	--FIXME
	
	if missle_type == "prayer" then
		buff = lvl[1];
		dur = num[1];
		chars_mobs_npcs[victim].prayer_power = buff;
		chars_mobs_npcs[victim].prayer_dur = dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
	end;
	
	if missle_type == "wingsoflight" then
		buff= chars_mobs_npcs[current_mob].num_lvl+chars_mobs_npcs[current_mob].lvl_light;
		chars_mobs_npcs[victim].wingsoflight=buff;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
	end;

	if missle_type == "protfromfire" then
		chars_mobs_npcs[victim].protfromfire_dur = 0;
		helpers.recalcResistances(victim);
		prebuff=math.ceil(10+num[1]*lvl[1]/2);
		dur=5+num[1]*lvl[1];
		buff=math.min(prebuff,100-chars_mobs_npcs[victim].rezfire);
		chars_mobs_npcs[victim].rezfire= chars_mobs_npcs[victim].rezfire+buff; --FIX
		chars_mobs_npcs[victim].protfromfire_power=buff;
		chars_mobs_npcs[victim].protfromfire_dur=dur;
		chars_mobs_npcs[victim].shieldfromfire_power=buff;
		chars_mobs_npcs[victim].shieldfromfire_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. buff .. lognames.actions.rez .. types_of_damage.tofire);
	end;

	if missle_type == "protfromcold" then
		chars_mobs_npcs[victim].protfromcold_dur = 0;
		helpers.recalcResistances(victim);
		prebuff=math.ceil(10+num[1]*lvl[1]/2);
		dur=5+num[1]*lvl[1];
		buff=math.min(prebuff,100-chars_mobs_npcs[victim].rezcold);
		chars_mobs_npcs[victim].rezcold= chars_mobs_npcs[victim].rezcold+buff;
		chars_mobs_npcs[victim].protfromcold_power=buff;
		chars_mobs_npcs[victim].protfromcold_dur=dur;
		chars_mobs_npcs[victim].shieldfromcold_power=buff;
		chars_mobs_npcs[victim].shieldfromcold_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. buff .. lognames.actions.rez .. types_of_damage.tocold);
	end;

	if missle_type == "protfromstatic" then
		chars_mobs_npcs[victim].protfromstatic_dur = 0;
		helpers.recalcResistances(victim);
		prebuff=math.ceil(10+num[1]*lvl[1]/2);
		dur=5+num[1]*lvl[1];
		buff=math.min(prebuff,100-chars_mobs_npcs[victim].rezstatic);
		chars_mobs_npcs[victim].rezstatic= chars_mobs_npcs[victim].rezstatic+buff;
		chars_mobs_npcs[victim].protfromstatic_power=buff;
		chars_mobs_npcs[victim].protfromstatic_dur=dur;
		chars_mobs_npcs[victim].shieldfromstatic_power=buff;
		chars_mobs_npcs[victim].shieldfromstatic_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. buff .. lognames.actions.rez .. types_of_damage.tostatic);
	end;

	if missle_type == "protfromacid" then
		chars_mobs_npcs[victim].protfromacid_dur = 0;
		helpers.recalcResistances(victim);
		prebuff=math.ceil(10+num[1]*lvl[1]/2);
		dur=5+num[1]*lvl[1];
		buff=math.ceil(math.min(prebuff,100-chars_mobs_npcs[victim].rezacid));
		chars_mobs_npcs[victim].rezacid= chars_mobs_npcs[victim].rezacid+buff;
		chars_mobs_npcs[victim].protfromacid_power=buff;
		chars_mobs_npcs[victim].protfromacid_dur=dur;
		chars_mobs_npcs[victim].shieldfromacid_power=buff;
		chars_mobs_npcs[victim].shieldfromacid_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. buff .. lognames.actions.rez .. types_of_damage.toacid);
	end;

	if missle_type == "protfrompoison" then
		chars_mobs_npcs[victim].protfrompoison_dur = 0;
		helpers.recalcResistances(victim);
		prebuff=math.ceil(10+num[1]*lvl[1]/2);
		dur=5+num[1]*lvl[1];
		buff=math.min(prebuff,100-chars_mobs_npcs[victim].rezpoison);
		chars_mobs_npcs[victim].rezpoison= chars_mobs_npcs[victim].rezpoison+buff;
		chars_mobs_npcs[victim].protfrompoison_power=buff;
		chars_mobs_npcs[victim].protfrompoison_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. buff .. lognames.actions.rez .. types_of_damage.topoison);
	end;

	if missle_type == "protfromdisease" then
		chars_mobs_npcs[victim].protfromdisease_dur = 0;
		helpers.recalcResistances(victim);
		prebuff=math.ceil(10+num[1]*lvl[2]/2);
		dur=5+num[2]*lvl[1];
		buff=math.min(prebuff,100-chars_mobs_npcs[victim].rezdisease);
		chars_mobs_npcs[victim].rezpoison= chars_mobs_npcs[victim].rezdisease+buff;
		chars_mobs_npcs[victim].protfromdesease_power=buff;
		chars_mobs_npcs[victim].protfromdesease_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. buff .. lognames.actions.rez .. types_of_damage.todisease);
	end;

	if missle_type == "protofmind" then
		chars_mobs_npcs[victim].protofmind_dur = 0;
		helpers.recalcResistances(victim);
		prebuff=math.ceil(10+num[1]*lvl[1]/2);
		dur=5+num[1]*lvl[1];
		buff = math.ceil(math.min(prebuff,100-chars_mobs_npcs[victim].rezmind));
		chars_mobs_npcs[victim].rezmind = chars_mobs_npcs[victim].rezmind+buff;
		chars_mobs_npcs[victim].protofmind_power = buff;
		chars_mobs_npcs[victim].protofmind_dur = dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. buff .. lognames.actions.rez .. types_of_damage.tomind);
	end;

	if missle_type=="protofspirit" then
		chars_mobs_npcs[victim].protofspirit_dur = 0;
		helpers.recalcResistances(victim);
		prebuff=math.ceil(10+num[1]*lvl[1]/2);
		dur=5+num[1]*lvl[1];
		buff=math.ceil(math.min(prebuff,100-chars_mobs_npcs[victim].rezspirit));
		chars_mobs_npcs[victim].rezspirit= chars_mobs_npcs[victim].rezspirit+buff;
		chars_mobs_npcs[victim].protofspirit_power=buff;
		chars_mobs_npcs[victim].protofspirit_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. buff .. lognames.actions.rez .. types_of_damage.tospirit);
	end;

	if missle_type=="shield" then
		dur=5+num[1]*lvl[1];
		chars_mobs_npcs[victim].shield_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.gotprot .. types_of_damage.torng);
	end;

	if missle_type=="stoneskin" then
		chars_mobs_npcs[victim].stoneskin_dur = 0;
		helpers.recalcResistances(victim);
		prebuff=10+num[1];
		dur=5+num[1]*lvl[1];
		buff=math.ceil(math.min(prebuff,100-chars_mobs_npcs[victim].ac));
		chars_mobs_npcs[victim].ac= chars_mobs_npcs[victim].ac+buff;
		chars_mobs_npcs[victim].stoneskin_power=buff;
		chars_mobs_npcs[victim].stoneskin_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» "); 
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. buff .. lognames.actions.rez .. types_of_damage.toac);
	end;

	if missle_type=="heroism" then
		local dur = 5 + lvl[1]*num[1];
		local power = 5 + num[1];
		chars_mobs_npcs[victim].heroism_dur = dur;
		chars_mobs_npcs[victim].heroism_power = power;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.likeahero[chars_mobs_npcs[current_mob].gender]);
	end;
	
	if missle_type=="dayofgods" then
		local dur = lvl[1];
		local power = math.ceil(num[2]+num[3]+num[4]/3);
		chars_mobs_npcs[victim].dayofgods = dur;
		chars_mobs_npcs[victim].dayofgods = power;
		helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog(helpers.mobName(victim) .. lognames.actions.likeahero[chars_mobs_npcs[current_mob].gender]);
	end;

	if missle_type=="holyblood" then
		local dur = num[1] + num[2];
		local power = lvl[1] + lvl[2];
		chars_mobs_npcs[victim].holyblood_dur=dur;
		chars_mobs_npcs[victim].holyblood_power=power;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. " «" .. spellname .. "» ");
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.likeasaint[chars_mobs_npcs[current_mob].gender]);
	end;

	if missle_type=="resurrect" then
		love.audio.play(media.sounds.spell_resurrect,0);
		if lvl[1]==5 then
			buff=damage.damageRandomizator(current_mob,1,5)*num[2];
		else
			buff=1;
		end;
		helpers.mobAtBody (victim);
		if mobs_at_hex==0 then
			chars_mobs_npcs[victim].status=1;
		end;
		chars_mobs_npcs[victim].hp=buff --FIX
		if chars_mobs_npcs[current_mob].person=="char" then
			chars_mobs_npcs[current_mob].tmpexpdeaths= chars_mobs_npcs[current_mob].tmpexpdeaths+1; --expa
			chars_mobs_npcs[current_mob].tmpexpdmg= chars_mobs_npcs[current_mob].tmpexpdmg+buff; --expa
		end;
			helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname)
			helpers.addToActionLog( lognames.actions.andrestored[chars_mobs_npcs[current_mob].gender] .. helpers.mobName(victim) .. " " .. lognames.actions.resurrected[chars_mobs_npcs[current_mob].gender])
			helpers.addToActionLog( lognames.actions.andrestored[chars_mobs_npcs[current_mob].gender] .. helpers.mobName(victim) .. " " .. buff .. lognames.actions.metr .. lognames.actions.ofhp)
		end;

	if missle_type == "ritualofthevoid" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname)
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		local id = math.random(1,100000);
		vlandscape_obj[cursor_world_y][cursor_world_x] = 1;
		vlandscape_duration[cursor_world_y][cursor_world_x] = num[1];
		vlandscape_id[cursor_world_y][cursor_world_x] = id;
		for h=1,3 do
			for i=1,#rings[h] do
				if helpers.insideMap(rings[h][i].y,rings[h][i].x) then
					vlandscape_id[rings[h][i].y][rings[1][h].x] = id;
				end;
			end;
		end;
	end;

	if missle_type=="sacrifice" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname)

		if lvl[1] == 3 then
			chars_mobs_npcs[victim].hp = -1*chars_mobs_npcs[victim].hp_max*3;
		elseif lvl[1] == 4 then
			chars_mobs_npcs[victim].hp = -1*chars_mobs_npcs[victim].hp_max;
		elseif lvl[1]== 5 then
			chars_mobs_npcs[victim].hp = 0;
		end
		helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.sacrificed[chars_mobs_npcs[current_mob].gender]);
		for i = 1, chars do
			if i ~= victim then
				local lostMoral = math.max(0,100 - (chars_mobs_npcs[current_mob].lvl_darkness+chars_mobs_npcs[current_mob].num_darkness));
				if chars_mobs_npcs[current_mob].despondency_power < lostMoral then
					chars_mobs_npcs[current_mob].despondency_power = chars_mobs_npcs[current_mob].moral - lostMoral;
					chars_mobs_npcs[current_mob].despondency_dur = 10 - chars_mobs_npcs[current_mob].lvl_darkness;
					helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.desponded[chars_mobs_npcs[i].gender]);
				end;
				if chars_mobs_npcs[current_mob].lvl_darkness >= 3 then
					if not helpers.aliveAtHex(chars_mobs_npcs[i].x,chars_mobs_npcs[i].y) then
						local healHP = chars_mobs_npcs[i].hp_max - chars_mobs_npcs[i].hp;
						chars_mobs_npcs[i].hp = chars_mobs_npcs[i].hp_max;
						helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.got[chars_mobs_npcs[i].gender] .. " " .. healHP .. lognames.actions.metr .. lognames.actions.ofhp);
					end;
				elseif chars_mobs_npcs[current_mob].lvl_darkness >= 4 then
					local healST = chars_mobs_npcs[i].st_max - chars_mobs_npcs[i].st;
					chars_mobs_npcs[i].st = -chars_mobs_npcs[i].st_max;
					helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.got[chars_mobs_npcs[i].gender] .. " " .. healST .. lognames.actions.metr .. lognames.actions.ofst);
				elseif chars_mobs_npcs[current_mob].lvl_darkness == 5 then
					local healSP = chars_mobs_npcs[i].sp_max - chars_mobs_npcs[i].sp;
					chars_mobs_npcs[i].sp = chars_mobs_npcs[i].sp_max;
					helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.got[chars_mobs_npcs[i].gender] .. " " .. healSP .. lognames.actions.metr .. lognames.actions.ofsp);
				end;
			end;
		end;
		
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
		--damage.deathsWatcher(damaged_mobs);
	end;

---debuffs

	if missle_type == "fear" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		debuff = damage.applyCondition (victim,lvl[1],num[1],"fear","mind",false,false,1,false);
		if debuff > 0 then
			helpers.addToActionLog(helpers.mobName(victim) .. " " .. lognames.actions.scared[chars_mobs_npcs[current_mob].gender]);
		else
			helpers.addToActionLog(lognames.actions.noeffect);
		end;
	end;

	if missle_type == "charm" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		debuff = damage.applyCondition (victim,lvl[1],num[1],"charm","mind",false,false,1,false);
		if debuff > 0 then
			helpers.addToActionLog(helpers.mobName(victim) .. " " .. lognames.actions.charmed[chars_mobs_npcs[current_mob].gender]);
		else
			helpers.addToActionLog(lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "feeblemind" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		debuff = damage.applyCondition (victim,lvl[1],num[1],"feeblemind","mind",false,false,1,false);
		if debuff > 0 then
			helpers.addToActionLog(helpers.mobName(victim) .. " " .. lognames.actions.feebleminded[chars_mobs_npcs[current_mob].gender]);
		else
			helpers.addToActionLog(lognames.actions.noeffect);
		end;
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
	end;
	
	if missle_type == "darkgasp" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		debuff = damage.applyCondition (victim,lvl[1],num[1],"darkgasp","darkness",false,false,1,false);
		if debuff > 0 then
			helpers.addToActionLog(helpers.mobName(victim) .. " " .. lognames.actions.darkgasped[chars_mobs_npcs[current_mob].gender]);
		else
			helpers.addToActionLog(lognames.actions.noeffect);
		end;
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
	end;
	
	if missle_type == "fingerofdeath" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		debuff = damage.applyCondition (victim,lvl[1],num[1],"fingerofdeath","darkness",false,false,1,false);
		if debuff > 0 then
			helpers.addToActionLog(helpers.mobName(victim) .. " " .. lognames.actions.fingerofdeathed[chars_mobs_npcs[current_mob].gender]);
		else
			helpers.addToActionLog(lognames.actions.noeffect);
		end;
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
	end;
	
	if missle_type == "slow" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		debuff = damage.applyCondition (victim,lvl[1],num[1],"slow","light",false,false,1,false);
		if debuff > 0 then
			helpers.addToActionLog(helpers.mobName(victim) .. " " .. lognames.actions.slowed[chars_mobs_npcs[current_mob].gender]);
		else
			helpers.addToActionLog(lognames.actions.noeffect);
		end;
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
	end;

	--FIXME: use damage.applyCondition lvl num

	if missle_type == "berserk" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if lvl[1]*num[1] > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			debuff=10+lvl[1]*num[1];
			chars_mobs_npcs[victim].berserk=debuff;
			chars_mobs_npcs[victim].fear = 0;
			chars_mobs_npcs[victim].charm=0;
			chars_mobs_npcs[victim].enslave=0;
			chars_mobs_npcs[victim].battleai="melee";
			helpers.addToActionLog(helpers.mobName(victim) .. " " .. lognames.actions.berserk[chars_mobs_npcs[current_mob].gender]);
		else
			helpers.addToActionLog(lognames.actions.noeffect);
		end;
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
	end;

	if missle_type == "enslave" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if lvl[1]*num[1] > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].insane==0 and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].enslave==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			debuff=10+lvl[1]*num[1];
			chars_mobs_npcs[victim].enslave=debuff;
			chars_mobs_npcs[victim].fear = 0;
			chars_mobs_npcs[victim].charm=0;
			chars_mobs_npcs[victim].berserk=0;
			helpers.addToActionLog(helpers.mobName(victim) .. " " .. lognames.actions.enslaved[chars_mobs_npcs[current_mob].gender]);
		else
			helpers.addToActionLog(lognames.actions.noeffect);
		end;
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
	end;

	if missle_type == "controlundead" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if lvl[1]*num[1] > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].enslave==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			debuff=10 + lvl[1]*num[1];
			chars_mobs_npcs[victim].enslave=debuff;
			chars_mobs_npcs[victim].fear = 0;
			chars_mobs_npcs[victim].berserk=0;
			helpers.addToActionLog(helpers.mobName(victim) .. " " .. lognames.actions.controlled[chars_mobs_npcs[current_mob].gender]);
		else
			helpers.addToActionLog(lognames.actions.noeffect);
		end;
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
	end;

	if missle_type == "freeze" then
		--dur=math.ceil((chars_mobs_npcs[current_mob].lvl_water-1+chars_mobs_npcs[current_mob].num_water/5)*(100-chars_mobs_npcs[victim].rezcold)/100);
		dur=damage.applyCondition (victim,lvl[1],num[1],"freeze","cold",false,false,1,false);
		debuff=math.max(chars_mobs_npcs[victim].freeze,dur);
		chars_mobs_npcs[victim].freeze=debuff;
		chars_mobs_npcs[victim].flame_power = 0;
		chars_mobs_npcs[victim].flame_dur = 0;
		chars_mobs_npcs[victim].deadlyswarm = 0;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.freeze[chars_mobs_npcs[current_mob].gender]);
		love.audio.play(media.sounds.spell_freeze,0);
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
	end;
	
	if missle_type == "turntostone" then
		dur = damage.applyCondition (victim,lvl[1],num[2],"stone",false,"luk",false,1,false);
		debuff = math.max(chars_mobs_npcs[victim].stone,dur);
		if debuff > 0 then
			chars_mobs_npcs[victim].stone = debuff;
			chars_mobs_npcs[victim].flame_power = 0;
			chars_mobs_npcs[victim].flame_dur = 0;
			chars_mobs_npcs[victim].acid_power = 0;
			chars_mobs_npcs[victim].acid_dur = 0;
			chars_mobs_npcs[victim].cold_power = 0;
			chars_mobs_npcs[victim].cold_dur = 0;
			chars_mobs_npcs[victim].poison_power = 0;
			chars_mobs_npcs[victim].poison_dur = 0;
			chars_mobs_npcs[victim].deadlyswarm = 0;
		end;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.freeze[chars_mobs_npcs[current_mob].gender]);
		--love.audio.play(media.sounds.spell_stone,0);
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
	end;

	if missle_type == "firemine" then
		debuff=30;
		mlandscape_obj[cursor_world_y][cursor_world_x] ="firemine";
		mlandscape_power[cursor_world_y][cursor_world_x] = 5;
		mlandscape_duration[cursor_world_y][cursor_world_x] = 10;
		mlandscape_id[cursor_world_y][cursor_world_x] = current_mob;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( lognames.actions.trapinstalled);
	end;
	
	if missle_type == "roots" then
		debuff=30;
		mlandscape_obj[cursor_world_y][cursor_world_x] ="roots";
		mlandscape_power[cursor_world_y][cursor_world_x] = 5;
		mlandscape_duration[cursor_world_y][cursor_world_x] = 10;
		chars_mobs_npcs[victim].immobilize = chars_mobs_npcs[victim].immobilize +10; 
		damage.mobDamaged (victim,current_mob,debuff);
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.immobilized[chars_mobs_npcs[victim].gender]);
		--helpers.addToActionLog( lognames.actions.trapinstalled);
		local damaged_mobs = {};
		table.insert(damaged_mobs,victim);
	end;
	
	if missle_type == "telepathy" then
		if lvl[1]*num[1] > chars_mobs_npcs[victim].rezmind then
			helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
			local phrase1,phrase2,phrase3 = helpers.detectAImode (victim);
			helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.thinks[chars_mobs_npcs[victim].gender] .. phrase1);
			helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.thinks[chars_mobs_npcs[victim].gender] .. phrase2);
			if phrase3 ~= "" then
				helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.thinks[chars_mobs_npcs[victim].gender] .. phrase3);
			end;
			local possiblytarget = helpers.mobName(helpers.detectAgro (victim));
			if possiblytarget and chars_mobs_npcs[victim].ai == "agr" then
				helpers.addToActionLog( helpers.mobName(victim) .. lognames.actions.hates[chars_mobs_npcs[victim].gender] .. possiblytarget);
			end;
		end;
	end;
	
	if missle_type	== "glamour" then
		buff = num[1];
		dur = lvl[1]+10;
		chars_mobs_npcs[victim].chr_buff_power=buff;
		chars_mobs_npcs[victim].chr_buff_dur=dur;
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.gotcharisma[chars_mobs_npcs[current_mob].gender]);
	end;
	
	if missle_type == "fireelemental" then
		table.insert(chars_mobs_npcs,{person="mob",control="ai",ai="agr",x=boomx,y=boomy,rot=math.random(1,6),class="fireelemental",fraction="party"});
		helpers.addMob(#chars_mobs_npcs,"mob");
		chars_mobs_npcs[#chars_mobs_npcs].torchlight_dur = 100000;
		chars_mobs_npcs[#chars_mobs_npcs].torchlight_power = 1;
		chars_mobs_npcs[#chars_mobs_npcs].firebelt_dur = 100000;
		chars_mobs_npcs[#chars_mobs_npcs].firebelt_power = 3;
		chars_mobs_npcs[#chars_mobs_npcs].fireprint_dur = 100000;
		chars_mobs_npcs[#chars_mobs_npcs].fireprint_power = 3;
		chars_mobs_npcs[#chars_mobs_npcs].summoned = true;
		helpers.addToActionLog( lognames.actions.elementalcalled);
	end;
	
	if missle_type == "airelemental" then
		table.insert(chars_mobs_npcs,{person="mob",control="ai",ai="agr",x=boomx,y=boomy,rot=math.random(1,6),class="airelemental",fraction="party"});
		helpers.addMob(#chars_mobs_npcs,"mob");
		chars_mobs_npcs[#chars_mobs_npcs].summoned = true;
		helpers.addToActionLog( lognames.actions.elementalcalled);
	end;
	
	if missle_type == "waterelemental" then
		table.insert(chars_mobs_npcs,{person="mob",control="ai",ai="agr",x=boomx,y=boomy,rot=math.random(1,6),class="waterelemental",fraction="party"});
		helpers.addMob(#chars_mobs_npcs,"mob");
		chars_mobs_npcs[#chars_mobs_npcs].summoned = true;
		chars_mobs_npcs[#chars_mobs_npcs].waterwalking = 100000;
		helpers.addToActionLog( lognames.actions.elementalcalled);
	end;
	
	if missle_type == "earthelemental" then
		table.insert(chars_mobs_npcs,{person="mob",control="ai",ai="agr",x=boomx,y=boomy,rot=math.random(1,6),class="earthelemental",fraction="party"});
		helpers.addMob(#chars_mobs_npcs,"mob");
		chars_mobs_npcs[#chars_mobs_npcs].summoned = true;
		helpers.addToActionLog( lognames.actions.elementalcalled);
	end;
	
	if missle_type == "clone" then
		table.insert(chars_mobs_npcs,{person="mob",control="ai",ai="agr",x=boomx,y=boomy,rot=math.random(1,6),class="clone",fraction="party"});
		helpers.addMob(#chars_mobs_npcs,"mob");
		chars_mobs_npcs[#chars_mobs_npcs].summoned = true;
		chars_mobs_npcs[#chars_mobs_npcs].hp = lvl[1]*num[1];
		helpers.addToActionLog(lognames.actions.clonecreated);
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,3 do
			for i=1,#rings[h] do
				for j=1,#chars_mobs_npcs do
					if chars_mobs_npcs[j].x == rings[h][i].x and chars_mobs_npcs[j].y == rings[h][i].y and chars_mobs_npcs[j].rez_mind < lvl[2]*num[2] then
						chars_mobs_npcs[j].aggressor = #chars_mobs_npcs;
						chars_mobs_npcs[j].aggro = lvl[2]*num[2] - chars_mobs_npcs[j].rez_mind;
					end;
				end;
			end;
		end;
	end;
	
	if chars_mobs_npcs[current_mob].person=="char" then
		chars_mobs_npcs[current_mob].tmpexpdmg= chars_mobs_npcs[current_mob].tmpexpdmg+debuff;
	end
		
	if chars_mobs_npcs[current_mob].person=="char" then
		chars_mobs_npcs[current_mob].tmpexpdmg= chars_mobs_npcs[current_mob].tmpexpdmg+areadot; --expa
	end

	chars_mobs_npcs[current_mob].rage = 0;
end;

function damage.mindGameCast()
	utils.printDebug("Mindcast!");
	local phrase1 = "";
	--local phrase2 = "";
	local lvl,num = helpers.countBoomNumbers ();
	spellname =	magic.spell_tips[missle_type].title;
	game_status = "mindgame";
	if missle_type == "berserk" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_mind;
			local plusstatus = 5;
			local plusnumber = debuff;
			local minusnumber = 1;
			for i=1,10 do
				chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
			end;
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
			local snd = "mindgame_agression";
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("berserk",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "charm" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_mind;
			local minusstatus = 5;
			local minusnumber = debuff;
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][minusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][minusstatus] - minusnumber;
			local snd = "mindgame_loyality";
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("charm",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
			chars_mobs_npcs[victim].aggressor = 0;
			chars_mobs_npcs[victim].aggro = 0;
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "fear" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_mind;
			local plusstatus = 2;
			local plusnumber = debuff;
			local minusnumber = 1;
			for i=1,10 do
				chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
			end;
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
			local snd = "mindgame_fear";
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("fear",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "turnundead" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		and chars_mobs_npcs[victim].nature == "undead"
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_mind;
			local plusstatus = 2;
			local plusnumber = debuff;
			local minusnumber = 1;
			for i=1,10 do
				chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
			end;
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
			local snd = "mindgame_fear";
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("charm",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "glamour" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		buff = chars_mobs_npcs[current_mob].num_mind;
		dur = chars_mobs_npcs[current_mob].lvl_mind*10;
		chars_mobs_npcs[victim].chr_buff_power=buff;
		chars_mobs_npcs[victim].chr_buff_dur=dur;
		helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.gotcharisma[chars_mobs_npcs[current_mob].gender]);
	end;
	
	if missle_type == "telekinesis" then --FIXME agro from nearest
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_mind;
			local plusstatus = 2;
			local plusnumber = debuff;
			for i=1,10 do
				chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
			end;
			fractions[chars_mobs_npcs[victim]["fraction"]]["party"] = fractions[chars_mobs_npcs[victim]["fraction"]]["party"]-plusnumber;
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
			local snd = "mindgame_fear"; -- FIXME hhhhhhh
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("asphyxia",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "myrth" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_mind;
			local plusstatus = 1;
			local minusstatus = 7;
			local plusnumber = debuff;
			local minusnumber = debuff;
			local _delta = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][minusstatus] - minusnumber;
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][minusstatus] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][minusstatus] - minusnumber);
			if _delta > 0 then
				plusnumber = debuff - _delta;
				chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
			end;
			local snd = "mindgame_lol";
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("feelglad",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "despondency" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_mind;
			local plusstatus = 7;
			local minusstatus = 1;
			local minusnumber = debuff;
			local plusnumber = debuff;
			local _delta = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][minusstatus] - minusnumber;
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][minusstatus] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][minusstatus] - minusnumber);
			if _delta > 0 then
				plusnumber = debuff - _delta;
				chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
			end;
			local snd = "mindgame_cry";
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("feelsad",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "sleep" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		and mindgame.passCheck(5,5)
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_mind;
			if debuff > 0 then
				global.mind_hero.x = 5;
				global.mind_hero.y = 5;
			end;
			local snd = "mindgame_cry"; --FIXME
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("sleep",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "enslave" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_mind;
			local minusstatus = 7;
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][6] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][6] - debuff);
			local snd = "mindgame_loyality"; --FIXME master
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("mymaster",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "controlundead" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_spirit*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezspirit
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		and chars_mobs_npcs[victim].nature=="undead"
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_spirit;
			local minusstatus = 7;
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][6] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][6] - debuff);
			local snd = "mindgame_loyality"; --FIXME master
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("mymaster",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;
	
	if missle_type == "curemind" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname) 
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind
		and chars_mobs_npcs[victim].sleep==0
		and chars_mobs_npcs[victim].berserk==0 and chars_mobs_npcs[victim].stone==0
		and chars_mobs_npcs[victim].freeze==0
		then
			local debuff = chars_mobs_npcs[current_mob].lvl_mind;
			local minusstatus = 7;
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][2] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][2] - debuff);
			local snd = "mindgame_loyality"; --FIXME ooh
			love.audio.play(media["sounds"][snd],0);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("curedmind",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;
	end;

	if missle_type == "telepathy" then
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind then
			helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
			local phrase1,phrase2,phrase3 = helpers.detectAImode (victim);
			table.insert(mindgame_log, helpers.mobName(victim) .. lognames.actions.thinks[chars_mobs_npcs[victim].gender] .. phrase1);
			table.insert(mindgame_log, helpers.mobName(victim) .. lognames.actions.thinks[chars_mobs_npcs[victim].gender] .. phrase2);
			if phrase3 ~= "" then
				table.insert(mindgame_log, helpers.mobName(victim) .. lognames.actions.thinks[chars_mobs_npcs[victim].gender] .. phrase3);
			end;
			local possiblytarget = helpers.mobName(helpers.detectAgro (victim));
			if possiblytarget and chars_mobs_npcs[victim].ai == "agr" then
				table.insert(mindgame_log, helpers.mobName(victim) .. lognames.actions.hates[chars_mobs_npcs[victim].gender] .. possiblytarget);
			end;
			local _pack_of_secrets = {};
			if chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["chantage"] and #chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["chantage"] > 0 then
				for h=1, #chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["chantage"] do
					local _unknown_secret = true;
					local _unknown_secret_id = 0;
					for i=1,#party.secrets do
						if party.secrets[i] == chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["chantage"][h].id then
							_unknown_secret = false;
						end;
					end;
					if _unknown_secret then
						table.insert(_pack_of_secrets,chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["chantage"][h].id);
					end;
				end;

			end;
			if chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["known_secrets"] and #chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["known_secrets"] > 0 then
				for h=1, #chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["known_secrets"] do
					local _unknown_secret = true;
					local _unknown_secret_id = 0;
					for i=1,#party.secrets do
						if party.secrets[i] == chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["known_secrets"][h].id then
							_unknown_secret = false;
						end;
					end;
					if _unknown_secret then
						table.insert(_pack_of_secrets,chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["known_secrets"][h].id);
					end;
				end;
			end;
			if #_pack_of_secrets > 0 then
				local _new_secret_index = math.random(1,#_pack_of_secrets)
				table.insert(party.secrets,pack_of_secrets[_new_secret_index]);
				helpers.addToActionLog( lognames.actions.newsecret);
			end;
		end;
	end;
	
	if missle_type == "feeblemind" then
		helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.cast[chars_mobs_npcs[current_mob].gender] .. spellname);
		if chars_mobs_npcs[current_mob].lvl_mind*chars_mobs_npcs[current_mob].num_mind > chars_mobs_npcs[victim].rezmind then
			for i=1,10 do
				chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = 0;
			end;
			helpers.addToActionLog( helpers.mobName(victim) .. " " .. lognames.actions.forgottensnth[chars_mobs_npcs[current_mob].gender]);
			local phrase1 = chars_mobs_npcs[victim].name .. ": " .. chats.questionPerEtiquette("forgotit",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
		else
			helpers.addToActionLog( lognames.actions.noeffect);
		end;	
	end;
	
	table.insert(mindgame_log,phrase1);
	--table.insert(mindgame_log,phrase2);
	global.mindgame_counter = global.mindgame_counter + 1;
	draw.mindgameButtons();
	mindgame.path ();
end;


function damage.weaponPassives(current_mob,victim,attack)
 local weaponClass = "";
 local weaponSubClass = "";
 local effects = damage.weaponPassivesArray[weaponSubClass]; 
 if attack == "melee" and chars_mobs_npcs[current_mob]["equipment"].rh > 0 then
	weaponClass = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].ttxid].class;
	weaponSubClass = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].ttxid].subclass;	
 elseif attack == "melee" and chars_mobs_npcs[current_mob]["equipment"].rh == 0 then
	weaponClass = "unarmed";
	weaponSubClass = "unarmed";	
 else
	if missle_type == "bolt" or missle_type == "arrow" or missle_type == "bullet" or missle_type == "battery" then
		weaponClass = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].ttxid].class;
		weaponSubClass = missle_type; 
	elseif missle_drive == "muscles" and  helpers.missleAtWarBook() then
		weaponClass = tricks.tricks_tips[missle_type].skill;
		if weaponClass == "bow" then
			weaponSubClass = "arrow";
		elseif weaponClass == "crossbow" then
			weaponSubClass = "bolt";
		elseif weaponClass == "thrownig" then
			--weaponSubClass = FIXME should keep in memory like global.missle
		end;
	else
		weaponClass = missle_type;
		weaponSubClass = missle_type; 
	end;	
 end;
 local randomEffect = math.random(1,#damage.weaponPassivesArray[weaponSubClass]);
 local effect = damage.weaponPassivesArray[weaponSubClass][randomEffect];
 local chance = math.random(1,chars_mobs_npcs[current_mob]["num_" .. weaponClass] + math.ceil((chars_mobs_npcs[current_mob].luk-chars_mobs_npcs[victim].luk)/10));
 return effect,chance;
end;

damage.weaponPassivesArray = {
	longsword={"cut","chop","pierce","through","finish"},
	broadsword={"cut","chop","pierce","through","finish"},
	shortsword={"cut","chop","pierce","through","finish"},
	cutlass={"cut","chop","finish"},
	thsword={"cut","chop","destroy","finish"},
  
	battleaxe={"chop","destroy"},
	broadaxe={"chop","destroy"},
	poleaxe={"chop","destroy"},
	hetchet={"chop","destroy"},
	labris={"chop","destroy"},
  
	spear={"pierce","through"},
	scythe={"pierce","cut","through"},
	halbert={"pierce","chop","through","destroy"},
	trident={"pierce","through"},
  
	knife={"finish","cut"},
	shortdagger={"pierce","through","finish"},
	longdagger={"pierce","through","finish"},
 
	unarmed={"hit"},
	knuckles={"hit"},
	tentacles={"hit","lash","chock"},
	nipper={"crush","destroy"},
	claws={"tear","cut"},
  
    teeth = {"crush","tear","chop"},
    horns={"crush","pierce","destroy"},
    tail={"hit"},
  
	club={"hit","crush"},
	mace={"crush"},
	hammer={"crush","destroy"},
	flail={"crush","destroy","lash","deblock"},
  
	battlestaff={"hit"},
	magicalstaff={"hit"},
	
	suriken={"pierce"},
	thrknife={"cut"},
	thraxe={"chop"},
	boomerang={"hit"},
	chakra={"cut","chop"},
	
	arrow={"pierce"},
	bolt={"pierce"},
	bullet={"crush"},
	battery={},
};

function damage.classPassives(index)
	local class_passives_array = {};
	if mobs_stats[chars_mobs_npcs[index].class].class_attack_passives and #mobs_stats[chars_mobs_npcs[index].class].class_attack_passives > 0 then
		class_passives_array = mobs_stats[chars_mobs_npcs[index].class].class_attack_passives;
	end;
	if #class_passives_array > 0 then
		local random_effect = math.random(1,#class_passives_array);
		local chance = class_passives_array[chance].mode;
		local iflucky = math.random(1,100);
		if iflucky > chance then
			local mode = class_passives_array[random_effect].mode;
			local akgorythm = class_passives_array[random_effect].algorythm;
			local lvl = class_passives_array[random_effect].lvl;
			local num = class_passives_array[random_effect].num;
			local effect = class_passives_array[random_effect].effect;
			local stat = class_passives_array[random_effect].stat;
			local skill = class_passives_array[random_effect].skil;
			local coff = class_passives_array[random_effect].coff;
			local luck = class_passives_array[random_effect].luck;
			return mode,lvl,num,effect,element,stat,skill,coff,luck
		else
			return false;
		end;
	end;
	return false
end;

function damage.HPcheck(index)
	if chars_mobs_npcs[index].hp <= 0 and chars_mobs_npcs[index].hp >= -1*chars_mobs_npcs[index].enu then
		if chars_mobs_npcs[index].person == "char" and chars_mobs_npcs[index].status == 1 then
			damage.uncondNow(index);
		else
			damage.deadNow(index);	
		end;
	elseif chars_mobs_npcs[index].hp < -1*chars_mobs_npcs[index].enu then
		damage.deadNow(index);
	end;
end;

function damage.HPminus(index,damageHP,flag)
	chars_mobs_npcs[index].hp = chars_mobs_npcs[index].hp - damageHP;
	if chars_mobs_npcs[index].hp < chars_mobs_npcs[index].poison_status then
		chars_mobs_npcs[index].poison_status = chars_mobs_npcs[index].hp;
	end;
	if flag then
		helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.lost[chars_mobs_npcs[index].gender] .. damageHP .. lognames.actions.metr .. lognames.actions.ofhp);
	end;
	damage.HPcheck(index);
end;

function damage.PoisonPlus(index,poisonPlus)
	chars_mobs_npcs[index].poison_status = math.min(chars_mobs_npcs[index].hp,chars_mobs_npcs[index].poison_status + poisonPlus);
	helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.sufferingofpoison[chars_mobs_npcs[index].gender]);
end;

function damage.SPminus(index,damageSP,flag)
	local realdamage = math.max(0,chars_mobs_npcs[index].sp - damageSP);
	chars_mobs_npcs[index].sp = chars_mobs_npcs[index].sp - realdamage;
	if flag then
		helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.lost[chars_mobs_npcs[index].gender] .. realdamage .. lognames.actions.metr .. lognames.actions.ofsp);
	end;
end;

function damage.STminus(index,damageST,flag)
	local realdamage = math.max(0,chars_mobs_npcs[index].st - damageST);
	chars_mobs_npcs[index].st = chars_mobs_npcs[index].st - realdamage;
	if flag then
		helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.lost[chars_mobs_npcs[index].gender] .. realdamage .. lognames.actions.metr .. lognames.actions.ofst);
	end;
	if chars_mobs_npcs[index].st == 0 and chars_mobs_npcs[index].status == 1 and helpers.aliveNature(index) then
		chars_mobs_npcs[index].weakness = damageST - realdamage;
		helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.desponded[chars_mobs_npcs[index].gender]);
	end;
end;

function damage.RTminus(index,damageRT,flag)
	local realdamage = math.max(0,chars_mobs_npcs[index].rt - damageRT);
	chars_mobs_npcs[index].rt = chars_mobs_npcs[index].rt - realdamage;
	if flag then
		helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.lost[chars_mobs_npcs[index].gender] .. realdamage .. lognames.actions.metr .. lognames.actions.ofrt);
	end;
end;

function damage.HPplus(index,plus,flag)
	if chars_mobs_npcs[index].status >= 0 and chars_mobs_npcs[index].hp < chars_mobs_npcs[index].hp_max then
		local prevHP = chars_mobs_npcs[index].hp;
		local realplus = math.min(plus,chars_mobs_npcs[index].hp_max-chars_mobs_npcs[index].hp);
		chars_mobs_npcs[index].hp = chars_mobs_npcs[index].hp + realplus;
		if flag then
			helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.got[chars_mobs_npcs[index].gender] .. realplus .. lognames.actions.metr .. lognames.actions.ofhp);
		end;
		if chars_mobs_npcs[index].person == "char" and prevHP <=0 and chars_mobs_npcs[index].hp > 0 then
			chars_mobs_npcs[index].status = 1;
		end;
	end;
end;

function damage.SPplus(index,plus,flag)
	local realplus = math.min(plus,chars_mobs_npcs[index].sp_max-chars_mobs_npcs[index].sp);
	chars_mobs_npcs[index].sp = chars_mobs_npcs[index].sp + realplus;
	if flag then
		helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.got[chars_mobs_npcs[index].gender] .. realplus .. lognames.actions.metr .. lognames.actions.ofsp);
	end;
end;

function damage.STplus(index,plus,flag)
	local realplus = math.min(plus,chars_mobs_npcs[index].st_max-chars_mobs_npcs[index].st);
	chars_mobs_npcs[index].st = chars_mobs_npcs[index].st + realplus;
	if flag then
		helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.got[chars_mobs_npcs[index].gender] .. realplus .. lognames.actions.metr .. lognames.actions.ofst);
	end;
end;

function damage.RTplus(index,plus,flag)
	local realplus = math.min(plus,200-chars_mobs_npcs[index].rt);
	chars_mobs_npcs[index].rt = chars_mobs_npcs[index].rt + realplus;
	if flag then
		helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.got[chars_mobs_npcs[index].gender] .. realplus .. lognames.actions.metr .. lognames.actions.ofrt);
	end;
end;

function damage.deadNow (index)

	mobs_revengers = {};
	
	if chars_mobs_npcs[index].revenge_type ~= 0 then
		table.insert(mobs_revengers,j);
	end;
	if chars_mobs_npcs[index].revenge_type ~= 0 then
		table.insert(mobs_revengers,j);
	end;
	chars_mobs_npcs[index].status = -1;
	chars_mobs_npcs[index].protectionmode = "none";
	chars_mobs_npcs[index].trick = "none";
	chars_mobs_npcs[index].sp = 0;
	chars_mobs_npcs[index].st = 0;
	chars_mobs_npcs[index].rt = 0;
	chars_mobs_npcs[index].moral = 0;
	chars_mobs_npcs[index].firebelt_dur = 0;
	chars_mobs_npcs[index].firebelt_power = 0;
	chars_mobs_npcs[index].fireprint_dur = 0;
	chars_mobs_npcs[index].fireprint_power = 0;
	chars_mobs_npcs[index].poison_dur = 0;
	chars_mobs_npcs[index].poison_power = 0;
	chars_mobs_npcs[index].cold_dur = 0;
	chars_mobs_npcs[index].cold_power = 0;
	chars_mobs_npcs[index].freeze = 0;
	chars_mobs_npcs[index].stun = 0;
	chars_mobs_npcs[index].sleep = 0;
	chars_mobs_npcs[index].panic = 0;
	chars_mobs_npcs[index].charm = 0;
	chars_mobs_npcs[index].berserk = 0;
	chars_mobs_npcs[index].enslave = 0;
	chars_mobs_npcs[index].stone_power = 0;
	chars_mobs_npcs[index].regen_power = 0;
	chars_mobs_npcs[index].regen_dur = 0;
	chars_mobs_npcs[index].healaura_power = 0;
	chars_mobs_npcs[index].healaura_dur = 0;
	chars_mobs_npcs[index].darkgasp = 0;
	chars_mobs_npcs[index].fear = 0;
	chars_mobs_npcs[index].ai = "none";
	chars_mobs_npcs[index].heroism_dur = 0;
	chars_mobs_npcs[index].heroism_power = 0;
	chars_mobs_npcs[index].bless = 0;
	chars_mobs_npcs[index].fate = 0;
	chars_mobs_npcs[index].fateself = 0;
	chars_mobs_npcs[index].rage = 0;
	chars_mobs_npcs[index].haste = 0;
	chars_mobs_npcs[index].prayer_dur = 0;
	chars_mobs_npcs[index].prayer_power = 0;
	chars_mobs_npcs[index].myrth_dur = 0;
	chars_mobs_npcs[index].myrth_power = 0;
	chars_mobs_npcs[index].executor_dur = 0;
	chars_mobs_npcs[index].executor_power = 0;
	chars_mobs_npcs[index].torchlight_dur = 0;
	chars_mobs_npcs[index].torchlight_power = 0;
	chars_mobs_npcs[index].stoneskin_dur = 0;
	chars_mobs_npcs[index].stoneskin_power = 0;
	chars_mobs_npcs[index].shield = 0;
	chars_mobs_npcs[index].shieldoflight = 0;
	chars_mobs_npcs[index].wingsoflight = 0;
	chars_mobs_npcs[index].protfromfire_dur = 0;
	chars_mobs_npcs[index].protfromfire_power = 0;
	chars_mobs_npcs[index].protfromcold_dur = 0;
	chars_mobs_npcs[index].protfromcold_power = 0;
	chars_mobs_npcs[index].protfromstatic_dur = 0;
	chars_mobs_npcs[index].protfromstatic_power = 0;
	chars_mobs_npcs[index].protfromacid_dur = 0;
	chars_mobs_npcs[index].protfromacid_power = 0;
	chars_mobs_npcs[index].protfrompoison_dur = 0;
	chars_mobs_npcs[index].protfrompoison_power = 0;
	chars_mobs_npcs[index].protfromdisease_dur = 0;
	chars_mobs_npcs[index].protfromdisease_power = 0;
	chars_mobs_npcs[index].protofspirit_dur = 0;
	chars_mobs_npcs[index].protofspirit_power = 0;
	chars_mobs_npcs[index].protofmind_dur = 0;
	chars_mobs_npcs[index].protofmind_power = 0;
	chars_mobs_npcs[index].shieldfromfire_power = 0;
	chars_mobs_npcs[index].shieldfromfire_dur = 0;
	chars_mobs_npcs[index].shieldfromcold_power = 0;
	chars_mobs_npcs[index].shieldfromcold_dur = 0;
	chars_mobs_npcs[index].shieldfromstatic_power = 0;
	chars_mobs_npcs[index].shieldfromstatic_dur = 0;
	chars_mobs_npcs[index].shieldfromacid_power = 0;
	chars_mobs_npcs[index].shieldfromacid_dur = 0;
	chars_mobs_npcs[index].ironshirt_power = 0;
	chars_mobs_npcs[index].ironshirt_dur = 0;
	chars_mobs_npcs[index].hammerhands_power = 0;
	chars_mobs_npcs[index].hammerhands_dur = 0;
	chars_mobs_npcs[index].might_dur = 0;
	chars_mobs_npcs[index].might_power = 0;
	chars_mobs_npcs[index].dash_dur = 0;
	chars_mobs_npcs[index].dash_power = 0;
	chars_mobs_npcs[index].precision_dur = 0;
	chars_mobs_npcs[index].precision_power = 0;
	chars_mobs_npcs[index].concentration_dur = 0;
	chars_mobs_npcs[index].concentration_power = 0;
	chars_mobs_npcs[index].glamour_dur = 0;
	chars_mobs_npcs[index].glamour_power = 0;
	chars_mobs_npcs[index].luckyday_dur = 0;
	chars_mobs_npcs[index].luckyday_power = 0;	
	chars_mobs_npcs[index].mobility_dur = 0;
	chars_mobs_npcs[index].mobility_power = 0;
	chars_mobs_npcs[index].dash_dur = 0;
	chars_mobs_npcs[index].dash_power = 0;
	chars_mobs_npcs[index].invisibility = 0;
	chars_mobs_npcs[index].deadlyswarm = 0;
	chars_mobs_npcs[index].darkcontamination = 0;
	chars_mobs_npcs[index].fingerofdeath = 0;	
	chars_mobs_npcs[index].holyblood_dur = 0;
	chars_mobs_npcs[index].holyblood_power = 0;
	chars_mobs_npcs[index].basiliskbreath = 0;
	chars_mobs_npcs[index].dayofgods_power = 0;
	chars_mobs_npcs[index].dayofgods_dur = 0;
	if chars_mobs_npcs[index].person == "char" then
		tmp_name_dead = chars_stats[index].name;
	elseif chars_mobs_npcs[index].person=="mob" then
		tmp_name1 = chars_mobs_npcs[index].class;
		tmp_name2 = "lognames.mob_names." .. tmp_name1;
		tmp_name3 = loadstring("return " .. tmp_name2)();
		tmp_name_dead = tmp_name3;
		tmpexp = tmpexp+chars_mobs_npcs[index].expa;
		if chars_mobs_npcs[current_mob].person == "char" then
			chars_mobs_npcs[current_mob].tmpexpdeaths = chars_mobs_npcs[current_mob].tmpexpdeaths+1;
		end;
		chars_mobs_npcs[index].expa = 0;
-- creating a loot bag --FIX check if there is no bag at coords, check fullness, create another bag at other coordinates if fulness is 75% or more		
		table.insert(bags_list,{x=chars_mobs_npcs[index].x,y=chars_mobs_npcs[index].y,xi= chars_mobs_npcs[index].x,yi= chars_mobs_npcs[index].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
		for i=1,#chars_mobs_npcs[index].inventory_list do
			table.insert(bags_list[#bags_list],{ttxid=chars_mobs_npcs[index].inventory_list[i].ttxid,q=chars_mobs_npcs[index].inventory_list[i].q,w=chars_mobs_npcs[index].inventory_list[i].w,e=chars_mobs_npcs[index].inventory_list[i].e,r=chars_mobs_npcs[index].inventory_list[i].r,h=chars_mobs_npcs[index].inventory_list[i].h});
		end;
		chars_mobs_npcs[index].inventory_list = {};
		--[[
		table.insert(bags,{});
		for k=1,15 do
			bags[#bags_list][k] = {};
			for l=1,11 do
				bags[#bags_list][k][l] = 0;
			end;
		end;]]
		helpers.zeroLastBag ();
		sorttarget = "bag";
		dragfrom="bag"
		current_bag = #bags_list;
		th = #bags_list;
		bagid = #bags_list;
		helpers.resort_inv(bagid);
		chars_mobs_npcs[index].equipment = {rh=0,lh=0,ranged=0,ammo=0, armor=0,head=0,boots=0,gloves=0,cloak=0,belt=0,amulet=0,ring1=0,ring2=0,ring3=0,ring4=0,ring5=0,ring6=0,art=0};
		chars_mobs_npcs[index].inventory_list = {};
		--/ creating a loot bag
	end;
	helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.death[chars_mobs_npcs[index].gender]);
	--helpers.addToActionLog( helpers.mobName(index) .. lognames.actions.death[chars_mobs_npcs[index].gender] .. " N" .. index); --FIXME

	if #mobs_revengers > 0 then
		missle_drive="revenge";
		missle_type="revenge";
		d_timer = 0;
		md_timer = 0;
		draw.boom();
	end;
	if endbattle == 1 then -- end of the battle, counting of exp
		local tmpchars = chars_around;
		letaBattleFinishes ();
		local quater_exp = tmpexp/chars^2;
		local sum_of_tmpexpdmg = 0;
		local sum_of_tmpexplost = 0;
		local sum_of_tmpexpdeaths = 0;
		for i=1,chars do
			sum_of_tmpexpdmg = sum_of_tmpexpdmg+chars_mobs_npcs[i].tmpexpdmg;
			sum_of_tmpexplost = sum_of_tmpexplost+chars_mobs_npcs[i].tmpexplost;
			sum_of_tmpexpdeaths = sum_of_tmpexpdeaths+chars_mobs_npcs[i].tmpexpdeaths;
		end;
		for i=1,chars do
			local countedexp=math.ceil(quater_exp+quater_exp*chars_mobs_npcs[i].tmpexpdmg/math.max(1,sum_of_tmpexpdmg)+quater_exp*chars_mobs_npcs[i].tmpexplost/math.max(1,chars_mobs_npcs[i].tmpexplost)+quater_exp*chars_mobs_npcs[i].tmpexpdeaths/math.max(1,sum_of_tmpexpdeaths));
			chars_stats[i].xp = chars_stats[i].xp+countedexp;
			helpers.addToActionLog( chars_stats[i].name .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. countedexp .. lognames.actions.ofexp);
		end;
	end;
	damage.ifBattleEnds();
end;

function damage.uncondNow (index)
	chars_mobs_npcs[index].status = 0;
	chars_mobs_npcs[index].rt = 0;
	chars_mobs_npcs[index].invisibility = 0;
	chars_mobs_npcs[index].freeze = 0;
	chars_mobs_npcs[index].stun = 0;
	chars_mobs_npcs[index].sleep = 0;
	chars_mobs_npcs[index].protectionmode = "none";
	chars_mobs_npcs[index].trick = "none";
	chars_mobs_npcs[index].moral = 0;
	chars_mobs_npcs[index].freeze = 0;
	chars_mobs_npcs[index].stun = 0;
	chars_mobs_npcs[index].sleep = 0;
	chars_mobs_npcs[index].panic = 0;
	chars_mobs_npcs[index].charm = 0;
	chars_mobs_npcs[index].berserk = 0;
	chars_mobs_npcs[index].enslave = 0;
	chars_mobs_npcs[index].stone_power = 0;
	chars_mobs_npcs[index].regen_power = 0;
	chars_mobs_npcs[index].regen_dur = 0;
	chars_mobs_npcs[index].healaura_power = 0;
	chars_mobs_npcs[index].healaura_dur = 0;
	chars_mobs_npcs[index].darkgasp = 0;
	chars_mobs_npcs[index].fear = 0;
	chars_mobs_npcs[index].heroism_dur = 0;
	chars_mobs_npcs[index].heroism_power = 0;
	chars_mobs_npcs[index].bless = 0;
	chars_mobs_npcs[index].fate = 0;
	chars_mobs_npcs[index].fateself = 0;
	chars_mobs_npcs[index].rage = 0;
	chars_mobs_npcs[index].haste = 0;
	chars_mobs_npcs[index].prayer_dur = 0;
	chars_mobs_npcs[index].prayer_power = 0;
	chars_mobs_npcs[index].myrth_dur = 0;
	chars_mobs_npcs[index].myrth_power = 0;
	chars_mobs_npcs[index].executor_dur = 0;
	chars_mobs_npcs[index].executor_power = 0;
	chars_mobs_npcs[index].hourofpower_dur = 0;
	chars_mobs_npcs[index].hourofpower_power = 0;	
	chars_mobs_npcs[index].ironshirt_power = 0;
	chars_mobs_npcs[index].ironshirt_dur = 0;
	chars_mobs_npcs[index].hammerhands_power = 0;
	chars_mobs_npcs[index].hammerhands_dur = 0;
	chars_mobs_npcs[index].might_dur = 0;
	chars_mobs_npcs[index].might_power = 0;
	chars_mobs_npcs[index].dash_dur = 0;
	chars_mobs_npcs[index].dash_power = 0;
	chars_mobs_npcs[index].precision_dur = 0;
	chars_mobs_npcs[index].precision_power = 0;
	chars_mobs_npcs[index].concentration_dur = 0;
	chars_mobs_npcs[index].concentration_power = 0;
	chars_mobs_npcs[index].glamour_dur = 0;
	chars_mobs_npcs[index].glamour_power = 0;
	chars_mobs_npcs[index].luckyday_dur = 0;
	chars_mobs_npcs[index].luckyday_power = 0;	
	chars_mobs_npcs[index].mobility_dur = 0;
	chars_mobs_npcs[index].mobility_power = 0;
	chars_mobs_npcs[index].dash_dur = 0;
	chars_mobs_npcs[index].dash_power = 0;
	chars_mobs_npcs[index].invisibility = 0;
	tmp_name_uncond = chars_stats[index].name;
	helpers.addToActionLog( tmp_name_uncond .. lognames.actions.uncond);
	--
	if not helpers.partyAlive () then
		game_status = "gameover";
	end;
end;

function damage.countMultiattack(index)
	local multiattack = chars_mobs_npcs[index].multiattack; --FIXME add hands damage, weapons condition, st, rt
	return multiattack;
end;

function damage.weaponClassInHand(index,hand)
	local currentMobWeaponClass = "knuckle";
	local currentMobWeaponSubClass = "knuckle";
	if chars_mobs_npcs[index]["equipment"][hand] > 0 then
		currentMobWeaponClass = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class
		currentMobWeaponSubClass = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].subclass
	end;
	return currentMobWeaponClass,currentMobWeaponSubClass;
end;	

function damage.mightModifer(index,hand)
	local currentMobWeaponClass,currentMobWeaponSubClass = damage.weaponClassInHand(index,hand);
	local modifer = 0;
	local secondhand = "lh";
	if hand == "rh" then
		secondhand = "lh";
	elseif hand == "rh1" then
		secondhand = "lh1";
	elseif hand == "rh2" then
		secondhand = "lh2";
	end;
	if currentMobWeaponClass == "knuckle" then
		modifer = 0.15;
	elseif  currentMobWeaponSubClass == "claws" then
		modifer = 0.05;
	elseif  currentMobWeaponSubClass == "nipper" then
		modifer = 0.3;
	elseif  currentMobWeaponSubClass == "tentacles" then
		modifer = 0.1;
	elseif  currentMobWeaponSubClass == "thsword" then
		modifer = 1.5;
	elseif currentMobWeaponSubClass == "shortsword" then
		modifer = 0.075;
	elseif currentMobWeaponClass == "sword" then
		modifer = 0.1;
	elseif currentMobWeaponSubClass == "hetchet" and #chars_mobs_npcs[index]["arms"] <= secondhand and chars_mobs_npcs[index]["equipment"][secondhand] == 0 then
		modifer = 0.175;
	elseif currentMobWeaponClass == "axe" then
		modifer = 0.15;
	elseif currentMobWeaponClass == "crushing" then
		modifer = 0.2;
	elseif currentMobWeaponClass == "flagpole" and #chars_mobs_npcs[index]["arms"] <= secondhand and chars_mobs_npcs[index]["equipment"][secondhand] == 0 then
		modifer = 0.15;
	elseif currentMobWeaponClass == "flagpole" and #chars_mobs_npcs[index]["arms"] <= secondhand and chars_mobs_npcs[index]["equipment"][secondhand] > 0 then
		modifer = 0.125;
	elseif currentMobWeaponClass == "staff" then
		modifer = 0.15;
	elseif currentMobWeaponClass == "dagger" then
		modifer = 0.05;
	end;
	if chars_mobs_npcs[index]["arms_health"][hand] == 0 then --attacking hand broken
		modifer = 0;
	elseif chars_mobs_npcs[index]["arms_health"][secondhand] == 0 and chars_mobs_npcs[index]["equipment"][secondhand] == 0 
	and (currentMobWeaponSubClass == "thsword" or currentMobWeaponSubClass == "poleaxe" or currentMobWeaponSubClass == "staff" or currentMobWeaponClass == "flagpole" or currentMobWeaponSubClass == "hetchet") then
		modifer = 0.025;
	end;
	return modifer;
end;

function damage.countDamage(index,hand,flag)
	helpers.recalcBattleStats (index);
	local might_modifer = damage.mightModifer(index,hand);
	local dice = 0;
	if flag == "min" or chars_mobs_npcs[index].curse > chars_mobs_npcs[index].bless == 0 then
		dice = 1;
	elseif flag == "max" or chars_mobs_npcs[index].curse < chars_mobs_npcs[index].bless == 0 then
		dice = chars_mobs_npcs[index]["melee_stats"][hand].bmel
	else
		dice = math.random(chars_mobs_npcs[index]["melee_stats"][hand].bmel); -- main variant
	end;
	local dmg = math.ceil((dice*chars_mobs_npcs[index]["melee_stats"][hand].amel+chars_mobs_npcs[index]["melee_stats"][hand].cmel+might_modifer*chars_mobs_npcs[index].mgt)+chars_mobs_npcs[index].heroism_power);
	return dmg;
end;

function damage.calcArmorStats(index,hitzone,attacked_from)
	local add_ac,add_dt,add_dr = 0;
	local bodyArmorPieces = {armor=0,belt=0,cloak=0};
	local add_ac = 0;
	local add_dt = 0;
	local add_dr = 0;
	if hitzone == "head" then 
		if chars_mobs_npcs[index]["equipment"].head > 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].head].q > 0 then
			add_ac = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].head].ttxid].ac;
			add_dt = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].head].ttxid].dt;
			add_dr = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].head].ttxid].dr;
		end;
	elseif hitzone == "body" then
		if chars_mobs_npcs[index]["equipment"].armor > 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].q > 0 then
			bodyArmorPieces.armor = 1;
			add_ac = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].ac;
			add_dt = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].dt;
			add_dr = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].dr;
		end;
		if chars_mobs_npcs[index]["equipment"].belt > 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].belt].q > 0 then
			bodyArmorPieces.belt = 1;
			add_ac = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].belt].ttxid].ac;
			add_dt = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].belt].ttxid].dt;
			add_dr = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].belt].ttxid].dr;
		end;
		if chars_mobs_npcs[index]["equipment"].cloak > 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].cloak].q > 0 
		and (attacked_from=="back" or attacked_from=="lback" or attacked_from=="rback") then
			bodyArmorPieces.cloak = 1;
			add_ac = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].cloak].ttxid].ac;
			add_dt = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].cloak].ttxid].dt;
			add_dr = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].cloak].ttxid].dr;
		end;
	elseif hitzone == "rh" or hitzone == "lh" or hitzone == "rh1" or hitzone == "lh1" or hitzone == "rh2" or hitzone == "lh2" then
		if chars_mobs_npcs[index]["equipment"].gloves > 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].gloves].q > 0 then
			add_ac = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].gloves].ttxid].ac;
			add_dt = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].gloves].ttxid].dt;
			add_dr = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].gloves].ttxid].dr;
		end;
	end;
	if hitzone == "rf" or hitzone == "lf" or hitzone == "rf1" or hitzone == "lf1" or hitzone == "rf2" or hitzone == "lf2" or hitzone == "rf3" or hitzone == "lf3" then
		if chars_mobs_npcs[index]["equipment"].boots > 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].boots].q > 0 then
			add_ac = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].boots].ttxid].ac;
			add_dt = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].boots].ttxid].dt;
			add_dr = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].boots].ttxid].dr;
		end;
	end;
	return add_ac,add_dt,add_dr;
end;

function damage.weaponpEffect(index,hitzone,wpEffect)
	local victim_name = helpers.mobName(victim);
	print(">>>",index,victim_nam);
	if wpEffect == "hit" then
		if hitzone == "head" then
			local effect  = math.random(1,5);
			if effect == 1 and helpers.traumaNature(victim) then
				dmgrt = chars_mobs_npcs[index].rt;
				chars_mobs_npcs[index].rt = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.shocked[chars_mobs_npcs[index].gender]);
			elseif effect == 2  and helpers.traumaNature(victim) then
				chars_mobs_npcs[index].sleep = math.random(10,15);
				helpers.addToActionLog( victim_name .. lognames.actions.sleep[chars_mobs_npcs[index].gender]);
			elseif effect == 3  and helpers.traumaNature(victim) then
				chars_mobs_npcs[index].stun = math.random(10,15);
				helpers.addToActionLog( victim_name .. lognames.actions.stun[chars_mobs_npcs[index].gender]);
			elseif effect == 4  and helpers.traumaNature(victim) then
				chars_mobs_npcs[index].silence = math.random(5,10);
				helpers.addToActionLog( victim_name .. lognames.actions.silenced[chars_mobs_npcs[index].gender]);
			elseif effect == 5  and helpers.traumaNature(victim) then
				chars_mobs_npcs[index].charm = math.random(5,10);
				helpers.addToActionLog( victim_name .. lognames.actions.charmed[chars_mobs_npcs[index].gender]);
			end;
		elseif hitzone == "body" then
			local effect  = math.random(1,2);
			if effect == 1 and helpers.traumaNature(victim) then
				dmgrt = chars_mobs_npcs[index].rt;
				chars_mobs_npcs[index].rt = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.shocked[chars_mobs_npcs[index].gender]);
			elseif effect == 2  and helpers.traumaNature(victim) then
				dmgst = chars_mobs_npcs[index].st;
				chars_mobs_npcs[index].st = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.loststamina[chars_mobs_npcs[index].gender]);
			end;
		elseif hitzone == "rh" or hitzone == "lh" or hitzone == "rh1" or hitzone == "lh1" or hitzone == "rh2" or hitzone == "lh2" then
			
		elseif hitzone == "rf" or hitzone == "lf" or hitzone == "rf1" or hitzone == "lf1" or hitzone == "rf2" or hitzone == "lf2" or hitzone == "rf3" or hitzone == "lf3" then	
		
		end;
	end;
	if wpEffect == "crush" then
		if hitzone == "head" then
			local effect  = math.random(1,6);
			if effect == 1 and helpers.traumaNature(victim) then
				dmgrt = chars_mobs_npcs[index].rt;
				chars_mobs_npcs[index].rt = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.shocked[chars_mobs_npcs[index].gender]);
			elseif effect == 2  and helpers.traumaNature(victim) then
				chars_mobs_npcs[index].paralyze = chars_mobs_npcs[index].paralyze + math.random(5,10);
				helpers.addToActionLog( victim_name .. lognames.actions.paralyzed[chars_mobs_npcs[index].gender]);
			elseif effect == 3  and helpers.traumaNature(victim) then
				dmgsp = chars_mobs_npcs[index].sp;
				chars_mobs_npcs[index].sp = 0;
			elseif effect == 4  and helpers.traumaNature(victim) then
				chars_mobs_npcs[index].silence = math.random(5,10);
				helpers.addToActionLog( victim_name .. lognames.actions.silenced[chars_mobs_npcs[index].gender]);
			elseif effect == 5  and helpers.traumaNature(victim) then
				chars_mobs_npcs[index].berserk = math.random(5,10);
				helpers.addToActionLog( victim_name .. lognames.actions.berserk[chars_mobs_npcs[index].gender]);
			elseif effect == 6  and helpers.traumaNature(victim) then
				chars_mobs_npcs[index].madness = chars_mobs_npcs[index].madness + math.random(5,10);
				helpers.addToActionLog( victim_name .. lognames.actions.mad[chars_mobs_npcs[index].gender]);
			end;
		elseif hitzone == "body" then
			local effect  = math.random(1,2);
			if effect == 1 and helpers.traumaNature(victim) then
				dmgst = chars_mobs_npcs[index].st;
				chars_mobs_npcs[index].st = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.loststamina[chars_mobs_npcs[index].gender]);
			elseif effect == 2  and helpers.traumaNature(victim) then
				chars_mobs_npcs[index].paralyze = chars_mobs_npcs[index].paralyze + math.random(5,10);
				helpers.addToActionLog( victim_name .. lognames.actions.paralyzed[chars_mobs_npcs[index].gender]);
			end;
		elseif hitzone == "rh" or hitzone == "lh" or hitzone == "rh1" or hitzone == "lh1" or hitzone == "rh2" or hitzone == "lh2" then
			local chance = math.random(1,3);
			if chance == 1 then
			chars_mobs_npcs[index][hitzone] = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
			end;
		elseif hitzone == "rf" or hitzone == "lf" or hitzone == "rf1" or hitzone == "lf1" or hitzone == "rf2" or hitzone == "lf2" or hitzone == "rf3" or hitzone == "lf3" then	
			local chance = math.random(1,3);
			if chance == 1 then
			chars_mobs_npcs[index][hitzone] = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
			end;
		end;
	end;
	if wpEffect == "chop" then
		if hitzone == "head" then
			local effect  = math.random(1,2);
			if effect == 1 and helpers.traumaNature(victim) then
				chars_mobs_npcs[index].bleeding = 	chars_mobs_npcs[index].bleeding + math.random(1,10);
				helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[index].gender]);
			elseif effect == 2 and helpers.traumaNature(victim) then
				dmgsp = chars_mobs_npcs[index].sp;
				chars_mobs_npcs[index].sp = 0;
			end;
		elseif hitzone == "body" then
			chars_mobs_npcs[index].bleeding = chars_mobs_npcs[index].bleeding + math.random(1,10);
			helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[index].gender]);
		elseif hitzone == "rh" or hitzone == "lh" or hitzone == "rh1" or hitzone == "lh1" or hitzone == "rh2" or hitzone == "lh2" then
			chars_mobs_npcs[index][hitzone] = 0;
			helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
		elseif hitzone == "rf" or hitzone == "lf" or hitzone == "rf1" or hitzone == "lf1" or hitzone == "rf2" or hitzone == "lf2" or hitzone == "rf3" or hitzone == "lf3" then	
			chars_mobs_npcs[index][hitzone] = 0;
			helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
		end;
	end;
	if wpEffect == "cut" then
		if hitzone == "head" then
			chars_mobs_npcs[index].bleeding = 	chars_mobs_npcs[index].bleeding + math.random(5,10);
			helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[index].gender]);	
		elseif hitzone == "body" then
			chars_mobs_npcs[index].bleeding = 	chars_mobs_npcs[index].bleeding + math.random(5,10);
			helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[index].gender]);	
		elseif hitzone == "rh" or hitzone == "lh" or hitzone == "rh1" or hitzone == "lh1" or hitzone == "rh2" or hitzone == "lh2" then
			local chance = math.random(1,2);
			if chance == 1 then
				chars_mobs_npcs[index][hitzone] = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
			end;
		elseif hitzone == "rf" or hitzone == "lf" or hitzone == "rf1" or hitzone == "lf1" or hitzone == "rf2" or hitzone == "lf2" or hitzone == "rf3" or hitzone == "lf3" then	
			local chance = math.random(1,2);
			if chance == 1 then
				chars_mobs_npcs[index][hitzone] = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
			end;
		end;
	end;
	if wpEffect == "pierce" then
		if hitzone == "head" then
			if helpers.traumaNature(victim) then
				local randomEye = math.random(1,2);
				if randomEye == 1 and chars_mobs_npcs[index].reye == 1 then
					chars_mobs_npcs[index].reye = 0;
				elseif randomEye ==1 and chars_mobs_npcs[index].leye == 1 then
					chars_mobs_npcs[index].leye = 0;
				elseif randomEye == 2 and chars_mobs_npcs[index].leye == 1  then
					chars_mobs_npcs[index].leye = 0;
				elseif randomEye == 2 and chars_mobs_npcs[index].reye == 1  then
					chars_mobs_npcs[index].reye = 0;
				end;
				helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
			end;
		elseif hitzone == "body" then
			if helpers.traumaNature(victim) then
				local effect  = math.random(1,2);
				if effect == 1 then
					chars_mobs_npcs[index].pneumothorax = 1;
					helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
				elseif effect == 2 then
					chars_mobs_npcs[index].bleeding = 	chars_mobs_npcs[index].bleeding + math.random(1,5);
					helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[index].gender]);	
				end;
			end;
		elseif hitzone == "rh" or hitzone == "lh" or hitzone == "rh1" or hitzone == "lh1" or hitzone == "rh2" or hitzone == "lh2" then
			local chance = math.random(1,4);
			if chance == 1 then
				chars_mobs_npcs[index][hitzone] = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
			end;	
		elseif hitzone == "rf" or hitzone == "lf" or hitzone == "rf1" or hitzone == "lf1" or hitzone == "rf2" or hitzone == "lf2" or hitzone == "rf3" or hitzone == "lf3" then	
			local chance = math.random(1,4);
			if chance == 1 then
				chars_mobs_npcs[index][hitzone] = 0;
				helpers.addToActionLog( victim_name .. lognames.actions.gottrauma[chars_mobs_npcs[index].gender]);
			end;
		end;
	end;
	if wpEffect == "tear" then
		if hitzone == "head" then
			chars_mobs_npcs[index].bleeding = 	chars_mobs_npcs[index].bleeding + math.random(1,5);
			helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[index].gender]);	
		elseif hitzone == "body" then
			chars_mobs_npcs[index].bleeding = 	chars_mobs_npcs[index].bleeding + math.random(1,5);
			helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[index].gender]);	
		elseif hitzone == "rh" or hitzone == "lh" or hitzone == "rh1" or hitzone == "lh1" or hitzone == "rh2" or hitzone == "lh2" then
			if helpers.traumaNature(victim) then
				chars_mobs_npcs[index].bleeding = 	chars_mobs_npcs[index].bleeding + math.random(1,5);
				helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[index].gender]);	
			end;
		elseif hitzone == "rf" or hitzone == "lf" or hitzone == "rf1" or hitzone == "lf1" or hitzone == "rf2" or hitzone == "lf2" or hitzone == "rf3" or hitzone == "lf3" then
			if helpers.traumaNature(victim) then
				chars_mobs_npcs[index].bleeding = 	chars_mobs_npcs[index].bleeding + math.random(1,5);
				helpers.addToActionLog( victim_name .. lognames.actions.isbleeding[chars_mobs_npcs[index].gender]);	
			end;
		end;
	end;
end;

function damage.armorDestroying (hitzone,attacked_from,deltaDMG)
	local bodyArmorPieces = {armor=0,belt=0,cloak=0};
	local deltaDMGarmor = 0;
	local deltaDMGbelt = 0;
	local deltaDMGcloak = 0;
	if hitzone == "head" and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].head].h == 0 and inventory[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].head].ttxid].material < deltaDMG then
		chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].head].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].head].q - deltaDMG*armorDmgMod;
		local armor_piece_q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].helm].q;
		if armor_piece_q > 0 and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].head].q == 0 then
			--helm destroyed
		end;
	end;	
	if hitzone == "body" then
		if (attacked_from == "back" or attacked_from == "lback" or attacked_from == "rback") 
		and bodyArmorPieces.cloak == 1 then
			if bodyArmorPieces.armor + bodyArmorPieces.belt == 0 then
				deltaDMGcloak = deltaDMG;
			elseif bodyArmorPieces.armor + bodyArmorPieces.belt == 1 then
				deltaDMGcloak = math.ceil(0.5*deltaDMG);
			elseif bodyArmorPieces.armor + bodyArmorPieces.belt == 2 then
				deltaDMGcloak = math.ceil(0.2*deltaDMG);
			end;
			local armor_piece_q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].cloak].q;
			if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].cloak].h == 0 and inventory[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].cloak].ttxid].material < deltaDMGcloak then
				chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].cloak].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].cloak].q - deltaDMGcloak*armorDmgMod;
			end;
			if armor_piece_q > 0 and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].cloak].q == 0 then
				--cloak destroyed
			end;	
		end;
		if bodyArmorPieces.belt == 1 then
			if bodyArmorPieces.armor + bodyArmorPieces.cloak == 0 then
				deltaDMGbelt = deltaDMG;
			elseif bodyArmorPieces.armor + bodyArmorPieces.cloak == 1 then
				deltaDMGbelt = math.ceil(0.5*deltaDMG);
			elseif bodyArmorPieces.armor + bodyArmorPieces.cloak == 2 then
				deltaDMGbelt = math.ceil(0.2*deltaDMG);
			end;
			local armor_piece_q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].belt].q;
			if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].belt].h == 0 and inventory[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].belt].ttxid].material < deltaDMGbelt then
				chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].belt].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].belt].q - deltaDMGbelt*armorDmgMod;
			end;
			if armor_piece_q > 0 and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].belt].q == 0 then
				--belt destroyed
			end;	
		end;
		if bodyArmorPieces.armor == 1 then
			if bodyArmorPieces.belt + bodyArmorPieces.cloak == 0 then
				deltaDMGarmor = deltaDMG;
			elseif bodyArmorPieces.belt + bodyArmorPieces.cloak == 1 then
				deltaDMGarmor = math.ceil(0.5*deltaDMG);
			elseif bodyArmorPieces.belt + bodyArmorPieces.cloak == 2 then
				deltaDMGarmor = math.ceil(0.6*deltaDMG);
			end;
			local armor_piece_q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].q;
			if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].h == 0 and inventory[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].ttxid].material < deltaDMGarmor then
				chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].q - deltaDMGarmor*armorDmgMod;
			end;
			if armor_piece_q > 0 and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].armor].q == 0 then
				--armor destroyed
			end;	
		end;
	end;
	if (hitzone == "rh" or hitzone == "lh" or hitzone == "rh1" or hitzone == "lh1" or hitzone == "rh2" or hitzone == "lh2") and inventory[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].ttxid].material < deltaDMG then
		local armor_piece_q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].q;
		chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].q - deltaDMG*armorDmgMod;
		if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].h == 0 and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].gloves].q == 0 then
			--gloves destroyed
		end;
	end;
	if (hitzone == "rf" or hitzone == "lf" or hitzone == "rf1" or hitzone == "lf1" or hitzone == "rf2" or hitzone == "lf2" or hitzone == "rf3" or hitzone == "lf3") and inventory[chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].boots].ttxid].material < deltaDMG then
		local armor_piece_q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].boots].q;
		chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].boots].q = chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].boots].q - deltaDMG*armorDmgMod;
		if chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].boots].h == 0 and armor_piece_q > 0 and chars_mobs_npcs[victim]["inventory_list"][chars_mobs_npcs[victim]["equipment"].boots].q == 0 then
			--boots destroyed
		end;
	end;
end;

function damage.meleeAttackTool (index) --FIXME add to damage.meleeAttack calls
	local selected_tool = nil;
	if chars_mobs_npcs[index]["arms"] and #chars_mobs_npcs[index]["arms"] > 0 then --FIXME mob has noy only hands
		selected_tool = chars_mobs_npcs[index]["arms"][global.multiattack];
	else
		local possible_tools = {};
		if chars_mobs_npcs[index]["tail"] and #chars_mobs_npcs[index]["tail"] > 0 then
			table.insert(possible_tools,"tail");
		end;
		if chars_mobs_npcs[index]["teeth"] and #chars_mobs_npcs[index]["teeth"] > 0 then
			table.insert(possible_tools,"teeth");
		end;
		if chars_mobs_npcs[index]["horns"] and #chars_mobs_npcs[index]["horns"] > 0 then
			table.insert(possible_tools,"horns");
		end;
		selected_tool = possible_tools[math.random(1,#possible_tools)];
	end;
	return selected_tool
end;

function damage.setProtectionMode ()
	if missle_type == "dencedefence" or missle_type == "savingstick" then
		chars_mobs_npcs[current_mob].protectionmode = "parry";
	elseif missle_type == "torero" or missle_type == "top" or missle_type == "acrobat" or missle_type == "shore" then
		chars_mobs_npcs[current_mob].protectionmode = "dodge";
		chars_mobs_npcs[current_mob].trick = missle_type;
	elseif missle_type == "absoluteblock" then
		chars_mobs_npcs[current_mob].protectionmode = "block";
	elseif missle_type == "bump" or missle_type == "ribhit" or missle_type == "umbrella" then
		chars_mobs_npcs[current_mob].protectionmode = "block";
		chars_mobs_npcs[current_mob].trick = missle_type;
	end;
	local _minus = tricks.tricks_tips[missle_type].stamina;
	damage.SPminus(current_mob,_minus);
	damage.RTminus(current_mob,_minus);
	helpers.addToActionLog( chars_stats[current_mob].name .. " " .. lognames.actions.takenprotectionpose[chars_mobs_npcs[current_mob].gender]);
	restoreRT();
end;

function damage.setSelfBuff ()
end;

function damage.setSpecialAttack ()
end;

function damage.falseDamager(x,y,r)
	local new_damager_id = false
	local ring = boomareas.ringArea(x,y);
	local shored = {};
	for i=1,r do
		for h=1,#ring[i] do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == x and chars_mobs_npcs[j].y == y then
					table.insert(shored,j);
				end;
			end;
		end;
	end;
	if #shored > 0 then
		new_damager_id = shored[math.random(1,#shored)];
	end;
	return id;
end;

function damage.damageOfLandscape(index,x,y)
	if dlandscape_obj[y][x] == "fire" and dlandscape_duration[y][x] > 0 then
		local dmgland = dlandscape_power[y][x];
		local name = helpers.mobName(index);
		local dmg = damage.magicalRes (index,dmgland,"fire");
		damage.HPminus(index,dmg);
		dlandscape_duration[y][x] = dlandscape_duration[y][x] - 1;
		if dlandscape_duration[y][x] == 0 then
			dlandscape_power[y][x] = 0;
			dlandscape_obj[y][x] = 0;
			boomareas.ashGround (a,b)
			helpers.clearLights (a,b);
		end;
		helpers.addToActionLog( name .. lognames.actions.gotdmg[chars_mobs_npcs[index].gender]  .. lognames.actions.metr .. lognames.actions.ofhp .. " " .. dmg .. types_of_damage.fire);
	end;
	if alandscape_obj[y][x] == "poison" then
		local dmg=alandscape_power[y][x]
		local name = helpers.mobName(index);
		if chars_mobs_npcs[index].poison_power <= alandscape_power[y][x] then
			chars_mobs_npcs[index].poison_power = alandscape_power[y][x];
			chars_mobs_npcs[index].poison_dur = chars_mobs_npcs[index].poison_dur + 3;
			helpers.addToActionLog( name .. lognames.actions.poisoned[chars_mobs_npcs[index].gender])
		end;
		alandscape_duration[y][x]=alandscape_duration[y][x] - 1;
		if alandscape_duration[y][x] == 0 then
			alandscape_power[y][x] = 0;
			alandscape_obj[y][x] = 0;
			boomareas.ashGround (a,b)
			helpers.clearLights (a,b);
		end;
	end;
	if dlandscape_obj[y][x] == "holy" and dlandscape_duration[y][x] > 0 then
		local dmgland = dlandscape_power[y][x];
		local name = helpers.mobName(index);
		local dmg = damage.magicalRes (index,dmgland,"light");
		if chars_mobs_npcs[index].locomotion == "walk" and chars_mobs_npcs[index].nature == "undead" then
			damage.HPminus(index,dmg,false);
			helpers.addToActionLog( name .. lognames.actions.gotdmg[chars_mobs_npcs[index].gender]  .. lognames.actions.metr .. lognames.actions.ofhp .. " " .. dmg .. types_of_damage.light);
			dlandscape_duration[y][x] = dlandscape_duration[y][x] - 1;
		else
			damage.HPplus(index,dmg,true);
			dlandscape_duration[y][x] = dlandscape_duration[y][x] - 1;
		end;
		if dlandscape_duration[y][x] == 0 then
			dlandscape_power[y][x] = 0;
			dlandscape_obj[y][x] = 0;
			--boomareas.ashGround (a,b)
			--helpers.clearLights (a,b);
		end;
	end;
	if dlandscape_obj[y][x] == "twister" or dlandscape_obj[y][x] == "twisterpart" then
		trapped  = 1;
		chars_mobs_npcs[index].immobilize = chars_mobs_npcs[index].immobilize + 5;
		local name = helpers.mobName(index);
		helpers.addToActionLog( name .. lognames.actions.immobilized[chars_mobs_npcs[index].gender]);
	end;
end;

function damage.damageRandomizator(index,minvalue,maxvalue)
	local result = minvalue;
	if chars_mobs_npcs[index].curse == 0 then
		result = math.random(minvalue,maxvalue);
	end;
	return result;
end;
