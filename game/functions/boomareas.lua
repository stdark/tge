boomareas = {};

function boomareas.smallRingArea(x,y)
	local ring = {};
	local xdirections = {};
	local ydirections = {};
	local ydirections = directions[1].y
	local xdirections= {};
	local halfy = y/2;
	if halfy == math.ceil(halfy) then
		xdirections = directions[1].xc;
	else
		xdirections = directions[1].xn;
	end;
	for k=1,6 do
		local xx = x+xdirections[k];
		local yy = y+ydirections[k];
		if helpers.insideMap (xx,yy) then
			table.insert(ring,{x=xx,y=yy});
		end;
	end;
	return ring;
end;

function boomareas.ringArea(x,y)
	local rings = {};
	local xdirections = {};
	local ydirections = {};
	for i=1,3 do
		rings[i] = {};
		xdirections[i] = {};
		ydirections[i] = {};
		ydirections[i] = directions[i].y
		if y/2 == math.ceil(y/2) then
			xdirections[i] = directions[i].xc;
		elseif y/2~=math.ceil(y/2) then
			xdirections[i] = directions[i].xn;
		end;
	end;
	rings[4] = {};
	table.insert(rings[4],{x=x,y=y});
	for k=1,6 do
		if ((x+xdirections[1][k]) <= map_w or (x+xdirections[1][k]) > 0)
		and ((y+ydirections[1][k]) <= map_h or (y+ydirections[1][k]) > 0)
		and helpers.voidIsNotaProblem(x,y,x+xdirections[1][k],y+ydirections[1][k])
		--and map[][] check pass
		then
			table.insert(rings[1],{x=x+xdirections[1][k],y=y+ydirections[1][k]});
		end;
	end;
	for k=1,12 do
		if ((x+xdirections[2][k]) <= map_w or (x+xdirections[2][k]) > 0)
		and ((y+ydirections[2][k]) <= map_h or (y+ydirections[2][k]) > 0)
		and helpers.voidIsNotaProblem(x,y,x+xdirections[2][k],y+ydirections[2][k])
		--and map[][] check pass
		then
			table.insert(rings[2],{x=x+xdirections[2][k],y=y+ydirections[2][k]});
		end;
	end;
	for k=1,18 do
		if ((x+xdirections[3][k]) <= map_w or (x+xdirections[3][k]) > 0)
		and ((y+ydirections[3][k]) <= map_h or (y+ydirections[3][k]) > 0)
		and helpers.voidIsNotaProblem(x,y,x+xdirections[3][k],y+ydirections[3][k])
		--and map[][] check pass
		then
			table.insert(rings[3],{x=x+xdirections[3][k],y=y+ydirections[3][k]});
		end;
	end;
	return rings
end;

function boomareas.showerArea(x,y, clearance,power) -- clearance 12/18, power 1-3 
	local boomarea = {};
	for i=1,8 do -- 7 stars,stones to [8] + circle around of each
		boomarea[i] = {};
	end;
	if helpers.passCheck(x,y) and helpers.voidIsNotaProblem(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,x,y) then
		table.insert(boomarea[1],{x=x,y=y});
		table.insert(boomarea[1],{x=x,y=y});
	end;
	for i=2,clearance,clearance/6 do
		local xdirections = {};
		local ydirections = {};
		ydirection = directions[clearance/6].y
		if y/2 == math.ceil(y/2) then
			xdirection = directions[clearance/6].xc;
		elseif y/2~=math.ceil(y/2) then
			xdirection = directions[clearance/6].xn;
		end;
		if helpers.passCheck(x+xdirection[i],y+ydirection[i])  and helpers.voidIsNotaProblem(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,x+xdirection[i],y+ydirection[i])then
			table.insert(boomarea[1],{x=x+xdirection[i],y=y+ydirection[i]});
		end;
	end;
	for j=2,#boomarea[1] do -- circles
		boomarea[j] = boomareas.ringArea(boomarea[1][j].x,boomarea[1][j].y);
	end;
	local sharea = {};
	for h=1, #boomarea[1] do -- filter
		for j=1, power do
			for i=1,#boomarea[h][power] do
				local todo = -1;
				for k=1, #sharea do -- remove duplicates and calculate dmg
					if sharea[k].x == boomarea[h][power][i].x and sharea[k].y == boomarea[h][power][i].y then
						todo = k;
					end;
				end;
				for k=1, #boomarea[1] do -- remove stones/stars hexes
					if boomarea[1][k].x == boomarea[h][power][i].x and boomarea[1][k].y == boomarea[h][power][i].y then
						todo = 0;
					end;
				end;
				if todo > 0 then
					sharea[todo].power = sharea[todo].power + 10^j/10
				elseif todo == -1 then
					if helpers.passCheck(boomarea[h][power][i].x,boomarea[h][power][i].y) then
						table.insert(sharea,{x=boomarea[h][power][i].x,y=boomarea[h][power][i].y,power=math.ceil(10^j/10)});
					end;
				end;
			end;
		end;
	end;
	return boomarea,sharea
end;

function boomareas.wallArea(x,y,direction,power) -- direction 1-6, power 1,2,3 (3,5,7 hexes)
	local boomarea = {};
	if helpers.passCheck(cursor_world_x,cursor_world_y) and not helpers.cursorAtMob(cursor_world_x,cursor_world_y) then
		table.insert(boomarea,{x=x,y=y});
		local rings = boomareas.ringArea(x,y);
		for i=1, power do
			local length = 6*i;
			local adirection = direction*i;
			local bdirection = 0;
			if	adirection <= math.ceil(length/2) then
				bdirection = adirection + math.ceil(length/2);
			else
				bdirection = adirection - math.ceil(length/2);
			end;
			if	helpers.insideMap(rings[i][adirection].x,rings[i][adirection].y) and helpers.passCheck(rings[i][adirection].x,rings[i][adirection].y) then
				table.insert(boomarea,{x=rings[i][adirection].x,y=rings[i][adirection].y});
			end;
			if	helpers.insideMap(rings[i][bdirection].x,rings[i][bdirection].y) and helpers.passCheck(rings[i][bdirection].x,rings[i][bdirection].y) then
				table.insert(boomarea,{x=rings[i][bdirection].x,y=rings[i][bdirection].y});
			end;
		end;
	end;
	return boomarea;
