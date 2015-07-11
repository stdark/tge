--Fov, LoS, etc
trace = {};

function trace.array_of_darkness ()
	for h=1,100 do
		darkness[h]={};
		for i=1, map_w do
			darkness[h][i]={};
			for z=1, map_h do
				darkness[h][i][z]=2;
			end;
		end;
	end;
end;

function trace.trace_hexes (index,target,hexes_to_sense,mobsAffect,x,y) --Bresenham's line algorithm
	--utils.printDebug("trace hexed called", index)
	if not x or not y then
		if chars_mobs_npcs[current_mob].control == "player" then
			point_x = cursor_world_x;
			point_y = cursor_world_y;
		elseif chars_mobs_npcs[current_mob].control == "ai" then
			if target == false then
				target = 1;
			end;
			point_x = chars_mobs_npcs[target].x;
			point_y = chars_mobs_npcs[target].y;
		end;
	else
		point_x = x;
		point_y = y;
	end;
	shot_line = {};
	local shot_line_one = {};
	local shot_line_two = {};
	local shot_line_tri = {};
	local shot_line_for = {};
	local coff={1,0.7,0.6,0.5};
	--local coff={1,1,1,1};
	for k=1,4 do
		local sense = chars_mobs_npcs[index].sense;
		local start_sight_point_x = chars_mobs_npcs[index].x;
		local start_sight_point_y = chars_mobs_npcs[index].y;
		local trace_to_hex = {};
		local vpoint_world_x = 0;
		local vpoint_world_y = 0;
		local delta_x = 0;
		local delta_y = 0;
		local error = 0;
		local spoint_x = 0;
		local spoint_y = 0;
		for i=1,#hexes_to_sense do--LoS
			local vpoint_world_x=all_ground_hexes[hexes_to_sense[i][1]].x;
			local vpoint_world_y=all_ground_hexes[hexes_to_sense[i][1]].y;
			local delta_x = math.abs(vpoint_world_x - chars_mobs_npcs[index].x);
			local delta_y = math.abs(vpoint_world_y - chars_mobs_npcs[index].y)*coff[k];
			local error = delta_x-delta_y;
			if chars_mobs_npcs[index].x > vpoint_world_x then
				sign_x = -1;
			elseif chars_mobs_npcs[index].x < vpoint_world_x then
				sign_x=1;
			end;
			if chars_mobs_npcs[index].y > vpoint_world_y then
				sign_y=-1;
			elseif chars_mobs_npcs[index].y < vpoint_world_y then
				sign_y=1; 
			end;
			if chars_mobs_npcs[index].x == vpoint_world_x then
				sign_x=0;
			end;
			if chars_mobs_npcs[index].y == vpoint_world_y then
				sign_y=0;
			end;
			if chars_mobs_npcs[index].x==vpoint_world_x then
				sign_x=0;
			end;
			if chars_mobs_npcs[index].y==vpoint_world_y then
				sign_y=0;
			end;
			spoint_x = chars_mobs_npcs[index].x;
			spoint_y = chars_mobs_npcs[index].y;
			delta = math.ceil(math.sqrt(delta_x^2+(delta_y)^2));
			untraceable = 0;
			while(spoint_x ~= vpoint_world_x or spoint_y ~= vpoint_world_y) and (spoint_x > 1 and spoint_y > 1) and spoint_x<map_w and spoint_y<map_h do
				error2 = error*2;
				moved=0;
				if error2 > -2*delta_y then
					if  sign_y == 0 then
						error = error-delta_y;
						spoint_x = spoint_x+sign_x;
						moved = 1;
					elseif spoint_y/2 ~= math.ceil(spoint_y/2) and sign_x > 0 then
						error = error-delta_y;
						spoint_x = spoint_x+sign_x;
						moved = 1;         
					elseif spoint_y/2 == math.ceil(spoint_y/2) and sign_x < 0 then
						error = error-delta_y;
						spoint_x = spoint_x+sign_x;
						moved = 1;
					elseif math.abs(spoint_x-vpoint_world_x) == 1 and math.abs(spoint_y-vpoint_world_y) == 0 then
						error = error-delta_y;
						spoint_x = spoint_x+sign_x;
						moved = 1;
					elseif  spoint_y/2==math.ceil(spoint_y/2) and sign_x>0 and math.abs(spoint_y-vpoint_world_y)==0 then
						error = error-delta_y;
						spoint_x = spoint_x+sign_x;
						moved = 1;
					end;
				end;
				if error2 < delta_x or moved==0 then
					error = error + delta_x;
					spoint_y = spoint_y + sign_y;
				end; 
				local id_of_hex = (spoint_x-1)*map_w+spoint_y;
				
				if math.sqrt((all_ground_hexes[id_of_hex].x-chars_mobs_npcs[index].x)^2+(all_ground_hexes[id_of_hex].y-chars_mobs_npcs[index].y)^2) > chars_mobs_npcs[index].sense then
					break;
				end;
				local at_door,trash,trash = helpers.cursorAtClosedDoor(spoint_x,spoint_y);
				if at_door then
					if chars_mobs_npcs[index].control == "player" then
						darkness[chars_mobs_npcs[index].party][all_ground_hexes[id_of_hex].y ][all_ground_hexes[id_of_hex].x ] = 0;
					elseif chars_mobs_npcs[index].control == "ai" then
						darkness[chars_mobs_npcs[index].party][all_ground_hexes[id_of_hex].y ][all_ground_hexes[id_of_hex].x ] = 0;
					end;
					break;
				end;
				if all_ground_hexes[id_of_hex].visibility == 1 then
					if untraceable == 0 then
						if chars_mobs_npcs[index].control == "player" then
							darkness[chars_mobs_npcs[index].party][all_ground_hexes[id_of_hex].y ][all_ground_hexes[id_of_hex].x ] = 0; --objects
							if buildings_table[all_ground_hexes[id_of_hex].y][all_ground_hexes[id_of_hex].x] ~= 0 then
								darkness[chars_mobs_npcs[index].party][buildings_table[all_ground_hexes[id_of_hex].y][all_ground_hexes[id_of_hex].x][1]][buildings_table[all_ground_hexes[id_of_hex].y][all_ground_hexes[id_of_hex].x][2]] = 0;	
							end;
						elseif chars_mobs_npcs[index].control == "ai" then
							darkness[chars_mobs_npcs[index].party][all_ground_hexes[id_of_hex].y ][all_ground_hexes[id_of_hex].x ] = 0;
						end;
						break; --causes uncompleted shot_line
					end;
					untraceable = 1;
					hexes_to_sense[i][2] = 1;
				end;
			
	--for shrapmetal and direct --fixme
				local mob_at_los=0
				for k=1,#chars_mobs_npcs do
					if all_ground_hexes[id_of_hex].x == chars_mobs_npcs[k].x and all_ground_hexes[id_of_hex].y == chars_mobs_npcs[k].y and chars_mobs_npcs[k].status == 1 then 
						mob_at_los = 1;
						if mobsAffect then
							break;
						end;
					end;
				end;
	--/for shrapmetal and direct
				--if all_ground_hexes[id_of_hex].visibility == 0 then
					if chars_mobs_npcs[index].control == "player" then
						darkness[chars_mobs_npcs[index].party][all_ground_hexes[id_of_hex].y ][all_ground_hexes[id_of_hex].x ] = 0; --hexes
					elseif chars_mobs_npcs[index].control == "ai" then
						darkness[chars_mobs_npcs[index].party][all_ground_hexes[id_of_hex].y ][all_ground_hexes[id_of_hex].x ] = 0;
					end;
				--end;
				
				table.insert(trace_to_hex,{spoint_x,spoint_y,untraceable}); -- Why?!
				if vpoint_world_x == point_x and vpoint_world_y == point_y and untraceable == 0 then
					if k ==1 then
						table.insert(shot_line_one,{spoint_x,spoint_y});--line of shooting
					elseif k == 2 then
						table.insert(shot_line_two,{spoint_x,spoint_y});
					elseif k == 3 then
						table.insert(shot_line_tri,{spoint_x,spoint_y});
					elseif k == 4 then
						table.insert(shot_line_for,{spoint_x,spoint_y});
					end;
				end;
				if mob_at_los == 1 and game_status == "sensing" and mobsAffect and (missle_type == "shrapmetal" or missle_type == "bolt" or missle_type == "arrow" or missle_type == "throwing" or missle_type == "bullet" or magic.spell_tips[missle_type].form == "arrow" or magic.spell_tips[missle_type].form == "ball") then
					break;
				end;
			end;
		end; -- of LoS
	end; -- end of duplication
	if #shot_line_one > 0 and shot_line_one[#shot_line_one][1] == point_x and shot_line_one[#shot_line_one][2] == point_y then
		shot_line = shot_line_one;
	elseif #shot_line_two > 0 and shot_line_two[#shot_line_two][1] == point_x and shot_line_two[#shot_line_two][2] == point_y then
		shot_line = shot_line_two;
	elseif #shot_line_tri > 0 and shot_line_tri[#shot_line_tri][1] == point_x and shot_line_tri[#shot_line_tri][2] == point_y then
		shot_line = shot_line_tri;
	elseif #shot_line_for > 0 and shot_line_for[#shot_line_for][1] == point_x and shot_line_for[#shot_line_for][2] == point_y then
		shot_line = shot_line_for;
	elseif #shot_line_one <= #shot_line_two and #shot_line_one <= #shot_line_tri and #shot_line_one <= #shot_line_for then
		shot_line = shot_line_one;
	elseif #shot_line_two <= #shot_line_one and #shot_line_two <= #shot_line_tri and #shot_line_two <= #shot_line_for then
		shot_line = shot_line_two;
	elseif #shot_line_tri <= #shot_line_one and #shot_line_tri <= #shot_line_two and #shot_line_tri <= #shot_line_for then
		shot_line = shot_line_tri;
	else
		shot_line = shot_line_for;
	end;
	trace.clear_rounded();
	return shot_line;
