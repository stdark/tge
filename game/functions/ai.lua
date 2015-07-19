ai = {}

function ai.behavior()
	utils.printDebug("ai_called");
	mob_can_move = 0;
	game_status="ai";
	tmp_current_mob = current_mob;
	--BUILDING	
	if chars_mobs_npcs[current_mob].ai == "building" then
		damage.RTminus(current_mob,200,false);
		game_status = "restoring";
		return;
	end;
	--/BUILDING
	if chars_mobs_npcs[current_mob].ai ~= chars_mobs_npcs[current_mob].defaultai and chars_mobs_npcs[current_mob].fear == 0 and chars_mobs_npcs[current_mob].charm == 0 and chars_mobs_npcs[current_mob].berserk == 0 then
		print("current_mob",current_mob);
		chars_mobs_npcs[current_mob].ai = chars_mobs_npcs[current_mob].defaultai;
	end;
	mob_range = chars_mobs_npcs[current_mob].rng-walked_before; --count walked before!
	path_can_be_found = 0;
	local tmpclass = nil;
	local tmpclass2 = nil;
	local agro_array = ai.agro_array_full ();
	if person == "mob" then
		tmpclass="mobs_stats." .. chars_mobs_npcs[i].class;
		tmpclass2=loadstring("return " .. tmpclass)();
		chars_mobs_npcs[i].face = tmpclass2.face;	
	elseif person == "npc" then
		tmpclass="mobs_stats." .. chars_mobs_npcs[i].class;
		tmpclass2=loadstring("return " .. tmpclass)();
	elseif person == "char" then
		tmpclass2 = chars_stats[i];
	end;
	
	if chars_mobs_npcs[current_mob].ai ~= "berserk" and chars_mobs_npcs[current_mob].ai ~= "away" and chars_mobs_npcs[current_mob].control == "ai" and helpers.aliveNature(current_mob) 
	and chars_mobs_npcs[current_mob].hp + math.ceil(chars_mobs_npcs[current_mob].moral/5) < math.ceil(chars_mobs_npcs[current_mob].hp_max*0.2) and chars_mobs_npcs[current_mob].hp > chars_mobs_npcs[current_mob].hp_max*0.1 then
		chars_mobs_npcs[current_mob].ai	= "away";
		helpers.addToActionLog( helpers.mobName(current_mob) .. " " .. lognames.actions.runaway);
	end;
	helpers.clearAiArrays();
	trace.first_watch (current_mob);
--VOID	
	if chars_mobs_npcs[current_mob].ai == "agr" and chars_mobs_npcs[current_mob].battleai == "battlemage" and vlandscape_id[chars_mobs_npcs[current_mob].y][chars_mobs_npcs[current_mob].x] > 0 then
		chars_mobs_npcs[current_mob].ai = "away"; --FIXME bad zone away
		chars_mobs_npcs[current_mob].battleai = "melee";
	end;
	
--CALLED	
	if chars_mobs_npcs[current_mob].ai == "called" then
		if ai.mobWatchesTheMob (current_mob,true) then
			chars_mobs_npcs[current_mob].ai = chars_mobs_npcs[current_mob].dangerai;
		else
			mob_is_going_to_hit = 0;
			local roll_point = 1;
			local point_to_go_x = chars_mobs_npcs[current_mob]["call"].x;
			local point_to_go_y = chars_mobs_npcs[current_mob]["call"].y;
			local free_hexes = helpers.findFreeHexes (current_mob);
			local rollmd = math.random(1,2);
			if rollmd == 1 then
				modepf = 1;
			else
				modepf = -1;
			end;
			if #free_hexes > 0 then
				local distance = math.ceil(math.sqrt((free_hexes[1].x - point_to_go_x)^2 + (free_hexes[1].y - point_to_go_y)^2));
				local newdistance = 0;
				for j=1,#free_hexes do
					newdistance =  math.ceil(math.sqrt((free_hexes[j].x - point_to_go_x)^2 + (free_hexes[j].y - point_to_go_y)^2));
					if newdistance < distance then
						distance = newdistance;
						roll_point = j;
					end;
				end;		
				ai_world_x = free_hexes[roll_point].x;
				ai_world_y = free_hexes[roll_point].y;
				--ai_world_x = point_to_go_x;
				--ai_world_y = point_to_go_y;
				mob_can_move = 1;
				path_finding (0,0);
				helpers.addToActionLog( helpers.mobName(current_mob) .. " " .. lognames.actions.movingtocall);
			elseif #free_hexes == 0 then
				chars_mobs_npcs[current_mob].ai = "stay";
				helpers.addToActionLog( helpers.mobName(current_mob) .. " " .. lognames.actions.stoped[chars_mobs_npcs[current_mob].gender]);
			end;		
		end;
	end;
