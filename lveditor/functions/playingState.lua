--level_editor

local playingState = {}

function playingState.start(media)
	playingState.load();
end;

function playingState.load()
	require("lib.loveframes");
	--local anim8 = require 'anim8';
	require 'levels.level1';
	require 'lib.Tserial';
	require 'data.buildings';
	require "data.harvest"
	
	mX, mY = love.mouse.getPosition();
	loveframes.util.SetActiveSkin("GreyStone");
	if image_names == nil then
		image_names = {};
		image_names[1] = "img/background.dds";
		image_names[2] = "img/hex_landscape.dds";
		image_names[3] = "img/hex_foreground.dds";
	end;
	
	--img_hud =  love.graphics.newImage("img/hud.png");
	
	--[[media = {};
	media.images = {};
	media.images.hud_bottom_left = love.graphics.newImage("img/hud/hud_bottom_left.png");
	media.images.hud_bottom_right = love.graphics.newImage("img/hud/hud_bottom_right.png");
	media.images.hud_bottom_tile = love.graphics.newImage("img/hud/hud_bottom_tile.png");		
	media.images.hud_top_left = love.graphics.newImage("img/hud/hud_top_left.png");
	media.images.hud_top_right = love.graphics.newImage("img/hud/hud_top_right.png");
	media.images.hud_top_tile = love.graphics.newImage("img/hud/hud_top_tile.png");
	media.images.hud_top_center = love.graphics.newImage("img/hud/hud_top_center.png");
	media.images.hud_left_tile = love.graphics.newImage("img/hud/hud_left_tile.png");
	media.images.hud_right_tile = love.graphics.newImage("img/hud/hud_right_tile.png");
	media.images.hud_right_wall_tile = love.graphics.newImage("img/hud/hud_right_wall_tile.png");
	media.images.harvest = love.graphics.newImage("img/harvest.png");
	
	img =  love.graphics.newImage(image_names[2]);
	img_obj =  love.graphics.newImage(image_names[3]);
	img_back = love.graphics.newImage(image_names[1]);
	img_map =  love.graphics.newImage("img/map.png");
	buildings1 = love.graphics.newImage("img/buildings1.png");]]
	buildings_data ();
	harvest_load ();
	mainFont = love.graphics.newFont("fonts/DroidSans-Bold.ttf", 14);
	bigFont = love.graphics.newFont("fonts/DroidSans-Bold.ttf", 32);
	tile = {};
	path={};
	tile_path={};
	tile_w=64;
	tile_h=32;
	tile_moveto =  love.graphics.newQuad(5, 48, tile_w+2, tile_h, 1024, 1024);
	tile_cursor_empty = love.graphics.newQuad(745,172, tile_w+2, tile_h+2, 1024, 1024);
	tile_cursor_white = love.graphics.newQuad(745,260, tile_w+2, tile_h+2, 1024, 1024);
    for ty=1,20 do
		for tx=1,10 do
			tile[(ty-1)*10+tx] = love.graphics.newQuad(5+74*(tx-1), 5+42*(ty-1), tile_w, tile_h, 1024, 1024);
		end;
    end;
    minimap_hexes = {};
    for ty=12,16 do
		for tx=11,13 do
			table.insert(minimap_hexes,love.graphics.newQuad(5+74*(tx-1), 5+42*(ty-1), tile_w, tile_h, 1024, 1024));
		end;
    end;
    level ();
    minimap_table = {};
    area_table = {};
    stepsound_table = {};
    buildings_table = {};
    harvest_table = {};
	homelands_table = {};

    area_names = {"ground","sand","water","magma","acid","poison"};
    area_stepsounds = {"ground","swamp","stone","sand","snow","metal"};
	tile_empty =  love.graphics.newQuad(301, 48, tile_w+2, tile_h+2, 1024, 1024);
	objects={};
	flood_objects();
	all_ground_={};
		level ();
	map_w = #map;
	map_h = #map[1];
	
	map_size=map_w*map_h;
	map_x = 0;
	map_y = 0;
	map_display_w = 40;
	map_display_h = 48;
	tile_hw = 32;
	tile_qh=tile_h/2;
	tile_34=tile_hw+tile_hw/2;
	tile_row_check=0;
	left_space=20;
	top_space=20;
	editor_status='hexes';
	object_status=1;
	hexes_status=1;
	input_size_w=map_w;
	input_size_h=map_h;
	chars_mobs_npcs={};
   --[[table.insert(chars_mobs_npcs,{1,"char","player",11,11,1,1}) --id,role,controlled,x,y,rot,class
   table.insert(chars_mobs_npcs,{2,"char","player",12,13,2,1}) --id,role,controlled,x,y,rot,class
   table.insert(chars_mobs_npcs,{3,"char","player",7,4,3,1}) --id,role,controlled,x,y,rot,class
   table.insert(chars_mobs_npcs,{4,"mob","ai",15,15,5,1}) --id,role,controlled,x,y,rot,class
   mob_w=32
   mob_h=64]]
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
  
  --directions[3].xn = {1,2,2,3,3,3,2,2,1,0,-1,-2,-2,-3,-2,-2,-1,0};
  --directions[3].xc = {0,1,2,2,3,2,2,1,0,-1,-2,-2,-3,-3,-3,-2,-2,-1};
  --directions[3].y = {-3,-3,-2,-1,0,1,2,3,3,3,3,2,1,0,-1,-2,-3,-3};
  
	directions[3].xn = {0,1,2,2,3,3,3,2,2,1,0,-1,-2,-2,-3,-2,-2,-1};
	directions[3].xc = {-1,0,1,2,2,3,2,2,1,0,-1,-2,-2,-3,-3,-3,-2,-2};
	directions[3].y = {-3,-3,-3,-2,-1,0,1,2,3,3,3,3,2,1,0,-1,-2,-3};

	tempbb={};
	tmp_ppoint={};
	tmp_ppoint2={};
	map_limit_w=1;
	map_limit_h=1;
	hex_pass=" ";
	hex_costs="";
	hex_type=" ";
	cursor_world_x=0;
	cursor_world_y=0;
	tile_counter=0;
	current_hex_type=1;
	current_area_type=1;
	current_area_stepsound=1;
	current_minimap_hex=1;
	current_building=1;
	current_herb = 1;
	current_herb_dencity = 100;
	row_status=0;
	rows_total=22;
	showhidden=1;
	array_of_map ();
	savename = "level1.lua";
	row_buttons={};
	--global={};
	global.level = 1;
	global.screenWidth = love.graphics.getWidth();
	global.screenHeight = love.graphics.getHeight();
	global.randomize_hexes = -1;
	global.digger = -1;
	global.copy = -1;
	global.copied = {};
	global.moles = 6;
	global.rnd_value = 5;
	global.ctrl = -1;
	global.hex = 1;
	global.homeland = 0;
	
	global.homelands_colors = {};
	
	for i=1,50 do
		local r = math.random(1,255);
		local g = math.random(1,255);
		local b = math.random(1,255);
		table.insert(global.homelands_colors,{r,g,b});
	end;
	
	btn_x=global.screenWidth-210;
	back_size=256;
	back_count=8;
	bgmap_w=25;
	bgmap_h=12;

	for i=1,5 do
		for h=1,5 do
			row_buttons[(i-1)*5+h]={btn_x+(h-1)*36,36*i};
		end;
	end;
	row_button_w=32;
	row_button_h=32;
	
	--bgmap_w=#bgmap[1]
	--128bgmap_h=#bgmap
	current_back=1;
	row_back=1;
	brush=0;
	hex_mouse_visible = false;
	show_invisible = false;
	background_={};
	for i=1,back_count do
		for h=1,back_count do
			background_[(i-1)*back_count+h]=love.graphics.newQuad((h-1)*back_size, (i-1)*back_size, back_size, back_size, back_size*back_count, back_size*back_count);
		end;
	end;
	tempbg={};
	boxes();
	draw_buttons();
	draw_hexbuttons ();
	
	--for i=1,#visibility_table do
		--print("VT",i,visibility_table[i])
	--end;
	drawnumbers = false;
	love.window.setMode(1920, 1080, {resizable=false});
	drawUIButtons();
end;
 
function playingState.update(dt)
	love.mousepressed(x, y, button);
	mX, mY = love.mouse.getPosition();
	global.screenWidth = love.graphics.getWidth();
	global.screenHeight = love.graphics.getHeight();
	row_buttons = {};
	for i=1,5 do
		for h=1,5 do
			row_buttons[(i-1)*5+h]={btn_x+(h-1)*40,40*i};
		end;
	end;
	btn_x=global.screenWidth - 210;
	cursor_world_y=math.ceil((mY-top_space)/tile_h*1.32)+map_y;
	if cursor_world_y/2 == math.ceil(cursor_world_y/2) then
		cursor_world_x=math.ceil((mX-left_space+1.5*tile_w)/tile_w)+map_x;
	else
		cursor_world_x=math.ceil((mX-left_space+0.75*tile_w)/tile_w)+map_x;
	end;
	loveframes.update(dt); -- <-- !!!!!!!!!!!!
end;

function newLevel()	
	for i=1, map_w do
        buildings_table[i]={};
		for z=1, map_h do
			buildings_table[i][z]=0;
			if map[i][z] < 300 then
			else
			end;
		end;
	end;
	
	for i=1, 250 do
		table.insert(area_table,1);
		table.insert(minimap_table,1);
		table.insert(stepsound_table,1);
    end;
	
	for i=1, map_w do
        harvest_table[i]={};
		for z=1, map_h do
			harvest_table[i][z]={};
			harvest_table[i][z][1]=0;
			harvest_table[i][z][2]=0;
			harvest_table[i][z][3]={}; -- herbs if not success
		end;
	end;
	
	for i=1, map_w do
        homelands_table[i]={};
		for z=1, map_h do
			homelands_table[i][z]=0;
		end;
	end;
	
end;

function flood_objects ()
	for i=1,#objects_table do
		objects[i] =  love.graphics.newQuad(objects_table[i][1], objects_table[i][2], objects_table[i][3], objects_table[i][4], 1024, 1024);
	end;
end;

function draw_background ()
	for i=1,bgmap_h do
		for h=1,bgmap_w do
			if (editor_status == "hexes" or editor_status == "buildings" or editor_status == "harvest" or editor_status == "homelands") and (h-map_x) <= 8 and (i-map_y) <= 3 then
				love.graphics.draw(media.images.img_back, background_[bgmap[i][h]], (h-1)*back_size-map_x*64, (i-1)*back_size-map_y*32*0.75);
			elseif editor_status == "background" then
				hex_status=-1;
				object_status=-1;
				love.graphics.draw(media.images.img_back, background_[bgmap[i][h]], (h-1)*back_size/5+100-add_bg_x*back_size/5, (i-1)*back_size/5+100-add_bg_y*back_size/5,0,0.2,0.2); -- in background mode
			end;
		end;
	end;
end;

function array_of_map ()
	for my=1, map_h do
		for mx=1, map_w do	
			table.insert(all_ground_,{tile_counter+1, map[my][mx], my,mx, heights_table[map[my][mx]],costs_table[map[my][mx]],visibility_table[map[mx][my]] });
			tile_counter=tile_counter+1;
		end;
	end;
end;