end;

function trace.clear_rounded ()
	local darkness_temp ={};
	darkness_temp = darkness[chars_mobs_npcs[current_mob].party];
	local notinshadow = 0;
	for a=1,map_w do
		for b=1,map_h do
			if darkness_temp[b][a] == 2 and a > 1 and a < (map_w-1) and b > 1 and b < (map_h-1) then
				notinshadow = 1;
				for j=1,6 do
					if b/2 == math.ceil(b/2) then
						if darkness_temp[b+directions[1].xc[j]][a+directions[1].y[j]] == 2 then
							notinshadow = 0;
						end;
					else
						if darkness_temp[b+directions[1].xn[j]][a+directions[1].y[j]] == 2 then
							notinshadow = 0;
						end;
					end;
				end;
				if notinshadow == 1 then
					darkness_temp[b][a] = 0;
				end;
			end;
			if darkness_temp[b][a] == 1 and a > 1 and a < (map_w-1) and b > 1 and b < (map_h-1) then
				notinshadow = 1;
				for j=1,6 do
					if b/2 == math.ceil(b/2) then
						if darkness_temp[b+directions[1].xc[j]][a+directions[1].y[j]] ~= 0 then
							notinshadow = 0;
						end;
					else
						if darkness_temp[b+directions[1].xn[j]][a+directions[1].y[j]] ~= 0 then
							notinshadow = 0;
							end;
					end;
				end;
				if notinshadow == 1 and heights_table[map[b][a]] ~= 0 then
					darkness_temp[b][a] = 0;
				end;
			end;
		end;
	end;
