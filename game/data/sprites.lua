sprites = {};
function sprites.load()
	tiles_items={};
	for i=1,#inventory_ttx do
		imgtilex = inventory_ttx[i].x*32;
		imgtiley = inventory_ttx[i].y*32;
		imgtilew = inventory_ttx[i].w*32;
		imgtileh = inventory_ttx[i].h*32;
		tiles_items[i] = love.graphics.newQuad(imgtilex, imgtiley, imgtilew,imgtileh, media.images.items1:getWidth(), media.images.items1:getHeight());
	end
	mindgame_icons = {};
	for i=1,8 do
		for h=1,8 do
			local index = (i-1)*8+h;
			local x = (i-1)*64;
			local y = (h-1)*64;
			mindgame_icons[index] = love.graphics.newQuad(x, y, 64,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
		end;
	end;
	
	back_size=256;
	back_count=8;
	bgmap_w=#bgmap;
	bgmap_h=#bgmap[1];
	
	background_={}

	for i=1,back_count do
		for h=1,back_count do
			background_[(i-1)*back_count+h] = love.graphics.newQuad((h-1)*back_size, (i-1)*back_size, back_size, back_size, back_size*back_count, back_size*back_count);
		end;
	end;
	
	special_objects_animations = {
		competition = "animation_competition";
		};
	
	gold_icons={}
	gold_icons[1] = love.graphics.newQuad(305, 0, 128,64, media.images.ui:getWidth(), media.images.ui:getHeight());
	gold_icons[2] = love.graphics.newQuad(305, 64, 96,32, media.images.ui:getWidth(), media.images.ui:getHeight());
	gold_icons[3] = love.graphics.newQuad(305, 104, 64,32, media.images.ui:getWidth(), media.images.ui:getHeight());
	gold_icons[4] = love.graphics.newQuad(305, 140, 32,32, media.images.ui:getWidth(), media.images.ui:getHeight());
	gold_icons[5] = love.graphics.newQuad(305,177,32,12, media.images.ui:getWidth(), media.images.ui:getHeight());

	mindgame_pain_icon = love.graphics.newQuad(64*6, 64*5, 64,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_blood_icon = love.graphics.newQuad(64*1, 64*5, 64,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_injur_icon = love.graphics.newQuad(64*7, 64*5, 64,128, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_death_icon = love.graphics.newQuad(64*5, 65*5, 64,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_hit_icon = love.graphics.newQuad(64*6, 64*5, 64,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_ear_icon = love.graphics.newQuad(64*2, 64*5, 64,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_finger_icon = love.graphics.newQuad(64*3, 64*5, 64,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_eye_icon = love.graphics.newQuad(64*4, 64*5, 64,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_barrier_icon = love.graphics.newQuad(0, 64*5, 64,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_connection_icon = love.graphics.newQuad(0, 64*3, 128,128, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_hypno_icon = love.graphics.newQuad(64*2, 64*3, 128,128, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_secret_icon = love.graphics.newQuad(64*4, 64*3, 128,128, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_joke_icon = love.graphics.newQuad(64*6, 64*3, 192,128, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_hangman_icon = love.graphics.newQuad(64*9, 64*3, 128,128, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_sad_icon = love.graphics.newQuad(64*11, 64*3, 128,128, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_troll_icon = love.graphics.newQuad(64*13, 64*3, 128,128, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_affront_icon = love.graphics.newQuad(64*8, 64*5, 128,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	mindgame_music_icon = love.graphics.newQuad(64*15, 64*3, 64,64, media.images.mindgame_icons_img:getWidth(), media.images.mindgame_icons_img:getHeight());
	
	mindstar = love.graphics.newQuad(990,730, 32, 32, media.images.ui:getWidth(), media.images.ui:getHeight());
	papermap_pin = love.graphics.newQuad(230,870, 22, 41, media.images.ui:getWidth(), media.images.ui:getHeight());
	hp_indic = love.graphics.newQuad(0, 0, 7,100, media.images.ui:getWidth(), media.images.ui:getHeight());
	sp_indic = love.graphics.newQuad(7, 0, 7,100, media.images.ui:getWidth(), media.images.ui:getHeight());
	st_indic = love.graphics.newQuad(14, 0, 7,100, media.images.ui:getWidth(), media.images.ui:getHeight());
	rt_indic = love.graphics.newQuad(22, 0, 7,100, media.images.ui:getWidth(), media.images.ui:getHeight());
	bl_indic = love.graphics.newQuad(29, 0, 7,100, media.images.ui:getWidth(), media.images.ui:getHeight());
	wt_indic = love.graphics.newQuad(38, 0, 7,100, media.images.ui:getWidth(), media.images.ui:getHeight());
	ps_indic = love.graphics.newQuad(47, 0, 7,100, media.images.ui:getWidth(), media.images.ui:getHeight());
	hide_icon = love.graphics.newQuad(710,750,64,64, media.images.ui:getWidth(), media.images.ui:getHeight());
	handblock_icon = love.graphics.newQuad(774,750,64,64, media.images.ui:getWidth(), media.images.ui:getHeight());
	block_icon = love.graphics.newQuad(838,750,64,64, media.images.ui:getWidth(), media.images.ui:getHeight());
	dodge_icon = love.graphics.newQuad(902,750,64,64, media.images.ui:getWidth(), media.images.ui:getHeight());
	parry_icon = love.graphics.newQuad(966,750,64,64, media.images.ui:getWidth(), media.images.ui:getHeight());
	swords_indic = {love.graphics.newQuad(0, 240, 120,222, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(120, 240, 140,225, media.images.ui:getWidth(), media.images.ui:getHeight())};
	pass_turn = love.graphics.newQuad(225, 0, 80, 128, media.images.ui:getWidth(), media.images.ui:getHeight());
	system = love.graphics.newQuad(200, 140, 35, 38, media.images.ui:getWidth(), media.images.ui:getHeight());
	bag_inv = love.graphics.newQuad(442, 0, 115, 115, media.images.ui:getWidth(), media.images.ui:getHeight());
	current_char_img = love.graphics.newQuad(0, 100, 30, 20, media.images.ui:getWidth(), media.images.ui:getHeight());
	spellbook_icon = love.graphics.newQuad(100, 0, 125,128, media.images.ui:getWidth(), media.images.ui:getHeight());
	questbook_icon = love.graphics.newQuad(0, 602, 120,148, media.images.ui:getWidth(), media.images.ui:getHeight());
	warbook_icon = love.graphics.newQuad(312, 704, 110,156, media.images.ui:getWidth(), media.images.ui:getHeight());
	retorta_icon = love.graphics.newQuad(100, 128, 96,110, media.images.ui:getWidth(), media.images.ui:getHeight());
	picklock_icon = love.graphics.newQuad(450, 111, 126, 35, media.images.ui:getWidth(), media.images.ui:getHeight());
	map_icon = love.graphics.newQuad(250, 708, 57, 143, media.images.ui:getWidth(), media.images.ui:getHeight());
	gnomon_icon = love.graphics.newQuad(0, 750, 120, 110, media.images.ui:getWidth(), media.images.ui:getHeight());
	veksel_icon = love.graphics.newQuad(0, 860, 125, 90, media.images.ui:getWidth(), media.images.ui:getHeight());
	mask_icon = love.graphics.newQuad(128, 950, 252, 27, media.images.ui:getWidth(), media.images.ui:getHeight());
	--n_icon = love.graphics.newQuad(120, 610, 35, 70, media.images.ui:getWidth(), media.images.ui:getHeight());
	--eye_icon = love.graphics.newQuad(215, 627, 50, 50, media.images.ui:getWidth(), media.images.ui:getHeight());
	--boot_icon = love.graphics.newQuad(155, 610, 60, 70, media.images.ui:getWidth(), media.images.ui:getHeight());
	spyglass_icon_1 = love.graphics.newQuad(750, 880, 30, 145, media.images.ui:getWidth(), media.images.ui:getHeight());
	spyglass_icon_2 = love.graphics.newQuad(780, 880, 30, 145, media.images.ui:getWidth(), media.images.ui:getHeight());
	boot_icon_1 = love.graphics.newQuad(810, 890, 110, 140, media.images.ui:getWidth(), media.images.ui:getHeight());
	boot_icon_2 = love.graphics.newQuad(916, 890, 110, 140, media.images.ui:getWidth(), media.images.ui:getHeight());
	glove_icon_1 = love.graphics.newQuad(577, 830, 65, 61, media.images.ui:getWidth(), media.images.ui:getHeight());
	glove_icon_2 = love.graphics.newQuad(642, 875, 92, 140, media.images.ui:getWidth(), media.images.ui:getHeight());
	anvil_icon = love.graphics.newQuad(120,870,106,76, media.images.ui:getWidth(), media.images.ui:getHeight());
	bin_icon = love.graphics.newQuad(120,700,112,160, media.images.ui:getWidth(), media.images.ui:getHeight());
	logpaper = love.graphics.newQuad(0, 465, 348,133, media.images.ui:getWidth(), media.images.ui:getHeight());
	--tip = love.graphics.newQuad(360, 250, 240,360, media.images.ui:getWidth(), media.images.ui:getHeight());
	--tip_sub = love.graphics.newQuad(778, 769, 240,107, media.images.ui:getWidth(), media.images.ui:getHeight());
	btn_plus = love.graphics.newQuad(14, 1010, 14,14, media.images.ui:getWidth(), media.images.ui:getHeight());
	btn_minus = love.graphics.newQuad(0, 1010, 14,14, media.images.ui:getWidth(), media.images.ui:getHeight());
	btn_apply = love.graphics.newQuad(0, 980, 90,30, media.images.ui:getWidth(), media.images.ui:getHeight());
	bag_img = love.graphics.newQuad(0, 0, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	trap_img = love.graphics.newQuad(224, 0, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());

	chest_img = {};
	for i=1,4 do
		chest_img[i] = {};
		for h=1,5 do
			chest_img[i][h]=love.graphics.newQuad(20*32+(h-1)*64, (i-1)*64, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
		end;
	end;
	
	track_img = {
	{love.graphics.newQuad(0, 96, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(32, 96, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(64, 96, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(96, 96, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(128, 96, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(160, 96, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(192, 96, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(224, 96, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(256, 96, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(288, 96, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),},
		
	{love.graphics.newQuad(0, 128, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(32, 128, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(64, 128, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(96, 128, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(128, 128, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(160, 128, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(192, 128, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(224, 128, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(256, 128, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(288, 128, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),},
	
	{love.graphics.newQuad(0, 160, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(32, 160, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(64, 160, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(96, 160, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(128, 160, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(160, 160, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(192, 160, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(224, 160, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(256, 160, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(288, 160, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),},
	
	{love.graphics.newQuad(0, 192, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(32, 192, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(64, 192, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(96, 192, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(128, 192, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(160, 192, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(192, 192, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(224, 192, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(256, 192, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(288, 192, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),},
	
	{love.graphics.newQuad(0, 224, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(32, 224, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(64, 224, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(96, 224, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(128, 224, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(160, 224, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(192, 224, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(224, 224, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(256, 224, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(288, 224, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),},
	
	{love.graphics.newQuad(0, 256, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(32, 256, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(64, 256, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(96, 256, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(128, 256, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(160, 256, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(192, 256, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(224, 256, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(256, 256, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),
	love.graphics.newQuad(288, 256, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()),},
	};
	
	barrel_img = {};
	for i=1,13 do
		local _x = (i-1)*64;
		table.insert(barrel_img,love.graphics.newQuad(_x, 320, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()));
	end;
	
	cauldron_img = {};
	for i=1,13 do
		local _x = (i-1)*64;
		table.insert(cauldron_img,love.graphics.newQuad(_x, 384, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()));
	end;
--FIXME! lveditor has diffirent door sprites!
	door_img = {};
	for i=1,4 do
		local _x = (i-1)*64;
		table.insert(door_img,love.graphics.newQuad(_x, 448, 64,96, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight()));
	end;

	--[[
	door_img = {};
	for i=1,4 do
		door_img[i] = {};
		for h=1,5 do
			local _x = (h-1)*64;
			door_img[i][h]=love.graphics.newQuad(_x, 448, 64,96, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
		end;
	end;
	]]
	
	--[[
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
	]]
	--specialobjects
	obelisk_img = love.graphics.newQuad(0, 17*32, 64,128, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	altar_img = love.graphics.newQuad(64, 17*32, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	box_img = love.graphics.newQuad(128, 17*32, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	competition_img = love.graphics.newQuad(2*32, 21*32, 64,96, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	pedestal_img = love.graphics.newQuad(0, 21*32, 64,96, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	portal_img = love.graphics.newQuad(32*5, 20*32, 64,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	well_img = love.graphics.newQuad(10*32, 21*32, 128,128, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	trashheap_img = love.graphics.newQuad(32*5, 18*32, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	scullpile_img = love.graphics.newQuad(32*11, 17*32, 64,64, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	crystals_img = love.graphics.newQuad(4*32, 21*32, 64,96, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	fountain_img = love.graphics.newQuad(6*32, 21*32, 128,128, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	fake_img  = love.graphics.newQuad(31*32, 31*32, 32,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	
	competition =  anim8.newGrid(50, 150, media.images.animatedobjects_hex:getWidth(), media.images.animatedobjects_hex:getHeight(),0,0,0);
	animation_competition = anim8.newAnimation(competition("1-6",1), 0.05);
	
	lock_2_base = love.graphics.newQuad(600, 0, 200, 88, media.images.ui:getWidth(), media.images.ui:getHeight())
	lock_2_closed_elements = {};
	lock_2_closed_elements[6] = {
	love.graphics.newQuad(864, 15, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(848, 15, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(832, 15, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(816, 15, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(800, 15, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	};
	lock_2_closed_elements[1] = {
	love.graphics.newQuad(864, 70, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(848, 70, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(832, 70, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(816, 70, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(800, 70, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	};
	lock_2_closed_elements[2] = {
	love.graphics.newQuad(864, 125, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(848, 125, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(832, 125, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(816, 125, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(800, 125, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	};
	lock_2_closed_elements[3] = {
	love.graphics.newQuad(864, 180, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(848, 180, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(832, 180, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(816, 180, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(800, 180, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	};
	lock_2_closed_elements[4] = {
	love.graphics.newQuad(864, 235, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(848, 235, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(832, 235, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(816, 235, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(800, 235, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	};
	lock_2_closed_elements[5] = {
	love.graphics.newQuad(864, 290, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(848, 290, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(832, 290, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(816, 290, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(800, 290, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	};
	lock_2_opened_elements = {
	love.graphics.newQuad(944, 15, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(928, 15, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(912, 15, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(896, 15, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(880, 15, 16, 54, media.images.ui:getWidth(), media.images.ui:getHeight()),
	};
	lock_3_base = love.graphics.newQuad(600, 88, 200, 88, media.images.ui:getWidth(), media.images.ui:getHeight())
	lock_3_elements = {
	love.graphics.newQuad(600, 176, 12, 56, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(613, 176, 12, 56, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(626, 176, 12, 56, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(639, 176, 12, 56, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(652, 176, 12, 56, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(665, 176, 12, 56, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(678, 176, 12, 56, media.images.ui:getWidth(), media.images.ui:getHeight()),
	love.graphics.newQuad(691, 176, 12, 56, media.images.ui:getWidth(), media.images.ui:getHeight()),
	};
	locktrap_trigger = love.graphics.newQuad(683,243,13,13, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	trap_elements = {
	love.graphics.newQuad(625,345,25,25, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	love.graphics.newQuad(650,345,25,25, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	love.graphics.newQuad(675,345,25,25, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	love.graphics.newQuad(700,345,25,25, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	love.graphics.newQuad(725,345,25,25, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	love.graphics.newQuad(750,345,25,25, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	love.graphics.newQuad(775,345,25,25, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	love.graphics.newQuad(800,345,25,25, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	love.graphics.newQuad(825,345,25,25, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	love.graphics.newQuad(600,345,25,25, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	};
	trap_typeofdamage = {
	firebomb=love.graphics.newQuad(660,430,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	poison=love.graphics.newQuad(724,430,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	spikes=love.graphics.newQuad(788,430,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	summon=love.graphics.newQuad(852,430,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	
	icecoffin=love.graphics.newQuad(660,494,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	acid=love.graphics.newQuad(724,494,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	arrows=love.graphics.newQuad(788,494,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	portal=love.graphics.newQuad(852,494,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	
	staticcharge=love.graphics.newQuad(660,560,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	bell=love.graphics.newQuad(724,560,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	sleep=love.graphics.newQuad(788,560,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	stone=love.graphics.newQuad(852,560,64,64, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	};
	blood_dec = love.graphics.newQuad(32, 0, 64,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	ash_dec = love.graphics.newQuad(96, 0, 64,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	keypart = love.graphics.newQuad(583, 0, 17,74, media.images.ui:getWidth(), media.images.ui:getHeight());
	eye = love.graphics.newQuad(160, 0, 64,32, media.images.tmpobjs:getWidth(), media.images.tmpobjs:getHeight());
	
	green_fishka = love.graphics.newQuad(0,125,60,125, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	--red_fishka = love.graphics.newQuad(60,125,60,125, media.images.ui:getWidth(), media.images.tmpobjs:getHeight());
	
	path={};
	tile_path={};
   
	objects={};
	for i=1,#objects_table do
		objects[i] =  love.graphics.newQuad(objects_table[i][1], objects_table[i][2], objects_table[i][3], objects_table[i][4], 1024, 1024);
	end;
	
    minimap_hexes = {};
    for ty=12,16 do
		for tx=11,13 do
			table.insert(minimap_hexes,love.graphics.newQuad(5+74*(tx-1), 5+42*(ty-1), tile_w, tile_h, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight()));
		end;
    end;
	cursor_q = love.graphics.newQuad(819, 5, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_flag = love.graphics.newQuad(893, 9, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_arrow = love.graphics.newQuad(745, 131, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_broken_arrow = love.graphics.newQuad(819, 131, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_empty = love.graphics.newQuad(745, 174, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_yellow = love.graphics.newQuad(745, 217, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_red = love.graphics.newQuad(819, 217, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_spot = love.graphics.newQuad(893, 217, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_hand = love.graphics.newQuad(745, 300, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_white = love.graphics.newQuad(745, 260, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_danger = love.graphics.newQuad(819, 260, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_way = {};
	cursor_way[1] = love.graphics.newQuad(745, 297, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_way[2] = love.graphics.newQuad(819, 297, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_way[3] = love.graphics.newQuad(893, 297, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_way[4] = love.graphics.newQuad(745, 340, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_way[5] = love.graphics.newQuad(819, 340, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	cursor_way[6] = love.graphics.newQuad(893, 340, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
  
	tile_grey=love.graphics.newQuad(893, 930, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	tile_black=love.graphics.newQuad(893, 971, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	tile_shadow=love.graphics.newQuad(893, 889, tile_w+2, tile_h+2, media.images.hex_ui:getWidth(),media.images.hex_ui:getHeight());
	
--landscape tiles  
	tile = {};
	for ty=1,48 do
		for tx=1,25 do
			tile[(ty-1)*25+tx] = love.graphics.newQuad(5+74*(tx-1), 5+42*(ty-1), tile_w, tile_h, media.images.hex:getWidth(), media.images.hex:getHeight())
		end;
	end;
	
	spellicons={};
	for i=1,14 do
		spellicons[i]={};
		spellicons[i][1] = love.graphics.newQuad(20, 20, 150,150, 733, 451);
		spellicons[i][2] = love.graphics.newQuad(200, 20, 150,150, 733, 451);
		spellicons[i][4] = love.graphics.newQuad(20, 150, 150,150, 733, 451);
		spellicons[i][3] = love.graphics.newQuad(200, 150, 150,150, 733, 451);
		spellicons[i][5] = love.graphics.newQuad(20, 280, 150,150, 733, 451);
		spellicons[i][6] = love.graphics.newQuad(200, 280, 150,150, 733, 451);
		spellicons[i][7] = love.graphics.newQuad(400, 20, 150,150, 733, 451);
		spellicons[i][8] = love.graphics.newQuad(580, 20, 150,150, 733, 451);
		spellicons[i][9] = love.graphics.newQuad(400, 150, 150,150, 733, 451);
		spellicons[i][10] = love.graphics.newQuad(580, 150, 150,150, 733, 451);
		spellicons[i][11] = love.graphics.newQuad(400, 280, 150,150, 733, 451);
		spellicons[i][12] = love.graphics.newQuad(580, 280, 150,150, 733, 451);

		page=page+1;
	end;
	
	mobfaces={};
	for i=1,10 do
		for h=1,10 do
			local tmpf=((h-1)*10+i);
			mobfaces[tmpf] = love.graphics.newQuad((i-1)*80, (h-1)*90, 80,90, 800, 900);
		end;
	end;
	
	npcfaces={};
	for i=1,10 do
		for h=1,10 do
			local tmpf=((h-1)*10+i);
			npcfaces[tmpf] = love.graphics.newQuad((i-1)*80, (h-1)*90, 80,90, 800, 900);
		end;
	end;
end;
