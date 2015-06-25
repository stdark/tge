utils = {};

directions = {};

directions[1] = {};
directions[2] = {};
directions[3] = {};

directions[1].xn = {1,1,1,0,-1,0};
directions[1].xc = {0,1,0,-1,-1,-1};
directions[1].xnr = {0,-1,0,1,1,1};
directions[1].xcr = {-1,-1,-1,0,1,0};
directions[1].y = {-1,0,1,1,0,-1};

directions[2].xn = {0,1,2,2,2,1,0,-1,-1,-2,-1,-1};
directions[2].xc = {0,1,1,2,1,1,0,-1,-2,-2,-2,-1};
directions[2].y = {-2,-2,-1,0,1,2,2,2,1,0,-1,-2};

directions[3].xn = {0,1,2,2,3,3,3,2,2,1,0,-1,-2,-2,-3,-2,-2,-1};
directions[3].xc = {-1,0,1,2,2,3,2,2,1,0,-1,-2,-2,-3,-3,-3,-2,-2};
directions[3].y = {-3,-3,-3,-2,-1,0,1,2,3,3,3,3,2,1,0,-1,-2,-3};

fanform_y={};
fanform_xc={};
fanform_xn={};
fanform_y[1]={-5,-5,-5,-5,-5,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1};
fanform_xc[1]={-1,0,1,2,3,-1,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,1,2,3,5,5};
fanform_xn[1]={-2,-1,0,1,2,-1,0,1,2,3,-1,0,1,2,3,0,1,2,3,4,0,1,2,3,4};
fanform_y[2]={-4,-3,-3,-2,-2,-2,-1,-1,-1,-1,0,0,0,0,0,1,1,1,1,2,2,2,3,3,4};
fanform_xc[2]={3,3,4,2,3,4,2,3,4,5,1,2,3,4,5,2,3,4,5,2,3,4,3,4,3};
fanform_xn[2]={3,2,3,2,3,4,1,2,3,4,1,2,3,4,5,1,2,3,4,2,3,4,2,3,3};
fanform_y[3]={5,5,5,5,5,4,4,4,4,4,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1,};
fanform_xc[3]={-1,0,1,2,3,-1,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,1,2,3,5,5};
fanform_xn[3]={-2,-1,0,1,2,-1,0,1,2,3,-1,0,1,2,3,0,1,2,3,4,0,1,2,3,4};
fanform_y[4]={5,5,5,5,5,4,4,4,4,4,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1};
fanform_xn[4]={1,0,-1,-2,-3,1,0,-1,-2,-3,-4,0,-1,-2,-3,-4,0,-1,-2,-3,-4,-1,-2,-3,-5,-5};
fanform_xc[4]={2,1,0,-1,-2,1,0,-1,-2,-3,1,0,-1,-2,-3,0,-1,-2,-3,-4,0,-1,-2,-3,-4};
fanform_y[5]={-4,-3,-3,-2,-2,-2,-1,-1,-1,-1,0,0,0,0,0,1,1,1,1,2,2,2,3,3,4};
fanform_xn[5]={-3,-3,-4,-2,-3,-4,-2,-3,-4,-5,-1,-2,-3,-4,-5,-2,-3,-4,-5,-2,-3,-4,-3,-4,-3};
fanform_xc[5]={-3,-2,-3,-2,-3,-4,-1,-2,-3,-4,-1,-2,-3,-4,-5,-1,-2,-3,-4,-2,-3,-4,-2,-3,-3};
fanform_y[6]={-5,-5,-5,-5,-5,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1};
fanform_xn[6]={1,0,-1,-2,-3,1,0,-1,-2,-3,-4,0,-1,-2,-3,-4,0,-1,-2,-3,-4,-1,-2,-3,-5,-5};
fanform_xc[6]={2,1,0,-1,-2,1,0,-1,-2,-3,1,0,-1,-2,-3,0,-1,-2,-3,-4,0,-1,-2,-3,-4};

function utils.printDebug(message)
   -- Send message to log
   if debug then
      print(message);
   end;
end;