end;


function trace.chars_around ()
	for i = 1, #chars_mobs_npcs do
		trace.one_around (i)
	end;
end;

function trace.one_around (index)
	if chars_mobs_npcs[index].status == 1 then
		if chars_mobs_npcs[index].control == "player" then
			darkness[chars_mobs_npcs[index].party][chars_mobs_npcs[index].y][chars_mobs_npcs[index].x] = 0;
		elseif chars_mobs_npcs[index].control == "ai" then
			darkness[chars_mobs_npcs[index].party][chars_mobs_npcs[index].y][chars_mobs_npcs[index].x] = 0;
		end;
		local ring = boomareas.smallRingArea (chars_mobs_npcs[index].x,chars_mobs_npcs[index].y);
		for i = 1,#ring do
			if chars_mobs_npcs[index].control == "player" and chars_mobs_npcs[index].status == 1 and chars_mobs_npcs[index].stone == 0 then
				darkness[chars_mobs_npcs[index].party][ring[i].y][ring[i].x] = 0;
			elseif chars_mobs_npcs[index].control == "ai" and chars_mobs_npcs[index].ai ~= "building" and chars_mobs_npcs[index].status == 1 and chars_mobs_npcs[index].stone == 0 then
				darkness[chars_mobs_npcs[index].party][chars_mobs_npcs[index].y][chars_mobs_npcs[index].x] = 0;
			end;
		end;
	end;