function draw_hexbuttons ()
	if editor_status == "hexes" then
		for j=1,10 do
			love.graphics.draw(media.images.img, tile[row_status*10+j], btn_x+2, 240+(j-1)*40);
			love.graphics.line( btn_x,  240+(j-1)*40-2,
			btn_x+tile_w+8,  240+(j-1)*40-2,
			btn_x+tile_w+8,  240+(j-1)*40-2+36,
			btn_x,  240+(j-1)*40-2+36,
			btn_x,  240+(j-1)*40-2);
			if current_hex_type==j then
				love.graphics.line( btn_x-2,  240+(j-1)*40,
				btn_x+tile_w+10,  240+(j-1)*40,
				btn_x+tile_w+10,  240+(j-1)*40+36,
				btn_x-2,  240+(j-1)*40+36,
				btn_x-2,  240+(j-1)*40);
			end;
			if row_status*10+current_hex_type>120 then
				love.graphics.draw(media.images.img_obj, objects[row_status*10+current_hex_type-120], global.screenWidth-150, global.screenHeight-300);
			end;
		end;
		love.graphics.draw(media.images.img, minimap_hexes[current_minimap_hex],global.screenWidth-60, 440, 0, 0.5);
	end;
	
	if editor_status == "background" then
		for j=1,8 do
			love.graphics.draw(media.images.img_back, background_[(row_back-1)*8+j], btn_x+2, 150+(j-1)*60,0,0.2 ,0.2);
			if current_back == j then
				love.graphics.line( btn_x-2,  150+(j-1)*60-5,
				btn_x+back_size/5+5,  150+(j-1)*60-5,
				btn_x+back_size/5+5,  150+(j-1)*60+back_size/5+5,
				btn_x-2,  150+(j-1)*60+back_size/5+5,
				btn_x-2,  150+(j-1)*60-5);
			end;
		end;
	end;
end;

