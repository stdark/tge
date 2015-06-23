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
		image_names[4] = "img/hex_landscape.dds";
		image_names[5] = "/img/img_tmpobjs.dds";
	end;
	
	--specialobjects
	obelisk_img = love.graphics.newQuad(0, 17*32, 64,128, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	altar_img = love.graphics.newQuad(64, 17*32, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	box_img = love.graphics.newQuad(128, 17*32, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	competition_img = love.graphics.newQuad(64, 19*32, 32,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	pedestal_img = love.graphics.newQuad(128, 18*32, 32,96, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	portal_img = love.graphics.newQuad(32*5, 20*32, 64,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	well_img = love.graphics.newQuad(7*32, 17*32, 128,128, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	trashheap_img = love.graphics.newQuad(32*5, 18*32, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	scullpile_img = love.graphics.newQuad(32*11, 17*32, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	crystals_img = love.graphics.newQuad(32*11, 19*32, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	
	barrel_img = {};
	for i=1,12 do
		local _x = (i-1)*64;
		table.insert(barrel_img,love.graphics.newQuad(_x, 320, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()));
	end;
	
	cauldron_img = {};
	for i=1,11 do
		local _x = (i-1)*64;
		table.insert(cauldron_img,love.graphics.newQuad(_x, 384, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()));
	end;
	bag_img = love.graphics.newQuad(0, 0, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	trap_img = love.graphics.newQuad(224, 0, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	chest_img = {
	love.graphics.newQuad(10, 40, 48,48, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(182, 40, 48,48, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(96, 40, 48,48, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(10, 40, 48,48, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(180, 40, 48,48, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(100, 40, 48,48, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	};
	door_img = {};
	for i=1,4 do
		local _x = (i-1)*64;
		table.insert(door_img,love.graphics.newQuad(_x, 448, 64,96, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()));
	end;
	--/special objects
	
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
	
	special_objects_texts = {
		"ob","al","pd","cm","pt",
		"wl","br","cl","cn","tr",
		"bg","ch","cr","th","sp",
		"wb","sk","sc","ug","cf",
		"dr","fn","bx","?","?",
		};
	
	pedestal_buffs={
		{"heroism","heroism_power","heroism_dur"},
		{"prayer","prayer",false},
		{"bless","bless",false},
		{"fate","fateself",false},
		{"thirstofblood","thirstofblood",false},
		{"stoneskill","stoneskill_power","stoneskill_dur"},
		{"shield","shield",false},
		{"protfromfire","protfromfire_power","protfromfire_dur"},
		{"protfromcold","protfromcold_power","protfromcold_dur"},
		{"protfromstatic","protfromstatic_power","protfromstatic_dur"},
		{"protfromacid","protfromacid_power","protfromacid_dur"},
		{"protfrompoison","protfrompoison_power","protfrompoison_dur"},
		{"protfromlight","protfromlight_power","protfromlight_dur"},
		{"protfromdarkness","protfromdarkness_power","protfromdarkness_dur"},
		{"protofmind","protofmind_power","protofmind_dur"},
		{"protofspirit","protofspirit_power","protofspirit_dur"},
		{"protfrodisease","protfrodisease_power","protfrodisease_dur"},
		{"executor","executor_power","executor_dur"},
		{"haste","haste",false},
		{"hourofpower","hourofpower_power","hourofpower_dur"},
		{"dayofgods","dayofgods_power","dayofgods_dur"},
		{"dash","dash_power","dash_dur"},
		{"might","might_power","might_dur"},
		{"glamour","glamour_power","glamour_dur"},
		{"concentration","concentration_power","concentration_dur"},
		{"precision","precision_power","precision_dur"},
		{"luckyday","luckyday_power","luckyday_dur"},
		{"holyblood","holyblood_power","holyblood_dur"},
		{"divineintervention","divineintervention"},
		};
	pedestal_current_buff_index = 1;
	pedestal_current_buff_name = pedestal_buffs[pedestal_current_buff_index][1];
	pedestal_current_value1 = 10;
	pedestal_current_value2= 5;
	competition_stats = {"mgt","enu","spd","dex","acu","sns","int","spr","chr","luk"};
	competition_current_stat_index = 1;
	competition_current_stat = competition_stats[competition_current_stat_index];
	competition_current_limit = 50;
	competition_current_bonus = 5;
	global.portal_current_out_x = math.ceil(map_w/2);
	global.portal_current_out_y = math.ceil(map_h/2);
	global.portal_capture_coordinates = false;
	altar_stats = {"mgt","enu","spd","dex","acu","sns","int","spr","chr","luk","rezfire","rezcold","rezstatic","rezpoison","rezacid","rezmind","rezdisease","rezspirit","rezdarkness","rezlight"};
	altar_current_buff = 1;
	altar_current_value = 1;
	well_types = {"normal","dry","dungeon","bag","magical add","magical stat","magical buff","magical cure","drunk","poisoned","infected","cursed"};
	well_current_type_index = 1;
	well_current_type_name = well_types[well_current_type_index];
	well_current_area = 1;
	well_current_level = 3;
	well_current_number = 10;
	well_current_mask = 50;
	well_conditions={"poison","disease","curse","weakness"};
	well_current_condition_index = 1;
	well_current_condition_name = well_conditions[well_current_condition_index];
	--well_current_area_x = ;
	--well_current_area_y = ;
	well_addtypes = {"hp","sp","st"};
	well_current_add_value = 10;
	well_current_addtype_index = 1;
	well_current_addtype_name = well_addtypes[well_current_addtype_index];
	well_stats = {"mgt","enu","spd","dex","acu","sns","int","spr","chr","luk","rezfire","rezcold","rezstatic","rezpoison","rezacid","rezmind","rezdisease","rezspirit","rezdarkness","rezlight"};
	well_current_stat_index = 1;
	well_current_stat_name = well_stats[well_current_stat_index];
	well_buffs = {
		"mgt_buff",
		"enu_buff",
		"dex_buff",
		"spd_buff",
		"acu_buff",
		"sns_buff",
		"int_buff",
		"spr_buff",
		"luk_buff",
		"chr_buff",
		"protfromfire","protfromfire_power","protfromfire_dur",
		"protfromcold","protfromcold_power","protfromcold_dur",
		"protfromstatic","protfromstatic_power","protfromstatic_dur",
		"protfromacid","protfromacid_power","protfromacid_dur",
		"protfrompoison","protfrompoison_power","protfrompoison_dur",
		"protfromlight","protfromlight_power","protfromlight_dur",
		"protfromdarkness","protfromdarkness_power","protfromdarkness_dur",
		"protofmind","protofmind_power","protofmind_dur",
		"protofspirit","protofspirit_power","protofspirit_dur",
		"protfrodisease","protfrodisease_power","protfrodisease_dur",
	};
	well_current_buff_index = 1;
	well_current_buff_name = well_buffs[well_current_buff_index];
	well_current_power = 5;
	well_current_duration = 10;
	well_current_map = 1;
	chest_current_rotation = 1;
	chest_current_material = 1;
	chest_current_opened = 1;
	chest_current_locked = 1;
	chest_locktypes = {"none","simple","cylinder","disk"};
	chest_current_locktype_index = 1;
	chest_current_locktype_name = chest_locktypes[chest_current_locktype_index];
	chest_current_lockcode = "random";
	chest_current_trapcode = "random";
	chest_current_trappower = 10;
	chest_traptypes={"none","random","fire","cold","static","poison","acid","disease","spikes","teleport",",bell"};
	chest_current_traptype_index = 1;
	chest_current_traptype_name=chest_traptypes[chest_current_traptype_index];
	trap_current_trapcode = "random";
	trap_current_trappower = 10;
	trap_traptypes={"random","fire","cold","static","poison","acid","disease","spikes","teleport",",bell"};
	trap_current_trap_type_index = 1;
	trap_current_traptype_name = trap_traptypes[trap_current_trap_type_index];
	trap_current_mask=50;
	barrel_types={"none","mgt","enu","spd","dex","acu","sns","int","spr","chr","luk"};
	barrel_current_type = 1;
	barrel_current_name = barrel_types[barrel_current_type];
	cauldron_types={"none","rezfire","rezcold","rezstatic","rezpoison","rezacid","rezdisease","rezmind","rezspirit","rezlight","rezdarkness"};
	cauldron_current_type = 1;
	cauldron_current_name = cauldron_types[cauldron_current_type];
	row_status=0;
	rows_total=22;
	special_objects_status = 0;
	showhidden = 1;
	global.show_harvest = 1;
	global.show_decals = 1;
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
	global.subhex = 1;
	
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
	--[[
	submap={};
	for mx = 1,map_w do
		submap[mx] = {};
		for my = 1,map_h do
			submap[mx][my] = 41;
		end;
	end;
	]]
	if not objects_list then
		objects_list={};
	end;
	if not bags_list then
		bags_list={};
	end;
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
	mX, mY = love.mouse.getPosition();
	cursor_world_y=math.ceil((mY-top_space)/tile_h*4/3) + map_y;
	if cursor_world_y/2 == math.ceil(cursor_world_y/2) then
		cursor_world_x=math.ceil((mX-left_space)/tile_w+1)+map_x;
	else
		cursor_world_x=math.ceil((mX-left_space)/tile_w+0.5)+map_x;
	end;
	loveframes.update(dt);
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
	
	if editor_status == "subhexes" then
		for j=1,10 do
			love.graphics.draw(media.images.imgsub, tile[row_status*10+j], btn_x+2, 240+(j-1)*40);
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

function special_objects_parametres (special_objects_status)
	if special_objects_status == "ob" then
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-100);
		text:SetMaxWidth(230);
		text:SetText("puzzle part");
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-100, global.screenHeight-100);
		textinput:SetWidth(76);
		textinput:SetText(1);
		textinput:SetLimit(4);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				obelisk_puzzle_part=tonumber(text);
			end;
		end;
	end;
	if special_objects_status == "pd" then
		button1 = loveframes.Create("button")
		button1:SetPos(global.screenWidth-140, global.screenHeight-100);
		button1:SetHeight(20);
		button1:SetWidth(20);
		button1:SetText("<");
		button1.OnClick = function(object)
			if pedestal_current_buff_index and pedestal_current_buff_index  > 1 then
				pedestal_current_buff_index = pedestal_current_buff_index - 1;
				pedestal_current_buff_name = pedestal_buffs[pedestal_current_buff_index][1];
			end;
		end;
		button2 = loveframes.Create("button")
		button2:SetPos(global.screenWidth-40, global.screenHeight-100);
		button2:SetHeight(20);
		button2:SetWidth(20);
		button2:SetText(">");
		button2.OnClick = function(object)
			if pedestal_current_buff_index and pedestal_current_buff_index < #pedestal_buffs then
				pedestal_current_buff_index = pedestal_current_buff_index + 1;
				pedestal_current_buff_name = pedestal_buffs[pedestal_current_buff_index][1];
			end;
		end;
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-100);
		text:SetMaxWidth(100);
		text:SetText("buff");
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-80);
		text:SetMaxWidth(100);
		text:SetText("lvl");
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-100, global.screenHeight-80);
		textinput:SetWidth(76);
		textinput:SetText(pedestal_current_value1);
		textinput:SetLimit(2);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				pedestal_current_value1 = tonumber(text);
			end;
		end;
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-60);
		text:SetMaxWidth(230);
		text:SetText("num");
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-100, global.screenHeight-60);
		textinput:SetWidth(76);
		textinput:SetText(pedestal_current_value2);
		textinput:SetLimit(2);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				pedestal_current_value2 = math.min(20,tonumber(text));
			end;
		end;
	end;
	
	if special_objects_status == "cm" then
		button1 = loveframes.Create("button")
		button1:SetPos(global.screenWidth-140, global.screenHeight-100);
		button1:SetHeight(20);
		button1:SetWidth(20);
		button1:SetText("<");
		button1.OnClick = function(object)
			if competition_current_stat_index and competition_current_stat_index  > 1 then
				competition_current_stat_index = competition_current_stat_index - 1;
				competition_current_stat = competition_stats[competition_current_stat_index];
			end;
		end;
		button2 = loveframes.Create("button")
		button2:SetPos(global.screenWidth-40, global.screenHeight-100);
		button2:SetHeight(20);
		button2:SetWidth(20);
		button2:SetText(">");
		button2.OnClick = function(object)
			if competition_current_stat_index and competition_current_stat_index < #competition_stats then
				competition_current_stat_index = competition_current_stat_index + 1;
				competition_current_stat = competition_stats[competition_current_stat_index];
			end;
		end;
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-100);
		text:SetMaxWidth(100);
		text:SetText("stat");
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-80);
		text:SetMaxWidth(100);
		text:SetText("limit");
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-100, global.screenHeight-80);
		textinput:SetWidth(76);
		textinput:SetText(competition_current_limit);
		textinput:SetLimit(1);
		textinput:SetUsable({"1","2","3","4","5"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				competition_current_limit = tonumber(text);
			end;
		end;
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-60);
		text:SetMaxWidth(230);
		text:SetText("bonus");
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-100, global.screenHeight-60);
		textinput:SetWidth(76);
		textinput:SetText(competition_current_bonus);
		textinput:SetLimit(2);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				competition_current_bonus = math.min(20,tonumber(text));
			end;
		end;
	end;
	
	if special_objects_status == "al" then
		button1 = loveframes.Create("button")
		button1:SetPos(global.screenWidth-140, global.screenHeight-100);
		button1:SetHeight(20);
		button1:SetWidth(20);
		button1:SetText("<");
		button1.OnClick = function(object)
			if altar_current_stat_index and altar_current_stat_index  > 1 then
				altar_current_stat_index = altar_current_stat_index - 1;
				altar_current_stat = altar_stats[altar_current_stat_index];
			end;
		end;
		button2 = loveframes.Create("button")
		button2:SetPos(global.screenWidth-40, global.screenHeight-100);
		button2:SetHeight(20);
		button2:SetWidth(20);
		button2:SetText(">");
		button2.OnClick = function(object)
			if altar_current_stat_index and altar_current_stat_index < #altar_stats then
				altar_current_stat_index = altar_current_stat_index + 1;
				altar_current_stat = altar_stats[altar_current_stat_index];
			end;
		end;
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-100);
		text:SetMaxWidth(100);
		text:SetText("stat");
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-60);
		text:SetMaxWidth(230);
		text:SetText("bonus");
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-100, global.screenHeight-60);
		textinput:SetWidth(76);
		textinput:SetText(altar_current_bonus);
		textinput:SetLimit(2);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				altar_current_bonus = math.min(20,tonumber(text));
			end;
		end;
	end;
	if special_objects_status == "pt" then
		button1 = loveframes.Create("button")
		button1:SetPos(global.screenWidth-240, global.screenHeight-60);
		button1:SetHeight(30);
		button1:SetWidth(30);
		button1:SetText("x");
		button1.OnClick = function(object)
			global.portal_capture_coordinates = true;
		end;
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-200, global.screenHeight-60);
		textinput:SetWidth(76);
		textinput:SetText(global.portal_current_out_x);
		textinput:SetLimit(5);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				global.portal_current_out_x = math.min(text,map_w);
			end;
		end;
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-100, global.screenHeight-60);
		textinput:SetWidth(76);
		textinput:SetText(global.portal_current_out_y);
		textinput:SetLimit(5);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				global.portal_current_out_y = math.min(text,map_h);
			end;
		end;		
	end;
	
	if special_objects_status == "ch" then
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-140);
		text:SetMaxWidth(100);
		text:SetText("lock type");
		
		button1 = loveframes.Create("button")
		button1:SetPos(global.screenWidth-140, global.screenHeight-140);
		button1:SetHeight(20);
		button1:SetWidth(20);
		button1:SetText("<");
		button1.OnClick = function(object)
			if chest_current_locktype_index and chest_current_locktype_index  > 1 then
				chest_current_locktype_index = chest_current_locktype_index - 1;
				chest_current_locktype_name = chest_locktypes[chest_current_locktype_index];
				loveframes.util.RemoveAll();
				drawUIButtons();
				draw_buttons();
				special_objects_parametres(special_objects_status);
			end;
		end;
		button2 = loveframes.Create("button")
		button2:SetPos(global.screenWidth-40, global.screenHeight-140);
		button2:SetHeight(20);
		button2:SetWidth(20);
		button2:SetText(">");
		button2.OnClick = function(object)
			if chest_current_locktype_index and chest_current_locktype_index < #chest_locktypes then
				chest_current_locktype_index = chest_current_locktype_index + 1;
				chest_current_locktype_name = chest_locktypes[chest_current_locktype_index];
				loveframes.util.RemoveAll();
				drawUIButtons();
				draw_buttons();
				special_objects_parametres(special_objects_status);
			end;
		end;
		
		if chest_current_locktype_index > 1 then
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-200, global.screenHeight-120);
			text:SetMaxWidth(100);
			text:SetText("lock code");
			
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-120);
			textinput:SetWidth(76);
			textinput:SetText(chest_current_lockcode);
			textinput:SetLimit(12);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					chest_current_lockcode  = text;
				end;
			end;
		end;
		
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-100);
		text:SetMaxWidth(100);
		text:SetText("trap type");
		
		button3 = loveframes.Create("button")
		button3:SetPos(global.screenWidth-140, global.screenHeight-100);
		button3:SetHeight(20);
		button3:SetWidth(20);
		button3:SetText("<");
		button3.OnClick = function(object)
			if chest_current_traptype_index and chest_current_traptype_index  > 1 then
				chest_current_traptype_index = chest_current_traptype_index - 1;
				chest_current_traptype_name = chest_traptypes[chest_current_traptype_index];
				loveframes.util.RemoveAll();
				drawUIButtons();
				draw_buttons();
				special_objects_parametres(special_objects_status);
			end;
		end;
		button4 = loveframes.Create("button")
		button4:SetPos(global.screenWidth-40, global.screenHeight-100);
		button4:SetHeight(20);
		button4:SetWidth(20);
		button4:SetText(">");
		button4.OnClick = function(object)
			if chest_current_traptype_index and chest_current_traptype_index < #chest_traptypes then
				chest_current_traptype_index = chest_current_traptype_index + 1;
				chest_current_traptype_name = chest_traptypes[chest_current_traptype_index];
				loveframes.util.RemoveAll();
				drawUIButtons();
				draw_buttons();
				special_objects_parametres(special_objects_status);
			end;
		end;
		
		if chest_current_traptype_index > 1 then
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-200, global.screenHeight-80);
			text:SetMaxWidth(100);
			text:SetText("trap power");
			
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-80);
			textinput:SetWidth(76);
			textinput:SetText(chest_current_trappower);
			textinput:SetLimit(2);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					chest_current_trappower  = text; 
				end;
			end;
			
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-200, global.screenHeight-60);
			text:SetMaxWidth(100);
			text:SetText("trap code");
			
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-60);
			textinput:SetWidth(76);
			textinput:SetText(chest_current_trapcode);
			textinput:SetLimit(9);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					chest_current_trapcode  = text; --"random","random3","random4","random5","123456789"
				end;
			end;
			
		end;
		
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-40);
		text:SetMaxWidth(100);
		text:SetText("material");
		
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-120, global.screenHeight-40);
		textinput:SetWidth(76);
		textinput:SetText(chest_current_material);
		textinput:SetLimit(9);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				chest_current_material  = text; --"random","random3","random4","random5","123456789"
			end;
		end;

	end;
	
	if special_objects_status == "tr" then
		
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-100);
		text:SetMaxWidth(100);
		text:SetText("traptype");
		
		button3 = loveframes.Create("button")
		button3:SetPos(global.screenWidth-140, global.screenHeight-100);
		button3:SetHeight(20);
		button3:SetWidth(20);
		button3:SetText("<");
		button3.OnClick = function(object)
			if trap_current_traptype_index and trap_current_traptype_index  > 1 then
				trap_current_traptype_index = trap_current_traptype_index - 1;
				trap_current_traptype_name = trap_traptypes[trap_current_traptype_index];
				loveframes.util.RemoveAll();
				drawUIButtons();
				draw_buttons();
				special_objects_parametres(special_objects_status);
			end;
		end;
		button4 = loveframes.Create("button")
		button4:SetPos(global.screenWidth-40, global.screenHeight-100);
		button4:SetHeight(20);
		button4:SetWidth(20);
		button4:SetText(">");
		button4.OnClick = function(object)
			if trap_current_traptype_index and trap_current_traptype_index < #trap_traptypes then
				trap_current_traptype_index = trap_current_traptype_index + 1;
				trap_current_traptype_name = trap_traptypes[trap_current_traptype_index];
				loveframes.util.RemoveAll();
				drawUIButtons();
				draw_buttons();
				special_objects_parametres(special_objects_status);
			end;
		end;
		
		
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-80);
		text:SetMaxWidth(100);
		text:SetText("trappower");
		
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-120, global.screenHeight-80);
		textinput:SetWidth(76);
		textinput:SetText(trap_current_trappower);
		textinput:SetLimit(2);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				trap_current_trappower  = math.min(text,map_w); 
			end;
		end;
		
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-60);
		text:SetMaxWidth(100);
		text:SetText("trappower");
		
		local textinput = loveframes.Create("textinput");
		textinput:SetPos(global.screenWidth-120, global.screenHeight-60);
		textinput:SetWidth(76);
		textinput:SetText(trap_current_trapcode);
		textinput:SetLimit(9);
		textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
		textinput.OnEnter = function(object, text)
			if text ~= nil then
				trap_current_trapcode  = math.min(text,map_w); --"random","random3","random4","random5","123456789"
			end;
		end;
		
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-40);
		text:SetMaxWidth(100);
		text:SetText("mask");
		
		local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-40);
			textinput:SetWidth(76);
			textinput:SetText(trap_current_mask);
			textinput:SetLimit(9);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					trap_current_mask  = math.min(text,map_w); --"random","random3","random4","random5","123456789"
				end;
			end;

	end;

	if special_objects_status == "wl" then
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-220, global.screenHeight-140);
		text:SetMaxWidth(100);
		text:SetText("well type");
	
		button1 = loveframes.Create("button")
		button1:SetPos(global.screenWidth-160, global.screenHeight-140);
		button1:SetHeight(20);
		button1:SetWidth(20);
		button1:SetText("<");
		button1.OnClick = function(object)
			if well_current_type_index and well_current_type_index  > 1 then
				well_current_type_index = well_current_type_index - 1;
				well_current_type_name = well_types[well_current_type_index];
				loveframes.util.RemoveAll();
				drawUIButtons();
				draw_buttons();
				special_objects_parametres(special_objects_status);
			end;
		end;
		button2 = loveframes.Create("button")
		button2:SetPos(global.screenWidth-40, global.screenHeight-140);
		button2:SetHeight(20);
		button2:SetWidth(20);
		button2:SetText(">");
		button2.OnClick = function(object)
			if well_current_type_index and well_current_type_index < #well_types then
				well_current_type_index = well_current_type_index + 1;
				well_current_type_name = well_types[well_current_type_index];
				loveframes.util.RemoveAll();
				drawUIButtons();
				draw_buttons();
				special_objects_parametres(special_objects_status);
			end;
		end;
		
		if well_current_type_name == "normal" then	
		elseif well_current_type_name == "dry" then
		elseif well_current_type_name == "bag" then
		elseif well_current_type_name == "dungeon" then
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-200, global.screenHeight-120);
			text:SetMaxWidth(100);
			text:SetText("area");
				
			
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-120);
			textinput:SetWidth(76);
			textinput:SetText(well_current_area);
			textinput:SetLimit(3);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
			if text ~= nil then
				well_current_area  = text;
			end;
		end;
		elseif well_current_type_name == "magical add" then
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-120);
			text:SetMaxWidth(100);
			text:SetText("stat");
			
			button1 = loveframes.Create("button")
			button1:SetPos(global.screenWidth-160, global.screenHeight-120);
			button1:SetHeight(20);
			button1:SetWidth(20);
			button1:SetText("<");
			button1.OnClick = function(object)
				if well_current_addtype_index and well_current_addtype_index  > 1 then
					well_current_addtype_index = well_current_addtype_index - 1;
					well_current_addtype_name = well_addtypes[well_current_addtype_index];
				end;
			end;
			button2 = loveframes.Create("button")
			button2:SetPos(global.screenWidth-40, global.screenHeight-120);
			button2:SetHeight(20);
			button2:SetWidth(20);
			button2:SetText(">");
			button2.OnClick = function(object)
				if well_current_addtype_index and well_current_addtype_index < #well_addtypes then
					well_current_addtype_index = well_current_addtype_index + 1;
					well_current_addtype_name = well_addtypes[well_current_addtype_index];
				end;
			end;
			
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-100);
			text:SetMaxWidth(100);
			text:SetText("value");
		
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-100);
			textinput:SetWidth(76);
			textinput:SetText(well_current_add_value);
			textinput:SetLimit(3);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					well_current_add_value  = text;
				end;
			end;
		elseif well_current_type_name == "magical stat" then
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-120);
			text:SetMaxWidth(100);
			text:SetText("stat");
			
			button1 = loveframes.Create("button")
			button1:SetPos(global.screenWidth-160, global.screenHeight-120);
			button1:SetHeight(20);
			button1:SetWidth(20);
			button1:SetText("<");
			button1.OnClick = function(object)
				if well_current_stat_index and well_current_stat_index  > 1 then
					well_current_stat_index = well_current_stat_index - 1;
					well_current_stat_name = well_stats[well_current_stat_index];
				end;
			end;
			button2 = loveframes.Create("button")
			button2:SetPos(global.screenWidth-40, global.screenHeight-120);
			button2:SetHeight(20);
			button2:SetWidth(20);
			button2:SetText(">");
			button2.OnClick = function(object)
				if well_current_stat_index and well_current_stat_index < #well_stats then
					well_current_stat_index = well_current_stat_index + 1;
					well_current_stat_name = well_stats[well_current_stat_index];
				end;
			end;
			
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-100);
			text:SetMaxWidth(100);
			text:SetText("value");
		
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-100);
			textinput:SetWidth(76);
			textinput:SetText(well_current_add_value);
			textinput:SetLimit(3);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					well_current_add_value  = text;
				end;
			end;
		elseif well_current_type_name == "magical buff" then
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-120);
			text:SetMaxWidth(100);
			text:SetText("buff");
			
			button1 = loveframes.Create("button")
			button1:SetPos(global.screenWidth-160, global.screenHeight-120);
			button1:SetHeight(20);
			button1:SetWidth(20);
			button1:SetText("<");
			button1.OnClick = function(object)
				if well_current_buff_index and well_current_buff_index  > 1 then
					well_current_buff_index = well_current_buff_index - 1;
					well_current_buff_name = well_buffs[well_current_buff_index];
				end;
			end;
			button2 = loveframes.Create("button")
			button2:SetPos(global.screenWidth-40, global.screenHeight-120);
			button2:SetHeight(20);
			button2:SetWidth(20);
			button2:SetText(">");
			button2.OnClick = function(object)
				if well_current_buff_index and well_current_buff_index < #well_buffs then
					well_current_buff_index = well_current_buff_index + 1;
					well_current_buff_name = well_buffs[well_current_buff_index];
				end;
			end;
			
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-100);
			text:SetMaxWidth(100);
			text:SetText("duration");
		
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-100);
			textinput:SetWidth(76);
			textinput:SetText(well_current_duration);
			textinput:SetLimit(3);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					well_current_duration  = text;
				end;
			end;
			
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-80);
			text:SetMaxWidth(100);
			text:SetText("power");
		
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-80);
			textinput:SetWidth(76);
			textinput:SetText(well_current_power);
			textinput:SetLimit(3);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					well_current_power  = text;
				end;
			end;
		elseif well_current_type_name == "magical cure" then
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-120);
			text:SetMaxWidth(100);
			text:SetText("cure");
			
			button1 = loveframes.Create("button")
			button1:SetPos(global.screenWidth-160, global.screenHeight-120);
			button1:SetHeight(20);
			button1:SetWidth(20);
			button1:SetText("<");
			button1.OnClick = function(object)
				if well_current_condition_index and well_current_condition_index  > 1 then
					well_current_condition_index = well_current_condition_index - 1;
					well_current_condition_name = well_conditions[well_current_condition_index];
				end;
			end;
			button2 = loveframes.Create("button")
			button2:SetPos(global.screenWidth-40, global.screenHeight-120);
			button2:SetHeight(20);
			button2:SetWidth(20);
			button2:SetText(">");
			button2.OnClick = function(object)
				if well_current_condition_index and well_current_condition_index < #well_conditions then
					well_current_condition_index = well_current_condition_index + 1;
					well_current_condition_name = well_conditions[well_current_condition_index];
				end;
			end;	
		elseif well_current_type_name == "infected" or well_current_type_name == "poisoned" or well_current_type_name == "cursed" then
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-120);
			text:SetMaxWidth(100);
			text:SetText("level");
		
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-120);
			textinput:SetWidth(76);
			textinput:SetText(well_current_level);
			textinput:SetLimit(1);
			textinput:SetUsable({"0","1","2","3","4","5"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					well_current_level  = math.min(5,tonumber(text));
				end;
			end;
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-100);
			text:SetMaxWidth(100);
			text:SetText("number");
		
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-100);
			textinput:SetWidth(76);
			textinput:SetText(well_current_number);
			textinput:SetLimit(1);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					well_current_number  = math.min(100,tonumber(text));
				end;
			end;
			
			local text = loveframes.Create("text");
			text:SetPos(global.screenWidth-220, global.screenHeight-80);
			text:SetMaxWidth(100);
			text:SetText("mask");
			
			local textinput = loveframes.Create("textinput");
			textinput:SetPos(global.screenWidth-120, global.screenHeight-80);
			textinput:SetWidth(76);
			textinput:SetText(well_current_mask);
			textinput:SetLimit(1);
			textinput:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textinput.OnEnter = function(object, text)
				if text ~= nil then
					well_current_mask  = math.min(100,tonumber(text));
				end;
			end;
		end;
	end;
	if special_objects_status == "br" then
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-120);
		text:SetMaxWidth(100);
		text:SetText("stat");
		
		button1 = loveframes.Create("button")
		button1:SetPos(global.screenWidth-140, global.screenHeight-120);
		button1:SetHeight(20);
		button1:SetWidth(20);
		button1:SetText("<");
		button1.OnClick = function(object)
			if barrel_current_type and barrel_current_type  > 1 then
				barrel_current_type = barrel_current_type - 1;
				barrel_current_name = barrel_types[barrel_current_type];
			end;
		end;
		button2 = loveframes.Create("button")
		button2:SetPos(global.screenWidth-40, global.screenHeight-120);
		button2:SetHeight(20);
		button2:SetWidth(20);
		button2:SetText(">");
		button2.OnClick = function(object)
			if barrel_current_type and barrel_current_type < #barrel_types then
				barrel_current_type = barrel_current_type + 1;
				barrel_current_name = barrel_types[barrel_current_type];
			end;
		end;
	end;
	if special_objects_status == "cl" then
		local text = loveframes.Create("text");
		text:SetPos(global.screenWidth-200, global.screenHeight-120);
		text:SetMaxWidth(100);
		text:SetText("stat");
		
		button1 = loveframes.Create("button")
		button1:SetPos(global.screenWidth-140, global.screenHeight-120);
		button1:SetHeight(20);
		button1:SetWidth(20);
		button1:SetText("<");
		button1.OnClick = function(object)
			if cauldron_current_type and cauldron_current_type  > 1 then
				cauldron_current_type = cauldron_current_type - 1;
				cauldron_current_name = cauldron_types[cauldron_current_type];
			end;
		end;
		button2 = loveframes.Create("button")
		button2:SetPos(global.screenWidth-40, global.screenHeight-120);
		button2:SetHeight(20);
		button2:SetWidth(20);
		button2:SetText(">");
		button2.OnClick = function(object)
			if cauldron_current_type and cauldron_current_type < #cauldron_types then
				cauldron_current_type = cauldron_current_type + 1;
				cauldron_current_name = cauldron_types[cauldron_current_type];
			end;
		end;
	end;