end;

function trace.first_watch (index)
	darkness[chars_mobs_npcs[index].party][chars_mobs_npcs[index].y][chars_mobs_npcs[index].x] = 0;
	if chars_mobs_npcs[index].status == 1 then
		if chars_mobs_npcs[index].control == "player" then
			local temp_array = trace.trace_hexes(index,false,trace.sightArray (index),false);
		end;
		if chars_mobs_npcs[index].control == "ai" and  chars_mobs_npcs[index].ai ~= "building" then
			trace.trace_hexes(index,false,trace.sightArray (index));
		end;
	end;
end;

function trace.wizardEye ()
	for my=1, math.min(map_display_h+4, map_h-map_y) do
		for mx=1, math.min(map_display_w+4, map_w-map_x) do		
			if wlandscape[mx][my] > 0 then
				darkness[1][mx][my] = 0;
				local rings = boomareas.ringArea(mx,my);
				for h=1,3 do
					for i=1,#rings[h] do
						darkness[chars_mobs_npcs[1].party][rings[h][i].x][rings[h][i].y] = 0;
					end;
				end;
			end
		end;
	end;
end;

function trace.lookaround (index)
	--utils.printDebug("lookaround called");
	if game_status == "neutral" then
		trace.wizardEye ();
	end;
	if chars_mobs_npcs[index].control == "player" then
		helpers.cam_to_mob ();
		trace.first_watch (index);
		trace.chars_around();
		trace.clear_rounded ();
	end;
	if chars_mobs_npcs[index].control == "ai" then
		if darkness[chars_mobs_npcs[index].party][chars_mobs_npcs[index].x][chars_mobs_npcs[index].y] == 0 then
			helpers.cam_to_mob ();
		end;
		trace.first_watch (index);
		trace.chars_around ();
	end;
end;

