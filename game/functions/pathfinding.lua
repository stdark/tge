function path_finding (mode,ignore_mobs)
	hitHex = {x=0,y=0};
	mob_is_going_to_picklock = 0;
	mob_is_going_to_knock = 0;
	mob_is_going_to_useobject = 0;
	chars_mobs_npcs[current_mob].view = chars_mobs_npcs[current_mob].rot;
	local checked_path={};
	local checked_path2={};
	local mob_range = 0;
	helpers.recalcBattleStats (current_mob);
	if mode == 0 then --battle
		local st_rt_limit = math.min(math.ceil(chars_mobs_npcs[current_mob].rt/5),math.ceil(chars_mobs_npcs[current_mob].st/5));
		local limit = math.min(chars_mobs_npcs[current_mob].rng,st_rt_limit);
		mob_range = math.max(0,limit-walked_before); --count walked before!
		if chars_mobs_npcs[current_mob].immobilize > 0 then
			mob_range = 0;
		elseif chars_mobs_npcs[current_mob].wingsoflight > 0 then
			mob_range = chars_mobs_npcs[current_mob].wingsoflight;
		end;
		
	elseif mode == 1 then --peace
		mob_range = 20;
	elseif mode == 2 then --earth magic
		mob_range = 5 + chars_mobs_npcs[current_mob].lvl_earth;
	end;
	path_status = 0;
	path_print = "";
	path_can_be_found = 0;
	cursor_on_mob = 0;
	aim_on_mob = 0;
	if chars_mobs_npcs[current_mob].control == "player" then
		if helpers.insideMap(cursor_world_x,cursor_world_y) then
			point_to_go_x = cursor_world_x;
			point_to_go_y = cursor_world_y;
			cursor_hex_x = cursor_world_x;
			cursor_hex_y = cursor_world_y;
		else
			point_to_go_x = chars_mobs_npcs[current_mob].x;
			point_to_go_y = chars_mobs_npcs[current_mob].y;
		end;
		if chars_mobs_npcs[current_mob].person == "char" then
			--chest
			local cursor_at_chest, pointx,pointy,rotation_to_chest = helpers.cursorAtChest(cursor_world_x,cursor_world_y);
			if cursor_at_chest then
				point_to_go_x = pointx;
				point_to_go_y = pointy;
				last_path_hex_turn = rotation_to_chest; -- check if hex is free!
				mob_is_going_to_picklock = 1;
			end;
			--trashheap,scullpile,campfire,crystals,secret,well
			local at_mbag,mbagid = helpers.cursorAtMaterialBag(cursor_world_x,cursor_world_y);
			if at_mbag then
				point_to_go_x = cursor_world_x;
				point_to_go_y = cursor_world_y;
				local newx,newy = findAltWayToHex(cursor_world_x,cursor_world_y);
				if newx and newy then
					point_to_go_x = newx;
					point_to_go_y = newy;
				end;
				bagid = mbagid;
				mob_is_going_to_picklock = 1;
				hitHex = {x=cursor_hex_x,y=cursor_hex_y};
				path_can_be_found = 1;
				path_status = 1;
			end;
			local cursor_at_door, bagid, locked, traped = helpers.cursorAtClosedDoor(point_to_go_x,point_to_go_y);
			if cursor_at_door and (locked or traped) then				
				local newx,newy = findAltWayToHex(cursor_world_x,cursor_world_y);
				if newx and newy then
					point_to_go_x = newx;
					point_to_go_y = newy;
				end;
				mob_is_going_to_picklock = 1;
				if point_to_go_x and helpers.passWalk(point_to_go_x,point_to_go_y) and not helpers.isAimOnMob (point_to_go_x,point_to_go_y) then
					path_can_be_found = 1;
					hitHex = {x=cursor_hex_x,y=cursor_hex_y};
					global.object = helpers.whatObject(cursor_world_x,cursor_world_y);
				else
					path_status = 0;
					--print("path not found!");
				end;
			end;
			--buildings
			local cursor_at_building,rotation_to_building = helpers.cursorAtBuilding(cursor_world_x,cursor_world_y);
			if cursor_at_building then
				point_to_go_x = cursor_world_x;
				point_to_go_y = cursor_world_y;
				if helpers.passCheck(point_to_go_x,point_to_go_y) then
					last_path_hex_turn = rotation_to_building;
					mob_is_going_to_knock = 1;
				else
					path_status = 0;
				end;
			end;
			--obelisks,altars,barrels,cauldrons,pedestals
			if helpers.cursorAtObject(cursor_world_x,cursor_world_y) then
				point_to_go_x = cursor_world_x;
				point_to_go_y = cursor_world_y;
				atk_direction = helpers.bestAttackDirection (current_mob,point_to_go_x,point_to_go_y);
				if not helpers.passCheck(cursor_world_x,cursor_world_y) or helpers.cursorAtMob(cursor_world_x,cursor_world_y) then
					local newx,newy = findAltWayToHex(cursor_world_x,cursor_world_y);
					if newx and newy then
						point_to_go_x = newx;
						point_to_go_y = newy;
					end;
				end;
				mob_is_going_to_useobject = 1;
				if point_to_go_x and helpers.passWalk(point_to_go_x,point_to_go_y) and not helpers.isAimOnMob (point_to_go_x,point_to_go_y) then
					path_can_be_found = 1;
					hitHex = {x=cursor_hex_x,y=cursor_hex_y};
					global.object = helpers.whatObject(cursor_world_x,cursor_world_y);
				else
					path_status = 0;
					--print("path not found!");
				end;	
			end;
		end;
	elseif chars_mobs_npcs[current_mob].control == "ai" then
		point_to_go_x = ai_world_x;
		point_to_go_y = ai_world_y;
		atk_direction = math.random(1,6); --dirtyfix
	end;
	--if  game_status == "path_finding" and chars_mobs_npcs[current_mob].control == "player" and not helpers.passWalk(point_to_go_x,point_to_go_y) then --FIXME spikes and razors also
	if  game_status == "path_finding" and chars_mobs_npcs[current_mob].control == "player" and not helpers.passMove(point_to_go_x,point_to_go_y,current_mob) then
		path_status = 0;
		--print ("path not found (char)!");
		--find_the_path = 0;
		global.hang = false;
		game_status = "path_finding";--do not move if neutral
	end;