end;

function draw_buttons ()
	if editor_status == "hexes" or editor_status == "subhexes" then
		cc=4;
	elseif editor_status == "objects" then
		cc=5;
	elseif editor_status == "background" then
		cc=2;
	elseif editor_status == "help" then
		cc=0;
	end;
	
	if editor_status == "objects" then
		local togglebuttons = {};
		for i=1,cc do
			for h=1,5 do        
				togglebuttons[#togglebuttons+1] = loveframes.Create("button")
				togglebuttons[#togglebuttons]:SetPos(row_buttons[(i-1)*5+h][1], row_buttons[(i-1)*5+h][2]);
				togglebuttons[#togglebuttons]:SetHeight(40);
				togglebuttons[#togglebuttons]:SetWidth(40);
				togglebuttons[#togglebuttons]:SetText(special_objects_texts[5*(i-1)+h]);
				togglebuttons[#togglebuttons].OnClick = function(object)
					special_objects_status=special_objects_texts[5*(i-1)+h];
					loveframes.util.RemoveAll();
					drawUIButtons();
					draw_buttons();
					special_objects_parametres(special_objects_status);
				end;
			end;
		end;
		togglebuttons[#togglebuttons+1] = loveframes.Create("button")
		togglebuttons[#togglebuttons]:SetPos(global.screenWidth-200, 400);
		togglebuttons[#togglebuttons]:SetHeight(40);
		togglebuttons[#togglebuttons]:SetWidth(80);
		togglebuttons[#togglebuttons]:SetText("clear");
		togglebuttons[#togglebuttons].OnClick = function(object)
			special_objects_status="clear";
			loveframes.util.RemoveAll();
			drawUIButtons();
			draw_buttons();
			special_objects_parametres(special_objects_status);
		end;
	end;
	
	if editor_status == "subhexes" then
		local togglebuttons = {};
		for i=1,cc do
			for h=1,5 do        
				togglebuttons[#togglebuttons+1] = loveframes.Create("button")
				togglebuttons[#togglebuttons]:SetPos(row_buttons[(i-1)*5+h][1],  row_buttons[(i-1)*5+h][2]);
				togglebuttons[#togglebuttons]:SetHeight(40);
				togglebuttons[#togglebuttons]:SetWidth(40);
				togglebuttons[#togglebuttons]:SetText(5*(i-1)+h);
				togglebuttons[#togglebuttons].OnClick = function(object)
					row_status=(i-1)*5+h-1;
					boxes();
					draw_hexbuttons ();
				end;
			end;
		end;
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
					row_status=(i-1)*5+h-1;
					boxes();
					draw_hexbuttons ();

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
	if (editor_status == "hexes" or editor_status == "buildings" or editor_status == "harvest" or editor_status == "decals" or editor_status == "homelands" or editor_status == "subhexes" or editor_status == "objects") and hexes_status==1 then
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
 
function draw_submap()
	if (editor_status == "hexes" or editor_status == "buildings" or editor_status == "harvest" or editor_status == "decals" or editor_status == "homelands" or editor_status == "subhexes" or editor_status == "objects") and global.subhex == 1 then
		for my=1, math.min(map_display_h, map_h-map_y) do
			for mx=1, math.min(map_display_w, map_w-map_x) do	
				if show_invisible and submap[my+map_y][mx+map_x]<20  and submap[my+map_y][mx+map_x]<300 then
					drawHex(mx+map_x,my+map_y,tile[submap[my+map_y][mx+map_x]]);
				elseif submap[my+map_y][mx+map_x]>20 and submap[my+map_y][mx+map_x]<300 then
					drawHex(mx+map_x,my+map_y,tile[submap[my+map_y][mx+map_x]]);
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
				submap[my] = {};
				harvest_table[my] = {};
				buildings_table[my] = {};
				homelands_table = {};
			end;
			if not map[my][mx] then
				map[my][mx] = current_hex_type;
				submap[my][mx] = current_hex_type;
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
			table.remove(submap,my);
			table.remove(harvest_table,my);
			table.remove(buildings_table,my);
			table.remove(homelands_table,my);
		end;
		if map[my] then
			local _limit2 = #map[my];
			for mx=_limit2,1,-1 do
				if mx > map_w then
					table.remove(map[my],mx);
					table.remove(submap[my],mx);
					table.remove(harvest_table[my],mx);
					table.remove(buildings_table[my],mx);
					table.remove(homelands_table[my],mx);
				end;
			end;
		end;
	end;
	for i=1,#bags_list do
		if not insideMap(bags_list[i].x,bags_list[i].y) or not insideMap(bags_list[i].xi,bags_list[i].yi) then
			table.remove(bags_list,i);
		end;
	end;
	for i=1,#objects_list do
		if not insideMap(objects_list[i].x,objects_list[i].y) or not insideMap(objects_list[i].xi,objects_list[i].yi) then
			table.remove(objects_list,i);
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
	if object_status==1 and (editor_status == "hexes" or editor_status == "buildings" or editor_status == "harvest" or editor_status == "decals" or editor_status == "homelands" or editor_status == "subhexes" or editor_status == "objects") then
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
					love.graphics.draw(img, sprite, ((mx-1)*tile_w+left_space)-tile_w+top_space+addx, (my-1)*tile_h*0.75+addy+top_space)
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
					love.graphics.draw(img, sprite, ((mx-1)*tile_w+left_space+tile_hw)-tile_w+top_space+addx, (my-1)*tile_h*0.75+addy+top_space)
				end;   
			end;
			for j=1,#bags_list do
				if bags_list[j].xi == mx+map_x and bags_list[j].yi == my+map_y and bags_list[j].typ ~= "door" and bags_list[j].typ ~= "well" and bags_list[j].typ ~= "crystals" and bags_list[j].typ ~= "scullpile" and bags_list[j].typ ~= "trashheap" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w-16, (my-1)*tile_h*0.75+top_space-12);
					else  
						love.graphics.draw(media.images.tmpobjs,bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-16, (my-1)*tile_h*0.75+top_space-12);
					end;
				end;
				
				if bags_list[j].xi == mx+map_x and bags_list[j].yi == my+map_y and bags_list[j].typ == "door" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w-32, (my-1)*tile_h*0.75+top_space-64);
					else  
						love.graphics.draw(media.images.tmpobjs,bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-32, (my-1)*tile_h*0.75+top_space-64);
					end;
				end;
				
				if bags_list[j].xi == mx+map_x and bags_list[j].yi == my+map_y and bags_list[j].typ == "box" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w-16, (my-1)*tile_h*0.75+top_space-8);
					else  
						love.graphics.draw(media.images.tmpobjs,bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-16, (my-1)*tile_h*0.75+top_space-8);
					end;
				end;
				
				if bags_list[j].xi == mx+map_x and bags_list[j].yi == my+map_y and bags_list[j].typ == "crystals" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w-32, (my-1)*tile_h*0.75+top_space-36);
					else  
						love.graphics.draw(media.images.tmpobjs,bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-32, (my-1)*tile_h*0.75+top_space-36);
					end;
				end;
				
				if bags_list[j].xi == mx+map_x and bags_list[j].yi == my+map_y and bags_list[j].typ == "scullpile" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w-32, (my-1)*tile_h*0.75+top_space-32);
					else  
						love.graphics.draw(media.images.tmpobjs,bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-32, (my-1)*tile_h*0.75+top_space-32);
					end;
				end;
				
				if bags_list[j].xi == mx+map_x and bags_list[j].yi == my+map_y and bags_list[j].typ == "trashheap" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w-32, (my-1)*tile_h*0.75+top_space-32);
					else  
						love.graphics.draw(media.images.tmpobjs,bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-32, (my-1)*tile_h*0.75+top_space-32);
					end;
				end;
				
				if bags_list[j].xi == mx+map_x and bags_list[j].yi == my+map_y and bags_list[j].typ == "well" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w-64, (my-1)*tile_h*0.75+top_space-96);
					else  
						love.graphics.draw(media.images.tmpobjs,bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-64, (my-1)*tile_h*0.75+top_space-96);
					end;
				end;
				
			end;
			for j=1, #objects_list do
				local addx = 0;
				local add y = 0;
				if objects_list[j].typ == "barrel" or  objects_list[j].typ == "cauldron" then
					addx = 32;
					addy = 32;
				elseif objects_list[j].typ == "obelisk" then
					addx = 32;
					addy = 96;
				elseif objects_list[j].typ == "pedestal" then
					addx = 16;
					addy = 72;			
				elseif objects_list[j].typ == "altar" then
					addx = 32;
					addy = 32;
				elseif objects_list[j].typ == "competition" then
					addx = 16;
					addy = 40;
				elseif objects_list[j].typ == "portal" then
					addx = 32;
					addy = 0;
				elseif objects_list[j].typ == "well" then
					addx = 64;
					addy = 96;
				end;
				if objects_list[j].xi == mx+map_x and objects_list[j].yi == my+map_y then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, objects_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w-addx, (my-1)*tile_h*0.75+top_space-addy);
					else  
						love.graphics.draw(media.images.tmpobjs,objects_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-addx, (my-1)*tile_h*0.75+top_space-addy);
					end;
				end;
			end;
			if (editor_status == "harvest" or editor_status == "hexes" or editor_status == "subhexes" or editor_status == "decals" or editos_status == "buildings" or editor_status == "objects") and harvest_table[my+map_y][mx+map_x][1] ~= 0 and global.show_harvest == 1 then --harvest
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
		if editor_status == "hexes" or editor_status == "buildings" or editor_status == "harvest" or editor_status == "homelands" or editor_status == "subhexes" or editor_status == "objects" then
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
		if editor_status == "hexes" then
			hexes_status=-1*hexes_status;
		elseif editor_status == "subhexes" then
			global.subhex = -1*global.subhex;
		end;
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
	
	if love.keyboard.isDown("lctrl") and key == 't'  then
		editor_status = "objects";
		loveframes.util.RemoveAll();
		drawUIButtons();
		draw_buttons();
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
	if love.keyboard.isDown("lctrl") and key == 'f' then
		if editor_status == "hexes" then
			flood_map();
		elseif editor_status == "subhexes" then
			flood_submap();
		end;
	end;
	if love.keyboard.isDown("lctrl") and key == 'u' then
		loveframes.util.RemoveAll();
		editor_status = "subhexes";
		drawUIButtons();
		draw_buttons ();
	end;
	
	if love.keyboard.isDown("lctrl") and key == 'd' and editor_status == "background" then
		flood_back();
	end;
	if love.keyboard.isDown("lctrl") and key == 'm' then
		editor_status = "minimap";
	end;
	if key == 'escape'  then
		if editor_status == 'objects'and global.portal_capture_coordinates then
			global.portal_capture_coordinates = false;
		else
			editor_status='hexes';
			hexes_status=1;
			object_status=1;
			loveframes.util.RemoveAll();
			drawUIButtons();
			draw_buttons();
			draw_hexbuttons ();
			boxes();
		end;
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
	
	---SUBHEXES
		
	if love.mouse.isDown("r") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "subhexes" and global.copy == 1 then
		global.copied = {};
		if brush == 0 then
			table.insert(global.copied,submap[cursor_world_y][cursor_world_x]);
		elseif brush == 1 or brush == 2 or brush == 3 then
			local rings = ringArea(cursor_world_x,cursor_world_y);
			table.insert(global.copied,submap[cursor_world_y][cursor_world_x]);
			for h=1,brush do
				for i=1,#rings[h] do
					if insideMap(rings[h][i].y,rings[h][i].x) then
						table.insert(global.copied,submap[rings[h][i].y][rings[h][i].x]);
					end;
				end;
			end;
		elseif brush >= 4 and brush <= 10 then
			local boomarea = squareArea(cursor_world_x,cursor_world_y,brush);
			for i=1,#boomarea do
				if insideMap(boomarea[i].y,boomarea[i].x) then
					table.insert(global.copied,submap[boomarea[i].y][boomarea[i].x]);
				end;
			end;
		
		end;
	end;
		
	if love.mouse.isDown("l") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "subhexes" and global.copy == 1 and #global.copied > 0 and global.digger == -1 then
		if brush == 0 then
			if insideMap(cursor_world_y,cursor_world_x) then
				submap[cursor_world_y][cursor_world_x] = global.copied[1];
			end;
		elseif brush == 1 or brush == 2 or brush == 3 then
			local rings = ringArea(cursor_world_x,cursor_world_y);
			local _tmp_array = global.copied;
			if global.randomize_hexes == 1 then
				_tmp_array = randomizeArray(global.copied);
			end;
			submap[cursor_world_y][cursor_world_x] = _tmp_array[1];
			local counter = 2;
			for h=1,brush do
				for i=1,#rings[h] do
					if insideMap(rings[h][i].y,rings[h][i].x) and _tmp_array[counter] then	
						submap[rings[h][i].y][rings[h][i].x] = _tmp_array[counter];
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
					submap[boomarea[i].y][boomarea[i].x] = _tmp_array[counter];
				end;
				counter = counter + 1;
			end;
		
		end;
	end;
	
	if love.mouse.isDown("l") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "subhexes" and global.digger == -1 and global.copy == -1 then
		local mapvalue = 1;
		if brush == 0 then
			if global.randomize_hexes == -1 then
				map_value = current_hex_type+row_status*10;
			else
				local rnd = math.random(0,math.min(global.rnd_value-1,200 - current_hex_type+row_status*10));
				map_value = current_hex_type+rnd+row_status*10;
			end;
			if insideMap(cursor_world_y,cursor_world_x) then
				submap[cursor_world_y][cursor_world_x] = map_value;
			end;
		elseif brush == 1 or brush == 2 or brush == 3 then
			if global.randomize_hexes == -1 then
				map_value = current_hex_type+row_status*10;
			else
				local rnd = math.random(0,math.min(global.rnd_value-1,200 - current_hex_type+row_status*10));
				map_value = current_hex_type+rnd+row_status*10;
			end;
			if insideMap(cursor_world_y,cursor_world_x) then
				submap[cursor_world_y][cursor_world_x] = map_value;
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
						submap[rings[h][i].y][rings[h][i].x] = map_value;
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
					submap[boomarea[i].y][boomarea[i].x] = map_value;
				end;
			end;
		end;
	elseif love.mouse.isDown("l") and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "subhexes" and global.digger == 1 then
			startDiggers(cursor_world_x,cursor_world_y,global.moles,true);
			--global.digger = -1;
	end;
		
		
	----SUBHEXES/
	
	if love.mouse.isDown("l") and insideMap(cursor_world_x,cursor_world_y) and mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "buildings" then
		map[cursor_world_y][cursor_world_x] = 300 + current_building;
		if cursor_world_y/2 == math.ceil(cursor_world_y/2) then
			hexes = "hexes_ev";
		else
			hexes = "hexes_ne";
		end;
		for i=1,#buildings_stats[current_building][hexes] do	
			if cursor_world_y-buildings_stats[current_building][hexes][i][2] > 0 and cursor_world_y-buildings_stats[current_building][hexes][i][2] <= map_h
			and cursor_world_x-buildings_stats[current_building][hexes][i][1] > 0 and cursor_world_x-buildings_stats[current_building][hexes][i][1] <= map_w 
			then
				local mapx = cursor_world_y-buildings_stats[current_building][hexes][i][2];
				local mapy = cursor_world_x-buildings_stats[current_building][hexes][i][1]
				if buildings_stats[current_building][hexes][i][2] ~= 0 or buildings_stats[current_building][hexes][i][1] ~= 0 then
					map[mapx][mapy] = 10;
				end;
				buildings_table[mapy][mapx] = {cursor_world_y,cursor_world_x};
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
	elseif editor_status == "subhexes" then
		for j=1,10 do
			if love.mouse.isDown("l") and mX > global.screenWidth-274 and mY<650 and mX>btn_x and mY>240+(j-1)*40-2 and mX<btn_x+tile_w+8 and mY<240+(j-1)*40-2+36 then
				current_hex_type=j;
				current_area_type=area_table[row_status*10+current_hex_type];
				current_minimap_hex = minimap_table[row_status*10+current_hex_type];
				current_area_stepsound = stepsound_table[row_status*10+current_hex_type];
				boxes();
			end;
		end
	elseif editor_status == "background" then
		for j=1,8 do
			if love.mouse.isDown("l") and mX>global.screenWidth-274 and mX>btn_x and mY>150+(j-1)*60 and mX<btn_x+tile_w and mY<150+(j-1)*60+back_size/5 then
				current_back = j;
			end;
		end;
	end;
	if global.ctrl == -1 and (editor_status == "hexes" or editor_status == "harvest" or editor_status == "homelands" or editor_status == "subhexes") and global.digger == -1 then
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
	if global.randomize_hexes == 1 and (editor_status == "hexes" or editor_status == "harvest" or editor_status == "homelands" or editor_status == "subhexes") then
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
	
	if global.ctrl == -1 and (editor_status == "hexes" or editor_status == "subhexes") and global.digger == 1 then
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
	
	if editor_status == "objects" and special_objects_status == "ch" then
		if button=="wu" then
			if chest_current_rotation < 6 then
				chest_current_rotation = chest_current_rotation + 1;
			end;
		end;
		if button=="wd" then
			if chest_current_rotation > 1 then
				chest_current_rotation = chest_current_rotation - 1;
			end;
		end;
	end;
	
	loveframes.mousepressed(x, y, button);
end

function playingState.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button);
    if mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "objects" and special_objects_status == "pt" then
		if global.portal_capture_coordinates and passCheck (cursor_world_x,cursor_world_y) then
			global.portal_current_out_x = cursor_world_x;
			global.portal_current_out_y = cursor_world_y;
			global.portal_capture_coordinates = false;
			loveframes.util.RemoveAll();
			drawUIButtons();
			draw_buttons();
			special_objects_parametres(special_objects_status);
		end;
	end;
	if mX < global.screenWidth-274 and mY < global.screenHeight-115 and editor_status == "objects" and passCheck (cursor_world_x,cursor_world_y) then
		findBagOrObject(cursor_world_x,cursor_world_y);
		if  special_objects_status == "clear"  then
			--
		elseif special_objects_status == "ob"  then
			table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="obelisk",part=obelisk_puzzle_part,img=obelisk_img});
		elseif special_objects_status == "pt"  then
			table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="portal",outx=global.portal_current_out_x, outy=global.portal_current_out_y,img=portal_img});
		elseif special_objects_status == "al"  then
			table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="altar",uids={},stat=altar_stats[altar_current_stat_index],value=altar_current_value,img=altar_img});
		elseif special_objects_status == "pd"  then
			if pedestal_buffs[pedestal_current_buff_index][3] then
				pedestal_current_value2 = false;
			end;
			table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="pedestal",effect1=pedestal_buffs[2],effect2=pedestal_buffs[3],value1=pedestal_current_value1,value2=pedestal_current_value2,img=pedestal_img});
		elseif special_objects_status == "cm"  then
			table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="competition",uids={},stat=competition_current_stat,limit=competition_current_limit,bonus=competition_current_bonus,img=competition_img});
		elseif special_objects_status == "br" then
			table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="barrel",subtyp=barrel_current_type,img=barrel_img[barrel_current_type]});
		elseif special_objects_status == "cl" then
			table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="cauldron",subtyp=cauldron_current_type,img=cauldron_img[cauldron_current_type]});
		elseif special_objects_status == "wl" then
			if well_current_type_name == "normal" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y, typ="well", subtyp="drink", story="wellclean", plus=false, plusvalue=0, minus=false, minusvalue=0, conditions={}, wimg="well_clean", img=well_img});
			elseif well_current_type_name == "dry" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y, typ="well", subtyp="drink", story="welldry", plus=false, plusvalue=0, minus=false, minusvalue=0, conditions={}, wimg="well_dry", img=well_img});
			elseif well_current_type_name == "bag" then
				table.insert(bags_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="well", opened=false, locked=false, dir=0, img=well_img});
			elseif well_current_type_name == "dungeon" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="well", subtyp="dungeon", story="wellclean", wimg="well_dungeon", opened=false, locked=false, dir=0, img=well_img});
			elseif well_current_type_name == "magical add" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="well", subtyp="drink", story="wellmagical", plus=well_current_addtype_name, plusvalue=well_current_add_value, minus=false, minusvalue=0, conditions={}, wimg="well_magical", img=well_img});
			elseif well_current_type_name == "magical stat" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="well", subtyp="drink", story="wellmagical", permanentplus=well_current_stat_name, permanentplusvalue=well_current_stat_value, plus=false, plusvalue=0, minus=false, minusvalue=0, conditions={}, wimg="well_magical", img=well_img});
			elseif well_current_type_name == "magical buff" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="well", subtyp="drink", story="wellmagical", plus=false, plusvalue=0, minus=false, minusvalue=0, conditions={{well_current_buff_name,well_current_duration,well_current_buff_power}}, wimg="well_magical", img=well_img});
			elseif well_current_type_name == "magical cure" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y, typ="well", subtyp="drink", story="wellmagical", conditions={{well_current_condition_name,well_current_condition_value}}, plus=false, plusvalue=0, minus=false, minusvalue=0, conditions={}, wimg="well_magical", img=well_img});
			elseif well_current_type_name == "drunk" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y, typ="well", subtyp="drink", story="wellevil", conditions={{"drunk",3,10}}, plus=false, plusvalue=0, minus=false, minusvalue=0, conditions={}, wimg="well_evil", img=well_img});
			elseif well_current_type_name == "poisoned" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y, typ="well", subtyp="drink", mask = well_current_mask, story="wellclean", poisoned={well_current_level,well_current_number}, plus=false, plusvalue=0, minus=false, minusvalue=0, conditions={}, wimg="well_clean", img=well_img});
			elseif well_current_type_name == "infected" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y, typ="well", subtyp="drink", mask = well_current_mask, story="wellclean", infected={well_current_level,well_current_number}, plus=false, plusvalue=0, minus=false, minusvalue=0, conditions={}, wimg="well_clean", img=well_img});
			elseif well_current_type_name == "cursed" then
				table.insert(objects_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y, typ="well", subtyp="drink", mask = well_current_mask, story="wellclean", cursed={well_current_level,well_current_number}, plus=false, plusvalue=0, minus=false, minusvalue=0, conditions={}, wimg="well_clean", img=well_img});
			end;
		elseif special_objects_status == "ch" then
			local ring = smallRingArea(cursor_world_x,cursor_world_y);
			local _locked = "false";
			local _locktype = "false";
			local _lockcode = "false";
			if chest_current_locktype_index > 1 then
				_locked = true;
				_locktype = chest_current_locktype_index - 1;
				_lockcode = chest_current_lockcode;
			end;
			local _traped = "false";
			local _traptype = "false";
			local _trapcode = "false";
			local _trappower = "false";
			if chest_current_traptype_index > 1 then
				_traped = true;
				_traptype = chest_traptypes[chest_current_traptype_index];
				_trapcode = chest_current_trapcode;
			end;
			table.insert(bags_list,{x=ring[chest_current_rotation].x,y=ring[chest_current_rotation].y,xi=cursor_world_x,yi=cursor_world_y,typ="chest", dir=chest_current_rotation,inspected=false, material=chest_current_material,opened = false, locked=_locked, locktype=_locktype, lockcode =_lockcode, traped=_traped, triggers="", trapmodel=_traptype, trappower=_trappower,trapcode=_trapcode, img=chest_img[chest_current_rotation]});
		elseif special_objects_status == "tr" then
			_traptype = trap_traptypes[trap_current_traptype_index];
			_trapcode = trap_current_trapcode;
			_trappower = trap_current_trappower;
			_mask = trap_current_mask;
			table.insert(bags_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="trap", detected=false, inspected=false, opened=false, locked=true, locktype=0, lockcode=999999999, dir=0, traped = true, inspected = false, trapcode=_trapcode, trapmodel=_traptype, trappower = _trappower, img=trap_img});
		elseif special_objects_status == "cr" then
			table.insert(bags_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="crystals",charged = true, power = 25, opened=false, locked=false, img=crystals_img});
		elseif special_objects_status == "th"  then
			table.insert(bags_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y,typ="trashheap", condition_lvl=1,condition_num=5, opened=false, locked=false, img=trashheap_img});
		elseif special_objects_status == "sp" then
			table.insert(bags_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y, typ="scullpile", condition_lvl=1,condition_num=5, opened=false, locked=false, img=scullpile_img});
		elseif special_objects_status == "bg" then
			table.insert(bags_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y, typ="bag", opened=false, locked=false, img=bag_img});
		elseif special_objects_status == "bx" then
			table.insert(bags_list,{x=cursor_world_x,y=cursor_world_y,xi=cursor_world_x,yi=cursor_world_y, typ="box", opened=false, locked=false, img=box_img});
		end;
	end;