function trace.sightArray (index)
	local hexes_to_sense = {};
	local hexes_in_fov = {};
	local hexes_by_trauma = {};
	for l=1,#all_ground_hexes do
		if math.sqrt((all_ground_hexes[l].x-chars_mobs_npcs[index].x)^2+(all_ground_hexes[l].y-chars_mobs_npcs[index].y)^2) <= chars_mobs_npcs[index].sense then
			if chars_mobs_npcs[index].fov == 180 then
				if point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y < chars_mobs_npcs[index].y then
					chars_mobs_npcs[index].view = 8; --look straight up
				elseif point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y > chars_mobs_npcs[index].y then
					chars_mobs_npcs[index].view = 7; --look straight down
				elseif point_to_go_x ~= chars_mobs_npcs[index].x then
					chars_mobs_npcs[index].view = chars_mobs_npcs[index].rot; --standart
				end;
				if chars_mobs_npcs[index].view == 2 and all_ground_hexes[l].x >= chars_mobs_npcs[index].x then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 5 and all_ground_hexes[l].x <= chars_mobs_npcs[index].x then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 3 and (all_ground_hexes[l].x+all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x+chars_mobs_npcs[index].y) then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 6 and (all_ground_hexes[l].x+all_ground_hexes[l].y) <= (chars_mobs_npcs[index].x+chars_mobs_npcs[index].y) then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 4 and (all_ground_hexes[l].x-all_ground_hexes[l].y) <= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 1 and (all_ground_hexes[l].x-all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 7 and all_ground_hexes[l].y >= chars_mobs_npcs[index].y then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 8 and all_ground_hexes[l].y <= chars_mobs_npcs[index].y then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				end;
			elseif chars_mobs_npcs[index].fov == 90 then
				if point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y < chars_mobs_npcs[index].y then
					chars_mobs_npcs[index].view = 8; --look straight up
				elseif point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y > chars_mobs_npcs[index].y then
					chars_mobs_npcs[index].view = 7; --look straight down
				elseif point_to_go_x ~= chars_mobs_npcs[index].x then
					chars_mobs_npcs[index].view = chars_mobs_npcs[index].rot; --standart
				end;
				if chars_mobs_npcs[index].view == 2 and all_ground_hexes[l].x >= chars_mobs_npcs[index].x and (all_ground_hexes[l].x-chars_mobs_npcs[index].x)-(all_ground_hexes[l].y-chars_mobs_npcs[index].y) >= 0 and (all_ground_hexes[l].x-chars_mobs_npcs[index].x)-(-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y) >= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 5 and all_ground_hexes[l].x <= chars_mobs_npcs[index].x  and (-1*all_ground_hexes[l].x+chars_mobs_npcs[index].x)-(all_ground_hexes[l].y-chars_mobs_npcs[index].y) >= 0 and (-1*all_ground_hexes[l].x+chars_mobs_npcs[index].x)-(-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y) >= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 3 and (all_ground_hexes[l].x+all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x+chars_mobs_npcs[index].y) and (all_ground_hexes[l].x - chars_mobs_npcs[index].x) >= 0 and (all_ground_hexes[l].y - chars_mobs_npcs[index].y) >= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 6 and (all_ground_hexes[l].x-all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) and (all_ground_hexes[l].x - chars_mobs_npcs[index].x) <= 0 and (all_ground_hexes[l].y - chars_mobs_npcs[index].y) <= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 4 and (all_ground_hexes[l].x-all_ground_hexes[l].y) <= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) and (all_ground_hexes[l].x - chars_mobs_npcs[index].x) <= 0 and (all_ground_hexes[l].y - chars_mobs_npcs[index].y) >= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 1 and (all_ground_hexes[l].x-all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) and (all_ground_hexes[l].x - chars_mobs_npcs[index].x) >= 0 and (all_ground_hexes[l].y - chars_mobs_npcs[index].y) <= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 7 and all_ground_hexes[l].y >= chars_mobs_npcs[index].y and (all_ground_hexes[l].x-chars_mobs_npcs[index].x)-(all_ground_hexes[l].y-chars_mobs_npcs[index].y) <= 0 and (-1*all_ground_hexes[l].x+chars_mobs_npcs[index].x)-(all_ground_hexes[l].y-chars_mobs_npcs[index].y) <= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 8 and all_ground_hexes[l].y <= chars_mobs_npcs[index].y and (all_ground_hexes[l].x-chars_mobs_npcs[index].x)-(-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y) <= 0 and (-1*all_ground_hexes[l].x+chars_mobs_npcs[index].x)-(-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y) <= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				end;
			elseif chars_mobs_npcs[index].fov == 360 then
				table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
			end;
		end;
	end;
	for l=1,#all_ground_hexes do --FIXME this works only vs. creatures with 1/2 eyes, remember of hydras, chimeras, adau, ooz, medusas (snakes)
		if math.sqrt((all_ground_hexes[l].x-chars_mobs_npcs[index].x)^2+(all_ground_hexes[l].y-chars_mobs_npcs[index].y)^2) <= chars_mobs_npcs[index].sense then	
			if chars_mobs_npcs[index].leye and chars_mobs_npcs[index].leye == 0 then -- left eye blinded
				if point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y < chars_mobs_npcs[index].y then
					chars_mobs_npcs[index].view = 8; --look straight up
				elseif point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y > chars_mobs_npcs[index].y then
					chars_mobs_npcs[index].view = 7; --look straight down
				elseif point_to_go_x ~= chars_mobs_npcs[index].x then
					chars_mobs_npcs[index].view = chars_mobs_npcs[index].rot; --standart
				end;
				if chars_mobs_npcs[index].view == 2 and all_ground_hexes[l].x >= chars_mobs_npcs[index].x and all_ground_hexes[l].y-chars_mobs_npcs[index].y >= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 5 and all_ground_hexes[l].x <= chars_mobs_npcs[index].x and all_ground_hexes[l].y-chars_mobs_npcs[index].y >= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 3 and (all_ground_hexes[l].x+all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x+chars_mobs_npcs[index].y) and all_ground_hexes[l].x-chars_mobs_npcs[index].x+-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y <= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 6 and (all_ground_hexes[l].x+all_ground_hexes[l].y) <= (chars_mobs_npcs[index].x+chars_mobs_npcs[index].y) and all_ground_hexes[l].x-chars_mobs_npcs[index].x+-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y <= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 4 and (all_ground_hexes[l].x-all_ground_hexes[l].y) <= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) and -1*all_ground_hexes[l].x+chars_mobs_npcs[index].x+-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y <= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 1 and (all_ground_hexes[l].x-all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) and all_ground_hexes[l].x-chars_mobs_npcs[index].x+all_ground_hexes[l].y-chars_mobs_npcs[index].y >= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 7 and all_ground_hexes[l].y >= chars_mobs_npcs[index].y and all_ground_hexes[l].x-chars_mobs_npcs[index].x <= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 8 and all_ground_hexes[l].y <= chars_mobs_npcs[index].y and all_ground_hexes[l].x-chars_mobs_npcs[index].x <= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				end;
			end;
			
			if chars_mobs_npcs[index].reye and chars_mobs_npcs[index].reye == 0 then -- right eye blinded
				if point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y < chars_mobs_npcs[index].y then
					chars_mobs_npcs[index].view = 8; --look straight up
				elseif point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y > chars_mobs_npcs[index].y then
					chars_mobs_npcs[index].view = 7; --look straight down
				elseif point_to_go_x ~= chars_mobs_npcs[index].x then
					chars_mobs_npcs[index].view = chars_mobs_npcs[index].rot; --standart
				end;
				if chars_mobs_npcs[index].view == 2 and all_ground_hexes[l].x >= chars_mobs_npcs[index].x and all_ground_hexes[l].y-chars_mobs_npcs[index].y <= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 5 and all_ground_hexes[l].x <= chars_mobs_npcs[index].x and all_ground_hexes[l].y-chars_mobs_npcs[index].y <= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 3 and (all_ground_hexes[l].x+all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x+chars_mobs_npcs[index].y) and all_ground_hexes[l].x-chars_mobs_npcs[index].x+-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y >= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 6 and (all_ground_hexes[l].x+all_ground_hexes[l].y) <= (chars_mobs_npcs[index].x+chars_mobs_npcs[index].y) and all_ground_hexes[l].x-chars_mobs_npcs[index].x+-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y >= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 4 and (all_ground_hexes[l].x-all_ground_hexes[l].y) <= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) and -1*all_ground_hexes[l].x+chars_mobs_npcs[index].x+-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y >= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 1 and (all_ground_hexes[l].x-all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) and all_ground_hexes[l].x-chars_mobs_npcs[index].x+all_ground_hexes[l].y-chars_mobs_npcs[index].y <= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 7 and all_ground_hexes[l].y >= chars_mobs_npcs[index].y and all_ground_hexes[l].x-chars_mobs_npcs[index].x >= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 8 and all_ground_hexes[l].y <= chars_mobs_npcs[index].y and all_ground_hexes[l].x-chars_mobs_npcs[index].x >= 0 then
					table.insert(hexes_by_trauma, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				end;
			end;
			
			if chars_mobs_npcs[index].ceye and chars_mobs_npcs[index].ceye == 0 then -- central eye blinded
				if point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y < chars_mobs_npcs[index].y then
					chars_mobs_npcs[index].view = 8; --look straight up
				elseif point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y > chars_mobs_npcs[index].y then
					chars_mobs_npcs[index].view = 7; --look straight down
				elseif point_to_go_x ~= chars_mobs_npcs[index].x then
					chars_mobs_npcs[index].view = chars_mobs_npcs[index].rot; --standart
				end;
				if chars_mobs_npcs[index].view == 2 and all_ground_hexes[l].x >= chars_mobs_npcs[index].x and (all_ground_hexes[l].x-chars_mobs_npcs[index].x)-(all_ground_hexes[l].y-chars_mobs_npcs[index].y) >= 0 and (all_ground_hexes[l].x-chars_mobs_npcs[index].x)-(-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y) >= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 5 and all_ground_hexes[l].x <= chars_mobs_npcs[index].x  and (-1*all_ground_hexes[l].x+chars_mobs_npcs[index].x)-(all_ground_hexes[l].y-chars_mobs_npcs[index].y) >= 0 and (-1*all_ground_hexes[l].x+chars_mobs_npcs[index].x)-(-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y) >= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 3 and (all_ground_hexes[l].x+all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x+chars_mobs_npcs[index].y) and (all_ground_hexes[l].x - chars_mobs_npcs[index].x) >= 0 and (all_ground_hexes[l].y - chars_mobs_npcs[index].y) >= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 6 and (all_ground_hexes[l].x-all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) and (all_ground_hexes[l].x - chars_mobs_npcs[index].x) <= 0 and (all_ground_hexes[l].y - chars_mobs_npcs[index].y) <= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 4 and (all_ground_hexes[l].x-all_ground_hexes[l].y) <= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) and (all_ground_hexes[l].x - chars_mobs_npcs[index].x) <= 0 and (all_ground_hexes[l].y - chars_mobs_npcs[index].y) >= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 1 and (all_ground_hexes[l].x-all_ground_hexes[l].y) >= (chars_mobs_npcs[index].x-chars_mobs_npcs[index].y) and (all_ground_hexes[l].x - chars_mobs_npcs[index].x) >= 0 and (all_ground_hexes[l].y - chars_mobs_npcs[index].y) <= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 7 and all_ground_hexes[l].y >= chars_mobs_npcs[index].y and (all_ground_hexes[l].x-chars_mobs_npcs[index].x)-(all_ground_hexes[l].y-chars_mobs_npcs[index].y) <= 0 and (-1*all_ground_hexes[l].x+chars_mobs_npcs[index].x)-(all_ground_hexes[l].y-chars_mobs_npcs[index].y) <= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				elseif chars_mobs_npcs[index].view == 8 and all_ground_hexes[l].y <= chars_mobs_npcs[index].y and (all_ground_hexes[l].x-chars_mobs_npcs[index].x)-(-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y) <= 0 and (-1*all_ground_hexes[l].x+chars_mobs_npcs[index].x)-(-1*all_ground_hexes[l].y+chars_mobs_npcs[index].y) <= 0 then
					table.insert(hexes_in_fov, {all_ground_hexes[l].id,all_ground_hexes[l].visibility});
				end;
			end;
			
		end;
	end;
	if (chars_mobs_npcs[index].reye and chars_mobs_npcs[index].leye and chars_mobs_npcs[index].leye == 1 and chars_mobs_npcs[index].reye == 1) or (chars_mobs_npcs[index].ceye == 1 and chars_mobs_npcs[index].ceye == 1) or chars_mobs_npcs[index].fov == 360 then
		for i=1,#hexes_in_fov do
			hexes_to_sense[i] = hexes_in_fov[i];
		end;
	elseif chars_mobs_npcs[index].leye == 0 or chars_mobs_npcs[index].reye == 0 then
		local j = 1;
		for i=1,#hexes_in_fov do
			for h=1,#hexes_by_trauma do
				if hexes_in_fov[i][1] == hexes_by_trauma[h][1] then
					hexes_to_sense[j] = hexes_in_fov[i];
					j = j+1;
				end;
			end;
		end;
	end;
	return hexes_to_sense;
