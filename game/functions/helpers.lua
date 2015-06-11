helpers = {};


function helpers.passMove (x,y,index)
	if not helpers.insideMap(x,y) then
		return false;
	end;	
	local passable = false;
	if chars_mobs_npcs[index].wingsoflight > 0 then
		passable = helpers.passFly (x,y);
	elseif chars_mobs_npcs[index].waterwalking > 0 then
		passable = helpers.passWaterWalk (x,y);
	elseif chars_mobs_npcs[index].levitation > 0 then
		passable = helpers.passLev (x,y);
	else
		passable = helpers.passWalk (x,y);
	end;
	return passable;
end;

function helpers.passCheck (x,y)
	if not helpers.insideMap(x,y) then
		return false;
	end;
	local height_value = 0;
	if map[y][x] < 300 then
		height_value = heights_table[map[y][x]];
	else
		height_value = 2;
	end;
	if helpers.insideMap(x,y) and height_value <= 0 and helpers.voidIsNotaProblem(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,x,y) and map[y][x] < 300 and not helpers.cursorAtObject(x,y) and not helpers.cursorAtChest(x,y) and not helpers.cursorAtClosedDoor(x,y) then
		return true
	else
		return false
	end;
end;

function helpers.passLev (x,y)
	if not helpers.insideMap(x,y) then
		return false;
	end;
	local height_value = 0;
	if map[y][x] < 300 and not helpers.cursorAtObject(x,y) and not helpers.cursorAtClosedDoor(x,y) then
		height_value = heights_table[map[y][x]];
	else
		height_value = 2;
	end;
	if helpers.insideMap(x,y) and height_value <= 1 then
		return true
	else
		return false
	end;
end;

function helpers.passJump (x,y)
	if not helpers.insideMap(x,y) then
		return false;
	end;
	local height_value = 0;
	if map[y][x] < 300 then
		height_value = heights_table[map[y][x]];
	else
		height_value = 2;
	end;
	if helpers.insideMap(x,y) and height_value < 2 and helpers.voidIsNotaProblem(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,x,y) and not helpers.cursorAtClosedDoor(x,y) then
		return true
	else
		return false
	end;
end;

function helpers.passFly (x,y)
	if not helpers.insideMap(x,y) then
		return false;
	end;
	local height_value = 0;
	if map[y][x] < 300 then
		height_value = heights_table[map[y][x]];
	else
		height_value = 2;
	end;
	if helpers.insideMap(x,y) and height_value <= 2 and helpers.voidIsNotaProblem(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,x,y) and not helpers.cursorAtClosedDoor(x,y) then
		return true
	else
		return false
	end;
end;

function helpers.insideMap(x,y)
	if x <= map_w and x > 0 and y <= map_h and y > 0 then
		return true
	else
		return false
	end;
end;

function helpers.passWaterWalk (x,y)
	if not map[y][x] then
		return false;
	end;
	if helpers.insideMap(y,x) and heights_table[map[y][x] ] <= 0 and hex_type[map[y][x] ] == "water" and not helpers.cursorAtClosedDoor(x,y) then
		return true
	else
		return false
	end;
end;

function helpers.passWalk (x,y)
	if not helpers.insideMap(x,y) then
		return false;
	end;
	local height_value = 0;
	if map[y][x] < 300 and not helpers.cursorAtObject(x,y) and not helpers.cursorAtClosedDoor(x,y) then
		height_value = heights_table[map[y][x]];
	else
		height_value = 2;
	end;
	if helpers.insideMap(x,y) and height_value == 0 and helpers.voidIsNotaProblem(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,x,y) then
		return true
	else
		return false
	end;
end;

function whatNpcsAreNear (x,y)
	if not helpers.insideMap(x,y) then
		return false;
	end;
	local rings = boomareas.ringArea(x,y);
	local npcs_near ={};
	for i=1,6 do
		for j=chars,#chars_mobs_npcs do
			if chars_mobs_npcs[j].x == rings[1][i].x and chars_mobs_npcs[j].y == rings[1][i].y and chars_mobs_npcs[j].person == "npc" and chars_mobs_npcs[j].control == "ai" then
				table.insert(npcs_near,j);
			end;
		end;
	end;
	return npcs_near;
end;

function helpers.ifMobIsNear (watcher,index)
	local rings = boomareas.smallRingArea(chars_mobs_npcs[index].x,chars_mobs_npcs[index].y);
	for i=1,6 do
		if chars_mobs_npcs[watcher].x == rings[i].x and chars_mobs_npcs[watcher].y == rings[i].y then
			return true;
		end;
	end;
	return false;
end;

function helpers.hexToPixels (x,y)
	moveto_hex_y = math.ceil((y-1-map_y)*tile_h*0.75+top_space);
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2-map_x)*tile_w+left_space;
	else
		moveto_hex_x = (x-2-map_x)*tile_w+tile_w/2+left_space;
	end;
	return moveto_hex_x, moveto_hex_y;
end;

function helpers.rockCoords (x,y) -- copy of previous, mb some adds ll be
	moveto_hex_y = math.ceil((y-1-map_y)*tile_h*0.75+top_space);
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2-map_x)*tile_w+left_space;
	else
		moveto_hex_x = (x-2-map_x)*tile_w+tile_w/2+left_space;
	end;
	return moveto_hex_x, moveto_hex_y;
end;

function helpers.antiDirection(somedirection)
	local directionArray = {4,5,6,1,2,3};
	local dir = directionArray[somedirection];
	return dir;
end;

function helpers.mobevenornot (index)
	if chars_mobs_npcs[index].y/2 == math.ceil(chars_mobs_npcs[index].y/2) then
		return true;
	elseif chars_mobs_npcs[index].y/2 ~= math.ceil(chars_mobs_npcs[index].y/2) then
		return false;
	end;
end;

function helpers.cursorIsNear(x1,y1,x2,y2)
	local ring = boomareas.smallRingArea(x1,y1);
	for i=1,#ring do
		if ring.x == x1 and ring.y == y2 then
			return true;
		end;
	end;
	return false;
end;

function helpers.isAimOnMob (x,y) -- false/true
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y then
			aim_on_mob = 1;
			return true;
		else

		end;
	end;
	return false;
end;

 function helpers.ifCursorIsNear ()
	 local mob_even = helpers.mobevenornot(current_mob);
	 if mob_even then
		 for i=1,6 do
			 if (cursor_world_x-chars_mobs_npcs[current_mob].x) == directions[1].xc[i] 
			 and (cursor_world_y-chars_mobs_npcs[current_mob].y) == directions[1].y[i] then
				return true;
			 end;
		 end;
		 elseif not mob_even then
		  for i=1,6 do
			if (cursor_world_x-chars_mobs_npcs[current_mob].x)==directions[1].xn[i]
			and (cursor_world_y-chars_mobs_npcs[current_mob].y)==directions[1].y[i] then
				return true;
			end;
		 end;
	 end;
	 return false;
 end;
 
 function helpers.ifMobAtCordinates (x,y)
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].ai ~= "building" and chars_mobs_npcs[i].status > 0 and chars_mobs_npcs[i].hexes == 1 and x == chars_mobs_npcs[i].x and y == chars_mobs_npcs[i].y then
			return true;
		elseif chars_mobs_npcs[i].ai ~= "building" and  chars_mobs_npcs[i].status > 0 and chars_mobs_npcs[i].hexes == 2 and helpers.mobevenornot(i) and x == chars_mobs_npcs[i].x + directions[1]["xc"][helpers.antiDirection(chars_mobs_npcs[i].rot)] and y == chars_mobs_npcs[i].y + directions[1]["y"][helpers.antiDirection(chars_mobs_npcs[i].rot)] then
			return true;
		elseif chars_mobs_npcs[i].ai ~= "building" and chars_mobs_npcs[i].status > 0  and chars_mobs_npcs[i].hexes == 2 and not helpers.mobevenornot(i) and x == chars_mobs_npcs[i].x + directions[1]["xn"][helpers.antiDirection(chars_mobs_npcs[i].rot)] and y == chars_mobs_npcs[i].y + directions[1]["y"][helpers.antiDirection(chars_mobs_npcs[i].rot)] then
			return true;
		end;
	end;
	return false;
 end;
 
 function helpers.ifDeadMobAtCordinates (x,y)
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].status <= 0 and chars_mobs_npcs[i].hexes == 1 and x == chars_mobs_npcs[i].x and y == chars_mobs_npcs[i].y then
			return true;
		elseif chars_mobs_npcs[i].status <= 0 and chars_mobs_npcs[i].hexes == 2 and helpers.mobevenornot(i) and x == chars_mobs_npcs[i].x + directions[1]["xc"][helpers.antiDirection(chars_mobs_npcs[i].rot)] and y == chars_mobs_npcs[i].y + directions[1]["y"][helpers.antiDirection(chars_mobs_npcs[i].rot)] then
			return true;
		elseif chars_mobs_npcs[i].status <= 0 and chars_mobs_npcs[i].hexes == 2 and not helpers.mobevenornot(i) and x == chars_mobs_npcs[i].x + directions[1]["xn"][helpers.antiDirection(chars_mobs_npcs[i].rot)] and y == chars_mobs_npcs[i].y + directions[1]["y"][helpers.antiDirection(chars_mobs_npcs[i].rot)] then
			return true;
		end;
	end;
	return false;
 end;

function helpers.cursorWorldCoordinates () -- in hexes
	local coordX = 1;
	local coordY = 1;
	local centreX = 0;
	local centreY = 0;
	local deltaX = map_w;
	local deltaY = map_h;
	for h=1, map_h do
		centreY = (h-1-map_y)*tile_h*0.75+top_space+tile_h/2;
		for i=1, map_w do
			if	h/2 == math.ceil(h/2) then
				centreX = (i-1-map_x)*tile_w;
			else
				centreX = (i-1-map_x)*tile_w+tile_w/2;
			end;
			if math.abs(centreY - mY) <= deltaY then
				coordY = h;
				deltaY = math.abs(centreY - mY); 
			end
			local addx = 0;
			if coordY/2 == math.ceil(coordY/2) then
				addx = 32;
			end;
			if math.abs(mX - centreX) <= deltaX +addx then
				coordX = i;
				deltaX = math.abs(mX - centreX);
			end
		end;
	end;
	return coordX,coordY;
end;

function helpers.mindGameCoordinates ()
	local coordX = 5;
	local coordY = 5;
	local centreX = 0;
	local centreY = 0;
	local deltaX = 32;
	local deltaY = 16;
	local x,y = helpers.centerObject(media.images.map);
	local xx = x + 80;
	local yy = y - 50 + 190;
	if mX >= xx and mX <= xx+580 and mY >= yy and mY <= yy+230 then
		for h=1, 9 do
			centreY = (h-1)*tile_h*0.75+yy+tile_h/2;
			for i=1, 9 do
				if	h/2 == math.ceil(h/2) then
					centreX = (i-1)*tile_w+xx;
				else
					centreX = (i-1)*tile_w+tile_w/2+xx;
				end;
				if math.abs(centreY - mY) <= deltaY then
					coordY = h;
				end
				if math.abs(centreX - mX) <= deltaX then
					coordX = i;
					deltaX = math.abs(mX - centreX);
				end
			end;
		end;
	end;
	return coordX,coordY;
end;

--should get skill or missle_type!
function helpers.countBoomNumbers ()
	local lvl = {};
	local num = {};
	if missle_drive == "spellbook" then
		for i = 1,4 do -- 4 schools maximum!
			if magic.spell_tips[missle_type].level[i] > 0 then
				lvl[i] = chars_mobs_npcs[current_mob][magic.spell_tips[missle_type].skill[i]];
				num[i] = chars_mobs_npcs[current_mob][spell_nums[magic.spell_tips[missle_type].skill[i]]];
			end;
		end;
	elseif missle_drive == "scroll" then
		for i =1,4 do
			lvl[i] = math.max(3,magic.spell_tips[missle_type].level[i]);
			num[i] = lvl[i]*5;
			print("levels",lvl[i],num[i])
		end;
	elseif missle_drive == "wand" then
		for i =1,4 do
			print("missle_type",missle_type);
			lvl[i] = math.max(3,magic.spell_tips[missle_type].level[i]);
			num[i] = lvl[i]*5;
		end;
	elseif missle_drive == "alchemy" then
		for i =1,4 do
			lvl[i] = bombpower;
			num[i] = bombpower;
		end;
	elseif missle_drive == "mob" then
	elseif missle_drive == "trap" then
		for i =1,4 do
			lvl[i] = trappower;
			num[i] = trappower;
		end;
	elseif missle_drive == "revenge" then
		for i =1,4 do
			lvl[i] = 3;
			num[i] = 10;
		end;
	end;
	return lvl,num;
end;

function helpers.cursorAtCurrentMob (index,x,y)
	global.hex = 1;
	if chars_mobs_npcs[index].status >= 0 then
		if chars_mobs_npcs[index].x == x and chars_mobs_npcs[index].y == y then
			return true;
		end;
		if chars_mobs_npcs[index].hexes == 2 then
			if chars_mobs_npcs[index].y/2 == math.ceil(hars_mobs_npcs[index].y/2) and x == chars_mobs_npcs[index].x + directions[1]["xc"][helpers.antiDirection(chars_mobs_npcs[index].rot)] and y == chars_mobs_npcs[index].y + directions[1]["y"][helpers.antiDirection(chars_mobs_npcs[index].rot)] then
				global.hex = 2;
				return true;
			elseif chars_mobs_npcs[index].y/2 ~= math.ceil(hars_mobs_npcs[index].y/2) and x == chars_mobs_npcs[index].x + directions[1]["xn"][helpers.antiDirection(chars_mobs_npcs[index].rot)] and y == chars_mobs_npcs[index].y + directions[1]["y"][helpers.antiDirection(chars_mobs_npcs[index].rot)] then
				global.hex = 2;
				return true;
			end
		end;
	end;
	return false;
end;

function helpers.cursorAtMob (x,y)
	global.hex = 1;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].status >= 0 then
			if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y then
				return true;
			end;
			if chars_mobs_npcs[i].hexes == 2 then
				if chars_mobs_npcs[i].y/2 == math.ceil(hars_mobs_npcs[i].y/2) and x == chars_mobs_npcs[i].x + directions[1]["xc"][helpers.antiDirection(chars_mobs_npcs[i].rot)] and y == chars_mobs_npcs[i].y + directions[1]["y"][helpers.antiDirection(chars_mobs_npcs[i].rot)] then
					global.hex = 2;
					return true;
				elseif chars_mobs_npcs[i].y/2 ~= math.ceil(hars_mobs_npcs[i].y/2) and x == chars_mobs_npcs[i].x + directions[1]["xn"][helpers.antiDirection(chars_mobs_npcs[i].rot)] and y == chars_mobs_npcs[i].y + directions[1]["y"][helpers.antiDirection(chars_mobs_npcs[i].rot)] then
					global.hex = 2;
					return true;
				end
			end;
		end;
	end;
	return false;
end;

function helpers.cursorAtMobID (x,y)
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].status >= 0 then
			if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y then
				return i;
			end;
			if chars_mobs_npcs[i].hexes == 2 then
				if chars_mobs_npcs[i].y/2 == math.ceil(hars_mobs_npcs[i].y/2) and x == chars_mobs_npcs[i].x + directions[1]["xc"][helpers.antiDirection(chars_mobs_npcs[i].rot)] and y == chars_mobs_npcs[i].y + directions[1]["y"][helpers.antiDirection(chars_mobs_npcs[i].rot)] then
					return i;
				elseif chars_mobs_npcs[i].y/2 ~= math.ceil(hars_mobs_npcs[i].y/2) and x == chars_mobs_npcs[i].x + directions[1]["xn"][helpers.antiDirection(chars_mobs_npcs[i].rot)] and y == chars_mobs_npcs[i].y + directions[1]["y"][helpers.antiDirection(chars_mobs_npcs[i].rot)] then
					return i;
				end
			end;
		end;
	end;
	return false;
end;

function helpers.cursorAtPartyMember (x,y)
	for i=1,chars do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y  and chars_mobs_npcs[i].status >= 0 then
			return true;
		end;
	end;
	return false;
end;

function helpers.cursorAtDeadPartyMember (x,y)
	for i=1,chars do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y and chars_mobs_npcs[i].status < 0 then
			return true;
		end;
	end;
	return false;
end;

function helpers.cursorAtDeadMob (x,y)
	for i=chars,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y and chars_mobs_npcs[i].status < 0 then
			return true;
		end;
	end;
	return false;
end;

function helpers.cursorAtNotPlayer (x,y)
	for i=5,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y and chars_mobs_npcs[i].status >= 0 then
			return true;
		end;
	end;
	return false;
end

function helpers.cursorAtEnemy (x,y)
	for i=5,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y and chars_mobs_npcs[i].status >= 0 and not ai.friendOrFoe (current_mob,i) then
			return true;
		end;
	end;
	return false;
end;

function helpers.cursorAtNPC (x,y)
	for i=5,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y and chars_mobs_npcs[i].status >= 0 and chars_mobs_npcs[i].person == "npc" then
			return true;
		end;
	end;
	return false;
end;

function helpers.cursorAtDeadEnemy (x,y)
	for i=5,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y and chars_mobs_npcs[i].status < 0 then
			return true;
		end;
	end;
	return false;
end;

function helpers.ifMobIsCastable (mob)
	if mob.freeze == 0 and mob.stone == 0 then
		return true;
	else
		return false;
	end;
end;

function helpers.mobIsAlive (mob)
	if mob.status == 1 then
		return true;
	else
		return false;
	end;
end;

function helpers.cursorAtMobControl (x,y)
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y and chars_mobs_npcs[i].status == 1 then
			return chars_mobs_npcs[i].control;
		end;
	end;
	return "none";
end;

function helpers.mobCanDefendHimself (index)
	if chars_mobs_npcs[index].status ~= 1 then
		return false;
	end;
	if chars_mobs_npcs[index].sleep > 0 then
		return false;
	end;
	if chars_mobs_npcs[index].stun > 0 then
		return false;
	end;
	if chars_mobs_npcs[index].paralyze > 0 then
		return false;
	end;
	if chars_mobs_npcs[index].freeze > 0 then
		return false;
	end;
	if chars_mobs_npcs[index].stone > 0 then
		return false;
	end;
	if chars_mobs_npcs[index].rt <= 5 then
		return false;
	end;
	if chars_mobs_npcs[index].rage > 0 then
		return false;
	end;
	if chars_mobs_npcs[index].berserk > 0 then
		return false;
	end;
	if chars_mobs_npcs[index].charm > 0 then
		return false;
	end;
	if chars_mobs_npcs[index].panic > 0 then
		return false;
	end;
	return true;
end;

function helpers.mobHasHandblock (index)
	if chars_mobs_npcs[index].lvl_unarmed < 1 then
		return false;
	end;
	for i=1,#chars_mobs_npcs[index].arms do
		local hand = chars_mobs_npcs[index]["arms"][i];
		if chars_mobs_npcs[index]["equipment"][hand] > 0
		and (inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class ~= "claws"
		and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class ~= "nipper"
		and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class ~= "knuckle"
		and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class ~= "tentacle")
		then
			return false;
		end;
	end;
	return true;
end;

function helpers.mobHasHealthyHands (index)
	local healthy_arms = 0;
	for i=1,#chars_mobs_npcs[index]["arms"] do
		if chars_mobs_npcs[index]["arms_health"][chars_mobs_npcs[index]["arms"][i]] > 0  then
			healthy_arms = healthy_arms + 1;
		end;
	end;
	return healthy_arms;
end;

function helpers.sizeModifer(index)
	if chars_mobs_npcs[index].size == "giant" then
		return 2;
	elseif chars_mobs_npcs[index].size == "big" then
		return 1.5;
	elseif chars_mobs_npcs[index].size == "normal" then
		return 1;
	elseif chars_mobs_npcs[index].size == "small" then
		return 0.5;
	end;
end;

function helpers.mobIDUnderCursor (x,y)
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y then
			return i;
		end;
	end;
end;

function helpers.someOneUnderCursor ()
	mob_under_cursor=0;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == point_to_go_x and chars_mobs_npcs[i].y == point_to_go_y  and chars_mobs_npcs[previctim].status == 1 then
			return true;
		else
			return false;
		end;
	end;
end;

function helpers.mobUnderCursor ()
	mob_under_cursor=0;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == point_to_go_x and chars_mobs_npcs[i].y == point_to_go_y  and chars_mobs_npcs[previctim].status == 1 and chars_mobs_npcs[current_mob].person == "mob" then
			return true;
		else
			return false;
		end;
	end;
end;

function helpers.npcUnderCursor ()
	mob_under_cursor=0;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == point_to_go_x and chars_mobs_npcs[i].y == point_to_go_y  and chars_mobs_npcs[previctim].status == 1 and chars_mobs_npcs[current_mob].person == "npc" then
			return true;
		else
			return false;
		end;
	end;
end;

function helpers.charUnderCursor ()
	mob_under_cursor=0;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == point_to_go_x and chars_mobs_npcs[i].y == point_to_go_y  and chars_mobs_npcs[previctim].status >= 0 and chars_mobs_npcs[current_mob].person == "char" then
			return true;
		else
			return false;
		end;
	end;
end;

function helpers.deadCharUnderCursor ()
	mob_under_cursor=0;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == point_to_go_x and chars_mobs_npcs[i].y == point_to_go_y  and chars_mobs_npcs[previctim].status < 0 and chars_mobs_npcs[current_mob].person == "char" then
			return true;
		else
			return false;
		end;
	end;
end;

function helpers.deadMobUnderCursor ()
	mob_under_cursor=0;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == point_to_go_x and chars_mobs_npcs[i].y == point_to_go_y  and chars_mobs_npcs[previctim].status < 0 and chars_mobs_npcs[current_mob].person ~= "char" then
			return true;
		else
			return false;
		end;
	end;
end;

function helpers.notCharUnderCursor ()
	mob_under_cursor=0;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == point_to_go_x and chars_mobs_npcs[i].y == point_to_go_y  and chars_mobs_npcs[previctim].status == 1 and chars_mobs_npcs[current_mob].person ~= "char" then
			return true;
		else
			return false;
		end;
	end;
end;

function helpers.allyUnderCursor ()
	mob_under_cursor=0;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == point_to_go_x and chars_mobs_npcs[i].y == point_to_go_y  and chars_mobs_npcs[previctim].status == 1 and (chars_mobs_npcs[current_mob].person == "char" or chars_mobs_npcs[current_mob].control == "player") then
			return true;
		else
			return false;
		end;
	end;
end;

function helpers.aliveAtHex(x,y)
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == x and chars_mobs_npcs[i].y == y and chars_mobs_npcs[i].status == 1 then
			return true;
		end;
	end;
	return false;
end;

function helpers.globalRandom ()
	global_rnd = {};
	global_rnd[1] = 1;
	global_rnd[2] = math.random(2);
	global_rnd[3] = math.random(3);
	global_rnd[4] = math.random(4);
	global_rnd[5] = math.random(5);
	global_rnd[6] = math.random(6);
	global_rnd[7] = math.random(10);
	global_rnd[8] = math.random(10);
	global_rnd[9] = math.random(10);
	global_rnd[10] = math.random(10);
	global_rnd[11] = math.random(10);
	global_rnd[12] = math.random(10);
end;

function helpers.anim_random ()
	anim_rnd = {};
	anim_rnd[1] = math.random(10);
	anim_rnd[2] = math.random(10);
	anim_rnd[3] = math.random(10);
	anim_rnd[4] = math.random(10);
	anim_rnd[5] = math.random(10);
	anim_rnd[6] = math.random(10);
end;

function helpers.BagNear (x,y)
	for i=1, #bags_list do
		if x == bags_list[i].x and y == bags_list[i].y then
			return true;
		end;
	end;
	return false;
end;

function helpers.attackDirectionNum (agressor,x,y)
	local rings = boomareas.ringArea(chars_mobs_npcs[agressor].x,chars_mobs_npcs[agressor].y);
	for i=1,6 do
		if rings[1][i].x == x and rings[1][i].y == y then
			atk_direction = i;
		end;
	end;
	return atk_direction;
end;

function helpers.bestAttackDirection (agressor,x,y)
	if chars_mobs_npcs[agressor].y == y and chars_mobs_npcs[agressor].x > x then
		atk_direction = 5;
	elseif chars_mobs_npcs[agressor].y == y and chars_mobs_npcs[agressor].x < x then
		atk_direction = 2;
	elseif chars_mobs_npcs[agressor].y < y and chars_mobs_npcs[agressor].x >= x and helpers.mobevenornot (agressor) then
		atk_direction = 1;
	elseif chars_mobs_npcs[agressor].y < y and chars_mobs_npcs[agressor].x < x and helpers.mobevenornot (agressor) then
		atk_direction = 6;
	elseif chars_mobs_npcs[agressor].y < y and chars_mobs_npcs[agressor].x > x and not helpers.mobevenornot (agressor) then
		atk_direction = 1;
	elseif chars_mobs_npcs[agressor].y < y and chars_mobs_npcs[agressor].x <= x and not helpers.mobevenornot (agressor) then
		atk_direction = 6;
	elseif chars_mobs_npcs[agressor].y > y and chars_mobs_npcs[agressor].x >= x and helpers.mobevenornot (agressor) then
		atk_direction = 3;
	elseif chars_mobs_npcs[agressor].y > y and chars_mobs_npcs[agressor].x < x and helpers.mobevenornot (agressor) then
		atk_direction = 4;
	elseif chars_mobs_npcs[agressor].y > y and chars_mobs_npcs[agressor].x > x and not helpers.mobevenornot (agressor) then
		atk_direction = 3;
	elseif chars_mobs_npcs[agressor].y > y and chars_mobs_npcs[agressor].x <= x and not helpers.mobevenornot (agressor) then
		atk_direction = 4;
	end;
	return atk_direction;
end;

function helpers.mobName(index)
	if chars_mobs_npcs[index].person == "char" or chars_mobs_npcs[index].person == "npc" then
		local name = chars_mobs_npcs[index].name;
		return name;
	elseif chars_mobs_npcs[index].person == "mob" then
		local name_ = chars_mobs_npcs[index].class;
		local name__ = "lognames.mob_names." .. name_;
		local name = loadstring("return " .. name__)();
		return name;
	end;
end;

function helpers.whatBag (index)
	local bagid = 0;
	for i=1, #bags_list do
		if chars_mobs_npcs[index].x == bags_list[i].x and chars_mobs_npcs[index].y == bags_list[i].y then
			bagid = i;
			break;
		end;
	end;
	if bagid > 0 then
		return bagid;
	end;
	local x,y = helpers.hexBehindMob(current_mob);
	local at_door,doorid,locked,traped = helpers.cursorAtClosedDoor(x,y);
	if at_door then
		bagid = doorid;
		return bagid;
	end;
	return false;
end;

function helpers.aliveNature(index)
	if chars_mobs_npcs[index].nature == "undead" or chars_mobs_npcs[index].nature == "golem" or chars_mobs_npcs[index].nature == "droid" or chars_mobs_npcs[index].nature == "elemental" then
		return false;
	end;
	return true;
end;

function helpers.droidNature(index)
	if chars_mobs_npcs[index].nature == "droid" then
		return true;
	end;
	return false;
end;

function helpers.traumaNature(index)
	if chars_mobs_npcs[index].nature == "undead" or chars_mobs_npcs[index].nature == "golem" or chars_mobs_npcs[index].nature == "droid" or chars_mobs_npcs[index].nature == "elemental"
	or chars_mobs_npcs[index].nature == "ooz" or chars_mobs_npcs[index].nature == "plant"
	then
		return false;
	end;
	return true;
end;

function helpers.soulNature(index)
	if chars_mobs_npcs[index].nature == "golem" or chars_mobs_npcs[index].nature == "droid" then
		return false;
	end;
	return true;
end;

