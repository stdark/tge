mobsoperatons = {};

function mobsoperatons.addMob(index,person)
	local tmpclass = nil;
	local tmpclass2 = nil;
	if person == "mob" then
		tmpclass="mobs_stats." .. chars_mobs_npcs[index].class;
		tmpclass2=loadstring("return " .. tmpclass)();
		chars_mobs_npcs[index].face = tmpclass2.face;
		chars_mobs_npcs[index].control = "ai";
		chars_mobs_npcs[index].battleai = tmpclass2.battleai;
	elseif person == "npc" then
		tmpclass="mobs_stats." .. chars_mobs_npcs[index].class;
		tmpclass2=loadstring("return " .. tmpclass)();
		chars_mobs_npcs[index].control = "ai";
		chars_mobs_npcs[index].battleai = tmpclass2.battleai;
	elseif person == "char" then
		tmpclass2 = chars_stats[index];
		chars_mobs_npcs[index].control = "player";
		chars_mobs_npcs[index].face = chars_stats[index].face;
		chars_mobs_npcs[index].class = chars_stats[index].class;
		chars_mobs_npcs[index].race = chars_stats[index].race;
		chars_mobs_npcs[index].name = chars_stats[index].name;
		chars_mobs_npcs[index].ai = "player";
		chars_mobs_npcs[index].fraction = "party";
		chars_mobs_npcs[index].battleai = "any";
		chars_stats[index].xp = 0;
		chars_mobs_npcs[index].tmpexpdmg = 0;
		chars_mobs_npcs[index].tmpexplost = 0;
		chars_mobs_npcs[index].tmpexpdeaths = 0;
		chars_mobs_npcs[index].lv = chars_stats[index].lv;
		chars_mobs_npcs[index]["personality"] = {};
		chars_mobs_npcs[index]["personality"]["current"] = {};
		chars_mobs_npcs[index]["personality"]["current"].etiquette=chars_stats[index].etiquette;
		chars_stats[index].skillpoints = 50; --FIXME DEBUG
		if chars_mobs_npcs[index].class == "acolyte"
		or chars_mobs_npcs[index].class == "mage"
		or chars_mobs_npcs[index].class == "archmage"
		or chars_mobs_npcs[index].class == "necromancer"
		or chars_mobs_npcs[index].class == "lich"
		or chars_mobs_npcs[index].class == "rogue" --FIXME: debug
		or chars_mobs_npcs[index].class == "battlemage"
		then
			chars_mobs_npcs[index].sp_stat	= chars_mobs_npcs[index].int;
		elseif chars_mobs_npcs[index].class == "novice"
		or chars_mobs_npcs[index].class == "cleric"
		or chars_mobs_npcs[index].class == "priest"
		or chars_mobs_npcs[index].class == "heretic"
		or chars_mobs_npcs[index].class == "heresyarch"
		or chars_mobs_npcs[index].class == "monk"
		or chars_mobs_npcs[index].class == "ieromonk"
		or chars_mobs_npcs[index].class == "paladin"
		or chars_mobs_npcs[index].class == "deathknight"
		then
			chars_mobs_npcs[index].sp_stat	= chars_mobs_npcs[index].spr;
		elseif chars_mobs_npcs[index].class == "druid"
		or chars_mobs_npcs[index].class == "archdruid"
		or chars_mobs_npcs[index].class == "sorcerer"
		or chars_mobs_npcs[index].class == "warlock"
		or chars_mobs_npcs[index].class == "shaman"
		or chars_mobs_npcs[index].class == "ubershaman"
		then
			chars_mobs_npcs[index].sp_stat	= math.max(chars_mobs_npcs[index].int,chars_mobs_npcs[index].spr);
		end;
	end;

	if person ~= "char" and tmpclass2.spellbook == 1 then
		chars_mobs_npcs[index].spellnames = tmpclass2.spellnames;
		helpers.createSpellbookBySpellNames(tmpclass2.spellnames);
	end;

	if person ~= "char" and tmpclass2.warbook == 1 then
		helpers.createWarbook(i);
	end;
	
	if tmpclass2.shader then
		chars_mobs_npcs[index].shader = tmpclass2.shader;
	end;
	
	chars_mobs_npcs[index].region = "none"; --FIXME depends on region
	
	chars_mobs_npcs[index].multiattack = tmpclass2.multiattack;
	chars_mobs_npcs[index].status = 1;
	chars_mobs_npcs[index].id = index;
	chars_mobs_npcs[index].person = person;
	chars_mobs_npcs[index].sprite = tmpclass2.sprite;
	chars_mobs_npcs[index].aggro = 0;
	chars_mobs_npcs[index].aggressor = 0;
	chars_mobs_npcs[index].perks = tmpclass2.perks;
	chars_mobs_npcs[index].immunities = tmpclass2.immunities;

	--chars_mobs_npcs[index].class = tmpclass2.class;

	chars_mobs_npcs[index].hp_base = tmpclass2.lv*tmpclass2.hp_base_mod;
	chars_mobs_npcs[index].sp_base = tmpclass2.lv*tmpclass2.sp_base_mod;
	chars_mobs_npcs[index].st_base = tmpclass2.lv*tmpclass2.st_base_mod;
	
	chars_mobs_npcs[index].hp_coff = tmpclass2.hp_coff;
	chars_mobs_npcs[index].sp_coff = tmpclass2.sp_coff;
	chars_mobs_npcs[index].st_coff = tmpclass2.st_coff;
	
	chars_mobs_npcs[index].spells = tmpclass2.spells;
	chars_mobs_npcs[index].spellbook=tmpclass2.spellbook;
	chars_mobs_npcs[index].warbook = tmpclass2.warbook;
	chars_mobs_npcs[index].protectionmode = "none";
	chars_mobs_npcs[index].stealth = 0;
	for h=1,#tmpclass2["hitzones"] do
		for k=1,#tmpclass2["hitzones"][h] do
			if tmpclass2["hitzones"][h][k] == "rh" then
				chars_mobs_npcs[index].rh = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lh" then
				chars_mobs_npcs[index].lh = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "rh1" then
				chars_mobs_npcs[index].rh1 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lh1" then
				chars_mobs_npcs[index].lh1 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "rh2" then
				chars_mobs_npcs[index].rh2 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lh2" then
				chars_mobs_npcs[index].lh2 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "rf" then
				chars_mobs_npcs[index].rf = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lf" then
				chars_mobs_npcs[index].lf = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "rf1" then
				chars_mobs_npcs[index].rf1 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lf1" then
				chars_mobs_npcs[index].lf1 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "rf2" then
				chars_mobs_npcs[index].rf2 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lf2" then
				chars_mobs_npcs[index].lf2 = 1;
			end;
		end;
	end;
	chars_mobs_npcs[index].rt=0;
	chars_mobs_npcs[index].status=1;
	chars_mobs_npcs[index].nature=tmpclass2.nature;
	chars_mobs_npcs[index].gender=tmpclass2.gender;
	chars_mobs_npcs[index].size=tmpclass2.size;
	chars_mobs_npcs[index].lv=tmpclass2.lv;
	chars_mobs_npcs[index].expa=tmpclass2.expa;
	chars_mobs_npcs[index].motion=tmpclass2.motion;
	chars_mobs_npcs[index].nightvision=tmpclass2.nightvision;
	chars_mobs_npcs[index].leye = 1;
	chars_mobs_npcs[index].reye = 1;
	chars_mobs_npcs[index].fov = tmpclass2.fov;
	chars_mobs_npcs[index].track = tmpclass2.track;
	chars_mobs_npcs[index].motion = tmpclass2.motion;
	chars_mobs_npcs[index].hexes = tmpclass2.hexes;
	chars_mobs_npcs[index].hitzones = tmpclass2.hitzones;

	chars_mobs_npcs[index].claws = tmpclass2.claws;
	chars_mobs_npcs[index].teeth = tmpclass2.teeth;
	chars_mobs_npcs[index].horns = tmpclass2.horns;
	chars_mobs_npcs[index].hoofs = tmpclass2.hoofs;

	chars_mobs_npcs[index].inventory_list = tmpclass2.inventory_list;
	chars_mobs_npcs[index].equipment = tmpclass2.equipment;

	chars_mobs_npcs[index].mgt=tmpclass2.mgt;
	chars_mobs_npcs[index].enu=tmpclass2.enu;
	chars_mobs_npcs[index].dex=tmpclass2.dex;
	chars_mobs_npcs[index].spd=tmpclass2.spd;
	chars_mobs_npcs[index].acu=tmpclass2.acu;
	chars_mobs_npcs[index].sns=tmpclass2.sns;
	chars_mobs_npcs[index].int=tmpclass2.int;
	chars_mobs_npcs[index].spr=tmpclass2.spr;
	chars_mobs_npcs[index].chr=tmpclass2.chr;
	chars_mobs_npcs[index].luk=tmpclass2.luk;

	--[[if person == "mob" then
		chars_mobs_npcs[index].rng=math.ceil(tmpclass2.spd/10)*tmpclass2.mvcoff+5;
		chars_mobs_npcs[index].sense=10+math.ceil(tmpclass2.sns/5);
	elseif person == "npc" then
		chars_mobs_npcs[index].rng=math.ceil(tmpclass2.spd/10)*tmpclass2.mvcoff+5;
		chars_mobs_npcs[index].sense=10+math.ceil(tmpclass2.sns/5);
	elseif person == "char" then]]
		chars_mobs_npcs[index].rng = 5+math.ceil((chars_mobs_npcs[index].spd+chars_mobs_npcs[index].dex)/10);
		chars_mobs_npcs[index].sense =10+math.ceil(chars_mobs_npcs[index].sns/5);
		chars_mobs_npcs[index].satiation = chars_mobs_npcs[index].enu*10;
	--end;

	chars_mobs_npcs[index].sp_stat = chars_mobs_npcs[index].int;

	chars_mobs_npcs[index].view=i;
	chars_mobs_npcs[index].ac=tmpclass2.ac;
	chars_mobs_npcs[index].dt=tmpclass2.dt;
	chars_mobs_npcs[index].dr=tmpclass2.dr;
	chars_mobs_npcs[index].block=tmpclass2.block;
	chars_mobs_npcs[index].parry = 0;

	chars_mobs_npcs[index].melee_stats = {rh={atkm=0,amel=0,bmel=0,cmel=0},lh={atkm=0,amel=0,bmel=0,cmel=0},rh1={atkm=0,amel=0,bmel=0,cmel=0},lh1={atkm=0,amel=0,bmel=0,cmel=0},rh2={atkm=0,amel=0,bmel=0,cmel=0},lh2={atkm=0,amel=0,bmel=0,cmel=0}};
	chars_mobs_npcs[index].arms_health = {rh=1,lh=1,rh1=1,lh1=1,rh2=1,lh2=1};
	chars_mobs_npcs[index].arms = tmpclass2.arms;
	
	for i=1, #chars_mobs_npcs[index].arms do
		local hand = chars_mobs_npcs[index]["arms"][i];
		chars_mobs_npcs[index]["melee_stats"][hand].atkm=0;
		chars_mobs_npcs[index]["melee_stats"][hand].amel=0;
		chars_mobs_npcs[index]["melee_stats"][hand].bmel=0;
		chars_mobs_npcs[index]["melee_stats"][hand].cmel=0;
	end;
	chars_mobs_npcs[index].atkr=0;
	chars_mobs_npcs[index].arng=0;
	chars_mobs_npcs[index].brng=0;
	chars_mobs_npcs[index].crng=0;

	chars_mobs_npcs[index].aggro=0;
	chars_mobs_npcs[index].aggressor = 0;

	chars_mobs_npcs[index].mgt_buff_power = 0;
	chars_mobs_npcs[index].enu_buff_power = 0;
	chars_mobs_npcs[index].dex_buff_power = 0;
	chars_mobs_npcs[index].spd_buff_power = 0;
	chars_mobs_npcs[index].acu_buff_power = 0;
	chars_mobs_npcs[index].sns_buff_power = 0;
	chars_mobs_npcs[index].int_buff_power = 0;
	chars_mobs_npcs[index].spr_buff_power = 0;
	chars_mobs_npcs[index].chr_buff_power = 0;
	chars_mobs_npcs[index].luk_buff_power = 0;
	chars_mobs_npcs[index].ac_buff_power = 0;

	chars_mobs_npcs[index].mgt_debuff_power = 0;
	chars_mobs_npcs[index].enu_debuff_power = 0;
	chars_mobs_npcs[index].dex_debuff_power = 0;
	chars_mobs_npcs[index].spd_debuff_power = 0;
	chars_mobs_npcs[index].acu_debuff_power = 0;
	chars_mobs_npcs[index].sns_debuff_power = 0;
	chars_mobs_npcs[index].int_debuff_power = 0;
	chars_mobs_npcs[index].spr_debuff_power = 0;
	chars_mobs_npcs[index].chr_debuff_power = 0;
	chars_mobs_npcs[index].luk_debuff_power = 0;
	chars_mobs_npcs[index].ac_debuff_power = 0;

	chars_mobs_npcs[index].recmel=tmpclass2.recmel;
	chars_mobs_npcs[index].recrng=tmpclass2.recrng;
	chars_mobs_npcs[index].recmag=tmpclass2.recmag;

	chars_mobs_npcs[index].battleai=tmpclass2.battleai;
	chars_mobs_npcs[index].freeze = 0;
	chars_mobs_npcs[index].stone = 0;
	chars_mobs_npcs[index].paralyze = 0;
	chars_mobs_npcs[index].stun = 0;
	chars_mobs_npcs[index].sleep = 0;
	chars_mobs_npcs[index].immobilize = 0;
	chars_mobs_npcs[index].drunk = 0;
	chars_mobs_npcs[index].insane = 0;
	chars_mobs_npcs[index].charm = 0;
	chars_mobs_npcs[index].berserk = 0;
	chars_mobs_npcs[index].enslave = 0;
	chars_mobs_npcs[index].fear = 0;
	chars_mobs_npcs[index].panic = 0;
	chars_mobs_npcs[index].silence = 0;
	chars_mobs_npcs[index].madness = 0;
	chars_mobs_npcs[index].filth_power = 0;
	chars_mobs_npcs[index].filth_dur = 0;
	chars_mobs_npcs[index].darkgasp = 0;
	chars_mobs_npcs[index].feeblemind = 0;
	chars_mobs_npcs[index].despondency_power = 0;
	chars_mobs_npcs[index].despondency_dur = 0;
	chars_mobs_npcs[index].misfortune_power = 0;
	chars_mobs_npcs[index].misfortune_dur = 0;
	chars_mobs_npcs[index].blind_power = 0;
	chars_mobs_npcs[index].blind_dur = 0;
	chars_mobs_npcs[index].dark_gasp = 0;
	chars_mobs_npcs[index].deadlyswarm = 0;
	chars_mobs_npcs[index].darkcontamination = 0;
	chars_mobs_npcs[index].fingerofdeath = 0;
	chars_mobs_npcs[index].curse = 0;
	chars_mobs_npcs[index].basiliskbreath = 0;
	chars_mobs_npcs[index].flame_power = 0;
	chars_mobs_npcs[index].flame_dur = 0;
	chars_mobs_npcs[index].firebelt_power = 0;
	chars_mobs_npcs[index].firebelt_dur = 0;
	chars_mobs_npcs[index].fireprint_power = 0;
	chars_mobs_npcs[index].fireprint_dur = 0;
	chars_mobs_npcs[index].poison_power = 0;
	chars_mobs_npcs[index].poison_dur = 0;
	chars_mobs_npcs[index].poison_status = 0;
	chars_mobs_npcs[index].cold_power = 0;
	chars_mobs_npcs[index].cold_dur = 0;
	chars_mobs_npcs[index].acid_power = 0;
	chars_mobs_npcs[index].acid_dur = 0;
	chars_mobs_npcs[index].bleeding = 0;
	chars_mobs_npcs[index].pneumothorax = 0;
	chars_mobs_npcs[index].disease = 0;
	chars_mobs_npcs[index].slow_power = 0;
	chars_mobs_npcs[index].slow_dur = 0;
	chars_mobs_npcs[index].weakness_power = 0;
	chars_mobs_npcs[index].weakness_dur = 0;

	chars_mobs_npcs[index].protfromfire_power = 0;
	chars_mobs_npcs[index].protfromfire_dur = 0;
	chars_mobs_npcs[index].protfromcold_power = 0;
	chars_mobs_npcs[index].protfromcold_dur = 0;
	chars_mobs_npcs[index].protfromstatic_power = 0;
	chars_mobs_npcs[index].protfromstatic_dur = 0;
	chars_mobs_npcs[index].protfromacid_power = 0;
	chars_mobs_npcs[index].protfromacid_dur = 0;
	chars_mobs_npcs[index].protofspirit_power = 0;
	chars_mobs_npcs[index].protofspirit_dur = 0;
	chars_mobs_npcs[index].protfrompoison_power = 0;
	chars_mobs_npcs[index].protfrompoison_dur = 0;
	chars_mobs_npcs[index].protfromdisease_power = 0;
	chars_mobs_npcs[index].protfromdisease_dur = 0;
	chars_mobs_npcs[index].protofmind_power = 0;
	chars_mobs_npcs[index].protofmind_dur = 0;
	chars_mobs_npcs[index].protofmind_dur = 0;
	chars_mobs_npcs[index].protection_dur = 0;
	chars_mobs_npcs[index].protection_power = 0;
	chars_mobs_npcs[index].guardian = 0;
	chars_mobs_npcs[index].shield = 0;
	chars_mobs_npcs[index].stoneskin_power = 0;
	chars_mobs_npcs[index].stoneskin_dur = 0;
	chars_mobs_npcs[index].ironshirt_power = 0;
	chars_mobs_npcs[index].ironshirt_dur = 0;
	chars_mobs_npcs[index].hammerhands_power = 0;
	chars_mobs_npcs[index].hammerhands_dur = 0;
	chars_mobs_npcs[index].shieldfromfire_power = 0;
	chars_mobs_npcs[index].shieldfromfire_dur = 0;
	chars_mobs_npcs[index].shieldfromcold_power = 0;
	chars_mobs_npcs[index].shieldfromcold_dur = 0;
	chars_mobs_npcs[index].shieldfromstatic_power = 0;
	chars_mobs_npcs[index].shieldfromstatic_dur = 0;
	chars_mobs_npcs[index].shieldfromacid_power = 0;
	chars_mobs_npcs[index].shieldfromacid_dur = 0;
	chars_mobs_npcs[index].bless_dur = 0;
	chars_mobs_npcs[index].bless_power = 0;
	chars_mobs_npcs[index].fate = 0;
	chars_mobs_npcs[index].fateself = 0;
	chars_mobs_npcs[index].heroism_power = 0;
	chars_mobs_npcs[index].heroism_dur = 0;
	chars_mobs_npcs[index].prayer = 0
	chars_mobs_npcs[index].rage = 0;
	chars_mobs_npcs[index].thirstofblood = 0;
	chars_mobs_npcs[index].regen_power = 0;
	chars_mobs_npcs[index].regen_dur = 0;
	chars_mobs_npcs[index].healaura_power = 0;
	chars_mobs_npcs[index].healaura_dur = 0;
	chars_mobs_npcs[index].haste = 0;
	chars_mobs_npcs[index].mobility_dur = 0;
	chars_mobs_npcs[index].mobility_power = 0;
	chars_mobs_npcs[index].torchlight = 0;
	chars_mobs_npcs[index].executor_dur = 0;
	chars_mobs_npcs[index].executor_power = 0;
	chars_mobs_npcs[index].hourofpower_dur = 0;
	chars_mobs_npcs[index].hourofpower_power = 0;
	chars_mobs_npcs[index].shieldoflight = 0;
	chars_mobs_npcs[index].wingsoflight= 0;
	chars_mobs_npcs[index].myrth_power = 0;
	chars_mobs_npcs[index].myrth_dur = 0;
	chars_mobs_npcs[index].invisibility = 0;
	chars_mobs_npcs[index].painreflection = 0;
	chars_mobs_npcs[index].waterwalking = 0;
	chars_mobs_npcs[index].levitation = 0;
	chars_mobs_npcs[index].holyblood_power = 0;
	chars_mobs_npcs[index].holyblood_dur = 0;
	chars_mobs_npcs[index].might_power = 0;
	chars_mobs_npcs[index].might_dur = 0;
	chars_mobs_npcs[index].dash_power = 0;
	chars_mobs_npcs[index].dash_dur = 0;
	chars_mobs_npcs[index].precision_power = 0;
	chars_mobs_npcs[index].precision_dur = 0;
	chars_mobs_npcs[index].concentration_power = 0;
	chars_mobs_npcs[index].concentration_dur = 0;
	chars_mobs_npcs[index].glamour_power = 0;
	chars_mobs_npcs[index].glamour_dur = 0;
	chars_mobs_npcs[index].luckyday_power = 0;
	chars_mobs_npcs[index].luckyday_dur = 0;
	chars_mobs_npcs[index].preservation = 0;
	chars_mobs_npcs[index].dayofgods_power = 0;
	chars_mobs_npcs[index].dayofgods_dur = 0;
	chars_mobs_npcs[index].farsight_power = 0;
	chars_mobs_npcs[index].farsight_dur = 0;

	chars_mobs_npcs[index].num_unarmed=tmpclass2.num_unarmed;
	chars_mobs_npcs[index].lvl_unarmed=tmpclass2.lvl_unarmed;
	chars_mobs_npcs[index].num_sword=tmpclass2.num_sword;
	chars_mobs_npcs[index].lvl_sword=tmpclass2.lvl_sword;
	chars_mobs_npcs[index].num_axe=tmpclass2.num_axe;
	chars_mobs_npcs[index].lvl_axe=tmpclass2.lvl_axe;
	chars_mobs_npcs[index].num_crushing=tmpclass2.num_crushing;
	chars_mobs_npcs[index].lvl_crushing=tmpclass2.lvl_crushing;
	chars_mobs_npcs[index].num_flagpole=tmpclass2.num_flagpole;
	chars_mobs_npcs[index].lvl_flagpole=tmpclass2.lvl_flagpole;
	chars_mobs_npcs[index].num_dagger=tmpclass2.num_dagger;
	chars_mobs_npcs[index].lvl_dagger=tmpclass2.lvl_dagger;
	chars_mobs_npcs[index].num_staff=tmpclass2.num_staff;
	chars_mobs_npcs[index].lvl_staff=tmpclass2.lvl_staff;
	chars_mobs_npcs[index].num_bow=tmpclass2.num_bow;
	chars_mobs_npcs[index].lvl_bow=tmpclass2.lvl_bow;
	chars_mobs_npcs[index].num_crossbow=tmpclass2.num_crossbow;
	chars_mobs_npcs[index].lvl_crossbow=tmpclass2.lvl_crossbow;
	chars_mobs_npcs[index].num_throwing=tmpclass2.num_throwing;
	chars_mobs_npcs[index].lvl_throwing=tmpclass2.lvl_throwing;
	chars_mobs_npcs[index].num_firearms=tmpclass2.num_firearms;
	chars_mobs_npcs[index].lvl_firearms=tmpclass2.lvl_firearms;

	chars_mobs_npcs[index].num_dodging=tmpclass2.dodging_sword;
	chars_mobs_npcs[index].lvl_dodging=tmpclass2.dodging_sword;
	chars_mobs_npcs[index].num_shield=tmpclass2.num_shield;
	chars_mobs_npcs[index].lvl_shield=tmpclass2.lvl_shield;
	chars_mobs_npcs[index].num_leather=tmpclass2.num_leather;
	chars_mobs_npcs[index].lvl_leather=tmpclass2.lvl_leather;
	chars_mobs_npcs[index].num_chainmail=tmpclass2.num_chainmail;
	chars_mobs_npcs[index].lvl_chainmail=tmpclass2.lvl_chainmail;
	chars_mobs_npcs[index].num_plate=tmpclass2.num_plate;
	chars_mobs_npcs[index].lvl_plate=tmpclass2.lvl_plate;

	chars_mobs_npcs[index].num_fire=tmpclass2.num_fire;
	chars_mobs_npcs[index].lvl_fire=tmpclass2.lvl_fire;
	chars_mobs_npcs[index].num_water=tmpclass2.num_water;
	chars_mobs_npcs[index].lvl_water=tmpclass2.lvl_water;
	chars_mobs_npcs[index].num_air=tmpclass2.num_air;
	chars_mobs_npcs[index].lvl_air=tmpclass2.lvl_air;
	chars_mobs_npcs[index].num_earth=tmpclass2.num_earth;
	chars_mobs_npcs[index].lvl_earth=tmpclass2.lvl_earth;
	chars_mobs_npcs[index].num_body=tmpclass2.num_body;
	chars_mobs_npcs[index].lvl_body=tmpclass2.lvl_body;
	chars_mobs_npcs[index].num_mind=tmpclass2.num_mind;
	chars_mobs_npcs[index].lvl_mind=tmpclass2.lvl_mind;
	chars_mobs_npcs[index].num_spirit=tmpclass2.num_spirit;
	chars_mobs_npcs[index].lvl_spirit=tmpclass2.lvl_spirit;
	chars_mobs_npcs[index].num_light=tmpclass2.num_light;
	chars_mobs_npcs[index].lvl_light=tmpclass2.lvl_light;
	chars_mobs_npcs[index].num_darkness=tmpclass2.num_darkness;
	chars_mobs_npcs[index].lvl_darkness=tmpclass2.lvl_darkness;

	chars_mobs_npcs[index].num_alchemy=tmpclass2.num_alchemy;
	chars_mobs_npcs[index].lvl_alchemy=tmpclass2.lvl_alchemy;
	chars_mobs_npcs[index].num_repair=tmpclass2.num_repair;
	chars_mobs_npcs[index].lvl_repair=tmpclass2.lvl_repair;
	chars_mobs_npcs[index].num_bodybuilding=tmpclass2.num_bodybuilding;
	chars_mobs_npcs[index].lvl_bodybuilding=tmpclass2.lvl_bodybuilding;
	chars_mobs_npcs[index].num_armmastery=tmpclass2.num_armmastery;
	chars_mobs_npcs[index].lvl_armmastery=tmpclass2.lvl_armmastery;
	chars_mobs_npcs[index].num_meditation=tmpclass2.num_meditation;
	chars_mobs_npcs[index].lvl_meditation=tmpclass2.lvl_meditation;
	chars_mobs_npcs[index].num_mysticism=tmpclass2.num_spirit;
	chars_mobs_npcs[index].lvl_mysticism=tmpclass2.lvl_mysticism;
	chars_mobs_npcs[index].num_trading=tmpclass2.num_trading;
	chars_mobs_npcs[index].lvl_trading=tmpclass2.lvl_trading;
	chars_mobs_npcs[index].num_diplomacy=tmpclass2.num_diplomacy;
	chars_mobs_npcs[index].lvl_diplomacy=tmpclass2.lvl_diplomacy;
	chars_mobs_npcs[index].num_stealth=tmpclass2.num_stealth;
	chars_mobs_npcs[index].lvl_stealth=tmpclass2.lvl_stealth;
	chars_mobs_npcs[index].num_dodging=tmpclass2.num_dodging;
	chars_mobs_npcs[index].lvl_dodging=tmpclass2.lvl_dodging;
	chars_mobs_npcs[index].num_picklocking=tmpclass2.num_picklocking;
	chars_mobs_npcs[index].lvl_picklocking=tmpclass2.lvl_picklocking;
	chars_mobs_npcs[index].num_traps=tmpclass2.num_traps;
	chars_mobs_npcs[index].lvl_traps=tmpclass2.lvl_traps;
	chars_mobs_npcs[index].num_spothidden=tmpclass2.num_spothidden;
	chars_mobs_npcs[index].lvl_spothidden=tmpclass2.lvl_spothidden;
	chars_mobs_npcs[index].num_monsterid=tmpclass2.num_monsterid;
	chars_mobs_npcs[index].lvl_monsterid=tmpclass2.lvl_monsterid;
	chars_mobs_npcs[index].num_stuffid=tmpclass2.num_stuffid;
	chars_mobs_npcs[index].lvl_stuffid=tmpclass2.lvl_stuffid;
	chars_mobs_npcs[index].num_thievery=tmpclass2.num_thievery;
	chars_mobs_npcs[index].lvl_thievery=tmpclass2.lvl_thievery;
	chars_mobs_npcs[index].num_leadership= tmpclass2.num_leadership
	chars_mobs_npcs[index].lvl_leadership= tmpclass2.lvl_leadership
	chars_mobs_npcs[index].num_regeneration= tmpclass2.num_regeneration
	chars_mobs_npcs[index].lvl_regeneration= tmpclass2.lvl_regeneraton

	chars_mobs_npcs[index].rezfire=tmpclass2.rezfire;
	chars_mobs_npcs[index].rezcold=tmpclass2.rezcold;
	chars_mobs_npcs[index].rezstatic=tmpclass2.rezstatic;
	chars_mobs_npcs[index].rezpoison=tmpclass2.rezpoison;
	chars_mobs_npcs[index].rezacid=tmpclass2.rezacid;
	chars_mobs_npcs[index].rezdisease=tmpclass2.rezdisease;
	chars_mobs_npcs[index].rezmind=tmpclass2.rezmind;
	chars_mobs_npcs[index].rezspirit=tmpclass2.rezspirit;
	chars_mobs_npcs[index].rezlight=tmpclass2.rezlight;
	chars_mobs_npcs[index].rezdarkness=tmpclass2.rezdarkness;
	chars_mobs_npcs[index].rezzero=0; -- hack for non elemental damage
	
	local bodybuilding_bonus = chars_mobs_npcs[index].num_bodybuilding*chars_mobs_npcs[index].lvl_bodybuilding;
	local mysticism_bonus = chars_mobs_npcs[index].num_mysticism*chars_mobs_npcs[index].lvl_mysticism;
	chars_mobs_npcs[index].hp_max = chars_mobs_npcs[index].hp_base + chars_mobs_npcs[index].hp_coff * chars_mobs_npcs[index].enu + bodybuilding_bonus;
	chars_mobs_npcs[index].sp_max = chars_mobs_npcs[index].sp_base + chars_mobs_npcs[index].sp_coff * chars_mobs_npcs[index].sp_stat + mysticism_bonus;
	chars_mobs_npcs[index].st_max = 200 + chars_mobs_npcs[index].st_base + chars_mobs_npcs[index].st_coff * chars_mobs_npcs[index].enu + bodybuilding_bonus;

	chars_mobs_npcs[index].hp = chars_mobs_npcs[index].hp_max;
	chars_mobs_npcs[index].sp = chars_mobs_npcs[index].sp_max;
	chars_mobs_npcs[index].st = chars_mobs_npcs[index].st_max;
	chars_mobs_npcs[index].rt = 200;

	if tmpclass2.sp_limit then
		chars_mobs_npcs[index].sp_limit = tmpclass2.sp_limit;
	end;

	chars_mobs_npcs[index].hp_regeneration = tmpclass2.hp_regeneration;
	chars_mobs_npcs[index].sp_regeneration = tmpclass2.sp_regeneration;
	chars_mobs_npcs[index].st_regeneration = tmpclass2.st_regeneration;
	chars_mobs_npcs[index].moral = 0;
	chars_mobs_npcs[index].base_moral = tmpclass2.moral;

	chars_mobs_npcs[index].revenge_type = tmpclass2.revenge_type;
	chars_mobs_npcs[index].revenge_power = tmpclass2.revenge_power;

	if person ~= "char" then
		if tmpclass2.loot_gold_max > 0 then
			chars_mobs_npcs[index].gold = math.random(tmpclass2.loot_gold_min,tmpclass2.loot_gold_max);
		else
			chars_mobs_npcs[index].gold = 0;
		end;
		local packofgold = 0
		if chars_mobs_npcs[index].gold > 0 and chars_mobs_npcs[index].gold <= 10 then
			packofgold = 379;
		elseif chars_mobs_npcs[index].gold > 10 and chars_mobs_npcs[index].gold <= 100 then
			packofgold = 380;
		elseif chars_mobs_npcs[index].gold > 100 and chars_mobs_npcs[index].gold <= 1000 then
			packofgold = 381;
		elseif chars_mobs_npcs[index].gold > 1000 then
			packofgold = 382;
		end;
		if packofgold > 0 then
			table.insert(chars_mobs_npcs[index].inventory_list,{ttxid=packofgold,q= chars_mobs_npcs[index].gold,w=0,e=0,r = 1,h=0});
		end;
	end;
end; 