end;

function trace.trace_for_boom (hexes_to_sense,passing)
	local traced_hexes = {};
	if not global.traced_for_boom or global.rem_cursor_world_x ~= cursor_world_x or global.rem_cursor_world_y ~= cursor_world_y or chars_mobs_npcs[current_mob].control == "ai" then
		local mobsAffect = true;
		if passing then
			mobsAffect = false;
		end;
		local temp = {};
		for i=1,#hexes_to_sense do
			temp = trace.trace_hexes(current_mob,false,hexes_to_sense,mobsAffect,all_ground_hexes[hexes_to_sense[i][1] ].x,all_ground_hexes[hexes_to_sense[i][1] ].y);
			for h=1,#temp do
				local add = true;
				for j=1,#traced_hexes do
					if traced_hexes[j].x == temp[h][1] and traced_hexes[j].y == temp[h][2] then
						add = false
					end;
				end;
				if add then
					table.insert(traced_hexes,{x=temp[h][1],y=temp[h][2]});
				end;
			end;
		end;
		global.traced_for_boom = traced_hexes;
	else
		traced_hexes = global.traced_for_boom;
	end;
	return traced_hexes;
end;

function trace.all_to_darkness()
	for h=1,100 do
		for i=1, map_w do
			for z=1, map_h do
				if darkness[h][i][z] == 0 then
					darkness[h][i][z] = 1;
				end;
			end;
		end;
	end;