end;

function findBagOrObject(x,y)
	for i=1,#bags_list do
		if (bags_list[i].x == x and bags_list[i].y == y) or (bags_list[i].x == xi and bags_list[i].yi == y) then
			table.remove(bags_list,i);
		end;
	end;
	for i=1,#objects_list do
		if (objects_list[i].x == x and objects_list[i].y == y) or (objects_list[i].x == xi and objects_list[i].yi == y) then
			table.remove(objects_list,i);
		end;
	end;
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
end;


function flood_submap ()
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
		submap[i]={};
		for z=1, map_h do
			if global.randomize_hexes == -1 and global.copy == -1 then
				submap[i][z]= current_hex_type+row_status*10;
			elseif global.randomize_hexes == 1 and global.copy == -1 then
				local _rnd = math.random(0,math.min(global.rnd_value-1,200 - current_hex_type+row_status*10));
				submap[i][z]= current_hex_type+row_status*10+_rnd;
			elseif global.copy == 1 and #global.copied > 0 then
				local _tmp_array = global.copied;
				if global.randomize_hexes == 1 then
					_tmp_array = randomizeArray(global.copied);
				end;
				submap[i][z] = _tmp_array[1];--lala
			end;
		end;
	end;
	--array_of_map();
end;

function draw_cursor ()
	if (mX < global.screenWidth-274 and mY < global.screenHeight-150) and (editor_status == "hexes" or editor_status == "harvest" or editor_status == "buildings" or editor_status == "homelands" or editor_status == "objects") then
		if not hex_mouse_visible then
			love.mouse.setVisible(false);
		else
			love.mouse.setVisible(true);
		end;
	elseif mX >= global.screenWidth-274 or mY >= global.screenHeight-150 then
		love.mouse.setVisible(true);
	end;
	if cursor_world_x>0 and cursor_world_x<map_w-map_limit_w  and cursor_world_y>0 and cursor_world_y<map_h-map_limit_h and mX < global.screenWidth-274 and mY < global.screenHeight-150 and editor_status ~= "background" then
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
	
	if mX < global.screenWidth-274 and editor_status == "buildings" then
		drawHex(cursor_world_x,cursor_world_y,tile_cursor_empty);
		local hexes = "";
		if cursor_world_y/2 == math.ceil(cursor_world_y/2) then
			hexes = "hexes_ev";
		else
			hexes = "hexes_ne";
		end;
		for i=1,#buildings_stats[current_building][hexes] do
			drawHex(cursor_world_x-buildings_stats[current_building][hexes][i][1],cursor_world_y-buildings_stats[current_building][hexes][i][2],tile_cursor_empty);
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
	 .. "\r\n" .. "submap=" .. Tserial.pack(submap, true, false)
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
	 .. "\r\n" .. "bags_table=" .. Tserial.pack(bags_table, true, false)
	 .. "\r\n" .. "objects_table=" .. Tserial.pack(objects_table, true, false)
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
	uibuttons[1]:SetHeight(30);
	uibuttons[1]:SetWidth(80);
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
	
	uibuttons[6] = loveframes.Create("button")
	uibuttons[6]:SetPos(40,global.screenHeight-90);
	uibuttons[6]:SetHeight(30);
	uibuttons[6]:SetWidth(80);
	uibuttons[6]:SetText("s/h hexes");
	uibuttons[6].OnClick = function(object)
		hexes_status=-1*hexes_status;
	end;
	
	uibuttons[8] = loveframes.Create("button")
	uibuttons[8]:SetPos(40,global.screenHeight-60);
	uibuttons[8]:SetHeight(30);
	uibuttons[8]:SetWidth(80);
	uibuttons[8]:SetText("inv_hexes");
	uibuttons[8].OnClick = function(object)
		if show_invisible == true then
			show_invisible = false;
		else
			show_invisible = true;
		end;
	end;
	
	---
	
	uibuttons[22] = loveframes.Create("button")
	uibuttons[22]:SetPos(120,global.screenHeight-120);
	uibuttons[22]:SetHeight(30);
	uibuttons[22]:SetWidth(80);
	uibuttons[22]:SetText("subhex");
	uibuttons[22].OnClick = function(object)
		loveframes.util.RemoveAll();
		editor_status = "subhexes";
		drawUIButtons();
		draw_buttons ();
	end;
	
	uibuttons[23] = loveframes.Create("button")
	uibuttons[23]:SetPos(120,global.screenHeight-90);
	uibuttons[23]:SetHeight(30);
	uibuttons[23]:SetWidth(80);
	uibuttons[23]:SetText("s/h shubhex");
	uibuttons[23].OnClick = function(object)
		global.subhex = -1*global.subhex;
	end;
	
	uibuttons[21] = loveframes.Create("button")
	uibuttons[21]:SetPos(120,global.screenHeight-60);
	uibuttons[21]:SetHeight(30);
	uibuttons[21]:SetWidth(80);
	uibuttons[21]:SetText("areas");
	uibuttons[21].OnClick = function(object)
		editor_status = "homelands";
		loveframes.util.RemoveAll();
		drawUIButtons();
		love.mouse.setVisible(false);
		draw_homelands_buttons();
	end;
	
	---
	
	uibuttons[3] = loveframes.Create("button")
	uibuttons[3]:SetPos(200,global.screenHeight-120);
	uibuttons[3]:SetHeight(30);
	uibuttons[3]:SetWidth(80);
	uibuttons[3]:SetText("harvest");
	uibuttons[3].OnClick = function(object)
		checkHerbs();
		editor_status="harvest"
		loveframes.util.RemoveAll();
		drawUIButtons();
		love.mouse.setVisible(false);
		draw_harvest_buttons();
	end;
	
	uibuttons[5] = loveframes.Create("button")
	uibuttons[5]:SetPos(200,global.screenHeight-90);
	uibuttons[5]:SetHeight(30);
	uibuttons[5]:SetWidth(80);
	uibuttons[5]:SetText("s/h harvest");
	uibuttons[5].OnClick = function(object)
		global.show_harvest = -1*global.show_harvest;
	end;

	--
	
	uibuttons[26] = loveframes.Create("button")
	uibuttons[26]:SetPos(280,global.screenHeight-120);
	uibuttons[26]:SetHeight(30);
	uibuttons[26]:SetWidth(80);
	uibuttons[26]:SetText("decals");
	uibuttons[26].OnClick = function(object)
		checkHerbs();
		editor_status="decals"
		loveframes.util.RemoveAll();
		drawUIButtons();
		love.mouse.setVisible(false);
		draw_harvest_buttons();
	end;
	
	uibuttons[27] = loveframes.Create("button")
	uibuttons[27]:SetPos(280,global.screenHeight-90);
	uibuttons[27]:SetHeight(30);
	uibuttons[27]:SetWidth(80);
	uibuttons[27]:SetText("s/h decals");
	uibuttons[27].OnClick = function(object)
		global.show_decals = -1*global.show_decals;
	end;
	
	--
	
	uibuttons[24] = loveframes.Create("button")
	uibuttons[24]:SetPos(360,global.screenHeight-120);
	uibuttons[24]:SetHeight(30);
	uibuttons[24]:SetWidth(80);
	uibuttons[24]:SetText("objects");
	uibuttons[24].OnClick = function(object)
		editor_status = "objects";
		loveframes.util.RemoveAll();
		drawUIButtons();
		draw_buttons();
	end;
	
	uibuttons[2] = loveframes.Create("button")
	uibuttons[2]:SetPos(360,global.screenHeight-90);
	uibuttons[2]:SetHeight(30);
	uibuttons[2]:SetWidth(80);
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
	
	uibuttons[7] = loveframes.Create("button")
	uibuttons[7]:SetPos(360,global.screenHeight-60);
	uibuttons[7]:SetHeight(30);
	uibuttons[7]:SetWidth(80);
	uibuttons[7]:SetText("s/h objecys");
	uibuttons[7].OnClick = function(object)
		object_status=-1*object_status;
	end;

	--
	
	uibuttons[17] = loveframes.Create("button")
	uibuttons[17]:SetPos(440,global.screenHeight-120);
	uibuttons[17]:SetHeight(30);
	uibuttons[17]:SetWidth(80);
	uibuttons[17]:SetText("flood_map");
	uibuttons[17].OnClick = function(object)
		if editor_status == "hexes" then
			flood_map();
		elseif editor_status == "subhexes" then
			flood_submap();
		end;
	end;
	
	uibuttons[18] = loveframes.Create("button")
	uibuttons[18]:SetPos(440,global.screenHeight-90);
	uibuttons[18]:SetHeight(30);
	uibuttons[18]:SetWidth(80);
	uibuttons[18]:SetText("generate");
	uibuttons[18].OnClick = function(object)
		global.moles = 6;
		global.digger = -1*global.digger;
	end;
	
	--
	
	uibuttons[19] = loveframes.Create("button")
	uibuttons[19]:SetPos(520,global.screenHeight-120);
	uibuttons[19]:SetHeight(30);
	uibuttons[19]:SetWidth(80);
	uibuttons[19]:SetText("randomize");
	uibuttons[19].OnClick = function(object)
		global.randomize_hexes = global.randomize_hexes*-1;
	end;
	
	uibuttons[20] = loveframes.Create("button")
	uibuttons[20]:SetPos(520,global.screenHeight-90);
	uibuttons[20]:SetHeight(30);
	uibuttons[20]:SetWidth(80);
	uibuttons[20]:SetText("copy");
	uibuttons[20].OnClick = function(object)
		global.copy = -1*global.copy;
	end;
	
	--
	
	uibuttons[4] = loveframes.Create("button")
	uibuttons[4]:SetPos(600,global.screenHeight-120);
	uibuttons[4]:SetHeight(30);
	uibuttons[4]:SetWidth(80);
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

	uibuttons[11] = loveframes.Create("button")
	uibuttons[11]:SetPos(600,global.screenHeight-90);
	uibuttons[11]:SetHeight(30);
	uibuttons[11]:SetWidth(80);
	uibuttons[11]:SetText("flood_back");
	uibuttons[11].OnClick = function(object)
		flood_back();
	end;
	
	uibuttons[12] = loveframes.Create("button")
	uibuttons[12]:SetPos(600,global.screenHeight-60);
	uibuttons[12]:SetHeight(30);
	uibuttons[12]:SetWidth(80);
	uibuttons[12]:SetText("flood_back_alt");
	uibuttons[12].OnClick = function(object)
		flood_back_alt();
	end;
	
	---
	
	uibuttons[10] = loveframes.Create("button")
	uibuttons[10]:SetPos(680,global.screenHeight-120);
	uibuttons[10]:SetHeight(30);
	uibuttons[10]:SetWidth(80);
	uibuttons[10]:SetText("cursor");
	uibuttons[10].OnClick = function(object)
		if not hex_mouse_visible then
			hex_mouse_visible = true;
		else
			hex_mouse_visible = false;
		end;
	end;
	
	uibuttons[9] = loveframes.Create("button")
	uibuttons[9]:SetPos(680,global.screenHeight-90);
	uibuttons[9]:SetHeight(30);
	uibuttons[9]:SetWidth(80);
	uibuttons[9]:SetText("hex_numbers");
	uibuttons[9].OnClick = function(object)
		if drawnumbers then
			drawnumbers  = false;
		else
			drawnumbers  = true;
		end;
	end;
	
	uibuttons[19] = loveframes.Create("button")
	uibuttons[19]:SetPos(680,global.screenHeight-60);
	uibuttons[19]:SetHeight(30);
	uibuttons[19]:SetWidth(80);
	uibuttons[19]:SetText("minimap");
	uibuttons[19].OnClick = function(object)
		editor_status = "minimap";
	end;
	
	---
	
	uibuttons[14] = loveframes.Create("button")
	uibuttons[14]:SetPos(760,global.screenHeight-120);
	uibuttons[14]:SetHeight(30);
	uibuttons[14]:SetWidth(80);
	uibuttons[14]:SetText("reload");
	uibuttons[14].OnClick = function(object)
		load();
	end;
	--[[
	uibuttons[15] = loveframes.Create("button")
	uibuttons[15]:SetPos(740,global.screenHeight-60);
	uibuttons[15]:SetHeight(30);
	uibuttons[15]:SetWidth(80);
	uibuttons[15]:SetText("help");
	uibuttons[15].OnClick = function(object)
		editor_status="help";
		loveframes.util.RemoveAll();
		drawUIButtons()
	end;
	]]
	uibuttons[16] = loveframes.Create("button")
	uibuttons[16]:SetPos(760,global.screenHeight-90);
	uibuttons[16]:SetHeight(30);
	uibuttons[16]:SetWidth(80);
	uibuttons[16]:SetText("next_lv");
	uibuttons[16].OnClick = function(object)
		switchLevel();
	end;
		
	uibuttons[20] = loveframes.Create("button")
	uibuttons[20]:SetPos(760,global.screenHeight-60);
	uibuttons[20]:SetHeight(30);
	uibuttons[20]:SetWidth(80);
	uibuttons[20]:SetText("new_lv");
	uibuttons[20].OnClick = function(object)
		newLevel();
	end;
	
	
	uibuttons[13] = loveframes.Create("button")
	uibuttons[13]:SetPos(840,global.screenHeight-120);
	uibuttons[13]:SetHeight(30);
	uibuttons[13]:SetWidth(80);
	uibuttons[13]:SetText("save");
	uibuttons[13].OnClick = function(object)
		save();
	end;
	