--CRUISER
	if chars_mobs_npcs[current_mob].ai == "cruiser" then
		if ai.mobWatchesTheMob (current_mob,true) then
			chars_mobs_npcs[current_mob].ai = chars_mobs_npcs[current_mob].dangerai;
		else
			mob_is_going_to_hit = 0;
			local roll_point = 1;
			local point_to_go_x = chars_mobs_npcs[current_mob].waypoint[chars_mobs_npcs[current_mob].nextpoint][1]; --nil
			local point_to_go_y = chars_mobs_npcs[current_mob].waypoint[chars_mobs_npcs[current_mob].nextpoint][2];
			local free_hexes = helpers.findFreeHexes (current_mob);
			local rollmd = math.random(1,2);
			if rollmd == 1 then
				modepf = 1;
			else
				modepf = -1;
			end;
			if #free_hexes > 0 then
				local distance = math.ceil(math.sqrt((free_hexes[1].x - point_to_go_x)^2 + (free_hexes[1].y - point_to_go_y)^2));
				local newdistance = 0;
				for j=1,#free_hexes do
					newdistance =  math.ceil(math.sqrt((free_hexes[j].x - point_to_go_x)^2 + (free_hexes[j].y - point_to_go_y)^2));
					if newdistance < distance then
						distance = newdistance;
						roll_point = j;
					end;
				end;		
				ai_world_x = free_hexes[roll_point].x;
				ai_world_y = free_hexes[roll_point].y;
				mob_can_move = 1;
				path_finding (0,0);
				helpers.addToActionLog( helpers.mobName(current_mob) .. " " .. lognames.actions.atwaypoint);
				chars_mobs_npcs[current_mob].nextpoint = chars_mobs_npcs[current_mob].nextpoint + 1;
				if chars_mobs_npcs[current_mob].nextpoint > #chars_mobs_npcs[current_mob].waypoint then
					chars_mobs_npcs[current_mob].nextpoint = 1;
				end;
			elseif #free_hexes == 0 then
				chars_mobs_npcs[current_mob].ai = "stay";
				helpers.addToActionLog( helpers.mobName(current_mob) .. " " .. lognames.actions.stoped[chars_mobs_npcs[current_mob].gender]);
			end;		
		end;	
	end;