end;

function boomareas.rayArea(x,y,direction,power,passing) -- x,y -- current_mob,direction 1-6, passing 0/1 !--add pass mobs
	local boomarea = {};
	local addx = 0;
	local addy = 0;
	local newx = x;
	local newy = y;
	if direction == 1 then
		addx = 1;
		addy = -1;
	elseif direction == 2 then
		addx = 1;
	elseif direction == 3 then
		addx = 1;
		addy = 1;
	elseif direction == 4 then
		addx = -1;
		addy = 1;
	elseif direction == 5 then
		addx = -1;
	elseif direction == 6 then
		addx = -1;
		addy = -1;
	end;
	for i=1,power do
	if (direction == 1 or direction == 3) and (newy+addy)/2 == math.ceil((newy+addy)/2) then
		newx = newx + addx;
		newy = newy + addy;
	elseif (direction == 1 or direction == 3) and (newy+addy)/2 ~= math.ceil((newy+addy)/2) then
		newy = newy + addy;
	elseif (direction == 4 or direction == 6) and (newy+addy)/2 ~= math.ceil((newy+addy)/2) then
		newx = newx + addx;
		newy = newy + addy;
	elseif (direction == 4 or direction == 6) and (newy+addy)/2 == math.ceil((newy+addy)/2) then
		newy = newy + addy;
	elseif direction == 2 or direction == 5 then
		newx = newx + addx;
		newy = newy + addy;
	end;
		if helpers.insideMap(newx,newy) and helpers.passCheck(newx,newy) and helpers.voidIsNotaProblem(x,y,newx,newy) then
			table.insert(boomarea,{x=newx,y=newy});
		elseif (not helpers.insideMap(newx,newy) or not helpers.passLev(newx,newy)) and passing == 0 then
			break;
		end;
	end;
	return boomarea
end;

function boomareas.vrayArea(x,y,direction,passing) -- x,y -- current_mob,direction 1-6
	local boomarea = {};
	local addx = 0;
	local addy = 0;
	local newx = x;
	local newy = y;
	local addToTable = true;
	
	if direction == 1 then
		addx = 1;
		addy = -1;
	elseif direction == 2 then
		addx = 1;
	elseif direction == 3 then
		addx = 1;
		addy = 1;
	elseif direction == 4 then
		addx = -1;
		addy = 1;
	elseif direction == 5 then
		addx = -1;
	elseif direction == 6 then
		addx = -1;
		addy = -1;
	end;
	for i=1,11 do
	local rings = {}
	if (direction == 1 or direction == 3) and (newy+addy)/2 == math.ceil((newy+addy)/2) then
		newx = newx + addx;
		newy = newy + addy;
	elseif (direction == 1 or direction == 3) and (newy+addy)/2 ~= math.ceil((newy+addy)/2) then
		newy = newy + addy;
	elseif (direction == 4 or direction == 6) and (newy+addy)/2 ~= math.ceil((newy+addy)/2) then
		newx = newx + addx;
		newy = newy + addy;
	elseif (direction == 4 or direction == 6) and (newy+addy)/2 == math.ceil((newy+addy)/2) then
		newy = newy + addy;
	elseif direction == 2 or direction == 5 then
		newx = newx + addx;
	end;
		if helpers.insideMap(newx,newy) and helpers.passCheck(newx,newy) and helpers.voidIsNotaProblem(x,y,newx,newy) then
			addToTable = true;
			for j=1,#boomarea do
				if newx == boomarea[j].x and newy == boomarea[j].y then
					addToTable = false;
				end;
			end;
			if addToTable == true then
				table.insert(boomarea,{x=newx,y=newy});
			end;
			if i > 1 and i < 9 then
				rings = boomareas.ringArea(newx,newy);
			end;
			if i > 1 and i < 8 then
				for h=1,6 do
					addToTable = true;
					for j=1,#boomarea do
						if rings[1][h].x == boomarea[j].x and rings[1][h].y == boomarea[j].y then
							addToTable = false;
						end;
					end;
					if addToTable == true then
						table.insert(boomarea,{x=rings[1][h].x,y=rings[1][h].y});
					end;
				end;
			end;
			if i > 4 and i < 9  then
				for h=1,12 do
					addToTable = true;
					for j=1,#boomarea do
						if rings[2][h].x == boomarea[j].x and rings[2][h].y == boomarea[j].y then
							addToTable = false;
						end;
					end;
					if addToTable == true then
						table.insert(boomarea,{x=rings[2][h].x,y=rings[2][h].y});
					end;
				end;
			end;
			
			if i == 7 then
				for h=1,18 do
					addToTable = true;
					for j=1,#boomarea do
						if rings[3][h].x == boomarea[j].x and rings[3][h].y == boomarea[j].y then
							addToTable = false;
						end;
					end;
					if addToTable == true then
						table.insert(boomarea,{x=rings[3][h].x,y=rings[3][h].y});
					end;
				end;
			end;
			
		elseif (not helpers.insideMap(newx,newy) or not helpers.passLev(newx,newy)) and passing == 0 then
			break;
		end;
	end;
	return boomarea
end;

function boomareas.tridentArea (x,y,maindirection,power,passing)
	local boomarea = {};
	local addx = 0;
	local addy = 0;
	local newx = x;
	local newy = y;
	local subdirections = {{1,6,2},{2,1,3},{3,2,4},{4,3,5},{5,4,6},{6,5,1}};
	for h = 1,3 do
		local direction = subdirections[maindirection][h];
		newx = x;
		newy = y;
		if direction == 1 then
			addx = 1;
			addy = -1;
		elseif direction == 2 then
			addx = 1;
		elseif direction == 3 then
			addx = 1;
			addy = 1;
		elseif direction == 4 then
			addx = -1;
			addy = 1;
		elseif direction == 5 then
			addx = -1;
		elseif direction == 6 then
			addx = -1;
			addy = -1;
		end;
		for i=1,power do
			if (direction == 1 or direction == 3) and (newy+addy)/2 == math.ceil((newy+addy)/2) then
				newx = newx + addx;
				newy = newy + addy;
			elseif (direction == 1 or direction == 3) and (newy+addy)/2 ~= math.ceil((newy+addy)/2) then
			newy = newy + addy;
			elseif (direction == 4 or direction == 6) and (newy+addy)/2 ~= math.ceil((newy+addy)/2) then
				newx = newx + addx;
				newy = newy + addy;
			elseif (direction == 4 or direction == 6) and (newy+addy)/2 == math.ceil((newy+addy)/2) then
				newy = newy + addy;
			elseif direction == 2 or direction == 5 then
				newx = newx + addx;
			end;
			
			if helpers.insideMap(newx,newy) and helpers.passCheck(newx,newy) and helpers.voidIsNotaProblem(x,y,newx,newy) then
				table.insert(boomarea,{x=newx,y=newy});
			else
				break;
			end;
		end;
	end;
	return boomarea