function utils.generateHolyGrail () --FIXME check for objects,chests
	local selected_level = math.random(1,2);
	package.loaded[ 'levels.level1' ] = nil;
	package.loaded[ 'levels.level2' ] = nil;
	if selected_level == 1 then
		require "levels.level1"
	elseif selected_level == 2 then
		require "levels.level2"
	end;
	level ();
	map_w = #map
	map_h = #map[1]
	local applicable_hexes = {};
	for my=1,map_h do
		for mx=1, map_w do
			if map[mx][my] <= 300 and heights_table[map[mx][my]] == 0 and not utils.hexHasObject(mx,my) and mx > 12 and mx < map_w - 12 and my > 24 and my < map_h - 24 then
				local ring = utils.smallRingArea(mx,my);
				local add_hex = true;
				for i=1,#ring do
					if heights_table[map[ring[i].x][ring[i].y]] ~= 0 or utils.hexHasObject(ring[i].x,ring[i].y) then
						add_hex = false;
					end;
				end;
				if add_hex then
					table.insert(applicable_hexes,{y=mx,x=my});
				end;
			end;
		end;
	end;
	local selected_hex = math.random(1,#applicable_hexes);
	print("GRAIL",selected_level,selected_hex,#applicable_hexes,applicable_hexes[selected_hex].x,applicable_hexes[selected_hex].y);
	local obelisks_array = {};
	for i=1,23 do
		obelisks_array[i] = {};
		for h=1,11 do
			local x = applicable_hexes[selected_hex].x - 11 + i;
			local y = applicable_hexes[selected_hex].y - 5 + h;
			if map[x][y] <= 300 then
				obelisks_array[i][h] = minimap_table[map[x][y]];
			else
				obelisks_array[i][h] = 13;
			end;
		end;
	end;
	return selected_level,applicable_hexes[selected_hex].x,applicable_hexes[selected_hex].y,obelisks_array;
end;

function utils.hexHasObject(x,y)
	if bags_list and objects_list then
		for i=1,#bags_list do
			if bags_list[i].xi == x and bags_list[i].yi == y and bags_list[i].typ == "chest" then
				return true;
			end;
			if bags_list[i].xi == x and bags_list[i].yi == y and bags_list[i].typ == "door" then
				return true;
			end;
			if bags_list[i].xi == x and bags_list[i].yi == y and (bags_list[i].typ == "trashheap" or bags_list[i].typ == "crystals" or bags_list[i].typ == "scullpile" or bags_list[i].typ == "campfire" or bags_list[i].typ == "crystals" or bags_list[i].typ == "secret" or bags_list[i].typ == "well" or bags_list[i].typ == "box") then
				return true;
			end;
		end;
		for i=1,#objects_list do
			if objects_list[i].xi == x and objects_list[i].yi == y then
				return true;
			end;
		end;
		end;
	return false;
end;

function utils.smallRingArea(x,y)
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
		table.insert(ring,{x=xx,y=yy});
	end;
	return ring;
end;


---- Bicycle random generator

randomize = {};			-- array for random seeds
rndCounter = 1;			-- current seed num
randomizeSize = 20		-- how many seeds in randomize

function utils.random(seed)
   -- Get random number based on argument
   i, _ = math.modf(( (84589 * seed) + 45989), (217728));
   return i;
end;

function utils.initRandomize(seed)
   -- Set 20 random numbers to randomize array
   randomize = {};		-- reset randomize
   rndCounter = 1;		-- reset current seed num
   randomize[1] = utils.random(seed);
   for i = 2, randomizeSize do
      randomize[i] = utils.random(randomize[i-1]);
   end;
end;

function utils.getseed ()	-- deprecated ???
   local sum = 0;
   if love._os == "Linux" then
      local filo = io.open ("/dev/urandom","r")
      local num = string.byte(filo:read());
      filo:close();
   end;
   if sum ~= 0 then
      return sum;
   else
      return 0;
   end;
end;

function utils.randommore ()
   -- Set next int in randomize array as seed for lua random generator
   math.randomseed(randomize[rndCounter]); -- init random by current rndCounter
   rndCounter = rndCounter + 1;		   -- and increase it
   if rndCounter >= randomizeSize then	   --  but no more than randomizeSize
      rndCounter = 1;
   end;
end;

function utils.playThemeMusic (music,start_volume,music_type)
	music:setVolume(math.min(1,start_volume*global.theme_music_volume));
	love.audio.play(music);
	if music_type == "mainmenu" then
		global.music_mainmenu = 0;
		global.music_switch_to = "mainmenu";
	elseif music_type == "battle" then
		global.music_battle = 0;
		global.music_switch_to = "battle";
	elseif music_type == "peace" then
		global.music_peace = 0;
		global.music_switch_to = "peace";
	end;
	table.insert(global.theme_music_array,{track=music,type=global.music_switch_to});
	while #global.theme_music_array > 2 do
		love.audio.stop(global.theme_music_array[1].track);
		table.remove(global.theme_music_array,1);
	end;
end;

function utils.themeMusicVolumeDynamic ()
	for i=1,#global.theme_music_array do
		if global.music_switch_to == "mainmenu" and global.theme_music_array[i].type == global.music_switch_to then
			local volume = global.theme_music_array[i].track:getVolume()
			if volume < global.theme_music_volume then
				global.theme_music_array[i]["track"]:setVolume(volume+0.01);
			end;
		elseif global.theme_music_array[i].type == "mainmenu" then
			local volume = global.theme_music_array[i].track:getVolume()
			if volume > 0 then
				global.theme_music_array[i]["track"]:setVolume(volume-0.01);
			end;
			if volume <= 0 then
				love.audio.stop(global.theme_music_array[i].track);
			end;
		end;
		if global.music_switch_to == "battle" and global.theme_music_array[i].type == global.music_switch_to then
			local volume = global.theme_music_array[i].track:getVolume()
			if volume < global.theme_music_volume then
				global.theme_music_array[i]["track"]:setVolume(volume+0.01);
			end;
		elseif global.theme_music_array[i].type == "battle" then
			local volume = global.theme_music_array[i].track:getVolume()
			if volume > 0 then
				global.theme_music_array[i]["track"]:setVolume(volume-0.01);
			end;
			if volume <= 0 then
				love.audio.stop(global.theme_music_array[i].track);
			end;
		end;
		if global.music_switch_to == "peace" and global.theme_music_array[i].type == global.music_switch_to then
			local volume = global.theme_music_array[i].track:getVolume()
			if volume < global.theme_music_volume then
				global.theme_music_array[i]["track"]:setVolume(volume+0.01);
			end;
		elseif global.theme_music_array[i].type == "peace" then
			local volume = global.theme_music_array[i].track:getVolume()
			if volume > 0 then
				global.theme_music_array[i]["track"]:setVolume(volume-0.01);
			end;
			if volume <= 0 then
				love.audio.stop(global.theme_music_array[i].track);
			end;
		end;
	end;
end;

function utils.playSfx(sound,volume)
	sound:setVolume(math.min(1,volume*global.theme_sfx_volume));
	love.audio.play(sound);
end;