--AGR Shooter
	if chars_mobs_npcs[current_mob].ai == "agr" and chars_mobs_npcs[current_mob].battleai == "shooter" then
		if chars_mobs_npcs[current_mob]["equipment"].ammo and chars_mobs_npcs[current_mob].inventory_list[chars_mobs_npcs[current_mob]["equipment"].ammo].q > 0 and chars_mobs_npcs[current_mob].darkgasp == 0 then
			local rings = boomareas.ringArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
			for j=1,#chars_mobs_npcs do
				for h=1,3 do
					for i=1,6 do
						if not ai.friendOrFoe (current_mob,j)
						and chars_mobs_npcs[j].x == rings[h][i].x
						and chars_mobs_npcs[j].y == rings[h][i].y
						and chars_mobs_npcs[j].status == 1
						and chars_mobs_npcs[j].invisibility == 0
						and darkness[chars_mobs_npcs[current_mob].party][chars_mobs_npcs[j].y][chars_mobs_npcs[j].x] == 0 then
							chars_mobs_npcs[current_mob].ai = "away";
						end;
					end;
				end;
				trace.trace_hexes (current_mob,j,trace.sightArray (current_mob),true);
				if not ai.friendOrFoe (current_mob,j)
				and math.abs(chars_mobs_npcs[j].x - chars_mobs_npcs[current_mob].x) <= #shot_line
				and math.abs(chars_mobs_npcs[j].y - chars_mobs_npcs[current_mob].y) <= #shot_line
				and  #shot_line > 0
				and shot_line[#shot_line][1] == chars_mobs_npcs[j].x
				and shot_line[#shot_line][2] == chars_mobs_npcs[j].y 
				and chars_mobs_npcs[j].status == 1
				and chars_mobs_npcs[j].invisibility == 0
				and darkness[chars_mobs_npcs[current_mob].party][chars_mobs_npcs[j].x][chars_mobs_npcs[j].y] == 0 
				and chars_mobs_npcs[j].invisibility == 0 and chars_mobs_npcs[j].stealth == 0
				then
					table.insert(mob_detects_enemies, j)
				end;	
			end;
			if #mob_detects_enemies > 0 and chars_mobs_npcs[current_mob].battleai == "shooter" and chars_mobs_npcs[current_mob].ai == "agr" then
				for e=1,#mob_detects_enemies do --for aggro
					local tmpfrac = chars_mobs_npcs[mob_detects_enemies[e]].fraction;
					local tmpfrac2 = chars_mobs_npcs[current_mob].fraction;
					local fraccond = loadstring("return " .. "fractions." .. tmpfrac2 .. "." .. tmpfrac)();
					local aggro_factor = 0;
					local range_factor=math.ceil(20-math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[mob_detects_enemies[e]].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[mob_detects_enemies[e]].y)^2));
					aggro_factor = math.ceil(-1*fraccond/10) + range_factor;
					if chars_mobs_npcs[current_mob].aggressor == mob_detects_enemies[e] then
						aggro_factor = aggro_factor + chars_mobs_npcs[mob_detects_enemies[e]].aggro;
					end;
					table.insert(mob_detects_aggro,mob_detects_enemies[e]);
					local startcounter=#mob_detects_aggro+1;
					for f=startcounter,aggro_factor do
						table.insert(mob_detects_aggro,mob_detects_enemies[e]);
					end;
				end;
				local target_preroll = math.random(1,#mob_detects_aggro);
				local target_roll = mob_detects_aggro[target_preroll];
				previctim = chars_mobs_npcs[target_roll].id;
				--previctim = target_roll;
				ai_world_x = chars_mobs_npcs[target_roll].x;
				ai_world_y = chars_mobs_npcs[target_roll].y;
				mob_under_cursor= chars_mobs_npcs[target_roll].id;
				atk_direction = helpers.attackDirection (current_mob,previctim);
				--chars_mobs_npcs[current_mob].rot = atk_direction;
				boomx = chars_mobs_npcs[previctim].x;
				boomy = chars_mobs_npcs[previctim].y;
				missle_drive = "muscles";
				missle_type = "bolt";
				game_status = "shot";
				trace.trace_hexes (current_mob,previctim,trace.sightArray (current_mob),true);
				--if #shot_line > 0 then --dirty fix
				point_to_go_x = chars_mobs_npcs[previctim].x;
				point_to_go_y = chars_mobs_npcs[previctim].y;
				helpers.turnMob (current_mob);
					--chars_mobs_npcs[current_mob].rot =  helpers.antiDirection(atk_direction);
				damage.shoot ();
				return;
				--else
					--game_status = "restoring";
				--end;
				
			elseif chars_mobs_npcs[current_mob].ai == "agr" then
				change_position = true;
				--chars_mobs_npcs[current_mob].ai = "random";
				chars_mobs_npcs[current_mob].ai = "toenemy";
				--chars_mobs_npcs[current_mob].rt = chars_mobs_npcs[current_mob].rt - 200;
				--game_status = "restoring";
			end;
		else
			chars_mobs_npcs[current_mob].battleai = "melee";
		end;
	end;
--AGR battle mage
	if chars_mobs_npcs[current_mob].ai == "agr" and chars_mobs_npcs[current_mob].battleai == "battlemage" then
		local rings = boomareas.ringArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
		for j=1,#chars_mobs_npcs do
			for h=1,3 do
				for i=1,6 do
					if not ai.friendOrFoe (current_mob,j)
					and chars_mobs_npcs[j].x == rings[h][i].x
					and chars_mobs_npcs[j].y == rings[h][i].y
					and chars_mobs_npcs[j].status == 1
					and chars_mobs_npcs[j].invisibility == 0
					and darkness[chars_mobs_npcs[current_mob].party][chars_mobs_npcs[j].y][chars_mobs_npcs[j].x] == 0 then
						chars_mobs_npcs[current_mob].ai = "away";
					end;
				end;
			end;
		end;
		if chars_mobs_npcs[current_mob].darkgasp == 0 and chars_mobs_npcs[current_mob].feeblemind == 0 and chars_mobs_npcs[current_mob].sp > chars_mobs_npcs[current_mob].sp_limit then		
			for j=1,#chars_mobs_npcs do
				trace.trace_hexes (current_mob,j,trace.sightArray (current_mob),true);
				if not ai.friendOrFoe (current_mob,j)
				and math.abs(chars_mobs_npcs[j].x - chars_mobs_npcs[current_mob].x) <= #shot_line
				and math.abs(chars_mobs_npcs[j].y - chars_mobs_npcs[current_mob].y) <= #shot_line
				and  #shot_line > 0
				and shot_line[#shot_line][1] == chars_mobs_npcs[j].x
				and shot_line[#shot_line][2] == chars_mobs_npcs[j].y 
				and chars_mobs_npcs[j].status == 1
				and chars_mobs_npcs[j].invisibility == 0
				and darkness[chars_mobs_npcs[current_mob].party][chars_mobs_npcs[j].x][chars_mobs_npcs[j].y] == 0 
				and chars_mobs_npcs[j].invisibility == 0 and chars_mobs_npcs[j].stealth == 0
				then
					table.insert(mob_detects_enemies, j)
				end;	
			end;
			if #mob_detects_enemies > 0 and chars_mobs_npcs[current_mob].battleai == "battlemage" and chars_mobs_npcs[current_mob].ai == "agr" then
				for e=1,#mob_detects_enemies do --for aggro
					local tmpfrac = chars_mobs_npcs[mob_detects_enemies[e]].fraction;
					local tmpfrac2 = chars_mobs_npcs[current_mob].fraction;
					local fraccond = loadstring("return " .. "fractions." .. tmpfrac2 .. "." .. tmpfrac)();
					local aggro_factor = 0;
					local range_factor=math.ceil(20-math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[mob_detects_enemies[e]].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[mob_detects_enemies[e]].y)^2));
					aggro_factor = math.ceil(-1*fraccond/10) + range_factor;
					if chars_mobs_npcs[current_mob].aggressor == mob_detects_enemies[e] then
						aggro_factor = aggro_factor + chars_mobs_npcs[mob_detects_enemies[e]].aggro;
					end;
					table.insert(mob_detects_aggro,mob_detects_enemies[e]);
					local startcounter=#mob_detects_aggro+1;
					for f=startcounter,aggro_factor do
						table.insert(mob_detects_aggro,mob_detects_enemies[e]);
					end;
				end;
				local target_preroll = math.random(1,#mob_detects_aggro);
				local target_roll = mob_detects_aggro[target_preroll];
				previctim = chars_mobs_npcs[target_roll].id;
				ai_world_x = chars_mobs_npcs[target_roll].x;
				ai_world_y = chars_mobs_npcs[target_roll].y;
				mob_under_cursor= chars_mobs_npcs[target_roll].id;
				atk_direction = helpers.attackDirection (current_mob,previctim);
				--chars_mobs_npcs[current_mob].rot = atk_direction;
				boomx = chars_mobs_npcs[previctim].x;
				boomy = chars_mobs_npcs[previctim].y;
				missle_drive = "spellbook";
				--local missle = math.random(1,#chars_mobs_npcs[current_mob].spellnames); --FIXME check mana before, sp_limit is a bad variant
				local available_spells = {};
				for i=1,#chars_mobs_npcs[current_mob].spellnames do
					local spellname = chars_mobs_npcs[current_mob].spellnames[i];
					if chars_mobs_npcs[current_mob].sp >= magic.spell_tips[spellname].mana
					and chars_mobs_npcs[current_mob].rt >= magic.spell_tips[spellname].recovery then
						table.insert(available_spells,spellname);
					end;
				end;
				if #available_spells > 0 then
					missle_type = available_spells[math.random(1,#available_spells)];
					game_status = "shot";
					trace.trace_hexes (current_mob,previctim,trace.sightArray (current_mob),true);
					--if #shot_line > 0 then --dirty fix
					point_to_go_x = chars_mobs_npcs[previctim].x;
					point_to_go_y = chars_mobs_npcs[previctim].y;
					helpers.turnMob (current_mob);
						--chars_mobs_npcs[current_mob].rot =  helpers.antiDirection(atk_direction);
					damage.shoot ();
					return;
				else
					game_status = "melee";
				end;
			elseif chars_mobs_npcs[current_mob].ai == "agr" then
				change_position = true;
				--chars_mobs_npcs[current_mob].ai = "random";
				chars_mobs_npcs[current_mob].ai = "toenemy";
				--chars_mobs_npcs[current_mob].rt = chars_mobs_npcs[current_mob].rt - 200;
				--game_status = "restoring";
			end;
		else
			chars_mobs_npcs[current_mob].battleai = "melee";
		end;
	end;
--AGR healer
	if chars_mobs_npcs[current_mob].ai == "agr" and chars_mobs_npcs[current_mob].battleai == "healer" then
		for j=1,#chars_mobs_npcs do
			local rings = boomareas.ringArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
			for j=1,#chars_mobs_npcs do
				for h=1,3 do
					for i=1,6 do
						if not ai.friendOrFoe (current_mob,j)
						and chars_mobs_npcs[j].x == rings[h][i].x
						and chars_mobs_npcs[j].y == rings[h][i].y
						and chars_mobs_npcs[j].status == 1
						and chars_mobs_npcs[j].invisibility == 0
						and darkness[chars_mobs_npcs[current_mob].party][chars_mobs_npcs[j].y][chars_mobs_npcs[j].x] == 0 then
							chars_mobs_npcs[current_mob].ai = "away";
						end;
					end;
				end;
			end;
		end;
		if chars_mobs_npcs[current_mob].darkgasp == 0 and chars_mobs_npcs[current_mob].feeblemind == 0 and chars_mobs_npcs[current_mob].sp > chars_mobs_npcs[current_mob].sp_limit then
			local array_to_resurrect = {};
			local array_to_heal = {};
			local array_to_regenerate = {};
			local array_to_cure = {};
			local array_to_buff = {};
			boomx = chars_mobs_npcs[previctim].x;
			boomy = chars_mobs_npcs[previctim].y;
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].party == chars_mobs_npcs[current_mob].party and chars_mobs_npcs[j].stone == 0 and chars_mobs_npcs[j].freeze == 0 and chars_mobs_npcs[j].filth == 0 then
					if chars_mobs_npcs[j].status == 1
					and (chars_mobs_npcs[j].hp_max - chars_mobs_npcs[j].hp) >= chars_mobs_npcs[current_mob].lvl_body*chars_mobs_npcs[current_mob].num_body
					and helpers.aliveNature(j)
					and chars_mobs_npcs[current_mob].sp >= magic.spell_tips["heal"].mana
					and chars_mobs_npcs[current_mob].rt >= magic.spell_tips["heal"].recovery
					then
						table.insert(array_to_heal,j);
					end;
					if chars_mobs_npcs[j].status == 1
					and (chars_mobs_npcs[j].hp_max - chars_mobs_npcs[j].hp) >= chars_mobs_npcs[current_mob].lvl_body*chars_mobs_npcs[current_mob].num_body/2
					and (chars_mobs_npcs[j].hp_max - chars_mobs_npcs[j].hp) < chars_mobs_npcs[current_mob].lvl_body*chars_mobs_npcs[current_mob].num_body
					and helpers.aliveNature(j)
					and chars_mobs_npcs[j].regeneration_dur == 0
					and chars_mobs_npcs[current_mob].sp >= magic.spell_tips["regeneration"].mana
					and chars_mobs_npcs[current_mob].rt >= magic.spell_tips["regeneration"].recovery
					then
						table.insert(array_to_regenerate,j);
					end;
					if chars_mobs_npcs[j].status == 0
					and not helpers.cursorAtDeadMob (chars_mobs_npcs[j].x,chars_mobs_npcs[j].y)
					and chars_mobs_npcs[current_mob].sp >= magic.spell_tips["resurrect"].mana
					and chars_mobs_npcs[current_mob].rt >= magic.spell_tips["resurrect"].recovery
					then
						table.insert(array_to_resurrect,j);
					end;
				end;
			end;
			local spell = false;
			previctim = 0;
			local action_done = false;
			if #array_to_heal > 0 and not action_done then
				action_done = true;
				local rnd = array_to_heal[math.random(1,array_to_heal)];
				previctim = rnd;
				missle_drive = "spellbook";
				missle_type = "heal";
				helpers.beforeShoot ();
				game_status="shot";
				damage.shoot();
				return;
			end;
			if #array_to_regenerate > 0 and not action_done then
				action_done = true;
				local rnd = array_to_regenerate[math.random(1,array_to_regenerate)];
				previctim = rnd;
				missle_drive = "spellbook";
				missle_type = "regeneration";
				helpers.beforeShoot ();
				game_status="shot";
				damage.shoot();
				return;
			end;
			if #array_to_resurrect > 0 and not action_done then
				action_done = true;
				local rnd = array_to_resurrection[math.random(1,array_to_resurrection)];
				previctim = rnd;
				missle_drive = "spellbook";
				missle_type = "resurrection";
				helpers.beforeShoot ();
				game_status="shot";
				damage.shoot();
				return;
			end;
			if #array_to_cure > 0 and not action_done then --traumas, poison
				action_done = true;
			end;
			if #array_to_buff > 0 and not action_done then
				action_done = true;
			end;
		end;
	else
		chars_mobs_npcs[current_mob].battleai = "melee";
	end;
--  buffer

	if chars_mobs_npcs[current_mob].ai == "agr" and chars_mobs_npcs[current_mob].battleai == "buffer" then
		for j=1,#chars_mobs_npcs do
			local rings = boomareas.ringArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
			for j=1,#chars_mobs_npcs do
				for h=1,3 do
					for i=1,6 do
						if not ai.friendOrFoe (current_mob,j)
						and chars_mobs_npcs[j].x == rings[h][i].x
						and chars_mobs_npcs[j].y == rings[h][i].y
						and chars_mobs_npcs[j].status == 1
						and chars_mobs_npcs[j].invisibility == 0
						and darkness[chars_mobs_npcs[current_mob].party][chars_mobs_npcs[j].y][chars_mobs_npcs[j].x] == 0 then
							chars_mobs_npcs[current_mob].ai = "away";
						end;
					end;
				end;
			end;
		end;
		if chars_mobs_npcs[current_mob].darkgasp == 0 and chars_mobs_npcs[current_mob].feeblemind == 0 and chars_mobs_npcs[current_mob].sp > chars_mobs_npcs[current_mob].sp_limit then
			local array_to_buff = {};
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].party == chars_mobs_npcs[current_mob].party and chars_mobs_npcs[j].stone == 0 and chars_mobs_npcs[j].freeze == 0 and chars_mobs_npcs[j].filth == 0 then
					if chars_mobs_npcs[j].status == 1 and j ~= current_mob then
						table.insert(array_to_buff,j);
					end;
				end;
			end;
			if #array_to_buff > 1 then
				local previctim = array_to_buff[math.random(1,#array_to_buff)];
				local available_spells = {};
				for i=1,#chars_mobs_npcs[current_mob].spellnames do
					local spellname = chars_mobs_npcs[current_mob].spellnames[i];
					if chars_mobs_npcs[current_mob].sp >= magic.spell_tips[spellname].mana
					and chars_mobs_npcs[current_mob].rt >= magic.spell_tips[spellname].recovery then		
						table.insert(available_spells,spellname);
					end;
				end;
				if #available_spell > 0 then
					missle_type = available_spell[math.random(1,available_spell)];
					chars_mobs_npcs[current_mob].battleai = "melee";
					game_status = "shot";
					trace.trace_hexes (current_mob,previctim,trace.sightArray (current_mob),true);
					point_to_go_x = chars_mobs_npcs[previctim].x;
					point_to_go_y = chars_mobs_npcs[previctim].y;
					helpers.turnMob (current_mob);
					damage.shoot ();
					return;
					else
						game_status = "melee";
					end;
			elseif chars_mobs_npcs[current_mob].ai == "agr" then
				change_position = true;
				chars_mobs_npcs[current_mob].ai = "toenemy";
			end;
		end;
	end;
--	debuffer (like battle mage but conditions checks before)
--	controller (like battle mage but conditions checks before)
--AGR melee	
	if (chars_mobs_npcs[current_mob].ai == "agr" or chars_mobs_npcs[current_mob].ai == "berserk") and chars_mobs_npcs[current_mob].battleai == "melee" then
		for l=1, #chars_mobs_npcs do		
			local rings = boomareas.ringArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
			for i=1,6 do
				if not ai.friendOrFoe (current_mob,l)
				and chars_mobs_npcs[l].x == rings[1][i].x
				and chars_mobs_npcs[l].y == rings[1][i].y
				and chars_mobs_npcs[l].status == 1
				and darkness[chars_mobs_npcs[current_mob].party][chars_mobs_npcs[l].x][chars_mobs_npcs[l].y] == 0
				and chars_mobs_npcs[l].invisibility == 0 and chars_mobs_npcs[l].stealth == 0
				then
					table.insert(mob_detects_enemies, l)
				end;
			end;
		end;
		if #mob_detects_enemies == 0 and chars_mobs_npcs[current_mob].immobilize == 0 then
			for l=1, #chars_mobs_npcs do
				if darkness[chars_mobs_npcs[current_mob].party][chars_mobs_npcs[l].x][chars_mobs_npcs[l].y] == 0 and not ai.friendOrFoe (current_mob,l)
				and l ~= current_mob
				and chars_mobs_npcs[l].status == 1
				and math.ceil(math.sqrt((chars_mobs_npcs[l].x-chars_mobs_npcs[current_mob].x)^2+(chars_mobs_npcs[l].y-chars_mobs_npcs[current_mob].y)^2)) <= mob_range
				and chars_mobs_npcs[l].invisibility == 0 and chars_mobs_npcs[l].stealth == 0
				then
					ai_world_x = chars_mobs_npcs[l].x;
					ai_world_y = chars_mobs_npcs[l].y;
					mob_can_move = 0;
					mob_is_going_to_hit = 1;
					path_finding (0,0);
					if path_status == 1 then
						table.insert(mob_detects_enemies,l);
					end;
				end;
			end;
		end;
		if #mob_detects_enemies > 0 then
			for e=1,#mob_detects_enemies do --for aggro
				local tmpfrac = chars_mobs_npcs[mob_detects_enemies[e]].fraction;
				local tmpfrac2 = chars_mobs_npcs[current_mob].fraction;
				local fraccond = loadstring("return " .. "fractions." .. tmpfrac2 .. "." .. tmpfrac)();
				local aggro_factor = 0;
				local range_factor=math.ceil(20-math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[mob_detects_enemies[e]].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[mob_detects_enemies[e]].y)^2));
				aggro_factor = math.ceil(-1*fraccond/10)+range_factor;
				if chars_mobs_npcs[current_mob].aggressor==mob_detects_enemies[e] then
					aggro_factor = aggro_factor + chars_mobs_npcs[mob_detects_enemies[e]].aggro;
				end;
				table.insert(mob_detects_aggro,mob_detects_enemies[e]);
				local startcounter=#mob_detects_aggro+1;
				for f=startcounter,aggro_factor do
					table.insert(mob_detects_aggro,mob_detects_enemies[e]);
				end;
			end;
			local target_preroll = math.random(1,#mob_detects_aggro);
			local target_roll = mob_detects_aggro[target_preroll];
			previctim = chars_mobs_npcs[target_roll].id;
			--previctim = target_roll;
			if  helpers.ifMobIsNear(current_mob,target_roll) then
				ai_world_x = chars_mobs_npcs[target_roll].x;
				ai_world_y = chars_mobs_npcs[target_roll].y;
				helpers.turnMob (current_mob);
				mob_under_cursor= chars_mobs_npcs[target_roll].id;
				atk_direction = helpers.attackDirection (current_mob,victim);
				chars_mobs_npcs[current_mob].rot = atk_direction;
				global.multiattack = damage.countMultiattack(current_mob);
				game_status = "attack";
				damage.meleeAttack (damage.meleeAttackTool (current_mob));
				return;
			else
				mob_can_move = 1;
				mob_is_going_to_hit = 1;
				ai_world_x = chars_mobs_npcs[target_roll].x;
				ai_world_y = chars_mobs_npcs[target_roll].y;
				game_status = "pathfinding";
				path_finding(0,0);
				return;
			end;
		elseif #mob_detects_enemies == 0 then
			if all_agro > 0 then
				chars_mobs_npcs[current_mob].ai = "toenemy";
			else
				chars_mobs_npcs[current_mob].ai = "random";
			end;
		end;
	end;
--MOVING TO AN ENEMY
	if chars_mobs_npcs[current_mob].ai == "toenemy" then
		if not global.hang then
			local roll_point = 1;
			local free_hexes = helpers.findFreeHexes (current_mob);
			if #free_hexes > 0 then
				local distance = math.ceil(math.random(free_hexes[1].x^2+free_hexes[1].y^2));
				for j=1,#free_hexes do
					if agro_array[free_hexes[j].y][free_hexes[j].x] >= agro_array[free_hexes[roll_point].y][free_hexes[roll_point].x]
					and math.ceil(math.random(free_hexes[j].x^2+free_hexes[j].y^2)) <= distance
					then
						distance = math.ceil(math.random(free_hexes[j].x^2+free_hexes[j].y^2));
						roll_point = j;
					end;
				end;
				ai_world_x = free_hexes[roll_point].x;
				ai_world_y = free_hexes[roll_point].y;
				--print("TOENEMY",current_mob,#free_hexes,roll_point,free_hexes[roll_point],ai_world_x,ai_world_y);
				mob_can_move = 1;
				if chars_mobs_npcs[current_mob].person == "char" then
					helpers.addToActionLog( chars_stats[current_mob].name .. " " .. lognames.actions.toenemy);
				elseif chars_mobs_npcs[current_mob].person == "mob" then
					tmp_name1 = chars_mobs_npcs[current_mob].class;
					tmp_name2 = "lognames.mob_names." .. tmp_name1;
					tmp_name3 = loadstring("return " .. tmp_name2)();
					helpers.addToActionLog( tmp_name3 .. " " .. lognames.actions.toenemy);
				end;
				path_finding (0,0);
				return;
			else
				chars_mobs_npcs[current_mob].rot = math.random(1,6);
				chars_mobs_npcs[current_mob].ai = "stay";
			end;
		else
			game_status = "restoring";
			return;
		end;
	end;
--MOVING TO A PARTY
	ai.party_array_full ();
	if chars_mobs_npcs[current_mob].ai == "toparty" then
		if not global.hang then
			local roll_point = 1;
			local free_hexes = helpers.findFreeHexes (current_mob);
			if #free_hexes > 0 then
				local distance = math.ceil(math.random(free_hexes[1].x^2+free_hexes[1].y^2));
				for j=1,#free_hexes do
					if party_array[free_hexes[j].y][free_hexes[j].x] >= party_array[free_hexes[roll_point].y][free_hexes[roll_point].x]
					and math.ceil(math.random(free_hexes[j].x^2+free_hexes[j].y^2)) <= distance
					then
						distance = math.ceil(math.random(free_hexes[j].x^2+free_hexes[j].y^2));
						roll_point = j;
					end;
				end;
				ai_world_x = free_hexes[roll_point].x;
				ai_world_y = free_hexes[roll_point].y;
				--print("TOENEMY",current_mob,#free_hexes,roll_point,free_hexes[roll_point],ai_world_x,ai_world_y);
				mob_can_move = 1;
				if chars_mobs_npcs[current_mob].person == "char" then
					helpers.addToActionLog( chars_stats[current_mob].name .. " " .. lognames.actions.toenemy);
				elseif chars_mobs_npcs[current_mob].person == "mob" then
					tmp_name1 = chars_mobs_npcs[current_mob].class;
					tmp_name2 = "lognames.mob_names." .. tmp_name1;
					tmp_name3 = loadstring("return " .. tmp_name2)();
					helpers.addToActionLog( tmp_name3 .. " " .. lognames.actions.toenemy);
				end;
				path_finding (0,0);
				return;
			else
				chars_mobs_npcs[current_mob].rot = math.random(1,6);
				chars_mobs_npcs[current_mob].ai = "stay";
			end;
		end;
	end;
--RANDOM WALKING
	if chars_mobs_npcs[current_mob].ai == "random" then
		mob_is_going_to_hit = 0;
		local rollmd = math.random(1,2);
		if rollmd == 1 then
			modepf = 1;
		else
			modepf = -1;
		end;
		roll_point = 0;
		local free_hexes = helpers.findFreeHexes (current_mob);
		if #free_hexes > 0 then
			local roll_point = math.random(1,#free_hexes);
			ai_world_x = free_hexes[roll_point].x;
			ai_world_y = free_hexes[roll_point].y;
			mob_can_move = 1;
			path_finding (0,0);
			if chars_mobs_npcs[current_mob].person=="char" then
				helpers.addToActionLog( chars_stats[current_mob].name .. " " .. lognames.actions.lostself[chars_mobs_npcs[current_mob].gender]);
			elseif chars_mobs_npcs[current_mob].person=="mob" then
				tmp_name1 = chars_mobs_npcs[current_mob].class;
				tmp_name2 = "lognames.mob_names." .. tmp_name1;
				tmp_name3 = loadstring("return " .. tmp_name2)();
				helpers.addToActionLog( tmp_name3 .. " " .. lognames.actions.lostself[chars_mobs_npcs[current_mob].gender]);
				
			end;
			return;
		else
			chars_mobs_npcs[current_mob].ai = "stay";
		end;
	end;
--AFRAID
	if chars_mobs_npcs[current_mob].ai == "away" then
		mob_is_going_to_hit = 0;
		local rollmd = math.random(1,2);
		if rollmd == 1 then
			modepf = 1;
		else
			modepf = -1;
		end;
		local roll_point = 1;
		local free_hexes = helpers.findFreeHexes (current_mob);
		if #free_hexes > 0 then
			for j=1,#free_hexes do
				if agro_array[free_hexes[j].y][free_hexes[j].x] < agro_array[free_hexes[roll_point].y][free_hexes[roll_point].x] then
					roll_point = j;
				end;
			end;
			ai_world_x = free_hexes[roll_point].x;
			ai_world_y = free_hexes[roll_point].y;
			mob_can_move = 1;
			helpers.addToActionLog( helpers.mobName(current_mob) .. " " .. lognames.actions.runaway);
			path_finding (0,0);
			return;
		else
			chars_mobs_npcs[current_mob].ai = "agr";
			chars_mobs_npcs[current_mob].battleai = "melee";
			return;
		end;
	end;
--STAY
	if chars_mobs_npcs[current_mob].ai == "stay" then
		if ai.mobWatchesTheMob (current_mob,true) then
			chars_mobs_npcs[current_mob].ai = chars_mobs_npcs[current_mob].dangerai;
			game_status = "restoring";
			return;
		else
			--chars_mobs_npcs[current_mob].rt = chars_mobs_npcs[current_mob].rt - 200;
			damage.RTminus(current_mob,200,false);
			game_status = "restoring";
			return;
		end;
	end;
--RETURNING TO BASE
	if chars_mobs_npcs[current_mob].area and not helpers.thisHexAtArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].area) then
		local free_hexes = helpers.findZoneHexes (current_mob);
		if #free_hexes > 0 then	
			chars_mobs_npcs[current_mob].ai = "called";
			mob_is_going_to_hit = 0;
			local roll_point = math.random(1,#free_hexes);
			chars_mobs_npcs[current_mob]["call"].x = free_hexes[roll_point].x;
			chars_mobs_npcs[current_mob]["call"].y = free_hexes[roll_point].y;
			mob_can_move = 1;
			path_finding (0,0);
			helpers.addToActionLog( helpers.mobName(current_mob) .. " " .. lognames.actions.movingback);
			return;
		end;
	end;
end;

function ai.fractionRelations (watcher,index)
	local tmpfrac= chars_mobs_npcs[watcher].fraction;
	local tmpfrac2= chars_mobs_npcs[index].fraction;
	local fraccond=loadstring("return " .. "fractions." .. tmpfrac2 .. "." .. tmpfrac)();
	return fraccond;
end;

function ai.friendOrFoe (watcher,index)
	if ai.fractionRelations (watcher,index) < 0 or chars_mobs_npcs[index].control ~= chars_mobs_npcs[watcher].control or chars_mobs_npcs[index].berserk > 0 then
		return false;
	end;
	return true;
end;

function ai.enemyWatchesYou ()
	local value = false;
	for index=1,#chars_mobs_npcs do
		if chars_mobs_npcs[index].control == "player" then
			value = ai.mobWatchesTheMob(index,true);
			if value then
				return true;
			end;
		end;
	end;
	return false;
end;

function ai.mobWatchesTheMobNum (index,enemyonly) --for stealth
	local counter = 0;
	local value = 0;
	for i = 1, #chars_mobs_npcs do
		if chars_mobs_npcs[i].ai ~= "building" and chars_mobs_npcs[i].status == 1 and chars_mobs_npcs[i].dangerai == "agr" 
		and darkness[chars_mobs_npcs[i].party][chars_mobs_npcs[index].y][chars_mobs_npcs[index].x] == 0 
		and chars_mobs_npcs[i].blind_dur == 0 and chars_mobs_npcs[i].sleep == 0 and chars_mobs_npcs[i].stone == 0 and chars_mobs_npcs[i].freeze == 0 and (chars_mobs_npcs[i].reye == 1 or chars_mobs_npcs[i].leye == 1) then
			if not enemyonly or (enemyonly and ai.fractionRelations (i,index) < 0) then
				local value = 2 + chars_mobs_npcs[i].num_spothidden*chars_mobs_npcs[i].lvl_spothidden;
				if helpers.blindedWithLight (current_mob,chars_mobs_npcs[i].x,chars_mobs_npcs[i].y) then
					value = math.ceil(value/2);
				end;
			end;
			counter = counter + value;
		end;
	end;
	return counter;
end;

function ai.mobWatchesTheMob (index,enemyonly)
	for i = 1, #chars_mobs_npcs do
		if darkness[chars_mobs_npcs[i].party][chars_mobs_npcs[i].y][chars_mobs_npcs[i].x] == 0 and chars_mobs_npcs[i].status > 0
		and chars_mobs_npcs[i].blind_dur == 0 and chars_mobs_npcs[i].sleep == 0 and chars_mobs_npcs[i].stone == 0 then
			if not enemyonly or (enemyonly and ai.fractionRelations (i,index) < 0) then
				return true;
			end;
		end;
	end;
	return false;
end;

function ai.sendCall(index,trigger,party,fraction)
	for i = 1, #chars_mobs_npcs do
		if ((party and chars_mobs_npcs[i].party == chars_mobs_npcs[index].party) or (fraction and chars_mobs_npcs[i].fraction == chars_mobs_npcs[index].fraction)) and chars_mobs_npcs[i].control == "ai" and not ai.mobWatchesTheMob (i,true) then
			if not trigger then
				chars_mobs_npcs[i].call = {chars_mobs_npcs[index].x,chars_mobs_npcs[index].y};
			else
				chars_mobs_npcs[i].call = {triggers[trigger].x,triggers[trigger].y};
			end;
			chars_mobs_npcs[index].ai = "called";
		end;
	end;
end;

function ai.agro_array_full () -- check trace and visibility
	local agro_array = {};
	for i=1, map_w do
		agro_array [i]= {};
		for z=1, map_h do
			agro_array[i][z]= 0;
		end;
	end;
	for i=1, map_w do
		for z=1, map_h do
			for m=1,#chars_mobs_npcs do
				if chars_mobs_npcs[m].y == i and chars_mobs_npcs[m].x == z and chars_mobs_npcs[m].invisibility == 0 then
					local tmpfrac = chars_mobs_npcs[m].fraction;
					local tmpfrac2 = chars_mobs_npcs[current_mob].fraction;
					local fraccond = loadstring("return " .. "fractions." .. tmpfrac2 .. "." .. tmpfrac)();
					if fraccond < 0 and chars_mobs_npcs[m].invisibility == 0 and darkness[chars_mobs_npcs[current_mob].party][chars_mobs_npcs[m].y][chars_mobs_npcs[m].x] == 0 then
						agro_array[i][z] = 10+math.ceil(chars_mobs_npcs[current_mob].lv*math.abs(fraccond)/100);
					end;
				end;
			end;
			for n=1,6 do
				if i/2 == math.ceil(i/2)then
					if i+directions[1].y[n]>0 and i+directions[1].y[n] <= map_w and z+directions[1].xc[n] > 0 and z+directions[1].xc[n] <= map_h then
						agro_array[i+directions[1].y[n]][z+directions[1].xc[n]] = math.max(agro_array[i+directions[1].y[n]][z+directions[1].xc[n]],agro_array[i][z]-1);
					end;
				else
					if i+directions[1].y[n] > 0 and i+directions[1].y[n] < map_w and z+directions[1].xn[n] > 0 and z+directions[1].xn[n] < map_h then
						agro_array[i+directions[1].y[n]][z+directions[1].xn[n]] = math.max(agro_array[i+directions[1].y[n]][z+directions[1].xn[n]],agro_array[i][z]-1);
					end;
				end; 
			end;
		end;
	end;
	for i=map_w,1 do
		for z=map_h,1 do
			for n=1,6 do
				if i/2 == math.ceil(i/2)then
					if i+directions[1].y[n] > 0 and i+directions[1].y[n] <= map_w  and z+directions[1].xc[n] > 0 and z+directions[1].xc[n] <= map_h then
						agro_array[i+directions[1].y[n]][z+directions[1].xc[n]] = math.max(agro_array[i+directions[1].y[n]][z+directions[1].xc[n]],agro_array[i][z]-1);
					end;
				else
					if i+directions[1].y[n]>0 and i+directions[1].y[n] <= map_w and z+directions[1].xn[n]>0 and z+directions[1].xn[n] <= map_h then
						agro_array[i+directions[1].y[n]][z+directions[1].xn[n]] = math.max(agro_array[i+directions[1].y[n]][z+directions[1].xn[n]],agro_array[i][z]-1);
					end;
				end;
			end;
		end;
	end;
	all_agro = 0
	for i = 1,#agro_array do
		for h = 1,#agro_array[i] do
			all_agro = all_agro + agro_array[i][h];
		end;
	end;
	return agro_array
end;

function ai.party_array_full ()
	local party_array = {};
	for i=1, map_w do
		party_array [i]= {};
		for z=1, map_h do
			party_array[i][z]= 0;
		end;
	end;
	for i=1, map_w do
		for z=1, map_h do
			for m=1,#chars_mobs_npcs do		
				if chars_mobs_npcs[current_mob].party == chars_mobs_npcs[m].party then
					party_array[i][z] = 10;
				end;
			end;
			for n=1,6 do
				if i/2 == math.ceil(i/2)then
					if i+directions[1].y[n]>0 and i+directions[1].y[n] <= map_w and z+directions[1].xc[n] > 0 and z+directions[1].xc[n] <= map_h then
						party_array[i+directions[1].y[n]][z+directions[1].xc[n]] = math.max(party_array[i+directions[1].y[n]][z+directions[1].xc[n]],party_array[i][z]-1);
					end;
				else
					if i+directions[1].y[n] > 0 and i+directions[1].y[n] < map_w and z+directions[1].xn[n] > 0 and z+directions[1].xn[n] < map_h then
						party_array[i+directions[1].y[n]][z+directions[1].xn[n]] = math.max(party_array[i+directions[1].y[n]][z+directions[1].xn[n]],party_array[i][z]-1);
					end;
				end; 
			end;
		end;
	end;
	for i=map_w,1 do
		for z=map_h,1 do
			for n=1,6 do
				if i/2 == math.ceil(i/2)then
					if i+directions[1].y[n] > 0 and i+directions[1].y[n] <= map_w  and z+directions[1].xc[n] > 0 and z+directions[1].xc[n] <= map_h then
						party_array[i+directions[1].y[n]][z+directions[1].xc[n]] = math.max(party_array[i+directions[1].y[n]][z+directions[1].xc[n]],party_array[i][z]-1);
					end;
				else
					if i+directions[1].y[n]>0 and i+directions[1].y[n] <= map_w and z+directions[1].xn[n]>0 and z+directions[1].xn[n] <= map_h then
						party_array[i+directions[1].y[n]][z+directions[1].xn[n]] = math.max(party_array[i+directions[1].y[n]][z+directions[1].xn[n]],party_array[i][z]-1);
					end;
				end;
			end;
		end;
	end;
	all_party = 0
	for i = 1,#party_array do
		for h = 1,#party_array[i] do
			all_party = all_party + party_array[i][h];
		end;
	end;
	return party_array
end;