--just walk or hit for a char
	if not helpers.cursorAtMob (point_to_go_x,point_to_go_y) and not helpers.cursorAtObject(cursor_world_x,cursor_world_y) then
	--if not helpers.ifMobAtCordinates(ppoint_x,ppoint_y) then
		path_can_be_found = 1;
		global.wheeled = 0;
		global.traced = false;
	elseif helpers.cursorAtMob (point_to_go_x,point_to_go_y) then
		local rings = boomareas.ringArea(point_to_go_x,point_to_go_y);
		if global.wheeled == 0 then
			--if mob_is_going_to_hit == 1 then
			atk_direction = helpers.bestAttackDirection (current_mob,point_to_go_x,point_to_go_y);
			chars_mobs_npcs[current_mob].rot = helpers.antiDirection(atk_direction);
			if not global.traced then
				trace.first_watch(current_mob);
				trace.chars_around();
				trace.clear_rounded();
				global.traced = true;
			end;
		end;
		point_to_go_x = rings[1][atk_direction].x;
		point_to_go_y = rings[1][atk_direction].y;
		--atk_dir_to_hex ();
---char should find alt way to enemy
		if aim_on_mob == 1 and global.wheeled == 0 then
			counter = 1;
			global.wheeled = 1;
		end;
		counter = 1;
		--while (helpers.isAimOnMob (rings[1][counter].x,rings[1][counter].y)  or not helpers.passWalk(rings[1][counter].x,rings[1][counter].y)) do
		while (helpers.isAimOnMob (rings[1][atk_direction].x,rings[1][atk_direction].y)  or not helpers.passWalk(rings[1][atk_direction].x,rings[1][atk_direction].y)) do
			aim_on_mob = 0;
			atk_direction = atk_direction+1;
			
			if atk_direction > 6 then
				atk_direction = 1;
			end;
			if not helpers.isAimOnMob (rings[1][counter].x,rings[1][counter].y) and helpers.passWalk(rings[1][counter].x,rings[1][counter].y) then
				point_go_x = rings[1][atk_direction].x;
				point_to_go_y = rings[1][atk_direction].y;
				path_can_be_found = 1;
				break;
			end;
			counter=counter+1;
			if counter >= 6 then
				path_status = 0;
				path_print = "path not found (char)!";
				global.hang = false;
				damage.RTminus(current_mob,100,false);
				game_status = "restoring";
				print ("alt way problem");
				break;
			end;
		end;
		if helpers.passWalk(point_to_go_x,point_to_go_y) and not helpers.isAimOnMob (point_to_go_x,point_to_go_y) then
			if cusor_on_mob == 0 then
				global.wheeled = 0;
			end;
			path_can_be_found = 1;
			hitHex = {x=cursor_hex_x,y=cursor_hex_y};
		else
			path_status = 0;
			--print("path not found!");
		end;
	end;
	if chars_mobs_npcs[current_mob].control == "player" and helpers.cursorAtMob (cursor_world_x,cursor_world_y) and helpers.cursorAtMobControl (cursor_world_x,cursor_world_y) == "player" then
		aim_on_mob = 1;
		path_status = 0;
		--print("path not found!(P)");--dupilcating!
	end;
	--just walk or hit/
	
	if  path_can_be_found == 1 and helpers.passWalk(point_to_go_x,point_to_go_y) then
	--cleaning list of checked and to_be_checked hexes for a new path finding action
		path_status=0
	--path_print="path not found!"
		for n=1,#hex_to_check_next_wave do
			table.remove(hex_to_check_next_wave,1);
		end;
		for m=1,#checked_path2 do 
			table.remove(checked_path2,1);
		end;
		local wave = 1;
		table.insert(checked_path2,{chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,1,1,0,0});
		table.insert(hex_to_check_next_wave,1,{chars_mobs_npcs[current_mob].x, chars_mobs_npcs[current_mob].y,1});