end;

function startDiggers(x,y,count,flag) --FIXME submap only
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
	draw_submap();
	draw_map();
	if find_the_path==1 then
		path_finding(chars_mobs_npcs[current_mob][4],chars_mobs_npcs[current_mob][5]);
	end;
	draw_cursor();
	if drawnumbers and (editor_status == "hexes" or editor_status == "subhexes" or editor_status == "buildings") then
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
		love.graphics.print("[LCTRL]+[X] - hide/view (sub)hexes (показать/спрятать (суб)гексы)", 40,210);
		love.graphics.print("[LCTRL]+[O] - hide/view objects (показать/спрятать объекты)", 40,230);
		love.graphics.print("[LCTRL]+[V] - hide/view not rendering hexes (показать/спрятать невидимые гексы)", 40,250);
		love.graphics.print("[LCTRL]+[Z] - randomize hexes (случайные гексы)", 40,270);
		love.graphics.print("[LCTRL]+[S] - save results (сохранить результаты)", 40,290);
		love.graphics.print("[LCTRL]+[L] - reload map (перезагрузить уровень)", 40,310);
		love.graphics.print("[LCTRL]+[M] - show hexes coordinates of hexes (показать координаты гекс)", 40,330);
		love.graphics.print("[LCTRL]+[I] - mouse cursor toggle in hex mode (отображение курсора мыши в режиме гекс)", 40,350);
		love.graphics.print("[LCTRL]+[M] - show minimap (показать мини-карту)", 40,370);
		love.graphics.print("[LCTRL]+[E] - fill background with first tile/заполнить подложку первым тайлом", 40,390);
		love.graphics.print("[Up],[Down],[Left],[Right] - scroll map (прокрутка карты)", 40,410);
		love.graphics.print("WheelUp/WheelDown - change brush (сменить кисть)", 40,430);
		love.graphics.print("[LCTRL]+[R] - load next level (загрузить следующий уровень)", 40,450);
		love.graphics.print("[LCTRL]+[G] - cave autogeneration, needs a click (автогенерация пещеры, работает по клику)", 40,470);
		love.graphics.print("[LCTRL]+[C] - copy mode, RMB for copy, LMB for PASTE (режим копирования, ПКМ для копирования, ЛКМ для вставки)", 40,490);
		love.graphics.print("can be used with randomize hexes (можно использовать со случайными гексами)", 40,510);
		love.graphics.print("[LCTRL]+WheelUp/WheelDown - quantity of randomizing hexes (количество рандомизируемых гекс)", 40,530);
		love.graphics.print("[LCTRL]+[P] - mob areas (территории мобов)", 40,550);
		love.graphics.print("[LCTRL]+[U] - sub-hexmode (режим правки подкарты)", 40,570);
		love.graphics.print("[LCTRL]+[T] - special objects (специальные объекты) --under construction (в разработке)", 40,590);
		love.graphics.print("[LCTRL]+[D] - decals (декали) --under construction (в разработке)", 40,610);
		love.graphics.print("[ESC] - hex mode (режим правки гексов)", 40,630);
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
			love.graphics.draw(media.images.harvest,harvest_ttx[current_herb].sprite,global.screenWidth-160,500);
			love.graphics.print("current: ",global.screenWidth-200, 600);
			love.graphics.print("chance : ",global.screenWidth-200, 630);
			love.graphics.print("pool   : ",global.screenWidth-200, 660);
		if insideMap(cursor_world_x,cursor_world_y) then
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
	
	if editor_status == "objects" then
		local addy = 300;
		local addx = 150;
		
		local sob_images = {
		ob=obelisk_img,
		al=altar_img,
		pd=pedestal_img,
		cm=competition_img,
		pt=portal_img,
		
		wl=well_img,
		br=barrel_img[barrel_current_type],
		cl=cauldron_img[cauldron_current_type],
		cn=nil,
		tr=trap_img,
		
		bg=bag_img,
		ch=chest_img[chest_current_rotation],
		cr=crystals_img,
		th=trashheap_img,
		sp=scullpile_img,
		bx=box_img,
		
		wc=well_img,
		};
	
		if special_objects_status and  special_objects_status ~= 0 and sob_images[special_objects_status] then
			love.graphics.draw(media.images.tmpobjs, sob_images[special_objects_status],global.screenWidth-addx, global.screenHeight-addy);
		end;
		love.graphics.setColor(0, 0, 0,255);
		if special_objects_status == "pd" then	
			love.graphics.print(pedestal_current_buff_name,global.screenWidth-120, global.screenHeight-100);
		end;
		
		if special_objects_status == "cm" then
			love.graphics.print(competition_stats[competition_current_stat_index],global.screenWidth-120, global.screenHeight-100);		
		end;
		
		if special_objects_status == "ch" then
			local text = "rotation: " .. chest_current_rotation;
			love.graphics.print(text,global.screenWidth-100, global.screenHeight-160);
			love.graphics.print(chest_current_locktype_name,global.screenWidth-100, global.screenHeight-140);	
			love.graphics.print(chest_current_traptype_name,global.screenWidth-100, global.screenHeight-100);		
		end;
		
		if special_objects_status == "wl" then
			love.graphics.print(well_current_type_name,global.screenWidth-140, global.screenHeight-140);
			if well_current_type_name == "magical add" then
				love.graphics.print(well_current_addtype_name,global.screenWidth-140, global.screenHeight-120);
			elseif well_current_type_name == "magical stat" then
				love.graphics.print(well_current_stat_name,global.screenWidth-140, global.screenHeight-120);
			elseif well_current_type_name == "magical buff" then
				love.graphics.print(well_current_buff_name,global.screenWidth-140, global.screenHeight-120);
			elseif well_current_type_name == "magical cure" then
				love.graphics.print(well_current_condition_name,global.screenWidth-140, global.screenHeight-120);
			end;		
		end;
		
		if special_objects_status == "br" then
			love.graphics.print(barrel_current_name,global.screenWidth-120, global.screenHeight-120);		
		end;
		
		if special_objects_status == "cl" then
			love.graphics.print(cauldron_current_name,global.screenWidth-120, global.screenHeight-120);		
		end;
		
		love.graphics.setColor(255, 255, 255,255);
	end;
	
	if editor_status == "minimap" then
		draw_papermap ();
	end;
	if editor_status == "saved" then
		local _txt = levelname .. " SAVED!"
		love.graphics.print(_txt, global.screenWidth/2-300,global.screenHeight/2);
    end
    if editor_status == "hexes" or editor_status == "buildings" or editor_status == "harvest" or editor_status == "subhexes" or editor_status == "objects" or editor_status == "areas" or editor_status == "decals" then
    	love.graphics.print(cursor_world_x, 10, 10);
		love.graphics.print("x", 35, 10);
		love.graphics.print(cursor_world_y, 55, 10)
	end;

	if global.randomize_hexes == 1 then 
		local _str = "value:" .. global.rnd_value;
		love.graphics.print(_str,740, global.screenHeight-140);
		love.graphics.print("rnd mode",655, global.screenHeight-140);
	end;
	
	if global.digger == 1 then
		local _str = "moles:" .. global.moles;
		love.graphics.print(_str,500, global.screenHeight-140);
	end;
	
	if global.copy == 1 then 
		love.graphics.print("copy mode",565, global.screenHeight-140);
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