function draw_buttons ()
	if editor_status == "hexes" then
		cc=4;
	elseif editor_status == "background" then
		cc=2;
	elseif editor_status == "help" then
		cc=0;
	end;
	
	if editor_status == "hexes" then
		local togglebuttons = {};
		for i=1,cc do
			for h=1,5 do        
				togglebuttons[#togglebuttons+1] = loveframes.Create("button")
				togglebuttons[#togglebuttons]:SetPos(row_buttons[(i-1)*5+h][1],  row_buttons[(i-1)*5+h][2]);
				togglebuttons[#togglebuttons]:SetHeight(40);
				togglebuttons[#togglebuttons]:SetWidth(40);
				togglebuttons[#togglebuttons]:SetText(5*(i-1)+h);
				togglebuttons[#togglebuttons].OnClick = function(object)
					if editor_status == "hexes" then
						row_status=(i-1)*5+h-1;
						boxes();
						draw_hexbuttons ();
					elseif editor_status == "background" then
					end;
				end;
			end;
		end;
		
	
		love.graphics.draw(media.images.img, minimap_hexes[current_minimap_hex],global.screenWidth-60, 440, 0, 0.5);
		
		togglebuttons[#togglebuttons+1] = loveframes.Create("button")
		togglebuttons[#togglebuttons]:SetPos(global.screenWidth-125,440);
		togglebuttons[#togglebuttons]:SetHeight(20);
		togglebuttons[#togglebuttons]:SetWidth(20);
		togglebuttons[#togglebuttons]:SetText("<");
		togglebuttons[#togglebuttons].OnClick = function(object)
			if current_minimap_hex > 1 then
				current_minimap_hex = current_minimap_hex - 1;
			else
				current_minimap_hex = #minimap_table;
			end;
			minimap_table[row_status*10+current_hex_type] = current_minimap_hex;
			end;
		
		togglebuttons[#togglebuttons+1] = loveframes.Create("button")
		togglebuttons[#togglebuttons]:SetPos(global.screenWidth-105,440);
		togglebuttons[#togglebuttons]:SetHeight(20);
		togglebuttons[#togglebuttons]:SetWidth(20);
		togglebuttons[#togglebuttons]:SetText(">");
		togglebuttons[#togglebuttons].OnClick = function(object)
			if current_minimap_hex < #minimap_table then
				current_minimap_hex = current_minimap_hex + 1;
			else
				current_minimap_hex = 1;
			end;
			minimap_table[row_status*10+current_hex_type] = current_minimap_hex;
			end;
		
		togglebuttons[#togglebuttons+1] = loveframes.Create("button")
		togglebuttons[#togglebuttons]:SetPos(global.screenWidth-125,480);
		togglebuttons[#togglebuttons]:SetHeight(20);
		togglebuttons[#togglebuttons]:SetWidth(20);
		togglebuttons[#togglebuttons]:SetText("<");
		togglebuttons[#togglebuttons].OnClick = function(object)
			current_area_type = current_area_type - 1;
			if current_area_type < 1 then
				current_area_type = #area_table;
			end;
			area_table[row_status*10+current_hex_type] = current_area_type;
			end;
		
		togglebuttons[#togglebuttons+1] = loveframes.Create("button")
		togglebuttons[#togglebuttons]:SetPos(global.screenWidth-105,480);
		togglebuttons[#togglebuttons]:SetHeight(20);
		togglebuttons[#togglebuttons]:SetWidth(20);
		togglebuttons[#togglebuttons]:SetText(">");
		togglebuttons[#togglebuttons].OnClick = function(object)
			current_area_type = current_area_type + 1;
			if current_area_type > #area_table then
				current_area_type = 1;
			end;
			area_table[row_status*10+current_hex_type] = current_area_type;
			end;
			
		togglebuttons[#togglebuttons+1] = loveframes.Create("button")
		togglebuttons[#togglebuttons]:SetPos(global.screenWidth-125,520);
		togglebuttons[#togglebuttons]:SetHeight(20);
		togglebuttons[#togglebuttons]:SetWidth(20);
		togglebuttons[#togglebuttons]:SetText("<");
		togglebuttons[#togglebuttons].OnClick = function(object)
			current_area_stepsound = current_area_stepsound - 1;
			if current_area_stepsound < 1 then
				current_area_stepsound = #stepsound_table;
			end;
			stepsound_table[row_status*10+current_hex_type] = current_area_stepsound;
			end;
		
		togglebuttons[#togglebuttons+1] = loveframes.Create("button")
		togglebuttons[#togglebuttons]:SetPos(global.screenWidth-105,520);
		togglebuttons[#togglebuttons]:SetHeight(20);
		togglebuttons[#togglebuttons]:SetWidth(20);
		togglebuttons[#togglebuttons]:SetText(">");
		togglebuttons[#togglebuttons].OnClick = function(object)
			current_area_stepsound = current_area_stepsound + 1;
			if current_area_stepsound > #stepsound_table then
				current_area_stepsound = 1;
			end;
			stepsound_table[row_status*10+current_hex_type] = current_area_stepsound;
			end;
	end;
	
	
	if editor_status == "buildings" then
		local togglebuttons = {};
		for i=1,cc do
			for h=1,5 do        
				togglebuttons[#togglebuttons+1] = loveframes.Create("button")
				togglebuttons[#togglebuttons]:SetPos(row_buttons[(i-1)*5+h][1],  row_buttons[(i-1)*5+h][2]);
				togglebuttons[#togglebuttons]:SetHeight(40);
				togglebuttons[#togglebuttons]:SetWidth(40);
				togglebuttons[#togglebuttons]:SetText(5*(i-1)+h);
				togglebuttons[#togglebuttons].OnClick = function(object)
					current_building = (i-1)*5+h;
					if current_building <= 0 then
						current_building = 1;
					end;
					if current_building > #buildings_stats then
						current_building = #buildings_stats;
					end;
				end;
			end;
		end;
	end;
	
	if editor_status == "background" then
		local togglebuttons = {};
		for i=1,cc do
			for h=1,4 do        
				togglebuttons[#togglebuttons+1] = loveframes.Create("button")
				togglebuttons[#togglebuttons]:SetPos(row_buttons[(i-1)*4+h][1],  row_buttons[(i-1)*4+h][2]);
				togglebuttons[#togglebuttons]:SetHeight(40);
				togglebuttons[#togglebuttons]:SetWidth(40);
				togglebuttons[#togglebuttons]:SetText(4*(i-1)+h);
				togglebuttons[#togglebuttons].OnClick = function(object)
					row_back = h;
				end;
			end;
		end;
	end;
	
end;

function centerObject(sprite)
	local x = math.ceil(global.screenWidth/2 - sprite:getWidth()/2);
	local y = math.ceil(global.screenHeight/2 - sprite:getHeight()/2);
	return x,y;
end;

function draw_map()
	if (editor_status == "hexes" or editor_status == "buildings" or editor_status == "harvest" or editor_status == "homelands") and hexes_status==1 then
		for my=1, math.min(map_display_h, map_h-map_y) do
			for mx=1, math.min(map_display_w, map_w-map_x) do	
				if show_invisible and map[my+map_y][mx+map_x]<20  and map[my+map_y][mx+map_x]<300 then
					drawHex(mx+map_x,my+map_y,tile[map[my+map_y][mx+map_x]]);
				elseif map[my+map_y][mx+map_x]>20 and map[my+map_y][mx+map_x]<300 then
					drawHex(mx+map_x,my+map_y,tile[map[my+map_y][mx+map_x]]);
				end;
			end;
		end;
	end;
 end;
 
function resize_map ()
	for my=1, map_h do
		for mx=1, map_w do
			if not map[my] then
				map[my] = {};
				harvest_table[my] = {};
				buildings_table[my] = {};
				homelands_table = {};
			end;
			if not map[my][mx] then
				map[my][mx] = current_hex_type;
				harvest_table[my][mx] = {0,0,{}};
				buildings_table[my][mx] = 0;
				homelands_table = 0;
			end;

		end;
	end;
	resize_map_lesser ();
end;

function resize_map_lesser ()
	local _limit1 = #map;
	for my=_limit1,1,-1 do
		if my > map_h then
			table.remove(map,my);
			table.remove(harvest_table,my);
			table.remove(buildings_table,my);
			table.remove(homelands_table,my);
		end;
		if map[my] then
			local _limit2 = #map[my];
			for mx=_limit2,1,-1 do
				if mx > map_w then
					table.remove(map[my],mx);
					table.remove(harvest_table[my],mx);
					table.remove(buildings_table[my],mx);
					table.remove(homelands_table[my],mx);
				end;
			end;
		end;
	end;
end;

function resize_background ()
	for my=1, bgmap_h do
		for mx=1, bgmap_w do
			if not bgmap[my] then
				bgmap[my] = {};
				
			end;
			if not bgmap[mx] then
				bgmap[mx] = {};
			end;
			if not bgmap[my][mx] then
				bgmap[my][mx] = current_back;	
			end;
		end;
	end;
end;

function passCheck (x,y)
	if not map[y][x] then
		return false;
	end;
	local height_value = 0;
	if map[y][x] < 300 then
		height_value = heights_table[map[y][x]];
	else
		height_value = 2;
	end;
	if height_value <= 0 then
		return true
	else
		return false
	end;
end;

function draw_objects ()
	if object_status==1 and (editor_status == "hexes" or editor_status == "buildings" or editor_status == "harvest" or editor_status == "homelands") then
		if map_x < 12 then
			mxx = 1
		else
			mxx = -10
		end;
		if map_y < 4 then
			myy = 1
		else
			myy = -2
		end;
		for my=myy, math.min(map_display_h, map_h-map_y) do
		  for mx=mxx, math.min(map_display_w, map_w-map_x) do
			if (my+map_y)/2 == math.ceil((my+map_y)/2) then
				if map[my+map_y][mx+map_x]>120 and  map[my+map_y][mx+map_x]<=220 then
					love.graphics.draw(media.images.img_obj, objects[map[my+map_y][mx+map_x]-120], ((mx-1)*tile_w+left_space)-tile_w+top_space+objects_table[map[my+map_y][mx+map_x]-120][5], (my-1)*tile_h*0.75+top_space-objects_table[map[my+map_y][mx+map_x]-120][6])
				end;       
				if map[my+map_y][mx+map_x] > 300 then
					local index = map[my+map_y][mx+map_x] - 300;
					local img = buildings_stats[index].img;
					local sprite = buildings_stats[index].sprite;
					local addx = buildings_stats[index].addx;
					local addy = buildings_stats[index].addy;
					love.graphics.draw(media.images.buildings1, sprite, ((mx-1+addx)*tile_w+left_space)-tile_w+top_space, (my-1+addy)*tile_h*0.75+top_space)
				end;
			else
				if map[my+map_y][mx+map_x]>120 and  map[my+map_y][mx+map_x]<=220 then
					love.graphics.draw(media.images.img_obj, objects[map[my+map_y][mx+map_x]-120], ((mx-1)*tile_w+left_space+tile_hw)-tile_w+top_space+objects_table[map[my+map_y][mx+map_x]-120][5], (my-1)*tile_h*0.75+top_space-objects_table[map[my+map_y][mx+map_x]-120][6])
				end;
				if map[my+map_y][mx+map_x] > 300 then
					local index = map[my+map_y][mx+map_x] - 300;
					local img = buildings_stats[index].img;
					local sprite = buildings_stats[index].sprite;
					local addx = buildings_stats[index].addx;
					local addy = buildings_stats[index].addy;
					love.graphics.draw(media.images.buildings1, sprite, ((mx-1+addx)*tile_w+left_space+tile_hw)-tile_w+top_space, (my-1+addy)*tile_h*0.75+top_space)
				end;   
			end;
			if editor_status == "harvest" and harvest_table[my+map_y][mx+map_x][1] ~= 0 then --harvest
				drawHarvest (mx+map_x,my+map_y,harvest_table[my+map_y][mx+map_x][1]);
			end;
		end;
      end;
   end;
   
end;

function drawHarvest (x,y,img_index)
	moveto_hex_y = math.ceil((y-1-map_y)*tile_h*0.75+top_space)-tile_h*2;
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2-map_x)*tile_w+left_space;
	else
		moveto_hex_x = (x-2-map_x)*tile_w+tile_w/2+left_space;
	end;
		love.graphics.draw(media.images.harvest, harvest_ttx[img_index].sprite, moveto_hex_x, moveto_hex_y);
end;

function switchLevel()
	if global.level == 1 then
		package.loaded[ 'levels.level1' ] = nil;
		package.loaded[ 'levels.level2' ] = nil;
		require 'levels.level2';
		savename = "level2.lua";
		levelname = "level2";
		global.level = global.level+1;
	elseif global.level == 2 then
		package.loaded[ 'levels.level1' ] = nil;
		package.loaded[ 'levels.level2' ] = nil;
		require 'levels.level1';
		savename = "level1.lua";
		levelname = "level1";
		global.level=1;
	end;
	all_ground = {};
	array_of_map ();
	level ();
	global.screenWidth = love.graphics.getWidth();
	global.screenHeight = love.graphics.getHeight();
end;

function playingState.keypressed(key, unicode)
	if love.keyboard.isDown("lctrl") then
		global.ctrl = 1;
	end;
	if love.keyboard.isDown("lctrl") and key == 'g' then
		--startDiggers(cursor_world_x,cursor_world_y,global.moles,true);
		global.moles = 6;
		global.digger = 1;
	end;
	
	if love.keyboard.isDown("lctrl") and key == 'r' then
		switchLevel();
	end;
	
	if  mX< global.screenWidth-274 then
		if editor_status == "hexes" or editor_status == "buildings" or editor_status == "harvest" or editor_status == "homelands" then
			if key == 'up' then
				if map_y>2 then
					map_y = map_y-2;
				end;
			end;
			if key == 'down' then
				if  map_y<(map_h-30) then
					map_y = map_y+2;
				end;
			end;
			if key == 'left' then
				if map_x > 2 then
					map_x=map_x-2;
				end;
			end;
			if key == 'right' then
				if map_x<(map_w-18) then
					map_x=map_x+2;
				end;  
			end;
			if key == 'i' then
				if not hex_mouse_visible then
					hex_mouse_visible = true;
				else
					hex_mouse_visible = false;
				end;
			end;
        end;  
		if editor_status == "background" then
			if key == 'up' then
				add_bg_y=add_bg_y-1;
			end;
			if key == 'down' then
				add_bg_y=add_bg_y+1;
			end;  
			if key == 'left' then
				add_bg_x=add_bg_x-1;
			end;
			if key == 'right' then
				add_bg_x=add_bg_x+1;
			end;
		end;       	
	end;
	if love.keyboard.isDown("lctrl") and key == 'c'  then
		showhidden=-1*showhidden;
	end;
	if love.keyboard.isDown("lctrl") and key == 'j'  then
		editor_status="hexes"
		hexes_status=1;
		object_status=1;
		loveframes.util.RemoveAll();
		drawUIButtons();
		love.mouse.setVisible(false);
		draw_buttons();
		boxes();
	end;
    if love.keyboard.isDown("lctrl") and key == 'x'  then
		hexes_status=-1*hexes_status;
	end;
	if love.keyboard.isDown("lctrl") and key == 'o'  then
		object_status=-1*object_status;
	end;
	
	if love.keyboard.isDown("lctrl") and key == 'v' and editor_status=='hexes' then
		if show_invisible == true then
			show_invisible = false;
		else
			show_invisible = true;
		end;
	end;
	if love.keyboard.isDown("lctrl") and key == 'p'  then
		checkHerbs();
		editor_status="harvest"
		loveframes.util.RemoveAll();
		drawUIButtons();
		love.mouse.setVisible(false);
		draw_harvest_buttons();
	end;
	
	if love.keyboard.isDown("lctrl") and key == 'n' and (editor_status=='hexes' or editor_status=='buildings') then
		if drawnumbers then
			drawnumbers  = false;
		else
			drawnumbers  = true;
		end;
	end;
	
	if love.keyboard.isDown("lctrl") and key == 'k'  then
		add_bg_x=0;
		add_bg_y=0;
		editor_status="background";
		loveframes.util.RemoveAll();
		drawUIButtons();
		love.mouse.setVisible(true);
		draw_buttons();
		boxes();
	end;
	
	if love.keyboard.isDown("lctrl") and key == 'b'  then
		editor_status="buildings";
		loveframes.util.RemoveAll();
		drawUIButtons();
		--love.mouse.setVisible(true);
		brush = 0;
		draw_buttons();
		boxes();
	end;
	
	if love.keyboard.isDown("lctrl") and key == 't' and editor_status == "background" then
		flood_back();
	end;
	if love.keyboard.isDown("lctrl") and key == 'y' and editor_status == "background" then
		flood_back_alt();
	end;
	if love.keyboard.isDown("lctrl") and key == 's' then
		save();
	end;  
	if love.keyboard.isDown("lctrl") and key == 'l' then
		load();
	end; 
	if editor_status=='hexes' and mX<global.screenWidth-274 then 
		if love.keyboard.isDown("lctrl") and key == '1'  then
			current_hex_type=1;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '2'  then
			current_hex_type=2;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '3'  then
			current_hex_type=3;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '4'  then
			current_hex_type=4;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '5'  then
			current_hex_type=5;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '6'  then
			current_hex_type=6;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '7'  then
			current_hex_type=7;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '8'  then
			current_hex_type=8;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '9'  then
			current_hex_type=9;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '0'  then
			current_hex_type=10;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '-'  then
			current_hex_type=11;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '='  then
			current_hex_type=12;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == '/'  then
			current_hex_type=13;
			current_area_type = area_table[row_status*10+current_hex_type];
			current_minimap_hex = minimap_table[row_status*10+current_hex_type];
			current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
		end;
		if love.keyboard.isDown("lctrl") and key == 'z'  then
			global.randomize_hexes = global.randomize_hexes*-1;
		end;
	end;
    if editor_status=='background' and mX<global.screenWidth-274 then
		if love.keyboard.isDown("lctrl") and key == '1'  then
			current_back=1;
		end;
		if love.keyboard.isDown("lctrl") and key == '2'  then
			current_back=2;
		end;
		if love.keyboard.isDown("lctrl") and key == '3'  then
			current_back=3;
		end;
		if love.keyboard.isDown("lctrl") and key == '4'  then
			current_back=4;
		end;
		if love.keyboard.isDown("lctrl") and key == '5'  then
			current_back=5;
		end;
		if love.keyboard.isDown("lctrl") and key == '6'  then
			current_back=6;
		end;
		if love.keyboard.isDown("lctrl") and key == '7'  then
			current_back=7;
		end;
		if love.keyboard.isDown("lctrl") and key == '8'  then
			current_back=8;
		end;
		if love.keyboard.isDown("lctrl") and key == '9'  then
			current_back=9;
		end;
		if love.keyboard.isDown("lctrl") and key == '0'  then
			current_back=10;
		end;
     end;
     if editor_status=='buildings' and mX<global.screenWidth-274 then
		if love.keyboard.isDown("lctrl") and key == '1'  then
			current_building=1;
		end;
		if love.keyboard.isDown("lctrl") and key == '2'  then
			current_building=math.min(2,tonumber(key));
		end;
		if love.keyboard.isDown("lctrl") and key == '3'  then
			current_building=math.min(2,tonumber(key));
		end;
		if love.keyboard.isDown("lctrl") and key == '4'  then
			current_building=math.min(2,tonumber(key));
		end;
		if love.keyboard.isDown("lctrl") and key == '5'  then
			current_building=math.min(2,tonumber(key));
		end;
		if love.keyboard.isDown("lctrl") and key == '6'  then
			current_building=math.min(2,tonumber(key));
		end;
		if love.keyboard.isDown("lctrl") and key == '7'  then
			current_building=math.min(2,tonumber(key));
		end;
		if love.keyboard.isDown("lctrl") and key == '8'  then
			current_building=math.min(2,tonumber(key));
		end;
		if love.keyboard.isDown("lctrl") and key == '9'  then
			current_building=math.min(2,tonumber(key));
		end;
		if love.keyboard.isDown("lctrl") and key == '0'  then
			current_building=math.min(2,tonumber(key));
		end;
     end;
	if love.keyboard.isDown("lctrl") and key == 'f' and editor_status == "hexes" then
		flood_map();
	end;
	if love.keyboard.isDown("lctrl") and key == 'd' and editor_status == "background" then
		flood_back();
	end;
	if love.keyboard.isDown("lctrl") and key == 'm' then
		editor_status = "minimap";
	end;
	if key == 'escape'  then
		editor_status='hexes';
		hexes_status=1;
		object_status=1;
		loveframes.util.RemoveAll();
		drawUIButtons();
		draw_buttons();
		draw_hexbuttons ();
		boxes();
	end;
	if love.keyboard.isDown("lctrl") and key == 'q' and row_status < rows_total and editor_status == "hexes" then
		row_status=row_status+1;
	end;
	if love.keyboard.isDown("lctrl") and key == 'q' and row_status == rows_total and editor_status == "hexes" then
		row_status=0;
	end;
	if love.keyboard.isDown("lctrl") and key == 'a' and row_status > 0 and editor_status == "hexes" then
		row_status=row_status-1;
		loveframes.util.RemoveAll();
		drawUIButtons();
		boxes();
	end;
	if love.keyboard.isDown("lctrl") and key == 'a' and row_status == rows_total and editor_status == "hexes" then
		row_status=rows_total;
		loveframes.util.RemoveAll();
		drawUIButtons();
		boxes();
	end;
	if love.keyboard.isDown("lctrl") and key == 'h'  then
		editor_status="help";
		loveframes.util.RemoveAll();
		drawUIButtons();
   end;
   loveframes.keypressed(key, unicode);
end;

----

function playingState.mousepressed(x, y, button)
	
	if love.mouse.isDown("l") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "homelands" then
		if brush == 0 then
			if insideMap(cursor_world_y,cursor_world_x) and passCheck (cursor_world_x,cursor_world_y) then
				homelands_table[cursor_world_y][cursor_world_x] = global.homeland;
			end;
		elseif brush == 1 or brush == 2 or brush == 3 then
			if insideMap(cursor_world_y,cursor_world_x) and passCheck (cursor_world_x,cursor_world_y) then
				homelands_table[cursor_world_y][cursor_world_x] = global.homeland;
			end;
			local rings = ringArea(cursor_world_x,cursor_world_y);
			for h=1,brush do
				for i=1,#rings[h] do
					if insideMap(rings[h][i].y,rings[h][i].x) and passCheck (rings[h][i].x,rings[h][i].y) then	
						homelands_table[rings[h][i].y][rings[h][i].x] = global.homeland;
					end;
				end;
			end;
		elseif brush >= 4 and brush <= 10 then
			local boomarea = squareArea(cursor_world_x,cursor_world_y,brush);
			for i=1,#boomarea do
				if insideMap(boomarea[i].y,boomarea[i].x) and passCheck (boomarea[i].x,boomarea[i].y) then
					homelands_table[boomarea[i].y][boomarea[i].x] = global.homeland;
				end;
			end;
		
		end;
	end;
	
	if love.mouse.isDown("r") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "hexes" and global.copy == 1 then
		global.copied = {};
		if brush == 0 then
			table.insert(global.copied,map[cursor_world_y][cursor_world_x]);
		elseif brush == 1 or brush == 2 or brush == 3 then
			local rings = ringArea(cursor_world_x,cursor_world_y);
			table.insert(global.copied,map[cursor_world_y][cursor_world_x]);
			for h=1,brush do
				for i=1,#rings[h] do
					if insideMap(rings[h][i].y,rings[h][i].x) then
						table.insert(global.copied,map[rings[h][i].y][rings[h][i].x]);
					end;
				end;
			end;
		elseif brush >= 4 and brush <= 10 then
			local boomarea = squareArea(cursor_world_x,cursor_world_y,brush);
			for i=1,#boomarea do
				if insideMap(boomarea[i].y,boomarea[i].x) then
					table.insert(global.copied,map[boomarea[i].y][boomarea[i].x]);
				end;
			end;
		
		end;
	end;
	
	if love.mouse.isDown("l") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "hexes" and global.copy == 1 and #global.copied > 0 and global.digger == -1 then
		if brush == 0 then
			if insideMap(cursor_world_y,cursor_world_x) then
				map[cursor_world_y][cursor_world_x] = global.copied[1];
			end;
		elseif brush == 1 or brush == 2 or brush == 3 then
			local rings = ringArea(cursor_world_x,cursor_world_y);
			local _tmp_array = global.copied;
			if global.randomize_hexes == 1 then
				_tmp_array = randomizeArray(global.copied);
			end;
			map[cursor_world_y][cursor_world_x] = _tmp_array[1];
			local counter = 2;
			for h=1,brush do
				for i=1,#rings[h] do
					if insideMap(rings[h][i].y,rings[h][i].x) and _tmp_array[counter] then	
						map[rings[h][i].y][rings[h][i].x] = _tmp_array[counter];
					end;
					counter = counter + 1;
				end;
			end;
		elseif brush >= 4 and brush <= 10 then
			local boomarea = squareArea(cursor_world_x,cursor_world_y,brush);
			local _tmp_array = global.copied;
			if global.randomize_hexes == 1 then
				_tmp_array = randomizeArray(global.copied);
			end;
			local counter = 1;
			for i=1,#boomarea do
				if insideMap(boomarea[i].y,boomarea[i].x) and _tmp_array[counter] then
					map[boomarea[i].y][boomarea[i].x] = _tmp_array[counter];
				end;
				counter = counter + 1;
			end;
		
		end;
	end;
	if love.mouse.isDown("l") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "hexes" and global.digger == -1 and global.copy == -1 then
		local mapvalue = 1;
		if brush == 0 then
			if global.randomize_hexes == -1 then
				map_value = current_hex_type+row_status*10;
			else
				local rnd = math.random(0,math.min(global.rnd_value-1,200 - current_hex_type+row_status*10));
				map_value = current_hex_type+rnd+row_status*10;
			end;
			if insideMap(cursor_world_y,cursor_world_x) then
				map[cursor_world_y][cursor_world_x] = map_value;
			end;
		elseif brush == 1 or brush == 2 or brush == 3 then
			if global.randomize_hexes == -1 then
				map_value = current_hex_type+row_status*10;
			else
				local rnd = math.random(0,math.min(global.rnd_value-1,200 - current_hex_type+row_status*10));
				map_value = current_hex_type+rnd+row_status*10;
			end;
			if insideMap(cursor_world_y,cursor_world_x) then
				map[cursor_world_y][cursor_world_x] = map_value;
			end;
			local rings = ringArea(cursor_world_x,cursor_world_y);
			for h=1,brush do
				for i=1,#rings[h] do
					if global.randomize_hexes == -1 then
						map_value = current_hex_type+row_status*10;
					else
						local rnd = math.random(0,math.min(global.rnd_value-1,200 - current_hex_type+row_status*10));
						map_value = current_hex_type+rnd+row_status*10;
					end;
					if insideMap(rings[h][i].y,rings[h][i].x) then
						map[rings[h][i].y][rings[h][i].x] = map_value;
					end;
				end;
			end;
		elseif brush >= 4 and brush <= 10 then
			local boomarea = squareArea(cursor_world_x,cursor_world_y,brush);
			for i=1,#boomarea do
				if insideMap(boomarea[i].y,boomarea[i].x) then
					if global.randomize_hexes == -1 then
						map_value = current_hex_type+row_status*10;
					else
						local rnd = math.random(0,math.min(global.rnd_value-1,200 - current_hex_type+row_status*10));
						map_value = current_hex_type+rnd+row_status*10;
					end;
					map[boomarea[i].y][boomarea[i].x] = map_value;
				end;
			end;
		end;
	elseif love.mouse.isDown("l") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "hexes" and global.digger == 1 then
			startDiggers(cursor_world_x,cursor_world_y,global.moles,true);
			--global.digger = -1;
	end;
	
	if love.mouse.isDown("l") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "buildings" then
		map[cursor_world_y][cursor_world_x] = 300+current_building;
		if cursor_world_y/2 == math.ceil(cursor_world_y/2) then
			hexes = "hexes_ev";
		else
			hexes = "hexes_ne";
		end;
		for i=1,#buildings_stats[current_building][hexes] do	
			if buildings_stats[current_building][hexes][i][2]+cursor_world_y > 0 and buildings_stats[current_building][hexes][i][2]+cursor_world_y <= map_h
			and buildings_stats[current_building][hexes][i][1]+cursor_world_x > 0 and buildings_stats[current_building][hexes][i][1]+cursor_world_x <= map_w then
				map[buildings_stats[current_building][hexes][i][2]+cursor_world_y][buildings_stats[current_building][hexes][i][1]+cursor_world_x] = 10;
				buildings_table[buildings_stats[current_building][hexes][i][2]+cursor_world_y][buildings_stats[current_building][hexes][i][1]+cursor_world_x] = {cursor_world_y,cursor_world_x};
			end;
		end;
	end;
	
	--FIXME: tool to remove FIX array
	
	if love.mouse.isDown("l") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "harvest" then
		if brush == 0 and passCheck (cursor_world_y,cursor_world_x) then
			addHerb(cursor_world_x,cursor_world_y);
		elseif brush == 1 or brush == 2 or brush == 3 then
			if passCheck (cursor_world_y,cursor_world_x) then
				addHerb(cursor_world_x,cursor_world_y);
			end;
			local rings = ringArea(cursor_world_x,cursor_world_y);
			for h=1,brush do
				for i=1,#rings[h] do
					if passCheck (rings[h][i].x,rings[h][i].y) then
						addHerb(rings[h][i].x,rings[h][i].y);
					end;
				end;
			end;
		elseif brush >= 4 and brush <= 10 then
			local boomarea = squareArea(cursor_world_x,cursor_world_y,brush);
			for i=1,#boomarea do
				if passCheck (boomarea[i].x,boomarea[i].y) then
					addHerb(boomarea[i].x,boomarea[i].y);
				end;
			end;
		end;
	end;
	
	if love.mouse.isDown("l") and mX < global.screenWidth-274 and editor_status == "background" then
		for i=1,bgmap_h do
			for h=1,bgmap_w do
				if mX>(h-1)*back_size/5+100-add_bg_x*back_size/5
				and mX<(h-1)*back_size/5+100-add_bg_x*back_size/5+back_size/5
				and mY >(i-1)*back_size/5+100-add_bg_y*back_size/5
				and mY<(i-1)*back_size/5+100-add_bg_y*back_size/5+back_size/5 then
					bgmap[i][h]=(row_back-1)*8+current_back;
				end;
			end;
		end;
	end;
	if editor_status == "hexes" then
		for j=1,10 do
			if love.mouse.isDown("l") and mX > global.screenWidth-274 and mY<650 and mX>btn_x and mY>240+(j-1)*40-2 and mX<btn_x+tile_w+8 and mY<240+(j-1)*40-2+36 then
				current_hex_type=j;
				current_area_type=area_table[row_status*10+current_hex_type];
				current_minimap_hex = minimap_table[row_status*10+current_hex_type];
				current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
				boxes();
			end;
		end;
	elseif editor_status == "background" then
		for j=1,8 do
			if love.mouse.isDown("l") and mX>global.screenWidth-274 and mX>btn_x and mY>150+(j-1)*60 and mX<btn_x+tile_w and mY<150+(j-1)*60+back_size/5 then
				current_back = j;
			end;
		end;
	end;
	if global.ctrl == -1 and (editor_status == "hexes" or editor_status == "harvest" or editor_status == "homelands") and global.digger == -1 then
		if button=="wd" then
			global.copied = {};
			if brush < 10 then
				brush = brush + 1
			end;

		end;
		if button=="wu" then
			global.copied = {};
			
			if brush > 0 then
				brush = brush - 1
			end;
		end;
	end;
	if global.randomize_hexes == 1 and (editor_status == "hexes" or editor_status == "harvest" or editor_status == "homelands") then
		if global.ctrl == 1 then
			if button=="wu" then
				if global.rnd_value < 10 then
					global.rnd_value = global.rnd_value + 1
				end;

			end;
			if button=="wd" then
				if global.rnd_value > 1 then
					global.rnd_value = global.rnd_value - 1
				end;
			end;
		end;
	end;
	
	if global.ctrl == -1 and editor_status == "hexes" and global.digger == 1 then
		if button=="wu" then
			if global.moles < 6 then
				global.moles = global.moles + 1;
			end;
		end;
		if button=="wd" then
			if global.moles > 1 then
				global.moles = global.moles - 1;
			end;
		end;
	end;
	
	loveframes.mousepressed(x, y, button);
end

function playingState.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button);
end;

function playingState.textinput(text)
    -- your code
    loveframes.textinput(text); 
end;

function playingState.keyreleased(key)
    if key == "lctrl" then
		global.ctrl = -1;
	end;
    -- your code
    loveframes.keyreleased(key)
end;

function flood_map ()
	map_w=tonumber(input_size_w);
	map_h=tonumber(input_size_h);
	tile_counter=0;
	while #all_ground_>0 do
		table.remove(all_ground_,1);
	end;
	while #map>0 do
		table.remove(map,1);
	end;
	for i=1, map_w do
		map[i]={};
		for z=1, map_h do
			if global.randomize_hexes == -1 and global.copy == -1 then
				map[i][z]= current_hex_type+row_status*10;
			elseif global.randomize_hexes == 1 and global.copy == -1 then
				local _rnd = math.random(0,math.min(global.rnd_value-1,200 - current_hex_type+row_status*10));
				map[i][z]= current_hex_type+row_status*10+_rnd;
			elseif global.copy == 1 and #global.copied > 0 then
				local _tmp_array = global.copied;
				if global.randomize_hexes == 1 then
					_tmp_array = randomizeArray(global.copied);
				end;
				map[i][z] = _tmp_array[1];--lala
			end;
		end;
	end;
	array_of_map();
	editor_status='hexes';
end;

function draw_cursor ()
	if (mX < global.screenWidth-274 and mY < global.screenHeight-150) and (editor_status == "hexes" or editor_status == "harvest" or editor_status == "buildings" or editor_status == "homelands") then
		if not hex_mouse_visible then
			love.mouse.setVisible(false);
		else
			love.mouse.setVisible(true);
		end;
	elseif mX >= global.screenWidth-274 or mY >= global.screenHeight-150 then
		love.mouse.setVisible(true);
	end;
	if cursor_world_x>0 and cursor_world_x<map_w-map_limit_w  and cursor_world_y>0 and cursor_world_y<map_h-map_limit_h and mX<global.screenWidth-274 and editor_status ~= "background" then
		if brush == 0 then
			drawHex(cursor_world_x,cursor_world_y,tile_cursor_empty);
		elseif brush == 1 or brush == 2 or brush == 3 then
			drawHex(cursor_world_x,cursor_world_y,tile_cursor_empty);
			local rings = ringArea(cursor_world_x,cursor_world_y);
			for h=1,brush do
				for i=1,#rings[h] do
					drawHex(rings[h][i].x,rings[h][i].y,tile_cursor_empty);
				end;
			end;
		elseif brush >= 4 and brush <= 10 then
			local boomarea = squareArea(cursor_world_x,cursor_world_y,brush);
			for i=1,#boomarea do
				drawHex(boomarea[i].x,boomarea[i].y,tile_cursor_empty);
			end;
		end;
	end;
	
	if mX<global.screenWidth-274 and editor_status == "buildings" then
		drawHex(cursor_world_x,cursor_world_y,tile_cursor_empty);
		local hexes = "";
		if cursor_world_y/2 == math.ceil(cursor_world_y/2) then
			hexes = "hexes_ev";
		else
			hexes = "hexes_ne";
		end;
		for i=1,#buildings_stats[current_building][hexes] do
			drawHex(buildings_stats[current_building][hexes][i][1]+cursor_world_x,buildings_stats[current_building][hexes][i][2]+cursor_world_y,tile_cursor_empty);
		end;
	end;
end;

function save()
	checkHerbs();
	love.filesystem.write( savename, 
	 "function " .. "level" .. " ()"
	 .. "\r\n" .. "levelname=" .. '"' .. levelname .. '"'
	 .. "\r\n" .. "leveltype=" .. '"' .. leveltype .. '"'
	 .. "\r\n" .. "images_table=" .. Tserial.pack(image_names, true, false)
	 .. "\r\n" .. "map=" .. Tserial.pack(map, true, false)
	 .. "\r\n" .. "bgmap=" .. Tserial.pack(bgmap, true, false)
	 .. "\r\n" .. "objects_table=" .. Tserial.pack(objects_table, true, false)
	 .. "\r\n" .. "heights_table=" .. Tserial.pack(heights_table, true, false)
	 .. "\r\n" .. "costs_table=" .. Tserial.pack(costs_table, true, false)
	 .. "\r\n" .. "visibility_table=" .. Tserial.pack(visibility_table, true, false)
	 .. "\r\n" .. "area_table=" .. Tserial.pack(area_table, true, false)
	 .. "\r\n" .. "buildings_table=" .. Tserial.pack(buildings_table, true, false)
	 .. "\r\n" .. "minimap_table=" .. Tserial.pack(minimap_table, true, false)
	 .. "\r\n" .. "stepsound_table=" .. Tserial.pack(stepsound_table, true, false)
	 .. "\r\n" .. "harvest_table=" .. Tserial.pack(harvest_table, true, false)
	 .. "\r\n" .. "homelands_table=" .. Tserial.pack(homelands_table, true, false)
	 .. "\r\n" .. "end;"
	 );
	print("levelname SAVED!");
	editor_status = "saved";
end;

function load()
	while (#all_ground_>0) do
		table.remove(all_ground_,1);
		table.remove(background_,1);
	end
	love.load();
end;


function boxes ()
-- map h/w
	if editor_status == "hexes" then             
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-200, global.screenHeight-50);
		textinput:SetWidth(76);
		textinput:SetText(map_w);
		textinput:SetLimit(4);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				map_w=tonumber(text);
				resize_map ();
				flood_objects ();
			end;
		end;
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-100, global.screenHeight-50);
		textinput:SetWidth(76);
		textinput:SetText(map_h);
		textinput:SetLimit(4);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				map_h=tonumber(text);
				resize_map ();
				flood_objects ();
			end;
		end;
--pass through
		local textinput = loveframes.Create("textinput",frame);
		textinput:SetPos(global.screenWidth-130, 375);
		textinput:SetWidth(46);
		textinput:SetText(heights_table[row_status*10+current_hex_type]);
		textinput:SetLimit(4);
		--textinput:SetUsable({"0","1","2","-"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				heights_table[row_status*10+current_hex_type]=tonumber(text);
				flood_objects ();
			end;
		end;
--viz/inviz   
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-80, 375);
		textinput:SetWidth(46);
		textinput:SetText(visibility_table[row_status*10+current_hex_type]);
		textinput:SetLimit(4);
		textinput:SetUsable({"0","1"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				visibility_table[row_status*10+current_hex_type]=tonumber(text);
				flood_objects ();
			end;
		end ;
--st/rt costs
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-130, 550);
		textinput:SetWidth(46);
		textinput:SetText(heights_table[row_status*10+current_hex_type]);
		textinput:SetLimit(4);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				costs_table[row_status*10+current_hex_type]=tonumber(text);
				flood_objects ();
			end;
		end;
--objects
		if row_status>=12 then
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-130, 325);
			textinput:SetWidth(46);
			textinput:SetText(objects_table[row_status*10+current_hex_type-120][5]);
			textinput:SetLimit(4);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9","-"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					objects_table[row_status*10+current_hex_type-120][5]=tonumber(text);
					flood_objects ();
				end;
			end ;
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-80, 325);
			textinput:SetWidth(46);
			textinput:SetText(objects_table[row_status*10+current_hex_type-120][6]);
			textinput:SetLimit(4);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9","-"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					objects_table[row_status*10+current_hex_type-120][6]=tonumber(text);
					flood_objects ();
				end;
			end;
    
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-80, 270);
			textinput:SetWidth(46);
			textinput:SetText(objects_table[row_status*10+current_hex_type-120][4]);
			textinput:SetLimit(4);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					objects_table[row_status*10+current_hex_type-120][4]=tonumber(text);
					flood_objects ();
				end;
			end;
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-130, 270);
			textinput:SetWidth(46);
			textinput:SetText(objects_table[row_status*10+current_hex_type-120][3]);
			textinput:SetLimit(4);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					objects_table[row_status*10+current_hex_type-120][3]=tonumber(text);
					flood_objects ();
				end;
			end;
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-80, 220);
			textinput:SetWidth(46);
			textinput:SetText(objects_table[row_status*10+current_hex_type-120][2]);
			textinput:SetLimit(4);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					objects_table[row_status*10+current_hex_type-120][2]=tonumber(text);
					flood_objects ();
				end;
			end;
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-130, 220);
			textinput:SetWidth(46);
			textinput:SetText(objects_table[row_status*10+current_hex_type-120][1]);
			textinput:SetLimit(4);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				objects_table[row_status*10+current_hex_type-120][1]=tonumber(text);
				flood_objects ();
			end;
		end;
	end;
	if editor_status == "background" then
		
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-150, 402);
		textinput:SetWidth(136);
		textinput:SetText(levelname);
		textinput:SetLimit(20);
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				levelname = tostring(text);
			end;
		end;
		
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-150, 452);
		textinput:SetWidth(136);
		textinput:SetText(leveltype);
		textinput:SetLimit(20);
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				leveltype = tostring(text);
			end;
		end;
		
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-150, 502);
		textinput:SetWidth(136);
		textinput:SetText(image_names[1]);
		textinput:SetLimit(20);
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				image_names[1] = tostring(text);
				img_back=love.graphics.newImage(image_names[1]);
			end;
		end;
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-150, 552);
		textinput:SetWidth(136);
		textinput:SetText(image_names[2]);
		textinput:SetLimit(20);
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				image_names[2] = tostring(text);
				img=love.graphics.newImage(image_names[2]);
			end;
		end;
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-150, 602);
		textinput:SetWidth(136);
		textinput:SetText(image_names[3]);
		textinput:SetLimit(20);
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				image_names[3]=tostring(text);
				img_obj=love.graphics.newImage(image_names[3]);
			end;
		end;
		
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-150, 652);
		textinput:SetWidth(76);
		textinput:SetText(bgmap_w);
		textinput:SetLimit(4);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				bgmap_w=tonumber(text);
				--flood_back();
				resize_background ();
			end;
		end;
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-150, 702);
		textinput:SetWidth(76);
		textinput:SetText(bgmap_h);
		textinput:SetLimit(4);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				bgmap_h=tonumber(text);
				--flood_back();
				resize_background ();
			end;
		end;
	end;
end;

function draw_harvest_buttons()
	--[[local textinput = loveframes.Create("textinput");
	textinput:SetPos(global.screenWidth-80, 220);
	textinput:SetWidth(46);
	textinput:SetText(current_herb);
	textinput:SetLimit(4);
	textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
	textinput.OnEnter = function(object, text)
		if text ~= nil then
			current_herb = tonumber(text);
		end;
	end;]]
	local textinput = loveframes.Create("textinput");
	textinput:SetPos(global.screenWidth-100, 550);
	textinput:SetWidth(46);
	textinput:SetText(current_herb_dencity);
	textinput:SetLimit(4);
	textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
	textinput.OnEnter = function(object, text)
		if text ~= nil then
			current_herb_dencity=tonumber(text);
		end;
	end;
	
	clearharvestbutton = loveframes.Create("button")
	clearharvestbutton:SetPos(global.screenWidth-220,550);
	clearharvestbutton:SetHeight(40);
	clearharvestbutton:SetWidth(40);
	clearharvestbutton:SetText("0");
	clearharvestbutton.OnClick = function(object)
	current_herb = 0;
		end;
	
	harvestbuttons = {};
	for i=1,#harvest_ttx do
		local _addx = (i-1)*40-(math.ceil(i/5)-1)*200;
		local _addy = math.floor((i-1)/5)*40;
		harvestbuttons[#harvestbuttons+1] = loveframes.Create("button")
		harvestbuttons[#harvestbuttons]:SetPos(global.screenWidth-220+_addx,40+_addy);
		harvestbuttons[#harvestbuttons]:SetHeight(40);
		harvestbuttons[#harvestbuttons]:SetWidth(40);
		harvestbuttons[#harvestbuttons]:SetText(i);
		harvestbuttons[#harvestbuttons].OnClick = function(object)
			current_herb = i;
			end;
	end;
end;

function draw_homelands_buttons()
	local textinput = loveframes.Create("textinput");
	textinput:SetPos(global.screenWidth-100, 550);
	textinput:SetWidth(46);
	textinput:SetText(global.homeland);
	textinput:SetLimit(4);
	textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
	textinput.OnEnter = function(object, text)
		if text ~= nil then
			global.homeland=tonumber(text);
		end;
	end;
	
	clearhomelandbutton = loveframes.Create("button")
	clearhomelandbutton:SetPos(global.screenWidth-220,550);
	clearhomelandbutton:SetHeight(40);
	clearhomelandbutton:SetWidth(40);
	clearhomelandbutton:SetText("0");
	clearhomelandbutton.OnClick = function(object)
		global.homeland = 0;
		end;
	
	homelandsbuttons = {};
	for i=1,50 do
		local _addx = (i-1)*40-(math.ceil(i/5)-1)*200;
		local _addy = math.floor((i-1)/5)*40;
		homelandsbuttons[#homelandsbuttons+1] = loveframes.Create("button")
		homelandsbuttons[#homelandsbuttons]:SetPos(global.screenWidth-220+_addx,40+_addy);
		homelandsbuttons[#homelandsbuttons]:SetHeight(40);
		homelandsbuttons[#homelandsbuttons]:SetWidth(40);
		homelandsbuttons[#homelandsbuttons]:SetText(i);
		homelandsbuttons[#homelandsbuttons].OnClick = function(object)
			global.homeland = i;
			end;
	end;
end;

function drawUIButtons()
	uibuttons = {};
	
	uibuttons[1] = loveframes.Create("button")
	uibuttons[1]:SetPos(40,global.screenHeight-120);
	uibuttons[1]:SetHeight(40);
	uibuttons[1]:SetWidth(100);
	uibuttons[1]:SetText("hexes");
	uibuttons[1].OnClick = function(object)
		editor_status='hexes';
		hexes_status=1;
		object_status=1;
		loveframes.util.RemoveAll();
		drawUIButtons();
		draw_buttons();
		draw_hexbuttons ();
		boxes();
	end;
	
	uibuttons[2] = loveframes.Create("button")
	uibuttons[2]:SetPos(40,global.screenHeight-60);
	uibuttons[2]:SetHeight(40);
	uibuttons[2]:SetWidth(100);
	uibuttons[2]:SetText("buildings");
	uibuttons[2].OnClick = function(object)
		editor_status="buildings";
		loveframes.util.RemoveAll();
		drawUIButtons();
		--love.mouse.setVisible(true);
		brush = 0;
		draw_buttons();
		boxes();
	end;
	
	uibuttons[3] = loveframes.Create("button")
	uibuttons[3]:SetPos(160,global.screenHeight-120);
	uibuttons[3]:SetHeight(40);
	uibuttons[3]:SetWidth(100);
	uibuttons[3]:SetText("harvest");
	uibuttons[3].OnClick = function(object)
		checkHerbs();
		editor_status="harvest"
		loveframes.util.RemoveAll();
		drawUIButtons();
		love.mouse.setVisible(false);
		draw_harvest_buttons();
	end;
	
	uibuttons[4] = loveframes.Create("button")
	uibuttons[4]:SetPos(160,global.screenHeight-60);
	uibuttons[4]:SetHeight(40);
	uibuttons[4]:SetWidth(100);
	uibuttons[4]:SetText("background");
	uibuttons[4].OnClick = function(object)
		add_bg_x=0;
		add_bg_y=0;
		editor_status="background";
		loveframes.util.RemoveAll();
		drawUIButtons();
		love.mouse.setVisible(true);
		draw_buttons();
		boxes();
	end;
	
	uibuttons[5] = loveframes.Create("button")
	uibuttons[5]:SetPos(280,global.screenHeight-60);
	uibuttons[5]:SetHeight(40);
	uibuttons[5]:SetWidth(100);
	uibuttons[5]:SetText("showhidden");
	uibuttons[5].OnClick = function(object)
		showhidden=-1*showhidden;
	end;
	
	uibuttons[6] = loveframes.Create("button")
	uibuttons[6]:SetPos(280,global.screenHeight-120);
	uibuttons[6]:SetHeight(40);
	uibuttons[6]:SetWidth(100);
	uibuttons[6]:SetText("hexes_status");
	uibuttons[6].OnClick = function(object)
		hexes_status=-1*hexes_status;
	end;
	
	uibuttons[7] = loveframes.Create("button")
	uibuttons[7]:SetPos(400,global.screenHeight-60);
	uibuttons[7]:SetHeight(40);
	uibuttons[7]:SetWidth(100);
	uibuttons[7]:SetText("objects");
	uibuttons[7].OnClick = function(object)
		object_status=-1*object_status;
	end;
	
	uibuttons[8] = loveframes.Create("button")
	uibuttons[8]:SetPos(400,global.screenHeight-120);
	uibuttons[8]:SetHeight(40);
	uibuttons[8]:SetWidth(100);
	uibuttons[8]:SetText("inv_hexes");
	uibuttons[8].OnClick = function(object)
		if show_invisible == true then
			show_invisible = false;
		else
			show_invisible = true;
		end;
	end;
	
	uibuttons[9] = loveframes.Create("button")
	uibuttons[9]:SetPos(520,global.screenHeight-60);
	uibuttons[9]:SetHeight(40);
	uibuttons[9]:SetWidth(100);
	uibuttons[9]:SetText("hex_numbers");
	uibuttons[9].OnClick = function(object)
		if drawnumbers then
			drawnumbers  = false;
		else
			drawnumbers  = true;
		end;
	end;
	
	uibuttons[10] = loveframes.Create("button")
	uibuttons[10]:SetPos(520,global.screenHeight-120);
	uibuttons[10]:SetHeight(40);
	uibuttons[10]:SetWidth(100);
	uibuttons[10]:SetText("cursor");
	uibuttons[10].OnClick = function(object)
		if not hex_mouse_visible then
			hex_mouse_visible = true;
		else
			hex_mouse_visible = false;
		end;
	end;
	
	uibuttons[11] = loveframes.Create("button")
	uibuttons[11]:SetPos(640,global.screenHeight-60);
	uibuttons[11]:SetHeight(40);
	uibuttons[11]:SetWidth(100);
	uibuttons[11]:SetText("flood_back");
	uibuttons[11].OnClick = function(object)
		flood_back();
	end;
	
	uibuttons[12] = loveframes.Create("button")
	uibuttons[12]:SetPos(640,global.screenHeight-120);
	uibuttons[12]:SetHeight(40);
	uibuttons[12]:SetWidth(100);
	uibuttons[12]:SetText("flood_back_alt");
	uibuttons[12].OnClick = function(object)
		flood_back_alt();
	end;
	
	uibuttons[13] = loveframes.Create("button")
	uibuttons[13]:SetPos(760,global.screenHeight-60);
	uibuttons[13]:SetHeight(40);
	uibuttons[13]:SetWidth(100);
	uibuttons[13]:SetText("save");
	uibuttons[13].OnClick = function(object)
		save();
	end;
	
	uibuttons[14] = loveframes.Create("button")
	uibuttons[14]:SetPos(760,global.screenHeight-120);
	uibuttons[14]:SetHeight(40);
	uibuttons[14]:SetWidth(100);
	uibuttons[14]:SetText("reload");
	uibuttons[14].OnClick = function(object)
		load();
	end;
	
	uibuttons[15] = loveframes.Create("button")
	uibuttons[15]:SetPos(880,global.screenHeight-60);
	uibuttons[15]:SetHeight(40);
	uibuttons[15]:SetWidth(100);
	uibuttons[15]:SetText("help");
	uibuttons[15].OnClick = function(object)
		editor_status="help";
		loveframes.util.RemoveAll();
		drawUIButtons()
	end;
	
	uibuttons[16] = loveframes.Create("button")
	uibuttons[16]:SetPos(880,global.screenHeight-120);
	uibuttons[16]:SetHeight(40);
	uibuttons[16]:SetWidth(100);
	uibuttons[16]:SetText("next_lv");
	uibuttons[16].OnClick = function(object)
		switchLevel();
	end;
	
	uibuttons[17] = loveframes.Create("button")
	uibuttons[17]:SetPos(1000,global.screenHeight-60);
	uibuttons[17]:SetHeight(40);
	uibuttons[17]:SetWidth(100);
	uibuttons[17]:SetText("flood_map");
	uibuttons[17].OnClick = function(object)
		flood_map();
	end;

	uibuttons[18] = loveframes.Create("button")
	uibuttons[18]:SetPos(1000,global.screenHeight-120);
	uibuttons[18]:SetHeight(40);
	uibuttons[18]:SetWidth(100);
	uibuttons[18]:SetText("generate");
	uibuttons[18].OnClick = function(object)
		global.moles = 6;
		global.digger = -1*global.digger;
	end;
	
	uibuttons[19] = loveframes.Create("button")
	uibuttons[19]:SetPos(1120,global.screenHeight-120);
	uibuttons[19]:SetHeight(40);
	uibuttons[19]:SetWidth(100);
	uibuttons[19]:SetText("minimap");
	uibuttons[19].OnClick = function(object)
		editor_status = "minimap";
	end;
	
	uibuttons[20] = loveframes.Create("button")
	uibuttons[20]:SetPos(1120,global.screenHeight-60);
	uibuttons[20]:SetHeight(40);
	uibuttons[20]:SetWidth(100);
	uibuttons[20]:SetText("new_lv");
	uibuttons[20].OnClick = function(object)
		newLevel();
	end;
	
	uibuttons[19] = loveframes.Create("button")
	uibuttons[19]:SetPos(1240,global.screenHeight-120);
	uibuttons[19]:SetHeight(40);
	uibuttons[19]:SetWidth(100);
	uibuttons[19]:SetText("randomize");
	uibuttons[19].OnClick = function(object)
		global.randomize_hexes = global.randomize_hexes*-1;
	end;
	
	uibuttons[20] = loveframes.Create("button")
	uibuttons[20]:SetPos(1240,global.screenHeight-60);
	uibuttons[20]:SetHeight(40);
	uibuttons[20]:SetWidth(100);
	uibuttons[20]:SetText("copy");
	uibuttons[20].OnClick = function(object)
		global.copy = -1*global.copy;
	end;
	
	uibuttons[20] = loveframes.Create("button")
	uibuttons[20]:SetPos(1360,global.screenHeight-60);
	uibuttons[20]:SetHeight(40);
	uibuttons[20]:SetWidth(100);
	uibuttons[20]:SetText("areas");
	uibuttons[20].OnClick = function(object)
		editor_status = "homelands";
		loveframes.util.RemoveAll();
		drawUIButtons();
		love.mouse.setVisible(false);
		draw_homelands_buttons();
	end;
	
end;

function startDiggers(x,y,count,flag)
	if insideMap(cursor_world_x,cursor_world_y) then
		if global.randomize_hexes == -1 then
			map[cursor_world_y][cursor_world_x] = row_status*10+current_hex_type;
		else
			local _rnd = math.random(1,global.rnd_value+1)-1;
			map[cursor_world_y][cursor_world_x] = row_status*10+current_hex_type+_rnd;
		end;
	end;
	diggers = {};
	for i=1,count do
		diggers[i] = {};
		diggers[i].x = cursor_world_x;
		diggers[i].y = cursor_world_y;
		diggers[i].active = true;
	end;
	for i=1,count do
		while diggers[i].active do
			local xdirections = {};
			local _halfy = diggers[i].y/2;
			if _halfy == math.ceil(_halfy) then
				xdirections = directions[1].xc;
			else
				xdirections = directions[1].xn;
			end;
			if flag then
				for i=1,count do
					if insideMap(diggers[i].y+directions[1]["y"][i],diggers[i].x+xdirections[i]) then
						if global.randomize_hexes == -1 then
							map[diggers[i].y+directions[1]["y"][i]][diggers[i].x+xdirections[i]] = row_status*10+current_hex_type;
						else
							local _rnd = math.random(0,math.min(global.rnd_value-1,200 - current_hex_type+row_status*10));
							map[diggers[i].y+directions[1]["y"][i]][diggers[i].x+xdirections[i]] = row_status*10+current_hex_type+_rnd;
						end;
					end;
				end;
			end;
			local _rnd = math.random(1,6);
			diggers[i].x = diggers[i].x+xdirections[_rnd];
			diggers[i].y = diggers[i].y+directions[1]["y"][_rnd];
			if insideMap(diggers[i].y,diggers[i].x) then
				if global.randomize_hexes == -1 then
					map[diggers[i].y][diggers[i].x] = row_status*10+current_hex_type;
				else
					local _rnd = math.random(1,global.rnd_value+1)-1;
					map[diggers[i].y][diggers[i].x] = row_status*10+current_hex_type+_rnd;
				end;
			end;
			if ifDiggerStops(diggers[i].x ,diggers[i].y ,row_status*10+current_hex_type) then
				diggers[i].active = false;
			end;
		end;
	end;
end;

function ifDiggerStops(x,y,hexid)
	if x == 3 or x == map_w-3 or y == 3 or y == map_h-3 then
		return true;
	end;
	local _ring = smallRingArea(x,y);
	local _counter = 0;
	for i=1,6 do
		_counter = 0;
		if _ring[i] then
			if not insideMap(_ring[i].x,_ring[i].y) 
			or (global.randomize_hexes == -1 and insideMap(_ring[i].x,_ring[i].y) and map[_ring[i].x][_ring[i].y] == hexid)
			or (global.randomize_hexes == 1 and insideMap(_ring[i].x,_ring[i].y) and map[_ring[i].x][_ring[i].y] >= hexid and map[_ring[i].x][_ring[i].y] <= hexid+global.rnd_value) then
				_counter = _counter + 1;
			end;
		end;
	end;
	if _counter >= 6 then
		return true;
	end;
	return false;
end;

function insideMap(x,y)
	if x <= map_w and x > 0 and y <= map_h and y > 0 then
		return true
	else
		return false
	end;
end;

function flood_back_alt ()
	if bgmap_w>back_count and bgmap_h>back_count then
		for i=1,bgmap_h do
			for h=1,bgmap_w do
				if i <=8  and h <= 8 then
					bgmap[i][h] = (i-1)*8 + h;
				end
				if i > 8 and h <= 8 then
					bgmap[i][h] = 56;
				end
				if i <= 8 and h > 8 then
					bgmap[i][h] = 8;
				end
				if i > 8 and h > 8 then
					bgmap[i][h] = 64;
				end;
			end;
		end;
	end;
end;

function flood_back()
	for i=1,bgmap_h do
		bgmap[i] = {};
		for z=1, bgmap_w do
			bgmap[i][z]= row_back*8+current_back;
		end;
	end;
end;


function draw_papermap ()
	local x,y = centerObject(media.images.img_map);
	love.graphics.draw(media.images.img_map, x-120,y-50)
	tile_w_paper=8
	tile_h_paper=4
	for my=1, map_h do
		for mx=1, map_w do	
			if (my)/2 == math.ceil((my)/2) then
				if map[my][mx] <= 300 then
					love.graphics.setColor(255, 255, 255,125);
					love.graphics.draw(media.images.img, tile[map[my][mx]],((mx-1)*tile_w_paper)+x-80, (my-1)*tile_h_paper*0.75+y-15,0,0.15);
					love.graphics.setColor(255, 255, 255,255);
					love.graphics.draw(media.images.img, minimap_hexes[minimap_table[map[my][mx]]],((mx  -1)*tile_w_paper)+x-80, (my-1)*tile_h_paper*0.75+y-15,0,0.15);
				else
					love.graphics.draw(media.images.img, minimap_hexes[13],((mx  -1)*tile_w_paper)+x-80, (my-1)*tile_h_paper*0.75+y-15,0,0.15);
				end;
			else
				if map[my][mx] <= 300 then
					love.graphics.setColor(255, 255, 255,125);
					love.graphics.draw(media.images.img, tile[map[my][mx]],((mx-1)*tile_w_paper+tile_w_paper/2)+x-80, (my-1)*tile_h_paper*0.75+y-15,0,0.15);
					love.graphics.setColor(255, 255, 255,255);
					love.graphics.draw(media.images.img, minimap_hexes[minimap_table[map[my][mx]]],((mx-1)*tile_w_paper+tile_w_paper/2)+x-80, (my-1)*tile_h_paper*0.75+y-15,0,0.15);
				else
					love.graphics.draw(media.images.img, minimap_hexes[13],((mx-1)*tile_w_paper+tile_w_paper/2)+x-80, (my-1)*tile_h_paper*0.75+y-15,0,0.15);
				end;
			end;
		end;
	end;
end;




function draw_papermap_ ()
	local x,y = centerObject(media.images.img_map);
	love.graphics.draw(media.images.img_map, x-50,y-50)
	tile_w_paper=8
	tile_h_paper=4
	for my=1 + map_y, map_h do
		for mx=1 + map_x, map_w do	
			if (my)/2 == math.ceil((my)/2) then
				if map[my][mx] <= 300 then
					love.graphics.setColor(255, 255, 255,125);
					love.graphics.draw(media.images.img, tile[map[my][mx]],((mx - map_x -1)*tile_w_paper)+x+55, (my- map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
					love.graphics.setColor(255, 255, 255,255);
					love.graphics.draw(media.images.img, minimap_hexes[minimap_table[map[my][mx]]],((mx - map_x -1)*tile_w_paper)+x+55, (my- map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
				else
					love.graphics.draw(media.images.img, minimap_hexes[13],((mx - map_x -1)*tile_w_paper)+x+55, (my- map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
				end;
			else
				if map[my][mx] <= 300 then
					love.graphics.setColor(255, 255, 255,125);
					love.graphics.draw(media.images.img, tile[map[my][mx]],((mx - map_x - 1)*tile_w_paper+tile_w_paper/2)+x+55, (my - map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
					love.graphics.setColor(255, 255, 255,255);
					love.graphics.draw(media.images.img, minimap_hexes[minimap_table[map[my][mx]]],((mx - map_x - 1)*tile_w_paper+tile_w_paper/2)+x+55, (my - map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
				else
					love.graphics.draw(media.images.img, minimap_hexes[13],((mx - map_x - 1)*tile_w_paper+tile_w_paper/2)+x+55, (my - map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
				end;
			end;
		end;
	end;
end;


function smallRingArea(x,y)
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
		if insideMap (xx,yy) then
			table.insert(ring,{x=xx,y=yy});
		end;
	end;
	return ring;
end;

function ringArea(x,y)
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
	for k=1,6 do
		if ((x+xdirections[1][k]) <= map_w or (x+xdirections[1][k]) > 0)
		and ((y+ydirections[1][k]) <= map_h or (y+ydirections[1][k]) > 0)
		then
			table.insert(rings[1],{x=x+xdirections[1][k],y=y+ydirections[1][k]});
		end;
	end;
	for k=1,12 do
		if ((x+xdirections[2][k]) <= map_w or (x+xdirections[2][k]) > 0)
		and ((y+ydirections[2][k]) <= map_h or (y+ydirections[2][k]) > 0)
		then
			table.insert(rings[2],{x=x+xdirections[2][k],y=y+ydirections[2][k]});
		end;
	end;
	for k=1,18 do
		if ((x+xdirections[3][k]) <= map_w or (x+xdirections[3][k]) > 0)
		and ((y+ydirections[3][k]) <= map_h or (y+ydirections[3][k]) > 0)
		then
			table.insert(rings[3],{x=x+xdirections[3][k],y=y+ydirections[3][k]});
		end;
	end;
	return rings
end;

function squareArea (x,y,radius)
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

function drawHex (x,y,cursor)
	moveto_hex_y = math.ceil((y-1-map_y)*tile_h*0.75+top_space);
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2-map_x)*tile_w+left_space;
	else
		moveto_hex_x = (x-2-map_x)*tile_w+tile_w/2+left_space;
	end;
	love.graphics.draw(media.images.img, cursor, moveto_hex_x, moveto_hex_y);
end;

function draw_numbers()
	for my=1, math.min(map_display_h, map_h-map_y) do
		for mx=1, math.min(map_display_w, map_w-map_x) do
			drawNumberHex (mx+map_x,my+map_y,16,mx);
			drawNumberHex (mx+map_x,my+map_y,32,"x");
			drawNumberHex (mx+map_x,my+map_y,48,my);
		end;
	end;
	love.graphics.setColor(255, 255, 255);
 end;
 
 function draw_homelandNumbers()
	for my=1, math.min(map_display_h, map_h-map_y) do
		for mx=1, math.min(map_display_w, map_w-map_x) do
			if homelands_table[my+map_y][mx+map_x] > 0 then
				local index = math.min(255,homelands_table[my+map_y][mx+map_x]);
				local _color1 = global.homelands_colors[index][1];
				local _color2 = global.homelands_colors[index][2];
				local _color3 = global.homelands_colors[index][3];
				love.graphics.setColor(_color1, _color2, _color3,200);
				drawHex (mx+map_x,my+map_y,tile_cursor_white);
				love.graphics.setColor(255, 255, 255,255);
				drawNumberHex (mx+map_x,my+map_y,32,homelands_table[my+map_y][mx+map_x]);
			end;
		end;
	end;
	love.graphics.setColor(255, 255, 255);
 end;
 
function drawNumberHex (x,y,add,txt)
	moveto_hex_y = math.ceil((y-1-map_y)*tile_h*0.75+top_space)+8;
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2-map_x)*tile_w+left_space+add;
	else
		moveto_hex_x = (x-2-map_x)*tile_w+tile_w/2+left_space+add;
	end;
	love.graphics.print(txt,moveto_hex_x,moveto_hex_y);
end;

function playingState.draw()
	love.graphics.setFont(mainFont);
	draw_background();
	draw_map();
	if find_the_path==1 then
		path_finding(chars_mobs_npcs[current_mob][4],chars_mobs_npcs[current_mob][5]);
	end;
	draw_cursor();
	if drawnumbers and (editor_status == "hexes" or editor_status == "buildings") then
		draw_numbers();
	end;
	
	if editor_status == "homelands" then
		draw_homelandNumbers();
	end;
	
	draw_objects();
	
	--HUD
	love.graphics.setColor(255, 255, 255);
	local bottom_hud_tiles = math.floor(global.screenWidth - media.images.hud_bottom_left:getWidth()*2)/media.images.hud_bottom_tile:getWidth()+1;
	for i=1,bottom_hud_tiles do
		love.graphics.draw(media.images.hud_bottom_tile, media.images.hud_bottom_left:getWidth()+(i-1)*media.images.hud_bottom_tile:getWidth(),global.screenHeight - media.images.hud_bottom_tile:getHeight());
	end;
	local top_hud_tiles = math.floor(global.screenWidth/media.images.hud_top_tile:getWidth())+1;
	for i=1,top_hud_tiles do
		love.graphics.draw(media.images.hud_top_tile, (i-1)*media.images.hud_top_tile:getWidth(),0);
	end;
	local side_hud_tiles = math.floor(global.screenHeight/media.images.hud_left_tile:getWidth())+1;
	for i=1,side_hud_tiles do
		love.graphics.draw(media.images.hud_left_tile, 0,(i-1)*media.images.hud_left_tile:getHeight());
		love.graphics.draw(media.images.hud_right_tile, global.screenWidth-media.images.hud_right_tile:getWidth(),(i-1)*media.images.hud_right_tile:getHeight());
	end;
	love.graphics.draw(media.images.hud_bottom_left, 0,global.screenHeight - media.images.hud_bottom_left:getHeight());
	love.graphics.draw(media.images.hud_bottom_right, global.screenWidth - media.images.hud_bottom_right:getWidth() ,global.screenHeight - media.images.hud_bottom_right:getHeight());
	love.graphics.draw(media.images.hud_top_center, global.screenWidth/2 - media.images.hud_top_center:getWidth()/2 ,0);
	--love.graphics.draw(media.images.hud_top_left, 0,0);
	--love.graphics.draw(media.images.hud_top_right, global.screenWidth - media.images.hud_top_right:getWidth() ,0);
	
	for i=1,side_hud_tiles do
		love.graphics.draw(media.images.hud_right_wall_tile, global.screenWidth-media.images.hud_right_wall_tile:getWidth(),(i-1)*media.images.hud_right_wall_tile:getHeight());
	end;
	--/HUD
	
	draw_hexbuttons();
	if editor_status == "help" then
		love.graphics.print("[LCTRL]+[H] - this screen (вызов справки)", 40,30);
		love.graphics.print("[LCTRL]+[Q]/[LCTRL]+[A] - change row of hexes in 'edit hexes mode' (сменить ряд гексов в режиме редактирования оных)", 40,50);
		love.graphics.print("[LCTRL]+[0]-[LCTRL]+[9] - change hex/tile brush (сменить кисть тайла/гекса)", 40,70);
		love.graphics.print("[LCTRL]+[F] - flood hexagonal grid with current hex(залить гексагональную сетку выбранным гексом)", 40,90);
		love.graphics.print("[LCTRL]+[T] - flood background with current tile(залить подложку выбранным тайлом)", 40,110);
		love.graphics.print("[LCTRL]+[Y] - flood background with current tile (alt) (залить подложку выбранным тайлом (доп.))", 40,130);
		love.graphics.print("[LCTRL]+[J]/[ESC] - hex editor mode (режим редактирования гексагональной сетки)", 40,150);
		love.graphics.print("[LCTRL]+[K] - background tile editor mode (режим редактирования подложки)", 40,170);
		love.graphics.print("[LCTRL]+[B] - buildings mode (режим расстановки зданий)", 40,190);
		love.graphics.print("[LCTRL]+[X] - hide/view hexes (показать/спрятать гексы)", 40,210);
		love.graphics.print("[LCTRL]+[O] - hide/view objects (показать/спрятать объекты)", 40,230);
		love.graphics.print("[LCTRL]+[V] - hide/view not rendering hexes (показать/спрятать невидимые гексы)", 40,250);
		love.graphics.print("[LCTRL]+[Z] - randomize hexes (случайные гексы)", 40,270);
		love.graphics.print("[LCTRL]+[S] - save results (сохранить результаты)", 40,290);
		love.graphics.print("[LCTRL]+[L] - reload map (перезагрузить уровень)", 40,310);
		love.graphics.print("[LCTRL]+[M] - show hexes coordinates of hexes (показать координаты гекс)", 40,330);
		love.graphics.print("[LCTRL]+[I] - mouse cursor toggle in hex mode (отображение курсора мыши в режиме гекс)", 40,350);
		love.graphics.print("[LCTRL]+[M] - show minimap (показать мини-карту)", 40,370);
		love.graphics.print("[LCTRL]+[D] - fill background with first tile/заполнить подложку первым тайлом", 40,390);
		love.graphics.print("[Up],[Down],[Left],[Right] - scroll map (прокрутка карты)", 40,410);
		love.graphics.print("WheelUp/WheelDown - change brush (сменить кисть)", 40,430);
		love.graphics.print("[LCTRL]+[R] - load next level (загрузить следующий уровень)", 40,450);
		love.graphics.print("[LCTRL]+[G] - cave autogeneration, needs a click (автогенерация пещеры, работает по клику)", 40,470);
		love.graphics.print("[LCTRL]+[C] - copy mode, RMB for copy, LMB for PASTE (режим копирования, ПКМ для копирования, ЛКМ для вставки)", 40,490);
		love.graphics.print("can be used with randomize hexes (можно использовать со случайными гексами)");
		love.graphics.print("[LCTRL]+WheelUp/WheelDown - quantity of randomizing hexes (количество рандомизируемых гекс)", 40,530);
		love.graphics.print("[LCTRL]+[P] - mob areas (территории мобов)", 40,550);
		love.graphics.print("[ESC] - hex mode (режим правки гексов)", 40,570);
	end;
	if editor_status == "background" then
		love.graphics.print("tile type selected:", 100, 10);
		love.graphics.print(row_back*8+current_back, 230, 10);
		love.graphics.print("level name", global.screenWidth-130, 380);
		love.graphics.print("openair/dungeon", global.screenWidth-130, 430);
		love.graphics.print("bg filename", global.screenWidth-130, 480);
		love.graphics.print("hexes filename", global.screenWidth-130, 530);
		love.graphics.print("objects filename", global.screenWidth-130, 580);
		love.graphics.print("background width", global.screenWidth-130, 630);
		love.graphics.print("background height", global.screenWidth-130, 680);
		love.graphics.print("[T]/[Y] to flood bg", global.screenWidth-130, 740);
	end;
	love.graphics.print("[LCTRL]+[H]elp (Справка) ", 460, 10);
	local _lv = "LEVEL: " .. global.level;
	love.graphics.print(_lv, 800, 10);
	if editor_status == "hexes" then
		love.graphics.print("map width x height", global.screenWidth-200, global.screenHeight-70);
		love.graphics.print("hex type:", 90, 10);
		if cursor_world_x>0 and cursor_world_x<map_w-map_limit_w  and cursor_world_y>0 and cursor_world_y<map_h-map_limit_h
		and mX<global.screenWidth-274 and editor_status == "hexes" then
			love.graphics.print(map[cursor_world_y][cursor_world_x], 160, 10);
			love.graphics.print("hex type selected:", 200, 10);
		end;
		love.graphics.print(row_status*10+current_hex_type, 330, 10);
		love.graphics.print(" unpass  untrace",global.screenWidth-130, 400);
		love.graphics.print(" minimap",global.screenWidth-130, 420);
		love.graphics.print(" type",global.screenWidth-130, 460);
		love.graphics.print(" sound",global.screenWidth-130, 500);
		love.graphics.print(" st/rt",global.screenWidth-130, 580);
		love.graphics.print(area_names[current_area_type],global.screenWidth-80, 460);
		love.graphics.print(area_stepsounds[current_area_stepsound],global.screenWidth-80, 500);
		if row_status>=12 then
			love.graphics.print("  +x        +y  ",global.screenWidth-130, 350);
			love.graphics.print(" width   height ",global.screenWidth-130, 300);
			love.graphics.print("   x        y   ",global.screenWidth-130, 250);
		end;
	end;
	
	if editor_status == "buildings" then
		local building_img = buildings_stats[current_building].img;
		local sprite = buildings_stats[current_building].sprite;
		love.graphics.draw(building_img, sprite,global.screenWidth-180,500,0,0.25);
		love.graphics.print("building:", 90, 10);
		love.graphics.print(current_building, 150, 10);
	end;
	
	if editor_status == "harvest" and current_herb > 0 then
		if insideMap(cursor_world_x,cursor_world_y) then
			love.graphics.draw(media.images.harvest,harvest_ttx[current_herb].sprite,global.screenWidth-160,500);
			love.graphics.print("current: ",global.screenWidth-200, 600);
			love.graphics.print("chance : ",global.screenWidth-200, 630);
			love.graphics.print("pool   : ",global.screenWidth-200, 660);
			love.graphics.print(harvest_table[cursor_world_y][cursor_world_x][1],global.screenWidth-130, 600);
			love.graphics.print(harvest_table[cursor_world_y][cursor_world_x][2],global.screenWidth-130, 630);
			local _str = "";
			if harvest_table[cursor_world_y][cursor_world_x][3] then
				for i=1,#harvest_table[cursor_world_y][cursor_world_x][3] do
					_str = _str .. " " .. harvest_table[cursor_world_y][cursor_world_x][3][i];
				end;
			end;
			love.graphics.print(_str,global.screenWidth-130, 660);
		end;
	end;
	
	if editor_status == "minimap" then
		draw_papermap ();
	end;
	if editor_status == "saved" then
		local _txt = levelname .. " SAVED!"
		love.graphics.print(_txt, global.screenWidth/2-300,global.screenHeight/2);
    end
    if editor_status == "hexes" or editor_status == "buildings" or editor_status == "harvest" then
    	love.graphics.print(cursor_world_x, 10, 10);
		love.graphics.print("x", 35, 10);
		love.graphics.print(cursor_world_y, 55, 10)
	end;

	if global.randomize_hexes == 1 then 
		local _str = "value:" .. global.rnd_value;
		love.graphics.print(_str,1240, global.screenHeight-140);
		love.graphics.line(rantButton(1240,global.screenHeight-120,100,40,5));
	end;
	
	if global.digger == 1 then
		local _str = "moles:" .. global.moles;
		love.graphics.print(_str,1000, global.screenHeight-140);
		love.graphics.line(rantButton(1000,global.screenHeight-120,100,40,5));
	end;
	
	if global.copy == 1 then 
		love.graphics.line(rantButton(1240,global.screenHeight-60,100,40,5));
	end;
	draw_cursor();
    loveframes.draw();
end;

function rantButton(x,y,width,height,add)
	if not add then add = 5 end;
	if not width then width = 100 end;
	if not height then height = 40 end;
	local button_rant = {
	x-add,y-add,
	x+width+add,y-add,
	x+width+add,y+height+add,
	x-add,y+height+add,
	x-add,y-add
	}
	return button_rant;
end;

function randomizeArray(array)
	for i=1,#array do
		local rnd = math.random(1,#array);
		local tmp = array[i];
		array[i] = array[rnd];
		array[rnd] = tmp;
	end;
	return array;
end;

function addHerb(x,y)
	if current_herb == 0 then
		clearHerb(x,y);
		return;	
	end;
	if harvest_table[y][x][1] == 0 then --no herb (apply)
		harvest_table[y][x] = {current_herb,current_herb_dencity,{}};
	elseif current_herb >=1 and current_herb <=25 and 
	harvest_table[y][x][1] >= 1 and harvest_table[y][x][1] <= 25
	then --comp herb at simple herb (move)
		local _array = harvest_table[y][x][3];
		harvest_table[y][x] = {current_herb,current_herb_dencity,_array};
	elseif current_herb > 25 and harvest_table[y][x][1] >= 1
	and harvest_table[y][x][1] <= 25
	then --simple herb at comp herb (apply comp, simple to fix array)
		local _array = {};
		if global.randomize_hex == -1 then
			_array = {current_herb};
		else
			for i=1, global.rnd_value do
				table.insert(_array,(current_herb+math.random(1,i)-1));
			end;
		end;
		harvest_table[y][x] = {current_herb,current_herb_dencity,_array};
	elseif current_herb >= 1 and current_herb <= 25 and harvest_table[y][x][1] > 25 then
		--comp herb at simple herb (apply comp, simple to fix array)
		local _array = {harvest_table[y][x][1]};
		harvest_table[y][x] = {current_herb,current_herb_dencity,_array};
	elseif current_herb > 25 and harvest_table[y][x][1] > 25 then
		--simple herb at simple herb (new simple to fix array)
		local _array = {};
		if global.randomize_hex == -1 then
			_array = {current_herb};
		else
			for i=1, global.rnd_value do
				table.insert(_array,(current_herb+math.random(1,i)-1));
			end;
		end;
		harvest_table[y][x] = {current_herb,current_herb_dencity,_array};
	else
		harvest_table[y][x] = {current_herb,current_herb_dencity,{}};
	end;
end;

function clearHerb(x,y)
	harvest_table[y][x] = {0,0,{}};
end;


function checkHerbs()
	for i=1,map_w do
		for h=1,map_h do
			if not  passCheck (h,i) then
				clearHerb(h,i)	
			end;
		end;
	end;
end;

return playingState