function helpers.renumber (tmpnumber,index) -- DO NOT USE elseif here!!!
	for i=1,11 do
		for h=1,15 do
			if inventory_bag[index][h][i] > tmpnumber and inventory_bag[index][h][i] > 0 and inventory_bag[index][h][i] < 10000 then
				inventory_bag[index][h][i]=inventory_bag[index][h][i]-1;
			end;
		end;
	end;
	--
	if chars_mobs_npcs[index]["equipment"].rh>tmpnumber then
		chars_mobs_npcs[index]["equipment"].rh=chars_mobs_npcs[index]["equipment"].rh-1
	end
	if chars_mobs_npcs[index]["equipment"].lh>tmpnumber then
		chars_mobs_npcs[index]["equipment"].lh=chars_mobs_npcs[index]["equipment"].lh-1
	end
	if chars_mobs_npcs[index]["equipment"].armor>tmpnumber then
		chars_mobs_npcs[index]["equipment"].armor=chars_mobs_npcs[index]["equipment"].armor-1
	end
	if chars_mobs_npcs[index]["equipment"].head>tmpnumber then
		chars_mobs_npcs[index]["equipment"].head=chars_mobs_npcs[index]["equipment"].head-1
	end
	if chars_mobs_npcs[index]["equipment"].boots>tmpnumber then
		chars_mobs_npcs[index]["equipment"].boots=chars_mobs_npcs[index]["equipment"].boots-1
	end
	if chars_mobs_npcs[index]["equipment"].gloves>tmpnumber then
		chars_mobs_npcs[index]["equipment"].gloves=chars_mobs_npcs[index]["equipment"].gloves-1
	end
	if chars_mobs_npcs[index]["equipment"].ranged>tmpnumber then
		chars_mobs_npcs[index]["equipment"].ranged=chars_mobs_npcs[index]["equipment"].ranged-1
	end
	if chars_mobs_npcs[index]["equipment"].ammo>tmpnumber then
		chars_mobs_npcs[index]["equipment"].ammo=chars_mobs_npcs[index]["equipment"].ammo-1
	end
	if chars_mobs_npcs[index]["equipment"].amulet>tmpnumber then
		chars_mobs_npcs[index]["equipment"].amulet=chars_mobs_npcs[index]["equipment"].amulet-1
	end
	if chars_mobs_npcs[index]["equipment"].cloak>tmpnumber then
		chars_mobs_npcs[index]["equipment"].cloak=chars_mobs_npcs[index]["equipment"].cloak-1
	end
	if chars_mobs_npcs[index]["equipment"].belt>tmpnumber then
		chars_mobs_npcs[index]["equipment"].belt=chars_mobs_npcs[index]["equipment"].belt-1
	end
	if chars_mobs_npcs[index]["equipment"].art>tmpnumber then
		chars_mobs_npcs[index]["equipment"].art=chars_mobs_npcs[index]["equipment"].art-1
	end
	if chars_mobs_npcs[index]["equipment"].ring1>tmpnumber then
		chars_mobs_npcs[index]["equipment"].ring1=chars_mobs_npcs[index]["equipment"].ring1-1
	end
	if chars_mobs_npcs[index]["equipment"].ring2>tmpnumber then
		chars_mobs_npcs[index]["equipment"].ring2=chars_mobs_npcs[index]["equipment"].ring2-1
	end
	if chars_mobs_npcs[index]["equipment"].ring3>tmpnumber then
		chars_mobs_npcs[index]["equipment"].ring3=chars_mobs_npcs[index]["equipment"].ring3-1
	end
	if chars_mobs_npcs[index]["equipment"].ring4>tmpnumber then
		chars_mobs_npcs[index]["equipment"].ring4=chars_mobs_npcs[index]["equipment"].ring4-1
	end
	if chars_mobs_npcs[index]["equipment"].ring5>tmpnumber then
		chars_mobs_npcs[index]["equipment"].ring5=chars_mobs_npcs[index]["equipment"].ring5-1
	end
	if chars_mobs_npcs[index]["equipment"].ring6>tmpnumber then
		chars_mobs_npcs[index]["equipment"].ring6=chars_mobs_npcs[index]["equipment"].ring6-1
	end
	--
	if chars_mobs_npcs[index].person == "char" then
		if alchlab[index].tool1>tmpnumber then
			alchlab[index].tool1=alchlab[index].tool1-1
		end
		if alchlab[index].tool2>tmpnumber then
			alchlab[index].tool2=alchlab[index].tool2-1
		end
		if alchlab[index].tool3>tmpnumber then
			alchlab[index].tool3=alchlab[index].tool3-1
		end
		if alchlab[index].bottle1>tmpnumber then
			alchlab[index].bottle1=alchlab[index].bottle1-1
		end
		if alchlab[index].bottle2>tmpnumber then
			alchlab[index].bottle2=alchlab[index].bottle2-1
		end
		if alchlab[index].bottle3>tmpnumber then
			alchlab[index].bottle3=alchlab[index].bottle3-1
		end
		if alchlab[index].comp1>tmpnumber then
			alchlab[index].comp1=alchlab[index].comp1-1
		end
		if alchlab[index].comp2>tmpnumber then
			alchlab[index].comp2=alchlab[index].comp2-1
		end
		if alchlab[index].comp3>tmpnumber then
			alchlab[index].comp3=alchlab[index].comp3-1
		end
		if alchlab[index].comp4>tmpnumber then
			alchlab[index].comp4=alchlab[index].comp4-1
		end
		if alchlab[index].comp5>tmpnumber then
			alchlab[index].comp5=alchlab[index].comp5-1
		end
		if alchlab[index].comp6>tmpnumber then
			alchlab[index].comp6=alchlab[index].comp6-1
		end;
		--
		if picklock[index].tool1>tmpnumber then
			picklock[index].tool1=picklock[index].tool1-1
		end;
		if picklock[index].tool2>tmpnumber then
			picklock[index].tool2=picklock[index].tool2-1
		end;
		if picklock[index].tool3>tmpnumber then
			picklock[index].tool3=picklock[index].tool3-1
		end;
		if picklock[index].tool4>tmpnumber then
			picklock[index].tool4=picklock[index].tool4-1
		end;
		if picklock[index].picklock>tmpnumber then
			picklock[index].picklock=picklock[index].picklock-1
		end;
		if picklock[index].key>tmpnumber then
			picklock[index].key=picklock[index].key-1
		end;
		if picklock[index].traptool>tmpnumber then
			picklock[index].traptool=picklock[index].traptool-1
		end;
		if picklock[index].forcer>tmpnumber then
			picklock[index].forcer=picklock[index].forcer-1
		end;
	end;
	--
end;

function helpers.equiped(mob_id,index)
	if chars_mobs_npcs[mob_id]["equipment"].rh==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].lh==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].armor==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].head==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].boots==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].gloves==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].ranged==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].ammo==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].amulet==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].cloak==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].belt==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].art==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].ring1==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].ring2==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].ring3==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].ring4==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].ring5==index then
		return true;
	elseif chars_mobs_npcs[mob_id]["equipment"].ring6==index then
		return true;
	--
	elseif alchlab[mob_id].tool1==index then
		return true;
	elseif alchlab[mob_id].tool2==index then
		return true;
	elseif alchlab[mob_id].tool3==index then
		return true;
	elseif alchlab[mob_id].bottle1==index then
		return true;
	elseif alchlab[mob_id].bottle2==index then
		return true;
	elseif alchlab[mob_id].bottle3==index then
		return true;
	elseif alchlab[mob_id].comp1==index then
		return true;
	elseif alchlab[mob_id].comp2==index then
		return true;
	elseif alchlab[mob_id].comp3==index then
		return true;
	elseif alchlab[mob_id].comp4==index then
		return true;
	elseif alchlab[mob_id].comp5==index then
		return true;
	elseif alchlab[mob_id].comp6==index then
		return true;
	--
	elseif picklock[mob_id].tool1==index then
		return true;
	elseif picklock[mob_id].tool2==index then
		return true;
	elseif picklock[mob_id].tool3==index then
		return true;
	elseif picklock[mob_id].tool4==index then
		return true;
	elseif picklock[mob_id].picklock==index then
		return true;
	elseif picklock[mob_id].key==index then
		return true;
	elseif picklock[mob_id].traptool==index then
		return true;
	elseif picklock[mob_id].forcer==index then
		return true;
	end;
	--
	return false;
end;

function helpers.leadershipBonus (index) --add stats bonuses
	local bonus = 0;
	local area_bonus = 0;
	local leader_is_alive = false;
	local leader_id = 0;
	local rings = boomareas.ringArea(chars_mobs_npcs[index].x,chars_mobs_npcs[index].y);
	local coffchr = 0;
	local boomarea = {};
	for h=1,3 do
		for i =1, #rings[h] do
			table.insert(boomarea,{x=rings[h][i].x,y=rings[h][i].y});
		end;
	end;
	for j=1,#chars_mobs_npcs do
		for i=1,#boomarea do
			if j ~= index and chars_mobs_npcs[index].party == chars_mobs_npcs[j].party and chars_mobs_npcs[j].status == 1 and chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y == boomarea[i].y and j ~= i and (chars_mobs_npcs[j].fraction == chars_mobs_npcs[index].fraction or chars_mobs_npcs[j].party == chars_mobs_npcs[index].party) and chars_mobs_npcs[j].lvl_leadership*chars_mobs_npcs[j].num_leadership > chars_mobs_npcs[index].lvl_leadership*chars_mobs_npcs[index].num_leadership then
				bonus = bonus + chars_mobs_npcs[j].num_leadership*chars_mobs_npcs[j].lvl_leadership;
				if chars_mobs_npcs[j].lvl_leadership == 5 then
					coffchr = 1;
				elseif chars_mobs_npcs[j].lvl_leadership == 4 then
					coffchr = 0.5;
				elseif chars_mobs_npcs[j].lvl_leadership == 3 then
					coffchr = 0.25;
				elseif chars_mobs_npcs[j].lvl_leadership == 2 then
					coffchr = 0.1;
				end;
				bonus = bonus + math.ceil(chars_mobs_npcs[j].chr*coffchr);
			end;
		end;
		if  j ~= index and chars_mobs_npcs[index].party == chars_mobs_npcs[j].party and chars_mobs_npcs[j].num_leadership > 0 and chars_mobs_npcs[j].status == 1 then
			leader_is_alive = true;
			leader_id = j;
		end;
	end;
	if bonus == 0 and leader_is_alive then
		bonus = chars_mobs_npcs[leader_id].lvl_leadership;
	end;
	return bonus;
end;

function helpers.enemyYouWatch (index)
	local enemies = 0;
	local demoral = 0;
	local darkarray = {};
	darkarray = darkness[chars_mobs_npcs[index].party];
	for my=1, map_h do
		for mx=1, map_w do	
			if darkness[chars_mobs_npcs[index].party][my][mx] == 0 then
				for j=1, #chars_mobs_npcs do
					if chars_mobs_npcs[j].status > 0 and ai.fractionRelations (index,j) < 0 and chars_mobs_npcs[j].x == mx and chars_mobs_npcs[j].x == my and chars_mobs_npcs[j].invisibility == 0 and not helpers.ifStealthed(index,j) then
						enemies = enemies + 1;
						if chars_mobs_npcs[j].lv > chars_mobs_npcs[index].lv then
							demoral = demoral + math.max(1,chars_mobs_npcs[j].lv - chars_mobs_npcs[index].lv);
						else
							demoral = demoral + 1;
						end;
					end;
				end;
			end;
		end;
	end;
	return enemies,demoral;
end;

function helpers.ifStealthed(watcher,stealther)
	if helpers.blindedWithLight (watcher,chars_mobs_npcs[stealther].x,chars_mobs_npcs[stealther].y)
	and chars_mobs_npcs[stealther].num_stealth*chars_mobs_npcs[stealther].lvl_stealth > chars_mobs_npcs[watcher].num_spothidden*chars_mobs_npcs[watcher].lvl_spothidden
	and (not helpers.cursorIsNear(chars_mobs_npcs[watcher].x,chars_mobs_npcs[watcher].y,chars_mobs_npcs[stealther].x,chars_mobs_npcs[stealther].y) or helpers.attackDirection(stealther,watcher) == "back") then
		return true;
	end;
	return false;
end;

function helpers.countMoral(index)
	local self_leadership_bonus = chars_mobs_npcs[index].num_leadership*chars_mobs_npcs[index].lvl_leadership;
	local leadership_bonus =  helpers.leadershipBonus (index);
	local enemies,demoral = helpers.enemyYouWatch(index); -- level of
	if enemies == 0 then
		moral = 0;
		demoral = 0;
	end;
	if chars_mobs_npcs[index].panic == 0 then
		demoral = math.ceil(demoral*1.5);
	elseif chars_mobs_npcs[index].fear == 0 then
		demoral = math.ceil(demoral*1.25);
	end;
	if chars_mobs_npcs[index].class == "savage" or chars_mobs_npcs[index].class == "paladin" and (chars_mobs_npcs[index].fear == 0 and chars_mobs_npcs[index].panic == 0) then
		demoral = math.ceil(demoral/2);
	end;
	if chars_mobs_npcs[index].class == "savage" and (chars_mobs_npcs[index].fear == 0 and chars_mobs_npcs[index].panic == 0) then
		demoral = 0;
	end;
	if (chars_mobs_npcs[index].class == "barbarian" or chars_mobs_npcs[index].berserk > 0) and (chars_mobs_npcs[index].fear == 0 and chars_mobs_npcs[index].panic == 0) then
		demoral = -1*demoral;
	end;
	local moral = chars_mobs_npcs[index].base_moral + self_leadership_bonus + leadership_bonus + chars_mobs_npcs[index].myrth_power - chars_mobs_npcs[index].despondency_power - demoral;
	if chars_mobs_npcs[index].drunk > 0 then
		moral = math.random(1,201)-101;
	end;
	if not helpers.aliveNature(index) then
		moral = 0;
	end
	chars_mobs_npcs[index].moral = moral;
	return moral;
end;

function helpers.checkPickLock (code,typ)
	local keycode = {};
	local lockcode = {};
	local tmp = "0000000000";
	local disksum = 0;
	if typ == 3 then
		for i=1,10 do
			disksum = disksum + diskcode[i];
		end;
	end;
	if picklock[current_mob].key > 0 then
		tmp = tostring(chars_mobs_npcs[current_mob]["inventory_list"][picklock[current_mob].key].w);
	end;
	if picklock[current_mob].key > 0 then
		for w in string.gmatch(tmp, "%d") do
			table.insert(keycode, tonumber(w));
		end;
	else
		for w in string.gmatch(tmp, "%d") do
			table.insert(keycode, tonumber(w));
		end;
	end;
	for w in string.gmatch(code, "%d") do
		table.insert(lockcode, tonumber(w));
	end;
	for i=1,10 do
		if (typ == 3 and disksum < 64) or (typ == 1 and keycode[i] ~= lockcode[i]) or (typ == 2 and keycode[i] ~= lockcode[i] and lock_elements[i] == 1) then
			return false;
		end;
	end;
	calendar.add_time_interval(calendar.delta_picklocking);
	return true;
end;

function helpers.cylinricalPickLocked()
	for i=1,10 do
		if lock_elements[i] == 1 then
			return false;
		end;
	end;
	calendar.add_time_interval(calendar.delta_picklocking);
	return true;
end;

function helpers.chestTrapCylinder(bagid,traptrigger)
	if bags_list[bagid].traped then
		if traptrigger == 1 then
			helpers.addToActionLog( lognames.actions.trapactivated);
			bags_list[bagid].traped = false;
			missle_drive = "trap";
			missle_type = bags_list[bagid].trapmodel;
			trappower = bags_list[bagid].trappower;
			boomx = bags_list[bagid].xi;
			boomy = bags_list[bagid].yi;
			--psPicklockBroken[1].ps:stop();
			bm_timer = 0
			victim = current_mob;
			game_status = "boom";
			calendar.add_time_interval(calendar.delta_picklocking);
		end;
	end;
end;

function helpers.chestTrapDisk(bagid)
	helpers.addToActionLog( lognames.actions.trapactivated);
	bags_list[bagid].traped = false;
	missle_drive = "trap";
	missle_type = bags_list[bagid].trapmodel;
	trappower = bags_list[bagid].trappower;
	boomx = bags_list[bagid].xi;
	boomy = bags_list[bagid].yi;
	--psPicklockBroken[1].ps:stop();
	bm_timer = 0
	victim = current_mob;
	game_status = "boom";
	calendar.add_time_interval(calendar.delta_picklocking);
end;

function helpers.chestTrapDisarmFailed (bagid)
	helpers.addToActionLog( lognames.actions.trapactivated);
	bags_list[bagid].traped = false;
	missle_drive = "trap";
	missle_type = bags_list[bagid].trapmodel;
	trappower = bags_list[bagid].trappower;
	boomx = bags_list[bagid].xi;
	boomy = bags_list[bagid].yi;
	--psPicklockBroken[1].ps:stop();
	bm_timer = 0
	victim = current_mob;
	game_status = "boom";
	calendar.add_time_interval(calendar.delta_disarming);
end;

function helpers.groundTrapActivated (bagid)
	helpers.addToActionLog( lognames.actions.trapactivated);
	bags_list[bagid].traped = false;
	missle_drive = "trap";
	missle_type = bags_list[bagid].trapmodel;
	trappower = bags_list[bagid].trappower;
	boomx = bags_list[bagid].x;
	boomy = bags_list[bagid].y;
	bm_timer = 0
	victim = current_mob;
	game_status = "boom";
	boomareas.ashGround (boomx,boomy);
	draw.boom();
	table.remove(bags_list,bagid);
end;

function helpers.ifTrapDisarmed(trapcode)
	local traparray = {};
	for w in string.gmatch(trapcode, "%d") do
		table.insert(traparray, tonumber(w));
	end;
	for i=1,#traparray do
		if traparray[i] > 0 then
			return false;
		end;
	end;
	return true;
end;

function helpers.afterTrapDisarmed(index)
	bags_list[index].traped = false;
	helpers.addToActionLog( lognames.actions.trapdisarmed);
	table.insert(bags_list[index],helpers.trapDamagingPart(index));
	if bags_list[index].typ == "trap" then
		bags_list[index].locked = false;
		bags_list[index].opened = true;
		bags_list[index].typ = "bag";
		chars_mobs_npcs[current_mob].x = bags_list[index].x;
		chars_mobs_npcs[current_mob].y = bags_list[index].y;
		index = helpers.whatBag(current_mob);
		helpers.repackBag();
		game_status = "inventory";
		calendar.add_time_interval(calendar.delta_picklocking);
	end;
	if bags_list[index].typ == "door" and not bags_list[index].locked then
		bags_list[index].opened = true;
		bags_list[index].typ = "bag";
		chars_mobs_npcs[current_mob].x = bags_list[index].x;
		chars_mobs_npcs[current_mob].y = bags_list[index].y;
		index = helpers.whatBag(current_mob);
		helpers.repackBag();
		game_status = "inventory";
		calendar.add_time_interval(calendar.delta_picklocking);
	end;
end;

function helpers.trapDamagingPart(index)
	local part = nil;
	local power = bags_list[index].trappower;
	local model = bags_list[index].trapmodel;
	local battleparts = {firebomb={303,power},toxicbomb={281,power},acidbomb={315,power},frostbomb={301,power},staticbomb={},noicebomb={328,power},fearbomb={307,power},sleepbomb={313,power},charmbomb={},spikes={384,1},bell={},teleport={},spawn={},bolts={146,5},heavybolts={150,5}};
	local part = {ttxid=battleparts[model][1],q=battleparts[model][2],w=0,e=0,r=1,h=0};
	return part;
end;

function helpers.breakAllPicklocks (bagid)
	helpers.breakKey (current_mob);
	helpers.breakPicklock (current_mob);
	helpers.breakTrapTool (current_mob);
end;

function helpers.breakTrapTool (bagid)
	if picklock[current_mob].traptool > 0 then
		local tmp = picklock[current_mob].traptool;
		table.remove(list[current_mob],tmp);
		picklock[current_mob].traptool = 0;
		--helpers.renumber(picklock[current_mob].traptool,current_mob);
		love.audio.play(media.sounds.crack,0);
		helpers.addToActionLog( lognames.actions.picklockbroken);
		--psPicklockBroken[1].ps:start();
		picklockJustBroken = 100;
	end;
end;

function helpers.breakPicklock (bagid)
	if picklock[current_mob].picklock > 0 then
		local tmp = picklock[current_mob].picklock;
		table.remove(list[current_mob],picklock[current_mob].picklock);
		picklock[current_mob].picklock = 0;
		--helpers.renumber(tmp,current_mob);
		love.audio.play(media.sounds.crack,0);
		helpers.addToActionLog( lognames.actions.picklockbroken);
		--psPicklockBroken[1].ps:start();
		picklockJustBroken = 100;
	end;
end;

function helpers.breakKey (bagid)
	if picklock[current_mob].key > 0 then
		local tmp = picklock[current_mob].key;
		table.remove(list[current_mob],tmp);
		picklock[current_mob].key = 0;
		--helpers.renumber(picklock[current_mob].key,current_mob);
		love.audio.play(media.sounds.crack,0);
		helpers.addToActionLog( lognames.actions.picklockbroken);
		--psPicklockBroken[1].ps:start();
		keyJustBroken = 100;
	end;
end;

function helpers.detectAgro (index)
	local mob_detects_enemies = {};
	local mob_detects_aggro = {};
	ai.agro_array_full ();
	trace.first_watch (index);
	for l=1, #chars_mobs_npcs do
		if darkness[chars_mobs_npcs[index].party][chars_mobs_npcs[l].x][chars_mobs_npcs[l].y] == 0 and not ai.friendOrFoe (index,l)
		and l ~= index and chars_mobs_npcs[l].status == 1 then
			ai_world_x = chars_mobs_npcs[l].x;
			ai_world_y = chars_mobs_npcs[l].y;
			mob_can_move = 0;
			mob_is_going_to_hit = 1;
			path_finding (0,0);
			if path_status == 1 and chars_mobs_npcs[l].invisibility == 0 then
				table.insert(mob_detects_enemies,l);
			end;
		end;
	end;
	print("MbDtEn",#mob_detects_enemies);
	if #mob_detects_enemies > 0 then
		for e=1,#mob_detects_enemies do --for aggro
			local tmpfrac = chars_mobs_npcs[mob_detects_enemies[e]].fraction;
			local tmpfrac2 = chars_mobs_npcs[index].fraction;
			local fraccond = loadstring("return " .. "fractions." .. tmpfrac2 .. "." .. tmpfrac)();
			local aggro_factor = 0;
			local range_factor=math.ceil(20-math.sqrt((chars_mobs_npcs[index].x-chars_mobs_npcs[mob_detects_enemies[e]].x)^2+(chars_mobs_npcs[index].y-chars_mobs_npcs[mob_detects_enemies[e]].y)^2));
			aggro_factor = -1*fraccond+range_factor+math.random(10);
			if chars_mobs_npcs[index].aggressor==mob_detects_enemies[e] then
				aggro_factor = aggro_factor*2;
			end;
			local startcounter=#mob_detects_aggro+1;
			for f=startcounter,aggro_factor do
				table.insert(mob_detects_aggro,mob_detects_enemies[e]);
			end;
		end;
	end;
	if #mob_detects_aggro > 0 then
		local target_preroll = math.random(1,#mob_detects_aggro);
		local target_roll = mob_detects_aggro[target_preroll];
		local previctim = chars_mobs_npcs[target_roll].id;
		return previctim;
	end;
	return false;
end;

function helpers.detectAImode (index)
	local mind_mod = "";
	local mind_condition = "";
	local mind_buff = "";
	local mind_buff2 = "";
	local mind_debuff = "";
	local mind_killmepls = "";
	local mind_drunk = "";
	local mind_gold = "";
	local mind_counter = 0;
	local mind_howmuch = "";
	local mind_fraction = mind_fractions[chars_mobs_npcs[index].fraction];
	if chars_mobs_npcs[index].gold == 0 then
		mind_gold = mind_status.nogold;
	elseif chars_mobs_npcs[index].gold >= 1 and chars_mobs_npcs[index].gold < 100 then
		mind_gold = mind_status.abitgold .. chars_mobs_npcs[index].gold;
	elseif chars_mobs_npcs[index].gold >= 100 and chars_mobs_npcs[index].gold < 1000 then
		mind_gold = mind_status.somegold .. chars_mobs_npcs[index].gold;
	elseif chars_mobs_npcs[index].gold >= 1000 then
		mind_gold = mind_status.enoughgold .. chars_mobs_npcs[index].gold;
	end;
	local in_mind = "";
	if chars_mobs_npcs[index].ai == "agr" or chars_mobs_npcs[index].ai == "away" or chars_mobs_npcs[index].ai == "stay" or chars_mobs_npcs[index].ai == "rnd" then
		mind_mod = mind_status[chars_mobs_npcs[index].ai];
	end;
	if chars_mobs_npcs[index].charm > 0 then
		mind_condition = mind_status.charm;
	elseif chars_mobs_npcs[index].berserk > 0 then
		mind_condition = mind_status.berserk;
	elseif chars_mobs_npcs[index].madness > 0 then
		mind_condition = mind_status.madness;
	elseif chars_mobs_npcs[index].enslave > 0 then
		mind_condition = mind_status.enslave;
	end;
	if chars_mobs_npcs[index].heroism_power > 0 or chars_mobs_npcs[index].fateself > 0 or chars_mobs_npcs[index].prayer_power > 0 or chars_mobs_npcs[index].myrth_power > 0 or chars_mobs_npcs[index].bless > 0 or chars_mobs_npcs[index].haste > 0 then
		mind_buff = mind_status.hoorah;
	end;
	if chars_mobs_npcs[index].rage > 0 or chars_mobs_npcs[index].thirstofblood > 0 then
		mind_buff2 = mind_status.blood;
	end;
	if chars_mobs_npcs[index].fate > 0 or chars_mobs_npcs[index].mgt_debuff_power > 0 or chars_mobs_npcs[index].enu_debuff_power > 0 or chars_mobs_npcs[index].despondency_power > 0 or chars_mobs_npcs[index].luk_debuff_power > 0 or chars_mobs_npcs[index].curse > 0 or chars_mobs_npcs[index].hp <= chars_mobs_npcs[index].hp_max*0.25 then
		mind_debuff = mind_status.killmepls;
	end;
	if chars_mobs_npcs[index].drunk > 0 then
		mind_drunk = mind_status.killmepls;
	end;
	for j=1,#chars_mobs_npcs do
		if chars_mobs_npcs[j].fraction == chars_mobs_npcs[index].fraction then
			mind_counter = mind_counter + 1;
		end;
	end;
	mind_howmuch = lognames.actions.ustotal .. mind_counter;
	local phrase1 = mind_fraction;
	local phrase2 = mind_howmuch;
	local phrase3 = mind_gold;
	local phrase4 = mind_buff .. mind_buff2 .. mind_debuff;
	local phrase5 = mind_buff .. mind_buff2 .. mind_debuff;
	return phrase1,phrase2,phrase3;
end;

function helpers.beforeShoot ()
	if missle_drive == "spellbook" then
		chars_mobs_npcs[current_mob].sp = chars_mobs_npcs[current_mob].sp - price_in_mana;
		chars_mobs_npcs[current_mob].tmpexplost = chars_mobs_npcs[current_mob].tmpexplost + price_in_mana;
	elseif missle_drive == "scroll" then
		table.remove(list[tmp_bagid],scroll_smth);
		helpers.renumber(scroll_smth,current_mob);
		scroll_smth = 0;
	elseif missle_drive == "wand" then
		chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].q = chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].q -1;
	end;
end;

function helpers.countFreeCells (bag)
	local free_cells = {};
	for i=1,11 do
		for h=1,15 do
			if bag[h][i] == 0  then
				table.insert(free_cells,{h,i});
			end;
		end;
	end;
	return free_cells;
end;

function helpers.harvestOne ()
	local free_cells = helpers.countFreeCells (inventory_bag[chars_mobs_npcs[current_mob].id]); 
	if hlandscape[chars_mobs_npcs[current_mob].y][chars_mobs_npcs[current_mob].x] > 0 and hlandscape[chars_mobs_npcs[current_mob].y][chars_mobs_npcs[current_mob].x] < 26 then
		if #free_cells > 0 then
			helpers.addToActionLog( lognames.actions.found .. harvest_ttx[hlandscape[chars_mobs_npcs[current_mob].y][chars_mobs_npcs[current_mob].x]].title);
			table.insert(chars_mobs_npcs[current_mob]["inventory_list"],{ttxid=harvest_ttx[hlandscape[chars_mobs_npcs[current_mob].y][chars_mobs_npcs[current_mob].x]].loot, q=harvest_ttx[hlandscape[chars_mobs_npcs[current_mob].y][chars_mobs_npcs[current_mob].x]].power,w=0,e=0,r=0,h=0});
			inventory_bag[current_mob][free_cells[1][1]][free_cells[1][2]] = #chars_mobs_npcs[current_mob]["inventory_list"];
			hlandscape[chars_mobs_npcs[current_mob].y][chars_mobs_npcs[current_mob].x] = 0;
		else
			helpers.addToActionLog( lognames.actions.nospace);	
		end;
	else
		helpers.addToActionLog( lognames.actions.nothingtotake);
	end;