end;

function trace.arrowStatus(index)
	local arrow_status = false;
	local hexes_to_sense = trace.sightArray(index);
	local point_x = 1;
	local point_x = 1;
	if chars_mobs_npcs[current_mob].control == "player" then
		point_x = cursor_world_x;
		point_y = cursor_world_y;
	elseif chars_mobs_npcs[current_mob].control == "ai" then
		point_x = chars_mobs_npcs[index].x;
		point_y = chars_mobs_npcs[index].y;
	end;
	for i=1,#hexes_to_sense do
		if all_ground_hexes[hexes_to_sense[i][1]].x == point_x and all_ground_hexes[hexes_to_sense[i][1]].y == point_y and hexes_to_sense[i][2] == 0 then
			arrow_status = true;
		end;
		if all_ground_hexes[hexes_to_sense[i][1]].x == point_x	and all_ground_hexes[hexes_to_sense[i][1]].y == point_y and hexes_to_sense[i][2] == 1 then
			arrow_status = false;
		end;
	end;
	local hypo = math.floor(math.sqrt(math.abs(point_x-chars_mobs_npcs[current_mob].x)^2+math.abs(point_y-chars_mobs_npcs[current_mob].y)^2));	
	if #shot_line > 0 and #shot_line < hypo then
		arrow_status = false;
	end;
	if #shot_line > 0 then
		if shot_line[#shot_line][1] ~= point_x or shot_line[#shot_line][2] ~= point_y then
			arrow_status = false;
		end;
	end;
  -- FIX for penetrating spells!!!
	for k=1,(#shot_line-1) do
		for l=1,#chars_mobs_npcs do
			if chars_mobs_npcs[l].x == shot_line[k][1] and chars_mobs_npcs[l].y == shot_line[k][2] and chars_mobs_npcs[l].status == 1 then
				arrow_status = false;
			end;
		end;
	end;
	return arrow_status;
end;