end;

function boomareas.waveArea (x,y,maindirection,power,passing)
	local boomarea = {};
	local hexes_to_sense = {};
	local subdirections = {{1,6,2},{2,1,3},{3,2,4},{4,3,5},{5,4,6},{6,5,1}};
	for k = 2, power do
		local farhexes = {};
		local xx = x;
		local yy = y;
		local newx = x;
		local newy = y;
		local addx = 0;
		local addy = 0;
		local maindirection2 = maindirection;
		local pointChanged = false;
		for h = 1,3 do
			if h == 2 and not pointChanged and #farhexes > 0 then
				xx = farhexes[#farhexes].x;
				yy = farhexes[#farhexes].y;
				maindirection2 = helpers.antiDirection(maindirection);
				while #farhexes > 1 do
					table.remove(farhexes,1);
				end;
				pointChanged = true;
			end;
			local direction = subdirections[maindirection2][h];
			newx = xx;
			newy = yy;
			if direction == 1 then
				addx = 1;
				addy = -1;
			elseif direction == 2 then
				addx = 1;
			elseif direction == 3 then
				addx = 1;
				addy = 1;
			elseif direction == 4 then
				addx = -1;
				addy = 1;
			elseif direction == 5 then
				addx = -1;
			elseif direction == 6 then
				addx = -1;
				addy = -1;
			end;
			for i=1,k do
				if (direction == 1 or direction == 3) and (newy+addy)/2 == math.ceil((newy+addy)/2) then
					newx = newx + addx;
					newy = newy + addy;
				elseif (direction == 1 or direction == 3) and (newy+addy)/2 ~= math.ceil((newy+addy)/2) then
				newy = newy + addy;
				elseif (direction == 4 or direction == 6) and (newy+addy)/2 ~= math.ceil((newy+addy)/2) then
					newx = newx + addx;
					newy = newy + addy;
				elseif (direction == 4 or direction == 6) and (newy+addy)/2 == math.ceil((newy+addy)/2) then
					newy = newy + addy;
				elseif direction == 2 or direction == 5 then
					newx = newx + addx;
				end;
				if helpers.insideMap(newx,newy) and helpers.passJump(newx,newy) and helpers.voidIsNotaProblem(x,y,newx,newy) then
					table.insert(farhexes,{x=newx,y=newy});
				elseif not helpers.insideMap(newx,newy) then
				end;
			end;
		end;
		for i=1,#farhexes do
			local hexid = (farhexes[i].x-1)*map_w+farhexes[i].y;
			table.insert(hexes_to_sense,{all_ground_hexes[hexid].id,all_ground_hexes[hexid].visibility}); --id and sight
		end;
		--boomarea = farhexes;
	end;
	boomarea = trace.trace_for_boom (hexes_to_sense,passing);
	return boomarea;
end;

function boomareas.sightArea ()
	local boomarea = {};
	trace.sightArray (current_mob);
	darkness_temp = darkness[chars_mobs_npcs[current_mob].party];
	for i=1,map_w do
		for h=1,map_h do
			if darkness_temp[i][h] == 0 and helpers.passLev(h,i) and not (chars_mobs_npcs[current_mob].x == h and chars_mobs_npcs[current_mob].y == i ) and helpers.voidIsNotaProblem(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,h,i) then
				table.insert(boomarea,{x=h,y=i});
			end;
		end;
	end;
	return boomarea;
end;

function boomareas.levelArea ()
	local boomarea = {};
	for i=1,map_w do
		for h=1,map_h do
			if helpers.voidIsNotaProblem(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,h,i) then
				table.insert(boomarea,{x=h,y=i});
			end;
		end;
	end;
	return boomarea;	
end;

function boomareas.pathArea (mode,ignoreMobs)
	local way = path_finding(mode,ignoreMobs);
	local boomarea = {};
	for i=1,#way_of_the_mob do
		table.insert(boomarea, {x=way[i][1],y=way[i][2],r=way[i][6]});
	end;
	--table.insert(boomarea,{cursor_world_x,cursor_world_y});
	return boomarea;
 end
 
function boomareas.chainArea (x,y,length,width)
    local boomarea = {};
    mobsfound = {};
    local mobsmarked = {};
    local tmpx = 0;
    local tmpy = 0;
    local aimx = cursor_world_x;
    local aimy = cursor_world_y;
    local selectedmob = 1;
    local alreadymarked = 0;
    local linetable = {};
    local linex, liney = helpers.hexToPixels(cursor_world_x,cursor_world_y);
    table.insert(linetable,linex+32);
	table.insert(linetable,liney+16);
	for i = 1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].x == aimx and chars_mobs_npcs[i].y == aimy  then
			table.insert(mobsfound,i);
			table.insert(mobsmarked,i);
		end;
	end;
	for j = 1,length do
		while (#mobsfound > 0) do
			table.remove(mobsfound,1);
		end;
		
		local rings = boomareas.ringArea(x,y);
		for m = 1,width do
			for n = 1, 6*m do
				for i=1,#chars_mobs_npcs do
					alreadymarked = 0;
					for h=1,#mobsmarked do
						if mobsmarked[h] == i then
							alreadymarked = 1;
						end;
					end;
					if chars_mobs_npcs[i].x == rings[m][n].x and chars_mobs_npcs[i].y == rings[m][n].y and alreadymarked == 0 then
						table.insert(mobsfound,i);
					end;
				end;
			end;
		end;
		if #mobsfound > 0 then
			selectedmob = global_rnd[#mobsfound]; -- nearest! FIXME
			table.insert(mobsmarked,mobsfound[selectedmob]);
		else
			j = chars_mobs_npcs[current_mob].lvl_air;
		end;  
	end;
	for i=1,#mobsmarked do
		draw.drawHex(chars_mobs_npcs[mobsmarked[i]].x,chars_mobs_npcs[mobsmarked[i]].y,cursor_danger,hex_ui);
		moveto_hex_y=math.ceil(chars_mobs_npcs[mobsmarked[i]].y-1)*tile_h*0.75+top_space
		if chars_mobs_npcs[mobsmarked[i]].y/2 == math.ceil(chars_mobs_npcs[mobsmarked[i]].y/2 ) then
			moveto_hex_x=math.ceil(chars_mobs_npcs[mobsmarked[i]].x-1)*tile_w+left_space
		else
			moveto_hex_x=math.ceil(chars_mobs_npcs[mobsmarked[i]].x-1)*tile_w+left_space+tile_w/2
		end;
		local linex, liney = helpers.hexToPixels(chars_mobs_npcs[mobsmarked[i]].x,chars_mobs_npcs[mobsmarked[i]].y);
		table.insert(linetable,linex+32);
		table.insert(linetable,liney+16);
		table.insert(boomarea, {x = chars_mobs_npcs[mobsmarked[i]].x, y = chars_mobs_npcs[mobsmarked[i]].y});		
	end;
    return boomarea,linetable,mobsmarked;
end;

function boomareas.signArea (sign,value)
	local boomarea = {};
	for j=1,#chars_mobs_npcs do
		if chars_mobs_npcs[j][sign] == value and helpers.voidIsNotaProblem(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[j].x,chars_mobs_npcs[j].y) then
			table.insert(boomarea, {x = chars_mobs_npcs[j].x, y = chars_mobs_npcs[j].y});	
		end;
	end;
	return boomarea;
end;

function boomareas.radiusArea (x,y,radius) --FIXME
	local boomarea = {};
	for i=1,map_w do
		for h=1,map_h do
			if math.floor(math.sqrt((y-i)^2 +(x-h)^2))<= radius and math.abs(y-i) <= radius and math.abs(x-h) <= radius then
				table.insert(boomarea,{x=h,y=i, power = 1});
			end;
		end;
	end;
	return boomarea;	
end;

function boomareas.xArea (x,y,radius) --lol
	local boomarea = {};
	for i=1,map_w do
		for h=1,map_h do
			if math.floor(math.sqrt((y-i)^2-(x-h)^2))<= radius then
				table.insert(boomarea,{x=h,y=i, power = radius-(math.abs(x-i) + math.abs(y-h))+1});
			end;
		end;
	end;
	return boomarea;	
end;

function boomareas.squareArea (x,y,radius) --lol
	local boomarea = {};
	for i=1,map_w do
		for h=1,map_h do
			if math.abs(y-i) <= radius and math.abs(x-h) <= radius then
				table.insert(boomarea,{x=h,y=i, power = radius-(math.abs(x-i) + math.abs(y-h))+1});
			end;
		end;
	end;
	return boomarea;	
end;

function boomareas.xHorArea (x,y,radius) --lol
	local boomarea = {};
	for i=1,map_w do
		for h=1,map_h do
			if math.abs(y-i) - math.abs(x-h) <= radius then
				table.insert(boomarea,{x=h,y=i, power = radius-(math.abs(x-i) - math.abs(y-h))+1});
			end;
		end;
	end;
	return boomarea;	
end;

function boomareas.ricoBallArea(range, power, locomotion, ignoreMobs) --locomotion 0 (ground) or 1 (fly)
   local ricodir = chars_mobs_npcs[current_mob].rot;
   local tmpricodir = 0;
   local mobatway = 0;
   local currentx = chars_mobs_npcs[current_mob].x;
   local currenty = chars_mobs_npcs[current_mob].y;
   local tmpcurrentx = chars_mobs_npcs[current_mob].x;
   local tmpcurrenty = chars_mobs_npcs[current_mob].y;
   local rockrange = 0;
   ricoline = {};
   for i=1,range do
	local dir1 = 1;
	local dir2 = 1;
	local dir3 = 1;
	local dir4 = 1;
	local alreadysix = 0;
	tmpcurrenty = currenty+directions[1].y[ricodir];
	if currenty/2 == math.ceil(currenty/2) then
		tmpcurrentx = currentx+directions[1].xc[ricodir];
	else
		tmpcurrentx = currentx+directions[1].xn[ricodir];
	end;
	for h=1,#chars_mobs_npcs do
		if chars_mobs_npcs[h].x == tmpcurrentx and chars_mobs_npcs[h].y == tmpcurrenty and ignoreMobs == false then
			mobatway = 1;
		end;
	end;
	if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
--nothing here
	elseif  (helpers.passCheck (tmpcurrenty,tmpcurrentx) == false and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) == false and locomotion == 1) then
		if ricodir == 1 then --impact
			tmpricodir = 6;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir1 = 0;
			end;
			tmpricodir = 2;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir2 = 0;
			end;
			tmpricodir = 3;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir3 = 0;
			end;
			if dir1 == 0 and dir2 == 0 and dir3 == 0 then
				local rnd = global_rnd[3];
				if rnd == 1 then
					ricodir = 6;
				elseif rnd == 2 then
					ricodir = 2;
				elseif rnd == 3 then
					ricodir = 3;
				end;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 2;
				elseif rnd == 2 then
					ricodir = 3;
				end;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 6;
				elseif rnd == 2 then
					ricodir = 3;
				end;
			elseif dir1 == 0 and dir2 == 0 and dir3 == 1 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 6;
				elseif rnd == 2 then
					ricodir = 2;
				end;
			elseif dir1 == 1 and dir2 == 1 and dir3 == 0 then
				ricodir = 3;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 1 then
				ricodir = 6;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 1 then
				ricodir = 2;
			elseif dir1 == 1 and dir2 == 1 and dir3 == 1 then
				ricodir = 4;
			end;
		elseif ricodir == 2 then --X
			tmpricodir = 1;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then  
				dir1 = 0;
			end;
			tmpricodir = 3;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx=currentx+directions[1].xn[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then  
				dir2 = 0;
			end;
			tmpricodir = 4;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			end
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then  
				dir3 = 0;
			end
			tmpricodir = 6;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then  
				dir4 = 0;
			end;
			if dir1 == 0 and dir2 == 0 and dir3 == 0 and dir4 == 0 then
				local rnd = global_rnd[4];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 3;
				elseif rnd == 3 then
					ricodir = 4;
				elseif rnd == 4 then
					ricodir = 6;
				end;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 0 and dir4 == 0 then
				local rnd = global_rnd[3];
				if rnd == 1 then
					ricodir = 3;
				elseif rnd == 2 then
					ricodir = 4;
				elseif rnd == 3 then
					ricodir = 6;
				end;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 0 and dir4 == 0 then
				local rnd = global_rnd[3];
				if rnd == 1 then
					ricodir = 4;
				elseif rnd == 2 then
					ricodir = 6;
				elseif rnd == 3 then
					ricodir = 1;
				end;
			elseif dir1 == 0 and dir2 == 0 and dir3 == 1 and dir4 == 0 then
				local rnd = global_rnd[3]
				if rnd==1 then
					ricodir=6
				elseif rnd==2 then
					ricodir=1
				elseif rnd==3 then
					ricodir=3
				end
		   elseif dir1 == 0 and dir2 == 0 and dir3 == 0 and dir4 == 1 then
				local rnd = global_rnd[3]
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 3;
				elseif rnd == 3 then
					ricodir = 4;
				end;
		   elseif dir1 == 1 and dir2 == 1 and dir3 == 0 and dir4 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 4;
				elseif rnd == 2 then
					ricodir = 6;
				end;
		   elseif dir1 == 1 and dir2 == 0 and dir3 == 1 and dir4 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 3;
				elseif rnd == 2 then
					ricodir = 6;
				end;
		   elseif dir1 == 1 and dir2 == 0 and dir3 == 0 and dir4 == 1 then
				local rnd = global_rnd[2]
				if rnd == 1 then
					ricodir = 3;
				elseif rnd == 2 then
					ricodir = 4;
				end;
		   elseif dir1 == 0 and dir2 == 1 and dir3 == 1 and dir4 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 6;
				end;
		   elseif dir1 == 0 and dir2 == 1 and dir3 == 0 and dir4 == 1 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 4;
				end;
		   elseif dir1 == 0 and dir2 == 0 and dir3 == 1 and dir4 == 1 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 3;
				end;
		   elseif dir1 == 0 and dir2 == 1 and dir3 == 1 and dir4 == 1 then
				ricodir = 1;
		   elseif dir1 == 1 and dir2 == 0 and dir3 == 1 and dir4 == 1 then
				ricodir = 3;
		   elseif dir1 == 0 and dir2 == 1 and dir3 == 0 and dir4 == 1 then
				ricodir = 4;
		   elseif dir1 == 1 and dir2 == 1 and dir3 == 1 and dir4 == 0 then
				ricodir = 6;
		   elseif dir1 == 1 and dir2 == 1 and dir1 == 3 and dir2 == 4 then
				ricodir = 5;
		   end;
		elseif ricodir == 3 then --X  
			tmpricodir = 1;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir1 = 0;
			end;
			tmpricodir = 4;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir]
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir2 = 0;
			end;
			tmpricodir = 5;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir3 = 0;
			end;
			if dir1 == 0 and dir2 == 0 and dir3 == 0 then
				local rnd = global_rnd[3];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 4;
				elseif rnd == 3 then
					ricodir = 5;
				end;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 4;
				elseif rnd == 2 then
					ricodir = 5;
				end;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 5;
				end;
			elseif dir1 == 0 and dir2 == 0 and dir3 == 1 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 4;
				end;
			elseif dir1 == 1 and dir2 == 1 and dir3 == 0 then
				ricodir = 5;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 1 then
				ricodir = 1;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 1 then
				ricodir = 4;
			elseif dir1 == 1 and dir2 == 1 and dir3 == 1 then
				ricodir = 6;
			end;
		elseif ricodir == 4 then --X
			tmpricodir = 3;
			tmpcurrenty = currenty+directions[1].y[tmpricodir]
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end 
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir1 = 0;
			end;
			tmpricodir = 5;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir2 = 0;
			end;
			tmpricodir = 6;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end; 
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir3 = 0;
			end;
			if dir1 == 0 and dir2 == 0 and dir3 == 0 then
				local rnd = global_rnd[3];
				if rnd == 1 then
					ricodir = 3;
				elseif rnd == 2 then
					ricodir = 5;
				elseif rnd == 3 then
					ricodir = 6;
				end;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 0 then
				local rnd=global_rnd[2];
				if rnd == 1 then
					ricodir = 5;
				elseif rnd == 2 then
					ricodir = 6;
				end;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 3;
				elseif rnd == 2 then
					ricodir = 6;
				end;
			elseif dir1 == 0 and dir2 == 0 and dir3 == 1 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 3;
				elseif rnd == 2 then
					ricodir = 5;
				end;
			elseif dir1 == 1 and dir2 == 1 and dir3 == 0 then
				ricodir = 6;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 1 then
				ricodir = 3;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 1 then
				ricodir = 5;
			elseif dir1 == 1 and dir2 == 1 and dir3 == 1 then
				ricodir = 1;
			end;   
		elseif ricodir == 5 then --X
			tmpricodir = 1;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			end
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then  
				dir1 = 0;
			end
			tmpricodir = 3;
			tmpcurrenty = currenty+directions[1].y[tmpricodir]
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			end
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then  
				dir2 = 0;
			end
			tmpricodir = 4;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then  
				dir3 = 0;
			end;
			tmpricodir = 6;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			end
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then  
				dir4 = 0;
			end;
			if dir1 == 0 and dir2 == 0 and dir3 == 0 and dir4 == 0 then
				local rnd = global_rnd[4]
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 3;
				elseif rnd == 3 then
					ricodir = 4;
				elseif rnd == 4 then
					ricodir = 6;
				end;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 0 and dir4 == 0 then
				local rnd = global_rnd[3];
				if rnd == 1 then
					ricodir = 3;
				elseif rnd == 2 then
					ricodir = 4;
				elseif rnd == 3 then
					ricodir = 6;
				end;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 0 and dir4 == 0 then
				local rnd = global_rnd[3];
				if rnd == 1 then
					ricodir = 4;
				elseif rnd == 2 then
					ricodir = 6;
				elseif rnd == 3 then
					ricodir = 1;
				end;
			elseif dir1 == 0 and dir2 == 0 and dir3 == 1 and dir4 == 0 then
				local rnd = global_rnd[3];
				if rnd == 1 then
					ricodir = 6; 
				elseif rnd == 2 then
					ricodir = 1;
				elseif rnd == 3 then
					ricodir = 3;
				end;
			elseif dir1 == 0 and dir2 == 0 and dir3 == 0 and dir4 == 1 then
				local rnd = global_rnd[3];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 3;
				elseif rnd == 3 then
					ricodir = 4;
				end;
			elseif dir1 == 1 and dir2 == 1 and dir3 == 0 and dir4 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 4;
				elseif rnd == 2 then
					ricodir = 6;
				end;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 1 and dir4 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 3;
				elseif rnd == 2 then
					ricodir = 6;
				end;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 0 and dir4 == 1 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 3;
				elseif rnd == 2 then
					ricodir = 4;
				end;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 1 and dir4 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 6;
				end;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 0 and dir4 == 1 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 4;
				end;
			elseif dir1 == 0 and dir2 == 0 and dir3 == 1 and dir4 == 1 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 3;
				end;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 1 and dir4 == 1 then
				ricodir = 1;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 1 and dir4 == 1 then
				ricodir = 3;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 0 and dir4 == 1 then
				ricodir = 4;
			elseif dir1 == 1 and dir2 == 1 and dir3 == 1 and dir4 == 0 then
				ricodir = 6;
			elseif dir1 == 1 and dir2 == 1 and dir1 == 3 and dir2 == 4 then
				ricodir = 2;
			end
		elseif ricodir == 6 then --X
			tmpricodir = 5;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir1 = 0;
			end;
			tmpricodir = 1;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end;
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir2 = 0; 
			end; 
			tmpricodir = 4;
			tmpcurrenty = currenty+directions[1].y[tmpricodir];
			if tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
				tmpcurrentx = currentx+directions[1].xc[tmpricodir];
			else
				tmpcurrentx = currentx+directions[1].xn[tmpricodir];
			end
			if (helpers.passCheck (tmpcurrenty,tmpcurrentx) and locomotion == 0) or (helpers.passJump (tmpcurrenty,tmpcurrentx) and locomotion == 1) then
				dir3 = 0;
			end;
			if dir1 == 0 and dir2 == 0 and dir3 == 0 then
				local rnd = global_rnd[3];
				if rnd == 1 then
					ricodir = 5;
				elseif rnd == 2 then
					ricodir = 1;
				elseif rnd == 3 then
					ricodir = 4;
				end;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 1;
				elseif rnd == 2 then
					ricodir = 4;
				end
			elseif dir1 == 0 and dir2 == 1 and dir3 == 0 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 5;
				elseif rnd==2 then
					ricodir = 4;
				end
			elseif dir1 == 0 and dir2 == 0 and dir3 == 1 then
				local rnd = global_rnd[2];
				if rnd == 1 then
					ricodir = 5;
				elseif rnd == 2 then
					ricodir = 1;
				end;
			elseif dir1 == 1 and dir2 == 1 and dir3 == 0 then
				ricodir = 4;
			elseif dir1 == 0 and dir2 == 1 and dir3 == 1 then
				ricodir = 6;
			elseif dir1 == 1 and dir2 == 0 and dir3 == 1 then
				ricodir = 1
			elseif dir1 == 1 and dir2 == 1 and dir3 == 1 then
				ricodir = 3;
			end;
		end;
	end;
	if mobatway <= 1 then
		tmpcurrenty = currenty+directions[1].y[ricodir];
		if tmpcurrenty/2 ~= math.ceil(tmpcurrenty/2) then
			tmpcurrentx = currentx+directions[1].xc[ricodir];
		elseif tmpcurrenty/2 == math.ceil(tmpcurrenty/2) then
			tmpcurrentx = currentx+directions[1].xn[ricodir];
		end;
		currenty = tmpcurrenty;
		currentx = tmpcurrentx;
		if mobatway == 1 then
			mobatway = 2;
		end;
	end;
	if mobatway == 2 then
		alreadysix = 1;
	end;
	if mobatway < 2 then
		table.insert(ricoline,{x=currentx,y=currenty,dir=ricodir})
	end;
    if (mobatway == 2 and alreadysix == 0) or i == range then --boom! blast!  
		boomarea = boomareas.ringArea(currentx,currenty);
		end;
	end;
	return boomarea, ricoline;
end;

function boomareas.fireGround (x,y,i,lvl,num)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		if dlandscape_obj[y][x] == 0 then
			dlandscape_obj[y][x] = "fire";
			local xx,yy = helpers.hexToPixels (x,y);
			table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 255, 127, 63, 128),typ="ground"});
			lights[#lights]["light"].setGlowStrength(0.3);
			dlandscape_power[y][x] = math.ceil(lvl*1/i);
			dlandscape_duration[y][x] = math.ceil(num*1/i);
		elseif dlandscape_obj[y][x] == "fire" then
			if dlandscape_power[y][x] >= math.ceil(lvl*1/i) then
				dlandscape_duration[y][x] = math.ceil(num*1/i);
			end;
		elseif dlandscape_obj[y][x] == "ice" or dlandscape_obj[y][x] == "mud" then
			if dlandscape_power[y][x] < math.ceil(lvl*1/i) then
				dlandscape_obj[y][x] = "fire";
				local xx,yy = helpers.hexToPixels (x,y);
				table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 255, 127, 63, 128),typ="ground"});
				lights[#lights]["light"].setGlowStrength(0.3);
				local shorterDuration = math.ceil(dlandscape_power[y][x]/lvl*1/i*num*1/i);
				dlandscape_power[y][x] = math.ceil(lvl*1/i);
				dlandscape_duration[y][x] = math.ceil(num*1/i) - shorterDuration;
			elseif dlandscape_power[y][x] > math.ceil(lvl*1/i) then
				local shorterDuration = math.ceil(lvl*1/dlandscape_power[y][x]/dlandscape_duration[y][x]);
				dlandscape_duration[y][x] = dlandscape_duration[y][x] - shorterDuration;
			elseif dlandscape_power[y][x] == math.ceil(lvl*1/i) then
				dlandscape_obj[y][x] = 0;
				dlandscape_power[y][x] = 0;
				dlandscape_duration[y][x] = 0;
			end;
		end;
	end;
	alandscape_obj[y][x] = 0;
	alandscape_power[y][x] = 0;
	alandscape_duration[y][x] = 0;
	helpers.clearHlandscape(x,y);
end;

function boomareas.holyGround (x,y,i,lvl,num)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		if dlandscape_obj[y][x] == 0 then
			dlandscape_obj[y][x] = "light";
			local xx,yy = helpers.hexToPixels (x,y);
			table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 255, 255, 255, 128),typ="ground"});
			lights[#lights]["light"].setGlowStrength(0.3);
			dlandscape_power[y][x] = math.ceil(lvl*1/i);
			dlandscape_duration[y][x] = math.ceil(num*1/i);
		elseif dlandscape_obj[y][x] == "light" then
			if dlandscape_power[y][x] >= math.ceil(lvl*1/i) then
				dlandscape_duration[y][x] = math.ceil(num*1/i);
			end;
		end;
	end;
end;

function boomareas.startFireGround (x,y,i,lvl,num)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		if dlandscape_obj[y][x] == 0 then
			elandscape[y][x] = "fire";
		elseif dlandscape_obj[y][x] == "ice" or dlandscape_obj[y][x] == "mud" then
			if dlandscape_power[y][x] < math.ceil(lvl*1/i) then
				elandscape[y][x] = "fire";
			elseif dlandscape_power[y][x] > math.ceil(lvl*1/i) then
				elandscape[y][x] = dlandscape_duration[y][x] - shorterDuration;
			elseif dlandscape_power[y][x] == math.ceil(lvl*1/i) then
				elandscape[y][x] = 0;
			end;
		end;
	end;
	alandscape_obj[y][x] = 0;
	alandscape_power[y][x] = 0;
	alandscape_duration[y][x] = 0;
	helpers.clearHlandscape(x,y);	
end;

function boomareas.iceGround (x,y,i,lvl,num)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		if dlandscape_obj[y][x] == 0 then
			dlandscape_obj[y][x] = "ice";
			dlandscape_power[y][x] = math.ceil(lvl*1/i);
			dlandscape_duration[y][x] = math.ceil(num*1/i);
		elseif dlandscape_obj[y][x] == "ice" then
			if dlandscape_power[y][x] >= math.ceil(lvl*1/i) then
				dlandscape_duration[y][x] = math.ceil(num*1/i);
			end;
		elseif dlandscape_obj[y][x] == "fire" or dlandscape_obj[y][x] == "mud" then
			if dlandscape_power[y][x] < math.ceil(lvl*1/i) then
				dlandscape_obj[y][x] = "ice";
				local shorterDuration = math.ceil(dlandscape_power[y][x]/lvl*1/i*num*1/i);
				dlandscape_power[y][x] = math.ceil(lvl*1/i);
				dlandscape_duration[y][x] = math.ceil(num*1/i) - shorterDuration;
			elseif dlandscape_power[y][x] > math.ceil(lvl*1/i) then
				local shorterDuration = math.ceil(lvl*1/dlandscape_power[y][x]/dlandscape_duration[y][x]);
				dlandscape_duration[y][x] = dlandscape_duration[y][x] - shorterDuration;
			elseif dlandscape_power[y][x] == math.ceil(lvl*1/i) then
				dlandscape_obj[y][x] = 0;
				dlandscape_power[y][x] = 0;
				dlandscape_duration[y][x] = 0;
			end;
		end;
		helpers.clearHlandscape(x,y);
	end;
end;

function boomareas.mudGround (x,y,i,lvl,num)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		if dlandscape_obj[y][x] == 0 then
			dlandscape_obj[y][x] = "mud";
			dlandscape_power[y][x] = math.ceil(lvl*1/i);
			dlandscape_duration[y][x] = math.ceil(num*1/i);
		elseif dlandscape_obj[y][x] == "mud" then
			if dlandscape_power[y][x] >= math.ceil(lvl*1/i) then
				dlandscape_duration[y][x] = math.ceil(num*1/i);
			end;
		elseif dlandscape_obj[y][x] == "fire" or dlandscape_obj[y][x] == "ice" then
			if dlandscape_power[y][x] < math.ceil(lvl*1/i) then
				dlandscape_obj[y][x] = "ice";
				local shorterDuration = math.ceil(dlandscape_power[y][x]/lvl*1/i*num*1/i);
				dlandscape_power[y][x] = math.ceil(lvl*1/i);
				dlandscape_duration[y][x] = math.ceil(num*1/i) - shorterDuration;
			elseif dlandscape_power[y][x] > math.ceil(lvl*1/i) then
				local shorterDuration = math.ceil(lvl*1/dlandscape_power[y][x]/dlandscape_duration[y][x]);
				dlandscape_duration[y][x] = dlandscape_duration[y][x] - shorterDuration;
			elseif dlandscape_power[y][x] == math.ceil(lvl*1/i) then
				dlandscape_obj[y][x] = 0;
				dlandscape_power[y][x] = 0;
				dlandscape_duration[y][x] = 0;
			end;
		end;
		helpers.clearHlandscape(x,y);
	end;
end;

function boomareas.startWallGround (x,y,i,lvl,num)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		if dlandscape_obj[y][x] ~= "pit" and dlandscape_obj[y][x] ~= "stone" then
			elandscape[y][x] = "stone";
		elseif dlandscape_obj[y][x] == "stone" or dlandscape_obj[y][x] == "pit" then
			elandscape[y][x] = "dust";
		end;
		helpers.clearHlandscape(x,y);
	end;
end;

function boomareas.wallGround (x,y,i,lvl,num) --affect map! FIXME
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		if dlandscape_obj[y][x] ~= "pit" and dlandscape_obj[y][x] ~= "stone" then
			dlandscape_obj[y][x] = "stone";
			dlandscape_power[y][x] = math.ceil(lvl*1/i);
			dlandscape_duration[y][x] = math.ceil(num*1/i);
			--map[y][x]=7;
			helpers.clearHlandscape(x,y);
		elseif dlandscape_obj[y][x] == "stone" or dlandscape_obj[y][x] == "pit" then
			dlandscape_obj[y][x] = 0;
			dlandscape_power[y][x] = 0;
			dlandscape_duration[y][x] = 0;
			--map[y][x]=1;
			helpers.clearHlandscape(x,y);
		end;
	end;
end;


function boomareas.pitGround (x,y,i,lvl,num) --affect map! FIXME
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		if dlandscape_obj[y][x] ~= "pit" and dlandscape_obj[y][x] ~= "stone" then
			dlandscape_obj[y][x] = "pit";
			dlandscape_power[y][x] = math.ceil(lvl*1/i);
			dlandscape_duration[y][x] = math.ceil(num*1/i);
			--map[y][x]=9;
		elseif dlandscape_obj[y][x] == "stone" or dlandscape_obj[y][x] == "pit" then
			elandscape[y][x] = "dust";
			dlandscape_obj[y][x] = 0;
			dlandscape_power[y][x] = 0;
			dlandscape_duration[y][x] = 0;
			--map[y][x]=1;
		end;
	end;
end;

function boomareas.poisonAir (x,y,i,lvl,num)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		if dlandscape_obj[y][x] ~= "fire" and alandscape_obj[y][x] == 0 then
			alandscape_obj[y][x] = "poison";
			local xx,yy = helpers.hexToPixels (x,y);
			table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 185, 255, 49, 128),typ="ground"});
			lights[#lights]["light"].setGlowStrength(0.3);
			alandscape_power[y][x] = math.ceil(lvl*1/i);
			alandscape_duration[y][x] = math.ceil(num*1/i);
		elseif dlandscape_obj[y][x] ~= "fire" and alandscape_obj[y][x] == "poison" then
			if alandscape_power[y][x] < math.ceil(lvl*1/i) then
				alandscape_obj[y][x] = "poison";
				local xx,yy = helpers.hexToPixels (x,y);
				table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 185, 255, 49, 64),typ="ground"});
				lights[#lights]["light"].setGlowStrength(0.1);
				local shorterDuration = math.ceil(alandscape_power[y][x]/lvl*1/i*num*1/i);
				alandscape_power[y][x] = math.ceil(lvl*1/i);
				alandscape_duration[y][x] = math.ceil(num*1/i) - shorterDuration;
			elseif alandscape_power[y][x] > math.ceil(lvl*1/i) then
				local shorterDuration = math.ceil(lvl*1/alandscape_power[y][x]/alandscape_duration[y][x]);
				alandscape_duration[y][x] = alandscape_duration[y][x] - shorterDuration;
			elseif alandscape_power[y][x] == math.ceil(lvl*1/i) then
				alandscape_obj[y][x] = 0;
				alandscape_power[y][x] = 0;
				alandscape_duration[y][x] = 0;
			end;
		end;
	end;
end;

function boomareas.toxicGround (x,y)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		elandscape[y][x] = "toxic";
	end;
end;

function boomareas.snowAir (x,y,i,lvl,num)
end;

function boomareas.trackGround (x,y,param,rot)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		helpers.addDecal(x,y,"track",param,rot);
	end;	
end;

function boomareas.ashGround (x,y)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		helpers.addDecal(x,y,"ash",nil,nil);
		helpers.clearHlandscape(x,y);
	end;	
end;

function boomareas.bloodGround (x,y)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		helpers.addDecal(x,y,"blood",nil,nil);
	end;	
end;

function boomareas.fireExploGround (x,y)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		elandscape[y][x] = "explo";
		local xx,yy = helpers.hexToPixels (x,y);
		table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 255, 127, 63, 128),typ="boom"});
		boomareas.ashGround (x,y);
	end;	