end;

function helpers.flayOne () --FIXME: if stoned cam`t stay at same hex
	for i=1, #chars_mobs_npcs do
		--if helpers.ifMobAtCordinates (chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y then
		if helpers.ifCursorIsNear() and (helpers.ifThisDeadMobAtCordinates (i,chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y) or helpers.ifThisDeadMobAtCordinates (i,cursor_world_x,cursor_world_y)) then
			if chars_mobs_npcs[i].person == "char" then
				helpers.flayChar(i);
			elseif chars_mobs_npcs[i].person == "mob" then
				helpers.flayMob(i);
			end;
			break;
		end;
	end;
end;

function helpers.ifThisDeadMobAtCordinates (index,x,y)
	if chars_mobs_npcs[index].status < 1 and chars_mobs_npcs[index].x == x and chars_mobs_npcs[index].y == y then
		return true;
	end;
	return false;
end;

function helpers.flayChar(index)
	local inv_bag = {};
	local eqip_bag = {};
	local dead_sprite = 0;
	if chars_mobs_npcs[index].stone == 1 then
		 dead_sprite = 497;
	elseif chars_mobs_npcs[index].status == 0 or chars_mobs_npcs[index].status == -1 then
		 dead_sprite = 496;
	elseif chars_mobs_npcs[index].status == -2 then
		 dead_sprite = 495;
	end;
	for i=1, #chars_stats[index].inventory_list do
		if not helpers.equiped(index,i) then
			table.insert(inv_bag,chars_stats[index]["inventory_list"][i]);
		else
			table.insert(eqip_bag,chars_stats[index]["inventory_list"][i]);
		end;
	end;
	chars_stats[index].inventory_list = {};
	if #inv_bag > 0 then
		table.insert(bags_list,{x=chars_mobs_npcs[index].x,y=chars_mobs_npcs[index].y,xi= chars_mobs_npcs[index].x,yi= chars_mobs_npcs[index].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
		helpers.zeroLastBag ();
	end;
	for i=1,#inv_bag do
		table.insert(bags_list[#bags_list],inv_bag[i]);
	end;
	if #eqip_bag > 0 then
		table.insert(bags_list,{x=chars_mobs_npcs[index].x,y=chars_mobs_npcs[index].y,xi= chars_mobs_npcs[index].x,yi= chars_mobs_npcs[index].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
		helpers.zeroLastBag ();
	end;
	for i=1,#eqip_bag do
		table.insert(bags_list[#bags_list],eqip_bag[i]);
		helpers.zeroLastBag ();
	end;
	table.insert(bags_list,{x=chars_mobs_npcs[index].x,y=chars_mobs_npcs[index].y,xi= chars_mobs_npcs[index].x,yi= chars_mobs_npcs[index].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
	table.insert(bags_list[#bags_list],{ttxid=dead_sprite,q=index,w=0,e=0,r=1});
	helpers.zeroLastBag ();
	chars_mobs_npcs[index].x = 0;
	chars_mobs_npcs[index].y = 0;
end;

function helpers.zeroLastBag ()
	table.insert(bags,{});
	for k=1,15 do
		bags[#bags_list][k] = {};
		for l=1,11 do
			bags[#bags_list][k][l] = 0;
		end;
	end;
end;

function helpers.flayMob(index)
end;

function helpers.ifItemIsNotBroken(index,ifbag,bagid)
	if not ifbag and chars_mobs_npcs[current_mob]["inventory_list"][index].q == 0 then
		return false;
	elseif ifbag and bags_list[bagid][index].q == 0 then
		return false;
	end;
	return true;
end;

function helpers.ifItemIsIdentified(index,ifbag,bagid)
	if not ifbag and chars_mobs_npcs[current_mob]["inventory_list"][index].r == 0 then
		return false;
	elseif ifbag and bags_list[bagid][index].r == 0 then
		return false;
	end;
	return true;
end;

function helpers.addMob(i,person)
	local tmpclass = nil;
	local tmpclass2 = nil;
	if person == "mob" then
		tmpclass="mobs_stats." .. chars_mobs_npcs[i].class;
		tmpclass2=loadstring("return " .. tmpclass)();
		chars_mobs_npcs[i].face = tmpclass2.face;
		chars_mobs_npcs[i].control = "ai";
	elseif person == "npc" then
		tmpclass="mobs_stats." .. chars_mobs_npcs[i].class;
		tmpclass2=loadstring("return " .. tmpclass)();
		chars_mobs_npcs[i].control = "ai";
	elseif person == "char" then
		tmpclass2 = chars_stats[i];
		chars_mobs_npcs[i].control = "player";
		chars_mobs_npcs[i].face = chars_stats[i].face;
		chars_mobs_npcs[i].class = chars_stats[i].class;
		chars_mobs_npcs[i].race = chars_stats[i].race;
		chars_mobs_npcs[i].name = chars_stats[i].name;
		chars_mobs_npcs[i].ai = "player";
		chars_mobs_npcs[i].fraction = "party";
		chars_mobs_npcs[i].battleai = "any";
		chars_stats[i].xp = 0;
		chars_mobs_npcs[i].tmpexpdmg = 0;
		chars_mobs_npcs[i].tmpexplost = 0;
		chars_mobs_npcs[i].tmpexpdeaths = 0;
		chars_mobs_npcs[i].lv = chars_stats[i].lv;	
		chars_mobs_npcs[i]["personality"] = {};
		chars_mobs_npcs[i]["personality"]["current"] = {};
		chars_mobs_npcs[i]["personality"]["current"].etiquette=chars_stats[i].etiquette;
		chars_mobs_npcs[i].skillpoints = 50; --FIXME DEBUG
		if chars_mobs_npcs[i].class == "acolyte" or
			chars_mobs_npcs[i].class == "mage" or
			chars_mobs_npcs[i].class == "archmage" or
			chars_mobs_npcs[i].class == "necromancer" or
			chars_mobs_npcs[i].class == "lich" or
			chars_mobs_npcs[i].class == "rogue" then
			chars_mobs_npcs[i].sp_stat	= chars_mobs_npcs[i].int;
		elseif chars_mobs_npcs[i].class == "novice" or
			chars_mobs_npcs[i].class == "monk" or
			chars_mobs_npcs[i].class == "ieromonk" or
			chars_mobs_npcs[i].class == "paladin" or
			chars_mobs_npcs[i].class == "crusader" or
			chars_mobs_npcs[i].class == "cleric" or 
			chars_mobs_npcs[i].class == "bishop" or 
			chars_mobs_npcs[i].class == "deathknight" or
			chars_mobs_npcs[i].class == "crusinant" then
			chars_mobs_npcs[i].sp_stat	= chars_mobs_npcs[i].spr;
		elseif chars_mobs_npcs[i].class == "druid" or
			chars_mobs_npcs[i].class == "archdruid" or
			chars_mobs_npcs[i].class == "sorcerer" or
			chars_mobs_npcs[i].class == "warlock" or
			chars_mobs_npcs[i].class == "shaman" or
			chars_mobs_npcs[i].class == "ubershaman" then
			chars_mobs_npcs[i].sp_stat	= math.max(chars_mobs_npcs[i].int,chars_mobs_npcs[i].spr);
		end;
	end;
	
	if person ~= "char" and tmpclass2.spellbook == 1 then
		chars_mobs_npcs[i].spellnames = tmpclass2.spellnames;
		helpers.createSpellbookBySpellNames(tmpclass2.spellnames);
	end;
	
	if person ~= "char" and tmpclass2.warbook == 1 then
		helpers.createWarbook(i);
	end;
	
	chars_mobs_npcs[i].multiattack = tmpclass2.multiattack;
	chars_mobs_npcs[i].status = 1;
	chars_mobs_npcs[i].id = i;
	chars_mobs_npcs[i].person = person;
	chars_mobs_npcs[i].sprite = tmpclass2.sprite;
	chars_mobs_npcs[i].aggro = 0;
	chars_mobs_npcs[i].aggressor = 0;
	chars_mobs_npcs[i].perks = tmpclass2.perks;
	
	--chars_mobs_npcs[i].class = tmpclass2.class;

	chars_mobs_npcs[i].hp_base = tmpclass2.hp_base;
	chars_mobs_npcs[i].sp_base = tmpclass2.sp_base;
	chars_mobs_npcs[i].st_base = tmpclass2.st_base;
	chars_mobs_npcs[i].hp_coff = tmpclass2.hp_coff;
	chars_mobs_npcs[i].sp_coff = tmpclass2.sp_coff;
	chars_mobs_npcs[i].st_coff = tmpclass2.st_coff;
	chars_mobs_npcs[i].spells = tmpclass2.spells;
	chars_mobs_npcs[i].spellbook=tmpclass2.spellbook;
	chars_mobs_npcs[i].warbook = tmpclass2.warbook;
	chars_mobs_npcs[i].protectionmode = "none";
	chars_mobs_npcs[i].stealth = 0;
	for h=1,#tmpclass2["hitzones"] do
		for k=1,#tmpclass2["hitzones"][h] do
			if tmpclass2["hitzones"][h][k] == "rh" then
				chars_mobs_npcs[i].rh = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lh" then
				chars_mobs_npcs[i].lh = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "rh1" then
				chars_mobs_npcs[i].rh1 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lh1" then
				chars_mobs_npcs[i].lh1 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "rh2" then
				chars_mobs_npcs[i].rh2 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lh2" then
				chars_mobs_npcs[i].lh2 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "rf" then
				chars_mobs_npcs[i].rf = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lf" then
				chars_mobs_npcs[i].lf = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "rf1" then
				chars_mobs_npcs[i].rf1 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lf1" then
				chars_mobs_npcs[i].lf1 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "rf2" then
				chars_mobs_npcs[i].rf2 = 1;
			end;
			if tmpclass2["hitzones"][h][k] == "lf2" then
				chars_mobs_npcs[i].lf2 = 1;
			end;
		end;
	end;
	chars_mobs_npcs[i].rt=0;
	chars_mobs_npcs[i].status=1;
	chars_mobs_npcs[i].nature=tmpclass2.nature;
	chars_mobs_npcs[i].gender=tmpclass2.gender;
	chars_mobs_npcs[i].size=tmpclass2.size;
	chars_mobs_npcs[i].lv=tmpclass2.lv;
	chars_mobs_npcs[i].expa=tmpclass2.expa;
	chars_mobs_npcs[i].motion=tmpclass2.motion;
	chars_mobs_npcs[i].nightvision=tmpclass2.nightvision;
	chars_mobs_npcs[i].leye = 1;
	chars_mobs_npcs[i].reye = 1;
	chars_mobs_npcs[i].fov = tmpclass2.fov;
	chars_mobs_npcs[i].track = tmpclass2.track;
	chars_mobs_npcs[i].motion = tmpclass2.motion;
	chars_mobs_npcs[i].hexes = tmpclass2.hexes;
	chars_mobs_npcs[i].hitzones = tmpclass2.hitzones;
	
	chars_mobs_npcs[i].claws = tmpclass2.claws;
	chars_mobs_npcs[i].teeth = tmpclass2.teeth;
	chars_mobs_npcs[i].horns = tmpclass2.horns;
	chars_mobs_npcs[i].hoofs = tmpclass2.hoofs;
	
	chars_mobs_npcs[i].inventory_list = tmpclass2.inventory_list;
	chars_mobs_npcs[i].equipment = tmpclass2.equipment;
	
	chars_mobs_npcs[i].mgt=tmpclass2.mgt;
	chars_mobs_npcs[i].enu=tmpclass2.enu;
	chars_mobs_npcs[i].dex=tmpclass2.dex;
	chars_mobs_npcs[i].spd=tmpclass2.spd;
	chars_mobs_npcs[i].acu=tmpclass2.acu;
	chars_mobs_npcs[i].sns=tmpclass2.sns;
	chars_mobs_npcs[i].int=tmpclass2.int;
	chars_mobs_npcs[i].spr=tmpclass2.spr;
	chars_mobs_npcs[i].chr=tmpclass2.chr;
	chars_mobs_npcs[i].luk=tmpclass2.luk;
	
	--[[if person == "mob" then
		chars_mobs_npcs[i].rng=math.ceil(tmpclass2.spd/10)*tmpclass2.mvcoff+5;
		chars_mobs_npcs[i].sense=10+math.ceil(tmpclass2.sns/5);
	elseif person == "npc" then
		chars_mobs_npcs[i].rng=math.ceil(tmpclass2.spd/10)*tmpclass2.mvcoff+5;
		chars_mobs_npcs[i].sense=10+math.ceil(tmpclass2.sns/5);
	elseif person == "char" then]]
		chars_mobs_npcs[i].rng = 5+math.ceil((chars_mobs_npcs[i].spd+chars_mobs_npcs[i].dex)/10);
		chars_mobs_npcs[i].sense =10+math.ceil(chars_mobs_npcs[i].sns/5);
		chars_mobs_npcs[i].satiation = chars_mobs_npcs[i].enu*10;
	--end;

	chars_mobs_npcs[i].sp_stat = chars_mobs_npcs[i].int;
	
	chars_mobs_npcs[i].view=i;
	chars_mobs_npcs[i].ac=tmpclass2.ac;
	chars_mobs_npcs[i].dt=tmpclass2.dt;
	chars_mobs_npcs[i].dr=tmpclass2.dr;
	chars_mobs_npcs[i].block=tmpclass2.block;
	chars_mobs_npcs[i].parry = 0;
	
	--[[chars_mobs_npcs[i].atkm=tmpclass2.atkm;
	chars_mobs_npcs[i].amel=tmpclass2.amel;
	chars_mobs_npcs[i].bmel=tmpclass2.bmel;
	chars_mobs_npcs[i].cmel=tmpclass2.cmel;
	chars_mobs_npcs[i].atkr=tmpclass2.atkr;
	chars_mobs_npcs[i].arng=tmpclass2.arng;
	chars_mobs_npcs[i].brng=tmpclass2.brng;
	chars_mobs_npcs[i].crng=tmpclass2.crng;]]
	
	chars_mobs_npcs[i].melee_stats = {rh={atkm=0,amel=0,bmel=0,cmel=0},lh={atkm=0,amel=0,bmel=0,cmel=0},rh1={atkm=0,amel=0,bmel=0,cmel=0},lh1={atkm=0,amel=0,bmel=0,cmel=0},rh2={atkm=0,amel=0,bmel=0,cmel=0},lh2={atkm=0,amel=0,bmel=0,cmel=0}};
	chars_mobs_npcs[i].arms_health = {rh=1,lh=1,rh1=1,lh1=1,rh2=1,lh2=1};
	chars_mobs_npcs[i].arms = tmpclass2.arms;
	
	chars_mobs_npcs[i].aggro=0;
	chars_mobs_npcs[i].aggressor = 0;

	chars_mobs_npcs[i].mgt_buff_power = 0;
	chars_mobs_npcs[i].mgt_buff_dur = 0;
	chars_mobs_npcs[i].enu_buff_power = 0;
	chars_mobs_npcs[i].enu_buff_dur = 0;
	chars_mobs_npcs[i].dex_buff_power = 0;
	chars_mobs_npcs[i].dex_buff_dur = 0;
	chars_mobs_npcs[i].spd_buff_power = 0;
	chars_mobs_npcs[i].spd_buff_dur = 0;
	chars_mobs_npcs[i].acu_buff_power = 0;
	chars_mobs_npcs[i].acu_buff_dur = 0;
	chars_mobs_npcs[i].sns_buff_power = 0;
	chars_mobs_npcs[i].sns_buff_dur = 0;
	chars_mobs_npcs[i].int_buff_power = 0;
	chars_mobs_npcs[i].int_buff_dur = 0;
	chars_mobs_npcs[i].spr_buff_power = 0;
	chars_mobs_npcs[i].spr_buff_dur = 0;
	chars_mobs_npcs[i].chr_buff_power = 0;
	chars_mobs_npcs[i].chr_buff_dur = 0;
	chars_mobs_npcs[i].luk_buff_power = 0;
	chars_mobs_npcs[i].luk_buff_dur = 0;
	chars_mobs_npcs[i].ac_buff_power = 0;
	chars_mobs_npcs[i].ac_buff_dur = 0;

	chars_mobs_npcs[i].mgt_debuff_power = 0;
	chars_mobs_npcs[i].mgt_debuff_dur = 0;
	chars_mobs_npcs[i].enu_debuff_power = 0;
	chars_mobs_npcs[i].enu_debuff_dur = 0;
	chars_mobs_npcs[i].dex_debuff_power = 0;
	chars_mobs_npcs[i].dex_debuff_dur = 0;
	chars_mobs_npcs[i].spd_debuff_power = 0;
	chars_mobs_npcs[i].spd_debuff_dur = 0;
	chars_mobs_npcs[i].acu_debuff_power = 0;
	chars_mobs_npcs[i].acu_debuff_dur = 0;
	chars_mobs_npcs[i].sns_debuff_power = 0;
	chars_mobs_npcs[i].sns_debuff_dur = 0;
	chars_mobs_npcs[i].int_debuff_power = 0;
	chars_mobs_npcs[i].int_debuff_dur = 0;
	chars_mobs_npcs[i].spr_debuff_power = 0;
	chars_mobs_npcs[i].spr_debuff_dur = 0;
	chars_mobs_npcs[i].chr_debuff_power = 0;
	chars_mobs_npcs[i].chr_debuff_dur = 0;
	chars_mobs_npcs[i].luk_debuff_power = 0;
	chars_mobs_npcs[i].luk_debuff_dur = 0;
	chars_mobs_npcs[i].ac_debuff_power = 0;
	chars_mobs_npcs[i].ac_debuff_dur = 0;

	chars_mobs_npcs[i].recmel=tmpclass2.recmel;
	chars_mobs_npcs[i].recrng=tmpclass2.recrng;
	chars_mobs_npcs[i].recmag=tmpclass2.recmag;

	chars_mobs_npcs[i].preservation=0;
	
	chars_mobs_npcs[i].battleai=tmpclass2.battleai;
	chars_mobs_npcs[i].freeze=0;
	chars_mobs_npcs[i].stone=0;
	chars_mobs_npcs[i].paralyze=0;
	chars_mobs_npcs[i].stun=0;
	chars_mobs_npcs[i].sleep=0;
	chars_mobs_npcs[i].immobilize = 0;
	chars_mobs_npcs[i].drunk=0;
	chars_mobs_npcs[i].insane=0;
	chars_mobs_npcs[i].charm=0;
	chars_mobs_npcs[i].berserk=0;
	chars_mobs_npcs[i].enslave=0;
	chars_mobs_npcs[i].fear = 0;
	chars_mobs_npcs[i].panic = 0;
	chars_mobs_npcs[i].silence = 0;
	chars_mobs_npcs[i].madness = 0;
	chars_mobs_npcs[i].filth_power = 0;
	chars_mobs_npcs[i].filth_dur = 0;
	chars_mobs_npcs[i].darkgasp = 0;
	chars_mobs_npcs[i].despondency_power = 0;
	chars_mobs_npcs[i].despondency_dur = 0;
	chars_mobs_npcs[i].misfortune_power = 0;
	chars_mobs_npcs[i].misfortune_dur = 0;
	chars_mobs_npcs[i].blind_power = 0;
	chars_mobs_npcs[i].blind_dur = 0;
	chars_mobs_npcs[i].dark_gasp = 0;
	
	chars_mobs_npcs[i].flame_power = 0;
	chars_mobs_npcs[i].flame_dur = 0;
	chars_mobs_npcs[i].firebelt_power = 0;
	chars_mobs_npcs[i].firebelt_dur = 0;
	chars_mobs_npcs[i].fireprint_power = 0;
	chars_mobs_npcs[i].fireprint_dur = 0;
	chars_mobs_npcs[i].poison_power = 0;
	chars_mobs_npcs[i].poison_dur = 0;
	chars_mobs_npcs[i].poison_status=0;
	chars_mobs_npcs[i].cold_power = 0;
	chars_mobs_npcs[i].cold_dur = 0;
	chars_mobs_npcs[i].acid_power = 0;
	chars_mobs_npcs[i].acid_dur = 0;
	chars_mobs_npcs[i].bleeding=0;
	chars_mobs_npcs[i].pneumothorax=0;
	chars_mobs_npcs[i].disease=0;

	chars_mobs_npcs[i].protfromfire_power = 0;
	chars_mobs_npcs[i].protfromfire_dur = 0;
	chars_mobs_npcs[i].protfromcold_power = 0;
	chars_mobs_npcs[i].protfromcold_dur = 0;
	chars_mobs_npcs[i].protfromstatic_power = 0;
	chars_mobs_npcs[i].protfromstatic_dur = 0;
	chars_mobs_npcs[i].protfromacid_power = 0;
	chars_mobs_npcs[i].protfromacid_dur = 0;
	chars_mobs_npcs[i].protofspirit_power = 0;
	chars_mobs_npcs[i].protofspirit_dur = 0;
	chars_mobs_npcs[i].protfrompoison_power = 0;
	chars_mobs_npcs[i].protfrompoison_dur = 0;
	chars_mobs_npcs[i].protfromdisease_power = 0;
	chars_mobs_npcs[i].protfromdisease_dur = 0;
	chars_mobs_npcs[i].protofmind_power = 0;
	chars_mobs_npcs[i].protofmind_dur = 0;
	chars_mobs_npcs[i].shield = 0;
	chars_mobs_npcs[i].stoneskin_power = 0;
	chars_mobs_npcs[i].stoneskin_dur = 0;
	chars_mobs_npcs[i].ironshirt_power = 0;
	chars_mobs_npcs[i].ironshirt_dur = 0;
	chars_mobs_npcs[i].hammerhands_power = 0;
	chars_mobs_npcs[i].hammerhands_dur = 0;
	chars_mobs_npcs[i].shieldfromfire_power = 0;
	chars_mobs_npcs[i].shieldfromfire_dur = 0;
	chars_mobs_npcs[i].shieldfromcold_power = 0;
	chars_mobs_npcs[i].shieldfromcold_dur = 0;
	chars_mobs_npcs[i].shieldfromstatic_power = 0;
	chars_mobs_npcs[i].shieldfromstatic_dur = 0;
	chars_mobs_npcs[i].shieldfromacid_power = 0;
	chars_mobs_npcs[i].shieldfromacid_dur = 0;
	
	chars_mobs_npcs[i].bless = 0;
	chars_mobs_npcs[i].fate = 0;
	chars_mobs_npcs[i].fateself = 0;
	chars_mobs_npcs[i].heroism_power = 0;
	chars_mobs_npcs[i].heroism_dur = 0;
	chars_mobs_npcs[i].prayer_power = 0
	chars_mobs_npcs[i].prayer_dur = 0
	chars_mobs_npcs[i].rage = 0;
	chars_mobs_npcs[i].thirstofblood = 0;
	chars_mobs_npcs[i].curse = 0;
	chars_mobs_npcs[i].regen_power = 0;
	chars_mobs_npcs[i].regen_dur = 0;
	chars_mobs_npcs[i].healaura_power = 0;
	chars_mobs_npcs[i].healaura_dur = 0;
	chars_mobs_npcs[i].haste=0;
	chars_mobs_npcs[i].mobility_dur = 0;
	chars_mobs_npcs[i].mobility_power = 0;
	chars_mobs_npcs[i].torchlight_dur = 0;
	chars_mobs_npcs[i].torchlight_power = 0;
	chars_mobs_npcs[i].executor_dur = 0;
	chars_mobs_npcs[i].executor_power = 0;
	chars_mobs_npcs[i].hourofpower_dur = 0;
	chars_mobs_npcs[i].hourofpower_power = 0;
	chars_mobs_npcs[i].shieldoflight = 0;
	chars_mobs_npcs[i].wingsoflight= 0;
	chars_mobs_npcs[i].slow= 0;
	chars_mobs_npcs[i].myrth_power = 0;
	chars_mobs_npcs[i].myrth_dur = 0;
	chars_mobs_npcs[i].invisibility=0;
	chars_mobs_npcs[i].painreflection=0;
	chars_mobs_npcs[i].waterwalking=0;
	chars_mobs_npcs[i].levitation=0;
	
	chars_mobs_npcs[i].might_power = 0;
	chars_mobs_npcs[i].might_dur = 0;
	chars_mobs_npcs[i].dash_power = 0;
	chars_mobs_npcs[i].dash_dur = 0;
	chars_mobs_npcs[i].precision_power = 0;
	chars_mobs_npcs[i].precision_dur = 0;
	chars_mobs_npcs[i].concentration_power = 0;
	chars_mobs_npcs[i].concentration_dur = 0;
	chars_mobs_npcs[i].glamour_power = 0;
	chars_mobs_npcs[i].glamour_dur = 0;
	chars_mobs_npcs[i].luckyday_power = 0;
	chars_mobs_npcs[i].luckyday_dur = 0;

	chars_mobs_npcs[i].num_unarmed=tmpclass2.num_unarmed;
	chars_mobs_npcs[i].lvl_unarmed=tmpclass2.lvl_unarmed;
	chars_mobs_npcs[i].num_sword=tmpclass2.num_sword;
	chars_mobs_npcs[i].lvl_sword=tmpclass2.lvl_sword;
	chars_mobs_npcs[i].num_axe=tmpclass2.num_axe;
	chars_mobs_npcs[i].lvl_axe=tmpclass2.lvl_axe;
	chars_mobs_npcs[i].num_crushing=tmpclass2.num_crushing;
	chars_mobs_npcs[i].lvl_crushing=tmpclass2.lvl_crushing;
	chars_mobs_npcs[i].num_flagpole=tmpclass2.num_flagpole;
	chars_mobs_npcs[i].lvl_flagpole=tmpclass2.lvl_flagpole;
	chars_mobs_npcs[i].num_dagger=tmpclass2.num_dagger;
	chars_mobs_npcs[i].lvl_dagger=tmpclass2.lvl_dagger;
	chars_mobs_npcs[i].num_staff=tmpclass2.num_staff;
	chars_mobs_npcs[i].lvl_staff=tmpclass2.lvl_staff;
	chars_mobs_npcs[i].num_bow=tmpclass2.num_bow;
	chars_mobs_npcs[i].lvl_bow=tmpclass2.lvl_bow;
	chars_mobs_npcs[i].num_crossbow=tmpclass2.num_crossbow;
	chars_mobs_npcs[i].lvl_crossbow=tmpclass2.lvl_crossbow;
	chars_mobs_npcs[i].num_throwing=tmpclass2.num_throwing;
	chars_mobs_npcs[i].lvl_throwing=tmpclass2.lvl_throwing;
	chars_mobs_npcs[i].num_firearms=tmpclass2.num_firearms;
	chars_mobs_npcs[i].lvl_firearms=tmpclass2.lvl_firearms;

	chars_mobs_npcs[i].num_dodging=tmpclass2.dodging_sword;
	chars_mobs_npcs[i].lvl_dodging=tmpclass2.dodging_sword;
	chars_mobs_npcs[i].num_shield=tmpclass2.num_shield;
	chars_mobs_npcs[i].lvl_shield=tmpclass2.lvl_shield;
	chars_mobs_npcs[i].num_leather=tmpclass2.num_leather;
	chars_mobs_npcs[i].lvl_leather=tmpclass2.lvl_leather;
	chars_mobs_npcs[i].num_chainmail=tmpclass2.num_chainmail;
	chars_mobs_npcs[i].lvl_chainmail=tmpclass2.lvl_chainmail;
	chars_mobs_npcs[i].num_plate=tmpclass2.num_plate;
	chars_mobs_npcs[i].lvl_plate=tmpclass2.lvl_plate;

	chars_mobs_npcs[i].num_fire=tmpclass2.num_fire;
	chars_mobs_npcs[i].lvl_fire=tmpclass2.lvl_fire;
	chars_mobs_npcs[i].num_water=tmpclass2.num_water;
	chars_mobs_npcs[i].lvl_water=tmpclass2.lvl_water;
	chars_mobs_npcs[i].num_air=tmpclass2.num_air;
	chars_mobs_npcs[i].lvl_air=tmpclass2.lvl_air;
	chars_mobs_npcs[i].num_earth=tmpclass2.num_earth;
	chars_mobs_npcs[i].lvl_earth=tmpclass2.lvl_earth;
	chars_mobs_npcs[i].num_body=tmpclass2.num_body;
	chars_mobs_npcs[i].lvl_body=tmpclass2.lvl_body;
	chars_mobs_npcs[i].num_mind=tmpclass2.num_mind;
	chars_mobs_npcs[i].lvl_mind=tmpclass2.lvl_mind;
	chars_mobs_npcs[i].num_spirit=tmpclass2.num_spirit;
	chars_mobs_npcs[i].lvl_spirit=tmpclass2.lvl_spirit;
	chars_mobs_npcs[i].num_light=tmpclass2.num_light;
	chars_mobs_npcs[i].lvl_light=tmpclass2.lvl_light;
	chars_mobs_npcs[i].num_darkness=tmpclass2.num_darkness;
	chars_mobs_npcs[i].lvl_darkness=tmpclass2.lvl_darkness;

	chars_mobs_npcs[i].num_alchemy=tmpclass2.num_alchemy;
	chars_mobs_npcs[i].lvl_alchemy=tmpclass2.lvl_alchemy;
	chars_mobs_npcs[i].num_repair=tmpclass2.num_repair;
	chars_mobs_npcs[i].lvl_repair=tmpclass2.lvl_repair;
	chars_mobs_npcs[i].num_bodybuilding=tmpclass2.num_bodybuilding;
	chars_mobs_npcs[i].lvl_bodybuilding=tmpclass2.lvl_bodybuilding;
	chars_mobs_npcs[i].num_armmastery=tmpclass2.num_armmastery;
	chars_mobs_npcs[i].lvl_armmastery=tmpclass2.lvl_armmastery;
	chars_mobs_npcs[i].num_meditation=tmpclass2.num_meditation;
	chars_mobs_npcs[i].lvl_meditation=tmpclass2.lvl_meditation;
	chars_mobs_npcs[i].num_mysticism=tmpclass2.num_spirit;
	chars_mobs_npcs[i].lvl_mysticism=tmpclass2.lvl_mysticism;
	chars_mobs_npcs[i].num_trading=tmpclass2.num_trading;
	chars_mobs_npcs[i].lvl_trading=tmpclass2.lvl_trading;
	chars_mobs_npcs[i].num_diplomacy=tmpclass2.num_diplomacy;
	chars_mobs_npcs[i].lvl_diplomacy=tmpclass2.lvl_diplomacy;
	chars_mobs_npcs[i].num_stealth=tmpclass2.num_stealth;
	chars_mobs_npcs[i].lvl_stealth=tmpclass2.lvl_stealth;
	chars_mobs_npcs[i].num_dodging=tmpclass2.num_dodging;
	chars_mobs_npcs[i].lvl_dodging=tmpclass2.lvl_dodging;
	chars_mobs_npcs[i].num_picklocking=tmpclass2.num_picklocking;
	chars_mobs_npcs[i].lvl_picklocking=tmpclass2.lvl_picklocking;
	chars_mobs_npcs[i].num_traps=tmpclass2.num_traps;
	chars_mobs_npcs[i].lvl_traps=tmpclass2.lvl_traps;
	chars_mobs_npcs[i].num_spothidden=tmpclass2.num_spothidden;
	chars_mobs_npcs[i].lvl_spothidden=tmpclass2.lvl_spothidden;
	chars_mobs_npcs[i].num_monsterid=tmpclass2.num_monsterid;
	chars_mobs_npcs[i].lvl_monsterid=tmpclass2.lvl_monsterid;
	chars_mobs_npcs[i].num_stuffid=tmpclass2.num_stuffid;
	chars_mobs_npcs[i].lvl_stuffid=tmpclass2.lvl_stuffid;
	chars_mobs_npcs[i].num_thievery=tmpclass2.num_thievery;
	chars_mobs_npcs[i].lvl_thievery=tmpclass2.lvl_thievery;
	chars_mobs_npcs[i].num_leadership= tmpclass2.num_leadership
	chars_mobs_npcs[i].lvl_leadership= tmpclass2.lvl_leadership
	chars_mobs_npcs[i].num_regeneration= tmpclass2.num_regeneration
	chars_mobs_npcs[i].lvl_regeneration= tmpclass2.lvl_regeneraton

	chars_mobs_npcs[i].rezfire=tmpclass2.rezfire;
	chars_mobs_npcs[i].rezcold=tmpclass2.rezcold;
	chars_mobs_npcs[i].rezstatic=tmpclass2.rezstatic;
	chars_mobs_npcs[i].rezpoison=tmpclass2.rezpoison;
	chars_mobs_npcs[i].rezacid=tmpclass2.rezacid;
	chars_mobs_npcs[i].rezdisease=tmpclass2.rezdisease;
	chars_mobs_npcs[i].rezmind=tmpclass2.rezmind;
	chars_mobs_npcs[i].rezspirit=tmpclass2.rezspirit;
	chars_mobs_npcs[i].rezlight=tmpclass2.rezlight;
	chars_mobs_npcs[i].rezdarkness=tmpclass2.rezdarkness;
	chars_mobs_npcs[i].rezzero=0; -- hack for non elemental damage
	
	chars_mobs_npcs[i].hp_max = chars_mobs_npcs[i].hp_base + chars_mobs_npcs[i].hp_coff * chars_mobs_npcs[i].enu + chars_mobs_npcs[i].num_bodybuilding*chars_mobs_npcs[i].lvl_bodybuilding;
	chars_mobs_npcs[i].sp_max = chars_mobs_npcs[i].sp_base + chars_mobs_npcs[i].sp_coff * chars_mobs_npcs[i].sp_stat + chars_mobs_npcs[i].num_mysticism*chars_mobs_npcs[i].lvl_mysticism;
	chars_mobs_npcs[i].st_max = 200 + chars_mobs_npcs[i].st_base + chars_mobs_npcs[i].st_coff * chars_mobs_npcs[i].enu;
	
	chars_mobs_npcs[i].hp = chars_mobs_npcs[i].hp_max;
	chars_mobs_npcs[i].sp = chars_mobs_npcs[i].sp_max;
	chars_mobs_npcs[i].st = chars_mobs_npcs[i].st_max;
	chars_mobs_npcs[i].rt = 200;
	
	if tmpclass2.sp_limit then
		chars_mobs_npcs[i].sp_limit = tmpclass2.sp_limit;
	end;
		
	chars_mobs_npcs[i].hp_regeneration = tmpclass2.hp_regeneration;
	chars_mobs_npcs[i].sp_regeneration = tmpclass2.sp_regeneration;
	chars_mobs_npcs[i].st_regeneration = tmpclass2.st_regeneration;	
	chars_mobs_npcs[i].moral = 0;	
	chars_mobs_npcs[i].base_moral = tmpclass2.moral;
	
	chars_mobs_npcs[i].revenge_type = tmpclass2.revenge_type;
	chars_mobs_npcs[i].revenge_power = tmpclass2.revenge_power;
	
	if person ~= "char" then
		if tmpclass2.loot_gold_max > 0 then
			chars_mobs_npcs[i].gold = math.random(tmpclass2.loot_gold_min,tmpclass2.loot_gold_max);
		else
			chars_mobs_npcs[i].gold = 0;
		end;
		local packofgold = 0
		if chars_mobs_npcs[i].gold > 0 and chars_mobs_npcs[i].gold <= 10 then
			packofgold = 379;
		elseif chars_mobs_npcs[i].gold > 10 and chars_mobs_npcs[i].gold <= 100 then
			packofgold = 380;
		elseif chars_mobs_npcs[i].gold > 100 and chars_mobs_npcs[i].gold <= 1000 then
			packofgold = 381;
		elseif chars_mobs_npcs[i].gold > 1000 then
			packofgold = 382;
		end;
		if packofgold > 0 then
			table.insert(chars_mobs_npcs[i].inventory_list,{ttxid=packofgold,q= chars_mobs_npcs[i].gold,w=0,e=0,r = 1,h=0});
		end;
	end;
end;

function helpers.countSkills (index)
	temporal_skills = {};
	for i=1,#skills do
		local tmpnum1 = "chars_mobs_npcs[" .. index .. "].num_" .. skills[i];
		local tmpnum2 = loadstring("return " .. tmpnum1)();
		temporal_skills[i] = tmpnum2;
	end;
	temp_skillpoints = chars_mobs_npcs[index].skillpoints;
end;

function helpers.applySkills (index)
	for i=1,40 do
		chars_mobs_npcs[index]["num_" .. skills[i]] = temporal_skills[i];
	end;
	chars_mobs_npcs[index].skillpoints = temp_skillpoints;
	game_status = "neutral";
	loveframes.util.RemoveAll();
end;

function helpers.interrupt ()
	path_counter = 0;
	game_status = "neutral";
	helpers.neutralWatch ();
	path_status = 0;
	hang = 0;
	mob_is_goung_to_hit = 0;
end;

function helpers.cam_to_mob ()
	if chars_mobs_npcs[current_mob].x >= 15 then
		map_x = chars_mobs_npcs[current_mob].x - 12;
	else 
		map_x = 0;
	end;
	if chars_mobs_npcs[current_mob].y >= 30 then
		map_y = chars_mobs_npcs[current_mob].y - 18;
	else
		map_y = 0;
	end;
	helpers.castShadows();
end;

function helpers.cam_to_hex (x,y)
	map_x = x-map_x;
	map_y = y-map_y;
	helpers.castShadows();
end;

function helpers.neutralWatch ()
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].control == "player" then
			trace.first_watch(i);
		end;
	end;
end;

function helpers.lightIsNear(x,y)
	local ring = boomareas.smallRingArea(x,y);
	for i=1,#ring do
		if dlandscape_obj[ring[i].x][ring[i].y] == "fire"  then
			return true;	
		end;
	end;
	return false;
end;

function helpers.castShadows ()
	if shadows then
		for i=1,#shadows do
			shadows[i]["shadow"].clear();
		end;
	end;
	shadows = {};
	for my=1, math.min(map_display_h, map_h-map_y) do
		for mx=1, math.min(map_display_w, map_w-map_x) do		
			if map[my+map_y][mx+map_x]>120 and map[my+map_y][mx+map_x] <= 220 and visibility_table[map[my+map_y][mx+map_x]] == 1 then --check in future
				local xx,yy =  helpers.hexToPixels(mx,my);
				table.insert(shadows,{x=mx,y=my,shadow = lightWorld.newCircle(xx, yy, 20),typ="obj"});
			end;
		end;
	end;
end;

function helpers.clearMissleLight ()
	for h=#lights,1,-1 do
		if lights[h].typ == "missle" then
			lights[h]["light"].clear();
			table.remove(lights,i);
		end;
	end;
end;

function helpers.clearBoomLight ()
	for h=#lights,1,-1 do
		if lights[h].typ == "boom" then
			lights[h]["light"].clear();
			table.remove(lights,i);
		end;
	end;
end;

function helpers.takenFromWhere (bagtype)
	local from = "";
	if bagtype == "bag" then
		from = lognames.actions.frombag;	
	elseif bagtype.typ == "chest" then
		from = lognames.actions.chest;
	elseif bagtype == "safe" then
		from = lognames.actions.fromsafe;
	elseif bagtype == "secret" then
		from = lognames.actions.fromsecret;
	end;
	return from;
end;

function helpers.countFulness(bag)
	local fullness = 0;
	for i=1,11 do
		for h=1,15 do
			if bag[h][i] > 0 then
				fullness = fullness +1;
			end;
		end;
	end;
	return fullness;
end;

function helpers.whatSortTarget(sorttarget,start,exchange,index)
	local list = nil;
	local bag = nil;
	local tmp_bagid = nil;
	if index then
		tmp_bagid = index;
	end;
	if sorttarget == "char" then
		if global.start then
			tmp_bagid = selected_char;
		else
			if not exchange then
				tmp_bagid = current_mob;
			elseif exchange then
				tmp_bagid = selected_portrait;
			end;
			--exchange = false;
		end;
		local liststring = "chars_mobs_npcs[" .. tmp_bagid .. ']["inventory_list"]';
		list = loadstring("return " .. liststring)();
		bag = loadstring("return " .. "inventory_bag")();
	elseif sorttarget == "bag" then
		if global.start then
			tmp_bagid = selected_char;
		else
			tmp_bagid = bagid;
		end;
		local liststring = "bags_list[" .. tmp_bagid .. "]";
		list = loadstring("return " .. liststring)();
		bag = loadstring("return " .. "bags")();
	end;
	return list,bag,tmp_bagid;
end;

function helpers.findNonFreeSpaceAtInv (bagid,sorttarget,start,exchange)
	local list,bag,noneed = helpers.whatSortTarget(sorttarget,false,false,bagid);
	for a=1,11 do
		for b=1,15 do
			if bagid>0 and bagremoved==0 and bag[bagid][b][a]>=10000 then
				bag[bagid][b][a]=0;
			end;
		end;
	end;
	for i=1,11 do
		for h=1,15 do
			if bagid>0 and bagremoved==0 and bag[bagid][h][i]~=0 and bag[bagid][h][i]<10000 then
				local tmp1=bag[bagid][h][i];
				--local tmp2=list[bagid][tmp1].ttxid;
				local tmp2=list[tmp1].ttxid;
				for a=1,11 do
					for b=1,15 do
						if a < i+inventory_ttx[tmp2].w and a >= i and b<h+inventory_ttx[tmp2].h and b >= h and  bag[bagid][b][a] == 0 then
							bag[bagid][b][a] = i*10000+h;
						end;
					end;
				end;
			end;
		end;
	end;
	bagremoved = 0;
end;

function helpers.clearLights (x,y)
	for i=#lights,1,-1 do
		if lights[i].typ == "ground" and lights[i].x == x and lights[i].y == y then
			lights[i]["light"].clear();
			table.remove(lights,i);
		end;
	end;
end;

function helpers.findShadows()
	local universal_darkness={};
	local environment_light = 0;
	if leveltype == "openair" then
		if irradiation == "day" then
			environment_light = 5;
		elseif irradiation == "twilight" then
			environment_light = 2;
		elseif irradiation == "night" then
			environment_light = 1;
		elseif irradiation == "dawn" or irradiation == "afterglow" then
			environment_light = 3;
		elseif irradiation == "firelight" then
			environment_light = 3;
		elseif irradiation == "dungeon" then
			environment_light = 0;
		end;
	else
		environment_light = 0;
	end;
	for i=1, map_w do
		for z=1, map_h do
			slandscape[i][z] = environment_light;
		end;
	end;
	
	if map_x < 12 then
		mxx = 1
	else
		mxx = -10
	end;
	if map_y < 12 then
		myy = 1
	else
		myy = -10
	end;
	for z=map_y+myy, math.min(map_display_h, map_h-map_y) do
		for i=map_x+mxx, math.min(map_display_w, map_w-map_x) do
			if dlandscape_obj[i][z] == "fire" or dlandscape_obj[i][z] == "light" then --nil
				slandscape[i][z] = math.max(4,environment_light,slandscape[i][z]);
				local rings = boomareas.ringArea(z,i);
				for i=1,#rings[1] do
					if helpers.insideMap(rings[1][i].y,rings[1][i].x) then
						slandscape[rings[1][i].y][rings[1][i].x] = math.max(3,environment_light,slandscape[rings[1][i].y][rings[1][i].x]);
					end;
				end;
				for i=1,#rings[2] do
					if helpers.insideMap(rings[2][i].y,rings[2][i].x) then
						slandscape[rings[2][i].y][rings[2][i].x] = math.max(2,environment_light,slandscape[rings[2][i].y][rings[2][i].x]);
					end;
				end;
				for i=1,#rings[3] do
					if helpers.insideMap(rings[3][i].y,rings[3][i].x) then
						slandscape[rings[3][i].y][rings[3][i].x] = math.max(1,environment_light,slandscape[rings[3][i].y][rings[3][i].x]);
					end;
				end;
			end;
			if alandscape_obj[i][z] == "poison" or dlandscape_obj[i][z] == "rotten" then
				slandscape[i][z] = math.max(3,environment_light,slandscape[i][z]);
				local rings = boomareas.ringArea(z,i);
				for i=1,#rings[1] do
					if helpers.insideMap(rings[1][i].y,rings[1][i].x) then
						slandscape[rings[1][i].y][rings[1][i].x] = math.max(2,environment_light,slandscape[rings[1][i].y][rings[1][i].x]);
					end;
				end;
				for i=1,#rings[2] do
					if helpers.insideMap(rings[2][i].y,rings[2][i].x) then
						slandscape[rings[2][i].y][rings[2][i].x] = math.max(1,environment_light,slandscape[rings[2][i].y][rings[2][i].x]);
					end;
				end;
			end;
		end;
	end;
	for j=1,#chars_mobs_npcs do
		if chars_mobs_npcs[j].torchlight_dur > 0 and chars_mobs_npcs[j].y == i and  chars_mobs_npcs[j].x == z then
			slandscape[z][i] = math.max(4,environment_light);
			for i=1,#rings[1] do
				if helpers.insideMap(rings[1][i].y,rings[1][i].x) then
					slandscape[rings[1][i].y][rings[1][i].x] = math.max(3,environment_light,slandscape[rings[1][i].y][rings[1][i].x]);
				end;
			end;
			for i=1,#rings[2] do
				if helpers.insideMap(rings[2][i].y,rings[2][i].x) then
					slandscape[rings[2][i].y][rings[2][i].x] = math.max(2,environment_light,slandscape[rings[2][i].y][rings[2][i].x]);
				end;
			end;
			for i=1,#rings[3] do
				if helpers.insideMap(rings[3][i].y,rings[3][i].x) then
					slandscape[rings[3][i].y][rings[3][i].x] = math.max(1,environment_light,slandscape[rings[3][i].y][rings[3][i].x]);
				end;
			end;	
		end;
	end;
end;

function helpers.blindedWithLight (index,x,y) --check x/y FIXME
	local unidarkness = {};
	unidarkness = darkness[chars_mobs_npcs[index].party];
	local rings = boomareas.ringArea(chars_mobs_npcs[index].x,chars_mobs_npcs[index].y);
	for h=1,3 do
		for i=1,#rings[h] do
			if rings[h][i].x > 0 and rings[h][i].y > 0 and unidarkness[rings[h][i].x][rings[h][i].y] == 0 and slandscape[rings[h][i].x][rings[h][i].y] > slandscape[x][y] then
				return true;
			end;
		end;
	end;
	return false;
end;

function helpers.visualConditions (index,x,y) --check x/y FIXME
	local vis = math.abs(5 - (chars_mobs_npcs[index].nightvision + slandscape[x][y]));
	return vis;
end;

function helpers.countMeleeRecoveryChar (index)
	local recovery = 0;
	local skillweaponrecovery = 0;
	local armmasteryrecovery = 0;
	local secondarmrecovery = 0;
	local armorrecovery = 0;
	local shieldrecovery = 0;
	local speedrecovery = 0;
	
	if chars_mobs_npcs[index]["equipment"].rh > 0 then
		recovery = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].rh].ttxid].rt;
	elseif chars_mobs_npcs[index]["equipment"].rh == 0 then
		recovery = 50;
	end;
	if chars_mobs_npcs[index]["equipment"].lh > 0 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].class ~= "shield" then
		if chars_mobs_npcs[index].lvl_armmastery < 4 then
			secondarmrecovery = math.ceil(0.5*inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].rt);
		elseif chars_mobs_npcs[index].lvl_armmastery == 4 then
			secondarmrecovery = math.ceil(0.25*inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].rt);
		elseif chars_mobs_npcs[index].lvl_armmastery == 5 then
			secondarmrecovery = 0;
		end;
	end;
	
	if chars_mobs_npcs[index]["equipment"].rh == 0 and chars_mobs_npcs[index].lvl_unarmed >= 3 then
		 skillweaponrecovery =  math.min(20,chars_mobs_npcs[index].num_unarmed);
	elseif chars_mobs_npcs[index]["equipment"].rh > 0 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].rh].ttxid].class == "sword" and chars_mobs_npcs[index].lvl_sword >= 3 then
		skillweaponrecovery =  math.min(20,chars_mobs_npcs[index].num_sword);
	elseif chars_mobs_npcs[index]["equipment"].rh > 0 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].rh].ttxid].class == "axe" and chars_mobs_npcs[index].lvl_axe >= 3 then
		skillweaponrecovery =  math.min(20,chars_mobs_npcs[index].num_axe);
	elseif chars_mobs_npcs[index]["equipment"].rh > 0 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].rh].ttxid].class == "staff" and chars_mobs_npcs[index].lvl_staff == 5 then
		skillweaponrecovery =  math.min(20,chars_mobs_npcs[index].num_unarmed);
	end;
	
	if chars_mobs_npcs[index].num_armmastery > 0 and chars_mobs_npcs[index].lvl_armmastery <= 4 then
		armmasteryrecovery = math.min(20,chars_mobs_npcs[index].num_armmastery);
	elseif chars_mobs_npcs[index].num_armmastery > 0 and chars_mobs_npcs[index].lvl_armmastery == 4 then
		armmasteryrecovery = math.min(50,2*chars_mobs_npcs[index].num_armmastery);
	end;
	
	recovery = math.max(10,recovery + secondarmrecovery - (skillweaponrecovery + armmasteryrecovery));
	
	if chars_mobs_npcs[index]["equipment"].lh > 0 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].class == "shield" then
		if chars_mobs_npcs[index].lvl_shield < 3 then
			recovery = recovery + inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].rt;
		else
			recovery = recovery + 5;
		end;
	end;

	if chars_mobs_npcs[index]["equipment"].armor > 0 then
		if inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "leather" and chars_mobs_npcs[index].lvl_leather < 3 then
			armorrecovery = 50 - math.max(10,math.ceil(chars_mobs_npcs[index].mgt/10)+math.ceil(chars_mobs_npcs[index].dex/2));
		elseif inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "leather" and chars_mobs_npcs[index].lvl_leather >= 3 then
			armorrecovery = 5;
		end;
		if inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "chain" and chars_mobs_npcs[index].lvl_chain < 4 then
			armorrecovery = 75 - math.max(25,math.ceil(chars_mobs_npcs[index].mgt/5)+math.ceil(chars_mobs_npcs[index].dex/5));
		elseif inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "chain" and chars_mobs_npcs[index].lvl_chain >= 4 then
			armorrecovery = 10;
		end;
		if inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "plate" and chars_mobs_npcs[index].lvl_plate < 4 then
			armorrecovery = 100 - math.max(50,math.ceil(chars_mobs_npcs[index].mgt/2)+math.ceil(chars_mobs_npcs[index].dex/10));
		elseif inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "plate" and chars_mobs_npcs[index].lvl_plate == 5 then
			armorrecovery = 20;
		end;
		recovery = recovery+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].rt;
	end
	
	recovery = math.max(10,recovery - math.ceil(chars_mobs_npcs[index].spd/5));
	
	return recovery;
end;

function helpers.countMeleeRecoveryMob (index)
	local recovery = 0;
	local speedrecovery = 0;
	recovery = chars_mobs_npcs[index].recmel;
	recovery = math.max(10,recovery - math.ceil(chars_mobs_npcs[index].spd/5));
	return recovery;
end;

function helpers.countRangeRecoveryChar (index)
	local recovery = 0;
	local skillweaponrecovery = 0;
	local armorrecovery = 0;
	local shieldrecovery = 0;
	local speedrecovery = 0;
		
	if chars_mobs_npcs[index]["equipment"].ranged > 0 then
		local prerecovery = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].rt;
		if inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].class == "bow" and chars_mobs_npcs[index].lvl_bow >= 3 then
			prerecovery = math.ceil(prerecovery/2);
		elseif inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].class == "crossbow"  and chars_mobs_npcs[index].lvl_crossbow >= 2 then
			prerecovery = math.ceil(prerecovery/2);
		elseif inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].class == "firearm"  and chars_mobs_npcs[index].lvl_firearms >= 4  then
			prerecovery = math.ceil(prerecovery/2);
		elseif inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].class == "blaster"  and chars_mobs_npcs[index].lvl_blaster == 5  then
			prerecovery = math.ceil(prerecovery/2);
		end;
		recovery = prerecovery;
	elseif chars_mobs_npcs[index]["equipment"].ranged == 0 and chars_mobs_npcs[index]["equipment"].ammo > 0 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].class == "throwing" then
		local prerecovery = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].throwing].ttxid].rt;
		if chars_mobs_npcs[index].lvl_throwing >= 4 then
			prerecovery = math.ceil(prerecovery/2);
		end;
		recovery = prerecovery;
	end;
	if chars_mobs_npcs[index]["equipment"].lh > 0 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].class == "shield" then
		if chars_mobs_npcs[index].lvl_shield < 3 then
			recovery = recovery + inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].rt;
		else
			recovery = recovery + 5;
		end;
	end;

	if chars_mobs_npcs[index]["equipment"].armor > 0 then
		if inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "leather" and chars_mobs_npcs[index].lvl_leather < 3 then
			armorrecovery = 50 - math.max(10,math.ceil(chars_mobs_npcs[index].mgt/10)+math.ceil(chars_mobs_npcs[index].dex/2));
		elseif inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "leather" and chars_mobs_npcs[index].lvl_leather >= 3 then
			armorrecovery = 5;
		end;
		if inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "chain" and chars_mobs_npcs[index].lvl_chain < 4 then
			armorrecovery = 75 - math.max(25,math.ceil(chars_mobs_npcs[index].mgt/5)+math.ceil(chars_mobs_npcs[index].dex/5));
		elseif inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "chain" and chars_mobs_npcs[index].lvl_chain >= 4 then
			armorrecovery = 10;
		end;
		if inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "plate" and chars_mobs_npcs[index].lvl_plate < 4 then
			armorrecovery = 100 - math.max(50,math.ceil(chars_mobs_npcs[index].mgt/2)+math.ceil(chars_mobs_npcs[index].dex/10));
		elseif inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "plate" and chars_mobs_npcs[index].lvl_plate == 5 then
			armorrecovery = 20;
		end;
		recovery = recovery+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].rt;
	end
	
	recovery = math.max(10,recovery - math.ceil(chars_mobs_npcs[index].spd/5));
	
	return recovery;
end;

function helpers.countBottleRecovery (index)
	local skillweaponrecovery = 0;
	if chars_mobs_npcs[index].lvl_throwing >= 4 then
		skillweaponrecovery = chars_mobs_npcs[index].num_throwing;
	end;
	local recovery = math.max(20,50 - math.ceil(chars_mobs_npcs[index].spd/10) - skillweaponrecovery);
	return recovery;	
end;

function helpers.countRangeRecoveryMob (index)
	local recovery = 0;
	local speedrecovery = 0;
	recovery = chars_mobs_npcs[index].recrng;
	recovery = math.max(10,recovery - math.ceil(chars_mobs_npcs[index].spd/5));
	return recovery;
end;

function helpers.countMagicRecovery (index,missle_type,missle_drive)
	local recovery = magic.spell_tips[missle_type].recovery;
	if missle_drive == "wand" then
		recovery = recovery + 15;
	elseif missle_drive == "scroll" then
		recovery = recovery + 25;
	end;
	recovery = math.max(10,recovery - math.ceil(chars_mobs_npcs[index].spd/5));
	return recovery;	
end;

function helpers.clearAiArrays()
	while (#mob_detects_enemies>0) do
		table.remove(mob_detects_enemies,1);
	end;
	while (#mob_detects_aggro>0) do
		table.remove(mob_detects_aggro,1);
	end;
end;

function helpers.countRange()
	if global.status == "battle" then
		local st_rt_limit = math.min(math.ceil(chars_mobs_npcs[current_mob].rt/5),math.ceil(chars_mobs_npcs[current_mob].st/5));
		local limit = math.min(chars_mobs_npcs[current_mob].rng,st_rt_limit);
		local _mob_range = math.max(0,limit-walked_before); --count walked before!
		if chars_mobs_npcs[current_mob].immobilize > 0 then
			_mob_range = 0;
		elseif chars_mobs_npcs[current_mob].wingsoflight > 0 then
			_mob_range = chars_mobs_npcs[current_mob].wingsoflight;
		end;
		return _mob_range;
	else
		_mob_range = 20;
		return _mob_range;
	end;
end;

function helpers.find_free_hexes_allmap ()
	local free_hexes = {};
	mob_range = helpers.countRange();
	for i=1,#all_ground_hexes do
		local _point_unavailable = true;
		if math.ceil(math.sqrt((all_ground_hexes[i].x-chars_mobs_npcs[current_mob].x)^2+(all_ground_hexes[i].y-chars_mobs_npcs[current_mob].y)^2)) > mob_range 
		or all_ground_hexes[i].pass ~= 0
		or all_ground_hexes[i].x <= map_limit_w 
		or all_ground_hexes[i].x >= map_w-map_limit_w 
		or all_ground_hexes[i].y <= map_limit_h 
		or all_ground_hexes[i].y >= map_h-map_limit_h
		or allmobs[all_ground_hexes[i].y][all_ground_hexes[i].x] ~= 0 then
			 _point_available = false;
		end;
		if _point_available and heights_table[map[all_ground_hexes[i].y][all_ground_hexes[i].x]] == 0 and allmobs[all_ground_hexes[i].y][all_ground_hexes[i].x]==0 then
			ai_world_x = all_ground_hexes[i].x;
			ai_world_y = all_ground_hexes[i].y;
			mob_can_move = 0;
			path_finding (0,0);
			if  path_status == 1 then
				table.insert(free_hexes,i);
			end;
		end;
	end;
	return free_hexes;
end;

function helpers.find_free_hexes (index)
	local mob_range = chars_mobs_npcs[index].rng-walked_before;
	local free_hexes = {};
	mob_range = helpers.countRange();
	for mx = math.max(1,chars_mobs_npcs[current_mob].x-mob_range),math.min(chars_mobs_npcs[current_mob].x+mob_range,map_w) do
		for my = math.max(1,chars_mobs_npcs[current_mob].y-mob_range),math.min(chars_mobs_npcs[current_mob].y+mob_range,map_h) do
			if helpers.passCheck(mx,my) and not helpers.aliveAtHex(mx,my) 
			and math.ceil(math.sqrt((mx-chars_mobs_npcs[current_mob].x)^2+(my-chars_mobs_npcs[current_mob].y)^2)) <= mob_range
			and helpers.passMove (mx,my,current_mob)
			then
				ai_world_x = mx;
				ai_world_y = my;
				mob_can_move = 0;
				path_finding (0,0);
				if path_status == 1 then
					local number_of_hex = (mx-1)*map_w+my;
					table.insert(free_hexes,number_of_hex);
				end;
			end;
		end;
	end;
	return free_hexes;
end;

function helpers.partyAlive ()
	local partyAlive = false;
	for i=1,chars do
		if chars_mobs_npcs[i].status > 0 then
			partyAlive = true;
		end;
	end;
	return partyAlive;
end;

function helpers.delta(i)
	local deltatime = math.min(i,1/30);
	return deltatime;
end;

function helpers.knockToDoor () --FIXME: housewatch then chat/buying/selling/npcidentify/npcrepair
 for i=1,#localtriggers do
	if chars_mobs_npcs[current_mob].x == localtriggers[i].x and chars_mobs_npcs[current_mob].y == localtriggers[i].y then
		chars_mobs_npcs[current_mob].rot = localtriggers[i].dir;
		current_house = localtriggers[i].id;
		game_status = "housewatch";
		return;
	end;
 end;
 local x,y = helpers.hexBehindMob(current_mob);
 local at_door,doorid,locked,traped = helpers.cursorAtClosedDoor(x,y);
 if at_door and not locked and not traped then
	bags_list[doorid].opened = true;
	bags_list[doorid].img_index = bags_list[doorid].img_index + 1;
	bags_list[doorid].img = door_img[bags_list[doorid].img_index];
	return;
 elseif at_door and (locked or traped) then --FIXME add trap detection
		bagid = doorid;
		game_status = "picklocking";
	return;
 end;
 local at_door,doorid = helpers.cursorAtOpenedDoor(x,y);
 if helpers.cursorAtOpenedDoor(x,y) then
	bags_list[doorid].opened = false;
	bags_list[doorid].img_index = bags_list[doorid].img_index - 1;
	bags_list[doorid].img = door_img[bags_list[doorid].img_index];
	return;
 end;
end;

function helpers.hexBehindMob(index)
	local y = chars_mobs_npcs[index].y + directions[1]["y"][chars_mobs_npcs[index].rot];
	local x = nil;
	if helpers.mobevenornot (index) then
		x = chars_mobs_npcs[index].x + directions[1]["xc"][chars_mobs_npcs[index].rot];
	else
		y = chars_mobs_npcs[index].x + directions[1]["xn"][chars_mobs_npcs[index].rot];
	end;
	return x,y;
end;

function helpers.cursorAtChest(x,y)
	for i=1,#bags_list do
		if bags_list[i].xi == x and bags_list[i].yi == y and bags_list[i].typ == "chest" then
			return true,bags_list[i].x,bags_list[i].y,bags_list[i].dir;
		end;
	end;
	return false,nil,nil,nil;
end;

function helpers.cursorAtClosedDoor(x,y) --FIXME doors are 2-sided
	for i=1,#bags_list do
		if bags_list[i].xi == x and bags_list[i].yi == y and bags_list[i].typ == "door" and not bags_list[i].opened then
			return true,i,bags_list[i].locked,bags_list[i].traped;
		end;
	end;
	return false,nil,nil;
end;

function helpers.cursorAtOpenedDoor(x,y) --FIXME doors are 2-sided
	for i=1,#bags_list do
		if bags_list[i].xi == x and bags_list[i].yi == y and bags_list[i].typ == "door" and bags_list[i].opened then
			return true,i;
		end;
	end;
	return false,nil;
end;

function helpers.cursorAtObject(x,y)
	for i=1,#objects_list do
		if objects_list[i].xi == x and objects_list[i].yi == y then
			return true;
		end;
	end;
	return false;
end;

function helpers.whatObject(x,y)
	for i=1,#objects_list do
		if objects_list[i].xi == x and objects_list[i].yi == y then
			return i;
		end;
	end;
	return 0;
end;

function helpers.useObject() --FIXME: pedestals for mobs too?
	local array_x = "";
	local array_y = directions[1].y
	local rot = chars_mobs_npcs[current_mob].rot;
	if helpers.mobevenornot (current_mob) then
		array_x = directions[1].xn;
	else
		array_x = directions[1].xc;
	end;
	if objects_list[global.object].typ == "barrel" and objects_list[global.object].subtyp > 0 then
		chars_stats[current_mob][global.stats_short[objects_list[global.object].subtyp]] = chars_stats[current_mob][global.stats_short[objects_list[global.object].subtyp]] + 5;
		helpers.recalcBattleStats(current_mob);
		objects_list[global.object].subtyp = 0;
		love.audio.play(media.sounds.drink,0);
		objects_list[global.object].img = barrel_img[1];
		global.object = 0;
		helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.drinkfrombarrel[chars_mobs_npcs[current_mob].gender]);
	elseif objects_list[global.object].typ == "cauldron" and objects_list[global.object].subtyp > 0 then
		chars_stats[current_mob][global.resistances[objects_list[global.object].subtyp]] = chars_stats[current_mob][global.resistances[objects_list[global.object].subtyp]] + 10;
		helpers.recalcResistances(current_mob);
		objects_list[global.object].subtyp = 0;
		love.audio.play(media.sounds.drink,0);
		objects_list[global.object].img = cauldron_img[1];
		helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.drinkfromcauldron[chars_mobs_npcs[current_mob].gender]);
		global.object = 0;
	elseif objects_list[global.object].typ == "pedestal" and chars_mobs_npcs[current_mob][objects_list[global.object].effext1] == 0 then
		chars_mobs_npcs[current_mob][objects_list[global.object].effext1] = chars_mobs_npcs[current_mob][objects_list[global.object].value1];
		if objects_list[global.object].effext2 then
			chars_mobs_npcs[current_mob][objects_list[global.object].effext2] = chars_mobs_npcs[current_mob][objects_list[global.object].value2];
			helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.usedpedestal[chars_mobs_npcs[current_mob].gender]); --FIXME type of pedestal
		end;
		global.object = 0;
	end;
end;

function helpers.trapInFrontOf(index)
	local array_x = "";
	local array_y = directions[1].y
	local rot = chars_mobs_npcs[index].rot;
	if helpers.mobevenornot (index) then
		array_x = directions[1].xn;
	else
		array_x = directions[1].xc;
	end;
	for i=1,#bags_list do
		if bags_list[i].xi ==  chars_mobs_npcs[index].x + array_x[rot] and bags_list[i].yi ==  chars_mobs_npcs[index].y + array_y[rot] and bags_list[i].typ == "trap" and bags_list[i].detected then
			return i;
		end;
	end;
	return false;
end;

function helpers.cursorAtBuilding(x,y)
	for i=1,#localtriggers do
		if cursor_world_x == localtriggers[i].x and cursor_world_y == localtriggers[i].y then
			return true,localtriggers[i].dir;
		end;
	end;
	return false,nil,nil,nil;
end;

function helpers.findNPCindex(index)
	local newindex = 0;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].uid == index then
			return i;
		end;
	end;
	return nil;
end;

function helpers.voidIsNotaProblem(xa,ya,xb,yb)
	if helpers.insideMap(xa,ya) and helpers.insideMap(xb,yb) and vlandscape_id[xa][ya] ~= vlandscape_id[xb][yb] then
		return false;
	end;
	return true;
end;

function helpers.attackDirection(attacker,hisvictim)
	local attacked_from = nil;
	if chars_mobs_npcs[attacker].rot == chars_mobs_npcs[hisvictim].rot then
		attacked_from="back";
	elseif (chars_mobs_npcs[attacker].rot==1 and chars_mobs_npcs[hisvictim].rot==4)
	or (chars_mobs_npcs[attacker].rot==2 and chars_mobs_npcs[hisvictim].rot==5)
	or (chars_mobs_npcs[attacker].rot==3 and chars_mobs_npcs[hisvictim].rot==6)
	or (chars_mobs_npcs[attacker].rot==4 and chars_mobs_npcs[hisvictim].rot==1)
	or (chars_mobs_npcs[attacker].rot==5 and chars_mobs_npcs[hisvictim].rot==2)
	or (chars_mobs_npcs[attacker].rot==6 and chars_mobs_npcs[hisvictim].rot==3) then
		attacked_from="front";
	elseif 
	   (chars_mobs_npcs[attacker].rot==1 and chars_mobs_npcs[hisvictim].rot==3)
	or (chars_mobs_npcs[attacker].rot==2 and chars_mobs_npcs[hisvictim].rot==4)
	or (chars_mobs_npcs[attacker].rot==3 and chars_mobs_npcs[hisvictim].rot==5)
	or (chars_mobs_npcs[attacker].rot==4 and chars_mobs_npcs[hisvictim].rot==6)
	or (chars_mobs_npcs[attacker].rot==5 and chars_mobs_npcs[hisvictim].rot==1)
	or (chars_mobs_npcs[attacker].rot==6 and chars_mobs_npcs[hisvictim].rot==2) then
		attacked_from="rh";
	elseif 
	   (chars_mobs_npcs[attacker].rot==1 and chars_mobs_npcs[hisvictim].rot==5)
	or (chars_mobs_npcs[attacker].rot==2 and chars_mobs_npcs[hisvictim].rot==6)
	or (chars_mobs_npcs[attacker].rot==3 and chars_mobs_npcs[hisvictim].rot==1)
	or (chars_mobs_npcs[attacker].rot==4 and chars_mobs_npcs[hisvictim].rot==2)
	or (chars_mobs_npcs[attacker].rot==5 and chars_mobs_npcs[hisvictim].rot==3)
	or (chars_mobs_npcs[attacker].rot==6 and chars_mobs_npcs[hisvictim].rot==4) then
		attacked_from="lh";
	elseif 
	   (chars_mobs_npcs[attacker].rot==1 and chars_mobs_npcs[hisvictim].rot==6)
	or (chars_mobs_npcs[attacker].rot==2 and chars_mobs_npcs[hisvictim].rot==1)
	or (chars_mobs_npcs[attacker].rot==3 and chars_mobs_npcs[hisvictim].rot==2)
	or (chars_mobs_npcs[attacker].rot==4 and chars_mobs_npcs[hisvictim].rot==3)
	or (chars_mobs_npcs[attacker].rot==5 and chars_mobs_npcs[hisvictim].rot==4)
	or (chars_mobs_npcs[attacker].rot==6 and chars_mobs_npcs[hisvictim].rot==5) then
		attacked_from="lback";
	elseif 
	   (chars_mobs_npcs[attacker].rot==1 and chars_mobs_npcs[hisvictim].rot==2)
	or (chars_mobs_npcs[attacker].rot==2 and chars_mobs_npcs[hisvictim].rot==3)
	or (chars_mobs_npcs[attacker].rot==3 and chars_mobs_npcs[hisvictim].rot==4)
	or (chars_mobs_npcs[attacker].rot==4 and chars_mobs_npcs[hisvictim].rot==5)
	or (chars_mobs_npcs[attacker].rot==5 and chars_mobs_npcs[hisvictim].rot==6)
	or (chars_mobs_npcs[attacker].rot==6 and chars_mobs_npcs[hisvictim].rot==1) then
		attacked_from="rback";
	end;
	return attacked_from;
end;

function helpers.countProtection (index)
	local totalac = chars_mobs_npcs[index].ac;
	local totaldt = chars_mobs_npcs[index].dt;
	local totaldr = chars_mobs_npcs[index].dr;
	local deltaac = 0;
	local deltadt = 0;
	local deltadr = 0;
	
	local deltaac_body = 0;
	local deltadt_body = 0;
	local deltadr_body = 0;
	
	local counter = 1;
	local minimalac = totalac;
	local minimaldt = totaldt;
	local minimaldr = totaldr;
	local minimalac_ = lognames.zones["def"];
	local minimaldt_ = lognames.zones["def"];
	local minimaldr_ = lognames.zones["def"];
	local maximalac = totalac;
	local maximaldt = totaldt;
	local maximaldr = totaldr;
	local maximalac_ = lognames.zones["def"];
	local maximaldt_ = lognames.zones["def"];
	local maximaldr_ = lognames.zones["def"];
	local function updatemaxmin (part)
		if deltaac > maximalac or (deltaac > 0 and maximalac_ == lognames.zones["def"]) then
			maximalac = deltaac;
			maximalac_ = lognames.zones[part];
		end;
		if deltaac < minimalac  or (deltaac > 0 and minimalac_ == lognames.zones["def"]) then
			minimalac = deltaac;
			minimalac_ = lognames.zones[part];
		end;
		if deltadt > maximaldt  or (deltadt > 0 and maximaldt_ == lognames.zones["def"]) then
			maximaldt = deltadt;
			maximaldt_ = lognames.zones[part];
		end;
		if deltadt < minimaldt or (deltadt > 0 and minimaldt_ == lognames.zones["def"]) then
			minimaldt = deltadt;
			minimaldt_ = lognames.zones[part];
		end;
		if deltadr > maximaldr or (deltadr > 0 and maximaldr_ == lognames.zones["def"]) then
			maximaldr = deltadr;
			maximaldr_ = lognames.zones[part];
		end;
		if deltadr < minimaldr or (deltadr > 0 and minimaldr_ == lognames.zones["def"])  then
			minimaldr = deltadr;
			minimaldr_ = lognames.zones[part];
		end;
	end;
	local protection = {};
	if chars_mobs_npcs[index]["equipment"].armor ~= 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].q > 0  then
		counter = counter + 1;
		deltaac = totalac+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].ac;
		deltadt = totaldt+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].dt;
		deltadr = totaldr+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].dr;
		totalac = totalac+deltaac;
		totaldt = totaldt+deltadt;
		totaldr = totaldr+deltadr;
		deltaac_body = deltaac_body + deltaac;
		deltadt_body = deltadt_body + deltadt;
		deltadr_body = deltadr_body + deltadr;
	end;
		if chars_mobs_npcs[index]["equipment"].cloak ~= 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].cloak].q > 0 then
		counter = counter + 1;
		deltaac = totalac+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].cloak].ttxid].ac;
		deltadt = totaldt+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].cloak].ttxid].dt;
		deltadr = totaldr+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].head].cloak].dr;
		totalac = totalac+deltaac;
		totaldt = totaldt+deltadt;
		totaldr = totaldr+deltadr;
		deltaac_body = deltaac_body + deltaac;
		deltadt_body = deltadt_body + deltadt;
		deltadr_body = deltadr_body + deltadr;
	end;
	if chars_mobs_npcs[index]["equipment"].belt ~= 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].belt].q > 0 then
		counter = counter + 1;
		deltaac = totalac+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].belt].ttxid].ac;
		deltadt = totaldt+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].belt].ttxid].dt;
		deltadr = totaldr+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].belt].ttxid].dr;
		totalac = totalac+deltaac;
		totaldt = totaldt+deltadt;
		totaldr = totaldr+deltadr;
		deltaac_body = deltaac_body + deltaac;
		deltadt_body = deltadt_body + deltadt;
		deltadr_body = deltadr_body + deltadr;
	end;
	deltaac = deltaac_body;
	deltadt = deltadt_body;
	deltadr = deltadr_body;
	updatemaxmin ("body");
	if chars_mobs_npcs[index]["equipment"].head ~= 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].head].q > 0 then
		counter = counter + 1;
		deltaac = totalac+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].head].ttxid].ac;
		deltadt = totaldt+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].head].ttxid].dt;
		deltadr = totaldr+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].head].ttxid].dr;
		totalac = totalac+deltaac;
		totaldt = totaldt+deltadt;
		totaldr = totaldr+deltadr;
		updatemaxmin ("head");
	end;
	if chars_mobs_npcs[index]["equipment"].boots ~= 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].boots].q > 0 then
		counter = counter + 1;
		deltaac = totalac+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].boots].ttxid].ac;
		deltadt = totaldt+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].boots].ttxid].dt;
		deltadr = totaldr+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].boots].ttxid].dr;
		totalac = totalac+deltaac;
		totaldt = totaldt+deltadt;
		totaldr = totaldr+deltadr;
		updatemaxmin ("legs");
	end;
	if chars_mobs_npcs[index]["equipment"].gloves ~= 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].gloves].q > 0 then
		counter = counter + 1;
		deltaac = totalac+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].gloves].ttxid].ac;
		deltadt = totaldt+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].gloves].ttxid].dt;
		deltadr = totaldr+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].head].gloves].dr;
		totalac = totalac+deltaac;
		totaldt = totaldt+deltadt;
		totaldr = totaldr+deltadr;
		updatemaxmin ("hands");
	end;
	
	--[[if chars_mobs_npcs[index].stoneskin_dur>0 then
		chars_mobs_npcs[index].ac= chars_mobs_npcs[index].ac+chars_mobs_npcs[index].stoneskin_power;
	else
		chars_mobs_npcs[index].stoneskin_power = 0;
	end;]]
	protection[1] = totalac;
	protection[2] = totaldt;
	protection[3] = totaldr;
	protection[4] = maximalac;
	protection[5] = maximaldt;
	protection[6] = maximaldr;
	protection[7] = maximalac_;
	protection[8] = maximaldt_;
	protection[9] = maximaldr_;
	protection[10] = minimalac;
	protection[11] = minimaldt;
	protection[12] = minimaldr;
	protection[13] = minimalac_;
	protection[14] = minimaldt_;
	protection[15] = minimaldr_;
	return protection;
end;

helpers.orthopedia = {"rh","lh","rh2","lh2","rh3","lh3","rh4","lh4"};

function helpers.centerObject(sprite)
	local x = math.ceil(global.screenWidth/2 - sprite:getWidth()/2);
	local y = math.ceil(global.screenHeight/2 - sprite:getHeight()/2);
	return x,y;
end;

function helpers.repackBag()
	if bagid and bagid > 0 then
		th=bagid;
		sorttarget="bag";
		oldsorttarget="bag";
		for i=1,15 do
			for j=1,11 do
				bags[bagid][i][j]=0;
			end;
		end;
		helpers.resort_inv(bagid);
	end;
end;

function helpers.findpotion (a, n)
print("findpotion called");
   potioncode = "";
      if n == 0 then
     --   printResult(a)
	  for m = 1,#comparray do
	     potioncode= potioncode .. comparray[m];
      end;
         print(potioncode);
         potion_in_inventory_ttx ();
      else
        for l = 1,n do
          a[n], a[l] = a[l], a[n];
          helpers.findpotion(a, n - 1);
          a[n], a[l] = a[l], a[n];
		end;
	end;
end;

function helpers.countPrice (sum,client,npc,buyorsel,baseprice,wishprice,identified,condition_mod)
	local trading_bonus = (100-(chars_mobs_npcs[client].lvl_trading*chars_mobs_npcs[client].num_trading - chars_mobs_npcs[npc].lvl_trading*chars_mobs_npcs[npc].num_trading))/100;
	local preprice = 0;
	local price = 0;
	if buyorsel == 1 then
		preprice = math.max(1,math.ceil(sum*traders[chars_mobs_npcs[npc].shop]["prices"][buyorsel]));
		price = math.max(1,math.ceil(preprice*trading_bonus - chars_mobs_npcs[client].chr/5));
	else
		if identified then
			preprice = math.max(1,math.ceil(wishprice*traders[chars_mobs_npcs[npc].shop]["prices"][buyorsel]));
			price = math.min(wishprice,math.max(1,math.ceil(preprice*trading_bonus + chars_mobs_npcs[client].chr/5)));
		else
			preprice = math.max(1,math.ceil(baseprice*traders[chars_mobs_npcs[npc].shop]["prices"][buyorsel]));
			price = math.min(baseprice,math.max(1,math.ceil(preprice*trading_bonus + chars_mobs_npcs[client].chr/5)));
		end;
	end;
	return price,preprice;
end;

function helpers.payGold (price)
	if party.gold >= price then
		party.gold = party.gold - price;
		love.audio.play(media.sounds.gold_dzen,0);
		return true;
	else
		love.audio.play(media.sounds.error,0);
		helpers.addToActionLog(helpers.mobName(victim) .. ": " .. lognames.traders.notenoughgold);
		return false;
	end;
end;

function helpers.countModifiedPrice (price)
	local wishprice = price;
	if (tip_class == "sword" or tip_class == "axe" or tip_class == "flagpole" or tip_class == "dagger" or tip_class == "crushing" or tip_class == "staff" or tip_class == "bow" or tip_class == "crossbow" or tip_class == "throwing" or tip_class == "firearm" or tip_class == "ammo" or tip_class == "armor" or tip_class == "helm" or tip_class == "boots" or tip_class == "shield" or tip_class == "belt" or tip_class == "gloves" or tip_class == "cloak" or tip_class == "amulet" or tip_class == "ring") and list[tmpinv].w > 0 then	
		if list[tmpinv].e == 1000 then
			price=price+items_modifers[list[tmpinv].w].price;
		end;
	end;
	if list[tmpinv].e == 1000 and (tip_class == "ammo" or tip_class == "throwing") then
		price=(price+items_modifers[list[tmpinv].w].price)*list[tmpinv].q;
	end;
	return price;
end;

function helpers.tradersBuysThisItem(npc,class)
	for i=1,#traders[chars_mobs_npcs[npc].shop]["classes"][1] do
		if class == traders[chars_mobs_npcs[npc].shop]["classes"][1][i] then
			return true;
		end;
	end;
	return false;
end;

function helpers.tradersRepairsThisItem(npc,class)
	for i=1,#traders[chars_mobs_npcs[npc].shop]["classes"][3] do
		if class == traders[chars_mobs_npcs[npc].shop]["classes"][3][i] then
			return true;
		end;
	end;
	return false;
end;

function helpers.tradersIdentifiesThisItem(npc,class)
	for i=1,#traders[chars_mobs_npcs[npc].shop]["classes"][2] do
		if class == traders[chars_mobs_npcs[npc].shop]["classes"][2][i] then
			return true;
		end;
	end;
	return false;
end;


function helpers.inv_tips_add()
	tmpinv2=list[tmpinv].ttxid;
	tmpinv3=list[tmpinv].w;
	local condition_mod = 1;
	if inventory_ttx[tmpinv2].class ~= "book" and inventory_ttx[tmpinv2].class ~= "message"
	and inventory_ttx[tmpinv2].class ~= "letter" and inventory_ttx[tmpinv2].class ~= "map"
	and inventory_ttx[tmpinv2].class ~= "scroll" and inventory_ttx[tmpinv2].class ~= "gobelen" then
		if list[tmpinv].r == 1 then
			tip_title=inventory_ttx[tmpinv2].title;
		else
			tip_title = lognames.actions.unknown;
		end;
	end;
	tip_classtitle = inventory_ttx[tmpinv2].classtitle;
	tip_class = inventory_ttx[tmpinv2].class;
	tip_price = inventory_ttx[tmpinv2].price; --base price
	if tip_class == "ammo" or tip_class == "throwing" then
		tip_price = tip_price*list[tmpinv].q;
	end;
	tip_hardened = "";
	if list[tmpinv].h > 0 and list[tmpinv].h < 1000 then
		tip_hardened = log.actions.hardened .. " " .. list[tmpinv].h;
	elseif list[tmpinv].h >= 1000 then
		tip_hardened = log.actions.incorruptable;
	end;
	baseprice = tip_price;
	tip_mod = "";
	tip_effect = "";
	if (tip_class == "sword" or tip_class == "axe" or tip_class == "flagpole" or tip_class == "dagger" or tip_class == "crushing" or tip_class == "staff" or tip_class == "bow" or tip_class == "crossbow" or tip_class == "throwing" or tip_class == "firearm" or tip_class == "ammo" or tip_class == "armor" or tip_class == "helm" or tip_class == "boots" or tip_class == "shield" or tip_class == "belt" or tip_class == "gloves" or tip_class == "cloak" or tip_class == "amulet" or tip_class == "ring") and list[tmpinv].w > 0 then	
		tip_mod = items_modifers[list[tmpinv].w].name;
		tip_effect = items_modifers[list[tmpinv].w].description;
	end;
	tip_price = helpers.countModifiedPrice (tip_price);
	wishprice = tip_price;
	tmpsk = "lognames.skills." .. inventory_ttx[tmpinv2].skill;
	tip_titleskill = loadstring("return " .. tmpsk)();
	if tip_class == "sword" or tip_class == "axe" or tip_class == "flagpole" or tip_class == "dagger"or tip_class == "crushing" or tip_class == "staff" or tip_class == "bow" or tip_class == "crossbow" or tip_class == "firearm" or tip_class == "armor" or tip_class == "helm" or tip_class == "boots" or tip_class == "shield" or tip_class == "belt" or tip_class == "gloves" or tip_class == "cloak" then
		tip_condition = list[tmpinv].q;
		tip_material = inventory_ttx[tmpinv2].material;
		condition_mod = tip_condition/tip_material;
	end ;
	if inventory_ttx[tmpinv2].class == "book" then
		tip_price = books_ttx[list[tmpinv].q].price;
		tip_subclasstitle = item_type.book;
		tip_title = books_ttx[list[tmpinv].q].title;
		tip_author = books_ttx[list[tmpinv].q].author;
		tip_story = books_ttx[list[tmpinv].q].annotation;
		tip_titleskill = lognames.skills.reading;
		baseprice = tip_price;
		wishprice = tip_price;
	end;
	if inventory_ttx[tmpinv2].class == "message" then
		tip_price = "";
		tip_subclasstitle = item_type.message;
		tip_title = messages_ttx[list[tmpinv].q].title;
		tip_author = messages_ttx[list[tmpinv].q].author;
		tip_story = messages_ttx[list[tmpinv].q].annotation;
		tip_titleskill = lognames.skills.reading;
	end;
	if inventory_ttx[tmpinv2].class == "letter" then
		tip_price = "";
		tip_subclasstitle = item_type.letter;
		tip_title = messages_ttx[list[tmpinv].q].title;
		tip_author = messages_ttx[list[tmpinv].q].author;
		tip_story = messages_ttx[list[tmpinv].q].annotation;
		tip_titleskill = lognames.skills.reading;
	end;
	if inventory_ttx[tmpinv2].class == "map" then
		tip_price = maps_ttx[list[tmpinv].q].price;
		tip_subclasstitle = item_type.map;
		tip_title = maps_ttx[list[tmpinv].q].title;
		--tip_author = maps_ttx[list[tmpinv].q].author;
		tip_story = maps_ttx[list[tmpinv].q].annotation;
		tip_titleskill = lognames.skills.reading;
		baseprice = tip_price;
		wishprice = tip_price;
	end;
	if inventory_ttx[tmpinv2].class == "gobelen" then
		tip_price = gobelens_ttx[list[tmpinv].q].price;
		tip_subclasstitle = item_type.gobelen;
		tip_title = gobelens_ttx[list[tmpinv].q].title;
		tip_author = gobelens_ttx[list[tmpinv].q].author;
		tip_story = gobelens_ttx[list[tmpinv].q].annotation;
		tip_titleskill = lognames.skills.reading;
		baseprice = tip_price;
		wishprice = tip_price;
	end;
	if inventory_ttx[tmpinv2].class == "scroll" then
		tip_title = magic.spell_tips[list[tmpinv].w].title;
		tip_subclasstitle = item_type.scroll;
		tip_story = magic.spell_tips[list[tmpinv].w].story;
		tip_titleskill = lognames.skills.reading;
		tip_price = inventory_ttx[tmpinv2].price;
		baseprice = tip_price;
		wishprice = tip_price;
	end;
	if inventory_ttx[tmpinv2].class == "wand" then
		tip_spell = magic.spell_tips[list[tmpinv].w].title;
		tip_subclasstitle = item_type.scroll;
		tip_story = magic.spell_tips[list[tmpinv].w].story;
		tip_titleskill = lognames.skills.reading;
		tip_price = inventory_ttx[tmpinv2].price;
		baseprice = tip_price;
		wishprice = tip_price;
	end;
	if inventory_ttx[tmpinv2].class == "potion" then
		tip_price = inventory_ttx[tmpinv2].price*list[tmpinv].q;
		baseprice = tip_price;
		wishprice = tip_price;
	end;
	if inventory_ttx[tmpinv2].class == "component" and inventory_ttx[tmpinv2].subclass == "gom" then
		tip_price = list[tmpinv].q*10;
		baseprice,wishprice = tip_price;
	end;
	tip_quantity = list[tmpinv].q;
	if tip_class	==	"sword" or tip_class == "axe" or tip_class == "flagpole" or tip_class == "crushing" or
	tip_class == "staff" or tip_class == "dagger" or tip_class == "bow" or tip_class == "crossbow" or tip_class == "throwing" or
	tip_class == "firearm" or tip_class == "ammo" then
		tip_formula = inventory_ttx[tmpinv2].a .. "d" .. inventory_ttx[tmpinv2].b .. "+" .. inventory_ttx[tmpinv2].c;
		tip_atk = inventory_ttx[tmpinv2].atk;
	elseif tip_class == "armor" or tip_class == "helm" or tip_class == "crown" or tip_class == "hat" or tip_class == "boots" or
		tip_class == "belt" or tip_class == "gloves" or tip_class == "cloak" then
		tip_ac = inventory_ttx[tmpinv2].ac;
		tip_dt = inventory_ttx[tmpinv2].dt;
		tip_dr = inventory_ttx[tmpinv2].dr;
	elseif tip_class == "shield"	then
		tip_block = inventory_ttx[tmpinv2].ac;
	end;
   	if game_status == "buying" then
		global.price,global.preprice = helpers.countPrice (tip_price,current_mob,victim,1);
	elseif game_status == "showinventory" then -- add class
		global.price,global.preprice = helpers.countPrice (tip_price,current_mob,victim,2,baseprice,wishprice,list[tmpinv].r,condition_mod);
	end;
	if list[tmpinv].r == 1 then
		tip_subclasstitle = inventory_ttx[tmpinv2].subclasstitle;
		tip_story = inventory_ttx[tmpinv2].story;
	else
		tip_subclasstitle = lognames.actions.unknown;
		tip_story = lognames.actions.unknown;
		tip_price = lognames.actions.unknown;
		tip_mod = lognames.actions.unknown;
		tip_effect = lognames.actions.unknown;
		tip_price = lognames.actions.unknown;
		tip_condition = lognames.actions.unknown;
		tip_material = lognames.actions.unknown;
		tip_price = lognames.actions.unknown;
		tip_title = lognames.actions.unknown;
		tip_subclasstitle = lognames.actions.unknown;
		tip_story = lognames.actions.unknown;
		tip_titleskill = lognames.actions.unknown;
		tip_price = lognames.actions.unknown;
		tip_formula = lognames.actions.unknown;
		tip_atk = lognames.actions.unknown;
		tip_ac = lognames.actions.unknown;
		tip_dt = lognames.actions.unknown;
		tip_dr = lognames.actions.unknown;
		tip_block = lognames.actions.unknown;
		tip_hardened = "";
	end;
end;

function helpers.resort_inv (index) --index ll be made later
	sort_switcher = 1;
	local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false,index);
	--whatsorttarget();
	--local list_length = #list;
	-- better sorting
	local sizelist = {};
	local noequiplist = {};
	if sorttarget == "char" then
		for i=1,#list do
			if not helpers.equiped(current_mob,i) then
				table.insert(noequiplist,{i,inventory_ttx[list[i].ttxid].h});
			end;
		end;
		for i=1,#noequiplist do
			sizelist[i] = noequiplist[i];
		end;
		local function compare(a,b)
			return a[2] > b[2]
		end
		table.sort(sizelist,compare);
		for i=1,#sizelist do
			if sizelist[i][1] ~= noequiplist[i][1] and sizelist[i][1] > 0 then
				local tmp1 = list[sizelist[i][1]];
				local tmp2 = list[noequiplist[i][1]];
				list[sizelist[i][1]] = tmp2;
				list[noequiplist[i][1]] = tmp1;
				for k = 1, #sizelist do
					if sizelist[k][1] == noequiplist[i][1] then
						sizelist[k][1] = 0;
					end;
				end;
			end;
		end;
	else
		
	end;
	--/ better sorting
	for i=1,#list do
		holding_smth = i;
		selected_char = th;
		if sorttarget == "char" then
			donotsortthis = 0;
			for key,value in pairs(chars_mobs_npcs[th]["equipment"]) do 
				if value == holding_smth then
					donotsortthis = 1;
				end;
			end;
			for key,value in pairs(alchlab[th]) do 
				if value == holding_smth then
					donotsortthis = 1;
				end;
			end;
			for key,value in pairs(picklock[th]) do 
				if value == holding_smth then
					donotsortthis = 1;
				end;
			end;
		end;
		find_free_space_at_inv();
	end;
	local sum = #list;
	local tmp = math.ceil(sum/2);
	for d=1,11 do
		for e=1,15 do
			if bag[th][e][d] > 0 and bag[th][e][d] < 10000 then
				bag[th][e][d] = bag[th][e][d] - tmp;
			end;
		end;
	end;
	for i=sum,tmp+1,-1 do
		table.remove(list,i);
	end;
	--while #list > list_length do
		--table.remove(list,#list)	
	--end;
	sort_switcher=0;
	local newfullness = helpers.countFulness(bag[th]);
end;

function helpers.idAndRepair(dragfrom)
	local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
	local tmp12=bag[tmp_bagid][inv_quad_x][inv_quad_y];
	local work_this = 0;
	if tmp12>0 and tmp12<10000 then
		work_this=tmp12;
	elseif tmp12>0 and tmp12>10000 then
		tmp_s=tostring(tmp12)
		if (tmp12-10000)<10 then
			tmpxi=tonumber(string.sub(tmp_s, 5,6));
		else
			tmpxi=tonumber(string.sub(tmp_s, 4,6));
		end;
		tmpyi=math.floor((tmp12-tmpxi)/10000);
		work_this=bag[tmp_bagid][tmpxi][tmpyi];
		inv_quad_x=tmpxi;
		inv_quad_y=tmpyi;
	end;
	print(tmp_bagid,work_this);
	--repair
	if love.keyboard.isDown("lctrl","rctrl") and work_this > 0 and list[work_this].q < inventory_ttx[list[work_this].ttxid].material 
	and (inventory_ttx[list[work_this].ttxid].class == "sword" or inventory_ttx[list[work_this].ttxid].class == "axe" or inventory_ttx[list[work_this].ttxid].class == "crushing"
	or inventory_ttx[list[work_this].ttxid].class == "flagpole" or inventory_ttx[list[work_this].ttxid].class == "dagger" or inventory_ttx[list[work_this].ttxid].class == "staff"
	or inventory_ttx[list[work_this].ttxid].class == "armor" or inventory_ttx[list[work_this].ttxid].class == "shield" or inventory_ttx[list[work_this].ttxid].class == "helm"
	or inventory_ttx[list[work_this].ttxid].class == "boots" or inventory_ttx[list[work_this].ttxid].class == "hat" or inventory_ttx[list[work_this].ttxid].class == "crown"
	or inventory_ttx[list[work_this].ttxid].class == "belt" or inventory_ttx[list[work_this].ttxid].class == "cloak")
	and chars_mobs_npcs[current_mob].num_repair*chars_mobs_npcs[current_mob].lvl_repair > list[work_this].q 
	then
		list[work_this].q = math.min(chars_mobs_npcs[current_mob].num_repair*chars_mobs_npcs[current_mob].lvl_repair,inventory_ttx[list[work_this].ttxid].material);
		helpers.addToActionLog( chars_stats[current_mob].name .. " " .. lognames.actions.fixed[chars_mobs_npcs[current_mob].gender] .. lognames.actions.someequipment);
		love.audio.play(media.sounds.repair, 0);
	elseif love.keyboard.isDown("lctrl","rctrl") and  work_this > 0 and inventory_ttx[list[work_this].ttxid].class ~= "ammo" then
		helpers.addToActionLog( lognames.actions.nothingtofix)
	end;
	--/repair
	--print(inventory_ttx[list[work_this].ttxid].class);
	local add = 0;
	if work_this > 0 and (inventory_ttx[list[work_this].ttxid].class == "sword" or inventory_ttx[list[work_this].ttxid].class == "axe" or inventory_ttx[list[work_this].ttxid].class == "crushing"
	or inventory_ttx[list[work_this].ttxid].class == "flagpole" or inventory_ttx[list[work_this].ttxid].class == "dagger" or inventory_ttx[list[work_this].ttxid].class == "staff"
	or inventory_ttx[list[work_this].ttxid].class == "armor" or inventory_ttx[list[work_this].ttxid].class == "shield" or inventory_ttx[list[work_this].ttxid].class == "helm"
	or inventory_ttx[list[work_this].ttxid].class == "boots" or inventory_ttx[list[work_this].ttxid].class == "hat" or inventory_ttx[list[work_this].ttxid].class == "crown"
	or inventory_ttx[list[work_this].ttxid].class == "belt" or inventory_ttx[list[work_this].ttxid].class == "cloak" or inventory_ttx[list[work_this].ttxid].class == "ring" or inventory_ttx[list[work_this].ttxid].class == "amulet")
	then
		local tmp = list[work_this].w - math.ceil(list[work_this].w/3)*3;
		if list[work_this].w > 0 then 
			if tmp == 0 then
				add = 3;
			elseif tmp == 1 then
				add = 1;
			elseif tmp == 2 then
				add = 2;
			end;
		end;
	end;
	if work_this > 0 then
		local idvalue = inventory_ttx[list[work_this].ttxid].level*20 + add*10;
		local idskill = chars_mobs_npcs[current_mob].lvl_stuffid*chars_mobs_npcs[current_mob].num_stuffid + chars_mobs_npcs[current_mob].int;
		print("ID:",idvalue,idskill);
		if work_this > 0 and list[work_this].r == 0 and (idskill > idvalue or chars_mobs_npcs[current_mob].lvl_stuffid == 5) then
			list[work_this].r = 1;
			helpers.addToActionLog( lognames.actions.identified);
		elseif work_this > 0  and list[work_this].r == 0 then
			helpers.addToActionLog( lognames.actions.cantid);
		end;
	end;
end;

function helpers.addDecal(x,y,dec,par,rot)
	table.insert(tlandscape[y][x],{decal=dec,param=par,rotation=rot});
	if #tlandscape[y][x] > 3 then
		table.remove(tlandscape[y][x],1);
	end;
end;

function helpers.countDistance (x1,y1,x2,y2)
	if y1/2 ~= math.ceil(y1/2) then
		
	end;
	local distance = math.ceil(math.sqrt((x1-x2)^2 +(y1-y2)^2));
	return distance;
end;


function helpers.randomizeArray1D (array)
	for i=1,#array do
		local roll = math.random(#array);
		local tmp = array[roll];
		array[roll] = array[i];
		array[i] = tmp;
	end;
	return array;
end;

function helpers.select_portrait()
	global.screenWidth = love.graphics.getWidth();
	global.screenHeight = love.graphics.getHeight();
	local screen_mod_x = 0;
	local screen_mod_y = global.screenHeight - 110; --850
	selected_portrait = 0;
	char_for_trading_is_near = 0;
	for i=1,chars do
		if mX>i*125-95 and mX<i*125-95+80+40 and mY < global.screenHeight and mY >= global.screenHeight-110 then
			selected_portrait = i;
			break;
		end;
	end;
	for h=1,6 do
		if selected_portrait > 0 then
			if chars_mobs_npcs[current_mob].y/2 == math.ceil(chars_mobs_npcs[current_mob].y/2) then
				if chars_mobs_npcs[selected_portrait].x == chars_mobs_npcs[current_mob].x+directions[1].xc[h] and
					chars_mobs_npcs[selected_portrait].y == chars_mobs_npcs[current_mob].y+directions[1].y[h] then
					char_for_trading_is_near = 1;
					break;
				end;
			elseif chars_mobs_npcs[current_mob].y/2 ~= math.ceil(chars_mobs_npcs[current_mob].y/2) then
				if chars_mobs_npcs[selected_portrait].x == chars_mobs_npcs[current_mob].x+directions[1].xn[h] and 
				chars_mobs_npcs[selected_portrait].y == chars_mobs_npcs[current_mob].y+directions[1].y[h] then
					char_for_trading_is_near = 1;
					break;
				end;
			end;
		end;
	end
	return selected_portrait, char_for_trading_is_near;
end;

function helpers.resistsFromIDSkill(level,resist)
 local value = resist;
 if level < 3 then
	if resist == 0 then
		value = resistsvalues.none;
	elseif resist > 0 and resist <= 25 then
		value = resistsvalues.weak;
	elseif resist > 25 and resist <= 50 then
		value = resistsvalues.medium;
	elseif resist > 50 and resist <= 75 then
		value = resistsvalues.high;
	elseif resist > 75 and resist <= 100 then
		value = resistsvalues.veryhigh;
	elseif resist == 100 then
		value = resistsvalues.immune;
	end;
 end;
 return value;
end;

function helpers.dodgeIfPossible (index)
	if chars_mobs_npcs[index].num_dodging > 0
	and helpers.mobCanDefendHimself (index)
	and chars_mobs_npcs[index].st >= 50
	and chars_mobs_npcs[index].rt >= 50
	and (chars_mobs_npcs[index]["equipment"].armor == 0
	or ((inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "leather"
	or inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "fur"
	or inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "skin") and chars_mobs_npcs[index].lvl_dodging >= 3)
	or (inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "chainmail" and chars_mobs_npcs[index].lvl_dodging >= 4)	
	or (inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].armor].ttxid].subclass == "plate" and chars_mobs_npcs[index].lvl_dodging == 5))		
	then
		chars_mobs_npcs[index].st = chars_mobs_npcs[index].st - 50; -- FIXME if 0
		chars_mobs_npcs[index].rt = chars_mobs_npcs[index].rt - 50;
		chars_mobs_npcs[index].defmod = "dodge";
		restore_rt();
	else
		love.audio.play(media.sounds.error,0);
	end;
end;
	
function helpers.blockIfPossible (index)
	if chars_mobs_npcs[index]["equipment"].lh > 0 and helpers.mobCanDefendHimself (index)
	and chars_mobs_npcs[index].st >= 50
	and chars_mobs_npcs[index].rt >= 50
	and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].class == "shield"
	and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].q > 0
	and helpers.mobCanDefendHimself (index) and chars_mobs_npcs[index].lh > 0 then
		chars_mobs_npcs[index].st = chars_mobs_npcs[index].st - 50; -- FIXME if 0
		chars_mobs_npcs[index].rt = chars_mobs_npcs[index].rt - 50;
		chars_mobs_npcs[index].protectionmode = "block";
		restore_rt();
	else
		love.audio.play(media.sounds.error,0);
	end;
end;

function helpers.parryIfPossible (index)
	if helpers.mobCanDefendHimself (index) -- RIGHT HAND
	and chars_mobs_npcs[index].st >= 50
	and chars_mobs_npcs[index].rt >= 50
	and (chars_mobs_npcs[index]["equipment"].rh > 0 and chars_mobs_npcs[index]["arms_health"].rh > 0 
	and (
	inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].rh].ttxid].class == "sword"
	or inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].rh].ttxid].class == "flagpole"
	or inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].rh].ttxid].class == "dagger"
	or inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].rh].ttxid].class == "staff"
	or inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].rh].ttxid].subclass == "hetchet"
	)
	and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].rh].q > 0)
	or (
	chars_mobs_npcs[index]["arms_health"].lh > 0  and chars_mobs_npcs[index]["equipment"].lh > 0 and (inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].class == "sword" or
	inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].class == "dagger")
	and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].q > 0
	) then
		chars_mobs_npcs[index].st = chars_mobs_npcs[index].st - 50; -- FIXME if 0
		chars_mobs_npcs[index].rt = chars_mobs_npcs[index].rt - 50;
		chars_mobs_npcs[index].protectionmode = "parry";
		restore_rt();
	else
		love.audio.play(media.sounds.error,0);
	end;
end;

function helpers.handsIfPossible (index)
	if helpers.mobHasHandblock (victim) and helpers.mobCanDefendHimself (victim)
	and chars_mobs_npcs[index].st >= 50
	and chars_mobs_npcs[index].rt >= 50 then
		chars_mobs_npcs[index].st = chars_mobs_npcs[index].st - 50; -- FIXME if 0
		chars_mobs_npcs[index].rt = chars_mobs_npcs[index].rt - 50;
		chars_mobs_npcs[index].protectionmode = "hands";
		restore_rt();
	else
		love.audio.play(media.sounds.error,0);
	end;
end;


function helpers.protectionOff (index)
	if not helpers.mobCanDefendHimself (index) then
		chars_mobs_npcs[index].protectionmode = "none";
	end;
end;

function helpers.createSpellbookBySpellNames(spellarray)
	local spellbook = {};
	for i=1,14 do
		spellbook[i] = {};
		for h=1,12 do
			spellbook[i][h] = 0;
		end;
	end;
	for i=1,#spellarray do
		local school = magic.spell_tips[spellarray[i]].school;
		local spell = magic.spell_tips[spellarray[i]].spell;
		spellbook[school][spell] = 1;
	end;
	return spellbook;
end;

function helpers.createWarbook(index)
	chars_mobs_npcs[index].warbook={
	{0,0,0,0,0,0,0,0,0,0,0,0}, --sword,axe,spear
	{0,0,0,0,0,0,0,0,0,0,0,0}, --crushing,staff,dagger
	{0,0,0,0,0,0,0,0,0,0,0,0}, --unarmed,dodge,shield
	{0,0,0,0,0,0,0,0,0,0,0,0}, --bow,crossbow,throwing
	};
	for j=1,#global.warbook_skills do
		for k=1,#global.warbook_skills[j] do
			local skill = "lvl_" .. global.warbook_skills[j][k];
			for l=1,4 do
				if chars_mobs_npcs[index][skill] >= l+1 then
					local order = {
					{1,2,7,8},
					{4,3,10,9},
					{5,6,11,12},
					};
					chars_mobs_npcs[index]["warbook"][j][order[k][l]] = 1;
				end;
			end;
		end;
	end;
end;

function helpers.recalcBattleStats (index) --FIXME darkgasp slow misfortune weakness
	local tmpclass = nil;
	local tmpclass2 = nil;
	local poison_mod1 = 1;
	local poison_mod2 = 1;
	if chars_mobs_npcs[index].person == "mob" then
		tmpclass="mobs_stats." .. chars_mobs_npcs[index].class;
		tmpclass2=loadstring("return " .. tmpclass)();
	elseif chars_mobs_npcs[index].person == "npc" then
		tmpclass="mobs_stats." .. chars_mobs_npcs[index].class;
		tmpclass2=loadstring("return " .. tmpclass)();
	elseif chars_mobs_npcs[index].person == "char" then
		tmpclass2 = chars_stats[index];
	end;
	chars_mobs_npcs[index].num_alchemy = tmpclass2.num_alchemy;
	if chars_mobs_npcs[index].person == "char" then
		if alchlab[index].tool4 > 0 then
			chars_mobs_npcs[index].num_alchemy= chars_mobs_npcs[index].num_alchemy+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][alchlab[index].tool4].ttxid].a;
		end;
		if alchlab[index].tool5 > 0 then
			chars_mobs_npcs[index].num_alchemy= chars_mobs_npcs[index].num_alchemy+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][alchlab[index].tool5].ttxid].a;
		end;
		if alchlab[index].tool6 > 0 then
			chars_mobs_npcs[index].num_alchemy= chars_mobs_npcs[index].num_alchemy+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][alchlab[index].tool6].ttxid].a;
		end;
	end;
	
	chars_mobs_npcs[index].mgt = tmpclass2.mgt;
	chars_mobs_npcs[index].enu = tmpclass2.enu;
	chars_mobs_npcs[index].dex = tmpclass2.dex;
	chars_mobs_npcs[index].spd = tmpclass2.spd;
	chars_mobs_npcs[index].acu = tmpclass2.acu;
	chars_mobs_npcs[index].sns = tmpclass2.sns;
	chars_mobs_npcs[index].int = tmpclass2.int;
	chars_mobs_npcs[index].spr = tmpclass2.spr;
	chars_mobs_npcs[index].chr = tmpclass2.chr;
	chars_mobs_npcs[index].luk = tmpclass2.luk;

	if chars_mobs_npcs[index].person == "char" then --FIXME
		chars_mobs_npcs[index].atkm = 0;
		chars_mobs_npcs[index].amel = 0;
		chars_mobs_npcs[index].bmel = 0;
		chars_mobs_npcs[index].cmel = 0;
		chars_mobs_npcs[index].atkr=0;
		chars_mobs_npcs[index].arng = 0;
		chars_mobs_npcs[index].brng = 0;
		chars_mobs_npcs[index].crng = 0;
		chars_mobs_npcs[index].block = 0;
		chars_mobs_npcs[index].parry = 0;
	--[[else
		chars_mobs_npcs[index].ac = tmpclass2.ac;
		chars_mobs_npcs[index].atkm = tmpclass2.atkm;
		chars_mobs_npcs[index].amel = tmpclass2.amel;
		chars_mobs_npcs[index].bmel = tmpclass2.bmel;
		chars_mobs_npcs[index].cmel = tmpclass2.cmel;
		chars_mobs_npcs[index].atkr = tmpclass2.atkr;
		chars_mobs_npcs[index].arng = tmpclass2.arng;
		chars_mobs_npcs[index].brng = tmpclass2.brng;
		chars_mobs_npcs[index].crng = tmpclass2.crng;
		chars_mobs_npcs[index].block=0;
		chars_mobs_npcs[index].parry=0;]]
	end;
	add_atkm=0;
	if chars_mobs_npcs[index].fear > 0 then --FEAR
		chars_mobs_npcs[index].mgt_buff_power = chars_mobs_npcs[index].mgt_buff_power + math.ceil(0.2*chars_mobs_npcs[index].mgt);
		chars_mobs_npcs[index].spd_buff_power = chars_mobs_npcs[index].spd_buff_power + math.ceil(0.2*chars_mobs_npcs[index].spd);
		chars_mobs_npcs[index].dex_debuff_power = chars_mobs_npcs[index].dex_debuff_power + math.ceil(0.5*chars_mobs_npcs[index].dex);
		chars_mobs_npcs[index].int_debuff_power = chars_mobs_npcs[index].int_debuff_power + math.ceil(0.5*chars_mobs_npcs[index].int);
		chars_mobs_npcs[index].acu_debuff_power = chars_mobs_npcs[index].acu_debuff_power + math.ceil(0.5*chars_mobs_npcs[index].acu);
		--chars_mobs_npcs[index].spr_debuff_power = chars_mobs_npcs[index].spr_debuff_power + math.ceil(0.5*chars_mobs_npcs[index].spr);
		chars_mobs_npcs[index].spr_buff_power = chars_mobs_npcs[index].spr_buff_power + math.ceil(0.2*chars_mobs_npcs[index].spr);
		chars_mobs_npcs[index].chr_debuff_power = chars_mobs_npcs[index].chr_debuff_power + math.ceil(0.5*chars_mobs_npcs[index].chr);
	end;
	if chars_mobs_npcs[index].drunk > 0 then --DRUNK
		chars_mobs_npcs[index].mgt_debuff_power = chars_mobs_npcs[index].mgt_debuff_power + math.ceil(0.5*chars_mobs_npcs[index].mgt);
		chars_mobs_npcs[index].enu_debuff_power = chars_mobs_npcs[index].enu_debuff_power + math.ceil(0.5*chars_mobs_npcs[index].enu);
		chars_mobs_npcs[index].spd_debuff_power = chars_mobs_npcs[index].spd_debuff_power + math.ceil(0.75*chars_mobs_npcs[index].spd);
		chars_mobs_npcs[index].dex_debuff_power = chars_mobs_npcs[index].dex_debuff_power + math.ceil(0.75*chars_mobs_npcs[index].dex);
		chars_mobs_npcs[index].int_debuff_power = chars_mobs_npcs[index].int_debuff_power + math.ceil(0.75*chars_mobs_npcs[index].int);
		chars_mobs_npcs[index].spr_debuff_power = chars_mobs_npcs[index].spr_debuff_power + math.ceil(0.75*chars_mobs_npcs[index].spr);
		chars_mobs_npcs[index].acu_debuff_power = chars_mobs_npcs[index].acu_debuff_power + math.ceil(0.75*chars_mobs_npcs[index].acu);
		chars_mobs_npcs[index].luk_buff_power = chars_mobs_npcs[index].luk_buff_power + chars_mobs_npcs[index].drunk;
		local ifNiceWhenDrunk = math.random(1,100) + chars_mobs_npcs[index].chr;
		if ifNiceWhenDrunk > 100 then
			chars_mobs_npcs[index].chr_buff_power = chars_mobs_npcs[index].chr_buff_power + math.ceil(0.25*chars_mobs_npcs[index].chr);
		else
			chars_mobs_npcs[index].chr_debuff_power = chars_mobs_npcs[index].chr_debuff_power + math.ceil(0.75*chars_mobs_npcs[index].chr);
		end;
	end;
	if chars_mobs_npcs[index].drunk > 0 then --PRAYER
		chars_mobs_npcs[index].mgt_debuff_power = chars_mobs_npcs[index].mgt_debuff_power + chars_mobs_npcs[index].prayer_power;
		chars_mobs_npcs[index].enu_debuff_power = chars_mobs_npcs[index].enu_debuff_power + chars_mobs_npcs[index].prayer_power;
		chars_mobs_npcs[index].spd_debuff_power = chars_mobs_npcs[index].spd_debuff_power + chars_mobs_npcs[index].prayer_power;
		chars_mobs_npcs[index].dex_debuff_power = chars_mobs_npcs[index].dex_debuff_power + chars_mobs_npcs[index].prayer_power;
		chars_mobs_npcs[index].int_debuff_power = chars_mobs_npcs[index].int_debuff_power + chars_mobs_npcs[index].prayer_power;
		chars_mobs_npcs[index].spr_debuff_power = chars_mobs_npcs[index].spr_debuff_power + chars_mobs_npcs[index].prayer_power;
		chars_mobs_npcs[index].acu_debuff_power = chars_mobs_npcs[index].acu_debuff_power + chars_mobs_npcs[index].prayer_power;
	end;
	if chars_mobs_npcs[index].drunk > 0 then --HOUR OF POWER
		chars_mobs_npcs[index].mgt_debuff_power = chars_mobs_npcs[index].mgt_debuff_power + chars_mobs_npcs[index].howerofpower_power;
		chars_mobs_npcs[index].enu_debuff_power = chars_mobs_npcs[index].enu_debuff_power + chars_mobs_npcs[index].howerofpower_power;
		chars_mobs_npcs[index].spd_debuff_power = chars_mobs_npcs[index].spd_debuff_power + chars_mobs_npcs[index].howerofpower_power;
		chars_mobs_npcs[index].dex_debuff_power = chars_mobs_npcs[index].dex_debuff_power + chars_mobs_npcs[index].howerofpower_power;
		chars_mobs_npcs[index].acu_debuff_power = chars_mobs_npcs[index].acu_debuff_power + chars_mobs_npcs[index].howerofpower_power;
	end;
	if chars_mobs_npcs[index].misfortune_dur > 0 then --MISFORTUNE
		chars_mobs_npcs[index].luk_debuff_power = chars_mobs_npcs[index].luk_debuff_power + chars_mobs_npcs[index].misfortune_power;	
	end;
	if chars_mobs_npcs[index].might_dur > 0 then --MIGHT
		chars_mobs_npcs[index].mgt_buff_power = chars_mobs_npcs[index].mgt_buff_power + chars_mobs_npcs[index].might_power;
		chars_mobs_npcs[index].enu_buff_power = chars_mobs_npcs[index].enu_buff_power + chars_mobs_npcs[index].might_power;	
	end;
	if chars_mobs_npcs[index].dash_dur > 0 then --DASH
		chars_mobs_npcs[index].spd_buff_power = chars_mobs_npcs[index].spd_buff_power + chars_mobs_npcs[index].dash_power;
		chars_mobs_npcs[index].dex_buff_power = chars_mobs_npcs[index].dex_buff_power + chars_mobs_npcs[index].dash_power;	
	end;
	if chars_mobs_npcs[index].concentration_dur > 0 then --CONCENTRATION
		chars_mobs_npcs[index].int_buff_power = chars_mobs_npcs[index].int_buff_power + chars_mobs_npcs[index].concentration_dur;
		chars_mobs_npcs[index].spr_buff_power = chars_mobs_npcs[index].spr_buff_power + chars_mobs_npcs[index].concentration_dur;	
	end;
	if chars_mobs_npcs[index].dash_dur > 0 then --PRESICION
		chars_mobs_npcs[index].acu_buff_power = chars_mobs_npcs[index].acu_buff_power + chars_mobs_npcs[index].precision_power;	
	end;
	if chars_mobs_npcs[index].glamour_dur > 0 then --GLAMOUR
		chars_mobs_npcs[index].chr_buff_power = chars_mobs_npcs[index].chr_buff_power + chars_mobs_npcs[index].glamour_power;	
	end;
	if chars_mobs_npcs[index].blind_dur > 0 then --BLIND
		chars_mobs_npcs[index].sns_debuff_power = chars_mobs_npcs[index].sns_debuff_power + chars_mobs_npcs[index].blind_power;
		chars_mobs_npcs[index].acu_debuff_power = chars_mobs_npcs[index].acu_debuff_power + chars_mobs_npcs[index].blind_power;	
	end;
	if chars_mobs_npcs[index].darkgasp > 0 then --DARKGASP
		chars_mobs_npcs[index].sns_debuff_power = chars_mobs_npcs[index].sns_debuff_power + chars_mobs_npcs[index].darkgasp;
	end;
	if dlandscape_duration[chars_mobs_npcs[index].x][chars_mobs_npcs[index].y] == "ice" then --ICE
		chars_mobs_npcs[index].spd_debuff_power = math.max(chars_mobs_npcs[index].spd_debuff_power,math.ceil(chars_mobs_npcs[index].spd/2));
		chars_mobs_npcs[index].dex_debuff_power = math.max(chars_mobs_npcs[index].dex_debuff_power,math.ceil(chars_mobs_npcs[index].dex/2));
		chars_mobs_npcs[index].acu_debuff_power = math.max(chars_mobs_npcs[index].acu_debuff_power,math.ceil(chars_mobs_npcs[index].acu/2));
	end;
	if chars_mobs_npcs[index].poison_dur > 0  then --POISON
		if  chars_mobs_npcs[index].poison_status <  chars_mobs_npcs[index].hp then
			poison_mod1 = 0.75-chars_mobs_npcs[index].poison_power/100;
		else
			poison_mod1 = 0.5-chars_mobs_npcs[index].poison_power/100;
			poison_mod2 = 0.75-chars_mobs_npcs[index].poison_power/100;
		end;
	end;
	chars_mobs_npcs[index].mgt=math.ceil(math.max(1,chars_mobs_npcs[index].mgt*poison_mod1+chars_mobs_npcs[index].mgt_buff_power-chars_mobs_npcs[index].mgt_debuff_power));
	chars_mobs_npcs[index].enu=math.ceil(math.max(1,chars_mobs_npcs[index].enu*poison_mod1+chars_mobs_npcs[index].enu_buff_power-chars_mobs_npcs[index].enu_debuff_power));
	chars_mobs_npcs[index].dex=math.ceil(math.max(1,chars_mobs_npcs[index].dex*poison_mod1+chars_mobs_npcs[index].dex_buff_power-chars_mobs_npcs[index].dex_debuff_power));
	chars_mobs_npcs[index].spd=math.ceil(math.max(1,chars_mobs_npcs[index].spd*poison_mod1+chars_mobs_npcs[index].spd_buff_power-chars_mobs_npcs[index].spd_debuff_power));
	chars_mobs_npcs[index].acu=math.ceil(math.max(1,chars_mobs_npcs[index].acu*poison_mod1+chars_mobs_npcs[index].acu_buff_power-chars_mobs_npcs[index].acu_debuff_power));
	chars_mobs_npcs[index].sns=math.ceil(math.max(1,chars_mobs_npcs[index].sns*poison_mod2+chars_mobs_npcs[index].sns_buff_power-chars_mobs_npcs[index].sns_debuff_power));
	chars_mobs_npcs[index].int=math.ceil(math.max(1,chars_mobs_npcs[index].int*poison_mod2+chars_mobs_npcs[index].int_buff_power-chars_mobs_npcs[index].int_debuff_power));
	chars_mobs_npcs[index].spr=math.ceil(math.max(1,chars_mobs_npcs[index].spr*poison_mod2+chars_mobs_npcs[index].spr_buff_power-chars_mobs_npcs[index].spr_debuff_power));
	chars_mobs_npcs[index].chr=math.ceil(math.max(1,chars_mobs_npcs[index].chr*poison_mod2+chars_mobs_npcs[index].chr_buff_power-chars_mobs_npcs[index].chr_debuff_power));
	chars_mobs_npcs[index].luk=math.max(1,chars_mobs_npcs[index].luk+chars_mobs_npcs[index].luk_buff_power-chars_mobs_npcs[index].luk_debuff_power);
	
	chars_mobs_npcs[index].mgt=math.ceil(chars_mobs_npcs[index].mgt+chars_mobs_npcs[index].hourofpower_power);
	chars_mobs_npcs[index].enu=math.ceil(chars_mobs_npcs[index].enu+chars_mobs_npcs[index].hourofpower_power);
	chars_mobs_npcs[index].dex=math.ceil(chars_mobs_npcs[index].dex+chars_mobs_npcs[index].hourofpower_power);
	chars_mobs_npcs[index].spd=math.ceil(chars_mobs_npcs[index].spd+chars_mobs_npcs[index].hourofpower_power);
	chars_mobs_npcs[index].acu=math.ceil(chars_mobs_npcs[index].acu+chars_mobs_npcs[index].hourofpower_power);
	chars_mobs_npcs[index].sns=math.ceil(chars_mobs_npcs[index].sns+chars_mobs_npcs[index].hourofpower_power);
	chars_mobs_npcs[index].int=math.ceil(chars_mobs_npcs[index].int+chars_mobs_npcs[index].hourofpower_power);
	chars_mobs_npcs[index].spr=math.ceil(chars_mobs_npcs[index].spr+chars_mobs_npcs[index].hourofpower_power);
	
	--if chars_mobs_npcs[index].person=="char" then
	for e=1,#chars_mobs_npcs[index]["equipment"] do
		if chars_mobs_npcs[current_mob]["equipment"] > 0 then
			for f=1,#items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][e]].w].effects do
				if items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][e]].w].typ == "buff" or items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][e]].w].typ == "debuff" then
					chars_mobs_npcs[items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][e]].w].effects[f][1]] = chars_mobs_npcs[items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][e]].w].effects[f][1]] + items_modifers[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][e]].w].effects[f][2];
				end;
			end;
		end;
	end;
	--MELEE
	for i=1, #chars_mobs_npcs[index].arms do
		local hand = chars_mobs_npcs[index]["arms"][i];
		if chars_mobs_npcs[index]["equipment"][hand]~=0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].q > 0 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class ~= "shield" then
			if chars_mobs_npcs[index].lvl_sword>=2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class == "sword" then
				add_atkm = chars_mobs_npcs[index].num_sword;
			end
			if chars_mobs_npcs[index].lvl_axe >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class == "axe" then
				add_atkm = chars_mobs_npcs[index].num_axe;
			end;
			if chars_mobs_npcs[index].lvl_flagpole >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class == "flagpole" then
				add_atkm = chars_mobs_npcs[index].num_flagpole;
			end;
			if chars_mobs_npcs[index].lvl_crushing >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class == "crushing" then
				add_atkm = chars_mobs_npcs[index].num_crushing;
			end;
			if chars_mobs_npcs[index].lvl_staff >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class == "staff" then
				add_atkm = chars_mobs_npcs[index].num_staff;
			end;
			if chars_mobs_npcs[index].lvl_dagger >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class == "dagger" then
				add_atkm = chars_mobs_npcs[index].num_dagger;
			end;
			chars_mobs_npcs[index]["melee_stats"][hand].atkm=inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].atk+add_atkm;
			chars_mobs_npcs[index]["melee_stats"][hand].amel=inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].a;
			chars_mobs_npcs[index]["melee_stats"][hand].bmel=inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].b;
			chars_mobs_npcs[index]["melee_stats"][hand].cmel=inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].c;
		elseif chars_mobs_npcs[index]["equipment"][hand] == 0 and chars_mobs_npcs[index].lvl_unarmed == 0 then
			chars_mobs_npcs[index]["melee_stats"][hand].atkm = 0;
			chars_mobs_npcs[index]["melee_stats"][hand].amel = 1;
			chars_mobs_npcs[index]["melee_stats"][hand].bmel = 1;
			chars_mobs_npcs[index]["melee_stats"][hand].cmel = 0;
		elseif chars_mobs_npcs[index]["equipment"][hand] == 0 and chars_mobs_npcs[index].lvl_unarmed >= 1 then
			chars_mobs_npcs[index]["melee_stats"][hand].atkm = 0;
			chars_mobs_npcs[index]["melee_stats"][hand].amel = 1;
			chars_mobs_npcs[index]["melee_stats"][hand].bmel = 1;
			chars_mobs_npcs[index]["melee_stats"][hand].cmel = 0;
			if chars_mobs_npcs[index].lvl_unarmed >= 3 then
				chars_mobs_npcs[index]["melee_stats"][hand].atkm = chars_mobs_npcs[index].atkm+chars_mobs_npcs[index].num_unarmed;
			end;
			if chars_mobs_npcs[index].lvl_unarmed >= 2 then
				chars_mobs_npcs[index]["melee_stats"][hand].cmel = chars_mobs_npcs[index].cmel+chars_mobs_npcs[index].num_unarmed;
			end;
		elseif inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"][hand]].ttxid].class == "shield" then
			chars_mobs_npcs[index]["melee_stats"][hand].atkm = 0;
			chars_mobs_npcs[index]["melee_stats"][hand].amel = 0;
			chars_mobs_npcs[index]["melee_stats"][hand].bmel = 0;
			chars_mobs_npcs[index]["melee_stats"][hand].cmel = 0;
		end;
	end;
	--RANGED
	if chars_mobs_npcs[index]["equipment"].ranged ~= 0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].q > 0 and chars_mobs_npcs[index]["equipment"].ammo ~= 0 then
		add_atkr=0;
		if chars_mobs_npcs[index].lvl_bow >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].class == "bow" then
			add_atkr = chars_mobs_npcs[index].num_bow;
		end;
		if chars_mobs_npcs[index].lvl_crossbow >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].class == "crossbow" then
			add_atkr = chars_mobs_npcs[index].num_crossbow;
		end;
		if chars_mobs_npcs[index].lvl_firearms >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].class == "firearms" then
			add_atkr = chars_mobs_npcs[index].num_firearms;
		end;
		if chars_mobs_npcs[index].lvl_firearms >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].class == "blaster" then
			add_atkr = chars_mobs_npcs[index].num_blaster;
		end;
		chars_mobs_npcs[index].atkr = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].atk+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].atk+add_atkr;
		chars_mobs_npcs[index].arng = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].a+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].a;
		chars_mobs_npcs[index].brng = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].b+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].b;
		chars_mobs_npcs[index].crng = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ranged].ttxid].c+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].c;
	elseif chars_mobs_npcs[index]["equipment"].ranged == 0 then
		chars_mobs_npcs[index].atkr=0;
		chars_mobs_npcs[index].arng = 0;
		chars_mobs_npcs[index].brng = 0;
		chars_mobs_npcs[index].crng = 0;
	end;
	if chars_mobs_npcs[index]["equipment"].ammo ~= 0 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].class == "throwing" then
		if chars_mobs_npcs[index].lvl_throwing >= 2 and inventory_ttx[chars_mobs_npcs[index]["equipment"].ammo].class == "throwing" then
			add_atkr= chars_mobs_npcs[index].num_throwing;
		end
		chars_mobs_npcs[index].atkr = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].atk+add_atkr;
		chars_mobs_npcs[index].arng = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].a;
		chars_mobs_npcs[index].brng = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].b;
		chars_mobs_npcs[index].crng = inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].ammo].ttxid].c;
	end
	if chars_mobs_npcs[index]["equipment"].lh ~= 0 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].class == "shield" and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].q > 0 then
		chars_mobs_npcs[index].block= chars_mobs_npcs[index].block+inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].ac + math.ceil(chars_mobs_npcs[index].num_shield*chars_mobs_npcs[index].lvl_shield/2);
	end;
	if chars_mobs_npcs[index].acid_dur > 0 then
		chars_mobs_npcs[index].ac= chars_mobs_npcs[index].ac-chars_mobs_npcs[index].acid_power;
	else
		chars_mobs_npcs[index].acid_power=0;
	end;
	if chars_mobs_npcs[index]["equipment"].lh~=0 and chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].q > 0 then
		local add_parry = 0;
		if chars_mobs_npcs[index].lvl_sword >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].class == "sword" then
			add_parry = chars_mobs_npcs[index].num_sword*(chars_mobs_npcs[index].lvl_sword-3);
		end
		if chars_mobs_npcs[index].lvl_dagger >= 2 and inventory_ttx[chars_mobs_npcs[index]["inventory_list"][chars_mobs_npcs[index]["equipment"].lh].ttxid].class == "dagger" then
			add_parry = chars_mobs_npcs[index].num_dagger*(chars_mobs_npcs[index].lvl_dagger-3);
		end;
		chars_mobs_npcs[index].parry = chars_mobs_npcs[index].parry + add_parry;
	end;	
	--end;
	-- belts,cloaks
	
	chars_mobs_npcs[index].rng = 5+math.ceil((chars_mobs_npcs[index].spd+chars_mobs_npcs[index].dex)/10);
	chars_mobs_npcs[index].sense =10+math.ceil(chars_mobs_npcs[index].sns/5);
	
	helpers.recalcResistances(index);
end;

function helpers.recalcResistances (index)
	local tmpclass = nil;
	local tmpclass2 = nil;
	if chars_mobs_npcs[index].person == "mob" then
		tmpclass="mobs_stats." .. chars_mobs_npcs[index].class;
		tmpclass2=loadstring("return " .. tmpclass)();
	elseif chars_mobs_npcs[index].person == "npc" then
		tmpclass="mobs_stats." .. chars_mobs_npcs[index].class;
		tmpclass2=loadstring("return " .. tmpclass)();
	elseif chars_mobs_npcs[index].person == "char" then
		tmpclass2 = chars_stats[index];
	end;
	chars_mobs_npcs[index].rezfire = tmpclass2.rezfire;
	if chars_mobs_npcs[index].protfromfire_dur>0 then
		chars_mobs_npcs[index].rezfire= chars_mobs_npcs[index].rezfire+chars_mobs_npcs[index].protfromfire_power;
	else
		chars_mobs_npcs[index].protfromfire_power=0;
	end;
	chars_mobs_npcs[index].rezcold= tmpclass2.rezcold
	if chars_mobs_npcs[index].protfromcold_dur>0 then
		chars_mobs_npcs[index].rezcold= chars_mobs_npcs[index].rezcold+chars_mobs_npcs[index].protfromcold_power;
	else
		chars_mobs_npcs[index].protfromcold_power=0;
	end;
	chars_mobs_npcs[index].rezstatic= tmpclass2.rezstatic
	if chars_mobs_npcs[index].protfromstatic_dur>0 then
		chars_mobs_npcs[index].rezstatic= chars_mobs_npcs[index].rezstatic+chars_mobs_npcs[index].protfromstatic_power;
	else
		chars_mobs_npcs[index].protfromstatic_power=0;
	end;
	chars_mobs_npcs[index].rezstatic= tmpclass2.rezpoison;
	if chars_mobs_npcs[index].protfrompoison_dur>0 then
		chars_mobs_npcs[index].rezpoison= chars_mobs_npcs[index].rezpoison+chars_mobs_npcs[index].protfrompoison_power;
	else
		chars_mobs_npcs[index].protfrompoison_power=0;
	end
	chars_mobs_npcs[index].rezacid= tmpclass2.rezacid;
	if chars_mobs_npcs[index].protfromacid_dur>0 then
		chars_mobs_npcs[index].rezacid= chars_mobs_npcs[index].rezpacid+chars_mobs_npcs[index].protfromacid_power;
	else
		chars_mobs_npcs[index].protfromacid_power=0;
	end
	chars_mobs_npcs[index].rezdisease= tmpclass2.rezdisease;
	if chars_mobs_npcs[index].protfromdisease_dur>0 then
		chars_mobs_npcs[index].rezdisease= chars_mobs_npcs[index].rezdisease+chars_mobs_npcs[index].protfromdisease_power;
	else
		chars_mobs_npcs[index].protfromdisease_power=0;
	end
	chars_mobs_npcs[index].rezmind= tmpclass2.rezmind;
	if chars_mobs_npcs[index].protofmind_dur>0 then
		chars_mobs_npcs[index].rezmind= chars_mobs_npcs[index].rezmind+chars_mobs_npcs[index].protofmind_power;
	else
		chars_mobs_npcs[index].protofmind_power=0;
	end
	chars_mobs_npcs[index].rezspirit= tmpclass2.rezspirit;
	if chars_mobs_npcs[index].protofspirit_dur>0 then
		chars_mobs_npcs[index].rezspirit= chars_mobs_npcs[index].rezspirit+chars_mobs_npcs[index].protofspirit_power;
	else
		chars_mobs_npcs[index].protofspirit_power=0;
	end;
end;

function helpers.mobHasPockets (index)
	if (chars_mobs_npcs[index].nature == "humanoid" or chars_mobs_npcs[index].nature == "hybrid" or  chars_mobs_npcs[index].nature == "undead") and  chars_mobs_npcs[index].size == "nomal" then
		return true;
	end;
	return false;
end;

function helpers.isGold(index)
	if inventory_ttx[index].class == "gold" then
		return true
	end;
	return false;
end;

function helpers.isPaper(index)
	if inventory_ttx[index].class == "scroll" or inventory_ttx[index].class == "message" or inventory_ttx[index].class == "letter" or inventory_ttx[index].class == "map" then
		return true
	end;
	return false;
end;

function helpers.isKey(index)
	if inventory_ttx[index].class == "key" or inventory_ttx[index].class == "picklock" or inventory_ttx[index].class == "traptool" then
		return true
	end;
	return false;
end;

function helpers.isFood(index)
	if inventory_ttx[index].class == "food" then
		return true
	end;
	return false;
end;

function helpers.isPotion(index)
	if inventory_ttx[index].class == "potion" then
		return true
	end;
	return false;
end;

function helpers.isAlchemicalComponent(index)
	if inventory_ttx[index].class == "component" then
		return true
	end;
	return false;
end;

function helpers.isjewelry(index)
	if inventory_ttx[index].class == "jewelry" then
		return true
	end;
	return false;
end;

function helpers.isGem(index)
	if inventory_ttx[index].class == "gem" then
		return true
	end;
	return false;
end;

function helpers.isBook(index)
	if inventory_ttx[index].class == "book" or inventory_ttx[index].class == "spellbook" then
		return true
	end;
	return false;
end;

function helpers.isArt(index)
	if inventory_ttx[index].class == "gobelen" or inventory_ttx[index].class == "picture" or inventory_ttx[index].class == "artifact" then
		return true
	end;
	return false;
end;

function helpers.trapHere(x,y)
	for i=1,#bags_list do
		if bags_list[i].typ == "trap" and bags_list[i].traped and bags_list[i].x == x and bags_list[i].y == y then
			return i;
		end;
	end;
	return false;
end;

function helpers.bagIsVisible(index)
	if bags_list[index].typ == "bag" or bags_list[index].typ == "chest" or bags_list[index].typ == "skulls" or bags_list[index].typ == "trash" or bags_list[index].typ == "door" then
		return true;
	end;
	if bags_list[index].typ == "trap" or bags_list[index].typ == "secret" then
		if bags_list[index].detected then
			return true;
		end;
		if game_status == "sensing" and chars_mobs_npcs[current_mob].control == "player" and chars_mobs_npcs[current_mob].num_spothidden*chars_mobs_npcs[current_mob].lvl_spothidden >= bags_list[index].mask then
			if not bags_list[index].detected then
				--sound
				helpers.addToActionLog( lognames.actions.trapdetected);
				bags_list[index].detected = true;
			end;
			return true;
		end;
	end;
end;

function helpers.noSkill()
	love.audio.play(media.sounds.noskill, 0);
	if tmpskillname=="sword" or tmpskillname=="axe" or tmpskillname=="flagpole" or tmpskillname=="crushing" 
	or tmpskillname=="dagger" or tmpskillname=="stuff" 
	or tmpskillname=="bow" or tmpskillname=="crossbow" or tmpskillname=="throwing" or tmpskillname=="firearms" or tmpskillname=="blaster" then
		helpers.addToActionLog( chars_stats[current_mob].name .. lognames.actions.noskill .. tmpskillname2)
	elseif tmpskillname=="leather" or  tmpskillname=="chainmail" or  tmpskillname=="plate" or  tmpskillname=="shield" then
		helpers.addToActionLog( chars_stats[current_mob].name .. lognames.actions.noskill2 .. tmpskillname2)
	elseif tmpskillname=="fire" or  tmpskillname=="air" or  tmpskillname=="water" or  tmpskillname=="earth"
	or tmpskillname=="body" or  tmpskillname=="mind" or  tmpskillname=="spirit" or  tmpskillname=="light" or tmpskillname=="darkness" then
		helpers.addToActionLog( chars_stats[current_mob].name .. lognames.actions.noskill3);
	else
		helpers.addToActionLog( chars_stats[current_mob].name .. lognames.actions.noskill4);
	end;
end;

function helpers.ifMobHasMana () --FIXME strange NOT USABLE ATM, ll be deleted
	price_in_mana = magic.spell_tips[missle_type].mana;
	rec = magic.spell_tips[missle_type].recovery;
	if chars_mobs_npcs[current_mob].sp >= price_in_mana then
		if magic.spell_tips[missle_type].form == "sight" or magic.spell_tips[missle_type].form == "ray" or magic.spell_tips[missle_type].form == "vray" or magic.spell_tips[missle_type].form == "skyray" or magic.spell_tips[missle_type].form == "trident" or magic.spell_tips[missle_type].form == "level" then
			boomx = 1;
			boomy = 1;
		end;
		missle_drive = "spellbook";
		game_status = "sensing";
	elseif chars_mobs_npcs[current_mob]["equipment"].ranged > 0 and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].ttxid].class == "wand" and chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].q > 0 then
		love.audio.play(media.sounds.outofmana, 0);
		helpers.addToActionLog( lognames.actions.outofmana);
		missle_drive = "wand";
		missle_type = chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].w;
	else
		love.audio.play(media.sounds.outofmana, 0);
		helpers.addToActionLog( lognames.actions.outofmana);
		missle_drive = "muscles";
		if chars_mobs_npcs[current_mob]["equipment"].ammo > 0 then
			missle_type = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].ttxid].class;
		else
			missle_type = "none";
		end;
	end;
end;

function helpers.ifSpellIsCastable (drive) --FIXME not completed
	local area_check = false;
	local time_check = true; --FIXME
	local mindgame_check = false;
	local mana_check = false;
	local recovery_check = false;
	if magic.spell_tips[missle_type][leveltype] or (vlandscape_obj[chars_mobs_npcs[current_mpb].x][chars_mobs_npcs[current_mpb].y] == 1 and magic.spell_tips[missle_type].dungeon) then
		area_check = true;
	end;
	if global.status ~= "mindgame" or  (global.status == "mindgame" and magic.spell_tips[missle_type].mindgame) then
		mindgame_check = true;
	end;
	if (drive == "spellbook" and chars_mobs_npcs[current_mob].sp >= magic.spell_tips[missle_type].mana) or (drive == "wand" and chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].w > 0) or drive == "scroll" then
		mana_check = true;
	end;
	if chars_mobs_npcs[current_mob].rt >= magic.spell_tips[missle_type].recovery then
		recovery_check = true;
	end;
	if area_check and time_check and mindgame_check and mana_check and recovery_check then
		helpers.castReady (drive);
		return true;
	end;
	helpers.castFailed ();
	return false;
end;

function helpers.castReady (drive)
	price_in_mana = magic.spell_tips[missle_type].mana;
	rec = magic.spell_tips[missle_type].recovery;
	if magic.spell_tips[missle_type].form == "sight" or magic.spell_tips[missle_type].form == "ray" or magic.spell_tips[missle_type].form == "vray" or magic.spell_tips[missle_type].form == "skyray" or magic.spell_tips[missle_type].form == "trident" or magic.spell_tips[missle_type].form == "level" then
		boomx = 1;
		boomy = 1;
	end;
	missle_drive = drive;
	if global.status ~= "mindgame" then
		game_status = "sensing";
	else
		damage.mindGameCast();
	end;
end;

function helpers.ifTrickIsCastable () --FIXME not completed
	local time_check = true; --FIXME
	local stamina_check = false;
	local recovery_check = false;
	local weapon_check = false;

	if global.status ~= "mindgame" or  (global.status == "mindgame" and trick_tips[missle_type].mindgame) then
		mindgame_check = true;
	end;
	if chars_mobs_npcs[current_mob].st >= trick_tips[missle_type].stamina then
		stamina_check = true;
	end;
	if chars_mobs_npcs[current_mob].rt >= trick_tips[missle_type].recovery then
		recovery_check = true;
	end;
	local _missle_name = tricks.alltricks[_page][_circle];
	local _tipskill = tricks.trick_tips[_missle_name].weapon_skill;

	if _tipskill == "unarmed" and chars_mobs_npcs[current_mob]["equipment"].rh == 0 and chars_mobs_npcs[current_mob]["equipment"].lh == 0 then
		weapon_check = true;
	elseif (_tipskill == "sword" or _tipskill == "axe" or _tipskill == "crushing" or _tipskill == "flagpole" or _tipskill == "staff" or _tipskill == "dagger") and chars_mobs_npcs[current_mob]["equipment"].rh > 0 then
		weapon_check = true;
	elseif (_tipskill == "bow" or _tipskill == "crossbow" or _tipskill == "firearms" or _tipskill == "blaster") and chars_mobs_npcs[current_mob]["equipment"].ranged > 0 and chars_mobs_npcs[current_mob]["equipment"].ammo > 0 then
		weapon_check = true;
	elseif _tipskill == "throwing" and chars_mobs_npcs[current_mob]["equipment"].ammo > 0 then
		weapon_check = true;
	end;
	if weapon_check and time_check and mana_check and recovery_check then
		helpers.trickReady ();
		return true;
	end;
	helpers.castFailed ();
	return false;
end;

function helpers.trickReady ()
	price_in_st = magic.spell_tips[missle_type].stamina;
	rec = trick_tips[missle_type].recovery;
	if magic.spell_tips[missle_type].form == "sight" or magic.spell_tips[missle_type].form == "ray" or magic.spell_tips[missle_type].form == "vray" or magic.spell_tips[missle_type].form == "skyray" or magic.spell_tips[missle_type].form == "trident" or magic.spell_tips[missle_type].form == "level" then
		boomx = 1;
		boomy = 1;
	end;
	missle_drive = drive;
end;

function helpers.castFailed ()
	missle_drive = "muscles";
	missle_type = "none";
	love.audio.play(media.sounds.error,0);
	if global.status == "mindgame" then
		game_status = "mindgame"
	else
		game_status = "neutral"
	end;
end;

function helpers.ifHoldIsUsable ()
	local stamina_check = false;
	local recovery_check = false;
	local recovery = helpers.countMeleeRecoveryChar (current_mob);
	if chars_mobs_npcs[current_mob].st >= recovery + hold_tips[missle_effect].stamina then
		stamina_check = true;
	end;
	if chars_mobs_npcs[current_mob].rt >= recovery + hold_tips[missle_effect].recovery then
		recovery_check = true;
	end;
	if mana_check and recovery_check then
		helpers.castReady (drive);
		return true;
	end;
	helpers.holdFailed ();
	return false;
end;

function helpers.holdFailed ()
	love.audio.play(media.sounds.error,0);
	missle_effect = "none";
	game_status = "neutral"
end;

function helpers.ifSwitchLevel()
	if global.status == "peace" then
		local _level = 0;
		local _counter = 0;
		for i=chars,1,-1 do
			if chars_mobs_npcs[i].control == "player" and chars_mobs_npcs[i].status == 1 and plandscape[chars_mobs_npcs[i].x][chars_mobs_npcs[i].y] ~= 0 then
				_level = plandscape[chars_mobs_npcs[i].x][chars_mobs_npcs[i].y][1];
			end;
		end;
		if _level > 0 then
			for i=1,chars do
				if (plandscape[chars_mobs_npcs[i].x][chars_mobs_npcs[i].y][1] == _level or (chars_mobs_npcs[i].x == 0 and chars_mobs_npcs[i].y == 0)) then --control,status?
					_counter = _counter + 1;
				else
					return false;
				end;
			end;
			if _counter == chars then
				return level;
			else
				return false;
			end;
		end;
	else
		return false;
	end;
end;

function helpers.switchLevelAsk(switch_level)
	game_status = "switchlevel";
	local x,y = helpers.centerObject(media.images.map);
	global.buttons.g1_button = loveframes.Create("imagebutton");
	global.buttons.g1_button:SetImage(media.images.button9);
	global.buttons.g1_button:SetPos(x+135,y+395);
	global.buttons.g1_button:SizeToImage()
	global.buttons.g1_button:SetText("YES");
	global.buttons.g1_button.OnClick = function(object)
		helpers.switchLevel(switch_level);
	end;
	global.buttons.g1_button = loveframes.Create("imagebutton");
	global.buttons.g1_button:SetImage(media.images.button9);
	global.buttons.g1_button:SetPos(x+435,y+395);
	global.buttons.g1_button:SizeToImage()
	global.buttons.g1_button:SetText("NO");
	global.buttons.g1_button.OnClick = function(object)
		game_status="restoring";
	end;
	
	--next
	--picture
end;

function helpers.switchLevel(switch_level)
	--FIXME load new level with new mobs and npcs, effects of travelling if needed
	game_status = "neutral";
	for i=1,chars do
		if chars_mobs_npcs[i].status == 1 then
			global.level_to_load = plandscape[chars_mobs_npcs[i].x][chars_mobs_npcs[i].y][1];
		end;
	end;
	loveframes.util.RemoveAll();
	nextState = playingState;
	nextStateName = "playingState";
	currentState = loadingState;
	currentState.start(media, loadingFinished);
	local roll = math.random(1,3);
	local tmp = "media.images.preloader" .. roll;
	img_preloader = loadstring("return " .. tmp)();
	package.loaded[ 'levels.level1' ] = nil;
	package.loaded[ 'levels.level2' ] = nil;
	for i=1,chars do
		if chars_mobs_npcs[i].status == 1 then
			chars_mobs_npcs[i].x = plandscape[chars_mobs_npcs[i].x][chars_mobs_npcs[i].y][2];
			chars_mobs_npcs[i].y = plandscape[chars_mobs_npcs[i].x][chars_mobs_npcs[i].y][3];
		end;
	end;
end;

function helpers.partyMoveToPoint () --FIXME incorrect
	local area = {};
	local ring = boomareas.smallRingArea(cursor_world_x,cursor_world_y);
	if helpers.passCheck(cursor_world_x,cursor_world_y) then
		table.insert(area,{x=cursor_world_x,y=cursor_world_y});
	end;
	for i=1,#ring do
		if helpers.passCheck(ring[i].x,ring[i].y) then
			table.insert(area,ring[i]);
		end;
	end;
	if #area >= chars  then
		for i=1,#area do
			local _rnd = math.random(1,#area);
			local _tmp = area[_rnd];
			area[_rnd] = area[i];
			area[i] = _tmp;
		end;
		for i=1,chars do
			if chars_mobs_npcs[i].status == 1 and chars_mobs_npcs[i].control == "player" then
				chars_mobs_npcs[i].call = {};
				chars_mobs_npcs[i]["call"].x = area[i].x;
				chars_mobs_npcs[i]["call"].y = area[i].y;
				chars_mobs_npcs[i].ai = "called";
				chars_mobs_npcs[i].control = "ai";
				print("CALL",i,area[i].x,area[i].y);
				--game_status = "restoring";
			end;
		end;
	else
		return
	end;
end;


function helpers.battleorder ()
	utils.printDebug("helpers.battleorder called");
	while (#order_of_turns > 0) do
		table.remove(order_of_turns,1);
	end;
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].status == 1 and  chars_mobs_npcs[i].ai ~= "building" then
			if global.battle_start then
				chars_mobs_npcs[i].rt = chars_mobs_npcs[i].spd;
				if chars_mobs_npcs[i].rt > 200 then
					chars_mobs_npcs[i].rt = 200;
				end;
				table.insert(order_of_turns, {i, chars_mobs_npcs[i].rt});
			elseif not global.battle_start then
				table.insert(order_of_turns, {i, chars_mobs_npcs[i].rt});
			end;
		end;
	end;

	table.sort(order_of_turns, function(a,b) return a[2] > b[2] end);
	
	for i=1,#order_of_turns-1 do
		for j=1,#order_of_turns-1 do
			if order_of_turns[j][1] > order_of_turns[j+1][1] and order_of_turns[j][2] ==  order_of_turns[j+1][2] then
				local tmp = order_of_turns[j];
				order_of_turns[j] = order_of_turns[j+1];
				order_of_turns[j+1] = tmp;
			end;
		end;
	end;
	if global.battle_start and order_of_turns[1][2] < 200 then
		local add = 200 - order_of_turns[1][2];
		for i=1 ,#order_of_turns do
			chars_mobs_npcs[order_of_turns[i][1]].rt = chars_mobs_npcs[order_of_turns[i][1]].rt + add;
		end;
	end;
	if global.battle_start then
		current_mob = order_of_turns[1][1];
		global.battle_start = false;
	end;
	if chars_mobs_npcs[current_mob].control == "player" then
		love.audio.play(media.sounds.party_turn, 0);
	end;
	if global.status == "battle" then
		draw.lineOfOrder();
	end;
	trace.lookaround(current_mob);
	helpers.findShadows();
end;

function helpers.addToActionLog(string)
	table.insert(logactions, string);
	while (#logactions>100) do
		table.remove(logactions, 1);
	end;
end;

function helpers.countPathPrice (index)
	local price = 0;
	if way_of_the_mob and #way_of_the_mob > 0 then
		for i=1,#way_of_the_mob do
			price = price + helpers.countCurrentHexPrice (i,index);
		end;
	end;
	return price
end;

function helpers.countCurrentHexPrice (index_hex,index_mob)
	if way_of_the_mob and #way_of_the_mob > 0 then
		local hex_price = costs_table[map[way_of_the_mob[index_hex][2]][way_of_the_mob[index_hex][1]]];
		local mobility_bonus = chars_mobs_npcs[index_mob].mobility_power;
		local dex_bonus = math.ceil(chars_mobs_npcs[current_mob].dex/20);
		local spd_bonus = math.ceil(chars_mobs_npcs[current_mob].spd/20);
		if not helpers.mobDependsGround(index_mob) then
			hex_price = 5;
			mobility_bonus = 0;
			dex_bonus = 0;
		end;
		local price = math.max(5,20 + hex_price-mobility_bonus-dex_bonus-spd_bonus);
		return price
	else
		return 0
	end;
end;

function helpers.mobDependsGround(index)
	if chars_mobs_npcs[index].locomotion == "levitation"
	or chars_mobs_npcs[index].locomotion == "fly"
	or chars_mobs_npcs[index].locomotion == "swim"
	or chars_mobs_npcs[index].locomotion == "underground"
	or chars_mobs_npcs[index].levitation > 0
	or chars_mobs_npcs[index].wingsoflight > 0 then
		return false
	end;
	return true
end;

function helpers.limitStats ()
for i=1,chars do
	if chars_mobs_npcs[i].hp>chars_mobs_npcs[i].hp_max then chars_mobs_npcs[i].hp= chars_mobs_npcs[i].hp_max end;
	if chars_mobs_npcs[i].sp>chars_mobs_npcs[i].sp_max then chars_mobs_npcs[i].sp= chars_mobs_npcs[i].sp_max end;
	if chars_mobs_npcs[i].st>chars_mobs_npcs[i].st_max then chars_mobs_npcs[i].st= chars_mobs_npcs[i].st_max end;
	if chars_mobs_npcs[i].rt>200 then chars_mobs_npcs[i].rt=200 end;
	if chars_mobs_npcs[i].sp<0 then chars_mobs_npcs[i].sp=0 end;
	if chars_mobs_npcs[i].st<0 then chars_mobs_npcs[i].st=0 end;
	if chars_mobs_npcs[i].rt<0 then chars_mobs_npcs[i].rt=0 end;

	if chars_mobs_npcs[i].rezfire>100 then chars_mobs_npcs[i].rezfire=100 end;
	if chars_mobs_npcs[i].rezstatic>100 then chars_mobs_npcs[i].rezstatic=100 end;
	if chars_mobs_npcs[i].rezcold>100 then chars_mobs_npcs[i].rezcold=100 end;
	if chars_mobs_npcs[i].rezacid>100 then chars_mobs_npcs[i].rezacid=100 end;
	if chars_mobs_npcs[i].rezpoison>100 then chars_mobs_npcs[i].rezpoison=100 end;
	if chars_mobs_npcs[i].rezdisease>100 then chars_mobs_npcs[i].rezdisease=100 end;
	if chars_mobs_npcs[i].rezmind>100 then chars_mobs_npcs[i].rezmind=100 end;
	if chars_mobs_npcs[i].rezspirit>100 then chars_mobs_npcs[i].rezspirit=100 end;
	if chars_mobs_npcs[i].rezlight>100 then chars_mobs_npcs[i].rezlight=100 end;
	if chars_mobs_npcs[i].rezdarkness>100 then chars_mobs_npcs[i].rezdarkness=100 end;
	if chars_mobs_npcs[i].ac>100 then chars_mobs_npcs[i].ac=100 end;

	if chars_mobs_npcs[i].rezfire<0 then chars_mobs_npcs[i].rezfire=0 end;
	if chars_mobs_npcs[i].rezstatic<0 then chars_mobs_npcs[i].rezstatic=0 end;
	if chars_mobs_npcs[i].rezcold<0 then chars_mobs_npcs[i].rezcold=0 end;
	if chars_mobs_npcs[i].rezacid<0 then chars_mobs_npcs[i].rezacid=0 end;
	if chars_mobs_npcs[i].rezpoison<0 then chars_mobs_npcs[i].rezpoison=0 end;
	if chars_mobs_npcs[i].rezdisease<0 then chars_mobs_npcs[i].rezdisease=0 end;
	if chars_mobs_npcs[i].rezmind<0 then chars_mobs_npcs[i].rezmind=0 end;
	if chars_mobs_npcs[i].rezspirit<0 then chars_mobs_npcs[i].rezspirit=0 end;
	if chars_mobs_npcs[i].rezlight<0 then chars_mobs_npcs[i].rezlight=0 end;
	if chars_mobs_npcs[i].rezdarkness<0 then chars_mobs_npcs[i].rezdarkness=0 end;
	if chars_mobs_npcs[i].ac<0 then chars_mobs_npcs[i].ac=0 end;
	end;
end;

function helpers.inSlot(slot)
	local x,y = helpers.centerObject(media.images.inv1);
	if slot == "rh" and game_status == "inventory" and inv_page == 1 and mX > x+370 and mX < x+490 and mY>= y+100 and mY < y + 458 then
		return true;
	elseif slot == "armor" and game_status == "inventory" and inv_page == 1 and mX > x+490 and mX <= x+600 and mY>= y+100 and mY < y+340 then
		return true;
	elseif slot == "lh" and game_status == "inventory" and inv_page == 1 and mX > x+600 and mX <= x+740 and mY>= y+100 and mY < y+340 then
		return true;
	elseif slot == "head" and game_status == "inventory" and inv_page == 1 and mX > x+490 and mX <= x+600 and mY>= y and mY < y+100 then
		return true;
	elseif slot == "boots" and game_status == "inventory" and inv_page == 1 and mX > x+490 and mX <= x+600 and mY>= y+340 and mY < y+450 then
		return true;
	elseif slot == "ranged" and game_status == "inventory" and inv_page == 2 and mX > x+370 and mX < x+490 and mY>= y+100 and mY < y + 458 then
		return true;
	elseif slot == "ammo" and game_status == "inventory" and inv_page == 2 and mX > x+600 and mX <= x+740 and mY>= y+100 and mY < y+340 then
		return true;
	elseif slot == "amulet" and game_status == "inventory" and inv_page == 2 and mX > x+490 and mX <= x+600 and mY>= y and mY < y+100 then
		return true;
	elseif slot == "gloves" and game_status == "inventory" and inv_page == 1 and mX > x+600 and mX <= x+740 and mY>= y+340 and mY < y+450 then
		return true;
	elseif slot == "art" and game_status == "inventory" and inv_page == 2 and mX > x+490 and mX <= x+600 and mY>= y+340 and mY < y+450 then
		return true;
	elseif slot == "cloak" and game_status == "inventory" and inv_page == 2 and mX > x+490 and mX <= x+600 and mY>= y+100 and mY < y+300 then
		return true;
	elseif slot == "belt" and game_status == "inventory" and inv_page == 2 and mX > x+490 and mX <= x+600 and mY >= y+300 and mY < y+340 then
		return true;
	elseif slot == "ring1" and game_status == "inventory" and inv_page == 2 and mX > x+600 and mX <= x+640 and mY>= y+340 and mY < y+380 then
		return true;
	elseif slot == "ring2" and game_status == "inventory" and inv_page == 2 and mX > x+600 and mX <= x+640 and mY>= y+380 and mY < y+420 then
		return true;
	elseif slot == "ring3" and game_status == "inventory" and inv_page == 2 and mX > x+600 and mX <= x+640 and mY>= y+420 and mY < y+460 then
		return true;
	elseif slot == "ring4" and game_status == "inventory" and inv_page == 2 and mX > x+700 and mX <= x+740 and mY>= y+340 and mY < y+380 then
		return true;
	elseif slot == "ring5" and game_status == "inventory" and inv_page == 2 and mX > x+700 and mX <= x+740 and mY>= y+380 and mY < y+420 then
		return true;
	elseif slot == "ring6" and game_status == "inventory" and inv_page == 2 and mX > x+700 and mX <= x+740 and mY>= y+420 and mY < y+460 then
		return true;
	elseif slot == "comp7" and game_status == "alchemy" and mX > x+620 and mX <= x+655 and mY>= y+100 and mY < y+135 then
		return true;
	elseif slot == "comp8" and game_status == "alchemy" and mX > x+655 and mX <= x+695 and mY>= y+100 and mY < y+135 then
		return true;
	elseif slot == "comp9" and game_status == "alchemy" and mX > x+695 and mX <= x+730 and mY>= y+100 and mY < y+135 then
		return true;
	elseif slot == "tool1" and game_status == "alchemy" and mX > x+375 and mX <= x+485 and mY>= y+180 and mY < y+275 then
		return true;
	elseif slot == "tool2" and game_status == "alchemy" and mX > x+395 and mX <= x+465 and mY>= y+90 and mY < y+160 then
		return true;
	elseif slot == "tool3" and game_status == "alchemy" and mX > x+375 and mX <= x+485 and mY>= y+300 and mY < y+400 then
		return true;
	elseif slot == "tool4" and game_status == "alchemy" and mX > x+380 and mX <= x+500 and mY>= y+405 and mY < y+485 then
		return true;
	elseif slot == "tool5" and game_status == "alchemy" and mX > x+500 and mX <= x+620 and mY>= y+405 and mY < y+485 then
		return true;
	elseif slot == "tool6" and game_status == "alchemy" and mX > x+620 and mX <= x+740 and mY>= y+405 and mY < y+485 then
		return true;
	elseif slot == "bottle1" and game_status == "alchemy" and mX > x+655 and mX <= x+695 and mY>= y+200 and mY < y+280 then
		return true;
	elseif slot == "bottle2" and game_status == "alchemy" and mX > x+625 and mX <= x+655 and mY>= y+315 and mY < y+395 then
		return true;
	elseif slot == "bottle3" and game_status == "alchemy" and mX > x+685 and mX <= x+725 and mY>= y+315 and mY < y+395 then
		return true;
	elseif slot == "comp1" and game_status == "alchemy" and mX > x+620 and mX <= x+655 and mY>= y+185 and mY < y+220 then
		return true;
	elseif slot == "comp2" and game_status == "alchemy" and mX > x+620 and mX <= x+655 and mY>= y+220 and mY < y+255 then
		return true;
	elseif slot == "comp3" and game_status == "alchemy" and mX > x+620 and mX <= x+655 and mY>= y+255 and mY < y+295 then
		return true;
	elseif slot == "comp4" and game_status == "alchemy" and mX > x+700 and mX <= x+735 and mY>= y+185 and mY < y+220 then
		return true;
	elseif slot == "comp5" and game_status == "alchemy" and mX > x+700 and mX <= x+735 and mY>= y+220 and mY < y+255 then
		return true;
	elseif slot == "comp6" and game_status == "alchemy" and mX > x+700 and mX <= x+735 and mY>= y+255 and mY < y+295 then
		return true;
	elseif slot == "key" and game_status == "picklocking" and mX > x+445 and mX <= x+480 and mY>= y+205 and mY < y+290 then
		return true;
	elseif slot == "picklock" and game_status == "picklocking" and mX > x+385 and mX <= x+420 and mY>= y+205 and mY < y+290 then
		return true;
	elseif slot == "traptool" and game_status == "picklocking" and mX > x+445 and mX <= x+480 and mY>= y+305 and mY < y+390 then
		return true;
	elseif slot == "forcer" and game_status == "picklocking" and mX > x+380 and mX <= x+485 and mY>= y+100 and mY < y+135 then
		return true;
	end;
	return false;
end;

function helpers.bookWhatCircle()
	local x,y = helpers.centerObject(media.images.sbook);
	local _circle = false;
	if     math.sqrt((x+235-mX)^2+(y+140-70-mY)^2) < 55 then
		_circle = 1;
	elseif math.sqrt((x+385-mX)^2+(y+140-70-mY)^2) < 55 then	
		_circle = 2;
	elseif math.sqrt((x+385-mX)^2+(y+268-70-mY)^2) < 55 then
		_circle = 3;
	elseif math.sqrt((x+235-mX)^2+(y+268-70-mY)^2) < 55 then
		_circle = 4;
	elseif math.sqrt((x+235-mX)^2+(y+390-70-mY)^2) < 55 then
		_circle = 5;
	elseif math.sqrt((x+385-mX)^2+(y+390-70-mY)^2) < 55 then
		_circle = 6;
	elseif math.sqrt((x+615-mX)^2+(y+140-70-mY)^2) < 55 then
		_circle = 7;
	elseif math.sqrt((x+765-mX)^2+(y+140-70-mY)^2) < 55 then
		_circle = 8;
	elseif math.sqrt((x+615-mX)^2+(y+268-70-mY)^2) < 55 then
		_circle = 9;
	elseif math.sqrt((x+765-mX)^2+(y+268-70-mY)^2) < 55 then
		_circle = 10;
	elseif math.sqrt((x+615-mX)^2+(y+390-70-mY)^2) < 55 then
		_circle = 11;
	elseif math.sqrt((x+765-mX)^2+(y+390-70-mY)^2) < 55 then
		_circle = 12;
	end;
	return _circle;
end;

function helpers.bookCircles(_page)
	local _circle = helpers.bookWhatCircle ();
	local _missle_type = false;
	if game_status == "spellbook" then
		if _circle and _page then
			print("sb:::",_page,_circle);
			_missle_type = magic.allspells[_page][_circle];
		end;
	elseif game_status == "warbook" then
		if _circle and _page then
			print("wb:::",_page,_circle);
			_missle_type = tricks.alltricks[_page][_circle];
		end;
	elseif game_status == "abilitiesbook" then
		if _circle and _page then
			_missle_type = abilities.allabils[_page][_circle];
		end;
	end;
	return _missle_type;
end;

function helpers.doNotFeelHunger(index)
	if not helpers.aliveNature(index) or chars_mobs_npcs[index].satiation > 0 then
		return true;
	end;
	return false;
end;

function helpers.addHunger(index,value)
	if helpers.aliveNature(index) then
		chars_mobs_npcs[index].satiation = chars_mobs_npcs[index].satiation - value;
		if chars_mobs_npcs[index].satiation < 0 and chars_mobs_npcs[index].hp > 0 and not helpers.mobHasPerk(index,"ascetic") then
			chars_mobs_npcs[index].weakness = 5;
			local mob_name = helpers.mobName(index);
			helpers.addToActionLog( mob_name .. lognames.actions.starves[chars_mobs_npcs[current_mob].gender]);
		end;
		if chars_mobs_npcs[index].satiation < -chars_mobs_npcs[index].enu and chars_mobs_npcs[index].status == 1 then
			chars_mobs_npcs[index].hp = 0;
			local mob_name = helpers.mobName(index);
			helpers.addToActionLog( mob_name .. lognames.actions.uncondfstarve[chars_mobs_npcs[current_mob].gender]);
		end;
		damage.HPcheck(index);
	end;
end;

function helpers.mobHasPerk(index,perk)
	for i=1,#chars_mobs_npcs[index]["perks"] do
		if chars_mobs_npcs[index]["perks"][i] == perk then
			return true;
		end;
	end;
	return false;
end;

function helpers.addSatiation(index,value)
	chars_mobs_npcs[index].satiation = math.min(chars_mobs_npcs[index].satiation+value,chars_mobs_npcs[index].enu*10);
end;

function helpers.clearHlandscapeUnderMobs()
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].motion == "walking" then
			helpers.clearHlandscape(chars_mobs_npcs[i].x,chars_mobs_npcs[i].y);
		end; 
	end;
end;

function helpers.clearHlandscapeUnderObjectsAndBags()
	for i=1,#objects_list do
		helpers.clearHlandscape(objects_list[i].xi,objects_list[i].yi);
	end;
	for i=1,#bags_list do
		helpers.clearHlandscape(bags_list[i].xi,bags_list[i].yi);
	end;
end;

function helpers.clearHlandscape(x,y)
	hlandscape[y][x] = 0;
end;

function helpers.mobAtBody (index)
	mobs_at_hex=0;
	for e=1,#chars_mobs_npcs do
		if chars_mobs_npcs[index].x==hex_x and chars_mobs_npcs[tmp_mobb].y== hex_y and chars_mobs_npcs[index].status==1 then
			mobs_at_hex=mobs_at_hex+1;
		end;
	end;
	return mobs_at_hex;
end;

function helpers.musicPull() --FIXME not completed
	return false
end;

function helpers.turnMob (index) --FIXME 2hex
	if chars_mobs_npcs[index].hexes == 1 then
		if  point_to_go_x<chars_mobs_npcs[index].x and point_to_go_y<chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].rot=6;
		end;
		if point_to_go_x>chars_mobs_npcs[index].x and point_to_go_y<chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].rot=1;
		end;
		if  point_to_go_x<chars_mobs_npcs[index].x and point_to_go_y>chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].rot=4;
		end;
		if point_to_go_x>chars_mobs_npcs[index].x and point_to_go_y>chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].rot=3;
		end; 
		if point_to_go_x>chars_mobs_npcs[index].x and point_to_go_y== chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].rot=2;
		end;
		if point_to_go_x<chars_mobs_npcs[index].x and point_to_go_y== chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].rot=5;
		end;
		if point_to_go_x== chars_mobs_npcs[index].x and chars_mobs_npcs[index].y/2~=math.ceil(chars_mobs_npcs[index].y/2) and point_to_go_y<chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].rot=6;
		end;
		if point_to_go_x== chars_mobs_npcs[index].x and chars_mobs_npcs[index].y/2~=math.ceil(chars_mobs_npcs[index].y/2) and point_to_go_y>chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].rot=4;
		end;
		if point_to_go_x== chars_mobs_npcs[index].x and chars_mobs_npcs[index].y/2==math.ceil(chars_mobs_npcs[index].y/2) and point_to_go_y<chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].rot=1;
		end;
		if point_to_go_x== chars_mobs_npcs[index].x and chars_mobs_npcs[index].y/2==math.ceil(chars_mobs_npcs[index].y/2) and point_to_go_y>chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].rot=3;
		end;
		if point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y < chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].view=8; --look straight up
		elseif point_to_go_x == chars_mobs_npcs[index].x and point_to_go_y > chars_mobs_npcs[index].y then
			chars_mobs_npcs[index].view=7; --look straight down
		elseif point_to_go_x ~= chars_mobs_npcs[index].x then
			chars_mobs_npcs[index].view= chars_mobs_npcs[index].rot; --standart
		end;
		if chars_mobs_npcs[index].control=="player" and game_status == "sensing" then
			trace.all_to_darkness();
			trace.trace_hexes(index,false,trace.sightArray (index));
			trace.one_around(index);
			trace.clear_rounded();
		elseif chars_mobs_npcs[index].control=="player" and game_status == "attack" then
			trace.first_watch(index);
			trace.clear_rounded();
		end;
	else
		--check where is opponent
		--do not turn or anti-turn
	end;
end;

function helpers.ifUmbrella ()
	local ring1 = boomareas.smallRingArea(chars_mobs_npcs[victim].x,chars_mobs_npcs[victim].y);
	local ring2 = boomareas.smallRingArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
	local _protectors = {};
	local _protectors2 = {};
	local index = false
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].trick == "umbrella" and i ~= victim and i ~= current_mob and chars_mobs_npcs[i].party == chars_mobs_npcs[victim].party and chars_mobs_npcs[i].control == chars_mobs_npcs[victim].control then
			for i=h,#ring1 do
				if chars_mobs_npcs[i].x == ring1[h].x and chars_mobs_npcs[i].y == ring1[h].y then
					table.insert(_protectors,{i,1});
				end;
			end;
			for i=h,#ring2 do
				if chars_mobs_npcs[i].x == ring1[h].x and chars_mobs_npcs[i].y == ring1[h].y then
					table.insert(_protectors,{i,2});
				end;
			end;
		end;
	end;
	for i=1,#_protectors do
		for h=1,#_protectors2 do
			if _protectors[i][1] == _protectors2[h][1]then
				_protectors2[h][2] = _protectors2[h][2] + _protectors[i][2];
			else
				table.insert(_prtotectors[2],_protectors[i]);
			end;
		end;
	end;
	if #_protectors2 > 1 then
		local _rnd = math.random(1,#_protectors2);
		return _protectors2[_rnd];
	else
		return index;
	end;
end;

function helpers.ifShore ()
	local ring = boomareas.smallRingArea(chars_mobs_npcs[victim].x,chars_mobs_npcs[victim].y);
	local _shored = {};
	local index = false
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].trick == "shore" and i ~= victim and i ~= current_mob and chars_mobs_npcs[i].party ~= chars_mobs_npcs[victim].party and chars_mobs_npcs[i].control ~= chars_mobs_npcs[victim].control then
			for i=h,#ring do
				if chars_mobs_npcs[i].x == ring[h].x and chars_mobs_npcs[i].y == ring[h].y then
					table.insert(_shored,i);
				end;
			end;
		end;
	end;
	if #_shored > 1 then
		local _rnd = math.random(1,#_shored);
		return _shored[_rnd];
	else
		return index;
	end;
end;

function helpers.findPlaceBehindAnEnemy (index)
	local x,y = 0;
	local ring = boomareas.smallRingArea(chars_mobs_npcs[index].x,chars_mobs_npcs[index].y);
	local x = ring[helpers.antiDirection(chars_mobs_npcs[index].rot)].x;
	local y = ring[helpers.antiDirection(chars_mobs_npcs[index].rot)].y;
	if helpers.passCheck (x,y) then
		return x,y;
	else
		return 0,0;
	end;
end;