--making waves
		local new_wave = 0;
		while (new_wave <= mob_range and path_status == 0 and #hex_to_check_next_wave > 0) do
			new_ppoint_x = hex_to_check_next_wave[1][1];
			new_ppoint_y = hex_to_check_next_wave[1][2];
			new_index = hex_to_check_next_wave[1][3];
			table.remove(hex_to_check_next_wave,1);
			for p=1,6 do
				hex_on_mob = 0;
				if new_ppoint_x > map_limit_w
				--and math.sqrt((point_to_go_x-chars_mobs_npcs[current_mob].x)^2+(point_to_go_y-chars_mobs_npcs[current_mob].y)^2) <=mob_range --FIX PROBLEM 
				and new_ppoint_x < map_w-map_limit_w 
				and new_ppoint_y > map_limit_h 
				and new_ppoint_y < map_h-map_limit_h then
					ppoint_y = new_ppoint_y+directions[1].y[p];
					if modepf == 1 then
						if new_ppoint_x > chars_mobs_npcs[current_mob].x then
							if ppoint_y/2 == math.ceil(ppoint_y/2) then
								ppoint_x = new_ppoint_x+directions[1].xn[p];
							else
								ppoint_x = new_ppoint_x+directions[1].xc[p]; 
							end;
						elseif new_ppoint_x<= chars_mobs_npcs[current_mob].x then
							if ppoint_y/2 == math.ceil(ppoint_y/2) then
								ppoint_x = new_ppoint_x+directions[1].xnr[p];
							else
								ppoint_x = new_ppoint_x+directions[1].xcr[p];
							end;
						end;
					elseif  modepf == -1 then
						if  new_ppoint_x < chars_mobs_npcs[current_mob].x then
							if ppoint_y/2 == math.ceil(ppoint_y/2) then
								ppoint_x = new_ppoint_x+directions[1].xn[p];
							else
								ppoint_x = new_ppoint_x+directions[1].xc[p];
							end;
						elseif new_ppoint_x >= chars_mobs_npcs[current_mob].x then
							if ppoint_y/2 == math.ceil(ppoint_y/2) then
								ppoint_x = new_ppoint_x+directions[1].xnr[p];
							else
								ppoint_x = new_ppoint_x+directions[1].xcr[p];
							end;
						end; 
					end;
				end;
				if checked_path2[#checked_path2][1] == point_to_go_x and checked_path2[#checked_path2][2] == point_to_go_y then
					path_status = 1;
					--print("a path has been found!");
					dest_point_x = checked_path2[#checked_path2][1];
					dest_point_y = checked_path2[#checked_path2][2];							
					if chars_mobs_npcs[current_mob].control=="ai" and mob_can_move == 1 then
						game_status = "premoving";
					end;
					break; -- breaking while
				end;
				if path_status == 1 then
					print("BREAKKKK!!!!");
					break;
				end;
				already_chkd = 0;
				for k=1,#checked_path2 do
					if checked_path2[k][1] == ppoint_x and checked_path2[k][2] == ppoint_y then
						already_chkd = 1;
					end;
				end;
				wave_delta_x = math.abs(chars_mobs_npcs[current_mob].x-ppoint_x);
				wave_delta_y = math.abs(chars_mobs_npcs[current_mob].y-ppoint_y);
				wave_delta_m = math.max(wave_delta_x,wave_delta_y);
				if wave_delta_m > new_wave then
					new_wave=wave_delta_m;
				end;
				for i=1,#chars_mobs_npcs do
					--if ignore_mobs == 0 and chars_mobs_npcs[i].x == ppoint_x and chars_mobs_npcs[i].y == ppoint_y and chars_mobs_npcs[i].status > 0 then --dont stay at dead one?
					if ignore_mobs == 0 and helpers.cursorAtMob (ppoint_x,ppoint_y) then
						hex_on_mob=1;
					elseif ignore_mobs == 1 then --spikes
						hex_on_mob=0;
					end;
				end
				
				--[[if ignore_mobs == 0 and helpers.ifMobAtCordinates(ppoint_x,ppoint_y) then --twohexes
					hex_on_mob=1;
				elseif ignore_mobs == 1 then --spikes
					hex_on_mob=0;
				end;]]
				
				
				for j=1,#bags_list do
					if bags_list[j].typ == "chest" and bags_list[j].xi == ppoint_x and bags_list[j].yi == ppoint_y then
						hex_on_mob = 1 -- dirty hack, will be removed after adding chests to map editor
					end;
				end;
				for j=1,#objects_list do
					if objects_list[j].typ == "chest" and objects_list[j].xi == ppoint_x then
						hex_on_mob = 1 -- dirty hack, will be removed after adding chests to map editor
					end;
				end;
				if already_chkd == 0 and helpers.passWalk(ppoint_x,ppoint_y) and hex_on_mob == 0 then
					table.insert(checked_path2,{ppoint_x,ppoint_y,#checked_path2+1,new_index,new_wave});
					table.insert(hex_to_check_next_wave,checked_path2[#checked_path2]);
				end;
			end;
			wave = wave+1;
		end;
--drawing found path
		for f=1,#way_of_the_mob do
			table.remove(way_of_the_mob,1);
		end;
		if path_status == 1  then
			current_point_x=dest_point_x;
			current_point_y=dest_point_y;
			paint_index=checked_path2[#checked_path2][3];
			while (current_point_x ~= chars_mobs_npcs[current_mob].x or current_point_y ~= chars_mobs_npcs[current_mob].y) do
				if path_status == 0 then
					break;
				end;
				table.insert(way_of_the_mob,{checked_path2[paint_index][1],checked_path2[paint_index][2],0,0,checked_path2[paint_index][5] });
				paint_index=checked_path2[paint_index][4];
				current_point_x=checked_path2[paint_index][1];
				current_point_y=checked_path2[paint_index][2];
			end;
			--rotation_while_moving
			local mob_rot = 0;
			--for h=2,#way_of_the_mob do --rotation at 2nd - last hexes
			for h=2,math.max(0,#way_of_the_mob-1) do --rotation at 2nd - prev last hexes
				if way_of_the_mob[h][2]==way_of_the_mob[h-1][2] and way_of_the_mob[h][1]>way_of_the_mob[h-1][1] then
					mob_rot=5;
				elseif way_of_the_mob[h][2]==way_of_the_mob[h-1][2] and way_of_the_mob[h][1]<way_of_the_mob[h-1][1] then
					mob_rot=2;
				elseif way_of_the_mob[h][2]>way_of_the_mob[h-1][2] and way_of_the_mob[h][1]==way_of_the_mob[h-1][1] and way_of_the_mob[h-1][2]/2==math.ceil(way_of_the_mob[h-1][2]/2) then
					mob_rot=6;
				elseif way_of_the_mob[h][2]>way_of_the_mob[h-1][2] and way_of_the_mob[h][1]>way_of_the_mob[h-1][1] and way_of_the_mob[h-1][2]/2~=math.ceil(way_of_the_mob[h-1][2]/2) then
					mob_rot=6;
				elseif way_of_the_mob[h][2]>way_of_the_mob[h-1][2] and way_of_the_mob[h][1]<way_of_the_mob[h-1][1] and way_of_the_mob[h-1][2]/2==math.ceil(way_of_the_mob[h-1][2]/2) then
					mob_rot=1;
				elseif way_of_the_mob[h][2]>way_of_the_mob[h-1][2] and way_of_the_mob[h][1]==way_of_the_mob[h-1][1] and way_of_the_mob[h-1][2]/2~=math.ceil(way_of_the_mob[h-1][2]/2) then
					mob_rot=1;
				elseif way_of_the_mob[h][2]<way_of_the_mob[h-1][2] and way_of_the_mob[h][1]==way_of_the_mob[h-1][1] and way_of_the_mob[h-1][2]/2==math.ceil(way_of_the_mob[h-1][2]/2) then
					mob_rot=4;
				elseif way_of_the_mob[h][2]<way_of_the_mob[h-1][2] and way_of_the_mob[h][1]>way_of_the_mob[h-1][1] and way_of_the_mob[h-1][2]/2~=math.ceil(way_of_the_mob[h-1][2]/2) then
					mob_rot=4;
				elseif way_of_the_mob[h][2]<way_of_the_mob[h-1][2] and way_of_the_mob[h][1]<way_of_the_mob[h-1][1] and way_of_the_mob[h-1][2]/2==math.ceil(way_of_the_mob[h-1][2]/2) then
					mob_rot=3;
				elseif way_of_the_mob[h][2]<way_of_the_mob[h-1][2] and way_of_the_mob[h][1]==way_of_the_mob[h-1][1] and way_of_the_mob[h-1][2]/2~=math.ceil(way_of_the_mob[h-1][2]/2) then
					mob_rot=3;
				end;
				way_of_the_mob[h][6] = mob_rot;
			end;
			local hex_around = boomareas.smallRingArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y); -- rotation for 1st hex
			for i=1,6 do
				if hex_around[i].x == way_of_the_mob[#way_of_the_mob][1] and hex_around[i].y == way_of_the_mob[#way_of_the_mob][2] then
					way_of_the_mob[#way_of_the_mob][6] = i;
				end;
			end;

			if #way_of_the_mob == 1 then --rotation at last hex
				if way_of_the_mob[1][2]/2 == math.ceil(way_of_the_mob[1][2]/2) then
					if way_of_the_mob[1][1]>chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]<chars_mobs_npcs[current_mob].y then
						mob_rot=1;
					elseif way_of_the_mob[1][1]>chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]== chars_mobs_npcs[current_mob].y then
						mob_rot=2;
					elseif way_of_the_mob[1][1]>chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]>chars_mobs_npcs[current_mob].y then
						mob_rot=3;
					elseif way_of_the_mob[1][1]== chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]>chars_mobs_npcs[current_mob].y then
						mob_rot=4;
					elseif way_of_the_mob[1][1]<chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]>chars_mobs_npcs[current_mob].y then
						mob_rot=4;
					elseif way_of_the_mob[1][1]<chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]== chars_mobs_npcs[current_mob].y then
						mob_rot=5;
					elseif way_of_the_mob[1][1]== chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]<chars_mobs_npcs[current_mob].y then
						mob_rot=6;
					end;
				elseif way_of_the_mob[1][2]/2 ~= math.ceil(way_of_the_mob[1][2]/2) then
					if way_of_the_mob[1][1]== chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]<chars_mobs_npcs[current_mob].y then
						mob_rot=6;
					elseif way_of_the_mob[1][1]>chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]== chars_mobs_npcs[current_mob].y then
						mob_rot=2;
					elseif way_of_the_mob[1][1]== chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]>chars_mobs_npcs[current_mob].y then
						mob_rot=3;
					elseif way_of_the_mob[1][1]<chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]>chars_mobs_npcs[current_mob].y then
						mob_rot=4;
					elseif way_of_the_mob[1][1]>chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]>chars_mobs_npcs[current_mob].y then
						mob_rot=3;	
					elseif way_of_the_mob[1][1]<chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]== chars_mobs_npcs[current_mob].y then
						mob_rot=5;
					elseif way_of_the_mob[1][1]<chars_mobs_npcs[current_mob].x and way_of_the_mob[1][2]<chars_mobs_npcs[current_mob].y then
						mob_rot=6;
					end;
				end;
				way_of_the_mob[1][6]=mob_rot;
			elseif #way_of_the_mob > 1 then
				if way_of_the_mob[1][2]/2 == math.ceil(way_of_the_mob[1][2]/2) then
					if way_of_the_mob[1][1]>way_of_the_mob[2][1] and way_of_the_mob[1][2]<way_of_the_mob[2][2] then
						mob_rot=1;
					elseif way_of_the_mob[1][1]>way_of_the_mob[2][1] and way_of_the_mob[1][2]== way_of_the_mob[2][2] then
						mob_rot=2;
					elseif way_of_the_mob[1][1]>way_of_the_mob[2][1] and way_of_the_mob[1][2]>way_of_the_mob[2][2] then
						mob_rot=3;
					elseif way_of_the_mob[1][1]== way_of_the_mob[2][1] and way_of_the_mob[1][2]>way_of_the_mob[2][2] then
						mob_rot=4;
					elseif way_of_the_mob[1][1]<way_of_the_mob[2][1] and way_of_the_mob[1][2]>way_of_the_mob[2][2] then
						mob_rot=4;
					elseif way_of_the_mob[1][1]<way_of_the_mob[2][1] and way_of_the_mob[1][2]== way_of_the_mob[2][2] then
						mob_rot=5;
					elseif way_of_the_mob[1][1]== way_of_the_mob[2][1] and way_of_the_mob[1][2]<way_of_the_mob[2][2] then
						mob_rot=6;
					end;
				elseif way_of_the_mob[1][2]/2 ~= math.ceil(way_of_the_mob[1][2]/2) then
					if way_of_the_mob[1][1]== way_of_the_mob[2][1] and way_of_the_mob[1][2]<way_of_the_mob[2][2] then
						mob_rot=1;
					elseif way_of_the_mob[1][1]>way_of_the_mob[2][1] and way_of_the_mob[1][2]== way_of_the_mob[2][2] then
						mob_rot=2;
					elseif way_of_the_mob[1][1]== way_of_the_mob[2][1] and way_of_the_mob[1][2]>way_of_the_mob[2][2] then
						mob_rot=3;
					elseif way_of_the_mob[1][1]<way_of_the_mob[2][1] and way_of_the_mob[1][2]>way_of_the_mob[2][2] then
						mob_rot=4;
					elseif way_of_the_mob[1][1]>way_of_the_mob[2][1] and way_of_the_mob[1][2]>way_of_the_mob[2][2] then
						mob_rot=3;	
					elseif way_of_the_mob[1][1]<way_of_the_mob[2][1] and way_of_the_mob[1][2]== way_of_the_mob[2][2] then
						mob_rot=5;
					elseif way_of_the_mob[1][1]<way_of_the_mob[2][1] and way_of_the_mob[1][2]<way_of_the_mob[2][2] then
						mob_rot=6;
					end;
				end;
				way_of_the_mob[1][6]=mob_rot;
			elseif #way_of_the_mob == 0 then
				mob_rot = chars_mobs_npcs[current_mob].rot;
			end;
			--/rotation
			if chars_mobs_npcs[current_mob].control == "ai" and game_status == "premoving" then
				local tmp = chars_mobs_npcs[current_mob].sprite .. "_walk";
				local mob_walk = loadstring("return " .. tmp)()
				if #way_of_the_mob > 0 then
					animation_walk = anim8.newAnimation(mob_walk[way_of_the_mob[1][6]]("4-8",1), 0.075,"pauseAtEnd");
				else
					animation_walk = anim8.newAnimation(mob_walk[chars_mobs_npcs[current_mob].rot]("4-8",1), 0.075,"pauseAtEnd");
				end;
				game_status = "moving";
				find_the_path=0;
				m_timer = 0;
			end;
		else --path not found
			if chars_mobs_npcs[current_mob].control == "ai" then
				--chars_mobs_npcs[current_mob].rt = chars_mobs_npcs[current_mob].rt - 100;
				--print("path not found");
				damage.RTminus(current_mob,100,false);
				game_status="restoring";
			end;
		end;
	end;
	redraw_path = 1;
	return way_of_the_mob;