end;

function boomareas.flameAir (x,y)
	if helpers.passLev(x,y) then
		elandscape[y][x] = "flame";
		--helpers.clearHlandscape(x,y);
		boomareas.ashGround (x,y);
		--local xx,yy = helpers.hexToPixels (x,y);
		--table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 255, 127, 63, 64),typ="boom"});
		--lights[#lights]["light"].setGlowStrength(0.3);
	end;	
end;

function boomareas.coldAir (x,y)
	if helpers.passLev(x,y) then
		elandscape[y][x] = "cold";
		local xx,yy = helpers.hexToPixels (x,y);
		table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 172, 228, 255, 64),typ="boom"});
	end;	
end;

function boomareas.frostAir (x,y)
	if helpers.passLev(x,y) then
		elandscape[y][x] = "frost";
		local xx,yy = helpers.hexToPixels (x,y);
		table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 172, 228, 255, 64),typ="boom"});
	end;	
end;

function boomareas.lightAir (x,y)
	if helpers.passLev(x,y) then
		elandscape[y][x] = "light";
		local xx,yy = helpers.hexToPixels (x,y);
		table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 255, 255, 255, 64),typ="boom"});
	end;	
end;

function boomareas.moonlightAir (x,y)
	if helpers.passLev(x,y) then
		elandscape[y][x] = "moonlight";
		--local xx,yy = helpers.hexToPixels (x,y);
		--table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 162, 236, 255, 64),typ="boom"});
	end;	
end;

function boomareas.windAir (x,y)
	if helpers.passLev(x,y) then
		elandscape[y][x] = "wind";
		local xx,yy = helpers.hexToPixels (x,y);
		table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 200, 200, 200, 64),typ="boom"});
	end;	
end;

function boomareas.acidExploGround (x,y)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		elandscape[y][x] = "acidbomb";
		local xx,yy = helpers.hexToPixels (x,y);
		table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 182,255,0,64),typ="boom"});
		boomareas.ashGround (x,y);
	end;	
end;

function boomareas.staticGround (x,y)
	local cursor_at_chest,pointx,pointy,rotation_to_chest = helpers.cursorAtChest(x,y);
	if helpers.passWalk(x,y) and not cursor_at_chest then
		elandscape[y][x] = "static";
		local xx,yy = helpers.hexToPixels (x,y);
		table.insert(lights,{x=x,y=y,light=lightWorld.newLight(xx, yy, 191, 237, 255,64),typ="boom"});
	end;	
end;