end;

function findAltWayToHex(x,y)
	local newx = nil;
	local newy = nil;
	local rings = boomareas.smallRingArea(x,y);
	if global.wheeled == 0 then
		atk_direction = helpers.bestAttackDirection (current_mob,x,y);
		chars_mobs_npcs[current_mob].rot = helpers.antiDirection(atk_direction);
	end;
	newx = rings[atk_direction].x;
	newy = rings[atk_direction].y;
	counter = 1;
	if not helpers.isAimOnMob (rings[atk_direction].x,rings[atk_direction].y) and helpers.passCheck(rings[atk_direction].x,rings[atk_direction].y) then
		newx = rings[atk_direction].x;
		newy = rings[atk_direction].y;
		path_can_be_found = 1;
		return newx,newy;	
	end;
	while (helpers.isAimOnMob (rings[atk_direction].x,rings[atk_direction].y) or not helpers.passCheck(rings[atk_direction].x,rings[atk_direction].y)) do
		atk_direction = atk_direction+1;
		if atk_direction > 6 then
			atk_direction = 1;
		end;
		if not helpers.isAimOnMob (rings[atk_direction].x,rings[atk_direction].y) and helpers.passCheck(rings[atk_direction].x,rings[atk_direction].y) then
			newx = rings[atk_direction].x;
			newy = rings[atk_direction].y;
			path_can_be_found = 1;
			return newx,newy;
		end;
		counter=counter+1;
		if counter >= 6 then
			path_status = 0;
			path_print = "path not found (char)!";
			global.hang = false;
			damage.RTminus(current_mob,100,false);
			game_status = "restoring";
			print ("alt way problem");
			return false,false
		end;
	end;
end;
