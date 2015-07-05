--game

local playingState = {}

function playingState.start(media)
	if not game_status then
		game_status = "comic"; --FIXME debug
	end;
	utils.printDebug("START!");
	playingState.load();
end;

function playingState.load()
	anim8 = require "lib.anim8"
	require "lib.postshader"
	require "lib.light"
	require "data.mobs_sprites"
	require "data.mobs_stats"
	require "data.effects"
	require "data.inventory"
	require "data.defaults"
	require "data.log"
	require "data.chats"
	require "data.magic"
	require "data.tricks"
	require "data.comics"
	require "data.books"
	require "data.messages"
	require "data.maps"
	require "data.gobelens"
	require "data.equipment_modifers"
	require "data.quests" -- if first start, working with a saved copy later
	require "data.harvest"
	require "data.buildings"
	require "data.mindmaps"
	require "data.particles"
	require "functions.damage"
	require "functions.boomareas"
	require "functions.draw"
	require "functions.helpers"
	require "functions.trace"
	require "functions.pathfinding"
	require "functions.mindgame"
	require "functions.ai"
	require "functions.mindresults"
	require "functions.calendar"
	require "data.jokes"
	require "data.secrets"
	require "data.nlp"
	require "data.affronts"
	require "data.threats"
	require "data.npc"
	require "data.sfx"
	require "data.triggers"
	--love.audio.stop(media.sounds.mainmenu, 0);
	
	--currentState = loadingState;
	--currentState.start(media, loadingFinished);
	--blurv = love.graphics.newShader(love.filesystem.read("shader/blurv.glsl"),1)
	--blurh = love.graphics.newShader(love.filesystem.read("shader/blurh.glsl"),1)
	--color2bw = love.graphics.newShader("shader/color2bw.glsl")

	lightWorld = love.light.newWorld();
	mainFont = love.graphics.newFont("fonts/DroidSans-Bold.ttf", 10);
	statFont = love.graphics.newFont("fonts/DroidSans-Bold.ttf", 14);
	tipFont = love.graphics.newFont("fonts/DroidSans-Bold.ttf", 12);
	--tipFont = love.graphics.newFont("fonts/HoMMFontCyr.ttf", 12);
	bigFont = love.graphics.newFont("fonts/DroidSans-Bold.ttf", 18);
	bookFont = love.graphics.newFont("fonts/Neocyr.ttf", 16);
	smallBookFont = love.graphics.newFont("fonts/Neocyr.ttf", 12);
	messFont = love.graphics.newFont("fonts/LC Chalk.ttf", 16);
	smallMessFont = love.graphics.newFont("fonts/LC Chalk.ttf", 12);
	heroesFont = love.graphics.newFont("fonts/HoMMFontCyr.ttf", 12);
	heroesLargeFont = love.graphics.newFont("fonts/HoMMFontCyr.ttf", 32);
	heroesSmallFont = love.graphics.newFont("fonts/HoMMSmallFontCyr.ttf", 12);
	erathiaFont = love.graphics.newFont("fonts/Erathia.ttf", 20);
	comicFont = love.graphics.newFont("fonts/HoMMFontCyr.ttf", 32);

	--global.use_walk_animation = true;
	--global.walk_animation_speed = 0.25;

	global.use_walk_animation = false;
	global.walk_animation_speed = 0.1;

	map_w = #map;
	map_h = #map[1];
	map_size=map_w*map_h;
	map_x = 0;
	map_y = 0;
	tile_w = 64;
	tile_h = 32;
	tile_hw = 32;
	tile_qh=tile_h/2;
	tile_34=tile_hw+tile_hw/2;
	global.screenWidth = love.graphics.getWidth();
	global.screenHeight = love.graphics.getHeight();
	map_display_w = math.ceil(global.screenWidth/tile_w)+1;
	map_display_h = math.ceil(global.screenHeight/tile_h*1.5)+1;
	tile_row_check=0;
	left_space=20;
	top_space=20;
	chars = 4;
	--inv_add_x = 92;
	--inv_add_y = 155;
	--inv_part2 = 734;


	inv_add_x = 92;
	inv_add_y = 155;
	inv_part2 = 734;

	inv_page = 1;

	current_comic = 1;
	page=1;

	--[[charfaces={};
	for i=1,12 do
		for h=1,12 do
			local tmpf=((h-1)*12+i);
			charfaces[tmpf] = love.graphics.newQuad((i-1)*80, (h-1)*90, 80,90, media.images.charfaces:getWidth(), media.images.charfaces:getHeight());
		end;
	end;]]
	--spelliconcoods={{180,108},{340,108},{340,238},{180,238},{180,368},{340,368},{550,108},{710,108},{550,238},{710,238},{550,368},{710,368},{550,368},{710,368}};

	holding_smth=0;

	sprites.load();
	mobs_sprites ();
	mobs_data();
	effects_data ();
	logstrings_load ();
	magic_tips_load ();
	comics_load();
	books_load ();
	maps_load ();
	gobelens_load ();
	msgs_load ();
	items_modifers_load ();
	jokes_load ();
	secrets_load ();
	nlps_load();
	affronts_load();
	threats_load();
	npc_load();
	calendar.calendar_data ();
	tricks_tips_load ();
	quests_load ();
	triggers_data ();

	fractions={
	party={party=0,greens=-100,bandidos=-100,vagrants = 0,merchants=0},
	greens={party=-100,greens=0,bandidos=0,vagrants = 0,merchants=0},
	bandidos={party=-100,greens=0,bandidos=0,vagrants = 0,merchants=0},
	vagrants={party=0,greens=0,bandidos=0,vagrants = 100,merchants=0},
	merchants={party=0,greens=0,bandidos=0,vagrants = 0,merchants=0},
	};

	mob_w=32
	mob_h=64

	hexes_to_sense={}

	irradiations={"dawn","day","afterglow", "twilight", "night","dungeon","firelight"};
	areaEffectsPriority = {"fire","ice","mud","acid","poison"};

	global.hang = false;
	global.damageflag = false; --for charm,sleep,stun
	global.questbook_page = 1;
	tempbb={};
	tmp_ppoint={};
	tmp_ppoint2={};
	map_limit_w=1;
	map_limit_h=1;
	hex_pass=" ";
	hex_costs=" ";
	hex_type=" ";
	cursor_world_x=1;
	cursor_world_y=1;

	path_status=0;

	hex_to_check_next_wave={};
	find_the_path=0;
	way_of_the_mob={};

	mob_add_mov_x=0;
	mob_add_mov_y=0;
	current_mob=1;
	modepf=1;

	
	shot_line={};

	darkness = {};

	trace.array_of_darkness();

	dlandscape_obj={} -- fire, ice, etc. effects
	dlandscape_power={}
	dlandscape_duration={}

	alandscape_obj={}; -- poison/air/clod effects
	alandscape_power={};
	alandscape_duration={};

	rlandscape_obj={}; -- radiation
	rlandscape_power={};
	rlandscape_duration={};

	vlandscape_obj={} ;-- void
	vlandscape_id={};
	vlandscape_duration={};

	mlandscape_obj={}; -- mines, spikes
	mlandscape_power={};
	mlandscape_duration={};
	mlandscape_id={};

	xlandscape = {}; --traps;

	elandscape={}; -- temporary explosion effects

	wlandscape={} -- wizard eye level

	tlandscape={}; --decals

	hlandscape={}; -- harvest, herbs, minerals,food

	slandscape={}; -- shadows

	plandscape={}; -- switch level

	arrays_of_tmp_landscape ();
	
	array_of_map ();

	back_size = 256;
	back_count = 8;

	bgmap_w=#bgmap[1];
	bgmap_h=#bgmap;

	current_back=1;
	row_back=1;

	atk_direction=1;
	global.wheeled=0;
	global.draw_interface = 1;
	global.draw_temphud = -1;
	global.grey = true;
	global.timers={};
	global.timers.x_timer=0;
	global.timers.t_timer=0;
	global.timers.m_timer=0;
	global.timers.n_timer=0;
	global.timers.o_timer=0;
	global.timers.s_timer=0;
	global.timers.a_timer=0;
	global.timers.msl_timer=0;
	global.timers.msla_timer=0;
	global.timers.d_timer=0;
	global.timers.th_timer=0;
	global.timers.md_timer=0;
	global.timers.bm_timer=0;
	global.timers.p_timer=0;
	global.timer=0;
	global.mindtimer = 0;
	global.multiattack = 1;
	global.price = 0;
	global.preprice = 0;
	global.wares_flag = 0;
	global.showinventory_flag = "sell";
	global.timer200=0;
	logactions={};
	global.status="peace";
	global.steal=false;
	global.object = 0;
	global.slots={
	"armor","head","rh","lh","ranged","ammo","boots","gloves","belt","cloak","art","amulet","ring1","ring2","ring3","ring4","ring5","ring6",
	"comp1","comp2","comp3","comp4","comp5","comp6","comp7","comp8","comp9","tool1","tool2","tool3","tool4","tool5","tool6","bottle1","bottle2","bottle3",
	"key","picklock","trapkey","forcer"
	};
	global.warbook_skills = {
	{"sword","axe","flagpole"},
	{"crushing","staff","dagger"},
	{"unarmed","dodging","shield"},
	{"bow","crossbow","throwing"},
	};
	global.stats_short={"mgt","enu","spd","dex","acu","sns","int","spr","chr","luk"};
	global.resistances={"rezfire","rezcold","rezstatic","rezpoison","rezacid","rezdisease","rezmind","rezspirit","rezlight","rezdarkness"};
	page=1;
	missle_type="none";
	missle_drive="muscles";
	missle_effect = "none";
	damaged_mobs={};

	blockturn=0;
	spell_rotation=1;
	walked_before=0;
	previctim=1;
	order_of_turns={};
	inv_status="watch";
	mob_detects_enemies={};
	mob_detects_aggro={};

	ai_called=0;
	mob_is_going_to_hit=0;
	mob_is_going_to_picklock=0;
	last_path_hex_turn = 1;
	mob_can_move=0;
	ignore_kb=0;

	trapped=0;
	show_inventory_tips=0;
	tip_title="none";
	standart_rtadd=100; -- add if spacebar or sand clock pressed or mob`s ai is rnd
	selected_mob=0;
	exchange=0;
	global.start = true;
	global.lookaround = true;
	global.weathers = {"shiny","rain"};
	global.weather = math.random(1,#global.weathers);

	chars_mobs_npcs={};
	if global.first_load then
		table.insert(chars_mobs_npcs,{uid=-1,person="char",control="player",party=1,x=15,y=10,rot=1});
		table.insert(chars_mobs_npcs,{uid=-2,erson="char",control="player",party=1,x=12,y=13,rot=3 });
		table.insert(chars_mobs_npcs,{uid=-3,person="char",control="player",party=1,x=7,y=7,rot=3 });
		table.insert(chars_mobs_npcs,{uid=-4,person="char",control="player",party=1,x=10,y=14,rot=3 });

		for i = 1,chars do
			helpers.addMob(i,"char");
		end;
	end;
	current_mob = 1;

	global_irr=2;
	irradiation=irradiations[global_irr];
--NEW LEVEL
	if global.level_to_load == 1 then
	--mobs
		--table.insert(chars_mobs_npcs,{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=15,y=15,rot=5,class="goblin",fraction="greens",party=4});
		table.insert(chars_mobs_npcs,{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=13,y=16,rot=5,class="goblin",fraction="greens",party=4});
		table.insert(chars_mobs_npcs,{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=10,y=6,rot=6,class="goblin",fraction="greens",party=4});
		table.insert(chars_mobs_npcs,{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=9,y=6,rot=4,class="goblin",fraction="greens",party=4});
		table.insert(chars_mobs_npcs,{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=11,y=5,rot=2,class="goblin",fraction="greens",party=4});
		table.insert(chars_mobs_npcs,{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=43,y=27,rot=3,class="goblin",fraction="greens",party=4});
		table.insert(chars_mobs_npcs,{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=16,y=5,rot=4,class="rogue",fraction="bandidos",party=4});
		table.insert(chars_mobs_npcs,{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=14,y=7,rot=1,class="naga",fraction="bandidos",party=4});
		table.insert(chars_mobs_npcs,{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=10,y=7,rot=4,class="mage",fraction="bandidos",party=4});

		for i=(chars+1),#chars_mobs_npcs do
			helpers.addMob(i,"mob");
		end;

		local totalmobs = #chars_mobs_npcs;

		table.insert(chars_mobs_npcs,{uid=1,person="npc",control="ai",defaultai="cruiser",ai="cruiser",dangerai="away",waypoint={{16,11},{13,11},{8,11},{8,5},{13,4},{17,6}},nextpoint=2,x=16,y=11,rot=5,class="goblin",fraction="vagrants", party=2, name="Nils Larsen", chat=2, face = 8,
		personality={
		current={chat=2,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="coward"},humor={multi=1,ifsuccess=10,ifnot=4,ifknown=3,known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblin"},{"elf"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		default={chat=2,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="coward"},humor={multi=1,ifsuccess=10,ifnot=4,ifknown=3,known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblin"},{"elf"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		alternative={chat=2,etiquette = "criminal",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="disdain",gold="middleclass",drinks="boozer",threat="coward"},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblin"},{"elf"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
		thiefcatcher={chat=8,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="boozer",threat="coward"},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblin"},{"elf"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
		}
		});
		table.insert(chars_mobs_npcs,{uid=2,person="npc",control="ai",defaultai="stay",ai="stay",dangerai="away",x=20,y=10,rot=2,class="goblin",fraction="vagrants",  party=2, name="Ivan Susanin", face = 8,
		personality={
		current={chat=1,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		default={chat=1,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="vrave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		thiefcatcher={chat=8,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
		}
		});
		table.insert(chars_mobs_npcs,{uid=3,person="npc",control="ai",defaultai="stay",ai="random",dangerai="away",x=18,y=8,rot=4,class="goblin",fraction="vagrants",  party=2, name="Pavlik Morozoff", face = 7,
		personality={
		current={chat=2,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		default={chat=2,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="vrave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		thiefcatcher={chat=8,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
		}
		});
		table.insert(chars_mobs_npcs,{uid=4,person="npc",control="ai",defaultai="building",ai="building",dangerai="none",x=1,y=1,rot=6,class="goblin",fraction="merchants",  party=3, name="Schors", face = 7, shop=1,
		personality={
		current={chat=3,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		default={chat=3,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="vrave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		thiefcatcher={chat=8,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
		}
		});
		chars_mobs_npcs[#chars_mobs_npcs].num_trading=10;
		chars_mobs_npcs[#chars_mobs_npcs].lvl_trading=3;
		table.insert(chars_mobs_npcs,{uid=5,person="npc",control="ai",defaultai="building",ai="building",dangerai="none",x=1,y=1,rot=6,class="goblin",fraction="merchants",  party=3, name="Meroving", face = 2,
		personality={
		current={chat=4,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		default={chat=4,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="vrave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		thiefcatcher={chat=8,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
		}
		});
		table.insert(chars_mobs_npcs,{uid=6,person="npc",control="ai",defaultai="building",ai="building",dangerai="none",x=1,y=1,rot=6,class="goblin",fraction="merchants",  party=3, name="Папарабль", face = 2,shop=2,
		personality={
		current={chat=5,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		default={chat=5,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="vrave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		thiefcatcher={chat=8,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
		}
		});
		table.insert(chars_mobs_npcs,{uid=7,person="npc",control="ai",defaultai="building",ai="building",dangerai="none",x=1,y=1,rot=6,class="goblin",fraction="merchants",  party=3, name="Лупитош", face = 3,shop=3,
		personality={
		current={chat=6,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		default={chat=6,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="vrave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		thiefcatcher={chat=8,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
		}
		});
		table.insert(chars_mobs_npcs,{uid=8,person="npc",control="ai",defaultai="building",ai="building",dangerai="none",x=1,y=1,rot=6,class="goblin",fraction="merchants",  party=3, name="Пилюлькин", face = 4,shop=3,
		personality={
		current={chat=7,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		default={chat=7,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="vrave"},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
		thiefcatcher={chat=8,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="boozer",threat="brave"},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
		}
		});

		for i=(totalmobs+1),#chars_mobs_npcs do
			helpers.addMob(i,"npc");
		end;

		sort_switcher=0;
		sorttarget="char";
		oldsorttarget="char";
		dragfrom="char";
		for h=1,chars do
			th=h;
			selected_char = h;
			for i=1,15 do
				for j=1,11 do
					inventory_bag[h][i][j]=0;
				end
			end
			helpers.resort_inv(h);
		end;

		bags_list={};
		bags={};
		bagid=false;

		bags_list[1]={
		x=10,y=10, xi=10, yi=10, typ="bag", opened=false, locked=false, dir=0, img=bag_img,
		{ttxid=1,q=1,w=0,e=0,r=0,h=0},
		{ttxid=5,q=1,w=0,e=0,r=0,h=0},
		{ttxid=372,q=20,w=0,e=0,r=0,h=0},
		{ttxid=465,q=1,w=0,e=0,r=0,h=0},
		{ttxid=474,q=1,w=0,e=0,r=0,h=0},
		{ttxid=475,q=1,w=0,e=0,r=0,h=0},
		{ttxid=476,q=1,w=0,e=0,r=0,h=0},
		};

		bags_list[2]={
		x=8,y=8, xi=8, yi=7, typ="chest", opened=false, material=30, locked=true, locktype=1, lockcode=2232543314, traped = false, dir=1, img=chest_img[1],
		{ttxid=1,q=1,w=0,e=0,r=0,h=0},
		};
		--trapcode="123456789" --FIXME: 1st item removes if trap activated, cause it`s trap`s part, other lost (q)antity: all types of armor, weapon and ammo, potions, books and scrolls can be destroyed, but only if firebomb or acidbomb, or mb electricity/cold (not scrolls!)
		bags_list[3]={
		x=14,y=7, xi=15, yi=7, typ="chest", opened=false, material=50, locked=true, locktype=2, lockcode=1234512345, traped = true, inspected = false, trapcode="0000000012312345678999300", triggers="0001000100", trapmodel="firebomb", trappower = 5, dir=2, img=chest_img[2],
		{ttxid=2,q=1,w=0,e=0,r=0,h=0},
		};

		bags_list[4]={
		x=17,y=14, xi=17, yi=15, typ="chest", opened=false, material=70, locked=true, locktype=3, lockcode=7457612465, traped = true, inspected = false, trapcode="333062520", triggers="0100010001", trapmodel="firebomb", trappower = 5, dir=3, img=chest_img[1],
		{ttxid=2,q=1,w=0,e=0,r=0,h=0},
		};

		bags_list[5]={
		x=11,y=8, xi=11, yi=8, typ="bag", opened=false, locked=false, dir=0, img=bag_img,
		{ttxid=1,q=1,w=0,e=0,r=0,h=0},
		};

		bags_list[6]={
		x=11,y=8, xi=11, yi=8, typ="bag", opened=false, locked=false, dir=0, img=bag_img,
		{ttxid=62,q=1,w=0,e=0,r=0,h=0},
		{ttxid=379,q=5,w=0,e=0,r=1,h=0},
		};

		bags_list[7]={
		x=10,y=11, xi=10, yi=11, typ="trap", mask=40, detected=false, opened=false, locked=true, locktype=0, lockcode=999999999, dir=0, traped = true, inspected = false, trapcode="204056305", trapmodel="firebomb", trappower = 5, img=trap_img,
		--{ttxid=303,q=32,w=0,e=0,r=1,h=0},
		};

		bags_list[8]={
		x=48,y=37, xi=48, yi=37, typ="door", opened=false, locked=true, locktype=2, lockcode=1234512345, dir=0, traped = true, inspected = false, trapcode="204056305", triggers="0001000100", trapmodel="firebomb", trappower = 5, dir=3, img_index = 1, img=door_img[1],
		--{ttxid=303,q=32,w=0,e=0,r=1,h=0},
		};

		bags_list[9]={
		x=34,y=18, xi=34, yi=18, typ="well", opened=false, locked=false, dir=0, img=well_img,
		{ttxid=72,q=10,w=0,e=0,r=1,h=0},
		{ttxid=202,q=5,w=0,e=0,r=1,h=0},
		};

		bags_list[10]={
		x=16,y=25, xi=16, yi=25, typ="crystals", charged = true, power = 25, opened=false, locked=false, img=crystals_img,
		{ttxid=429+math.random(1,6),q=1,w=0,e=0,r=1,h=0},
		};

		bags_list[11]={
		x=31,y=9, xi=31, yi=9, typ="trashheap", condition_lvl=1,condition_num=5, opened=false, locked=false, img=trashheap_img,
		{ttxid=1+math.random(1,10*5),q=math.random(1,10),w=0,e=0,r=1,h=0},
		};

		bags_list[12]={
		x=15,y=36, xi=15, yi=36, typ="scullpile", condition_lvl=1,condition_num=5, opened=false, locked=false, img=scullpile_img,
		{ttxid=440,q=math.random(1,10),w=0,e=0,r=1,h=0},
		};
		
		bags_list[13]={
		x=26,y=20, xi=26, yi=20, typ="box", opened=false, locked=false, img=box_img,
		{ttxid=6,q=math.random(1,10),w=0,e=0,r=1,h=0},
		};
		
--[[ for lveditor output
		local traptypes={"fire","cold","static","poison","acid","disease","spikes","teleport",",bell"}; 
		for i=1,#bags_list do
			if bags_list[i].typ == "chest" or bags_list[i].typ == "trap" or bags_list[i].typ == "door" then
				if bags_list[i].locked  then
					local complication = 10;
					local lockcode = {};
					local code = bags_list[bagid].lockcode;
					for w in string.gmatch(code, "%d") do
						table.insert(lockcode, tonumber(w));
					end;
					local firstsix = ""
					for h=1,#lockcode do
						if h <= 6 then
							firstsix = firstsix .. lockcode[h];
						end;
					end;
					if firstsix == "random" and #lockcode == 6 then
						complication = 10;
					elseif firstsix == "random" and #lockcode == 7 then
						complication = tonumber(lockcode[7]);
					elseif firstsix == "random" and #lockcode > 7 then
						complication = tonumber(lockcode[7] .. lockcode[8]);
					end;
					
					if firstsix == "random" and (#bags_list[i].lockcode >= 6 and #bags_list[i].lockcode <= 8) then
						local _lockcode = "";
						local limit = 5;
						if locktype == 3 then
							limit = 8;
						end;
						for h=1,complication do
							local rnd = math.random(1,limit);
							_lockcode = _lockcode .. rnd;
						end;
						bags_list[i].lockcode = _lockcode;
					end;	
				end;
				if bags_list[i].traped  then
					local complication = 9;
					local trapcode = {};
					local code = bags_list[bagid].trapcode;
					for w in string.gmatch(code, "%d") do
						table.insert(trapcode, tonumber(w));
					end;
					local firstsix = ""
					for h=1,#trapcode do
						if h <= 6 then
							firstsix = firstsix .. trapcode[h];
						end;
					end;
					if firstsix == "random" and #trapcode == 6 then
						complication = 9;
					elseif firstsix == "random" and trapcode[7] == 1 then
						complication = 1;
					elseif firstsix == "random" and trapcode[7] == 2 then
						complication = 2;
					elseif firstsix == "random" and trapcode[7] == 3 then
						complication = 3;
					elseif firstsix == "random" and trapcode[7] == 4 then
						complication = 4;
					elseif firstsix == "random" and trapcode[7] >= 5 then
						complication = 5;
					end;
					
					if firstsix == "random" and #bags_list[i].trapcode >= 6 then
						local limit = 10;
						local trapcode_array = {};
						local zerolomit =  complication;
						if complication == 1 then
							zerolimit = 0;
						elseif complication == 2 then
							zerolimit = 1;
						end;
						for h=1,complication^2 do
							local rnd = math.random(1,limit);
							table.insert(trapcode_array,rnd);
						end;
						for h=1,zerolimit do
							trapcode_array[h] = 0;
						end;
						helpers.randomizeArray1D (trapcode_array);
						local _trapcode = helpers.arrayToString (trapcode_array);
						bags_list[i].trapcode = _trapcode;
					end;	
				end;
				if bags_list[i].trapmodel and bags_list[i].trapmodel == "random" then
					bags_list[i].trapmodel = traptypes[math.random(1,#traptypes)];
				end;
				if bags_list[i].locked and bags_list[i].locktype > 1 and bags_list[i].traped and bags_list[i].triggers == "" then
					local triggers ="";
					for i=1,bags_list[i].lockcode do
						local rnd = math.random(1,2) - 1;
						triggers = triggers .. rnd;
					end;
					bags_list[i].triggers = triggers; --FIXME too much triggers?
				end;
			end;
		end;
		
]]

		objects_list={};

		objects_list[1]={x=6, y=8, xi=6, yi=8, typ="barrel", subtyp=1, img=barrel_img[2]};
		objects_list[2]={x=7, y=10, xi=7, yi=10, typ="cauldron", subtyp=1, img=cauldron_img[2]};
		objects_list[3]={x=42, y=30, xi=42, yi=30, typ="obelisk", part=1, img=obelisk_img};
		objects_list[4]={x=31, y=14, xi=31, yi=14, typ="pedestal", effect1="heroism_power",effect2="heroism_dur",value1=10,value2=10, img=pedestal_img};
		objects_list[5]={x=27, y=25, xi=27, yi=25, typ="competition", stat="mgt", limit=5, bonus=5, uids={}, img=competition_img};
		objects_list[6]={x=38, y=18, xi=38, yi=18, outx=18, outy=25, typ="portal", subtyp=1, img=portal_img};
		objects_list[7]={x=46, y=21, xi=46, yi=21, typ="well", subtyp="drink", story="wellmagical", plus="hp", plusvalue=10, minus=false, minusvalue=0, conditions={}, wimg="well_clean", img=well_img};
		objects_list[8]={x=48, y=20, xi=48, yi=20, typ="well", subtyp="dungeon", story="welldungeon", plus=false, plusvalue=0, minus=false, minusvalue=0, conditions={}, wimg="well_dungeon", img=well_img};
		for i=1,#objects_list do
			if objects_list[i].typ == "cauldron" then
				boomareas.ashGround (objects_list[i].xi,objects_list[i].yi);
			end;
		end;

		bars_list = {};
		bars_list[1]={};
		bars_list[2]={};
		bars_list[3]={};
		bars_list[4]={};

		armor_assortiment={
		{171,171,172,176},
		{186,186,191,251},
		{201,221,231},
		};

		melee_assortiment={
		{1,6,11,16,21,26,31,36,41,46,51,56,61,66,71,76,81,86,91,96,101,106},
		{1,6,11,16,21,26,31,36,41,46,51,56,61,66,71,76,81,86,91,96,101,106},
		};

		modifers_assortiment={
		{1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,671,64},
		};

		alchemy_assortiment={
		{423,424,425,426,427,469,470,471,472,473},
		{1,2,3,4}, --recepies, id 409
		{460,460,463,463,463,465},
		};

		for i=1,4 do
			local rndid = armor_assortiment[1][math.random(1,#armor_assortiment[1])];
			table.insert(bars_list[1],{ttxid=rndid,q=inventory_ttx[rndid].material,w=0,e=0,r=1,h=0});
		end;

		for i=1,4 do
			local rndid = armor_assortiment[2][math.random(1,#armor_assortiment[2])];
			table.insert(bars_list[1],{ttxid=rndid,q=inventory_ttx[rndid].material,w=0,e=0,r=1,h=0});
		end;

		for i=1,8 do
			local rndid = armor_assortiment[3][math.random(1,#armor_assortiment[3])];
			table.insert(bars_list[1],{ttxid=rndid,q=inventory_ttx[rndid].material,w=0,e=0,r=1,h=0});
		end;

		for i=1,8 do
			local rndid = melee_assortiment[1][math.random(1,#melee_assortiment[1])];
			table.insert(bars_list[2],{ttxid=rndid,q=inventory_ttx[rndid].material,w=0,e=0,r=1,h=0});
		end;

		for i=1,8 do
			local rndid = alchemy_assortiment[1][math.random(1,#alchemy_assortiment[1])];
			table.insert(bars_list[3],{ttxid=rndid,q=math.random(5,10),w=0,e=0,r=1,h=0});
		end;

		for i=1,8 do
			local rndid = alchemy_assortiment[2][math.random(1,#alchemy_assortiment[2])];
			table.insert(bars_list[3],{ttxid=409,q=rndid,w=0,e=0,r=1,h=0});
		end;

		for i=1,8 do
			local rndid = alchemy_assortiment[3][math.random(1,#alchemy_assortiment[3])];
			table.insert(bars_list[3],{ttxid=rndid,q=math.random(5,10),w=0,e=0,r=1,h=0});
		end;

		for i=1,8 do
			local rndid = melee_assortiment[2][math.random(1,#melee_assortiment[2])];
			local rndmod = modifers_assortiment[1][math.random(1,#modifers_assortiment[1])];
			table.insert(bars_list[4],{ttxid=rndid,q=inventory_ttx[rndid].material,w=rndmod,e=0,r=1,h=0});
		end;

		traders={
		{typ="armor",bars={1,1,2,4},prices={3,0.5},assortiment=1
		,classes={{"sword","axe","crushing","flagpole","staff","dagger","armor","helm","boots","gloves","belt","cloak","shield"}
		,{"sword","axe","crushing","flagpole","staff","dagger","armor","helm","boots","gloves","belt","cloak","shield"}
		,{"sword","axe","crushing","flagpole","staff","dagger","armor","helm","boots","gloves","belt","cloak","shield"}}
		},
		{typ="alchemy",bars={0,0,0,0,0,0,0,0,0,0,3,0},prices={3,0.5},assortiment=1
		,classes={{"bottle","potion","component","alchtool"}
		,{"bottle","potion","component","alchtool"}
		,{"alchtool"}}
		},
		};

		for i=1,map_w do
			for z=1,map_h do
				if harvest_table[i][z][1] > 0 and math.random(1,100) <= harvest_table[i][z][2] then
					hlandscape[i][z] = harvest_table[i][z][1];
				elseif harvest_table[i][z][1] > 0 and harvest_table[i][z][3] and #harvest_table[i][z][3] > 0 then
					local _rnd = math.random(1,#harvest_table[i][z][3]);
					hlandscape[i][z] = harvest_table[i][z][3][_rnd];
				end;
			end;
		end;
		helpers.clearHlandscapeUnderMobs();
		helpers.clearHlandscapeUnderObjectsAndBags();
		for i=2,3 do
			for h=12,16 do
				plandscape[i][h] = {2,100-i,h};
			end;
		end;
	end;
--/NEW LEVEL

	trace.chars_around();
	--helpers.battleorder();

	local tmp = chars_mobs_npcs[current_mob].sprite .. "_walk";
	mob_walk = loadstring("return " .. tmp)();

	local tmp = chars_mobs_npcs[current_mob].sprite .. "_dmg";
	mob_dmg = loadstring("return " .. tmp)();

	local tmp = chars_mobs_npcs[current_mob].sprite .. "_death";
	mob_death = loadstring("return " .. tmp)();

	local tmp = chars_mobs_npcs[current_mob].sprite .. "_atk1";
	mob_atk1 = loadstring("return " .. tmp)();

	local tmp = chars_mobs_npcs[current_mob].sprite .. "_sht1";
	mob_sht1 = loadstring("return " .. tmp)();

	local tmp = chars_mobs_npcs[current_mob].sprite .. "_cast1";
	mob_cast1 = loadstring("return " .. tmp)();

	local tmp = chars_mobs_npcs[current_mob].sprite .. "_block";
	mob_block = loadstring("return " .. tmp)();

	local tmp = chars_mobs_npcs[current_mob].sprite .. "_launch";
	mob_launch = loadstring("return " .. tmp)();

	local _walk_anim_time =  0.075*global.walk_animation_speed;
	animation_atk1 = anim8.newAnimation(mob_atk1[chars_mobs_npcs[current_mob].rot]("1-8",1), 0.075,"pauseAtEnd");
	animation_walk = anim8.newAnimation(mob_walk[chars_mobs_npcs[current_mob].rot]("1-8",1), _walk_anim_time,"pauseAtEnd");
	animation_death = anim8.newAnimation(mob_dmg[1]("1-8",1), 0.075,"pauseAtEnd");
	animation_sht1 = anim8.newAnimation(mob_sht1[1]("1-9",1), 0.075,"pauseAtEnd");
	animation_launch = anim8.newAnimation(mob_launch[1]("1-9",1), 0.075,"pauseAtEnd");
	animation_cast1 = anim8.newAnimation(mob_cast1[1]("1-9",1), 0.075,"pauseAtEnd");
	--animation_block = anim8.newAnimation(mob_block[1]("1-8",1), 0.075,"pauseAtEnd");

	animation_dmg = {};
	animation_block = {};

	for i=1,6 do
		local tmp = chars_mobs_npcs[current_mob].sprite .. "_dmg";
		mob_dmg = loadstring("return " .. tmp)();
		animation_dmg[i] = anim8.newAnimation(mob_dmg[i]("9-16",1), 0.075,"pauseAtEnd");
	end;

	for i=1,6 do
		local tmp = chars_mobs_npcs[current_mob].sprite .. "_block";
		mob_dmg = loadstring("return " .. tmp)();
		animation_block[i] = anim8.newAnimation(mob_block[i]("1-8",1), 0.075, "pauseAtEnd");
	end;

	for h = 1,#bags_list do
		bags[h] = {};
		for i = 1,15 do
			bags[h][i] = {};
			for j = 1,11 do
				bags[h][i][j] = 0;
			end;
		end;
	end;

	for i=1,#chars_mobs_npcs do
		helpers.recalcBattleStats (i);
	end;

	for i = 1, #chars_mobs_npcs do -- OR CHARS?
		trace.first_watch(i);
	end;
		trace.chars_around();
		trace.clear_rounded();

	sorttarget = "char";
	dragfrom = "char";

	global.start = false;
	bagremoved = 0;
	show_monsterid_tip = 0;

	tmpexp = 0;
	comparray = {};
	find_raw();
	global.rnd_timer_limit=0.05;
	global.timers.rnd_timer=0;

	helpers.globalRandom();
	start_picklock = false;
	dodge = 0;
	block = 0;
	parry = 0;
	drink_smth = 0;
	oil_smth = 0;
	bomb_smth = 0;
	scroll_smth = 0;
	use_smth =0 ;
	slot = 0;
	genocidethem = "";
	keyJustBroken = 0;
    picklockJustBroken = 0;
    changePosition = false;
    tmp_mob = current_mob;
    harvest_load ();
	buildings_data ();
    draw.shaderIrradiation ();
    --lightWorld.setAmbientColor(15, 15, 31) -- optional
    --lightMouse = lightWorld.newLight(0, 0, 0, 0, 0,0)
    --lightMouse.setGlowStrength(0.3) -- optional
    lights = {};
    table.insert(lights,{x=0,y=0,light=lightWorld.newLight(0, 0, 0, 0, 0,0),typ="default"});
    boomareas.fireGround (12,7,1,1,1); --FIXME! For test only
    boomareas.fireGround (15,15,1,1,2); --FIXME! For test only
    boomareas.poisonAir (8,12,1,10,10);
    --for i=1,#chars_mobs_npcs do
    	--local xx,yy =  helpers.hexToPixels(chars_mobs_npcs[i].y,chars_mobs_npcs[i].x);
    	--table.insert(shadows,{x=chars_mobs_npcs[i].x,y=chars_mobs_npcs[i].y,shadow = lightWorld.newCircle(xx, yy, 20),typ="mob"});
    --end;
        --for i=1,#chars_mobs_npcs do
    	--local xx,yy =  helpers.hexToPixels(chars_mobs_npcs[i].y,chars_mobs_npcs[i].x);
    	--table.insert(shadows,{x=chars_mobs_npcs[i].x,y=chars_mobs_npcs[i].y,shadow = lightWorld.newCircle(xx, yy, 20),typ="mob"});
    --end
    helpers.cam_to_mob ();

	sort_switcher = 1
	sorttarget="char"
	oldsorttarget="char"
	--h = current_mob
	for h=1,chars do
		th=h;
		current_mob = h;
		for i=1,15 do
			for j=1,11 do
				inventory_bag[h][i][j]=0;
			end
		end
		helpers.resort_inv();
	end

	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].motion == "walking" then
			boomareas.trackGround (chars_mobs_npcs[i].x,chars_mobs_npcs[i].y,chars_mobs_npcs[i].track,chars_mobs_npcs[i].rot);
		end;
	end;

	for j=1, #objects_list do
		local xx,yy = helpers.hexToPixels (objects_list[j].xi,objects_list[j].yi);
		if objects_list[j].typ == "barrel" or  objects_list[j].typ == "cauldron" then

		elseif objects_list[j].typ == "obelisk" then

		elseif objects_list[j].typ == "pedestal" then
			table.insert(lights,{x=objects_list[j].xi,y=objects_list[j].yi,light=lightWorld.newLight(xx, yy, 255, 135, 220, 128),typ="ground"});
			lights[#lights]["light"].setGlowStrength(0.3);
		elseif objects_list[j].typ == "altar" then

		elseif objects_list[j].typ == "competition" then
			table.insert(lights,{x=objects_list[j].xi,y=objects_list[j].yi,light=lightWorld.newLight(xx, yy, 0, 236, 255, 128),typ="ground"});
			lights[#lights]["light"].setGlowStrength(0.3);
		elseif objects_list[j].typ == "portal" then
			table.insert(lights,{x=objects_list[j].xi,y=objects_list[j].yi,light=lightWorld.newLight(xx, yy, 15, 255, 0, 128),typ="ground"});
			lights[#lights]["light"].setGlowStrength(0.3);
		elseif objects_list[j].typ == "well" then

		end;
	end;

	current_mob = 1;
	if ai.enemyWatchesYou () then
		letaBattleBegin ();
	end;
	if global.status == "peace" then
		utils.playThemeMusic (media.sounds.peace,0,"peace");
	end;
	global.first_load = false;
	
	--[[
	
	lightMouse = lightWorld.newLight(100, 100, 1, 1, 1,10)
    lightMouse.setGlowStrength(0.3) -- optional
	
	
	local x = 200
	local y = 200
	local strength = 1
	
	imgNormal = love.graphics.newImage("img/lightsvsshadows/refraction_normal.png")
	imgHeightMap = love.graphics.newImage("img/lightsvsshadows/refraction_height.png")
	
	print("IMG",imgNormal,imgHeightMap)
	
	lightWorld.setRefractionStrength(16.0)
   -- set the global reflection strength to 32 (default: 16)
   lightWorld.setReflectionStrength(32)
   -- set the global reflection visibility to 0.5 (default: 1.0)
   lightWorld.setReflectionVisibility(0.5)
   -- create a refraction from a normal map
   refraction = lightWorld.newRefraction(imgNormal, x, y)
   -- create a refraction from a height map and choose the strength (default: 1.0)
   refraction = lightWorld.newRefractionHeightMap(imgHeightMap, x, y)
   print("REF",refraction)
   -- move the normal map texture within the boundary
   refraction.setNormalTileOffset(x, y)]]
	
end;

--======================================================================

function playingState.update(dt)
	global.timer = global.timer + dt;
	--global.screenWidth = love.graphics.getWidth();
	--global.screenHeight = love.graphics.getHeight();
	if dt <= 1/60 then
      love.timer.sleep(0.001)
	end
	if global.timer >= 1000 then
		global.timer=0;
	end;
	for i=1,#lights do
		local xx,yy = 0,0;
		if lights[i].typ == "ground" then
			xx,yy = helpers.hexToPixels (lights[i].x+1,lights[i].y+1);
			if lights[i].y/2 == math.ceil(lights[i].y/2) then
				xx,ww = helpers.hexToPixels (lights[i].x,lights[i].y+1);
			end;
		elseif lights[i].typ == "mob" then
			xx,yy = helpers.hexToPixels (lights[i].x,lights[i].y);
		end;
		if lights[i].typ ~= "default" and lights[i].typ ~= "missle" and lights[i].typ ~= "boom" then
			lights[i]["light"].setPosition(xx,yy);
		end;
	end;
	for i=1,#shadows do
		local xx,yy =  helpers.hexToPixels(shadows[i].x+map_x,shadows[i].y+map_y);
		shadows[i]["shadow"].setPosition(xx+tile_w/2,yy+tile_h/2);
	end;
	if game_status ~= "pause" then
		dt = math.min(dt, 0.0166);
		global.timers.x_timer = global.timers.x_timer + dt
		if blockturn > 0 then
			blockturn = blockturn - 1;
		end
--coordinates of cursor
		local mob_range = chars_mobs_npcs[current_mob].rng-walked_before;
		if math.sqrt(math.abs(chars_mobs_npcs[current_mob].x-cursor_world_x)^2 + math.abs(chars_mobs_npcs[current_mob].y-cursor_world_y)^2)<mob_range then
			path_status = 0;
		end;
		mX, mY = love.mouse.getPosition();
		cursor_world_x,cursor_world_y = helpers.cursorWorldCoordinates ();
		if game_status == "mindgame" then
			global.mindcursor_x,global.mindcursor_y = helpers.mindGameCoordinates ();
		end;
		if chars_mobs_npcs[current_mob].control == "player" then
			point_to_go_x = cursor_world_x;
			point_to_go_y = cursor_world_y;
		end;
		selected_mob = 0;
		for j=1,chars do
			if mX>=(j*125-85) and mX<=(j*125-5) and mY>=global.screenHeight-110 and mY<global.screenHeight-20 then
				selected_mob=j;
			end;
		end;
		for j=1,#order_of_turns do
			if mX>=(j*45+global.screenWidth/2-240) and mX<=(j*45+global.screenWidth/2-200) and mY>=2 and mY<47 and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding") and global.status == "battle" then
				selected_mob = order_of_turns[j][1];
			end;
		end;
		if game_status == "mindgame" and global.mindtimer <= 0 and global.mindway and #global.mindway > 0 and (global.mindhero_x ~= global.mindway[#global.mindway][1] or global.mindhero_y ~= global.mindway[#global.mindway][2]) then
			global.hang = false;
			global.mindhero_x = global.mindway[#global.mindway][1];
			global.mindhero_y = global.mindway[#global.mindway][2];
			
			if mindgame.map[global.mindhero_x][global.mindhero_y] >= 1 and mindgame.map[global.mindhero_x][global.mindhero_y] <= 7 then -- opponent ignores money
				utils.playSfx(media.sounds.gold_dzen,1);
				party.gold = party.gold+mindgame.moneysums[mindgame.map[global.mindhero_x][global.mindhero_y]];
				global.mindgold = global.mindgold-mindgame.moneysums[mindgame.map[global.mindhero_x][global.mindhero_y]];
				mindgame.map[global.mindhero_x][global.mindhero_y] = 0;
			end;
			
			if mindgame.map[global.mindhero_x][global.mindhero_y] >= 1000 then -- opponent ignores gifts
				--utils.playSfx(media.sounds.gold_dzen,1);
				mindgame.map[global.mindhero_x][global.mindhero_y] = 0;
			end;

			if mindgame.map[global.mindhero_x][global.mindhero_y] > 100 and mindgame.map[global.mindhero_x][global.mindhero_y] <= 165 then
				local tmpx = global.mindhero_x;
				local tmpy = global.mindhero_y;
				if mindgame.map[global.mindhero_x][global.mindhero_y] == 101 then
					game_status = "neutral";
					chars_mobs_npcs[victim].status = 0;
					loveframes.util.RemoveAll();
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 102 then
					local plusstatus = 1;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 103 then
					local plusstatus = 2;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 104 then
					local plusstatus = 3;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 105 then
					local plusstatus = 4;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 106 then
					local plusstatus = 5;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 107 then
					local plusstatus = 6;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 108 then
					local plusstatus = 7;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 109 then
					local plusstatus = 8;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 110 then
					local plusstatus = 9;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 111 then
					local plusstatus = 10;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 112 then
					local plusstatus = 11;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 113 then
					local plusstatus = 12;
					local plusnumber = 5;
					local minusnumber = 1;
					for i=1,12 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = math.max(0,chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] - minusnumber);
					end;
					chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][plusstatus] + plusnumber;

				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 114 then
					local tmp = chars_mobs_npcs[victim]["personality"]["current"];
					chars_mobs_npcs[victim]["personality"]["current"] = chars_mobs_npcs[victim]["personality"]["alternative"];
					chars_mobs_npcs[victim]["personality"]["alternative"] = tmp;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 115 then
					local array = {};
					for i=1,9 do
						for h=1,9 do
							if mindgame.passCheck(i,h) then
								table.insert(array,{i,h});
							end;
						end;
					end;
					if #array > 0 then
						local rnd = math.random(1,#array);
						global.mindhero_x = i;
						global.mindhero_y = h;
					end;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 116 then
					--some secret to log
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 117 then
					if mindgame.passCheck(5,5) then
						global.mindhero_x = 5;
						global.mindhero_y = 5;
					end;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 118 then
					if mindgame.passCheck(5,5) then
						global.mindhero_x = 5;
						global.mindhero_y = 5;
					end;
					for i=1,10 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = 0;
					end;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 119 then
					for i=1,10 do
						chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = 0;
					end;
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 120 then
					local point = 1;
					global.mindhero_x = mindgame.dest_coords[point][1];
					global.mindhero_y = mindgame.dest_coords[point][2];
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 121 then
					local point = 2;
					global.mindhero_x = mindgame.dest_coords[point][1];
					global.mindhero_y = mindgame.dest_coords[point][2];
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 122 then
					local point = 3;
					global.mindhero_x = mindgame.dest_coords[point][1];
					global.mindhero_y = mindgame.dest_coords[point][2];
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 123 then
					local point = 4;
					global.mindhero_x = mindgame.dest_coords[point][1];
					global.mindhero_y = mindgame.dest_coords[point][2];
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 124 then
					local point = 5;
					global.mindhero_x = mindgame.dest_coords[point][1];
					global.mindhero_y = mindgame.dest_coords[point][2];
				elseif mindgame.map[global.mindhero_x][global.mindhero_y] == 125 then
					local point = 5;
					global.mindhero_x = mindgame.dest_coords[point][1];
					global.mindhero_y = mindgame.dest_coords[point][2];
				end;
				mindgame.map[tmpx][tmpy] = 0;
			end;
			draw.mindgameButtons();
			for i=1,12 do
				if mindgame.dest_coords[i][1] == global.mindhero_x and mindgame.dest_coords[i][2] == global.mindhero_y then
					print("MINDGAME FINISHED:",i); --CRY
					party.gold = party.gold - global.mindgold;
					global.mindgold = 0;
					loveframes.util.RemoveAll();
					global.status = "peace";
					if chars_mobs_npcs[victim]["personality"]["current"]["mindgameresults"][i] then
						local index = chars_mobs_npcs[victim]["personality"]["current"]["mindgameresults"][i];
						mindresults.results(index);
					else
						game_status = "neutral";
					end;
				end;
			end;
			if mindgame.attempts == 0 then
				print("MINDGAME FINISHED:",i); --CRY
				party.gold = party.gold - global.mindgold;
				global.mindgold = 0;
				loveframes.util.RemoveAll();
				global.status = "peace";
				if chars_mobs_npcs[victim]["personality"]["current"]["mindgameresults"][i] then
					local index = chars_mobs_npcs[victim]["personality"]["current"]["mindgameresults"][i];
					mindresults.results(index);
				else
					game_status = "neutral";
				end;
			end;
		end;
		--print(cursor_world_x,cursor_world_y);
		if game_status == "spellbook"
		or game_status == "warbook"
		or game_status == "questbook"
		or game_status == "inventory"
		or game_status == "alchemy"
		or game_status == "picklocking"
		or game_status == "crafting"
		or game_status == "chat"
		or game_status == "mindgame"
		or game_status == "literature"
		or game_status == "map"
		or game_status == "journal"
		or game_status == "menu"
		or game_status == "stats"
		or game_status == "skills"
		or mY > 820 or mY < 50 or darkness[chars_mobs_npcs[current_mob].party][cursor_world_y][cursor_world_x] == 2 then
			love.mouse.setVisible(true);
		else
			--love.mouse.setVisible(false);
		end;
		if game_status ~= "spellbook" then
			show_spellbook_tips = 0;
		end;
		if game_status ~= "warbook" then
			show_warbook_tips = 0;
		end;
		if game_status ~= "inventory" and game_status ~= "alchemy" and game_status ~= "picklocking" and gamePstatus ~= "crafting" and game_status ~= "buying" and game_status ~= "showinventory" then
			show_inventory_tips = 0;
		end;
		if game_status == "pathfinding" and global.status == "battle" and chars_mobs_npcs[current_mob].control=="player" and (cursor_world_x == chars_mobs_npcs[current_mob].x and cursor_world_y == chars_mobs_npcs[current_mob].y) == false then
			path_finding(0,0);
		end;
		if game_status == "pathfinding" and global.status == "peace" and chars_mobs_npcs[current_mob].control=="player" and (cursor_world_x == chars_mobs_npcs[current_mob].x and cursor_world_y == chars_mobs_npcs[current_mob].y) == false then
			if love.keyboard.isDown("lctrl") then
				global.steal = true;
			else
				global.steal = false;
			end;
			path_finding(1,0);
		end;
		animation_fireburn:update(dt);
		animation_flame:update(dt);
		animation_poisoned:update(dt);
		animation_twister:update(dt);
		if game_status == "boom" then
			animation_firexplo:update(dt);
			animation_toxicexplo:update(dt);
			animation_icexplo:update(dt);
			animation_snow:update(dt);
			animation_staticexplo:update(dt);
			animation_healbuff:update(dt);
			animation_chargebuff:update(dt);
			animation_encourage:update(dt);
			animation_regeneration:update(dt);
			animation_windexplo:update(dt);
			animation_dustexplo:update(dt);
			animation_incexplo:update(dt);
			animation_bloodfirst:update(dt);
			animation_regeneration:update(dt);
			animation_protfromfire:update(dt);
			animation_protfromcold:update(dt);
			animation_protfromstatic:update(dt);
			animation_shield:update(dt);
			animation_stoneskin:update(dt);
			animation_protfrompoison:update(dt);
			animation_protfromdisease:update(dt);
			animation_protfromacid:update(dt);
			animation_protofmind:update(dt);
			animation_protofspirit:update(dt);
			animation_prism:update(dt);
			--animation_violation:update(dt);
			animation_acidexplo:update(dt);
			animation_lightning:update(dt);
			animation_spike:update(dt);
			animation_shrapexplo:update(dt);
			animation_implosion:update(dt);
			animation_dehydratation:update(dt);
			animation_sunray:update(dt);
			animation_moonlight:update(dt);
			animation_souldrinker:update(dt);
			animation_massdistortion:update(dt);
			animation_charm:update(dt);
			animation_berserk:update(dt);
			animation_enslave:update(dt);
			animation_frost:update(dt);
			animation_razor:update(dt);
			animation_sleep:update(dt);
			animation_fear:update(dt);
			animation_resurrect:update(dt);
			animation_haste:update(dt);
			animation_strenght:update(dt);
			animation_dash:update(dt);
			animation_douse:update(dt);
			animation_acidbomb:update(dt);
			animation_cold:update(dt);
			animation_light:update(dt);
			animation_stonewall:update(dt);
			animation_startfireburn:update(dt);
			animation_mobility:update(dt);
			animation_deadlyswarm:update(dt);
			animation_deadlywave:update(dt);
		end;
		animation_fountain:update(dt);
		if game_status == "damage" or game_status == "multidamage" or game_status == "attack" then
			for i=1,6 do
				animation_dmg[i]:update(dt);
			end;
			animation_death:update(dt);
		end;
		if game_status == "moving" then
			animation_walk:update(dt);
		end;
		if game_status == "attack" then
			animation_atk1:update(dt);
		end;
		if game_status == "shot" then
			animation_sht1:update(dt);
			animation_cast1:update(dt);
			animation_launch:update(dt);
		end;
		if game_status == "missle" then
			animation_bolt:update(dt);
			animation_grenade:update(dt);
			animation_coldbeam:update(dt);
			animation_flamearrow:update(dt);
			animation_mindblast:update(dt);
			animation_spiritualarrow:update(dt);
			animation_darkflame:update(dt);
			animation_dragonbreath:update(dt);
			animation_lightbolt:update(dt);
			animation_staticharge:update(dt);
			animation_toxiccloud:update(dt);
			animation_fireball:update(dt);
			animation_iceball:update(dt);
			animation_poisonedspit:update(dt);
			animation_acidburst:update(dt);
			animation_meteor:update(dt);
			animation_armageddonsky:update(dt);
			animation_armageddonground:update(dt);
			animation_acidrain:update(dt);
			animation_deathblossom:update(dt);
			animation_comete:update(dt);
		end;
		if  chars_mobs_npcs[current_mob].control == "ai"
		and game_status == "neutral" then
			path_failed = 0;
			ai.behavior();
		end;
		if game_status == "pause" then
			global.timers.p_timer = global.timers.p_timer + dt;
			if global.timers.p_timer >= 0.5 then
				global.timers.p_timer=0;
				game_status = "neutral";
				if global.status == "peace" then
					mob_plus();
				elseif global.status == "battle" then
					game_status = "restoring";
				end;
			end;
		end;
		global.timers.m_timer = global.timers.m_timer + dt;
		global.timers.n_timer = global.timers.n_timer + dt;
		global.timers.o_timer = global.timers.o_timer + dt;
		global.timers.t_timer = global.timers.t_timer + dt;
		if game_status == "multidamage" then
			global.timers.md_timer = global.timers.md_timer + dt;
		end;
		if game_status == "attack" then
			global.timers.a_timer = global.timers.a_timer + dt;
		end;
		if game_status == "damage" then
			global.timers.d_timer = global.timers.d_timer + dt;
		end;
		if game_status == "shot" then
			global.timers.s_timer = global.timers.s_timer + dt;
		end;
		if game_status == "missle" then
			global.timers.msl_timer = global.timers.msl_timer + dt;
			global.timers.msla_timer = global.timers.msla_timer + dt;
		end;
		if game_status == "boom" then
			global.timers.bm_timer = global.timers.bm_timer + dt;
		end;
		global.timers.rnd_timer = global.timers.rnd_timer + dt;
		if global.timers.rnd_timer >= global.rnd_timer_limit then
			helpers.anim_random();
			global.timers.rnd_timer=0;
		end;
		if game_status == "sensing" then
			tmp_current_mob = current_mob;
		end;
		if game_status == "mindgame" and global.mindtimer > 0 then
			global.mindtimer = global.mindtimer - dt;
		end;
		if global.timers.m_timer >= 1 then
			if  cursor_world_x > map_limit_w and cursor_world_x < map_display_w - map_limit_w and cursor_world_y > map_limit_h and cursor_world_y < map_display_h - map_limit_h and heights_table[map[cursor_world_y][cursor_world_x]] == 0 then
				cursor_world_x = cursor_world_x;
				cursor_world_y = cursor_world_y;
			end;
			global.timers.m_timer=0;
		else
		end;
		if game_status == "pathfinding" and #way_of_the_mob > 0 then
			chars_mobs_npcs[current_mob].rot=way_of_the_mob[#way_of_the_mob][6];
		end;
		if game_status == "moving" then
			if not global.hang then
				--mobs gets path_counter at pathfinding.lua
				path_counter = #way_of_the_mob;
				global.hang = true;
				if #way_of_the_mob > 0 then --dirty fix
					rot = way_of_the_mob[#way_of_the_mob][6] -- nil
					chars_mobs_npcs[current_mob].rot = rot;
				end;
				tmp = chars_mobs_npcs[current_mob].sprite .. "_walk";
				mob_walk = loadstring("return " .. tmp)();
				global.timers.n_timer=0;
				local sound_of_step = stepsound_table[map[chars_mobs_npcs[current_mob].y][chars_mobs_npcs[current_mob].x]];
				local snd = loadstring("return " .. "media.sounds.footstep_long_" .. sound_of_step)();
				utils.playSfx(snd,1);
			end;
			mobMoving();
		end;

		if game_status == "sensing" and chars_mobs_npcs[current_mob].control=="player" then
			tmp_current_mob=current_mob
			helpers.turnMob(current_mob);
		end;
--0.4
		if game_status == "attack" and global.timers.a_timer >= 1 then
			if global.multiattack == 0 or chars_mobs_npcs[victim].status <= 0 or chars_mobs_npcs[current_mob].rt <= 0 or chars_mobs_npcs[current_mob].st <= 0 then --FIXME RECOVERY
				 global.multiattack = 0;
				hang=0;
				path_status=0;
				global.timers.a_timer=0;
				game_status="restoring";
			else
				--global.multiattack = global.multiattack -1;
				love.audio.stop(media.sounds.sword_miss,0);
				love.audio.stop(media.sounds.block,0);
				love.audio.stop(media.sounds.sword_crit,0);
				love.audio.stop(media.sounds.sword_impact,0);
				global.timers.a_timer=0;
				damage.meleeAttack (damage.meleeAttackTool (current_mob));
			end;
		end;
--0.4
		if  game_status == "damage" and global.timers.d_timer >= 1 then
			hang=0;
			path_status=0;
			global.timers.d_timer=0;
			if global.status == "peace" then
				mob_plus();
			elseif global.status == "battle" then
				game_status="restoring";
			end;
		end;
--0.4
		if game_status == "multidamage" and global.timers.md_timer >= 1 then
			hang=0;
			path_status=0;
			global.timers.md_timer=0;
			while (#damaged_mobs>0) do
				table.remove(damaged_mobs,1);
			end;
			if global.status == "peace" then
				mob_plus();
			elseif global.status == "battle" then
				game_status="restoring";
			end;
		end;

		if game_status == "restoring" then
			if global.lookaround then
				for i = 1, chars do
					trace.first_watch(i);
				end;
				global.lookaround = false;
			end;
			restoreRT();
		end;

		if game_status == "sensing" and missle_type == "genocide" then
			if helpers.cursorAtMobID (cursor_world_x,cursor_world_y) then
				genocidethem = chars_mobs_npcs[helpers.cursorAtMobID (cursor_world_x,cursor_world_y)].class;
			end;
		end;

		if game_status == "shot" and  global.timers.s_timer>=0.5 then
			global.timers.s_timer=0;
			missle_x= chars_mobs_npcs[current_mob].x;
			missle_y= chars_mobs_npcs[current_mob].y;
			fly_count=1;

			sfx.castSound ();

			if missle_type=="bolt" or missle_type=="arrow" or missle_type=="throwing" or missle_type=="bottle" or missle_type=="bullet" or missle_type=="battery" 
			or (missle_drive == "muscles" and  helpers.missleAtWarBook() and tricks.tricks_tips[missle_type].form == "range" and (tricks.tricks_tips[missle_type].skill == "bow" or tricks.tricks_tips[missle_type].skill == "crossbow"))
			or (missle_drive == "muscles" and  helpers.missleAtWarBook() and tricks.tricks_tips[missle_type].form == "range" and tricks.tricks_tips[missle_type].skill == "throwing")
			then
				game_status="missle";
				in_fly=0;
			elseif magic.spell_tips[missle_type].form == "arrow" or magic.spell_tips[missle_type].form == "ball"
			or magic.spell_tips[missle_type].form == "rico" or magic.spell_tips[missle_type].form == "rain" or magic.spell_tips[missle_type].form == "skyrock"
			or magic.spell_tips[missle_type].form == "ally" or magic.spell_tips[missle_type].form == "deadally" or magic.spell_tips[missle_type].form == "enemy" or magic.spell_tips[missle_type].form == "deadenemy"
			or magic.spell_tips[missle_type].form == "area"
			or missle_type == "armageddon" then
				game_status="missle";
				in_fly=0;
				draw.shaderIrradiation ();
			elseif magic.spell_tips[missle_type].form == "ring"
			or magic.spell_tips[missle_type].form == "sight"
			or magic.spell_tips[missle_type].form == "wall"
			or magic.spell_tips[missle_type].form == "breath"
			or magic.spell_tips[missle_type].form == "skyray"
			or magic.spell_tips[missle_type].form == "vray"
			or magic.spell_tips[missle_type].form == "ray"
			or magic.spell_tips[missle_type].form == "trident"
			or magic.spell_tips[missle_type].form == "level"
			or magic.spell_tips[missle_type].form == "path"
			or magic.spell_tips[missle_type].form == "proactive"
			or magic.spell_tips[missle_type].form == "direct"
			or missle_type=="jump"
			or missle_type=="torchlight"
			or missle_type=="chainlightning"
			or missle_type=="powerheal"
			or magic.spell_tips[missle_type].form=="mole"
			or missle_type=="ritualofthevoid"
			or missle_type=="twister" then
				if magic.spell_tips[missle_type].form == "sight"
				or magic.spell_tips[missle_type].form == "breath"
				or magic.spell_tips[missle_type].form == "vray"
				or magic.spell_tips[missle_type].form == "ray"
				or magic.spell_tips[missle_type].form == "level"
				or magic.spell_tips[missle_type].form == "trident" then
					boomy= chars_mobs_npcs[current_mob].y;
					boomx= chars_mobs_npcs[current_mob].x;
				end;
				if  magic.spell_tips[missle_type].form == "mole" or magic.spell_tips[missle_type].form == "ring" then
					boomy= chars_mobs_npcs[victim].y;
					boomx= chars_mobs_npcs[victim].x;
				end;
				if  magic.spell_tips[missle_type].form == "jump" then
					boomy = cursor_world_y;
					boomx = cursor_world_x;
				end;
				draw.boom();
			elseif magic.spell_tips[missle_type].form == "mine"
			or magic.spell_tips[missle_type].form == "enemy"
			or missle_type=="freeze"
			or missle_type=="earthquake"
			or missle_type=="wizardeye"
			or magic.spell_tips[missle_type].form == "summon" then
				game_status="damage";
				damage.instantCast();
			end;
		end;

		if game_status == "missle" then
			if helpers.missleIsAweapon () then
				missle_fly();
			elseif magic.spell_tips[missle_type].form == "arrow" or magic.spell_tips[missle_type].form == "ball"
			or missle_type=="icefield" then
				missle_fly();
			elseif magic.spell_tips[missle_type].form == "ally" or magic.spell_tips[missle_type].form == "deadally" or magic.spell_tips[missle_type].form == "enemy" or magic.spell_tips[missle_type].form == "deadenemy" then
				boomy= chars_mobs_npcs[victim].y;
				boomx= chars_mobs_npcs[victim].x;
				draw.boom();
			elseif magic.spell_tips[missle_type].form == "area" then
				boomx = cursor_world_x;
				boomy = cursor_world_y;
				draw.boom();
			elseif magic.spell_tips[missle_type].form == "rain" or magic.spell_tips[missle_type].form == "skyrock" then
				meteor_fly();
			elseif magic.spell_tips[missle_type].form == "rico" then
				in_fly=0;
				rock_fly();
			elseif missle_type == "armageddon" then
				armageddon_fly();
			end;
		end;

		if game_status == "boom" and global.timers.bm_timer >= 0.4 then
			global.timers.bm_timer=0;
			if missle_drive == "alchemy" or missle_drive == "trap" or missle_drive == "revenge" or magic.spell_tips[missle_type].form == "ball" or magic.spell_tips[missle_type].form == "rico" or magic.spell_tips[missle_type].form=="mole" then
				damaged_mobs = damage.multidamage();
			elseif magic.spell_tips[missle_type].form == "arrow" or magic.spell_tips[missle_type].form == "skyray" or magic.spell_tips[missle_type].form == "direct" then
				game_status="damage";
				damage.singledamage();
			elseif magic.spell_tips[missle_type].form == "ally" or magic.spell_tips[missle_type].form == "deadally" or magic.spell_tips[missle_type].form == "enemy" or magic.spell_tips[missle_type].form == "area" or magic.spell_tips[missle_type].form == "deadenemy" or missle_type=="torchlight" or missle_type=="ritualofthevoid" then
				game_status="damage";
				damage.instantCast();
			elseif magic.spell_tips[missle_type].form == "ring" or magic.spell_tips[missle_type].form == "proactive"
			or magic.spell_tips[missle_type].form == "wall" or magic.spell_tips[missle_type].form == "sight" or magic.spell_tips[missle_type].form == "breath"
			or magic.spell_tips[missle_type].form == "rain" or magic.spell_tips[missle_type].form == "level" or magic.spell_tips[missle_type].form == "vray"
			or magic.spell_tips[missle_type].form == "ray" or magic.spell_tips[missle_type].form == "trident" or magic.spell_tips[missle_type].form == "skyray" or magic.spell_tips[missle_type].form == "deathblossomk"
			or missle_type=="jump"
			or missle_type=="chainlightning"
			or missle_type=="powerheal"
			or missle_type=="armageddon"
			or missle_type=="twister" then
				game_status="damage";
				damage.multidamage ();
			elseif  missle_type=="flame" then
				game_status="restoring";
			end;
		end;
	end;
	loveframes.update(dt);
end;

function clear_elandscape ()
	for i = 1, map_w do
		elandscape[i] = {};
		for z=1, map_h do
			elandscape[i][z] = 0;
		end;
	end;
end;

function all_bags ()
	for h=1,bags do
		bag_at_map[h] = {};
		for i=1,15 do
			bag_at_map[h][i] = {};
			for j=1,11 do
				bag_at_map[h][i][j] = 0;
			end;
		end;
	end;
end;

function array_of_map ()
	all_ground_hexes={};
	tile_counter = 1;
	for my=1, map_h do
		for mx=1, map_w do
			local visibility = 0;
			local pass = 0;
			if map[mx][my] <= 1200 then
				visibility = visibility_table[map[mx][my]];
				pass = heights_table[map[mx][my]];
				if dlandscape_obj[mx][my] == "stone" then
					pass = 2;
					visibility = 1;
				end;
				if dlandscape_obj[mx][my] == "pit" then
					pass = -1;
				end;
			else
				visibility = 1;
				pass = 2;
			end;
			all_ground_hexes[tile_counter] = {id=tile_counter+1, type=map[my][mx], x=my,y=mx, pass=pass,visibility=visibility,stepsound=stepsound_table[map[mx][my]]};
			--table.insert(all_ground_hexes,{id=tile_counter+1, type=map[my][mx], x=my,y=mx, pass=pass,visibility=visibility,stepsound=stepsound_table[map[mx][my]] });
			tile_counter = tile_counter+1;
		end;
	end;
end;

function arrays_of_tmp_landscape ()
	for i=1, map_w do
        elandscape[i]={};
        tlandscape[i]={};
        xlandscape[i]={};
        dlandscape_obj[i]={};
        dlandscape_power[i] = {};
        dlandscape_duration[i] = {};
        alandscape_obj[i]={};
        alandscape_power[i] = {};
        alandscape_duration[i] = {};
        mlandscape_duration[i] = {};
        mlandscape_id[i] = {};
        mlandscape_obj[i]={};
        mlandscape_power[i] = {};
        wlandscape[i] = {};
        hlandscape[i] = {};
        slandscape[i] = {};
        vlandscape_obj[i]={};
		vlandscape_id[i]={};
		vlandscape_duration[i]={};
		plandscape[i]={};
		for z=1, map_h do
			elandscape[i][z]=0;
			elandscape[i][z]=0;
			tlandscape[i][z]={{decal=0,param=0,rotation=0},{decal=0,param=0,rotation=0},{decal=0,param=0,rotation=0}};
			xlandscape[i][z]= {dmg=nil,code=0};
			dlandscape_obj[i][z]=0;
			dlandscape_power[i][z] = 0;
			dlandscape_duration[i][z] = 0;
			alandscape_obj[i][z]=0;
			alandscape_power[i][z] = 0;
			alandscape_duration[i][z] = 0;
			mlandscape_obj[i][z]=0;
			mlandscape_power[i][z] = 0;
			mlandscape_duration[i][z] = 0;
			mlandscape_id[i][z] = 0;
			wlandscape[i][z]  = 0;
			hlandscape[i][z]  = 0;
			slandscape[i][z]  = 0;
			vlandscape_obj[i][z]=0;
			vlandscape_id[i][z]=0;
			vlandscape_duration[i][z]=0;
			plandscape[i][z]=0;
		end;
	end;
end;

function playingState.keypressed(key, unicode)
	if chars_mobs_npcs[current_mob].control == "player" or game_status == "menu" then
		if game_status ~= "moving" then
			if key == "up" then
				if map_y > 0 then
					map_y = map_y-1;
					helpers.castShadows();
				end;
			end;
			if key == "down" then
				if map_y < (map_h-40) then
					map_y = map_y+1;
					helpers.castShadows();
				end;
			end;
			if key == "left" then
				if map_x >= 2 then
					map_x = map_x-1;
					helpers.castShadows();
				end;
			end;
			if key == "right" then
				if map_x <= (map_w-30) then
					map_x = map_x+1;
					helpers.castShadows();
				end;
			end;
		end;
	end;
end;

function playingState.keyreleased(key, unicode)
	
	if key == "x" and find_the_path == 0 and (game_status ~= "neutral" and game_status ~= "sensing")then
		for j=1,#chars_mobs_npcs do
			if chars_mobs_npcs[j].person == "char" and chars_mobs_npcs[j].control == "player" then
			elseif chars_mobs_npcs[j].person == "mob" then
				chars_mobs_npcs[j].hp = 0;
				damage.deadNow (j);
			end;
		end;
		current_mob = 4;
		game_status = "neutral";
	end;
	
	
	if key == " " and chars_mobs_npcs[current_mob].control == "player" and game_status == "moving" then -- FIXME debug, for interrupt turn funtions
		helper.interrupt();
	end;

	if key == " " and game_status == "mindgame" then
		mindgame.passTurn()
	end;

	if key == "o" then
		if game_status ~= "pause" then
			tmp_game_status = game_status;
			game_status = "pause";
	   else
			game_status = tmp_game_status;
	   end;
	end;

	if key == "5" then
		game_status = "obelisk"; --FIXME from diary
	end;
	
	if key == "u" and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting") then
		th = current_mob;
		sorttarget = "char"
		oldsorttarget = "char";
		for i=1,15 do
			for j=1,11 do
				inventory_bag[current_mob][i][j] = 0;
			end;
		end;
		helpers.resort_inv(current_mob);
   end;

	if chars_mobs_npcs[current_mob].control == "player" or game_status == "menu" then
		if key == "lctrl" then
		  love.mouse.setVisible(true);
		end;
		if key == "rctrl" then --set to whatever key you want to use
			love.mouse.setVisible(false);
		end;
		if key=="y" then
			love.audio.pause(media.sounds.battle, 0);
		end;
		if key=="r" then
			love.audio.resume(media.sounds.battle, 0);
		end;
		if key=="l" then
			--utils.playSfx(media.sounds.battle, 1);
		end;
		if key=="h" and chars_mobs_npcs[current_mob].person == "char" and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting" or game_status == "skills" or game_status == "stats") then
			helpers.harvestOne (chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
		end;
		if key=="j" and chars_mobs_npcs[current_mob].person == "char" and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting" or game_status == "skills" or game_status == "stats") then
			helpers.flayOne ();
		end;
		if key=="z" and chars_mobs_npcs[current_mob].person == "char" and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding") then
			helpers.knockToDoor ();
		end;
		if key=="g" and chars_mobs_npcs[current_mob].person == "char" and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding") and global.status == "peace" then
			if chars_mobs_npcs[current_mob].stealth > 0 then
				 chars_mobs_npcs[current_mob].stealth = 0;
			elseif not ai.mobWatchesTheMob (current_mob,false) then
				 chars_mobs_npcs[current_mob].stealth = chars_mobs_npcs[current_mob].num_stealth*chars_mobs_npcs[current_mob].lvl_stealth;
			end;
		end;
		if key=="p" then
			if chars_mobs_npcs[current_mob].person=="char" and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" ) then
				game_status="picklocking";
				inventory_bag_call();
				helpers.repackBag();
			elseif chars_mobs_npcs[current_mob].person=="char" and game_status == "picklocking" then
			   utils.playSfx(media.sounds.invclose,1);
			   game_status="neutral";
			end;
		end;

		if key==" " and (game_status == "neutral" or game_status == "pathfinding" or game_status == "sensing") and chars_mobs_npcs[current_mob].control == "player" and ignore_kb==0 then  --spacebar
			utils.printDebug("spacebar");
			local switch_level = helpers.ifSwitchLevel();
			if switch_level then
				game_status="asktoswitchlevel";
				helpers.switchLevelAsk(switch_level);
			else
				chars_mobs_npcs[current_mob].rt=math.max(chars_mobs_npcs[current_mob].rt-standart_rtadd,0); -- pass turn
				game_status="restoring";
				ignore_kb=1;
			end;
		end;

		if key==" " and game_status == "comic" then
			if page < #comics_ttx[current_comic] then
				loveframes.util.RemoveAll();
				page = page + 1;
			else
				loveframes.util.RemoveAll();
				game_status = "neutral"
			end;
		end;

		if key == "x" and find_the_path == 0 and (game_status == "neutral" or game_status == "sensing")then
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].person == "char" and chars_mobs_npcs[j].control == "player" then
				elseif chars_mobs_npcs[j].person == "mob" then
					chars_mobs_npcs[j].hp = 0;
					damage.deadNow (j);
				end;
			end;
		end;

		if key == "0" then
			global.draw_interface = -1*global.draw_interface;
		end;

		if key == "9" then
			global.draw_temphud = -1*global.draw_temphud;
		end;

		if key == "f" and (game_status == "neutral" or game_status == "sensing") then
			find_the_path=1;
			game_status = "pathfinding";
			global.wheeled = 0;
			global.traced = 0;
			for i = 1, #chars_mobs_npcs do
				if chars_mobs_npcs[i].control == "player" then
					trace.first_watch(i);
				end;
			end;
		   trace.chars_around();
		   trace.clear_rounded();
		end

		if key == "n" and (game_status == "sensing" or game_status == "pathfinding") then
		   find_the_path=0;
		   path_status=0;
		   game_status="neutral";
			helpers.neutralWatch();
		end;

		if key == "s"
		and (game_status == "neutral"
		or game_status == "pathfinding"
		or game_status == "sensing") then
			find_the_path=0;
			game_status="sensing";
			tmp_current_mob=current_mob;
			trace.all_to_darkness();
			trace.trace_hexes(current_mob,false,trace.sightArray (current_mob));
			trace.one_around(current_mob);
			trace.clear_rounded();
			if chars_mobs_npcs[current_mob]["equipment"].ammo > 0 then
				missle_drive="muscles";
				missle_type=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].ttxid].subclass;
			end;
			if chars_mobs_npcs[current_mob]["equipment"].ranged > 0 and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].ttxid].class == "wand" then
				if chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].q > 0 then
					missle_drive="wand";
					missle_type = chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].w;
				else
					missle_drive="muscles";
					missle_type="none";
				end;
			end;
		end;

		if love.keyboard.isDown("lctrl") and key == "1" and global.status == "battle" then
			if chars_mobs_npcs[current_mob].control == "player" then
				helpers.dodgeIfPossible (current_mob);
			end;
		end;

		if love.keyboard.isDown("lctrl") and key == "2" and global.status == "battle" then
			if chars_mobs_npcs[current_mob].control == "player" then
				helpers.blockIfPossible (current_mob);
			end;
		end;

		if love.keyboard.isDown("lctrl") and key == "3"  then
			if chars_mobs_npcs[current_mob].control == "player" and global.status == "battle" then
				helpers.parryIfPossible (current_mob);
			end;
		end;

		if love.keyboard.isDown("lctrl") and key == "4"  then
			if chars_mobs_npcs[current_mob].control == "player" and global.status == "battle" then
				helpers.handsIfPossible (current_mob);
			end;
		end;

		if key == "m" and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "spellbook" or game_status == "questbook" or game_status == "warbook" or game_status == "skills" or game_status == "stats") then
			game_status="map"
			utils.playSfx(media.sounds.paper,1);
		elseif game_status == "map" then
			game_status="neutral"
			utils.playSfx(media.sounds.paper,1);
		end

		if key == "b"
		and chars_mobs_npcs[current_mob].control=="player"
		and chars_mobs_npcs[current_mob].person=="char"
		and chars_stats[current_mob].spellbook==1
		and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "spellbook"  or game_status == "questbook" or game_status == "warbook" or game_status == "skills" or game_status == "stats" or game_status == "mindgame") then
			loveframes.util.RemoveAll();
			if game_status~="spellbook" then
				page=1;
				spellbook_call();
			elseif game_status == "spellbook" then
				utils.playSfx(media.sounds.bookclose,1);
				game_status="neutral";
			end;
		end;

		if key == "q"
		and chars_mobs_npcs[current_mob].control=="player"
		and chars_mobs_npcs[current_mob].person=="char"
		and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "spellbook" or game_status == "questbook" or game_status == "warbook" or game_status == "skills" or game_status == "stats") then
			if game_status~="questbook" then
				page=1;
				questbook_call();
			elseif game_status == "questbook" then
				utils.playSfx(media.sounds.bookclose,1);
				game_status="neutral";
			end;
		end;

		if key == "w"
		and chars_mobs_npcs[current_mob].control=="player"
		and chars_mobs_npcs[current_mob].person=="char"
		and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "spellbook" or game_status == "questbook" or game_status == "warbook" or game_status == "skills" or game_status == "stats") then
			if game_status~="warbook" then
				page=1;
				warbook_call();
			elseif game_status == "warbook" then
				utils.playSfx(media.sounds.bookclose,1);
				game_status="neutral";
			end;
		end;

		if key == "c"
		and chars_mobs_npcs[current_mob].control=="player"
		and chars_mobs_npcs[current_mob].person=="char"
		and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "spellbook" or game_status == "questbook" or game_status == "warbook" or game_status == "stats" or game_status == "skills") then
			tmp_mob = current_mob;
			if game_status~="stats" then
				charstats_call();
			elseif game_status == "stats" then
				utils.playSfx(media.sounds.bookclose,1);
				game_status="neutral";
			end;
		end;

		if key == "k"
		and chars_mobs_npcs[current_mob].control=="player"
		and chars_mobs_npcs[current_mob].person=="char"
		and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "spellbook" or game_status == "questbook" or game_status == "warbook" or game_status == "stats"or game_status == "skills") then
			tmp_mob = current_mob;
			if game_status~="skills" then
				charskills_call(current_mob);
			elseif game_status == "skills" then
				utils.playSfx(media.sounds.bookclose,1);
				game_status="neutral";
			end;
		end;

		if key == "i" then
			if chars_mobs_npcs[current_mob].person=="char"
			and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "mindgame") then
				loveframes.util.RemoveAll();
				game_status="inventory";
				inventory_bag_call();
				helpers.repackBag();
			elseif chars_mobs_npcs[current_mob].person=="char" and game_status == "inventory" and holding_smth==0 then
				utils.playSfx(media.sounds.invclose,1);
				game_status="neutral";
			elseif chars_mobs_npcs[current_mob].person=="char" and game_status == "mindgame" and holding_smth==0 then
				utils.playSfx(media.sounds.invclose,1);
				global.mindgame_attempts = global.mindgame_attempts - 1;
				game_status = "mindgame";
				draw.mindgameButtons();
			end;
		end;

		if key == "a" then
			if chars_mobs_npcs[current_mob].person=="char"
			and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" ) then
				game_status="alchemy";
				inventory_bag_call();
				helpers.repackBag();
			elseif chars_mobs_npcs[current_mob].person=="char" and game_status == "alchemy" then
				utils.playSfx(media.sounds.invclose,1);
				game_status="neutral";
			end;
		end;

		if key == "r" then
			if global_irr<#irradiations then
				global_irr=global_irr+1;
			else
				global_irr=1;
			end;
			irradiation=irradiations[global_irr]
			draw.shaderIrradiation ();
			helpers.findShadows();
		end;

		if key == "t"
		and global.status == "peace"
		and chars_mobs_npcs[current_mob].person=="char"
		and chars_mobs_npcs[current_mob].control=="player"
		then
			letaBattleBegin ();
		end;

		if key == "e" and chars_mobs_npcs[current_mob].control=="player"
		and (game_status == "neutral"
		or game_status == "sensing"
		or game_status == "pathfinding"
		or game_status == "menu"
		or game_status == "inventory"
		or game_status == "alchemy"
		or game_status == "picklocking"
		or game_status == "crafting"
		or (game_status == "spellbook" and global.status ~= "mindgame")
		or game_status == "questbook"
		or game_status == "warbook"
		or game_status == "literature"
		or game_status == "map"
		or game_status == "inventory"
		or game_status == "stats"
		or game_status == "skills"
		or game_status == "chat" --?
		--or game_status == "mindgame" --?
		or game_status == "log"
		or game_status == "housewatch"
		or game_status == "buying"
		or game_status == "showinventory"
		or game_status == "npcrepair"
		or game_status == "npcidentify"
		or game_status == "journal")
		and holding_smth==0
		then
			game_status = "calendar";
		end;

		if key == "escape" and (game_status == "spellbook" and global.status == "mindgame") then
			game_status = "mindgame";
			draw.mindgameButtons();
		end;

		if key == "d" and chars_mobs_npcs[current_mob].control=="player"
		and (game_status == "neutral"
		or game_status == "sensing"
		or game_status == "pathfinding"
		or game_status == "menu"
		or game_status == "inventory"
		or game_status == "alchemy"
		or game_status == "picklocking"
		or game_status == "crafting"
		or (game_status == "spellbook" and global.status ~= "mindgame")
		or game_status == "questbook"
		or game_status == "warbook"
		or game_status == "literature"
		or game_status == "map"
		or game_status == "inventory"
		or game_status == "stats"
		or game_status == "skills"
		or game_status == "chat" --?
		--or game_status == "mindgame" --?
		or game_status == "housewatch"
		or game_status == "buying"
		or game_status == "showinventory"
		or game_status == "npcrepair"
		or game_status == "npcidentify"
		or game_status == "journal")
		and holding_smth==0
		then
			game_status = "log";
		end;

		if key == "escape" and (game_status == "spellbook" and global.status == "mindgame") then
			game_status = "mindgame";
			draw.mindgameButtons();
		end;
		
		if key == "escape" and (game_status == "inventory" and global.status == "mindgame") then
			global.mindgame_attempts = global.mindgame_attempts - 1;
			game_status = "mindgame";
			draw.mindgameButtons();
			utils.playSfx(media.sounds.invclose,1);
		end;

		if key == "escape"
		and (game_status == "neutral"
		or game_status == "sensing"
		or game_status == "pathfinding"
		or game_status == "menu"
		or (game_status == "inventory" and global.status ~= "mindgame")
		or game_status == "alchemy"
		or game_status == "picklocking"
		or game_status == "crafting"
		or (game_status == "spellbook" and global.status ~= "mindgame")
		or game_status == "questbook"
		or game_status == "warbook"
		or game_status == "literature"
		or game_status == "map"
		or game_status == "inventory"
		or game_status == "stats"
		or game_status == "skills"
		or game_status == "chat" --?
		--or game_status == "mindgame" --?
		or game_status == "log"
		or game_status == "housewatch"
		or game_status == "buying"
		or game_status == "showinventory"
		or game_status == "npcrepair"
		or game_status == "npcidentify"
		or game_status == "journal"
		or game_status == "calendar"
		or game_status == "obelisk"
		or game_status == "well"
		)
		and   chars_mobs_npcs[current_mob].control=="player"
		and holding_smth==0
		then
			tmp_mob = current_mob;
			start_picklock = false;
			show_inventory_tips = 0;
			show_monsterid_tip = 0;
			show_spellbook_tips = 0;
			loveframes.util.RemoveAll();
			if oil_smth > 0 then
				bag[tmp_bagid][inv_quad_x][inv_quad_y] = oil_smth;
				bag[tmp_bagid][inv_quad_x+1][inv_quad_y] = inv_quad_y*10000+inv_quad_x;
				oil_smth=0
			end;

			if drink_smth > 0 then
				bag[tmp_bagid][inv_quad_x][inv_quad_y] = drink_smth;
				bag[tmp_bagid][inv_quad_x+1][inv_quad_y] = inv_quad_y*10000+inv_quad_x;
				drink_smth = 0;
				helpers.resort_inv(current_mob);
			end;

			if bomb_smth > 0 then
				bag[tmp_bagid][inv_quad_x][inv_quad_y] = bomb_smth;
				bag[tmp_bagid][inv_quad_x+1][inv_quad_y]=inv_quad_y*10000+inv_quad_x;
				bomb_smth = 0;
				helpers.resort_inv(current_mob);
			end;

			if scroll_smth > 0 then
				bag[tmp_bagid][inv_quad_x][inv_quad_y] = scroll_smth;
				bag[tmp_bagid][inv_quad_x+1][inv_quad_y]=inv_quad_y*10000+inv_quad_x;
				scroll_smth = 0;
				helpers.resort_inv(current_mob);
			end;

			if use_smth > 0 then
				bag[tmp_bagid][inv_quad_x][inv_quad_y] = use_smth;
				bag[tmp_bagid][inv_quad_x+1][inv_quad_y]=inv_quad_y*10000+inv_quad_x;
				use_smth = 0;
				helpers.resort_inv(current_mob);
			end;

			if game_status == "spellbook" or game_status == "questbook" or game_status == "warbook" then
				utils.playSfx(media.sounds.bookclose,1);
			elseif  game_status == "inventory" then
				utils.playSfx(media.sounds.invclose,1);
			elseif game_status == "stats" then
				utils.playSfx(media.sounds.bookclose,1);
			elseif game_status == "map" then
				utils.playSfx(media.sounds.paper,1);
			end;
			game_status="neutral"
			for i = 1, chars do
				trace.first_watch(i);
			end;
			trace.chars_around();
			trace.clear_rounded();
			global.hang = false;
		end;

		if global.status == "peace" then
			for i=1,chars do
				if key == tostring(i) and game_status ~= "moving" and chars_mobs_npcs[i].status == 1 then
					if game_status ~= "chat" then --lalala
						game_status = "neutral";
						find_the_path = 0;
						path_status = 0;
						current_mob = i;
						for i = 1, chars do
							trace.first_watch(current_mob);
						end;
						trace.chars_around();
						trace.clear_rounded();
						helpers.cam_to_mob ();
					end;
					if game_status == "chat" then
						current_mob = i;
						chats.load ();
					end;
				end
			end;
		end;

		if key == "g" and game_status == "pathfinding" then
			modepf=-1*modepf;
		end;

		if key == "v" and game_status == "sensing" then --FIXME DEBUG hurt
			for i=1,chars do
				damage.HPminus(i,10);
			end;
		end
	end;
end;

function playingState.mousereleased (x,y,button)

	if (button == "l" or button == "r") and (game_status == "inventory" or game_status == "alchemy"  or game_status == "picklocking" or game_status == "crafting") then
		x,y = helpers.centerObject(media.images.inv1);
		inv_add_x = x+12;
		inv_add_y = y-25;
	end;

	if button == "r"  then
		show_inventory_tips = 0;
		show_monsterid_tip = 0;
		show_spellbook_tips = 0;
		show_warbook_tips = 0;
		loveframes.util.RemoveAll();
	end;

	if button == "l" and game_status == "mindgame" then
		draw.mindgameLog ();
	end;

	--if button == "l" and game_status == "skills" and mX >= 600 and mX <= 690 and mY >= 600 and mY <= 630 then
		--helpers.applySkills (current_mob);
	--end;

	 if button == "l" and game_status == "comic" then
		if page < #comics_ttx[current_comic] then
			loveframes.util.RemoveAll();
			page = page + 1;
		else
			loveframes.util.RemoveAll();
			game_status = "neutral"
		end;
    end;

	if button == "l" and game_status == "chat" then
		local function clearText()
			chat_log = {};
			global_answer = "";
			current_questions = {};
		end;
		local index = chars_mobs_npcs[victim]["personality"]["current"].chat;
		local linenumber = 0;
		if chars_mobs_npcs[victim]["personality"] then
			--chars_mobs_npcs[victim]["personality"]["current"].mindstatus = {0,0,0,0,0,0,0,0,0,0,0,0}; --FIXME depends ON
			chars_mobs_npcs[victim]["personality"]["current"].mindstatus = chars_mobs_npcs[victim]["personality"]["default"].mindstatus;
		end;
		local current_questions = {};
		for i = 1,#chats.rules[index] do
			if chats.rules[index][i].default then
				table.insert(current_questions,i);
			end;
		end;
		local x,y = helpers.centerObject(media.images.map);
		for i = 1,#current_questions do
			--if mX >= 420 and mX <= 920 and mY >= 430 + 25*(i-1) and mY <= 430 + 25*i then
			--if mX >= x+155 and mX <= x+655 and mY >= y+320 + 25*(i-1) and mY <= y+320 + 25*i then
			if mX >= x+55 and mX <= x+855 and mY >= y+320 + 50*(i-1) and mY <= y+320 + 50*i then
				linenumber = i;
			end;
		end;
		if linenumber > 0 then
			chats.rules[index][current_questions[linenumber]].default = false;
			local q2log = chars_mobs_npcs[current_mob].name .. ": " .. chats.questions[index][chats.rules[index][current_questions[linenumber]].question];
			table.insert(chat_log,q2log);
			if #chat_log > 10 then
				table.remove(chat_log,1);
			end;
			if chats.rules[index][current_questions[linenumber]].nextquestion[1] > 0 then
				for i=1, #chats.rules[index][current_questions[linenumber]].nextquestion do
					chats.rules[index][chats.rules[index][current_questions[linenumber]].nextquestion[i]].default = true;
				end;
			end;
			if chats.rules[index][current_questions[linenumber]].remquestion and chats.rules[index][current_questions[linenumber]].remquestion[1] > 0 then
				for i=1, #chats.rules[index][current_questions[linenumber]].remquestion do
					for h=1, #chats.rules[index] do
						if chats.rules[index][current_questions[linenumber]].remquestion[i] == chats.rules[index][h].question then
							chats.rules[index][h].default = false;
						end;
					end;
				end;
			end;
			if chats.rules[index][current_questions[linenumber]].answer > 0 then
				if chats.rules[index][current_questions[linenumber]].answer <= 1000 then
					global_answer = chats.answers[index][chats.rules[index][current_questions[linenumber]].answer];
					local a2log = chars_mobs_npcs[victim].name .. ": " .. global_answer; --FIXME for buildings
					table.insert(chat_log,a2log);
					if #chat_log > 10 then
						table.remove(chat_log,1);
					end;
				elseif chats.rules[index][current_questions[linenumber]].answer == 1001 then --stop chat (home)
					game_status = "housewatch";
					calendar.add_time_interval(calendar.delta_housewatch);
					chat_log = {};
					clearText();
				elseif chats.rules[index][current_questions[linenumber]].answer == 1002 then --stop chat (openarea)
				elseif chats.rules[index][current_questions[linenumber]].answer == 1003 then --temple
					local price = 0;
					local deltahp = chars_mobs_npcs[index].hp_max - chars_mobs_npcs[current_mob].hp;
					local deltasp = chars_mobs_npcs[index].sp_max - chars_mobs_npcs[current_mob].sp;
					local deltast = chars_mobs_npcs[index].st_max - chars_mobs_npcs[current_mob].st;
					local deltart = 200 - chars_mobs_npcs[current_mob].rt;
					local effects = chars_mobs_npcs[current_mob].bleeding + chars_mobs_npcs[current_mob].flame_power*chars_mobs_npcs[current_mob].flame_dur + chars_mobs_npcs[current_mob].poison_power*chars_mobs_npcs[current_mob].poison_dur
					+chars_mobs_npcs[current_mob].cold_power*chars_mobs_npcs[current_mob].cold_dur+chars_mobs_npcs[current_mob].acid_power*chars_mobs_npcs[current_mob].acid_dur+ chars_mobs_npcs[current_mob].disease*10
					+chars_mobs_npcs[current_mob].drunk*10+chars_mobs_npcs[current_mob].insane*10+chars_mobs_npcs[current_mob].fear*10+chars_mobs_npcs[current_mob].silence*10
					+chars_mobs_npcs[current_mob].madness*10+chars_mobs_npcs[current_mob].filth_power*chars_mobs_npcs[current_mob].filth_dur
					+chars_mobs_npcs[current_mob].darkgasp*10+chars_mobs_npcs[current_mob].despondency_power*chars_mobs_npcs[current_mob].despondency_dur
					+chars_mobs_npcs[current_mob].blind_dur*chars_mobs_npcs[current_mob].blind_power+chars_mobs_npcs[current_mob].curse*10
					+chars_mobs_npcs[current_mob].ac_debuff_power*chars_mobs_npcs[current_mob].ac_debuff_dur
					+chars_mobs_npcs[current_mob].darkcontamination+chars_mobs_npcs[current_mob].basiliskbreath+chars_mobs_npcs[current_mob].evileye
					+chars_mobs_npcs[current_mob].deadlyswarm;
					
					price = 3*deltahp + 2*deltasp + math.max(0,deltast-deltart) + effects*10;
					if chars_mobs_npcs[current_mob].reye and chars_mobs_npcs[current_mob].reye == 0 then
						price = price + 500;
					end;
					if chars_mobs_npcs[current_mob].leye and chars_mobs_npcs[current_mob].leye == 0 then
						price = price + 500;
					end;
					if chars_mobs_npcs[current_mob].ceye and chars_mobs_npcs[current_mob].ceye == 0 then
						price = price + 500;
					end;
					if chars_mobs_npcs[current_mob]["arms_health"].rh == 0 then
						price = price + 200;
					end;
					if chars_mobs_npcs[current_mob]["arms_health"].lh == 0 then
						price = price + 200;
					end;
					--[[if chars_mobs_npcs[current_mob].rleg == 0 then
						price = price + 100;
					end;
					if chars_mobs_npcs[current_mob].lleg == 0 then
						price = price + 100;
					end;]]
					if chars_mobs_npcs[current_mob].pneumothorax > 0 then
						price = price + 1000;
					end;
					price = helpers.recountPrice(price,current_mob,victim);
					if helpers.payGold(price) then
						calendar.add_time_interval(calendar.delta_temple_heals);

						utils.playSfx(media.sounds["spell_heal"], 1);
						helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.healed[chars_mobs_npcs[current_mob].gender]);

						chars_mobs_npcs[current_mob].hp = chars_mobs_npcs[current_mob].hp_max;
						chars_mobs_npcs[current_mob].sp = chars_mobs_npcs[current_mob].sp_max;
						chars_mobs_npcs[current_mob].st = chars_mobs_npcs[current_mob].st_max;
						chars_mobs_npcs[current_mob].rt = 200;

						chars_mobs_npcs[current_mob].bleeding = 0;
						chars_mobs_npcs[current_mob].flame_power=0;
						chars_mobs_npcs[current_mob].flame_dur=0;
						chars_mobs_npcs[current_mob].poison_power=0;
						chars_mobs_npcs[current_mob].poison_dur=0;
						chars_mobs_npcs[current_mob].poison_status=0;
						chars_mobs_npcs[current_mob].cold_power=0;
						chars_mobs_npcs[current_mob].cold_dur=0;
						chars_mobs_npcs[current_mob].acid_power=0;
						chars_mobs_npcs[current_mob].acid_dur=0;
						chars_mobs_npcs[current_mob].disease = 0;
						chars_mobs_npcs[current_mob].drunk = 0;
						chars_mobs_npcs[current_mob].insane = 0;
						chars_mobs_npcs[current_mob].fear=0;
						chars_mobs_npcs[current_mob].silence = 0;
						chars_mobs_npcs[current_mob].madness = 0;
						chars_mobs_npcs[current_mob].filth_power=0;
						chars_mobs_npcs[current_mob].filth_dur=0;
						chars_mobs_npcs[current_mob].darkgasp = 0
						chars_mobs_npcs[current_mob].darkcontamination = 0;
						chars_mobs_npcs[current_mob].basiliskbreath = 0;
						chars_mobs_npcs[current_mob].evileye = 0;
						chars_mobs_npcs[current_mob].despondency_power=0;
						chars_mobs_npcs[current_mob].despondency_dur=0;
						chars_mobs_npcs[current_mob].blind_power = 0;
						chars_mobs_npcs[current_mob].blind_dur = 0;
						chars_mobs_npcs[current_mob].curse = 0;
						chars_mobs_npcs[current_mob].deadlyswarm = 0;
						damage.operateAnEye(current_mob,"reye",true);
						damage.operateAnEye(current_mob,"leye",true);
						damage.operateAnEye(current_mob,"ceye",true);
						chars_mobs_npcs[current_mob]["arms_health"].rh = 1;
						chars_mobs_npcs[current_mob]["arms_health"].lh = 1;
						chars_mobs_npcs[current_mob].pneumothorax = 0;
					end;
					clearText();
					loveframes.util.RemoveAll();
					game_status = "neutral";
				elseif chats.rules[index][current_questions[linenumber]].answer == 2001 then
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[1];
					global.wares_flag = 0;
					wares = "armor";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2002 then
					global.wares_flag = 0;
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[3];
					wares = "melee";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2003 then
					global.wares_flag = 0;
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[5];
					wares = "ranged";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2004 then
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[11];
					wares = "alchemy";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2005 then
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[9];
					wares = "criminal";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2006 then
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[7];
					wares = "magic";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2007 then
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[13];
					wares = "guild";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2008 then
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[15];
					wares = "books";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2009 then
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[17];
					wares = "food";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2010 then
					global.wares_flag = 1;
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[2];
					wares = "armor";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2011 then
					global.wares_flag = 1;
					current_shop = chars_mobs_npcs[victim].shop;
					current_bar = traders[current_shop].bars[4];
					wares = "melee";
					game_status = "buying";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer == 2101 then
					game_status = "showinventory";
					global.showinventory_flag = "sell";
					calendar.add_time_interval(calendar.delta_trading);
					clearText();
					loveframes.util.RemoveAll();
				elseif chats.rules[index][current_questions[linenumber]].answer >= 3001 and chats.rules[index][current_questions[linenumber]].answer <= 4001 then --FIXME all to chats functions
					local tmp = math.ceil(chats.rules[index][current_questions[linenumber]].answer/1000-2);
					local index = chats.rules[index][current_questions[linenumber]].answer - 3000*tmp;
					local skill = skills[index];
					local skill_lvl_name = chars_mombs_npcs[current_mob]["lvl_" .. skill];
					local skill_num_name = chars_mombs_npcs[current_mob]["num_" .. skill];
					local price = math.ceil(math.max(1000,10^tmp));
					price = helpers.recountPrice(price,current_mob,victim);
					if chars_mobs_npcs[current_mob].skill_lvl_name == tmp and chars_mobs_npcs[current_mob].skill_num_name >= points_for_upgrade[tmp] and helpers.payGold() then
						chars_mobs_npcs[current_mob].skill_lvl_name = tmp+1;
					end;
					clearText();
				elseif chats.rules[index][current_questions[linenumber]].answer >= 5000 and chats.rules[index][current_questions[linenumber]].answer <= 5999 then --argumentation several mindfields per npc, so index = x-5000
					global.mindhero_x = 5;
					global.mindhero_y = 5;
					global.mindway = {};
					chat_log = {};
					local index = chats.rules[index][current_questions[linenumber]].answer - 5000;
					global.status = "mindgame";
					calendar.add_time_interval(calendar.delta_mindgame);
					if index == 0 then
						index = chars_mobs_npcs[victim]["personality"]["current"].mindmap;
					end;
					mindgame.updateFlags();
					mindgame_log = {};
					mindgame.map = mindmaps[index]; --FIXME NEED RESET
					global.threats_level = 0;
					global.mindgold = 0;
					global.mindgold_array = {};
					global.goldmissle = 1;
					global.minddrink_array = {};
					global.drinkmissle = 1;
					global.secrets_pull = party.secrets;
					global.jokes_pull = party.jokes;
					global.nlps_pull = party.nlps;
					global.music_pull = helpers.musicPull();
					global.affronts_pull = party.affronts;
					global.threats_pull = party.threats;
					global.connections_pull = party.connections;
					mindgame.moneysums = mindgame.calcGoldSums();
					for i=1,7 do
						local _gold = mindgame.moneysums[i];
						if party.gold >= _gold then
							table.insert(global.mindgold_array,_gold);
						end;
					end;
					for i=1,#chars_mobs_npcs[current_mob]["inventory_list"] do
						if chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid == raws.buz then
							table.insert(global.minddrink_array,{itemid=i,spriteid=chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid,typ="alcho",price=1});
						end;
					end;
					mindmissle = false;
					global.current_threat = 1;
					global.current_secret = 1;
					global.current_joke = 1;
					global.current_nlp = 1;
					global.current_connection = 1;
					global.mindgame_attempts = mindgame.attempts[chars_mobs_npcs[current_mob].lvl_diplomacy] + math.ceil(chars_mobs_npcs[current_mob].chr/20);
					global.mindgame_counter = 0;
					game_status = "mindgame";
					draw.mindgameButtons();
				elseif chats.rules[index][current_questions[linenumber]].answer == 7001 then
					loveframes.util.RemoveAll();
					chars_mobs_npcs[victim]["personality"]["current"] = chars_mobs_npcs[victim]["personality"]["default"];
					fractions[chars_mobs_npcs[victim].fraction].party = fractions[chars_mobs_npcs[victim].fraction].party - math.ceil(5 + (100-chars_mobs_npcs[current_mob].chr)/10);
					game_status = "neutral";
					helpers.addToActionLog(helpers.mobName(victim) .. lognames.actions.feelangry[chars_mobs_npcs[victim].gender]);
					--global.status = "battle"; --time to charm stun sleep paralyse
					--call guards
					--may be per party?
				elseif chats.rules[index][current_questions[linenumber]].answer == 7777 then
					loveframes.util.RemoveAll();
					chars_mobs_npcs[victim]["personality"]["current"] = chars_mobs_npcs[victim]["personality"]["default"];
					game_status = "neutral";
					helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.suspicionsdiminished[chars_mobs_npcs[current_mob].gender]);
				end;
			else
				global_answer = "";
			end;
		end;
	end;

	if button == "l"  and game_status == "warbook" then
		blockturn = 10;
		local x,y = helpers.centerObject(media.images.sbook);
		missle_type = helpers.bookCircles(page);
		if missle_type then
			helpers.ifTrickIsCastable ();
		end;
		if mX>x+8 and mX<x+100 and mY>y and mY<y+50 then
			utils.printDebug("sword axe falgpole");
			page=1;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+21 and mX<x+100 and mY>y+55 and mY<y+115 then
			utils.printDebug("crushing staff dagger");
			page=2;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+24 and mX<x+100 and mY>y+120 and mY<y+180 then
			utils.printDebug("unarmed dodging shield");
			page=3;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+18 and mX<x+100 and mY>y+185 and mY<y+240 then
			utils.printDebug("bow crossbow throwing");
			page=4;
			utils.playSfx(media.sounds.bookpage, 1);
		end;
	end;

	if button == "l"  and game_status == "spellbook" then
		blockturn = 10;
		local x,y = helpers.centerObject(media.images.sbook);
		missle_type = helpers.bookCircles(page);
		if missle_type then
			helpers.ifSpellIsCastable ("spellbook");
		end;
		--140,180
		if mX>x+8 and mX<x+100 and mY>y and mY<y+50 then
			utils.printDebug("school of fire");
			page=1;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+21 and mX<x+100 and mY>y+55 and mY<y+115 then
			utils.printDebug("school of air");
			page=2;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+24 and mX<x+100 and mY>y+120 and mY<y+180 then
			utils.printDebug("school of water");
			page=3;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+18 and mX<x+100 and mY>y+185 and mY<y+240 then
			utils.printDebug("school of earth");
			page=4;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+21 and mX<x+100 and mY>y+245 and mY<y+300 then
			utils.printDebug("school of conflux");
			page=10;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+18 and mX<x+100 and mY>y+305 and mY<y+360 then
			utils.printDebug("school of darkness");
			page=9;
			utils.playSfx(media.sounds.bookpage, 1)
		elseif  mX>x+18 and mX<x+100 and mY>y+405 and mY<y+420 then
			utils.printDebug("school of distortion");
			page=13;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif mX>x+901 and mX<x+978 and mY>y and mY<y+50 then
			utils.printDebug("school of body");
			page=5;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+901 and mX<x+978 and mY>y+55 and mY<y+115 then
			utils.printDebug("school of mind");
			page=6;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+901 and mX<x+978 and mY>y+120 and mY<y+180 then
			utils.printDebug("school of spirit");
			page=7;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+901 and mX<x+978 and mY>y+185 and mY<y+240 then
			utils.printDebug("school of life");
			page=11;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+901 and mX<x+978 and mY>y+245 and mY<y+300 then
			utils.printDebug("school of conjuction");
			page=12;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+901 and mX<x+978 and mY>y+305 and mY<y+360 then
			utils.printDebug("school of light");
			page=8;
			utils.playSfx(media.sounds.bookpage, 1);
		elseif  mX>x+901 and mX<x+978 and mY>y+365 and mY<y+420 then
			utils.printDebug("school of holyness");
			page=14;
			utils.playSfx(media.sounds.bookpage, 1);
		end ;
	end;
--/spellbook
	if button == "l" and game_status == "sensing" and (not helpers.cursorAtMob (cursor_world_x,cursor_world_y) or not trace.arrowStatus(current_mob)) and blockturn==0 and mY>=40 and mY<=800 then
		helpers.turnMob(current_mob);
	end;
	if button == "l" and game_status == "inventory" and holding_smth > 0  then --equip item
		local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
--right hand
		if helpers.inSlot("rh") and chars_mobs_npcs[current_mob]["equipment"].rh == 0
		and (inventory_ttx[list[holding_smth].ttxid].class == "sword" or inventory_ttx[list[holding_smth].ttxid].class == "axe" or inventory_ttx[list[holding_smth].ttxid].class == "staff" or inventory_ttx[list[holding_smth].ttxid].class == "flagpole" or inventory_ttx[list[holding_smth].ttxid].class == "crushing" or inventory_ttx[list[holding_smth].ttxid].class == "dagger")
		and (inventory_ttx[list[holding_smth].ttxid].subclass ~= "thsword" or chars_mobs_npcs[current_mob]["equipment"].lh==0)
		and (inventory_ttx[list[holding_smth].ttxid].subclass ~= "poleaxe"  or chars_mobs_npcs[current_mob]["equipment"].lh==0)
		and (inventory_ttx[list[holding_smth].ttxid].subclass ~= "staff"  or chars_mobs_npcs[current_mob]["equipment"].lh==0)
		and (inventory_ttx[list[holding_smth].ttxid].subclass ~= "flagpole" or chars_stats[current_mob].lvl_flagpoles>=3)
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "cantbeequiped"
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "none"
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "alchemy"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local hasskill = 0;
			local tmpskill = "chars_stats[" .. current_mob .. "].lvl_" .. inventory_ttx[list[holding_smth].ttxid].skill;
			local tmpskillname=inventory_ttx[list[holding_smth].ttxid].skill;
			local tmpskillname2=loadstring("return " .. "lognames.skillsr." .. tmpskillname)();
			local needskill = loadstring("return " .. tmpskill)();
			if chars_mobs_npcs[current_mob]["equipment"].rh == 0 and needskill > 0
			and (tmpskillname == "sword" or tmpskillname == "axe" or tmpskillname == "flagpole" or tmpskillname == "crushing"
			or tmpskillname == "dagger" or tmpskillname == "stuff") then
				local tmphold = chars_mobs_npcs[current_mob]["equipment"].rh
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].rh = holding_smth
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].rh = #chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				holding_smth = 0;
				sfx.soundsOfInv("put",dragfrom);
			elseif chars_mobs_npcs[current_mob]["equipment"].rh ~= 0 then
				if slot == 0 then
					inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
					sfx.soundsOfInv("put",dragfrom);
					holding_smth = 0;
				else
				end;
			elseif needskill == 0 then
				helpers.noSkill();
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot=0;
			end;
		end;
--ranged
		if helpers.inSlot("ranged") and chars_mobs_npcs[current_mob]["equipment"].ranged == 0
		and (inventory_ttx[list[holding_smth].ttxid].class == "bow" or inventory_ttx[list[holding_smth].ttxid].class == "crossbow" or inventory_ttx[list[holding_smth].ttxid].class == "gun" or inventory_ttx[list[holding_smth].ttxid].class == "blaster" or inventory_ttx[list[holding_smth].ttxid].class == "wand")
		--and inventory_ttx[list[holding_smth].ttxid].skill ~= "cantbeequiped"
		--and inventory_ttx[list[holding_smth].ttxid].skill ~= "none"
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "alchemy"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local hasskill = 0;
			local tmpskill = "chars_stats[" .. current_mob .. "].lvl_" .. inventory_ttx[list[holding_smth].ttxid].skill;
			local tmpskillname=inventory_ttx[list[holding_smth].ttxid].skill;
			local tmpskillname2=loadstring("return " .. "lognames.skillsr." .. tmpskillname)();
			--local needskill = loadstring("return " .. tmpskill)();
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class;
			local needskill = nil;
			if tmpclass ~= "wand" then
				needskill = chars_stats[current_mob]["lvl_" .. inventory_ttx[list[holding_smth].ttxid].skill];
			else
				needskill = "none";
			end;
			if chars_mobs_npcs[current_mob]["equipment"].ranged == 0 and (needskill == "none" or needskill > 0)
			and (tmpskillname == "bow" or tmpskillname == "crossbow" or tmpskillname == "firearms" or tmpskillname == "blaster" or tmpskillname == "none")
			and (tmpclass == "bow" or tmpclass == "crossbow" or tmpclass == "firearms" or tmpclass == "blaster" or tmpclass == "wand")
			and (chars_mobs_npcs[current_mob]["equipment"].ammo == 0 or inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].ttxid].skill == inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].ttxid].skill)
			then
				local tmphold = chars_mobs_npcs[current_mob]["equipment"].ranged;
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].ranged = holding_smth;
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].ranged = #chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].ranged ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif needskill == 0 then
				helpers.noSkill();
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot = 0;
			end;
		end;
--ammo
		if helpers.inSlot("ammo") and chars_mobs_npcs[current_mob]["equipment"].ammo == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "ammo"
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "cantbeequiped"
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "none"
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "alchemy"
		and list[holding_smth].r == 1 then
			local hasskill = 0;
			local tmpskill = "chars_stats[" .. current_mob .. "].lvl_" .. inventory_ttx[list[holding_smth].ttxid].skill;
			local tmpskillname=inventory_ttx[list[holding_smth].ttxid].skill;
			local tmpskillname2=loadstring("return " .. "lognames.skillsr." .. tmpskillname)();
			local needskill = loadstring("return " .. tmpskill)();
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class;
			if chars_mobs_npcs[current_mob]["equipment"].ammo == 0 and needskill > 0 and tmpclass == "ammo"
			and (chars_mobs_npcs[current_mob]["equipment"].ranged == 0 or inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].ttxid].skill == inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].ttxid].skill) then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].ammo;
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].ammo = holding_smth;
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].ammo = #chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif needskill > 0 and chars_mobs_npcs[current_mob]["equipment"].ammo ~= 0  then
				if list[holding_smth].ttxid == list[tmp12].ttxid and list[holding_smth].w == list[tmp12].w and list[holding_smth].e == list[tmp12].e and list[holding_smth].r == list[tmp12].r then
					list[chars_mobs_npcs[current_mob]["equipment"].ammo].q = list[chars_mobs_npcs[current_mob]["equipment"].ammo].q + list[holding_smth].q;
					table.remove(list,holding_smth);
					helpers.renumber(holding_smth,current_mob);
				else
					inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif needskill == 0 then
				helpers.noSkill();
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot = 0;
			end;
		end;
--armor
		if helpers.inSlot("armor") and chars_mobs_npcs[current_mob]["equipment"].armor == 0
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "cantbeequiped"
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "none"
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "alchemy"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local hasskill = 0;
			local tmpskill = "chars_stats[" .. current_mob .. "].lvl_" .. inventory_ttx[list[holding_smth].ttxid].skill;
			local tmpskillname=inventory_ttx[list[holding_smth].ttxid].skill;
			local tmpskillname2=loadstring("return " .. "lognames.skillsr." .. tmpskillname)();
			local needskill = loadstring("return " .. tmpskill)();
			if chars_mobs_npcs[current_mob]["equipment"].armor == 0 and needskill > 0
			and (tmpskillname == "leather" or tmpskillname == "chainmail" or tmpskillname == "plate") then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].armor;
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].armor = holding_smth;
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].armor = #chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].armor ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif needskill == 0 then
				helpers.noSkill();
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot = 0;
			end;
		end;
--left hand
		if helpers.inSlot("lh") and chars_mobs_npcs[current_mob]["equipment"].lh == 0
		and (chars_mobs_npcs[current_mob]["equipment"].rh==0 or inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].ttxid].subclass ~= "thsword")
		and (chars_mobs_npcs[current_mob]["equipment"].rh==0 or inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].ttxid].subclass ~= "poleaxe")
		and (chars_mobs_npcs[current_mob]["equipment"].rh==0 or inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].ttxid].subclass ~= "staff")
		and (chars_mobs_npcs[current_mob]["equipment"].rh==0 or (inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].ttxid].subclass ~= "flagpole" or chars_stats[current_mob].lvl_flagpoles >= 3) )
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "cantbeequiped"
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "none"
		and inventory_ttx[list[holding_smth].ttxid].skill ~= "alchemy"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local hasskill = 0;
			local tmpskill = "chars_stats[" .. current_mob .. "].lvl_" .. inventory_ttx[list[holding_smth].ttxid].skill;
			local tmpskillname=inventory_ttx[list[holding_smth].ttxid].skill;
			local tmpskillname2=loadstring("return " .. "lognames.skillsr." .. tmpskillname)();
			local needskill = loadstring("return " .. tmpskill)();
			if chars_mobs_npcs[current_mob]["equipment"].lh == 0 and needskill > 0
			and (tmpskillname == "shield" or (tmpskillname == "dagger" and chars_stats[current_mob].lvl_dagger >= 3) or (tmpskillname == "sword" and chars_stats[current_mob].lvl_sword >= 4 and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].ttxid].subclass ~= "thsword")) then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].lh;
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].lh = holding_smth
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].lh = #chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].lh ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif needskill == 0 then
				helpers.noSkill();
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot = 0;
			end;
		end;
--helm
		if helpers.inSlot("head") and chars_mobs_npcs[current_mob]["equipment"].head == 0
		and (inventory_ttx[list[holding_smth].ttxid].class == "helm" or inventory_ttx[list[holding_smth].ttxid].class == "hat" or inventory_ttx[list[holding_smth].ttxid].class == "crown")
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class;
			local tmpsubclass = inventory_ttx[list[holding_smth].ttxid].subclass;
			if chars_mobs_npcs[current_mob]["equipment"].head==0 and chars_stats[current_mob].horns == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].head;
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].head = holding_smth;
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].head=#chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].head ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_stats[current_mob].horns >= 0 then
				helpers.noSkillToUseThisItem();
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot = 0;
			end;
		 end;
--boots
		if helpers.inSlot("boots") and chars_mobs_npcs[current_mob]["equipment"].boots == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "boots"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class;
			local tmpsubclass = inventory_ttx[list[holding_smth].ttxid].subclass;
			if chars_mobs_npcs[current_mob]["equipment"].boots == 0 and chars_stats[current_mob].feet == 2 and chars_stats[current_mob].hoofs == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].boots;
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].boots = holding_smth;
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].boots=#chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].boots ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_stats[current_mob].feet~=2 or chars_stats[current_mob].hoofs > 0 then
				helpers.noSkillToUseThisItem();
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot=0;
			end;
		end;
 --gloves
		if helpers.inSlot("gloves") and chars_mobs_npcs[current_mob]["equipment"].gloves == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "gloves"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class;
			local tmpsubclass = inventory_ttx[list[holding_smth].ttxid].subclass;
			if chars_mobs_npcs[current_mob]["equipment"].gloves == 0 and #chars_stats[current_mob].arms == 2 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].gloves;
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].gloves = holding_smth;
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].gloves = #chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].gloves ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot = 0;
			end;
		end;
--cloak
		if helpers.inSlot("cloak") and chars_mobs_npcs[current_mob]["equipment"].cloak == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "cloak"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class;
			local tmpsubclass = inventory_ttx[list[holding_smth].ttxid].subclass;
			if chars_mobs_npcs[current_mob]["equipment"].cloak == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].cloak;
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].cloak = holding_smth;
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].cloak = #chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].cloak ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot = 0;
			end;
		end;
--belt
		if helpers.inSlot("belt")
		and inventory_ttx[list[holding_smth].ttxid].class == "belt"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class;
			local tmpsubclass = inventory_ttx[list[holding_smth].ttxid].subclass;
			if chars_mobs_npcs[current_mob]["equipment"].belt == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].belt;
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].belt = holding_smth;
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].belt = #chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].belt ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot = 0;
			end;
		end;
--amulet
		if helpers.inSlot("amulet") and chars_mobs_npcs[current_mob]["equipment"].amulet == 0
		and inventory_ttx[list[holding_smth].ttxid].subclass == "amulet"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class;
			local tmpsubclass = inventory_ttx[list[holding_smth].ttxid].subclass;
			if chars_mobs_npcs[current_mob]["equipment"].head == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].amulet
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].amulet = holding_smth;
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].amulet = #chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].head~=0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth=0;
			end;
		end;
--art
		if helpers.inSlot("art") and chars_mobs_npcs[current_mob]["equipment"].art == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "art"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class;
			local tmpsubclass = inventory_ttx[list[holding_smth].ttxid].subclass;
			if chars_mobs_npcs[current_mob]["equipment"].art == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].art;
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].art = holding_smth;
				elseif dragfrom == "bag" then
					from_bag_to_equip();
					chars_mobs_npcs[current_mob]["equipment"].art = #chars_mobs_npcs[current_mob]["inventory_list"];
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].art ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			end;
		end;
--rings
		if helpers.inSlot("ring1") and chars_mobs_npcs[current_mob]["equipment"].ring1 == 0
		and inventory_ttx[list[holding_smth].ttxid].subclass == "ring"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class
			if chars_mobs_npcs[current_mob]["equipment"].ring1 == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].ring1
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].ring1 = holding_smth
				elseif dragfrom == "bag" then
					from_bag_to_equip()
					chars_mobs_npcs[current_mob]["equipment"].ring1 = #chars_mobs_npcs[current_mob]["inventory_list"]
				end
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].ring1 ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			end;
		end;

		if  helpers.inSlot("ring2") and chars_mobs_npcs[current_mob]["equipment"].ring2
		and inventory_ttx[list[holding_smth].ttxid].subclass == "ring"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class
			if chars_mobs_npcs[current_mob]["equipment"].ring2 == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].ring2
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].ring2 = holding_smth
				elseif dragfrom == "bag" then
					from_bag_to_equip()
					chars_mobs_npcs[current_mob]["equipment"].ring2 = #chars_mobs_npcs[current_mob]["inventory_list"]
				end
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].ring2 ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			end;
		end;

		if  helpers.inSlot("ring3") and chars_mobs_npcs[current_mob]["equipment"].ring3
		and inventory_ttx[list[holding_smth].ttxid].subclass == "ring"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class
			if chars_mobs_npcs[current_mob]["equipment"].ring3 == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].ring3
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].ring3 = holding_smth
				elseif dragfrom == "bag" then
					from_bag_to_equip()
					chars_mobs_npcs[current_mob]["equipment"].ring3 = #chars_mobs_npcs[current_mob]["inventory_list"]
				end
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].ring3 ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			end;
		end;

		if helpers.inSlot("ring4") and chars_mobs_npcs[current_mob]["equipment"].ring4
		and inventory_ttx[list[holding_smth].ttxid].subclass == "ring"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class
			if chars_mobs_npcs[current_mob]["equipment"].ring4 == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].ring4
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].ring4 = holding_smth
				elseif dragfrom == "bag" then
					from_bag_to_equip()
					chars_mobs_npcs[current_mob]["equipment"].ring4 = #chars_mobs_npcs[current_mob]["inventory_list"]
				end
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].ring4 ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			end;
		end;

		if helpers.inSlot("ring5") and chars_mobs_npcs[current_mob]["equipment"].ring5
		and inventory_ttx[list[holding_smth].ttxid].subclass == "ring"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class
			if chars_mobs_npcs[current_mob]["equipment"].ring5 == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].ring5
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].ring5 = holding_smth
				elseif dragfrom == "bag" then
					from_bag_to_equip()
					chars_mobs_npcs[current_mob]["equipment"].ring5 = #chars_mobs_npcs[current_mob]["inventory_list"]
				end
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].ring5 ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			end;
		end;

		if helpers.inSlot("ring6") and chars_mobs_npcs[current_mob]["equipment"].ring6
		and inventory_ttx[list[holding_smth].ttxid].subclass == "ring"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			local tmpclass = inventory_ttx[list[holding_smth].ttxid].class
			if chars_mobs_npcs[current_mob]["equipment"].ring6 == 0 then
				tmphold = chars_mobs_npcs[current_mob]["equipment"].ring6
				if dragfrom == "char" then
					chars_mobs_npcs[current_mob]["equipment"].ring6 = holding_smth
				elseif dragfrom == "bag" then
					from_bag_to_equip()
					chars_mobs_npcs[current_mob]["equipment"].ring6 = #chars_mobs_npcs[current_mob]["inventory_list"]
				end
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			elseif chars_mobs_npcs[current_mob]["equipment"].ring6 ~= 0 then
				inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			end;
		end;
	end;
--/equip
--picklocking equip
	if button == "l" and game_status == "picklocking" and holding_smth > 0 then
		local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
		if helpers.inSlot("key") and picklock[current_mob].key == 0
		and (inventory_ttx[list[holding_smth].ttxid].class == "key" or inventory_ttx[list[holding_smth].ttxid].class == "key")
		and list[holding_smth].q > 0 and list[holding_smth].r == 1
		and picklock[current_mob].key == 0 then
			if dragfrom == "char" then
				picklock[current_mob].key = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				picklock[current_mob].key = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;
--add tool to picklocking
		if helpers.inSlot("picklock") and picklock[current_mob].picklock == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "picklock"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1
		and picklock[current_mob].picklock == 0
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				picklock[current_mob].picklock = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				picklock[current_mob].picklock = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth=0;
			slot=0;
		end;
--add tool to picklocking
		if helpers.inSlot("traptool") and picklock[current_mob].traptool == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "traptool"
		and picklock[current_mob].traptool==0
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom=="char" then
				picklock[current_mob].traptool=holding_smth;
			elseif dragfrom=="bag" then
				from_bag_to_equip();
				picklock[current_mob].traptool=#chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth=0;
			slot=0;
		end;
--add tool to picklocking
		if helpers.inSlot("forcer") and picklock[current_mob].forcer == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "forcer"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1
		and picklock[current_mob].forcer==0 and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom=="char" then
				picklock[current_mob].forcer=holding_smth;
			elseif dragfrom=="bag" then
				from_bag_to_equip();
				picklock[current_mob].forcer=#chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth=0;
			slot=0;
		end;
	end;
--/piclocking equip
--alchemy equip
--add components to alchemy lab
	if button == "l" and game_status == "alchemy" and holding_smth > 0 then
		local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
		if helpers.inSlot("tool1") --anyone can use cauldron
		and alchlab[current_mob].tool1==0
		and inventory_ttx[list[holding_smth].ttxid].class == "alchtool"
		and inventory_ttx[list[holding_smth].ttxid].subclass == "cauldron"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1
		then
			if dragfrom=="char" then
				alchlab[current_mob].tool1=holding_smth;
			elseif dragfrom=="bag" then
				from_bag_to_equip();
				alchlab[current_mob].tool1=#chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth=0;
			slot=0;
		end;
--everyone can equip boiler but only an alchemist can use brazier and reactor
		if helpers.inSlot("tool1")
		and alchlab[current_mob].tool1 == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "alchtool"
		and (inventory_ttx[list[holding_smth].ttxid].subclass == "reactor"
		or inventory_ttx[list[holding_smth].ttxid].subclass == "brazier")
		and chars_mobs_npcs[current_mob].lvl_alchemy > 0
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom=="char" then
				alchlab[current_mob].tool1=holding_smth;
			elseif dragfrom=="bag" then
				from_bag_to_equip();
				alchlab[current_mob].tool1=#chars_mobs_npcs[current_mob]["inventory_list"];
			end
			sfx.soundsOfInv("put",dragfrom);
			holding_smth=0;
			slot=0;
		end;
--alembic
		if helpers.inSlot("tool3")
		and alchlab[current_mob].tool3 == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "alchtool"
		and inventory_ttx[list[holding_smth].ttxid].subclass == "alembic"
		and chars_mobs_npcs[current_mob].lvl_alchemy>0
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].tool3 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].tool3=#chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth=0;
			slot=0;
		end;
--mill
		if helpers.inSlot("tool2")
		and alchlab[current_mob].tool2 == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "alchtool"
		and inventory_ttx[list[holding_smth].ttxid].subclass == "mill"
		and chars_mobs_npcs[current_mob].lvl_alchemy > 0
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].tool2 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].tool2=#chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;
--set
		if helpers.inSlot("tool4")
		and alchlab[current_mob].tool4 == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "alchtool"
		and inventory_ttx[list[holding_smth].ttxid].subclass == "alchtools1"
		and chars_mobs_npcs[current_mob].lvl_alchemy > 0
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].tool4 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip()
				alchlab[current_mob].tool4=#chars_mobs_npcs[current_mob]["inventory_list"];
			end
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;
--set
		if helpers.inSlot("tool5")
		and alchlab[current_mob].tool5 == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "alchtool"
		and inventory_ttx[list[holding_smth].ttxid].subclass == "alchtools2"
		and chars_mobs_npcs[current_mob].lvl_alchemy > 0
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].tool5 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].tool5 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;
--set
		if helpers.inSlot("tool6")
		and alchlab[current_mob].tool6 == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "alchtool"
		and inventory_ttx[list[holding_smth].ttxid].subclass == "alchtools3"
		and chars_mobs_npcs[current_mob].lvl_alchemy > 0
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].tool6 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].tool6=#chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;
-- components
		if helpers.inSlot("comp7") --anyone can use mills
		and alchlab[current_mob].comp7 == 0 and alchlab[current_mob].comp8 == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "component"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].comp7 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].comp7 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;

		if helpers.inSlot("comp8")
		and alchlab[current_mob].comp8 == 0 and alchlab[current_mob].comp7 == 0 and alchlab[current_mob].comp9 == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "component"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].comp8 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].comp8 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;

		if helpers.inSlot("comp9")
		and alchlab[current_mob].comp9 == 0 and alchlab[current_mob].comp8 == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "component"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].comp9 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].comp9=#chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth=0;
			slot=0;
		end;
--bottle
		if helpers.inSlot("bottle1")
		and alchlab[current_mob].bottle1 == 0
		and inventory_ttx[list[holding_smth].ttxid].class == "bottle"
		and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].bottle1 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].bottle1 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;

		if helpers.inSlot("bottle2")
		and (inventory_ttx[list[holding_smth].ttxid].class == "bottle" or inventory_ttx[list[holding_smth].ttxid].class == "potion")
		and alchlab[current_mob].bottle2 == 0 and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].bottle2 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].bottle2 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;

		if helpers.inSlot("bottle3")
		and (inventory_ttx[list[holding_smth].ttxid].class == "bottle" or inventory_ttx[list[holding_smth].ttxid].class == "potion")
		and alchlab[current_mob].bottle3 == 0 and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].bottle3 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].bottle3 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;

		if helpers.inSlot("comp1")
		and alchlab[current_mob].comp1 == 0 and inventory_ttx[list[holding_smth].ttxid].class == "component" and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].comp1 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].comp1 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;

		if helpers.inSlot("comp2")
		and alchlab[current_mob].comp2 == 0 and inventory_ttx[list[holding_smth].ttxid].class == "component" and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].comp2 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].comp2 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;

		if helpers.inSlot("comp3")
		and alchlab[current_mob].comp3 == 0 and inventory_ttx[list[holding_smth].ttxid].class == "component" and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].comp3 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].comp3 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;

		if helpers.inSlot("comp4")
		and alchlab[current_mob].comp4 == 0 and inventory_ttx[list[holding_smth].ttxid].class == "component" and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].comp4 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].comp4 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;

		if helpers.inSlot("comp5")
		and alchlab[current_mob].comp5 == 0 and inventory_ttx[list[holding_smth].ttxid].class == "component" and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].comp5 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].comp5 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;

		if helpers.inSlot("comp6")
		and alchlab[current_mob].comp6 == 0 and inventory_ttx[list[holding_smth].ttxid].class == "component" and list[holding_smth].q > 0 and list[holding_smth].r == 1 then
			if dragfrom == "char" then
				alchlab[current_mob].comp6 = holding_smth;
			elseif dragfrom == "bag" then
				from_bag_to_equip();
				alchlab[current_mob].comp6 = #chars_mobs_npcs[current_mob]["inventory_list"];
			end;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth = 0;
			slot = 0;
		end;
		if holding_smth > 0 and list[holding_smth].q == 0 then
			helpers.addToActionLog(lognames.actions.itembroken);
		end;
		if holding_smth > 0 and list[holding_smth].r == 0 then
			helpers.addToActionLog(lognames.actions.itemnotid);
		end;
		helpers.findNonFreeSpaceAtInv (current_mob,dragfrom,false,false);
	end;
	
	--FIXME add empty area
	selected_portrait,trash = helpers.select_portrait();
	if button == "l" and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting") and holding_smth > 0 --wrong area
	and selected_portrait ~= current_mob
	and (mX < x or mX > x + media.images.inv1:getWidth () or mY < y-50 or mY > y-50+media.images.inv1:getHeight ())
	then
		utils.printDebug("wrong area");
		local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
		local selected_char,trash = helpers.select_portrait()
		if tmp_bagid > 0 then
		--if tmp_bagid > 0 and selected_char > 0 and selected_char ~= current_mob then
			--selected_char = tmp_bagid;
			--find_free_space_at_inv();
		--else
			if slot == 0 then
				if bag[tmp_bagid][inv_quad_x][inv_quad_y] == 0 then
					bag[tmp_bagid][inv_quad_x][inv_quad_y] = holding_smth;
					helpers.repackBag();
				else -- splitted ammo
					local tmp12 = bag[tmp_bagid][inv_quad_x][inv_quad_y];
					list[tmp12].q = list[tmp12].q + list[holding_smth].q;
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			else
				chars_mobs_npcs[current_mob]["equipment"].slot = holding_smth;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
			end;
		end;
	end;



	if button == "l" and (game_status == "inventory" or game_status == "alchemy"  or game_status == "picklocking" or game_status == "crafting" ) and holding_smth>0
	and mX>inv_add_x and mX<=inv_add_x+11*32 and mY>inv_add_y and mY<=inv_add_y+15*32 then
		some_crap_under_cursor=0;
		inv_quad_new_x = math.ceil((mX-inv_add_x)/32);
		inv_quad_new_y = math.ceil((mY-inv_add_y)/32);
		local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
		if inv_quad_new_y > 15-inventory_ttx[list[holding_smth].ttxid].h then
			inv_quad_new_y = 15-inventory_ttx[list[holding_smth].ttxid].h + 1;
		end;
		if inv_quad_new_x > 11-inventory_ttx[list[holding_smth].ttxid].w then
			inv_quad_new_x = 11-inventory_ttx[list[holding_smth].ttxid].w+1;
		end;
		for a = inv_quad_new_x,(inv_quad_new_x+inventory_ttx[list[holding_smth].ttxid].w-1) do
			for b = inv_quad_new_y,(inv_quad_new_y+inventory_ttx[list[holding_smth].ttxid].h-1) do
				if inventory_bag[current_mob][b][a] > 0 then
					some_crap_under_cursor = 1;
				end;
			end;
		end;
		sorttarget = oldsorttarget;
		local tmp12 = bag[tmp_bagid][inv_quad_new_y][inv_quad_new_x];
		if tmp12 > 0 and tmp12 < 10000 then
		elseif tmp12>10000 then
		tmp_s=tostring(tmp12);
		if (tmp12-10000)<10 then
			tmpxi = tonumber(string.sub(tmp_s, 5,6));
		else
			tmpxi = tonumber(string.sub(tmp_s, 4,6));
		end
			tmpyi = math.floor((tmp12-tmpxi)/10000);
			tmp12 = bag[tmp_bagid][tmpxi][tmpyi];
		end;
		if  some_crap_under_cursor == 0 then
			if dragfrom == "char" then
				bag[tmp_bagid][inv_quad_new_y][inv_quad_new_x] = holding_smth -- table 90°!
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				find_nonfree_space_at_inv();
				slot = 0;
			end;
			--bagid = 0;
			if dragfrom == "bag" then
				local bag_found = false;
				--[[for j=1, #bags_list do
					if chars_mobs_npcs[current_mob].x == bags_list[j].x and chars_mobs_npcs[current_mob].y == bags_list[j].y and not bag_found then -- FIXME: bag found func
						bagid = j;
						bag_found = true;
					end
				end]]

				bagid = helpers.whatBag(current_mob)
				if not bagid then
					bagid = helpers.trapInFrontOf(current_mob)
				end;
				if bagid then
					bag_found = true;
				end;

				table.insert(chars_mobs_npcs[current_mob]["inventory_list"], {ttxid=bags_list[bagid][holding_smth].ttxid, q=bags_list[bagid][holding_smth].q,w=bags_list[bagid][holding_smth].w,e=bags_list[bagid][holding_smth].e,r=bags_list[bagid][holding_smth].r,h=bags_list[bagid][holding_smth].h})
				helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.taken[chars_mobs_npcs[current_mob].gender] .. inventory_ttx[bags_list[bagid][holding_smth].ttxid].title .. helpers.takenFromWhere(bags_list[bagid].typ));
				inventory_bag[current_mob][inv_quad_new_y][inv_quad_new_x] = #chars_mobs_npcs[current_mob]["inventory_list"];
				--bags[bagid][bags_list[bagid].x][bags_list[bagid].y] = 0;
				table.remove(bags_list[bagid],holding_smth)
				for i=1,11 do
					for h=1,15 do
						if bags[bagid][h][i] > holding_smth and bags[bagid][h][i] > 0 and bags[bagid][h][i] < 10000 then
							bags[bagid][h][i] = bags[bagid][h][i]-1;
						end;
					end;
				end;
				sorttarget = "bag";
				find_nonfree_space_at_inv();
				sorttarget = "char";
				find_nonfree_space_at_inv();
				if #bags_list[bagid]==0 and bags_list[bagid].typ == "bag" then
					table.remove(bags_list,bagid);
					table.remove(bags,bagid);
					bagremoved=1;
				end;
				sfx.soundsOfInv("put",dragfrom);
				holding_smth=0;
				slot=0 ;
			end;
		elseif some_crap_under_cursor ~= 0 and tmp12 > 0 and inventory_ttx[list[holding_smth].ttxid].class == "ammo" and list[holding_smth].ttxid == list[tmp12].ttxid and list[holding_smth].w == list[tmp12].w and list[holding_smth].e == list[tmp12].e and list[holding_smth].r == list[tmp12].r and list[holding_smth].h == list[tmp12].h then
			list[tmp12].q = list[tmp12].q + list[holding_smth].q;
			table.remove(list,holding_smth);
			helpers.renumber (holding_smth,current_mob);
			holding_smth = 0;
		elseif some_crap_under_cursor ~= 0 then
			if dragfrom == "char" then
				if slot ~= 0 then
					chars_mobs_npcs[current_mob]["equipment"][slot] = holding_smth;
				else
					inventory_bag[current_mob][inv_quad_x][inv_quad_y] = holding_smth;
				end;
			else
				bags[bagid][inv_quad_x][inv_quad_y] = holding_smth;
			end;
			holding_smth=0;
		end;
	end;
	 -- drop to a bag/ground FIXME (-picklock)
	if button == "l" and (game_status == "inventory" or game_status == "alchemy"  or game_status == "picklocking" or game_status == "crafting") and holding_smth > 0
	and mX > inv_add_x+inv_part2
	and mX <= inv_add_x+11*32+inv_part2
	and mY > inv_add_y
	and mY <= inv_add_y+15*32
	and (not helpers.BagNear(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y) or (helpers.BagNear(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y) and not bags_list[bagid].locked))
	then
	print("DROP");
		inv_quad_new_x = math.ceil((mX-inv_part2-inv_add_x)/32);
		inv_quad_new_y = math.ceil((mY-inv_add_y)/32);
		tmp_quad_x = inv_quad_new_x;
		tmp_quad_y = inv_quad_new_y;
		local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false,current_mob);
		if inv_quad_new_y > 15-inventory_ttx[list[holding_smth].ttxid].h then
			inv_quad_new_y = 15-inventory_ttx[list[holding_smth].ttxid].h+1;
		end;
		if inv_quad_new_x > 11-inventory_ttx[list[holding_smth].ttxid].w then
			inv_quad_new_x = 11-inventory_ttx[list[holding_smth].ttxid].w+1;
		end;
		--bagid = 0; --FIXME
		local bag_found = false;
		--[[for j=1, #bags_list do
			if chars_mobs_npcs[current_mob].x==bags_list[j].x and chars_mobs_npcs[current_mob].y==bags_list[j].y and not bag_found then
				bagid=j;
				bag_found = true;
			end;
		end;]]

		bagid = helpers.whatBag(current_mob)
		if not bagid then
			bagid = helpers.trapInFrontOf(current_mob)
		end;
		if bagid then
			bag_found = true;
		end;

		if bagid then
		else
			some_crap_under_cursor=0;
		end;
		local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false,bagid);
		if  some_crap_under_cursor == 0 then
			if dragfrom == "bag" then
				sorttarget = "bag";
				--find_free_space_at_inv(); -- duplicates bag --> bag objects
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				find_nonfree_space_at_inv();
				slot = 0 ;
				helpers.repackBag()
			end;
			if dragfrom == "char" then
				if not bagid then -- create new bag
					table.insert(bags_list,{x= chars_mobs_npcs[current_mob].x,y= chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y, typ="bag",locked=false, locktyp=0, dir=0, img=bag_img,{ttxid=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].ttxid,q=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].q,w=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].w,e=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].e,r=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].r,h=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].h}});
					helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.droped[chars_mobs_npcs[current_mob].gender] .. inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].ttxid].title .. lognames.actions.frominv);
					bags[#bags_list] = {};
					for i=1,15 do
						bags[#bags_list][i] = {};
						for j=1,11 do
							bags[#bags_list][i][j] = 0;
						end;
					end;
					bagid=#bags_list;

				else
					table.insert(bags_list[bagid],{ttxid=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].ttxid,q=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].q,w=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].w,e=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].e,r=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].r,h=chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].h});
					helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.droped[chars_mobs_npcs[current_mob].gender] .. inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].ttxid].title .. lognames.actions.frominv);
				end;
				table.remove(chars_mobs_npcs[current_mob]["inventory_list"],holding_smth);
				helpers.renumber(holding_smth,current_mob);
				sorttarget = "char";
				--find_nonfree_space_at_inv();
				helpers.repackBag()
				sfx.soundsOfInv("put",dragfrom);
				holding_smth = 0;
				slot = 0 ;
			end;
		elseif some_crap_under_cursor ~= 0 then
			selected_char = tmp_bagid;
			find_free_space_at_inv();
			find_nonfree_space_at_inv();
		end;
		if dragfrom	==	"char" then
			local list,bag,tmp_bagid = helpers.whatSortTarget("bag",false,false,bagid);
			local bagid = helpers.whatBag (current_mob);
			if bagid then
				th=bagid
				sorttarget="bag"
				oldsorttarget="bag"
				for i=1,15 do
					for j=1,11 do
						bags[bagid][i][j]=0;
					end;
				end;
				helpers.resort_inv(bagid);
			end;
		end;
	end;
--/drop
--mouse up at portraits, reading, using potions
	if button == "l" and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status =="crafting") and holding_smth > 0 then
		selected_portrait,char_for_trading_is_near = helpers.select_portrait();
		if selected_portrait == current_mob then
			list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false,bagid);
			if selected_portrait > 0 and char_for_trading_is_near==1 and selected_portrait~=current_mob then
				helpers.addToActionLog( chars_stats[current_mob].name .. lognames.actions.gave[chars_mobs_npcs[current_mob].gender] .. chars_stats[selected_portrait].name .. inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].ttxid].title);
				exchange=1;
			elseif selected_portrait>0 and char_for_trading_is_near==0 and  selected_portrait~=current_mob  then
				helpers.addToActionLog( lognames.actions.charistoofar);
			end;
			if selected_portrait > 0 and selected_portrait == current_mob -- drink a potion
			and inventory_ttx[list[holding_smth].ttxid].subclass == "drink"
			and chars_stats[current_mob].nature=="humanoid" then
				local tmp=inventory_ttx[list[holding_smth].ttxid].a .. add;
				local q=list[holding_smth].q;
				if inventory_ttx[list[holding_smth].ttxid].b=="plus" then
					chars_mobs_npcs[current_mob][tmp]= chars_mobs_npcs[current_mob][tmp]+list[holding_smth].q;
				elseif inventory_ttx[list[holding_smth].ttxid].b=="minus" then
					chars_mobs_npcs[current_mob][tmp]= chars_mobs_npcs[current_mob][tmp]-list[holding_smth].q;
				elseif inventory_ttx[list[holding_smth].ttxid].b=="zero" then
					chars_mobs_npcs[current_mob][tmp]=0;
				elseif inventory_ttx[list[holding_smth].ttxid].b=="equal" then
					chars_mobs_npcs[current_mob][tmp]=chars_mobs_npcs[current_mob][tmp]-list[holding_smth].q;
				elseif inventory_ttx[list[holding_smth].ttxid].b=="permanentplus" then
					chars_stats[current_mob][tmp]= chars_mobs_npcs[current_mob][tmp]+list[holding_smth].q;
				elseif inventory_ttx[list[holding_smth].ttxid].b=="permanentminus" then
					chars_stats[current_mob][tmp]= chars_mobs_npcs[current_mob][tmp]-list[holding_smth].q;
				elseif inventory_ttx[list[holding_smth].ttxid].b=="twinbuff" then
					local tmp2 = tmp .. "_power";
					local tmp2 = tmp .. "_dur";
					chars_stats[current_mob][tmp2]= list[holding_smth].q;
					chars_stats[current_mob][tmp3]= list[holding_smth].q;
				elseif inventory_ttx[list[holding_smth].ttxid].b=="twindebuff" then
					local tmp2 = tmp .. "_power";
					local tmp2 = tmp .. "_dur";
					chars_stats[current_mob][tmp2]= list[holding_smth].q;
					chars_stats[current_mob][tmp3]= list[holding_smth].q;
				elseif inventory_ttx[list[holding_smth].ttxid].b=="convertor" then
					if inventory_ttx[list[holding_smth].ttxid].a == 1 then
						local convertation = math.min(chars_mobs_npcs[current_mob].hp-1,list[holding_smth].q);
						damage.SPplus(current_mob,convertation,false);
						damage.HPminus(current_mob,convertation,false);
					elseif inventory_ttx[list[holding_smth].ttxid].a == 2 then
						local convertation = math.min(chars_mobs_npcs[current_mob].sp-1,list[holding_smth].q);
						damage.HPplus(current_mob,convertation,false);
						damage.SPminus(current_mob,convertation,false);
					end;
				end;
				helpers.limitStats();
				utils.playSfx(media.sounds.drink,1);
				helpers.addToActionLog( chars_stats[current_mob].name .. " " ..
				lognames.actions.drinked[chars_mobs_npcs[current_mob].gender] .. " «"
				.. inventory_ttx[list[holding_smth].ttxid].title .. "» "
				.. lognames.actions.ofpower .. " " .. list[holding_smth].q);
				table.remove(list,holding_smth);
				for i=1,11 do
					for h=1,15 do
						if bag[tmp_bagid][h][i] > holding_smth and bag[tmp_bagid][h][i] > 0 and bag[tmp_bagid][h][i]<10000 then
							bag[tmp_bagid][h][i]=bag[tmp_bagid][h][i]-1;
						end;
					end;
				end;
				helpers.renumber(holding_smth,current_mob);
				table.insert(list,{ttxid=raws.tare,q=1,w=0,e=0,r=0});
				bag[tmp_bagid][inv_quad_x][inv_quad_y] = #list;
				bag[tmp_bagid][inv_quad_x+1][inv_quad_y]=inv_quad_y*10000+inv_quad_x holding_smth = 0;
				if global.status == "battle" then
					chars_mobs_npcs[current_mob].rt = chars_mobs_npcs[current_mob].rt-10;
					game_status = "restoring";
				end;
			end;
			
			if selected_portrait > 0 and selected_portrait == current_mob  and holding_smth > 0 -- oil a weapon
			and (inventory_ttx[list[holding_smth].ttxid].subclass == "trioil" or inventory_ttx[list[holding_smth].ttxid].subclass =="oil"
			or inventory_ttx[list[holding_smth].ttxid].subclass == "chargeoil" or inventory_ttx[list[holding_smth].ttxid].subclass == "hardoil"
			or inventory_ttx[list[holding_smth].ttxid].subclass == "resetoil" or inventory_ttx[list[holding_smth].ttxid].subclass == "eternaloil"
			) then
				oil_smth = holding_smth;
				holding_smth = 0;
				utils.playSfx(media.sounds.chpok,1);
				sorttarget = dragfrom;
				game_status = "inventory";
			end;

			if selected_portrait > 0 and selected_portrait == current_mob  and holding_smth > 0 -- eat smth
			and inventory_ttx[list[holding_smth].ttxid].class == "food" then
				holding_smth = 0;
				--utils.playSfx(media.sounds.yami,1);
				helpers.addToActionLog(chars_stats[current_mob].name .. lognames.actions.eaten[chars_mobs_npcs[current_mob].gender]);
				local value = inventory_ttx[list[holding_smth].ttxid].a;
				if chars_mobs_npcs[index].basiliskbreath == 0 then
					helpers.addSatiation(index,value);
				end;
				table.remove(list,holding_smth);
				for i=1,11 do
					for h=1,15 do
						if bag[tmp_bagid][h][i] > holding_smth and bag[tmp_bagid][h][i] > 0 and bag[tmp_bagid][h][i]<10000 then
							bag[tmp_bagid][h][i]=bag[tmp_bagid][h][i]-1;
						end;
					end;
				end;
				helpers.renumber(holding_smth,current_mob);
				if global.status == "battle" then
					chars_mobs_npcs[current_mob].rt = chars_mobs_npcs[current_mob].rt-10;
					sorttarget = dragfrom;
					game_status = "restoring";
				end;
			end;

			if selected_portrait > 0 and selected_portrait == current_mob and holding_smth > 0 -- bomb
			and inventory_ttx[list[holding_smth].ttxid].subclass == "bomb" then
				bomb_smth = holding_smth;
				utils.playSfx(media.sounds.inv_bottle_put,1);
				potionname = inventory_ttx[list[holding_smth].ttxid].title;
				missle_subtype = inventory_ttx[list[holding_smth].ttxid].a;
				bombpower = list[holding_smth].q;
				holding_smth = 0;
				missle_type = "bottle";
				game_status = "sensing";
			end;
			if selected_portrait > 0 and selected_portrait == current_mob and holding_smth > 0 -- allieshelp
			and inventory_ttx[list[holding_smth].ttxid].subclass == " allieshelp" then
				use_smth = holding_smth;
				utils.playSfx(media.sounds.inv_bottle_put,1);
				potionname = inventory_ttx[list[holding_smth].ttxid].title;
				missle_subtype = inventory_ttx[list[holding_smth].ttxid].a;
				bombpower = list[holding_smth].q;
				holding_smth = 0;
				missle_type = "bottle";
				game_status = "sensing";
			end;
			if holding_smth>0 and selected_portrait>0 and selected_portrait==current_mob --read a spellbok
			and inventory_ttx[list[holding_smth].ttxid].class == "spellbook"
			and  chars_stats[current_mob].spellbook==1
			and  chars_mobs_npcs[current_mob].status==1
			and  chars_mobs_npcs[current_mob].stone==0
			and  chars_mobs_npcs[current_mob].freeze==0
			and  chars_mobs_npcs[current_mob].paralyze==0
			and  chars_mobs_npcs[current_mob].insane==0
			and  chars_mobs_npcs[current_mob].control=="player" then
				local bookcanberead = 1;
				for i = 1,chars do
					local tmpskill = magic.spell_tips[list[holding_smth].w].skill[i];
					local tmplevel = magic.spell_tips[list[holding_smth].w].level[i];
					if tmpskill == "none" or chars_stats[current_mob][tmpskill] >= tmplevel then
					else
						bookcanberead = 0;
					end;
				end;
				local tmpspell=list[holding_smth].w;
				local tmpspellname=typo[1] .. magic.spell_tips[tmpspell].title .. typo[2];
				if bookcanberead == 1 then
					if chars_mobs_npcs[current_mob].spells[magic.spell_tips[list[holding_smth].w].school][magic.spell_tips[list[holding_smth].w].spell] == 0 then
						chars_mobs_npcs[current_mob].spells[magic.spell_tips[list[holding_smth].w].school][magic.spell_tips[list[holding_smth].w].spell] = 1
						table.remove(list,holding_smth);
						helpers.addToActionLog( chars_stats[current_mob].name .. " " .. lognames.actions.examined[chars_mobs_npcs[current_mob].gender] .. tmpspellname)
						for i=1,11 do
							for h=1,15 do
								if bag[tmp_bagid][h][i] > holding_smth and bag[tmp_bagid][h][i] > 0 and bag[tmp_bagid][h][i] < 10000 then
									bag[tmp_bagid][h][i] = bag[tmp_bagid][h][i]-1;
								end;
							end;
						end;
					else
					--char knows the spell already
						helpers.addToActionLog( chars_stats[current_mob] .. " " .. lognames.actions.alreadyknown .. tmpspellname);
					end;
				else
				--cant read this!
					helpers.addToActionLog( chars_stats[current_mob] .. " " .. lognames.actions.cantreadthis);
				end;
				holding_smth = 0;
			end;
			if holding_smth>0 and selected_portrait>0 and selected_portrait==current_mob --read a book, letter, message
			and (inventory_ttx[list[holding_smth].ttxid].class == "book" or inventory_ttx[list[holding_smth].ttxid].class == "message" or inventory_ttx[list[holding_smth].ttxid].class == "letter" or inventory_ttx[list[holding_smth].ttxid].class == "map"  or inventory_ttx[list[holding_smth].ttxid].class == "gobelen")
			and  chars_mobs_npcs[current_mob].status==1
			and  chars_mobs_npcs[current_mob].stone==0
			and  chars_mobs_npcs[current_mob].freeze==0
			and  chars_mobs_npcs[current_mob].paralyze==0
			and  chars_mobs_npcs[current_mob].insane==0
			and  chars_mobs_npcs[current_mob].control=="player"
			then
				if inventory_ttx[list[holding_smth].ttxid].class == "book" then
					pagebook=1;
					littype="book";
					game_status="literature";
					tmp_book=holding_smth;
					holding_smth=0;
					bag[tmp_bagid][inv_quad_x][inv_quad_y]=tmp_book
					bag[tmp_bagid][inv_quad_x+1][inv_quad_y]=inv_quad_y*10000+inv_quad_x;
					bag[tmp_bagid][inv_quad_x][inv_quad_y+1]=inv_quad_y*10000+inv_quad_x;
					bag[tmp_bagid][inv_quad_x+1][inv_quad_y+1]=inv_quad_y*10000+inv_quad_x;
					utils.playSfx(media.sounds.bookopen, 1);
				elseif inventory_ttx[list[holding_smth].ttxid].class == "message" then
					littype="message";
					game_status="literature";
					tmp_book=holding_smth;
					bag[tmp_bagid][inv_quad_x][inv_quad_y]=tmp_book;
					bag[tmp_bagid][inv_quad_x+1][inv_quad_y]=inv_quad_y*10000+inv_quad_x;
					holding_smth=0;
					utils.playSfx(media.sounds.paper, 1);
				elseif inventory_ttx[list[holding_smth].ttxid].class == "letter" then
					littype="letter";
					game_status="literature";
					tmp_book=holding_smth;
					bag[tmp_bagid][inv_quad_x][inv_quad_y]=tmp_book;
					bag[tmp_bagid][inv_quad_x+1][inv_quad_y]=inv_quad_y*10000+inv_quad_x;
					holding_smth=0;
					utils.playSfx(media.sounds.paper, 1);
				elseif inventory_ttx[list[holding_smth].ttxid].class == "map" then
					littype="map";
					game_status="literature";
					tmp_book=holding_smth;
					bag[tmp_bagid][inv_quad_x][inv_quad_y]=tmp_book;
					bag[tmp_bagid][inv_quad_x+1][inv_quad_y]=inv_quad_y*10000+inv_quad_x;
					holding_smth=0;
					utils.playSfx(media.sounds.paper, 1);
				elseif inventory_ttx[list[holding_smth].ttxid].class == "gobelen" then
					littype="gobelen";
					game_status="literature";
					tmp_book=holding_smth;
					bag[tmp_bagid][inv_quad_x][inv_quad_y]=tmp_book;
					bag[tmp_bagid][inv_quad_x+1][inv_quad_y]=inv_quad_y*10000+inv_quad_x;
					holding_smth=0;
					utils.playSfx(media.sounds.inv_cloth_take, 1);
				end;
			end;
			if holding_smth > 0 and selected_portrait > 0 and selected_portrait == current_mob --read a scroll
			and inventory_ttx[list[holding_smth].ttxid].class == "scroll"
			and  chars_mobs_npcs[current_mob].status == 1
			and  chars_mobs_npcs[current_mob].stone == 0
			and  chars_mobs_npcs[current_mob].freeze == 0
			and  chars_mobs_npcs[current_mob].paralyze == 0
			and  chars_mobs_npcs[current_mob].insane == 0
			and  chars_mobs_npcs[current_mob].control == "player" then
				utils.playSfx(media.sounds.paper,1);
				missle_drive = "scroll";
				missle_type = list[holding_smth].w;
				if global.status ~= "mindgame" then
					game_status = "sensing";
				else
					global.mindgame_attempts = global.mindgame_attempts - 1;
					damage.mindGameCast();
					game_status = "mindgame";
				end;
				scroll_smth = holding_smth;
				holding_smth = 0;
			end;
			if (holding_smth > 0 and selected_portrait > 0 and selected_portrait ~= current_mob and char_for_trading_is_near == 1) then --FIXME wno need trading this way!
				sorttarget="char";
				oldsorttarget="char";
				selected_char=selected_portrait;
				find_free_space_at_inv();
			elseif (holding_smth > 0 and selected_portrait > 0 and selected_portrait ~= current_mob and char_for_trading_is_near == 0) then
				if slot==0 then
					inventory_bag[current_mob][inv_quad_x][inv_quad_y]=holding_smth;
					holding_smth=0;
				else
					chars_mobs_npcs[current_mob]["equipment"].slot=holding_smth;
					holding_smth=0;
				end;
			end;
			helpers.recalcBattleStats (current_mob);
		end;
	end;

	if mX > x+372 and mX < x+740 and mY > y-40 and mY < y+490 and holding_smth>0 then --area of equipment, but wrong slot or wrong item
		utils.printDebug("wrong slot");
		if slot==0 then
			list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false,bagid);
			bag[tmp_bagid][inv_quad_x][inv_quad_y]=holding_smth;
			sfx.soundsOfInv("put",dragfrom);
			holding_smth=0;
			find_nonfree_space_at_inv();
		elseif slot~=0 then
			if slotset=="equipment" then
				chars_mobs_npcs[current_mob]["equipment"][slot]=holding_smth;
			elseif slotset=="alchlab" then
				alchlab[current_mob][slot]=holding_smth;
			elseif slotset=="picklock" then
				picklock[current_mob][slot]=holding_smth;
			elseif slotset=="crafting" then
				crafting[current_mob][slot]=holding_smth;
			end;
			slot=0;
			holding_smth=0;
		end;
		helpers.recalcBattleStats (current_mob);
	end;
	loveframes.mousereleased(x, y, button);
end;

function  playingState.mousepressed(x,y,button)

	if (button == "l" or button == "r") and (game_status == "inventory" or game_status == "alchemy"  or game_status == "picklocking" or game_status == "crafting") then
		x,y = helpers.centerObject(media.images.inv1);
		inv_add_x = x+12;
		inv_add_y = y-25;
	end;

	local cursor_near = helpers.ifCursorIsNear ();
	if button == "l" then
		show_inventory_tips = 0;
		show_monsterid_tip = 0;
		show_spellbook_tips = 0;
		show_warbook_tips = 0;
	end;
	if button == "r" and game_status == "sensing" then
		game_status = "neutral";
	end;
	if button == "l" and game_status == "neutral" and mY <= global.screenHeight - 160 then
		if global.status == "peace" and helpers.cursorAtPartyMember(cursor_world_x,cursor_world_y) then
			current_mob = helpers.cursorAtMobID (cursor_world_x,cursor_world_y);
			helpers.cam_to_mob ();
		else
		   ---- kstn
		   helpers.cam_to_hex (cursor_world_x,cursor_world_y);
		end;
	end;
	--mindgame
	if button == "l" and game_status == "mindgame" and not global.hang and mindmissle then
		if	global.mindgame_counter < global.mindgame_attempts then
			local array =  boomareas.smallRingArea(global.mindhero_x,global.mindhero_y); -- FIXME while not array
			local x,y = helpers.centerObject(media.images.map);
			for i=1,#array do
				if mY <= y+365 and array[i].x == global.mindcursor_x and array[i].y == global.mindcursor_y and mindgame.notTriggerHex(global.mindcursor_x,global.mindcursor_y) then
					if mindgame.map[global.mindcursor_x][global.mindcursor_y] == 0 then
						local phrase1 = "";
						local phrase1 = "";
						global.mindtimer = 1;
						global.hang = true;
						if mindmissle >=1 and mindmissle <= 7 and #global.mindgold_array > 0 then	--gold
							local index = mindmissle;
							mindgame.map[global.mindcursor_x][global.mindcursor_y] = index;
							global.mindgold = global.mindgold + mindgame.moneysums[index];
							utils.playSfx(media.sounds.gold_dzen,1);
							for i=1,12 do
								--if global.mindgold <= mindgame["flags_gold"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["gold"]][8][7] then
									--index = mindmissle;
								--else
									--index = 3;
								--end;
								index = 3;
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] + mindgame["flags_gold"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["gold"]][index][1][i];
								local snd = "mindgame_" .. mindgame["flags_gold"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["gold"]][index][3];
								utils.playSfx(media["sounds"][snd],1);
								if chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] < 0 then
									chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = 0;
								end;
							end;
							phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. chats.valuablePhrase("givegold",mindgame.moneysums[mindmissle]);
							phrase2 = helpers.mobName(victim) .. ": " .. mindgame["flags_gold"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["gold"]][index][4];
							global.mindgold_array = {};
							for i=1,#mindgame.moneysums do
								local _gold = mindgame.moneysums[i];
								if party.gold >= _gold then
									table.insert(global.mindgold_array,_gold);
								end;
							end;
							global.goldmissle = 1;
							mindmissle = 1;
							loveframes.util.RemoveAll();
							draw.mindgameButtons();
						elseif mindmissle > 1000 and #global.minddrink_array >= 1 then --drinks,gifts
							local index = mindmissle;
							mindgame.map[global.mindcursor_x][global.mindcursor_y] = index;
							local emo = chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["drinks"];
							local price = chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["drinksprice"];
							for i=1,12 do
								if emo == taster and price and price > inventory_ttx[index-1000].price then
									emo = taster2;
								end;
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] + mindgame["flags_drinks"][emo][1][i]*math.ceil(chars_mobs_npcs[current_mob].chr/5);
								local snd = "mindgame_" .. mindgame["flags_drinks"][emo][3];
							end;
							if emo == "boozer" then
								if chars_mobs_npcs[current_mob].nature ~= "undead" then
									damage.applyConditionTwoFactors (current_mob,3,10,"drunk","poison","enu",false,1,true);
									helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.drunk[chars_mobs_npcs[current_mob].gender]);
								end;
								damage.applyConditionTwoFactors (victim,3,10,"drunk","poison","enu",false,1,true);
								helpers.addToActionLog(helpers.mobName(victim) .. lognames.actions.drunk[chars_mobs_npcs[victim].gender]);
							end;
							utils.playSfx(media.sounds.inv_bottle_put,1);
							table.remove(chars_mobs_npcs[current_mob]["inventory_list"],global.minddrink_array[global.drinkmissle].itemid);
							helpers.renumber (global.minddrink_array[global.drinkmissle].itemid,current_mob);
							global.minddrink_array = {};
							for i=1,#chars_mobs_npcs[current_mob]["inventory_list"] do
								if chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid == raws.buz then
									table.insert(global.minddrink_array,{itemid=i,spriteid=chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid,typ="alcho",price=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid].price});
								end;
							end;
							phrase1 = chars_mobs_npcs[current_mob].name .. ": " ..chats.questionPerEtiquette("wannadrink",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
							phrase2 = helpers.mobName(victim) .. ": " .. mindgame["flags_drinks"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["drinks"]][4];
							mindmissle = false;
							global.drinkmissle = 1;
							loveframes.util.RemoveAll();
							draw.mindgameButtons();
						elseif mindmissle >=10 and mindmissle <= 16 then --threats
							local _level = threats_ttx[global.threats_pull[global.current_threat] ].level;
							local _repo_down = math.max(1,threats_ttx[global.threats_pull[global.current_threat]].repodown - chars_mobs_npcs[current_mob].chr);
							if mindmissle == 10 then
								fractions[chars_mobs_npcs[victim]["fraction"]]["party"] = fractions[chars_mobs_npcs[victim]["fraction"]]["party"]-_repo_down;
								phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. chats.questionPerEtiquette("illpainyou",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
							elseif mindmissle == 11 then
								fractions[chars_mobs_npcs[victim]["fraction"]]["party"] = fractions[chars_mobs_npcs[victim]["fraction"]]["party"]-_repo_down;
								phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. chats.questionPerEtiquette("illinjuyou",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
							elseif mindmissle == 12 then
								fractions[chars_mobs_npcs[victim]["fraction"]]["party"] = fractions[chars_mobs_npcs[victim]["fraction"]]["party"]-_repo_down;
								phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. chats.questionPerEtiquette("illkillyou",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
							elseif mindmissle == 13 then
								fractions[chars_mobs_npcs[victim]["fraction"]]["party"] = fractions[chars_mobs_npcs[victim]["fraction"]]["party"]-_repo_down;
								phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. chats.questionPerEtiquette("illkillyou",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
							elseif mindmissle == 14 then
								fractions[chars_mobs_npcs[victim]["fraction"]]["party"] = fractions[chars_mobs_npcs[victim]["fraction"]]["party"]-_repo_down;
								phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. chats.questionPerEtiquette("illkillyou",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
							elseif mindmissle == 15 then
								fractions[chars_mobs_npcs[victim]["fraction"]]["party"] = fractions[chars_mobs_npcs[victim]["fraction"]]["party"]-_repo_down;
								phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. chats.questionPerEtiquette("illkillyou",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
							elseif mindmissle == 16 then
								fractions[chars_mobs_npcs[victim]["fraction"]]["party"] = fractions[chars_mobs_npcs[victim]["fraction"]]["party"]-_repo_down;
								phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. chats.questionPerEtiquette("illkillyou",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
							end;
							--FIXME: tags needed. lich jars, exorcisms, etc.
							if global.threats_level < _level and chars_mobs_npcs[current_mob].nature ~= "undead" and chars_mobs_npcs[current_mob].nature ~= "elemental" and chars_mobs_npcs[current_mob].nature ~= "golem" then
								global.threats_level = _level;
								mindgame.map[global.mindcursor_x][global.mindcursor_y] = mindmissle;
								--local index = mindmissle - 9;
								for i=1,10 do
									chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] + mindgame["flags_threat"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["threat"]][1][i]*threats_ttx[global.threats_pull[global.current_threat] ].level;
									local snd = "mindgame_" .. mindgame["flags_threat"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["threat"]][3];
									utils.playSfx(media["sounds"][snd],1); --FIXME 10 times?!
									if chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] < 0 then
										chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] = 0;
									end;
								end;
								phrase2 = helpers.mobName(victim) .. ": " .. mindgame["flags_threat"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["threat"]][4];
							else
								local _rnd_emo = {3,3,3,4,3,3,3,3,3,10};
								_emo = math.random(1,#_rnd_emo);
								local _power = 1;
								if _emo == 1 then --FIXME add phrases
									utils.playSfx(media.sounds.mindgame_loyality,1);
								elseif _emo == 2 then
									utils.playSfx(media.sounds.mindgame_fear,1);
								elseif _emo == 3 then
									utils.playSfx(media.sounds.mindgame_boring,1);
								elseif _emo == 4 then
									utils.playSfx(media.sounds.mindgame_disdain,1);
								elseif _emo == 5 then
									utils.playSfx(media.sounds.mindgame_agression,1);
								elseif _emo == 6 then
									utils.playSfx(media.sounds.mindgame_distrust,1);
								elseif _emo == 7 then
									utils.playSfx(media.sounds.mindgame_cry,1);
								elseif _emo == 8 then
									utils.playSfx(media.sounds.mindgame_surprized,1);
								elseif _emo == 9 then
									utils.playSfx(media.sounds.mindgame_respect,1);
								elseif _emo == 10 then
									utils.playSfx(media.sounds.mindgame_lol,1);
								elseif _emo == 11 then
									utils.playSfx(media.sounds.mindgame_pity,1);
								elseif _emo == 12 then
									utils.playSfx(media.sounds.mindgame_shame,1);
								end;
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo]+_power;
								phrase2 = "...";
							end;
						elseif mindmissle == 31 then --info secrets
							local _interested = false;
							local _remove = false;
							global.secret_index = global.secrets_pull[global.current_secret];
							phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. secrets_ttx[global.secret_index].title;
							local _id = nil;
							local _emo = nil;
							local _power = nil;
							for i=1,#chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["chantage"] do
								if chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["chantage"][i]["id"] == global.secret_index then
									_id = chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["chantage"][i]["id"];
									_emo = chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["chantage"][i]["emo"];
									_power = chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["chantage"][i]["pow"];
									chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo]+_power;
									phrase2 = helpers.mobName(victim) .. ": " .. chats.questionPerEtiquette("mysecret",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
									fractions[chars_mobs_npcs[victim]["fraction"]]["party"] = fractions[chars_mobs_npcs[victim]["fraction"]]["party"]-_power;
									table.insert(chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["known_secrets"],_id);
									_remove = i;
									_interested = true;
									break;
								end;
							end;
							for i=1,#chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["rumours"] do
								if chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["rumours"][i]["id"] == global.secret_index then
									_id = chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["rumours"][i]["id"];
									_emo = chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["rumours"][i]["emo"];
									_power = chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["rumours"][i]["pow"];
									chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo]+_power;
									phrase2 = helpers.mobName(victim) .. ": " .. chats.questionPerEtiquette("interestinginformation",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
									fractions[chars_mobs_npcs[victim]["fraction"]]["party"] = fractions[chars_mobs_npcs[victim]["fraction"]]["party"]+_power;
									table.insert(chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["known_secrets"],_id);
									_remove = i;
									_interested = true;
									break;
								end;
							end;

							for i=1,#chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["known_secrets"] do
								if chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["known_secrets"][i] == global.secret_index then
									_interested = false;
								end;
							end;

							if interested then
								mindgame.map[global.mindcursor_x][global.mindcursor_y] = mindmissle;
								if _emo == 1 then
									utils.playSfx(media.sounds.mindgame_loyality,1);
								elseif _emo == 2 then
									utils.playSfx(media.sounds.mindgame_fear,1);
								elseif _emo == 3 then
									utils.playSfx(media.sounds.mindgame_boring,1);
								elseif _emo == 4 then
									utils.playSfx(media.sounds.mindgame_disdain,1);
								elseif _emo == 5 then
									utils.playSfx(media.sounds.mindgame_agression,1);
								elseif _emo == 6 then
									utils.playSfx(media.sounds.mindgame_distrust,1);
								elseif _emo == 7 then
									utils.playSfx(media.sounds.mindgame_cry,1);
								elseif _emo == 8 then
									utils.playSfx(media.sounds.mindgame_surprized,1);
								elseif _emo == 9 then
									utils.playSfx(media.sounds.mindgame_respect,1);
								elseif _emo == 10 then
									utils.playSfx(media.sounds.mindgame_lol,1);
								elseif _emo == 11 then
									utils.playSfx(media.sounds.mindgame_pity,1);
								elseif _emo == 12 then
									utils.playSfx(media.sounds.mindgame_shame,1);
								end;
							else
								phrase2 = helpers.mobName(victim) .. ": " .. chats.questionPerEtiquette("whocares",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
								utils.playSfx(media.sounds.mindgame_boring,1);
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][3] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][3]+1;
							end;

							table.remove(global.secrets_pull,global.current_secret);
							if _remove then
								table.remove(chars_mobs_npcs[victim]["personality"]["current"]["secrets"]["rumours"],_remove);
							end;
							if #global.secrets_pull > 0 then
								mindmissle = 1;
								global.current_secret = 1;
								global.secret_index = 1;
							else
								mindmissle = nil;
							end;
							loveframes.util.RemoveAll();
							draw.mindgameButtons();
						elseif mindmissle == 32 then --joke
							global.joke_index = global.jokes_pull[global.current_joke];
							local _joke_reaction = mindgame.checkJoke(party["jokes"][global.joke_index],victim);
							phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. jokes_ttx[global.joke_index].shortstory;
							if _joke_reaction > 0 then
								mindgame.map[global.mindcursor_x][global.mindcursor_y] = mindmissle;
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][1] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][10]+_joke_reaction;
								utils.playSfx(media.sounds.mindgame_lol,1);
								phrase2 = helpers.mobName(victim) .. ": " .. chats.questionPerEtiquette("goodjoke",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
							elseif _joke_reaction == 0 then
								local _index = chars_mobs_npcs[victim]["personality"]["current"]["humor"]["ifknown"];
								utils.playSfx(media.sounds.mindgame_boring,1);
								phrase2 = helpers.mobName(victim) .. ": " .. chats.questionPerEtiquette("knownjoke",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
							elseif _joke_reaction < 0 then
								local _emo = chars_mobs_npcs[victim]["personality"]["current"]["humor"]["ifnot"];
								if _emo == 1 then
									utils.playSfx(media.sounds.mindgame_loyality,1);
								elseif _emo == 2 then
									utils.playSfx(media.sounds.mindgame_fear,1);
								elseif _emo == 3 then
									utils.playSfx(media.sounds.mindgame_boring,1);
								elseif _emo == 4 then
									utils.playSfx(media.sounds.mindgame_disdain,1);
								elseif _emo == 5 then
									utils.playSfx(media.sounds.mindgame_agression,1);
								elseif _emo == 6 then
									utils.playSfx(media.sounds.mindgame_distrust,1);
								elseif _emo == 7 then
									utils.playSfx(media.sounds.mindgame_cry,1);
								elseif _emo == 8 then
									utils.playSfx(media.sounds.mindgame_surprized,1);
								elseif _emo == 9 then
									utils.playSfx(media.sounds.mindgame_respect,1);
								elseif _emo == 10 then
									utils.playSfx(media.sounds.mindgame_lol,1);
								elseif _emo == 11 then
									utils.playSfx(media.sounds.mindgame_pity,1);
								elseif _emo == 12 then
									utils.playSfx(media.sounds.mindgame_shame,1);
								end;
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo]+_joke_reaction;
								phrase2 = helpers.mobName(victim) .. ": " .. chats.questionPerEtiquette("badjoke",chars_mobs_npcs[victim]["personality"]["current"].etiquette);
							end;
							local _joke_unkmown = true;
							for i=1, #chars_mobs_npcs[victim]["personality"]["current"]["humor"].known_jokes do
								if joke == chars_mobs_npcs[victim]["personality"]["known_jokes"][i] then
									_joke_unkmown = false;
									break;
								end;
							end;
							if _joke_unknown then --fixme
								table.insert(chars_mobs_npcs[victim]["personality"]["current"]["humor"]["known_jokes"],global.joke_index);
								if chars_mobs_npcs[victim]["personality"]["alternative"] then
									table.insert(chars_mobs_npcs[victim]["personality"]["alternative"]["humor"]["known_jokes"],global.joke_index);
								end;
								if chars_mobs_npcs[victim]["personality"]["default"] then
									table.insert(chars_mobs_npcs[victim]["personality"]["default"]["humor"]["known_jokes"],global.joke_index);
								end;
								if chars_mobs_npcs[victim]["personality"]["alternative"] then
									table.insert(chars_mobs_npcs[victim]["personality"]["alternative"]["humor"]["known_jokes"],global.joke_index);
								end;
								if chars_mobs_npcs[victim]["personality"]["thiefcatcher"] then
									table.insert(chars_mobs_npcs[victim]["personality"]["thiefcatcher"]["humor"]["known_jokes"],global.joke_index);
								end;
							end;
							table.remove(global.jokes_pull,global.current_joke);
							if #global.jokes_pull > 0 then
								mindmissle = 1;
								global.current_joke = 1;
								global.joke_index = 1;
							else
								mindmissle = nil;
							end;
							loveframes.util.RemoveAll();
							draw.mindgameButtons();
						elseif mindmissle == 33 or mindmissle == 36 or mindmissle == 37 then --nlp, trolling
							global.nlp_index = global.nlps_pull[global.current_nlp];
							phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. nlps_ttx[global.nlp_index].phrase;
							local _power = 0;
							local _known = false;
							for i=1,#chars_mobs_npcs[victim]["personality"]["current"]["known_nlps"] do
								if chars_mobs_npcs[victim]["personality"]["current"]["known_nlps"][i] == global.nlp_index then
										_known = true;
									break;
								end;
							end;
							if not _known then
								table.insert(chars_mobs_npcs[victim]["personality"]["current"]["known_nlps"],global.nlp_index);
								for i=1,#nlps_ttx[global.nlp_index].races do
									if nlps_ttx[global.nlp_index]["races"][i] == chars_mobs_npcs[victim].race or nlps_ttx[global.nlp_index]["races"][i] == "any" then
										_power = _power + 1;
									end;
								end;
								for i=1,#nlps_ttx[global.nlp_index].classes do
									if nlps_ttx[global.nlp_index]["classes"][i] == chars_mobs_npcs[victim].class or nlps_ttx[global.nlp_index]["classes"][i] == "any" then
										_power = _power + 1;
									end;
								end;
								for i=1,#nlps_ttx[global.nlp_index].natures do
									if nlps_ttx[global.nlp_index]["natures"][i] == chars_mobs_npcs[victim].nature or nlps_ttx[global.nlp_index]["natures"][i] == "any" then
										_power = _power + 1;
									end;
								end;
								for i=1,#nlps_ttx[global.nlp_index].genders do
									if nlps_ttx[global.nlp_index]["genders"][i] == chars_mobs_npcs[victim].gender or nlps_ttx[global.nlp_index]["genders"][i] == "any" then
										_power = _power + 1;
									end;
								end;
								--profession
								--guild
								--religion
								if nlps_ttx[global.nlp_index]["stat_delta"] then
									local stat_name = nlps_ttx[global.nlp_index]["stat_delta"][1];
									local stat_value = nlps_ttx[global.nlp_index]["stat_delta"][2];
									if chars_mobs_npcs[current_mob]["stat_name"]-chars_mobs_npcs[victim]["stat_name"] >= stat_value then
										_power = 1+chars_mobs_npcs[current_mob]["stat_name"]-chars_mobs_npcs[victim]["stat_name"];
									else
										_power = 0;
									end;
								end;
								if _power > 0 then
									local _emo = nlps_ttx[global.nlp_index].emo;
									mindgame.map[global.mindcursor_x][global.mindcursor_y] = mindmissle;
									if _emo == 1 then
										utils.playSfx(media.sounds.mindgame_loyality,1);
									elseif _emo == 2 then
										utils.playSfx(media.sounds.mindgame_fear,1);
									elseif _emo == 3 then
										utils.playSfx(media.sounds.mindgame_boring,1);
									elseif _emo == 4 then
										utils.playSfx(media.sounds.mindgame_disdain,1);
									elseif _emo == 5 then
										utils.playSfx(media.sounds.mindgame_agression,1);
									elseif _emo == 6 then
										utils.playSfx(media.sounds.mindgame_distrust,1);
									elseif _emo == 7 then
										utils.playSfx(media.sounds.mindgame_cry,1);
									elseif _emo == 8 then
										utils.playSfx(media.sounds.mindgame_surprized,1);
									elseif _emo == 9 then
										utils.playSfx(media.sounds.mindgame_respect,1);
									elseif _emo == 10 then
										utils.playSfx(media.sounds.mindgame_lol,1);
									elseif _emo == 11 then
										utils.playSfx(media.sounds.mindgame_pity,1);
                                    elseif _emo == 12 then
										utils.playSfx(media.sounds.mindgame_shame,1);
									end;
									chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo]+_power;

								end;
							else
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][3] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][3]+1;
								utils.playSfx(media.sounds.mindgame_boring,1);
							end;
							phrase2 = chars_mobs_npcs[victim].name .. ": " .. "..."; --FIXME from nlp ttx
							table.remove(global.nlps_pull,global.current_nlp);
							if #global.nlps_pull > 0 then
								mindmissle = 1;
								global.current_nlp = 1;
								global.nlp_index = 1;
							else
								mindmissle = nil;
							end;
							loveframes.util.RemoveAll();
							draw.mindgameButtons();
						elseif mindmissle == 34 then --affronts
							global.affront_index = global.affronts_pull[global.current_affront];
							phrase1 = chars_mobs_npcs[current_mob].name .. ": " .. affronts_ttx[global.affront_index].phrase;
							local _power = 0;
							local _known = false;
							for i=1,#chars_mobs_npcs[victim]["personality"]["current"]["affronts"]["known_affronts"] do
								if chars_mobs_npcs[victim]["personality"]["current"]["affronts"]["known_affronts"][i] == global.affront_index then
										_known = true;
									break;
								end;
							end;
							if not _known then
								table.insert(chars_mobs_npcs[victim]["personality"]["current"]["affronts"]["known_affronts"],global.affront_index);
								for i=1,#affronts_ttx[global.affront_index].races do
									if affronts_ttx[global.affront_index]["races"][i] == chars_mobs_npcs[victim].race or affronts_ttx[global.affront_index]["races"][i] == "any" then
										_power = _power + 1;
									end;
								end;
								for i=1,#affronts_ttx[global.affront_index].classes do
									if affronts_ttx[global.affront_index]["classes"][i] == chars_mobs_npcs[victim].class or affronts_ttx[global.affront_index]["classes"][i] == "any" then
										_power = _power + 1;
									end;
								end;
								for i=1,#affronts_ttx[global.affront_index].natures do
									if affronts_ttx[global.affront_index]["natures"][i] == chars_mobs_npcs[victim].nature or affronts_ttx[global.affront_index]["natures"][i] == "any" then
										_power = _power + 1;
									end;
								end;
								for i=1,#affronts_ttx[global.affront_index].genders do
									if affronts_ttx[global.affront_index]["genders"][i] == chars_mobs_npcs[victim].gender or affronts_ttx[global.affront_index]["genders"][i] == "any" then
										_power = _power + 1;
									end;
								end;
								for i=1,#affronts_ttx[global.affront_index].tags do
									for h=1,#chars_mobs_npcs[victim]["personality"]["current"]["affronts"]["additional_tags"] do
										if affronts_ttx[global.affront_index]["races"][i] == chars_mobs_npcs[victim]["personality"]["current"]["affronts"]["additional_tags"][h] then
											_power = _power + 1;
										end;
									end;
								end;
								--profession
								--guild
								--religion
								if affronts_ttx[global.affront_index]["stat_delta"] then
									local stat_name = affronts_ttx[global.affront_index]["stat_delta"][1];
									local stat_value = affronts_ttx[global.affront_index]["stat_delta"][2];
									if chars_mobs_npcs[current_mob]["stat_name"]-chars_mobs_npcs[victim]["stat_name"] >= stat_value then
										_power = 1+chars_mobs_npcs[current_mob]["stat_name"]-chars_mobs_npcs[victim]["stat_name"];
									else
										_power = 0;
									end;
								end;
								if _power > 0 then

									mindgame.map[global.mindcursor_x][global.mindcursor_y] = mindmissle; --FIXME: 2 variants
									local _emo = chars_mobs_npcs[victim]["personality"]["current"]["affronts"]["emo"];
									if _emo == 1 then
										utils.playSfx(media.sounds.mindgame_loyality,1);
									elseif _emo == 2 then
										utils.playSfx(media.sounds.mindgame_fear,1);
									elseif _emo == 3 then
										utils.playSfx(media.sounds.mindgame_boring,1);
									elseif _emo == 4 then
										utils.playSfx(media.sounds.mindgame_disdain,1);
									elseif _emo == 5 then
										utils.playSfx(media.sounds.mindgame_agression,1);
									elseif _emo == 6 then
										utils.playSfx(media.sounds.mindgame_distrust,1);
									elseif _emo == 7 then
										utils.playSfx(media.sounds.mindgame_cry,1);
									elseif _emo == 8 then
										utils.playSfx(media.sounds.mindgame_surprized,1);
									elseif _emo == 9 then
										utils.playSfx(media.sounds.mindgame_respect,1);
									elseif _emo == 10 then
										utils.playSfx(media.sounds.mindgame_lol,1);
									elseif _emo == 11 then
										utils.playSfx(media.sounds.mindgame_pity,1);
									elseif _emo == 12 then
										utils.playSfx(media.sounds.mindgame_shame,1);
									end;
									_power = math.ceil(_power*chars_mobs_npcs[victim]["personality"]["current"]["affronts"]["modifer"]);
									chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo]+_power;

								end;
							else
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][3] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][3]+1;
								utils.playSfx(media.sounds.mindgame_boring,1);
							end;
							phrase2 = chars_mobs_npcs[victim].name .. ": " .. "...";
						elseif mindmissle == 35 then --connections
							phrase1 = npc_ttx[party.connections[global.current_connection]].name .. ". " .. chats.questionPerEtiquette("doyouknowhim",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
							local _known = false;
							local _power = 0;
							local _emo = 0;
							local _uid = 0;
							for i=1,#chars_mobs_npcs[victim]["personality"]["current"]["connections"] do
								if chars_mobs_npcs[victim]["personality"]["current"]["connections"][i] == global.connection_index then
										_known = true;
										_uid = i;
									break;
								end;
							end;
							if known and chars_mobs_npcs[victim].uid ~= _uid then
								_emo = chars_mobs_npcs[victim]["personality"]["current"]["connections"][i].emo;
								_power = chars_mobs_npcs[victim]["personality"]["current"]["connections"][i].power;
								if _emo == 1 then --FIXME add phrases
									utils.playSfx(media.sounds.mindgame_loyality,1);
								elseif _emo == 2 then
									utils.playSfx(media.sounds.mindgame_fear,1);
								elseif _emo == 3 then
									utils.playSfx(media.sounds.mindgame_boring,1);
								elseif _emo == 4 then
									utils.playSfx(media.sounds.mindgame_disdain,1);
								elseif _emo == 5 then
									utils.playSfx(media.sounds.mindgame_agression,1);
								elseif _emo == 6 then
									utils.playSfx(media.sounds.mindgame_distrust,1);
								elseif _emo == 7 then
									utils.playSfx(media.sounds.mindgame_cry,1);
								elseif _emo == 8 then
									utils.playSfx(media.sounds.mindgame_surprized,1);
								elseif _emo == 9 then
									utils.playSfx(media.sounds.mindgame_respect,1);
								elseif _emo == 10 then
									utils.playSfx(media.sounds.mindgame_lol,1);
								elseif _emo == 11 then
									utils.playSfx(media.sounds.mindgame_pity,1);
								elseif _emo == 12 then
										utils.playSfx(media.sounds.mindgame_shame,1);
								end;
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo]+_power;
								phrase2 = ""; -- this person is...
							elseif chars_mobs_npcs[victim].uid == _uid then
								local _same_name_emo = {3,2,3,4,5,6,3,3,3,10};
								_emo = math.random(1,#_same_name_emo);
								local _power = 1;
								if _emo == 1 then --FIXME add phrases
									utils.playSfx(media.sounds.mindgame_loyality,1);
								elseif _emo == 2 then
									utils.playSfx(media.sounds.mindgame_fear,1);
								elseif _emo == 3 then
									utils.playSfx(media.sounds.mindgame_boring,1);
								elseif _emo == 4 then
									utils.playSfx(media.sounds.mindgame_disdain,1);
								elseif _emo == 5 then
									utils.playSfx(media.sounds.mindgame_agression,1);
								elseif _emo == 6 then
									utils.playSfx(media.sounds.mindgame_distrust,1);
								elseif _emo == 7 then
									utils.playSfx(media.sounds.mindgame_cry,1);
								elseif _emo == 8 then
									utils.playSfx(media.sounds.mindgame_surprized,1);
								elseif _emo == 9 then
									utils.playSfx(media.sounds.mindgame_respect,1);
								elseif _emo == 10 then
									utils.playSfx(media.sounds.mindgame_lol,1);
								elseif _emo == 11 then
									utils.playSfx(media.sounds.mindgame_pity,1);
						         elseif _emo == 12 then
									utils.playSfx(media.sounds.mindgame_shame,1);
								end;
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][_emo]+_power;
								phrase2 = ""; --thats my name!
							else
								chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][3] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][3]+1;
								utils.playSfx(media.sounds.mindgame_boring,1);
								phrase2 = ""; --do not know him!
							end;
						elseif mindmissle == 36 then --music

						end;
						table.insert(mindgame_log,phrase1);
						if #mindgame_log > 6 then
							table.remove(mindgame_log,1);
						end;
						table.insert(mindgame_log,phrase2);
						if #mindgame_log > 6 then
							table.remove(mindgame_log,1);
						end;
						global.mindgame_counter = global.mindgame_counter + 1;
						draw.mindgameButtons();
						mindgame.path ();
					end;
				end;
			end;
		else
			utils.playSfx(media.sounds.error,1);
		end;
	end;
	--/mindgame
	if button == "r"  and game_status == "spellbook" then -- watching spell tips in the spellbook
		local x,y = helpers.centerObject(media.images.sbook);
		missle_type = helpers.bookCircles(page);
		if missle_type then
			show_spellbook_tips = 1;
		end;
	end;
	if button == "r"  and game_status == "warbook" then -- watching trick tips in the warbook
		local x,y = helpers.centerObject(media.images.wbook);
		missle_type = helpers.bookCircles(page);
		if missle_type then
			show_warbook_tips = 1;
		end;
	end;

	if  button == "l" and mX>global.screenWidth-180 and mX<global.screenWidth-130 and mY>global.screenHeight-110 and mY<global.screenHeight and chars_mobs_npcs[current_mob].person=="char" and chars_mobs_npcs[current_mob].control=="player" then
		if game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" then
			game_status = "inventory";
			inventory_bag_call();
			helpers.repackBag();
		elseif game_status == "inventory" and holding_smth == 0 then
			oil_smth = 0;
			drink_smth = 0;
			bomb_smth = 0;
			use_smth = 0;
			utils.playSfx(media.sounds.invclose,1);
			game_status="neutral";
		end;
	end;
	if  button == "l" and mX>=global.screenWidth-320 and mX<global.screenWidth-270 and mY>global.screenHeight-110 and mY<global.screenHeight-35 and chars_mobs_npcs[current_mob].person=="char" and chars_mobs_npcs[current_mob].control=="player" then
		if game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" then
			game_status="alchemy";
			inventory_bag_call();
			helpers.repackBag();
		elseif game_status == "alchemy"  then
			utils.playSfx(media.sounds.invclose,1);
			game_status="neutral";
		end;
	end;

	if  button == "l" and mX>=global.screenWidth-335 and mX<global.screenWidth-220 and mY>global.screenHeight-35 and mY<global.screenHeight and chars_mobs_npcs[current_mob].person=="char" and chars_mobs_npcs[current_mob].control=="player" then
		if game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" then
			game_status="picklocking";
			inventory_bag_call();
			helpers.repackBag();
		elseif game_status == "picklocking"  then
			utils.playSfx(media.sounds.invclose,1);
			game_status="neutral";
		end;
	end;

	--if  button == "l" and mX>=math.min(930,global.screenWidth-280) and mX<math.min(990,global.screenWidth-220) and mY>global.screenHeight-150 and mY<global.screenHeight-80 and chars_mobs_npcs[current_mob].person=="char" and chars_mobs_npcs[current_mob].control=="player" then
	if  button == "l" and mX>=global.screenWidth-380 and mX<global.screenWidth-350 and mY>global.screenHeight-150 and mY<global.screenHeight-80 and chars_mobs_npcs[current_mob].person=="char" and chars_mobs_npcs[current_mob].control=="player" then
		if game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" then
			game_status="map";
			utils.playSfx(media.sounds.paper,1);
		elseif game_status == "map"  then
			utils.playSfx(media.sounds.paper,1);
			game_status="neutral";
		end;
	end;

	if button == "r" and game_status == "buying" then
		tip_title = "";
		tip_classtitle = "";
		tip_class = "";
		tip_subclasstitle = "";
		tip_story = "";
		tip_titleskill = "";
		tip_price = "";
		tip_quantity = "";
		--bagid = 0;
		if wares == "armor" then
			local x,y = helpers.centerObject(media.images.shoparmor);
			local part = math.ceil(media.images.shoparmor:getWidth()/8);
			local borders = 32;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 200 and mY < y + media.images.shoparmor:getHeight() -200 then
					list = bars_list[current_bar];
					tmpinv = i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y and mY < y + 200 then
					list = bars_list[current_bar];
					tmpinv = 8+i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
		end;
		if wares == "melee" then
			local x,y = helpers.centerObject(media.images.shopmelee);
			local part = math.ceil(media.images.shopmelee:getWidth()/8);
			local borders = 32;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 50 and mY < y + media.images.shoparmor:getHeight() -100 then
					list = bars_list[current_bar];
					tmpinv = i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
		end;
		if wares == "alchemy" then
			local x,y = helpers.centerObject(media.images.shopalchemy);
			local part = math.ceil(media.images.shopalchemy:getWidth()/8);
			local borders = 32;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 50 and mY < y +150 then
					list = bars_list[current_bar];
					tmpinv = i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y+150 and mY < y +300 then
					list = bars_list[current_bar];
					tmpinv = 8+i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y +300 and mY < y+430 then
					list = bars_list[current_bar];
					tmpinv = 16+i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
		end;
		if wares == "books" then
			local x,y = helpers.centerObject(media.images.shopbooks);
			local part = math.ceil(media.images.shopbooks:getWidth()/8);
			local borders = 32;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 50 and mY < y +150 then
					list = bars_list[current_bar];
					tmpinv = i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y+150 and mY < y +300 then
					list = bars_list[current_bar];
					tmpinv = 8+i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y +300 and mY < y+430 then
					list = bars_list[current_bar];
					tmpinv = 16+i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
		end;
		if wares == "magic" then
			local x,y = helpers.centerObject(media.images.shopmagic);
			local part = math.ceil(media.images.shopmagic:getWidth()/8);
			local borders = 32;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 50 and mY < y +150 then
					list = bars_list[current_bar];
					tmpinv = i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y+150 and mY < y +300 then
					list = bars_list[current_bar];
					tmpinv = 8+i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y +300 and mY < y+430 then
					list = bars_list[current_bar];
					tmpinv = 16+i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
		end;
		if wares == "jewelry" then
			local x,y = helpers.centerObject(media.images.shopjewelry);
			local part = math.ceil(media.images.shopjewelry:getWidth()/8);
			local borders = 32;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 50 and mY < y +150 then
					list = bars_list[current_bar];
					tmpinv = i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y+150 and mY < y +300 then
					list = bars_list[current_bar];
					tmpinv = 8+i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y +300 and mY < y+430 then
					list = bars_list[current_bar];
					tmpinv = 16+i;
					if list[current_bar][tmpinv] ~= "none" then
						show_inventory_tips=1;
					end;
				end;
			end;
		end;
	end;

	if button == "l" and game_status == "buying" then
		if wares == "armor" then
			local x,y = helpers.centerObject(media.images.shoparmor);
			local part = math.ceil(media.images.shoparmor:getWidth()/8);
			local borders = 32;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 200 and mY < y + media.images.shoparmor:getHeight() -200 then
					list = bars_list[current_bar];
					tmpinv = i;
					local price,preprice = helpers.countPrice(helpers.countModifiedPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price),current_mob,victim,1,nil,nil,1,1);
					if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
						table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
						table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
						table.insert(bags,{});
						for k=1,15 do
							bags[#bags_list][k] = {};
							for l=1,11 do
								bags[#bags_list][k][l] = 0;
							end;
						end;
						bars_list[current_bar][tmpinv] = "none";
					end;
				end;
			end;
			for i =1,8 do
				if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y and mY < y + 200 then
					list = bars_list[current_bar];
					tmpinv = 8+i;
					local price,preprice = helpers.countPrice(helpers.countModifiedPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price),current_mob,victim,1,nil,nil,1,1);
					if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
						table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
						table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
						table.insert(bags,{});
						for k=1,15 do
							bags[#bags_list][k] = {};
							for l=1,11 do
								bags[#bags_list][k][l] = 0;
							end;
						end;
						bars_list[current_bar][tmpinv] = "none";
					end;

				end;
			end;
			if wares == "melee" then
				local x,y = helpers.centerObject(media.images.shoparmor);
				local part = math.ceil(media.images.shoparmor:getWidth()/8);
				local borders = 32;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 50 and mY < y + media.images.shoparmor:getHeight() -100 then
						list = bars_list[current_bar];
						tmpinv = i;
						local price,preprice = helpers.countPrice(helpers.countModifiedPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price),current_mob,victim,1,nil,nil,1,1);
						if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
			end;
			if wares == "alchemy" then
				local x,y = helpers.centerObject(media.images.shopalchemy);
				local part = math.ceil(media.images.shopalchemy:getWidth()/8);
				local borders = 32;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 50 and mY < y +150 then
						list = bars_list[current_bar];
						tmpinv = i;
						local price,preprice = helpers.countPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price,current_mob,victim,1,nil,nil,1,1);
						if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y+150 and mY < y +300 then
						list = bars_list[current_bar];
						tmpinv = 8+i;
						local price,preprice = helpers.countPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price,current_mob,victim,1,nil,nil,1,1);
						if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y +300 and mY < y+430 then
						list = bars_list[current_bar];
						tmpinv = 16+i;
						local price,preprice = helpers.countPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price,current_mob,victim,1,nil,nil,1,1);
						if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
			end;
			if wares == "books" then
				local x,y = helpers.centerObject(media.images.shopbooks);
				local part = math.ceil(media.images.shopbooks:getWidth()/8);
				local borders = 32;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 50 and mY < y +150 then
						list = bars_list[current_bar];
						tmpinv = i;
						local price,preprice = helpers.countPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price,current_mob,victim,1,nil,nil,1,1);
						if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y+150 and mY < y +300 then
						list = bars_list[current_bar];
						tmpinv = 8+i;
						if list[current_bar][tmpinv] ~= "none" then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y +300 and mY < y+430 then
						list = bars_list[current_bar];
						tmpinv = 16+i;
						local price,preprice = helpers.countPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price,current_mob,victim,1,nil,nil,1,1);
						if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
			end;
			if wares == "magic" then
				local x,y = helpers.centerObject(media.images.shopmagic);
				local part = math.ceil(media.images.shopmagic:getWidth()/8);
				local borders = 32;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 50 and mY < y +150 then
						list = bars_list[current_bar];
						tmpinv = i;
						local price,preprice = helpers.countPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price,current_mob,victim,1,nil,nil,1,1); --FIXME magical modifers
						if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y+150 and mY < y +300 then
						list = bars_list[current_bar];
						tmpinv = 8+i;
						if list[current_bar][tmpinv] ~= "none" then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y +300 and mY < y+430 then
						list = bars_list[current_bar];
						tmpinv = 16+i;
						if list[current_bar][tmpinv] ~= "none" then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
			end;
			if wares == "jewelry" then
				local x,y = helpers.centerObject(media.images.shopjewelry);
				local part = math.ceil(media.images.shopjewelry:getWidth()/8);
				local borders = 32;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y + 50 and mY < y +150 then
						list = bars_list[current_bar];
						tmpinv = i;
						local price,preprice = helpers.countPrice(helpers.countModifiedPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price),current_mob,victim,1,nil,nil,1,1);
						if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y+150 and mY < y +300 then
						list = bars_list[current_bar];
						tmpinv = 8+i;
						local price,preprice = helpers.countPrice(helpers.countModifiedPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price),current_mob,victim,1,nil,nil,1,1);
						if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
				for i =1,8 do
					if mX > x+part*(i-1)+borders and mX < x+part*i-borders and mY > y +300 and mY < y+430 then
						list = bars_list[current_bar];
						tmpinv = 16+i;
						local price,preprice = helpers.countPrice(helpers.countModifiedPrice(inventory_ttx[bars_list[current_bar][tmpinv].ttxid].price),current_mob,victim,1,nil,nil,1,1);
						if list[current_bar][tmpinv] ~= "none" and helpers.payGold(price) then
							table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
							table.insert(bags_list[#bags_list],{ttxid=bars_list[current_bar][tmpinv].ttxid,q=inventory_ttx[bars_list[current_bar][tmpinv].ttxid].material,w=bars_list[current_bar][tmpinv].w,e=bars_list[current_bar][tmpinv].e,r=1,h=0});
							table.insert(bags,{});
							for k=1,15 do
								bags[#bags_list][k] = {};
								for l=1,11 do
									bags[#bags_list][k][l] = 0;
								end;
							end;
							bars_list[current_bar][tmpinv] = "none";
						end;
					end;
				end;
			end;
		end;
	end;

	if button == "r" and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting" or game_status == "showinventory") and holding_smth==0 then
		tip_title = "";
		tip_classtitle = "";
		tip_class = "";
		tip_subclasstitle = "";
		tip_story = "";
		tip_titleskill = "";
		tip_price = "";
		tip_quantity = "";
		local bag_found = false;
		local x,y = helpers.centerObject(media.images.inv1);
		local inv_add_x = x+12;
		local inv_add_y = y-25;
		bagid = helpers.whatBag(current_mob)
		if not bagid then
			bagid = helpers.trapInFrontOf(current_mob)
		end;
		if bagid then
			bag_found = true;
		end;

		count_inv_tips = 0;
		if mX > inv_add_x and mX < inv_add_x+11*32 and mY>inv_add_y and mY < inv_add_y+15*32 then
			inv_quad_y = math.ceil((mX-inv_add_x)/32);
			inv_quad_x = math.ceil((mY-inv_add_y)/32);
			count_inv_tips = 1;
			list,bag,tmp_bagid = helpers.whatSortTarget("char",false,false,bagid);
		elseif bagid and bagid > 0 and mX > inv_add_x + inv_part2 and mX < inv_add_x+11*32+inv_part2 and mY > inv_add_y and mY < inv_add_y+15*32 and not bags_list[bagid].locked then
			inv_quad_y = math.ceil((mX-inv_part2-inv_add_x)/32);
			inv_quad_x = math.ceil((mY-inv_add_y)/32);
			count_inv_tips = 1;
			list,bag,tmp_bagid = helpers.whatSortTarget("bag",false,false,bagid);
		else
			for i=1,#global.slots do
				local present = nil;
				local ct_value = 0;
				if i <= 18 and game_status == "inventory" then
					present = chars_mobs_npcs[current_mob]["equipment"][global.slots[i]];
					ct_value = 2;
				elseif i > 18 and i <= 36 and game_status == "alchemy" then
					present = alchlab[current_mob][global.slots[i]];
					ct_value = 3;
				elseif i > 36 and i <= 40 and game_status == "picklocking" then
					present = picklock[current_mob][global.slots[i]];
					ct_value = 4;
				end;
				if present and present > 0 and helpers.inSlot(global.slots[i]) then
					slot = global.slots[i];
					list,bag,tmp_bagid = helpers.whatSortTarget("char",false,false,bagid);
					count_inv_tips = ct_value;
					break;
				end;
			end;
		end;
		if count_inv_tips == 1 then
			if bag[tmp_bagid][inv_quad_x][inv_quad_y] ~= 0 then
				tmp12 = bag[tmp_bagid][inv_quad_x][inv_quad_y];
				if tmp12 > 0 and tmp12 <= 10000 then
					tmpinv = tmp12;
					helpers.inv_tips_add(); --CHECK THIS
					tip_title = inventory_ttx[tmpinv2].title;
				elseif tmp12 > 10000 then
					tmp_s = tostring(tmp12);
					if (tmp12-10000) < 10 then
						tmpxi = tonumber(string.sub(tmp_s, 5,6));
					else
						tmpxi = tonumber(string.sub(tmp_s, 4,6));
					end;
					tmpyi = math.floor((tmp12-tmpxi)/10000);
					tmpinv = bag[tmp_bagid][tmpxi][tmpyi];
					helpers.inv_tips_add();
				end;
				show_inventory_tips=1;
			end;
		end;

		if count_inv_tips==2 then --inventory tips
			tmpinv=loadstring("return " .. "chars_mobs_npcs[current_mob]['equipment']." .. slot)();
			if tmpinv>0 then
				helpers.inv_tips_add();
				show_inventory_tips=1;
			end;
		end;

		if count_inv_tips==3 then --alchlab tips
			tmpinv=loadstring("return " .. "alchlab[current_mob]." .. slot)();
			if tmpinv>0 then
				helpers.inv_tips_add();
				show_inventory_tips=1;
			end;
		end;

		if count_inv_tips==4 then --picklock tips
			tmpinv=loadstring("return " .. "picklock[current_mob]." .. slot)();
			if tmpinv>0 then
				helpers.inv_tips_add();
				show_inventory_tips=1;
			end;
		end;
	end;

--btns under inventory frame

	local x,y = helpers.centerObject(media.images.inv1);
	if button == "l"  and game_status == "inventory" and mX > x+378 and mX < x+468 and mY > y+458 and mY < y+485 then
		th=current_mob;
		sorttarget="char";
		oldsorttarget="char";
		for i=1,15 do
			for j=1,11 do
				inventory_bag[current_mob][i][j]=0;
			end;
		end;
		helpers.resort_inv(current_mob);
	end;

	if button == "l"  and game_status == "inventory"  and mX > x+468 and mX < x+550 and mY > y+458 and mY < y+485 then
		inv_page=1;
	end;
	if button == "l"  and game_status == "inventory"  and mX > x+570 and mX < x+658 and mY > y+458 and mY < y+485 then
		inv_page=2;
	end;

	if button == "l"  and game_status == "inventory"  and mX > x+658 and mX < x+750 and mY > y+458 and mY < y+485 then
		--bagid=0;
		local bag_found = false;
		--[[for j=1, #bags_list do
			if chars_mobs_npcs[current_mob].x==bags_list[j].x and chars_mobs_npcs[current_mob].y==bags_list[j].y and not bag_found then
				bagid=j;
				bag_found = true;
			end;
		end;]]
		bagid = helpers.whatBag(current_mob)
		if not bagid then
			bagid = helpers.trapInFrontOf(current_mob)
		end;
		if bagid then
			bag_found = true;
		end;

		helpers.repackBag();
	end;

-- building buttons
	if current_house and game_status == "housewatch" then
		local x,y = helpers.centerObject(media.images.map);
		for i=1,#localtriggers[global.level_to_load][current_house].npcs do
			if love.mouse.isDown("l") and mY >= y and mY <= y+190 and mX >= x+55+100*(i-1) and mX <= x+55+100*(i-1)+80 then
				local index = localtriggers[global.level_to_load][current_house].npcs[i];
				victim = helpers.findNPCindex(index);
				chat (victim);
			end;
		end;
	end;
-- turning the pagesof

	if button == "l"  and  game_status == "literature" and littype == "book" then
		local x,y = helpers.centerObject(media.images.book);
		if mX>x and mX <= x+460 and mY>y+20 and mY < y+680 and pagebook > 1 then
			utils.playSfx(media.sounds.bookpage, 1);
			pagebook = pagebook-1;
		elseif  mX >= 460 and mX < x+960 and mY > y+20 and mY < y+680 and pagebook<books_ttx[list[tmp_book].q].pages then
			utils.playSfx(media.sounds.bookpage, 1);
			pagebook = pagebook + 1;
		end;
	end;
	
	if button == "l"  and  game_status == "questbook" then --FIXME notes and etc modes
		local x,y = helpers.centerObject(media.images.book);
		if mX>x and mX<=x+460 and mY>y+20 and mY<y+680 and global.questbook_page > 1 then
			utils.playSfx(media.sounds.bookpage, 1);
			global.questbook_page = global.questbook_page - 1;
		elseif  mX >= 460 and mX < x+960 and mY > y+20 and mY < y+680 and global.questbook_page < #party.quests then
			utils.playSfx(media.sounds.bookpage, 1);
			global.questbook_page = global.questbook_page + 1;
		end;
	end;
	
--btns at alchemy --FIXME: btns at alchemy picklocking traptools

--mills
	if button == "l"  and game_status == "alchemy" and mX > x+520 and mX < x +580 and mY > y+100 and mY < y+145  then-- mill components
		alchstatus="millcomponents"
		local powerlimit=(chars_stats[current_mob].lvl_alchemy*chars_stats[current_mob].num_alchemy+(chars_mobs_npcs[current_mob].num_alchemy-chars_stats[current_mob].num_alchemy)); --amulets and rings +alch
		if alchlab[current_mob].comp8>0 -- mill components
		and alchlab[current_mob].comp7==0
		and alchlab[current_mob].comp9==0
		--and chars_mobs_npcs[current_mob].lvl_alchemy>0
		and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp8].ttxid].subclass == "raw"
		and alchlab[current_mob].tool2>0 then
			utils.playSfx(media.sounds.mill,1);
			local tclr=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp8].ttxid].b;
			local tmpcolor=raws[tclr]
			local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
			tmpnumber=alchlab[current_mob].comp8;
			local temppower=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp8].ttxid].a;
			local tmp_c1=math.ceil(temppower*inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].tool2].ttxid].a/100);
			local tmp_c2=temppower-tmp_c1;
			local temppower2=tmp_c1+math.random(tmp_c2);
			alchlab[current_mob].comp8=0;
			table.remove(list,tmpnumber);
			helpers.renumber(tmpnumber,current_mob);
			table.insert(list,{ttxid=tmpcolor,q=temppower2,w=0,e=0,r=1});
			alchlab[current_mob].comp8=#list;
		--combine components
		elseif alchlab[current_mob].comp8==0
		and alchlab[current_mob].comp7>0
		and alchlab[current_mob].comp9>0
		and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp7].ttxid].b==inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp9].ttxid].b
		and math.abs(chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp7].q-chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp9].q)<=powerlimit
		--and chars_mobs_npcs[current_mob].lvl_alchemy>0
		and alchlab[current_mob].tool2>0 then
			utils.playSfx(media.sounds.mill,1);
			local tclr=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp7].ttxid].b
			local tmpcolor=raws[tclr];
			local tmpnumber1=alchlab[current_mob].comp7;
			local tmpnumber2=alchlab[current_mob].comp9;
			local temppower=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp7].ttxid].a+inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp9].ttxid].a;
			local tmp_c1=math.ceil(temppower*inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].tool2].ttxid].a/100);
			local tmp_c2=temppower-tmp_c1;
			local temppower2=math.min(tmp_c1+math.random(tmp_c2),powerlimit);
			alchlab[current_mob].comp7=0;
			alchlab[current_mob].comp9=0;
			table.remove(list,tmpnumber1);
			helpers.renumber(tmpnumber1,current_mob);
			table.remove(list,tmpnumber2);
			for d=1,11 do
				for e=1,15 do
					if bag[current_mob][e][d]>tmpnumber2 and bag[current_mob][e][d]<10000 then
						bag[current_mob][e][d]=bag[current_mob][e][d]-1;
					end;
				end;
			end;
			helpers.renumber(tmpnumber2,current_mob);
			table.insert(list,{ttxid=tmpcolor,q=temppower2,w=0,e=0,r=1});
			alchlab[current_mob].comp8=#list;
		elseif alchlab[current_mob].comp8>0-- split components
		and alchlab[current_mob].comp7==0
		and alchlab[current_mob].comp9==0
		--and chars_mobs_npcs[current_mob].lvl_alchemy>0
		--and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp8].ttxid].subclass == "gom"
		and alchlab[current_mob].tool2>0 then
			utils.playSfx(media.sounds.mill,1);
			local tclr=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp8].ttxid].b;
			local tmpcolor=raws[tclr];
			local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
			tmpnumber=alchlab[current_mob].comp8;
			local temppower=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].comp8].ttxid].a;
			local tmp_c1=math.ceil(temppower*inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].tool2].ttxid].a/100);
			local tmp_c2=temppower-tmp_c1;
			local temppower2=tmp_c1+math.random(tmp_c2);
			local tmp_c3=math.ceil(temppower2/2);
			local tmp_c4=temppower2-tmp_c3;
			alchlab[current_mob].comp8=0;
			table.remove(list,tmpnumber);
			helpers.renumber(tmpnumber,current_mob);
			table.insert(list,{ttxid=tmpcolor,q=tmpc_3,w=0,e=0,r=1});
			table.insert(list,{ttxid=tmpcolor,q=tmpc_4,w=0,e=0,r=1});
			alchlab[current_mob].comp7=#list;
			alchlab[current_mob].comp9=#list-1;
			end;
		end;
		--/mills
		--cauldron
		if   button == "l"  and game_status == "alchemy"
		and mX > x+520 and mX < x +580 and mY > y+215 and mY < y + 260
		and alchlab[current_mob].bottle1>0
		and chars_mobs_npcs[current_mob].lvl_alchemy>0
		and alchlab[current_mob].tool1>0
		and (alchlab[current_mob].comp1>0
		or alchlab[current_mob].comp2>0
		or alchlab[current_mob].comp3>0
		or alchlab[current_mob].comp4>0
		or alchlab[current_mob].comp5>0
		or alchlab[current_mob].comp6>0)
		then
			alchstatus = "boiledfromcomponents";
			while (#comparray>0) do
				table.remove(comparray,1);
			end;
			utils.playSfx(media.sounds.alch_guggle,1);
			temppotion="";
			sumcomp="";
			tempcomp="";
			tempslot="";
			comparray={};
			for j=1,6 do
				tempslot=loadstring("return " .. "alchlab[" .. current_mob .. "].comp" .. j)();
				if tempslot~=0 then
					tempcomp=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][tempslot].ttxid].b;
					table.insert(comparray,tempcomp);
					sumcomp=sumcomp .. tempcomp;
				end;
			end;
			if sumcomp ~= "" then
				--combinatorika factorial
				helpers.findpotion (comparray, #comparray);
			end;
		end;
		--/cauldron
		--alembic
		if   button == "l"  and game_status == "alchemy"
		and mX > x+520 and mX < x +580 and mY > y+330 and mY < y+375
		and chars_mobs_npcs[current_mob].lvl_alchemy>0
		and alchlab[current_mob].tool3>0
		and alchlab[current_mob].bottle2>0
		and alchlab[current_mob].bottle3>0
		then
			alchstatus = "mixedpotions"
			comparray={}
			comparray[1]=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].c
			comparray[2]=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].c
			local powerlimit=(chars_stats[current_mob].lvl_alchemy*chars_stats[current_mob].num_alchemy+(chars_mobs_npcs[current_mob].num_alchemy-chars_stats[current_mob].num_alchemy)) --amulets and rings +alch
			print("powerlimit",powerlimit)
			if inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].subclass~="bubuz"
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].subclass~="catalizator"
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].class~="bottle"
			and #inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].c<=3
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].subclass~="bubuz"
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].subclass~="catalizator"
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].class~="bottle"
			and #inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].c<=3
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].id ~= inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].id
			and #inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].c+#inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].c<=5
			and #inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].c+#inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].c<= chars_stats[current_mob].lvl_alchemy
			and math.abs(chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].q-chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].q)<=powerlimit
			then
				utils.playSfx(media.sounds.alch_guggle,1);
				local tmppower=math.min(chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].q,chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].q,powerlimit);
				local tmppower2=math.ceil(tmppower*inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].tool3].ttxid].a/100);
				local tmppower3=tmppower2+math.random(tmppower-tmppower2);
				chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3]={ttxid=raws.tare,q=1,w=1,e=1,r=1};
				mixedpotion=raws.buz;
				helpers.findpotion (comparray, #comparray);
				chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2]={ttxid=mixedpotion,q=tmppower3,w=1,e=1,r=1}
				helpers.addToActionLog( chars_stats[current_mob].name .. lognames.actions.distillated[chars_stats[current_mob].gender] .. inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].title .. lognames.actions.ofpower .. tmppower3)
			elseif ((inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].subclass~="catalizator" and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].subclass == "catalizator") or (inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].subclass == "catalizator" and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].subclass~="catalizator"))
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].class~="bottle"
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].class~="bottle"
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].id ~= inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].id
			and #inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].c+#inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].c<= chars_stats[current_mob].lvl_alchemy
			and math.abs(chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].q-chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].q)<=powerlimit
			then --using catalisator
				utils.playSfx(media.sounds.alch_guggle,1);
				local tmppower=math.min(chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].q+chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].q,powerlimit);
				local tmppower2=math.ceil(tmppower*inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].tool3].ttxid].a/100);
				local tmppower3=tmppower2+math.random(tmppower-tmppower2);
				if inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].subclass~="catalizator" then
					mixedpotion=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].id;
					chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2]={ttxid=mixedpotion,q=tmppower3,w=1,e=1,r=1};
					chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3]={ttxid=raws.tare,q=1,w=1,e=1,r=1};
				elseif inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].subclass~="catalizator" then
					mixedpotion=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].id;
					chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3]={ttxid=mixedpotion,q=tmppower3,w=1,e=1,r=1};
					chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2]={ttxid=raws.tare,q=1,w=1,e=1,r=1};
				end;
				helpers.addToActionLog( chars_stats[current_mob].name .. lognames.actions.enchancedpotion[chars_stats[current_mob].gender] .. inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].title .. lognames.actions.ofpower .. tmppower3)
			elseif --concentrating potions
			inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].class~="bottle"
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].class~="bottle"
			and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].id == inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].id
			then
				utils.playSfx(media.sounds.alch_guggle,1);
				local tmppower=math.min(chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].q+chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].q,powerlimit)
				local tmppower2=math.ceil(tmppower*inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].tool3].ttxid].a/100)
				local tmppower3=tmppower2+math.random(tmppower-tmppower2)
				chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3]={ttxid=raws.tare,q=1,w=1,e=1,r=1}
				mixedpotion=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].id
				chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2]={ttxid=mixedpotion,q=tmppower3,w=1,e=1,r=1}
				helpers.addToActionLog( chars_stats[current_mob].name .. lognames.actions.distillated[chars_stats[current_mob].gender] .. inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].title .. lognames.actions.ofpower .. tmppower3)
			elseif --separating potions
			((inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].class == "bottle" and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].class~="bottle") or (inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].class~="bottle" and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].ttxid].class == "bottle"))
			then
				utils.playSfx(media.sounds.alch_guggle,1);
				mixedpotion=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].ttxid].id
				local tmppower=math.ceil(chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].q+chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].q/2);
				local tmppower2=chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2].q+chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3].q-tmppower;
				chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle2]={ttxid=mixedpotion,q=tmppower,w=1,e=1,r=1};
				chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle3]={ttxid=mixedpotion,q=tmppower2,w=1,e=1,r=1};
			end;
		end;
	--/alembic
--btns at picklocking
		if button == "l" and game_status == "picklocking" and picklock[current_mob].key > 0 then
			local keycode = {};
			local tmpk = "";
			local tmp = tostring(chars_mobs_npcs[current_mob]["inventory_list"][picklock[current_mob].key].w);
			for w in string.gmatch(tmp, "%d") do
				table.insert(keycode, w);
			end;
			for i=1,10 do
				for h=1,keycode[i] do
					if mX >= x+522+i*17 and mX <= x+522+i*17 + 17 and mY >= y+300-keycode[i]*14 and mY <= y+310 then
						keycode[i] = math.max(0,tonumber(keycode[i]) - 1);
						--low skill
						local chanceToMakePicklock = chars_mobs_npcs[current_mob].dex + math.ceil(chars_mobs_npcs[current_mob].lvl_picklocking*chars_mobs_npcs[current_mob].num_picklocking);
						local rollChance = math.random(1,100);
						if chanceToMakePicklock < rollChance then
							local roll = math.random(1,3);
							if roll == 1 and i > 1 and math.abs(keycode[i]-keycode[i-1])<=2 then
								keycode[i-1] = math.max(0,tonumber(keycode[i-1]) - 1);
							end;
							if roll == 2 and i < 10 and math.abs(keycode[i]-keycode[i+1])<=2 then
								keycode[i+1] = math.max(0,tonumber(keycode[i+1]) - 1);
							end;
							if roll == 3 and i < 10 and keycode[i] > 0 then
								keycode[i] = math.max(0,tonumber(keycode[i]) - 1);
							end;
						end;
						--/low skill
						for j=1,10 do
							tmpk = tmpk .. tostring(keycode[j]);
						end;
						utils.playSfx(media.sounds.making_picklock,1);
						chars_mobs_npcs[current_mob]["inventory_list"][picklock[current_mob].key].w = tmpk;
						break;
					end;
				end;
			end;
		end;

		if button == "l" and game_status == "picklocking" and helpers.whatBag (current_mob) and bags_list[helpers.whatBag(current_mob)].locktype == 2 and picklock[current_mob].picklock > 0 and inventory_ttx[list[picklock[current_mob].picklock].ttxid].subclass == "cpicklock" then
			local lockcode = {};
			local code = bags_list[bagid].lockcode;
			for w in string.gmatch(code, "%d") do
				table.insert(lockcode, tonumber(w));
			end;
			local keycode = {};
			if picklock[current_mob].key> 0 then
				local tmpk = "";
				local tmp = tostring(chars_mobs_npcs[current_mob]["inventory_list"][picklock[current_mob].key].w);
				for w in string.gmatch(tmp, "%d") do
					table.insert(keycode, tonumber(w));
				end;
			end;
			local traptriggers = {};
			if bags_list[bagid].traped then
				local tmp = tostring(bags_list[bagid].triggers);
				for w in string.gmatch(tmp, "%d") do
					table.insert(traptriggers, tonumber(w));
				end;
			end;
			for i=1,10 do
				if mX >= x+540+i*16 + 2 and mX <= x+540+i*16 + 14 and mY >= y+95 and mY <= y+140 and lockcode[i] > 0 then
					local opened_fingers = 0;
					for h=1,10 do
						if lock_elements[h] == 0 and lockcode[h] > 0 and (picklock[current_mob].key == 0 or (picklock[current_mob].key > 0 and keycode[h] ~= lockcode[h])) then
							opened_fingers = opened_fingers + 1;
						end;
					end;
					local successFactor = chars_mobs_npcs[current_mob].lvl_picklocking*chars_mobs_npcs[current_mob].num_picklocking;
					local success = false;
					if successFactor >= opened_fingers*10 then
						success = true;
					end;

					if lock_elements[i] == 1 and success then
						lock_elements[i] = 0;
						utils.playSfx(media.sounds.click,1);
					elseif lock_elements[i] == 1 and not success then
						lock_elements[i] = 0;
						utils.playSfx(media.sounds.click,1);
						for j=1,10 do
							local roll = math.random(1,120);
							if lock_elements[j] == 0 and roll > chars_mobs_npcs[current_mob].luk and j ~= i then --crack!
								lock_elements[j] = 1;
								utils.playSfx(media.sounds.click,1);
								helpers.chestTrapCylinder(bagid,traptriggers[j]);
								helpers.breakAllPicklocks (current_mob);
							end;
						end;
					else
						lock_elements[i] = 1;
						utils.playSfx(media.sounds.click,1);
					end;
				end;
			end;
		end;

		if button == "wd" and game_status == "picklocking" and helpers.whatBag (current_mob) and bags_list[helpers.whatBag(current_mob)].locktype == 3 and picklock[current_mob].picklock > 0 and inventory_ttx[list[picklock[current_mob].picklock].ttxid].subclass == "dpicklock" then
			local lockcode = {};
			local code = bags_list[bagid].lockcode;
			for w in string.gmatch(code, "%d") do
				table.insert(lockcode, tonumber(w));
			end;
			local traptriggers = {};
			if bags_list[bagid].traped then
				local tmp = tostring(bags_list[bagid].triggers);
				for w in string.gmatch(tmp, "%d") do
					table.insert(traptriggers, tonumber(w));
				end;
			end;
			for i=1,10 do
				if mX >= x+540+i*17 and mX <= x+540+i*17 + 15 and mY >= y+85 and mY <= y+140 and lockcode[i] > 0 then
					if diskcode[i] < 8 then
						diskcode[i] = diskcode[i] +1;
					else
						diskcode[i] = 1;
						if bags_list[bagid].traped and traptriggers[i] == 1 then
							helpers.chestTrapDisk(bagid);
							helpers.breakAllPicklocks (current_mob);
						end;
					end;
					local successFactor = chars_mobs_npcs[current_mob].lvl_picklocking*chars_mobs_npcs[current_mob].num_picklocking;
					local success = false;
					local roll = math.random(1,100);
					if successFactor >= roll then
						success = true;
					end;
					if not success then
						if i < 8 then
							local luckyroll = math.random(1,100);
							if chars_mobs_npcs[current_mob].luk < luckyroll then
								if diskcode[i+1] < 8 then
									diskcode[i+1] = diskcode[i+1] +1;
								else
									diskcode[i+1] = 1;
									if bags_list[bagid].traped and traptriggers[i+1] == 1 then
										helpers.chestTrapDisk(bagid);
										helpers.breakAllPicklocks (current_mob);
									end;
								end;
							end;
						end;
						if i > 1 then
							local luckyroll = math.random(1,100);
							if chars_mobs_npcs[current_mob].luk < luckyroll then
								if diskcode[i-1] < 8 then
									diskcode[i-1] = diskcode[i-1] +1;
								else
									diskcode[i-1] = 1;
									if bags_list[bagid].traped and traptriggers[i-1] == 1 then
										helpers.chestTrapDisk(bagid);
										helpers.breakAllPicklocks (current_mob);
									end;
								end;
							end;
						end;
					end;
					utils.playSfx(media.sounds.click,1);
				end;
			end;
			helpers.breakAllPicklocks (current_mob);
		end;

		if button == "wu" and game_status == "picklocking" and helpers.whatBag (current_mob) and bags_list[helpers.whatBag(current_mob)].locktype == 3 and picklock[current_mob].picklock > 0 and inventory_ttx[list[picklock[current_mob].picklock].ttxid].subclass == "dpicklock" then
			local lockcode = {};
			local code = bags_list[bagid].lockcode;
			for w in string.gmatch(code, "%d") do
				table.insert(lockcode, tonumber(w));
			end;
			local traptriggers = {};
			if bags_list[bagid].traped then
				local tmp = tostring(bags_list[bagid].triggers);
				for w in string.gmatch(tmp, "%d") do
					table.insert(traptriggers, tonumber(w));
				end;
			end;
			for i=1,10 do
				if mX >= x+540+i*17 and mX <= x+540+i*17 + 15 and mY >= y+85 and mY <= y+140 and lockcode[i] > 0 then
					if diskcode[i] > 1 then
						diskcode[i] = diskcode[i] -1;
						if diskcode[i] == 1 and bags_list[bagid].traped and traptriggers[i] == 1 then
							helpers.chestTrapDisk(bagid);
							helpers.breakAllPicklocks (current_mob);
						end;
					else
						diskcode[i] = 8;
					end;
					local successFactor = chars_mobs_npcs[current_mob].lvl_picklocking*chars_mobs_npcs[current_mob].num_picklocking;
					local success = false;
					local roll = math.random(1,100);
					if successFactor >= roll then
						success = true;
					end;
					if not success then
						if i < 8 then
							local luckyroll = math.random(1,100);
							if chars_mobs_npcs[current_mob].luk < luckyroll then
								if diskcode[i+1] > 1 then
									diskcode[i+1] = diskcode[i+1] -1;
									if diskcode[i+1] == 1 and bags_list[bagid].traped and traptriggers[i+1] == 1 then
										helpers.chestTrapDisk(bagid);
										helpers.breakAllPicklocks (current_mob);
									end;
								else
									diskcode[i+1] = 8;
								end;
							end;
						end;
						if i > 1 then
							local luckyroll = math.random(1,100);
							if chars_mobs_npcs[current_mob].luk < luckyroll then
								if diskcode[i-1] > 1 then
									diskcode[i-1] = diskcode[i-1] -1;
									if diskcode[i-1] == 1 and bags_list[bagid].traped and traptriggers[i-1] == 1 then
										helpers.chestTrapDisk(bagid);
										helpers.breakAllPicklocks (current_mob);
									end;
								else
									diskcode[i-1] = 8;
								end;
							end;
						end;
						helpers.chestTrapDisk(bagid);
						helpers.breakAllPicklocks (current_mob);
					end;
					utils.playSfx(media.sounds.click,1);
				end;
			end;
			helpers.breakAllPicklocks (current_mob);
		end;
		-- use forcer
		if button == "l" and game_status == "picklocking" and helpers.whatBag (current_mob) and bags_list[helpers.whatBag(current_mob)].locked
		and mX > x+395 and mX < x+425 and mY > y+155 and mY < y+185 then
			local chance = chars_mobs_npcs[current_mob].mgt;
			if picklock[current_mob].forcer > 0 then
				chance = chance*2;
			else
				if chars_mobs_npcs[current_mob]["equipment"].rh > 0 then
					chars_mobs_npcs[current_mob]["invemtory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].q = 0;
					local str = helpers.mobName(current_mob) .. " " .. lognames.actions.broke[chars_mobs_npcs[current_mob].gender] .. " " .. lognames.skills[chars_mobs_npcs[current_mob]["invemtory_list"][chars_mobs_npcs[current_mob]["equipment"].rh].class]
					helpers.addToActionLog(str);
					media.sounds.crack:play();
				else
					chars_mobs_npcs[current_mob].rh = 0;
					local str = helpers.mobName(current_mob) .. " " .. lognames.actions.traumed[chars_mobs_npcs[current_mob].gender] .. " " .. lognames.bodypartsr.hand;
					helpers.addToActionLog(str);
					--cry of pain
				end;
			end;
			if chance > bags_list[bagid].material then
				helpers.chestTrapDisarmFailed (bagid);
				bags_list[bagid].opened = true;
				calendar.add_time_interval(calendar.delta_picklocking);
				helpers.addToActionLog( lognames.actions.burgled);
			else
				calendar.add_time_interval(calendar.delta_picklocking);
				helpers.addToActionLog( lognames.actions.notenoughmight);
			end;
		end;
		--disarming --FIXME: chest door ground, remove ground trap at disarming
		if button == "l" and game_status == "picklocking" and ((helpers.whatBag (current_mob) and bags_list[helpers.whatBag(current_mob)].traped) or helpers.trapInFrontOf(current_mob)) then --and picklock[current_mob].picklock > 0 and inventory_ttx[list[picklock[current_mob].picklock].ttxid].subclass == "dpicklock" then
			bagid = helpers.whatBag (current_mob);
			local condition = "";
			if bagid then
				condition = bags_list[helpers.whatBag(current_mob)].inspected and not bags_list[helpers.whatBag(current_mob)].inspcode[counter];
			else
				bagid = helpers.trapInFrontOf(current_mob);
				condition = bags_list[helpers.trapInFrontOf(current_mob)].inspected and not bags_list[helpers.trapInFrontOf(current_mob)].inspcode[counter];
			end;
			local trapcode = {};
			local tmp = tostring(bags_list[bagid].trapcode);
			for w in string.gmatch(tmp, "%d") do
				table.insert(trapcode, tonumber(w));
			end;
			local counter = 1;
			local complication = math.sqrt(#trapcode);
			for i=1,complication do
				for h=1,complication do
					local successFactor = chars_mobs_npcs[current_mob].num_traps*chars_mobs_npcs[current_mob].lvl_traps+chars_mobs_npcs[current_mob].dex;
					local lucky = false;
					if mX > x+575+h*25 and mX < x+575+(h+1)*25 and mY > 620-i*25 and mY < y+400-(i-1)*25 and mY > y+400-i*25 then
						if condition then
							successFactor = math.ceil(successFactor*0.75);
						end;
						local roll = math.random(1,100);
						if roll >= 100 - successFactor then
							lucky = true;
						else
							lucky = false;
						end;
					end;
					if mX > x+575+h*25 and mX < x+575+(h+1)*25 and mY > 620-i*25 and mY < y+400-(i-1)*25 and mY > y+400-i*25 then
						if trapcode[counter] == 0 and condition then
							if not lucky then
								helpers.breakTrapTool (bagid);
							end;
						end;
					end;
					if mX > x+575+h*25 and mX < x+575+(h+1)*25 and mY > 620-i*25 and mY < y+400-(i-1)*25 and mY > y+400-i*25 and picklock[current_mob].traptool > 0 and inventory_ttx[list[picklock[current_mob].traptool].ttxid].a == trapcode[counter] and lucky then
						if trapcode[counter] > 0 then
							utils.playSfx(media.sounds.click,1);
							trapcode[counter] = 0;
							local tmp_trapcode = "";
							for k=1,complication^2 do
								tmp_trapcode = tmp_trapcode .. tostring(trapcode[k]);
							end;
							bags_list[bagid].trapcode = tmp_trapcode;
							if helpers.ifTrapDisarmed(bags_list[bagid].trapcode) then
								helpers.afterTrapDisarmed(bagid);
							end;
						end;
					elseif mX > x+575+h*25 and mX < x+575+(h+1)*25 and mY > 620-i*25 and mY < y+400-(i-1)*25 and mY > y+400-i*25 and picklock[current_mob].traptool > 0 and (inventory_ttx[list[picklock[current_mob].traptool].ttxid].a ~= trapcode[counter]) then
						local roll = math.random(1,100);
						if trapcode[counter] > 0 and chars_mobs_npcs[current_mob].luk > roll then
							helpers.chestTrapDisarmFailed(bagid);
							helpers.breakAllPicklocks (current_mob);
						elseif trapcode[counter] > 0 and chars_mobs_npcs[current_mob].luk <= roll then
							helpers.breakTrapTool (bagid);
						end;
					end;
					counter = counter + 1;
				end;
			end;
		end;
--/--btns at picklocking
--btns at skills
		if button == "l" and game_status == "skills" then
			local counter=0;
			local counter2 = 0;
			local counter3 = 0;
			local x,y = helpers.centerObject(media.images.skills);
			local btn_width = 14;
			for i=1,40 do
				local tmpnum2 = temporal_skills[i];
				if i <= 16 and tmpnum2 > 0 then
					counter2 = counter2 + 1;
				end;
				if i <= 25 and tmpnum2 > 0 then
					counter3 = counter3 + 1;
				end;
			end;
			for i=1,40 do
				local tmpnum2 = temporal_skills[i];
				if tmpnum2 > 0 then
					counter = counter + 1;
					if i <= 11 and mX >= x+220 and mX <= x+220+btn_width and mY >= y-30+(counter-1)*30 and mY <= y-30+(counter-1)*30+btn_width then
						local needpoints = temporal_skills[i]+1;
						if temp_skillpoints >=	needpoints then
							temporal_skills[i] = temporal_skills[i] + 1;
							temp_skillpoints = temp_skillpoints - needpoints;
						end;
					elseif i > 11 and i <= 16 and mX >= x+220 and mX <= x+220+btn_width and mY >= y-30+(counter-1)*30+(i-counter) and mY <= y-30+(counter-1)*30+(i-counter)+btn_width then
						local needpoints = temporal_skills[i]+1;
						if temp_skillpoints >=	needpoints then
							temporal_skills[i] = temporal_skills[i] + 1;
							temp_skillpoints = temp_skillpoints - needpoints;
						end;
					elseif i>16 and i <= 25 and mX >= x+610 and mX <= x+610+btn_width and mY >= y-30-(counter-1)*30-counter2*30 and mY <= y-30+(counter-1)*30+btn_width-counter2*30 then
						local needpoints = temporal_skills[i]+1;
						if temp_skillpoints >=	needpoints then
							temporal_skills[i] = temporal_skills[i] + 1;
							temp_skillpoints = temp_skillpoints - needpoints;
						end;
					elseif i > 25 and i <= 39 and mX >= x+1010 and mX <= x+1010+btn_width and mY >= y-30+(counter-1)*30-counter3*30 and mY <= y-30+(counter-1)*30+btn_width-counter3*30 then
						local needpoints = temporal_skills[i]+1;
						if temp_skillpoints >=	needpoints then
							temporal_skills[i] = temporal_skills[i] + 1;
							temp_skillpoints = temp_skillpoints - needpoints;
						end;
					end;
				end;
			end;
		end;

		if button == "l" and game_status == "skills" then
			local counter=0;
			local counter2 = 0;
			local counter3 = 0;
			local x,y = helpers.centerObject(media.images.skills);
			local btn_width = 14;
			for i=1,40 do
				local tmpnum2 = temporal_skills[i];
				if i<= 16 and tmpnum2 > 0 then
					counter2 = counter2 + 1;
				end;
				if i<= 25 and tmpnum2 > 0 then
					counter3 = counter3 + 1;
				end;
			end;
			for i=1,40 do
				local tmpnum2 = temporal_skills[i];
				if tmpnum2 > 0 then
					counter = counter + 1;
					if i <= 11 and mX >= x+180 and mX <= x+180+btn_width and mY >= y-30+(counter-1)*30 and mY <= y-30+(counter-1)*30+btn_width then
						local tmpnum1 = "chars_mobs_npcs[current_mob].num_" .. skills[i];
						local tmpnum2 = loadstring("return " .. tmpnum1)();
						if temporal_skills[i] >	tmpnum2 then
							local freepoints = temporal_skills[i];
							temporal_skills[i] = temporal_skills[i] - 1;
							temp_skillpoints = temp_skillpoints + freepoints;
						end;
					elseif i > 11 and i <= 16 and mX >= x+180 and mX <= x+180+btn_width and mY >= y-30+(counter-1)*30-(i-counter)*30 and mY <= y-30+(counter-1)*30+(i-counter)+btn_width then
						local tmpnum1 = "chars_mobs_npcs[current_mob].num_" .. skills[i];
						local tmpnum2 = loadstring("return " .. tmpnum1)();
						if temporal_skills[i] >	tmpnum2 then
							local freepoints = temporal_skills[i];
							temporal_skills[i] = temporal_skills[i] - 1;
							temp_skillpoints = temp_skillpoints + freepoints;
						end;
					elseif i>16 and i <= 25 and mX >= x+570 and mX <= x+570+btn_width and mY >= y-30+(counter-1)*30-counter2*30 and mY <= y-30+(counter-1)*30+btn_width-counter2*30 then
						local tmpnum1 = "chars_mobs_npcs[current_mob].num_" .. skills[i];
						local tmpnum2 = loadstring("return " .. tmpnum1)();
						if temporal_skills[i] >	tmpnum2 then
							local freepoints = temporal_skills[i];
							temporal_skills[i] = temporal_skills[i] - 1;
							temp_skillpoints = temp_skillpoints + freepoints;
						end;
					elseif i > 25 and i <= 39 and mX >= x+970 and mX <= x+970+btn_width and mY >= y-30+(counter-1)*30-counter3*30 and mY <= y-30+(counter-1)*30+btn_width-counter3*30 then
						local tmpnum1 = "chars_mobs_npcs[current_mob].num_" .. skills[i];
						local tmpnum2 = loadstring("return " .. tmpnum1)();
						if temporal_skills[i] >	tmpnum2 then
							local freepoints = temporal_skills[i];
							temporal_skills[i] = temporal_skills[i] - 1;
							temp_skillpoints = temp_skillpoints + freepoints;
						end;
					end;
				end;
			end;
		end;

	--/--btns at skills
		if button == "l" -- pass turn
		and mX>=global.screenWidth-50 and mX<=global.screenWidth
		and mY>=global.screenHeight-160 and mY<=global.screenHeight-60
		and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding")
		and chars_mobs_npcs[current_mob].person=="char"
		and chars_mobs_npcs[current_mob].control=="player"
		then
			local switch_level = helpers.ifSwitchLevel();
			if switch_level then
				game_status="asktoswitchlevel";
				helpers.switchLevelAsk(switch_level);
			else
				chars_mobs_npcs[current_mob].rt=math.max(chars_mobs_npcs[current_mob].rt-standart_rtadd,0);
				game_status="restoring";
				ignore_kb=1;
			end;
		end;

		if button == "l"
		and ((mX>=1100 and mX<=1220 and mY>=900 and mY<=1000) or (mX>=1150 and mX<=1190 and mY>=820 and mY<=880))
		and global.status == "peace"
		and chars_mobs_npcs[current_mob].person=="char"
		and chars_mobs_npcs[current_mob].control=="player"
		then
			letaBattleBegin ();
		end;
		--status buttons
		if button == "l"  and mX > 530 and mX < 580 and mY > global.screenHeight-133 and mY < global.screenHeight-10 and (game_status == "neutral" or game_status == "sensing") then
			game_status = "pathfinding";
			global.wheeled = 0;
			global.traced = 0;
			for i = 1, #chars_mobs_npcs do
				if chars_mobs_npcs[i].control == "player" then
					trace.first_watch(i);
				end;
			end;
			trace.chars_around();
			trace.clear_rounded();
		elseif  button == "l"  and mX > 580 and mX < 620 and mY > global.screenHeight-93 and mY < global.screenHeight-10 and (game_status == "neutral" or game_status == "pathfinding") then
			game_status = "sensing";
		elseif  button == "l"  and mX > 530 and mX < 560 and mY > global.screenHeight-160 and mY < global.screenHeight-40 and game_status == "pathfinding" then
			game_status = "neutral";
			helpers.neutralWatch ();
		elseif  button == "l"  and mX > 530 and mX < 580 and mY > global.screenHeight-160 and mY < global.screenHeight-130 and game_status == "sensing" then
			game_status = "neutral";
			helpers.neutralWatch ();
		end;

		if button == "l"  and mX > global.screenWidth-180 and mX < global.screenWidth-80 and mY > global.screenHeight-160 and mY < global.screenHeight-110 and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting" or game_status == "skills" or game_status == "stats") then
			helpers.harvestOne (chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
		end;

		if button == "l" and love.keyboard.isDown("lctrl") then
			for i=1,chars do
				if mX>i*125-95 and mX<i*125-95+80+40 and mY>global.screenHeight-110 and mY<=global.screenHeight then
					if game_status ~= "stats" then
						tmp_mob = i;
						game_status = "stats";
					else
						game_status = "neutral";
						tmp_mob = current_mob;
					end;
				end;
			end;
		end;

		if button == "r"  and love.keyboard.isDown("lctrl") then
			for i=1,chars do
				if mX>i*125-95 and mX<i*125-95+80+40 and mY>global.screenHeight-110 and mY<=global.screenHeight then
					if game_status ~= "skills" then
						tmp_mob = i;
						charskills_call(tmp_mob);
					else
						game_status = "neutral";
						tmp_mob = current_mob;
					end;
				end;
			end;
		end;

		if button == "l"  and global.status == "peace" then
			local selected_portrait,trash = helpers.select_portrait();
			if selected_portrait > 0 then
				tmp_mob = selected_portrait;
				if chars_mobs_npcs[tmp_mob].status == 1 then
					current_mob = tmp_mob;
				end;
				if game_status == "chat" then --FIXME chats inside of party here
					
					local index = chars_mobs_npcs[victim]["personality"]["current"].chat;
					local def_array = {};
					for i=1, #chats.rules[index] do
						table.insert(def_array,chats.rules[index][i].default)
					end;
					chats.load (); --FIXME chats should use previous results
					for i=1, #def_array do
						chats.rules[index][i].default = def_array[i];
					end;
				end;
			end;
		end;

		if button == "l"
		and mX>=global.screenWidth-255 and mX<=global.screenWidth-170
		and mY >= global.screenHeight-160 and mY<=global.screenHeight-60
		and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "spellbook" or gamestatus == "warbook" or gamestatus == "questbook")
		and chars_mobs_npcs[current_mob].person == "char"
		and chars_mobs_npcs[current_mob].control == "player"
		and chars_stats[current_mob].spellbook == 1 then
			if game_status ~= "spellbook" then
				page = 1;
				spellbook_call();
			elseif game_status == "spellbook" then
				utils.playSfx(media.sounds.bookclose,1);
				game_status = "neutral" ;
			end;
		end;

		if button == "l"
		and mX>= global.screenWidth-330 and mX<=global.screenWidth-280
		and mY>=global.screenHeight-160 and mY<=global.screenHeight-80
		and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "spellbook" or gamestatus == "warbook" or gamestatus == "questbook")
		and chars_mobs_npcs[current_mob].person == "char"
		and chars_mobs_npcs[current_mob].control == "player" then
			if game_status ~= "questbook" then
				page = 1;
				questbook_call();
			elseif game_status == "questbook" then
				utils.playSfx(media.sounds.bookclose,1);
				game_status = "neutral" ;
			end;
		end;

		if button == "l"
		and mX>=global.screenWidth-280 and mX<=global.screenWidth-230
		and mY>=global.screenHeight-180 and mY<=global.screenHeight-160
		and (game_status == "neutral" or game_status == "sensing" or game_status == "pathfinding" or game_status == "spellbook" or gamestatus == "warbook" or gamestatus == "questbook")
		and chars_mobs_npcs[current_mob].person == "char"
		and chars_mobs_npcs[current_mob].control == "player" then
			if game_status ~= "warbook" then
				page = 1;
				warbook_call();
			elseif game_status == "warbook" then
				utils.playSfx(media.sounds.bookclose,1);
				game_status = "neutral" ;
			end;
		end;

		if  game_status == "neutral"
		or game_status == "sensing"
		or game_status == "pathfinding" then
			for i=1,#chars_mobs_npcs do
				if chars_mobs_npcs[current_mob].control == "player" and chars_mobs_npcs[i].x == cursor_world_x and chars_mobs_npcs[i].y == cursor_world_y then
					previctim = chars_mobs_npcs[i].id;
				else
				end;
			end;
		end;

		if button == "r" and (game_status == "neutral" or game_status == "sensing " or game_status == "pathfinding") --monsterid
		and chars_mobs_npcs[current_mob].person == "char" and chars_mobs_npcs[current_mob].control == "player"
		then
			--for i= chars+1,#chars_mobs_npcs do
			for i=1,#chars_mobs_npcs do
				if chars_mobs_npcs[i].x == cursor_world_x and chars_mobs_npcs[i].y == cursor_world_y then
					tmpc = i;
					show_monsterid_tip = 1;
				end;
			end;
		end;
	----//////

		if love.mouse.isDown("m") and game_status == "pathfinding" then
			global.wheeled=0;
		end;
		--close combat
		if love.mouse.isDown("l") and chars_mobs_npcs[current_mob].control=="player" and helpers.ifCursorIsNear () and helpers.cursorAtMob (cursor_world_x,cursor_world_y)
		and chars_mobs_npcs[previctim].status==1 and current_mob ~= previctim and (game_status == "sensing" or (game_status == "pathfinding" and #way_of_the_mob == 0 ))
		and not love.keyboard.isDown("lctrl") then
			helpers.turnMob(current_mob);
			if chars_mobs_npcs[current_mob].rot==1 then
				atk_direction=4;
			elseif chars_mobs_npcs[current_mob].rot==2 then
				atk_direction=5;
			elseif chars_mobs_npcs[current_mob].rot==3 then
				atk_direction=6;
			elseif chars_mobs_npcs[current_mob].rot==4 then
				atk_direction=1;
			elseif chars_mobs_npcs[current_mob].rot==5 then
				atk_direction=2;
			elseif chars_mobs_npcs[current_mob].rot==6 then
				atk_direction=3;
			end;
			if global.status == "battle" then
				game_status="attack";
				damage.meleeAttack (damage.meleeAttackTool (current_mob));
			elseif global.status == "peace" and chars_mobs_npcs[previctim].person ~= "char" then
				chat (previctim);
			end;
		end;

		if love.mouse.isDown("l") and chars_mobs_npcs[current_mob].control=="player" and helpers.ifCursorIsNear () and helpers.cursorAtMob (cursor_world_x,cursor_world_y)
		and chars_mobs_npcs[previctim].status==1 and current_mob ~= previctim and (game_status == "sensing" or (game_status == "pathfinding" and #way_of_the_mob == 0 ))
		and love.keyboard.isDown("lctrl") and chars_mobs_npcs[current_mob].num_thievery > 0 and global.status == "peace" then
			steal(previctim);
		end;

		if love.mouse.isDown("l") and chars_mobs_npcs[current_mob].control=="player" and helpers.ifCursorIsNear() and helpers.cursorAtMob (cursor_world_x,cursor_world_y) --FIXME neutral is not neutral
		and chars_mobs_npcs[previctim].status==1 and current_mob ~= previctim and game_status == "neutral" and global.status == "battle" then
			helpers.turnMob(current_mob);
			if chars_mobs_npcs[current_mob].rot==1 then
				atk_direction=4;
			elseif chars_mobs_npcs[current_mob].rot==2 then
				atk_direction=5;
			elseif chars_mobs_npcs[current_mob].rot==3 then
				atk_direction=6;
			elseif chars_mobs_npcs[current_mob].rot==4 then
				atk_direction=1;
			elseif chars_mobs_npcs[current_mob].rot==5 then
				atk_direction=2;
			elseif chars_mobs_npcs[current_mob].rot==6 then
				atk_direction=3;
			end;
			game_status="attack";
			damage.meleeAttack (damage.meleeAttackTool (current_mob));
		end;

		if button == "r" and (game_status == "inventory" or game_status == "alchemy") and holding_smth>0
		and mY>global.screenHeight-110 and mX>40 and mX<global.screenWidth-745
		then
			helpers.select_portrait();
			if selected_portrait>0 and selected_portrait==current_mob -- imbue an ally with a potion
			and inventory_ttx[list[holding_smth].ttxid].subclass == "drink"
			and chars_stats[current_mob].nature=="humanoid"
			then
				helpers.limitStats();
				utils.playSfx(media.sounds.chpok,1);
				missle_type="drinkpotion";
				if global.status ~= "mindgame" then
					game_status="sensing";
				else
					global.mindgame_attempts = global.mindgame_attempts - 1;
					damage.mindGameCast();
					game_status = "mindgame";
				end;
				drink_smth=holding_smth;
				bag[tmp_bagid][inv_quad_x][inv_quad_y]=holding_smth;
				holding_smth=0;
			end;
		end;

		if love.mouse.isDown("l")
		and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
		and game_status == "sensing"
		and missle_type=="drinkpotion" then
			local ally_is_near=0
			for h=1,6 do
				if chars_mobs_npcs[current_mob].y/2 == math.ceil(chars_mobs_npcs[current_mob].y/2) then
					if  chars_mobs_npcs[previctim].x== chars_mobs_npcs[current_mob].x+directions[1].xc[h] and
						chars_mobs_npcs[previctim].y== chars_mobs_npcs[current_mob].y+directions[1].y[h]
					then
						ally_is_near=1;
					end
				elseif chars_mobs_npcs[current_mob].y/2 ~= math.ceil(chars_mobs_npcs[current_mob].y/2) then
					if  chars_mobs_npcs[previctim].x== chars_mobs_npcs[current_mob].x+directions[1].xn[h] and chars_mobs_npcs[previctim].y== chars_mobs_npcs[current_mob].y+directions[1].y[h] then
						ally_is_near=1;
					end;
				end;
			end;
			if ally_is_near==1 then
				local tmp=inventory_ttx[list[drink_smth].ttxid].a;
				local q=list[drink_smth].q;
				if inventory_ttx[list[drink_smth].ttxid].b=="plus" then
					chars_mobs_npcs[previctim][tmp]= chars_mobs_npcs[previctim][tmp]+list[drink_smth].q;
				elseif inventory_ttx[list[drink_smth].ttxid].b=="minus" then
					chars_mobs_npcs[previctim][tmp]= chars_mobs_npcs[previctim][tmp]-list[drink_smth].q;
				elseif inventory_ttx[list[drink_smth].ttxid].b=="zero" then
					chars_mobs_npcs[previctim][tmp]=0;
				end;
				helpers.limitStats() utils.playSfx(media.sounds.drink,1);
				helpers.addToActionLog( chars_stats[previctim].name .. " " ..
				lognames.actions.drinked[chars_mobs_npcs[previctim].gender] .. " «"
				.. inventory_ttx[list[drink_smth].ttxid].title .. "» "
				.. lognames.actions.ofpower .. " " .. list[drink_smth].q);
				table.remove(list,drink_smth);
				for i=1,11 do
					for h=1,15 do
						if bag[tmp_bagid][h][i]>drink_smth and bag[tmp_bagid][h][i]>0 and
							bag[tmp_bagid][h][i]<10000 then bag[tmp_bagid][h][i]=bag[tmp_bagid][h][i]-1;
						end;
					end;
				end;
				helpers.renumber(drink_smth,current_mob);
				table.insert(list,{ttxid=raws.tare,q=1,w=0,e=0,r=0}) bag[tmp_bagid][inv_quad_x][inv_quad_y]=#list bag[tmp_bagid][inv_quad_x+1][inv_quad_y]=inv_quad_y*10000+inv_quad_x drink_smth=0;
				if global.status == "battle" then
					chars_mobs_npcs[current_mob].rt= chars_mobs_npcs[current_mob].rt-10;
					game_status="restoring";
				end;
			end;
		end;

		if button=="wu" then
			if game_status == "pathfinding" or (game_status == "sensing" and (missle_type=="spikes" or missle_type=="razors")) then
				if helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
					global.wheeled=1;
					if atk_direction>1 then
						atk_direction=atk_direction-1;
					else
						atk_direction=6;
					end;
				else
					modepf=-1*modepf;
				end;
			local ignoreMobs = 0;
			local mode = 0;
				if game_status == "sensing" and missle_type=="razors" then
					mode = 2;
					ignoreMobs = 0;
				elseif game_status == "sensing" and missle_type=="spikes" then
					mode = 2;
					ignoreMobs = 1;
				end;
				path_finding(mode,ignoreMobs);
			elseif game_status == "sensing"  and (missle_type=="firewall" or missle_type=="stonewall" or missle_type=="pitfall") then
				spell_rotation=spell_rotation+1;
				if spell_rotation>6 then spell_rotation=1
				end;
			end;
		end;

		if button=="wd" then
			if game_status == "pathfinding" or (game_status == "sensing" and (missle_type=="spikes" or missle_type=="razors")) then
				if helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
					global.wheeled=1;
					if atk_direction<6 then
						atk_direction=atk_direction+1;
					else
						atk_direction=1;
					end;
				else
					modepf=-1*modepf;
				end;
				local ignoreMobs = 0;
				local mode = 0;
				if game_status == "sensing" and missle_type=="razors" then
					mode = 2;
					ignoreMobs = 0;
				elseif game_status == "sensing" and missle_type=="spikes" then
					mode = 2;
					ignoreMobs = 1;
				end;
					path_finding(mode,ignoreMobs);
				elseif game_status == "sensing" and (missle_type=="firewall" or missle_type=="stonewall" or missle_type=="pitfall") then
					spell_rotation=spell_rotation-1
				if spell_rotation<1 then spell_rotation=6
				end;
			end;
		end;

		if (button=="wd" or button=="wu") and game_status == "sensing" and (missle_type=="chainlightning" or missle_type=="rockblast" or missle_type=="toxiccloud") then
			helpers.globalRandom();
		end;

		if love.mouse.isDown("l") and mY < global.screenHeight-160 and chars_mobs_npcs[current_mob].control=="player" and path_status==1 and game_status == "pathfinding" and aim_on_mob==0  then --GO!
			tmp= chars_mobs_npcs[current_mob].sprite .. "_walk"
			mob_walk=loadstring("return " .. tmp)()
			animation_walk = anim8.newAnimation(mob_walk[way_of_the_mob[#way_of_the_mob][6] ]("5-8",1), 0.075, "pauseAtEnd")
			if helpers.cursorAtMob (cursor_world_x,cursor_world_y) and chars_mobs_npcs[previctim].status==1 then
				going_to_hit=1
			elseif not helpers.cursorAtMob (cursor_world_x,cursor_world_y) or chars_mobs_npcs[previctim].status<1 then
				going_to_hit=0
			end;
		   if chars_mobs_npcs[current_mob].wingsoflight == 0 then
			   game_status="moving";
			   find_the_path=0;
			   global.timers.m_timer=0;
		   elseif going_to_hit == 0  then
				--some sound
				chars_mobs_npcs[current_mob].wingsoflight = 0;
				chars_mobs_npcs[current_mob].x = cursor_world_x;
				chars_mobs_npcs[current_mob].y = cursor_world_y;
				helpers.cam_to_mob (current_mob);
				helpers.addToActionLog( chars_stats[current_mob].name .. " " .. lognames.actions.teleported[chars_mobs_npcs[current_mob].gender]);
		   end;
		end;
--tricks

		if love.mouse.isDown("l") and mY < global.screenHeight-160
		and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
		and game_status == "sensing"
		and missle_drive == "muscles"
		and helpers.missleAtWarBook()
		and tricks.tricks_tips[missle_type].form == "pose" then
			damage.setProtectionMode();
		end;
		
		--[[if love.mouse.isDown("l") and mY < global.screenHeight-160
		and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
		and (game_status == "sensing" or game_status == "pathfinding")
		and missle_drive == "muscles"
		and helpers.missleAtWarBook()
		and tricks.tricks_tips[missle_type].form == "melee" then
		
		end;]]
		
		--[[
		if love.mouse.isDown("l") and mY < global.screenHeight-160
		and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
		and game_status == "sensing"
		and missle_drive == "muscles"
		and tricks.tricks_tips[missle_type].form == "melee" then
			damage.meleeAttack (damage.meleeAttackTool (current_mob));
		end;
		]]
		if love.mouse.isDown("l") and mY < global.screenHeight-160
		and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
		and game_status == "sensing"
		and missle_drive == "muscles"
		and helpers.missleAtWarBook()
		and tricks.tricks_tips[missle_type].form == "ranged" then
			boomx= chars_mobs_npcs[victim].x;
			boomy= chars_mobs_npcs[victim].y;
			if missle_type == "evilswarm" or missle_type == "bitingcloud" then
				helpers.beforeShoot();
				game_status="shot";
				damage.shoot();
			else
				helpers.beforeShoot();
				game_status="shot";
				damage.shoot();
			end;
		end;
--/tricks
--spells
		if missle_drive ~= "muscles" then
			if global.status ~= "mindgame" then
				if love.mouse.isDown("l") and mY < global.screenHeight-160 and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char") and game_status == "sensing" and missle_type=="powerheal" then
					helpers.beforeShoot();
					boomx=cursor_world_x;
					boomy=cursor_world_y;
					game_status="shot";
					damage.shoot();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160 and game_status == "sensing" and missle_type=="ritualofthevoid" then
					helpers.beforeShoot();
					boomx=cursor_world_x;
					boomy=cursor_world_y;
					game_status="shot";
					damage.shoot();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
				and game_status == "sensing"
				and helpers.aliveNature(previctim) and damage.mobIsAlive(chars_mobs_npcs[previctim]) and damage.mobCanBeDamaged(chars_mobs_npcs[previctim])
				and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2)<= chars_mobs_npcs[current_mob].sense --not too far!
				and (missle_drive == "spellbook" or missle_drive == "scroll" or missle_drive == "wand")
				and magic.spell_tips[missle_type].form == "ally" then
					point_to_go_x=cursor_world_x;
					point_to_go_y=cursor_world_y;
					helpers.turnMob(current_mob);
					if helpers.allyUnderCursor (cursor_world_x,cursor_world_y) then
						previctim = helpers.mobIDUnderCursor (point_to_go_x,point_to_go_y);
						helpers.beforeShoot();
						game_status="shot";
						damage.shoot();
					end;
				end;
				
				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
				and game_status == "sensing"
				and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2)<= chars_mobs_npcs[current_mob].sense --not too far!
				and (missle_drive == "spellbook" or missle_drive == "scroll" or missle_drive == "wand")
				and magic.spell_tips[missle_type].form == "area" then
					point_to_go_x=cursor_world_x;
					point_to_go_y=cursor_world_y;
					helpers.turnMob(current_mob);
					if helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
						previctim = helpers.mobIDUnderCursor (point_to_go_x,point_to_go_y);
						helpers.beforeShoot();
						game_status="shot";
						damage.shoot();
					end;
				end;
				
				if love.mouse.isDown("l") and mY < global.screenHeight-1600
				and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
				and game_status == "sensing"
				and chars_mobs_npcs[previctim].status==-1
				and not helpers.aliveAtHex(chars_mobs_npcs[previctim].x,chars_mobs_npcs[previctim].y)
				and helpers.aliveNature(previctim) and damage.mobIsAlive(chars_mobs_npcs[previctim]) and damage.mobCanBeDamaged(chars_mobs_npcs[previctim])
				and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2)<= chars_mobs_npcs[current_mob].rng --not too far!
				and missle_type=="resurrect" then
					point_to_go_x=cursor_world_x;
					point_to_go_y=cursor_world_y;
					helpers.turnMob(current_mob);
					if helpers.deadCharUnderCursor () then
						helpers.beforeShoot();
						previctim = helpers.mobIDUnderCursor (point_to_go_x,point_to_go_y);
						game_status="shot"
						damage.shoot();
					end;
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and game_status == "sensing"
				and helpers.cursorAtDeadMob (cursor_world_x,cursor_world_y)
				and not helpers.aliveAtHex(chars_mobs_npcs[previctim].x,chars_mobs_npcs[previctim].y)
				and helpers.aliveNature(previctim)
				and damage.mobCanBeDamaged(chars_mobs_npcs[previctim])
				and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2)<= chars_mobs_npcs[current_mob].rng --not too far!
				and not chars_mobs_npcs[previctim].summoned
				and missle_type=="raisedead" then
					point_to_go_x=cursor_world_x;
					point_to_go_y=cursor_world_y;
					helpers.turnMob(current_mob);
					if helpers.deadMobUnderCursor () then
						previctim = helpers.mobIDUnderCursor (point_to_go_x,point_to_go_y);
						helpers.beforeShoot();
						game_status = "shot";
						damage.shoot();
					end;
				end

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
				and game_status == "sensing"
				and damage.mobIsAlive(chars_mobs_npcs[previctim]) and damage.mobCanBeDamaged(chars_mobs_npcs[previctim])
				and chars_mobs_npcs[previctim].nature=="undead"
				and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2)<= chars_mobs_npcs[current_mob].rng --not too far!
				and missle_type=="restoreundead" then
					point_to_go_x=cursor_world_x;
					point_to_go_y=cursor_world_y;
					helpers.turnMob(current_mob);
					if helpers.mobPersonUnderCursor (cursor_world_x,cursor_world_y) == "char" or helpers.mobControlUnderCursor (cursor_world_x,cursor_world_y) == "player" then
						previctim = helpers.mobIDUnderCursor (cursor_world_x,cursor_world_y);
						helpers.beforeShoot();
						game_status="shot";
						damage.shoot();
					end;
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160 and game_status == "sensing"
				and helpers.cursorAtEnemy (cursor_world_x,cursor_world_y)
				and (chars_mobs_npcs[previctim].control == "ai"or helpers.mobIDUnderCursor (cursor_world_x,cursor_world_y) > chars)
				and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2)<= chars_mobs_npcs[current_mob].rng --not too far!
				and (missle_drive == "spellbook" or missle_drive == "scroll" or missle_drive == "wand")
				and (magic.spell_tips[missle_type].form == "direct" or magic.spell_tips[missle_type].form == "enemy" or magic.spell_tips[missle_type].form == "skyray") then
					boomy=cursor_world_y;
					boomx=cursor_world_x;
					helpers.beforeShoot();
					game_status="shot";
					damage.shoot();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and helpers.cursorAtMob (cursor_world_x,cursor_world_y)
				and (chars_mobs_npcs[previctim].control=="ai" or person_under_cursor=="mob")
				and game_status == "sensing"
				and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2)<= chars_mobs_npcs[current_mob].rng --not too far!
				and (missle_type=="spikes" or missle_type=="razors")
				then
					boomx= chars_mobs_npcs[current_mob].x;
					boomy= chars_mobs_npcs[current_mob].y;
					helpers.beforeShoot();
					game_status="shot";
					damage.shoot();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and helpers.cursorAtMob (cursor_world_x,cursor_world_y)
				and game_status == "sensing"
				and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2)<= chars_mobs_npcs[current_mob].rng --not too far!
				and chars_mobs_npcs[previctim].nature == "undead"
				and missle_type=="controlundead" then
					victim=previctim;
					boomy= chars_mobs_npcs[previctim].y;
					boomx= chars_mobs_npcs[previctim].x;
					helpers.beforeShoot();
					game_status="shot";
					damage.shoot();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and missle_type ~= "bottle" and missle_drive ~= "muscles"
				and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
				and game_status == "sensing"
				and chars_mobs_npcs[previctim].status==1
				and chars_mobs_npcs[previctim].freeze==0
				and chars_mobs_npcs[previctim].stone==0
				and helpers.cursorAtMob (cursor_world_x,cursor_world_y)
				and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2)<= chars_mobs_npcs[current_mob].rng --not too far!
				and (magic.spell_tips[missle_type].form=="ring" or magic.spell_tips[missle_type].form=="proactive")
				then
					point_to_go_x=cursor_world_x;
					point_to_go_y=cursor_world_y;
					boomx = cursor_world_x;
					boomy = cursor_world_y;
					helpers.turnMob(current_mob);
					previctim = helpers.mobIDUnderCursor (cursor_world_x,cursor_world_y);
					helpers.beforeShoot();
					game_status="shot";
					damage.shoot();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and chars_mobs_npcs[current_mob].control=="player"	and helpers.cursorAtEnemy (cursor_world_x,cursor_world_y,y)
				and game_status == "sensing"
				and missle_type=="chainlightning"
				and #mobsmarked>1 then
					boomx=cursor_world_x;
					boomy=cursor_world_y;
					game_status="shot";
					helpers.beforeShoot();
					damage.shoot();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and chars_mobs_npcs[current_mob].control == "player" and helpers.cursorAtMob (cursor_world_x,cursor_world_y)
				and game_status == "sensing" and missle_type=="genocide" then
					boomx=cursor_world_x;
					boomy=cursor_world_y;
					game_status="shot";
					helpers.beforeShoot();
					damage.shoot();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and chars_mobs_npcs[current_mob].control == "player"
				and game_status == "sensing" and missle_type=="armageddon" then
					boomx=cursor_world_x;
					boomy=cursor_world_y;
					meteor_y=500
					stone_y=0
					game_status="shot";
					helpers.beforeShoot();
					damage.shoot();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and chars_mobs_npcs[current_mob].control == "player" and helpers.cursorAtMob (cursor_world_x,cursor_world_y)
				and game_status == "sensing" and missle_type=="roots" then
					boomx=cursor_world_x;
					boomy=cursor_world_y;
					game_status="shot";
					helpers.beforeShoot();
					damage.instantCast();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and missle_type ~= "arrow" and not helpers.missleIsAweapon ()
				and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
				and magic.spell_tips[missle_type] and game_status == "sensing" and (magic.spell_tips[missle_type].form == "sight" or magic.spell_tips[missle_type].form == "vray" or magic.spell_tips[missle_type].form == "ray" or magic.spell_tips[missle_type].form == "breath") then
					helpers.beforeShoot();
					game_status="shot";
					damage.shoot();
				end;

				if love.mouse.isDown("l") and mY < global.screenHeight-160
				and not helpers.missleIsAweapon ()
				and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
				and game_status == "sensing" and magic.spell_tips[missle_type].form == "rico" and #rockline>1 then
					helpers.beforeShoot();
					game_status="shot";
					rock_step=1;
					missle_x=rockline[1].x;
					missle_y=rockline[1].y;
					misx,misy = helpers.rockCoords (rockline[1].x,rockline[1].y);
					damage.shoot();
				end;

				if love.mouse.isDown("l") and game_status == "sensing" and missle_type=="wizardeye" and mY < global.screenHeight-160 then
					boomx = cursor_world_x;
					boomy = cursor_world_y;
					helpers.beforeShoot();
					damage.instantCast();
				end;
				
				if love.mouse.isDown("l") and game_status == "sensing" and missle_type=="telekinesis" and mY < global.screenHeight-160 then
					boomx = cursor_world_x;
					boomy = cursor_world_y;
					helpers.beforeShoot();
					damage.instantCast();
				end;
				
				
				if love.mouse.isDown("l")
				and (chars_mobs_npcs[current_mob].control=="player"	or person_under_cursor=="char")
				and game_status == "sensing"
				and not helpers.missleIsAweapon ()
				and (missle_drive == "spellbook" or missle_drive == "scroll" or missle_drive == "wand")
				and (magic.spell_tips[missle_type].form == "rain" or magic.spell_tips[missle_type].form == "skyrock") then
					helpers.beforeShoot();
					boomx=cursor_world_x;
					boomy=cursor_world_y;
					meteor_y=500;
					game_status="shot";
					damage.shoot();
				end;
			elseif global.status == "mindgame" then

			end;
		end;
--//spells

--dragging from
	if love.mouse.isDown("l") and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking") and holding_smth==0 and oil_smth==0 and drink_smth == 0 and bomb_smth == 0 and use_smth == 0 and scroll_smth == 0 then
		for i=1,#global.slots do
			local present = nil;

			if i <= 18 and game_status == "inventory" then
				slotset="equipment";
				present = chars_mobs_npcs[current_mob]["equipment"][global.slots[i]];
			elseif i > 18 and i <= 36 and game_status == "alchemy" then
				slotset="alchlab";
				present = alchlab[current_mob][global.slots[i]];
			elseif i > 36 and i <= 40 and game_status == "picklocking" then

				present = picklock[current_mob][global.slots[i]];
			end;
			if present and present > 0 and helpers.inSlot(global.slots[i]) then
				slot = global.slots[i];
				sorttarget = "char";
				oldsorttarget = "char";
				dragfrom = "char";
				holding_smth = present;
				if i <= 18 and game_status == "inventory" then
					chars_mobs_npcs[current_mob]["equipment"][slot] = 0;
				elseif i > 18 and i <= 36 and game_status == "alchemy" then
					alchlab[current_mob][slot] = 0;
				elseif i > 36 and i <= 40 and game_status == "picklocking" then
					picklock[current_mob][slot] = 0;
				end;
				helpers.recalcBattleStats (current_mob);
				break;
			end;
		end;

		if holding_smth>0 then
			holding_class=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].ttxid].class;
			holding_subclass=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].ttxid].subclass;
			sfx.soundsOfInv("take",dragfrom);
		end;
	end;
--//dragging from
	if love.mouse.isDown("l") --non free cells resetting bug fix
	and (game_status == "inventory" or game_status == "alchemy")
	and mX>inv_add_x
	and mX<inv_add_x+11*32
	and mY>inv_add_y
	and mY<inv_add_y+15*32
	then
		sorttarget="char";
		oldsorttarget="char";
		find_nonfree_space_at_inv ();
	end;

	if love.mouse.isDown("r") --repairing and id at inventory
	and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting" or game_status == "show_inventory")
	and mX>inv_add_x
	and mX<inv_add_x+11*32
	and mY>inv_add_y
	and mY<inv_add_y+15*32
	and holding_smth==0
	and oil_smth==0
	and drink_smth==0
	and bomb_smth==0
	and use_smth==0
	and scroll_smth==0 then
		local inv_quad_y=math.ceil((mX-inv_add_x)/32);
		local inv_quad_x=math.ceil((mY-inv_add_y)/32);
		helpers.idAndRepair("char");
	end;

	if love.mouse.isDown("r") --repairing and id at bag
	and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting" or game_status == "show_inventory")
	and (helpers.BagNear(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y)	and not bags_list[bagid].locked)
	and mX>inv_add_x+inv_part2
	and mX<inv_add_x+11*32+inv_part2
	and mY>inv_add_y
	and mY<inv_add_y+15*32
	and holding_smth==0
	and oil_smth==0
	and drink_smth==0
	and bomb_smth==0
	and use_smth==0
	and scroll_smth==0 then
		local inv_quad_y=math.ceil((mX-inv_add_x-inv_part2)/32);
		local inv_quad_x=math.ceil((mY-inv_add_y)/32);
		helpers.idAndRepair("bag");
	end;

	if love.mouse.isDown("l") -- splitting ammo
	and love.keyboard.isDown("lctrl","rctrl")
	and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting")
	and mX > inv_add_x and mX < inv_add_x+11*32 and mY > inv_add_y and mY < inv_add_y+15*32
	and holding_smth == 0 and oil_smth == 0 and drink_smth == 0 and bomb_smth == 0 and use_smth==0 and scroll_smth == 0 then
		local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
		inv_quad_y = math.ceil((mX-inv_add_x)/32);
		inv_quad_x = math.ceil((mY-inv_add_y)/32);
		local tmp12 = bag[tmp_bagid][inv_quad_x][inv_quad_y];
		if tmp12>0 and tmp12<10000 then
			if inventory_ttx[list[tmp12].ttxid].class == "ammo" and list[tmp12].q > 1 then
				local quantity1 = math.ceil(list[tmp12].q/2);
				local quantity2 = list[tmp12].q - quantity1;
				list[tmp12].q = quantity1;
				table.insert(list,{ttxid=list[tmp12].ttxid,q=quantity2,w=list[tmp12].w,e=list[tmp12].e,r=list[tmp12].r,h=list[tmp12].h});
				holding_smth = #list;
			elseif tmp12>10000 then
				tmp_s = tostring(tmp12);
				if (tmp12-10000) < 10 then
					tmpxi = tonumber(string.sub(tmp_s, 5,6));
				else
					tmpxi = tonumber(string.sub(tmp_s, 4,6));
				end;
				tmpyi = math.floor((tmp12-tmpxi)/10000);
				tmp12 = bag[tmp_bagid][tmpxi][tmpyi];
				local quantity1 = math.ceil(list[tmp12].q/2);
				local quantity2 = list[tmp12].q - quantity1;
				list[tmp12].q = quantity1;
				table.insert(list,{ttxid=list[tmp12].ttxid,q=quantity2,w=list[tmp12].w,e=list[tmp12].e,r=list[tmp12].r,h=list[tmp12].h});
				holding_smth = #list;
				inv_quad_x = tmpxi;
				inv_quad_y = tmpyi;
			end;
		end;
		if holding_smth > 0 then
			holding_class = inventory_ttx[list[holding_smth].ttxid].class;
			holding_subclass = inventory_ttx[list[holding_smth].ttxid].subclass;
			sfx.soundsOfInv("take","char");
		end;
	end;

	if love.mouse.isDown("l") -- splitting ammo
	and love.keyboard.isDown("lctrl","rctrl")
	and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting")
	and mX > inv_add_x+inv_part2 and mX < inv_add_x+11*32+inv_part2 and mY > inv_add_y and mY < inv_add_y+15*32
	and holding_smth == 0 and oil_smth == 0 and drink_smth == 0 and bomb_smth == 0 and use_smth==0 and scroll_smth == 0 then
		local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
		inv_quad_y=math.ceil((mX-inv_part2-inv_add_x)/32);
		inv_quad_x=math.ceil((mY-inv_add_y)/32);
		local tmp12 = bag[tmp_bagid][inv_quad_x][inv_quad_y];
		if tmp12>0 and tmp12<10000 then
			if inventory_ttx[list[tmp12].ttxid].class == "ammo" and list[tmp12].q > 1 then
				local quantity1 = math.ceil(list[tmp12].q/2);
				local quantity2 = list[tmp12].q - quantity1;
				list[tmp12].q = quantity1;
				table.insert(list,{ttxid=list[tmp12].ttxid,q=quantity2,w=list[tmp12].w,e=list[tmp12].e,r=list[tmp12].r,h=list[tmp12].h});
				holding_smth = #list;
			elseif tmp12>10000 then
				tmp_s = tostring(tmp12);
				if (tmp12-10000) < 10 then
					tmpxi = tonumber(string.sub(tmp_s, 5,6));
				else
					tmpxi = tonumber(string.sub(tmp_s, 4,6));
				end;
				tmpyi = math.floor((tmp12-tmpxi)/10000);
				tmp12 = bag[tmp_bagid][tmpxi][tmpyi];
				local quantity1 = math.ceil(list[tmp12].q/2);
				local quantity2 = list[tmp12].q - quantity1;
				list[tmp12].q = quantity1;
				table.insert(list,{ttxid=list[tmp12].ttxid,q=quantity2,w=list[tmp12].w,e=list[tmp12].e,r=list[tmp12].r,h=list[tmp12].h});
				holding_smth = #list;
				inv_quad_x = tmpxi;
				inv_quad_y = tmpyi;
			end;
		end;
		if holding_smth > 0 then
			holding_class = inventory_ttx[list[holding_smth].ttxid].class;
			holding_subclass = inventory_ttx[list[holding_smth].ttxid].subclass;
			sfx.soundsOfInv("take","bag");
		end;
	end;
 --
 	if love.mouse.isDown("l")
	and game_status == "showinventory"
	and mX > global.screenWidth/2 - 100
	and mX < global.screenWidth/2 + 100
	and mY >= 350
	and mY <= 400 then
		global.showinventory_flag = "sell";
	end;

	if love.mouse.isDown("l")
	and game_status == "showinventory"
	and mX > global.screenWidth/2 - 100
	and mX < global.screenWidth/2 + 100
	and mY >= 450
	and mY <= 500 then
		global.showinventory_flag = "id";
	end;

	if love.mouse.isDown("l")
	and game_status == "showinventory"
	and mX > global.screenWidth/2 - 100
	and mX < global.screenWidth/2 + 100
	and mY >= 550
	and mY <= 600 then
		global.showinventory_flag = "repair";
	end;

	if love.mouse.isDown("l") --selling from inventory
	and game_status == "showinventory"
	and mX>inv_add_x
	and mX<inv_add_x+11*32
	and mY>inv_add_y
	and mY<inv_add_y+15*32 then
		sorttarget="char"
		oldsorttarget="char"
		dragfrom="char"
		local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false,bagid);
		inv_quad_y=math.ceil((mX-inv_add_x)/32);
		inv_quad_x=math.ceil((mY-inv_add_y)/32);
		tmp12=bag[tmp_bagid][inv_quad_x][inv_quad_y];
		sell_smth=0;
		id_smth=0;
		repair_smth=0;
		print(global.showinventory_flag);
		if tmp12>0 and tmp12<10000 then
			if global.showinventory_flag == "sell" then
				sell_smth=tmp12;
			elseif global.showinventory_flag == "id" then
				id_smth=tmp12;
			elseif global.showinventory_flag == "repair" then
				repair_smth=tmp12;
			end;
		elseif tmp12>10000 then
			tmp_s=tostring(tmp12);
			if (tmp12-10000)<10 then
				tmpxi=tonumber(string.sub(tmp_s, 5,6));
			else
				tmpxi=tonumber(string.sub(tmp_s, 4,6));
			end
			tmpyi=math.floor((tmp12-tmpxi)/10000)
			if global.showinventory_flag == "sell" then
				sell_smth = bag[tmp_bagid][tmpxi][tmpyi];
			elseif global.showinventory_flag == "id" then
				id_smth = bag[tmp_bagid][tmpxi][tmpyi];
			elseif global.showinventory_flag == "repair" then
				repair_smth = bag[tmp_bagid][tmpxi][tmpyi];
			end;

			inv_quad_x=tmpxi;
			inv_quad_y=tmpyi;
		end;
		if sell_smth > 0 then
			local class = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][sell_smth].ttxid].class;
			tmpinv=sell_smth;
			helpers.inv_tips_add();
			if global.price > 0 and helpers.tradersBuysThisItem(victim,class) then
				bag[tmp_bagid][inv_quad_x][inv_quad_y]=0;
				helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.sold[chars_mobs_npcs[current_mob].gender] .. inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][sell_smth].ttxid].title .. lognames.actions.for_ .. global.price .. lognames.actions.withgold);
				table.remove(chars_mobs_npcs[current_mob]["inventory_list"],sell_smth);
				helpers.renumber(sell_smth,current_mob);
				sorttarget = "char";
				helpers.repackBag();
				find_nonfree_space_at_inv();
				sell_smth = 0;
				utils.playSfx(media.sounds.gold_dzen,1);
				party.gold=party.gold+global.price;
			else
				helpers.addToActionLog(helpers.mobName(victim) .. ": " .. lognames.traders.notinterested);
				utils.playSfx(media.sounds.error,1);
			end;
		end;
		if id_smth > 0 then
			local class = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][id_smth].ttxid].class;
			tmpinv=id_smth;
			helpers.inv_tips_add();
			local class = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][id_smth].ttxid].class;
			tmpinv=id_smth;
			helpers.inv_tips_add();
			local price = math.ceil(100*traders[chars_mobs_npcs[npc].shop].prices[1]);
			if helpers.tradersIdentifiesThisItem(victim,class) then
				if helpers.payGold(price) then
					--utils.playSfx(media.sounds.id,1);
					chars_mobs_npcs[current_mob]["inventory_list"][id_smth].r = 1;
				end;
			else
				helpers.addToActionLog(helpers.mobName(victim) .. ": " .. lognames.traders.notmyspec);
				utils.playSfx(media.sounds.error,1);
			end;
		end;
		if repair_smth > 0 then
			local class = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][repair_smth].ttxid].class;
			tmpinv=repair_smth;
			helpers.inv_tips_add();
			local class = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][repair_smth].ttxid].class;
			global.preprice = math.ceil(global.preprice*0.25);
			global.price = math.ceil(global.price*0.25);
			tmpinv=repair_smth;
			helpers.inv_tips_add();
			if helpers.tradersRepairsThisItem(victim,class) then
				if helpers.payGold(global.price) then
					utils.playSfx(media.sounds.repair,1);
					chars_mobs_npcs[current_mob]["inventory_list"][repair_smth].q = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][repair_smth].ttxid].material; --fixme may be skill of repairng?
				end;
			else
				helpers.addToActionLog(helpers.mobName(victim) .. ": " .. lognames.traders.notmyspec);
				utils.playSfx(media.sounds.error,1);
			end;
		end;
	end;

	if love.mouse.isDown("l") --selling from bag
	and game_status == "showinventory"
	and global.showinventory_flag == "sell"
	and (helpers.BagNear(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y) and not bags_list[bagid].locked)
	and mX>inv_add_x+inv_part2
	and mX<inv_add_x+11*32+inv_part2
	and mY>inv_add_y
	and mY<inv_add_y+15*32 then
		sorttarget="bag";
		oldsorttarget="bag";
		dragfrom="bag";
		--bagid=0;
		local bag_found = false;
		--[[for j=1, #bags_list do
			if chars_mobs_npcs[current_mob].x==bags_list[j].x and chars_mobs_npcs[current_mob].y==bags_list[j].y and not bag_found then
				bagid=j;
				bag_found = true;
			end;
		end]]
		bagid = helpers.whatBag(current_mob)
		if not bagid then
			bagid = helpers.trapInFrontOf(current_mob)
		end;
		if bagid then
			bag_found = true;
		end;
		local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false);
		if tmp_bagid>0 then
			inv_quad_y=math.ceil((mX-inv_part2-inv_add_x)/32);
			inv_quad_x=math.ceil((mY-inv_add_y)/32);
			tmp12=bag[tmp_bagid][inv_quad_x][inv_quad_y];
			if tmp12>0 and tmp12<10000 then
				sell_smth=tmp12;
			elseif tmp12>10000 then
				tmp_s=tostring(tmp12);
				if (tmp12-10000)<10 then
					tmpxi=tonumber(string.sub(tmp_s, 5,6));
				else
					tmpxi=tonumber(string.sub(tmp_s, 4,6));
				end
				tmpyi=math.floor((tmp12-tmpxi)/10000)
				sell_smth=bag[tmp_bagid][tmpxi][tmpyi];
				inv_quad_x=tmpxi;
				inv_quad_y=tmpyi;
			end;
			if sell_smth > 0 then
				local class = inventory_ttx[list[sell_smth].ttxid].class;
				tmpinv=sell_smth;
				helpers.inv_tips_add();
				if global.price > 0 and helpers.tradersBuysThisItem(victim,class) then
					bag[tmp_bagid][inv_quad_x][inv_quad_y]=0;
					helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.sold[chars_mobs_npcs[current_mob].gender] .. inventory_ttx[list[sell_smth].ttxid].title .. lognames.actions.for_ .. global.price .. lognames.actions.withgold);
					table.remove(bags_list[bagid],sell_smth);
					helpers.repackBag();
					find_nonfree_space_at_inv();
					sell_smth = 0;
					utils.playSfx(media.sounds.gold_dzen,1);
					party.gold=party.gold+global.price;
					if #bags_list[bagid] == 0 then
						table.remove(bags_list,bagid)
						table.remove(bags,bagid);
						bagremoved=1;
					end;
				else
					helpers.addToActionLog(helpers.mobName(victim) .. ": " .. lognames.traders.notinterested);
					utils.playSfx(media.sounds.error,1);
				end;
			end;
			if id_smth > 0 then
				local class = inventory_ttx[bags_list[bagid][id_smth].ttxid].class;
				tmpinv=id_smth;
				helpers.inv_tips_add();
				local class = inventory_ttx[bags_list[bagid][id_smth].ttxid].class;
				tmpinv=id_smth;
				helpers.inv_tips_add();
				local price = math.ceil(100*traders[chars_mobs_npcs[npc].shop].prices[1]);
				if helpers.helpers.tradersIdentifiesThisItem(victim,class) then
					if helpers.payGold(price) then
						--utils.playSfx(media.sounds.id,1);
						bags_list[bagid][id_smth].r = 1;
					end;
				else
					helpers.addToActionLog(helpers.mobName(victim) .. ": " .. lognames.traders.notmyspec);
					utils.playSfx(media.sounds.error,1);
				end;
			end;
			if repair_smth > 0 then
				local class = inventory_ttx[bags_list[bagid][repair_smth].ttxid].class;
				tmpinv=repair_smth;
				helpers.inv_tips_add();
				local class = inventory_ttx[bags_list[bagid][repair_smth].ttxid].class;
				global.preprice = math.ceil(global.preprice*0.25);
				global.price = math.ceil(global.price*0.25);
				tmpinv=repair_smth;
				helpers.inv_tips_add();
				if helpers.tradersRepairsThisItem(victim,class) then
					if helpers.payGold(global.price) then
						utils.playSfx(media.sounds.repair,1);
						bags_list[bagid][repair_smth].q = inventory_ttx[bags_list[bagid][repair_smth].ttxid].material; --fixme may be skill of repairng?
					end;
				else
					helpers.addToActionLog(helpers.mobName(victim) .. ": " .. lognames.traders.notmyspec);
					utils.playSfx(media.sounds.error,1);
				end;
			end;
		end;
	end;

	if love.mouse.isDown("l") --start dragging from inventory
	and not love.keyboard.isDown("lctrl","rctrl")
	and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting")
	and mX>inv_add_x
	and mX<inv_add_x+11*32
	and mY>inv_add_y
	and mY<inv_add_y+15*32
	and holding_smth==0
	and oil_smth==0
	and drink_smth==0
	and bomb_smth==0
	and use_smth==0
	and scroll_smth==0 then
		sorttarget="char";
		oldsorttarget="char";
		dragfrom="char";

		local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false);
		inv_quad_y=math.ceil((mX-inv_add_x)/32);
		inv_quad_x=math.ceil((mY-inv_add_y)/32);
		tmp12=bag[tmp_bagid][inv_quad_x][inv_quad_y];
		if tmp12>0 and tmp12<10000 then
			holding_smth=tmp12;
			bag[tmp_bagid][inv_quad_x][inv_quad_y]=0;
		elseif tmp12>10000 then
			tmp_s=tostring(tmp12);
			if (tmp12-10000)<10 then
				tmpxi=tonumber(string.sub(tmp_s, 5,6));
			else
				tmpxi=tonumber(string.sub(tmp_s, 4,6));
			end;
			tmpyi=math.floor((tmp12-tmpxi)/10000);
			holding_smth=bag[tmp_bagid][tmpxi][tmpyi];
			inv_quad_x=tmpxi;
			inv_quad_y=tmpyi;
			bag[tmp_bagid][inv_quad_x][inv_quad_y]=0;
			find_nonfree_space_at_inv();
		end;
		if tmp12>0 then
			for i=1,11 do
				for h=1,15 do
					if bag[tmp_bagid][h][i]>10000 then
						bag[tmp_bagid][h][i]=0;
					end
					find_nonfree_space_at_inv ();
				end;
			end;
		end;
		if holding_smth>0 then
			holding_class=inventory_ttx[list[holding_smth].ttxid].class;
			holding_subclass=inventory_ttx[list[holding_smth].ttxid].subclass;
			sfx.soundsOfInv("take",dragfrom);
		end;
	end;

	if love.mouse.isDown("l") --start dragging from bag
	and (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting")
	and (helpers.BagNear(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y)
	and mX>inv_add_x+inv_part2
	and mX<inv_add_x+11*32+inv_part2
	and mY>inv_add_y
	and mY<inv_add_y+15*32
	and not bags_list[bagid].locked)
	and holding_smth==0
	and oil_smth==0
	and drink_smth == 0
	and bomb_smth == 0
	and use_smth==0
	and scroll_smth == 0 then
		sorttarget="bag";
		oldsorttarget="bag";
		dragfrom="bag";
		--bagid=0;
		local bag_found = false;
		--[[for j=1, #bags_list do
			if chars_mobs_npcs[current_mob].x==bags_list[j].x and chars_mobs_npcs[current_mob].y==bags_list[j].y and not bag_found then
				bagid=j;
				bag_found = true;
			end;
		end;]]
		bagid = helpers.whatBag(current_mob)
		if not bagid then
			bagid = helpers.trapInFrontOf(current_mob)
		end;
		if bagid then
			bag_found = true;
		end;

		local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false);
		if tmp_bagid>0 then
			inv_quad_y=math.ceil((mX-inv_part2-inv_add_x)/32);
			inv_quad_x=math.ceil((mY-inv_add_y)/32);
			tmp12=bag[tmp_bagid][inv_quad_x][inv_quad_y];
			if tmp12>0 and tmp12<10000 then
				holding_smth=tmp12;
				bag[tmp_bagid][inv_quad_x][inv_quad_y]=0;
			elseif tmp12>0 and tmp12>10000 then
				tmp_s=tostring(tmp12);
				if (tmp12-10000)<10 then
					tmpxi=tonumber(string.sub(tmp_s, 5,6));
				else
					tmpxi=tonumber(string.sub(tmp_s, 4,6));
				end;
				tmpyi=math.floor((tmp12-tmpxi)/10000);
				holding_smth=bag[tmp_bagid][tmpxi][tmpyi];
				inv_quad_x=tmpxi;
				inv_quad_y=tmpyi;
				bag[tmp_bagid][inv_quad_x][inv_quad_y]=0;
			end;
			if tmp12>0 then
				if inventory_ttx[list[holding_smth].ttxid].class == "gold" then
					utils.playSfx(media.sounds.gold_dzen,1);
					party.gold=party.gold+list[holding_smth].q;
					table.remove(bags_list[bagid],holding_smth);
					for i=1,11 do
						for h=1,15 do
							if bags[bagid][h][i]>holding_smth and bags[bagid][h][i]>0 and bags[bagid][h][i]<10000 then
								bags[bagid][h][i]=bags[bagid][h][i]-1;
							end;
						end;
					end;
					holding_smth=0;
				end;
				if #bags_list[bagid]==0 and #bags_list[bagid].typ=="bag" then
					table.remove(bags_list,bagid)
					table.remove(bags,bagid);
					bagremoved=1;
				end;
			end;
		end;
		if holding_smth>0 then
			holding_class=inventory_ttx[list[holding_smth].ttxid].class;
			holding_subclass=inventory_ttx[list[holding_smth].ttxid].subclass;
			sfx.soundsOfInv("take",dragfrom);
		end;
	end;

	if love.mouse.isDown("l")
	and chars_mobs_npcs[current_mob].control=="player"
	and game_status == "sensing"
	and helpers.cursorAtMob (cursor_world_x,cursor_world_y)
	and trace.arrowStatus(current_mob)
	and chars_mobs_npcs[previctim].status==1
	and chars_mobs_npcs[previctim].freeze==0
	and chars_mobs_npcs[previctim].stone==0
	and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2)<= chars_mobs_npcs[current_mob].rng --not too far!
	then
		point_to_go_x=cursor_world_x
		point_to_go_y=cursor_world_y
		helpers.turnMob(current_mob);
		previctim = helpers.mobIDUnderCursor (cursor_world_x,cursor_world_y);
		if (missle_type=="bolt"
		or missle_type=="arrow"
		or missle_type=="bullet"
		or missle_type == "battery"
		or missle_type == "throwing"
			or (missle_drive == "muscles" and  helpers.missleAtWarBook() and tricks.tricks_tips[missle_type].form == "range" and (tricks.tricks_tips[missle_type].skill == "bow" or tricks.tricks_tips[missle_type].skill == "crossbow"))
			or (missle_drive == "muscles" and  helpers.missleAtWarBook() and tricks.tricks_tips[missle_type].form == "range" and tricks.tricks_tips[missle_type].skill == "throwing")
		) and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2) <= chars_mobs_npcs[current_mob].rng --not too far!
		and chars_mobs_npcs[current_mob]["equipment"].ranged ~=0 and chars_mobs_npcs[current_mob]["equipment"].ammo ~=0
		and chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].q > 0 then
			game_status="shot";
			damage.shoot();
		elseif missle_type=="throwing"
		and math.sqrt((chars_mobs_npcs[current_mob].x-chars_mobs_npcs[previctim].x)^2+(chars_mobs_npcs[current_mob].y-chars_mobs_npcs[previctim].y)^2) <= (math.ceil(chars_mobs_npcs[current_mob].mgt/2.5) + 5) --not too far!
		and chars_mobs_npcs[current_mob]["equipment"].ranged ==0 and chars_mobs_npcs[current_mob]["equipment"].ammo ~= 0
		and chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].q > 0 then
			game_status="shot";
			boomx = cursor_world_x;
			boomy = cursor_world_y;
			damage.shoot();
		elseif (missle_drive == "spellbook" or missle_drive == "scroll" or missle_drive == "wand") and (magic.spell_tips[missle_type].form == "arrow" or magic.spell_tips[missle_type].form == "ball" or magic.spell_tips[missle_type].form == "skyray") then
			helpers.beforeShoot();
			game_status="shot";
			damage.shoot();
		end;
	end;

	if love.mouse.isDown("l") -- potion of curing sleep, charm, berserk, enslave, paralyze, stone, stun, freeze; resurrection, restoration; douse as bomb now BOMB
	and chars_mobs_npcs[current_mob].control=="player"
	and game_status == "sensing"
	and trace.arrowStatus(current_mob)
	and missle_type=="bottle"
	and bomb_smth > 0
	and helpers.mobIDUnderCursor (cursor_world_x,cursor_world_y)
	and  helpers.ifCursorIsNear()
	then
		game_status="shot";
		missle_drive = "alchemy";
		table.remove(list,bomb_smth);
		helpers.renumber(bomb_smth,current_mob);
		bomb_smth = 0;
		damage.shoot();
	end;

	if love.mouse.isDown("l") --bombs
	and chars_mobs_npcs[current_mob].control=="player"
	and game_status == "sensing"
	and  missle_type=="bottle"
	and bomb_smth > 0
	then
		game_status="shot";
		missle_drive = "alchemy";
		table.remove(list,bomb_smth);
		helpers.renumber(bomb_smth,current_mob);
		use_smth = 0;
		damage.shoot();
	end;

	if love.mouse.isDown("l")
	and chars_mobs_npcs[current_mob].control=="player"
	and game_status == "sensing"
	and math.sqrt((chars_mobs_npcs[current_mob].x-cursor_world_x)^2+(chars_mobs_npcs[current_mob].y-cursor_world_y)^2)<=5+chars_mobs_npcs[current_mob].lvl_air --not too far!
	and missle_type=="jump"
	then
		boomx= chars_mobs_npcs[current_mob].x;
		boomy= chars_mobs_npcs[current_mob].y;
		point_to_go_x=cursor_world_x;
		point_to_go_y=cursor_world_y;
		helpers.beforeShoot();
		game_status="shot";
		damage.shoot();
	end;

	if love.mouse.isDown("l")
	and chars_mobs_npcs[current_mob].control=="player"
	and game_status == "sensing"
	and not helpers.cursorAtMob (cursor_world_x,cursor_world_y)
	and math.sqrt((chars_mobs_npcs[current_mob].x-cursor_world_x)^2+(chars_mobs_npcs[current_mob].y-cursor_world_y)^2)<= chars_mobs_npcs[current_mob].rng --not too far!
	and (missle_drive == "spellbook" or missle_drive == "scroll" or missle_drive == "wand")
	and  (magic.spell_tips[missle_type].form == "wall" or magic.spell_tips[missle_type].form == "summon")
	and heights_table[map[cursor_world_y][cursor_world_x] ]==0
	then
		helpers.beforeShoot();
		helpers.turnMob(current_mob);
		game_status="shot";
		boomx = cursor_world_x;
		boomy = cursor_world_y;
		damage.shoot();
	end;

	if love.mouse.isDown("l")
	and chars_mobs_npcs[current_mob].control=="player"
	and game_status == "sensing"
	and math.sqrt((chars_mobs_npcs[current_mob].x-cursor_world_x)^2+(chars_mobs_npcs[current_mob].y-cursor_world_y)^2)<= chars_mobs_npcs[current_mob].rng --not too far!
	and (missle_type=="twister")
	and heights_table[map[cursor_world_y][cursor_world_x] ] == 0
	--and mlandscape_obj[map[cursor_world_y][cursor_world_x] ]==0
	then
		helpers.beforeShoot();
		helpers.turnMob(current_mob);
		game_status="shot"
		boomx = cursor_world_x;
		boomy = cursor_world_y;
		damage.shoot();
	end;

	if love.mouse.isDown("l")
	and chars_mobs_npcs[current_mob].control=="player"
	and game_status == "sensing"
	and not helpers.cursorAtMob (cursor_world_x,cursor_world_y)
	and missle_type=="firemine"
	and helpers.cursorIsNear(cursor_world_x,cursor_world_y,chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y)
	and dlandscape_obj[cursor_world_x][cursor_world_y]~="fire"
	and mlandscape_obj[cursor_world_x][cursor_world_y]==0
	and heights_table[map[cursor_world_y][cursor_world_x] ]==0
	then
		minecanbeinstalled=1; --FIXME to function
		for i=1,6 do
			if cursor_world_y/2==math.ceil(cursor_world_y/2) then
				if heights_table[map[cursor_world_y+directions[1].y[i] ][cursor_world_x+directions[1].xc[i] ] ]==0
				and dlandscape_obj[cursor_world_x+directions[1].xc[i] ][cursor_world_y+directions[1].y[i] ]~="fire"
				and mlandscape_obj[cursor_world_x+directions[1].xc[i] ][cursor_world_y+directions[1].y[i] ]==0 then
				else
					minecanbeinstalled=0;
				end;
			elseif cursor_world_y/2~=math.ceil(cursor_world_y/2) then
				if heights_table[map[cursor_world_y+directions[1].y[i] ][cursor_world_x+directions[1].xn[i] ] ] == 0
				and dlandscape_obj[cursor_world_x+directions[1].xn[i] ][cursor_world_y+directions[1].y[i] ] ~= "fire"
				and mlandscape_obj[cursor_world_x+directions[1].xn[i] ][cursor_world_y+directions[1].y[i] ] == 0 then
				else
				 minecanbeinstalled=0;
				end;
			end;
		end;
		if minecanbeinstalled==1 then
			helpers.beforeShoot();
			helpers.turnMob(current_mob);
			game_status="shot"
			damage.shoot();
		end;
	end;
	
--modifing equipment
	if love.mouse.isDown("l") and game_status == "inventory" and holding_smth == 0 and oil_smth > 0 then
		sorttarget = dragfrom;
		local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false);
		local oiltype = inventory_ttx[list[oil_smth].ttxid].subclass;
		local oileffect = inventory_ttx[list[oil_smth].ttxid].a;
		local oilpower = inventory_ttx[list[oil_smth].ttxid].q;
		if helpers.inSlot("rh")
		and chars_mobs_npcs[current_mob]["equipment"].rh > 0
		and (oiltype == "trioil" or oiltype == "oil")
		then
			helpers.oilItemInSlot(current_mob,"rh",oiltype,oilpower,oileffect);
		elseif helpers.inSlot("lh")
		and chars_mobs_npcs[current_mob]["equipment"].lh > 0
		and (inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].lh].ttxid].class == "sword"
		or inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].lh].ttxid].class == "dagger")
		and (oiltype == "trioil" or oiltype == "oil")
		then
			helpers.oilItemInSlot(current_mob,"lh",oiltype,oilpower,oileffect);
		elseif helpers.inSlot("ammo")
		and chars_mobs_npcs[current_mob]["equipment"].ammo > 0
		and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].ttxid].class ~= "battery"
		and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].ttxid].class ~= "bullet"
		and (oiltype == "trioil" or oiltype == "oil")
		and (oiltype == "trioil" or oiltype == "oil")
		then
			helpers.oilItemInSlot(current_mob,"ammo",oiltype,oilpower,oileffect);
		elseif helpers.inSlot("ranged")
		and chars_mobs_npcs[current_mob]["equipment"].ranged > 0
		and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].ttxid].class == "wand"
		and oiltype == "chargeoil"
		then
			helpers.oilItemInSlot(current_mob,"ammo",oiltype,oilpower,oileffect);
		end;
		
		local hardslots = {"rh","lh","ranged","armor","helm","boots","gloves","belt","cloak","amulet","ring1","ring2","ring3","ring4","ring5","ring6"};
		if oil_smth > 0 then
			for i=1,#hardslots do
				slot = hardslots[i]
				if helpers.inSlot(slot)
				and chars_mobs_npcs[current_mob]["equipment"][slot] > 0
				and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][slot]].ttxid].class ~= "wand"
				and (oiltype == "hardoil")
				then
					helpers.oilItemInSlot(current_mob,slot,oiltype,oilpower,oileffect);
					break;
				end;
			end;
		end;
		
		local resetslots = {"rh","lh"};
		if oil_smth > 0 then
			for i=1,#resetslots do
				slot = resetslots[i]
				if helpers.inSlot(slot)
				and chars_mobs_npcs[current_mob]["equipment"][slot] > 0
				and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][slot]].ttxid].class ~= "wand"
				and (oiltype == "resetoil")
				then
					helpers.oilItemInSlot(current_mob,slot,oiltype,oilpower,oileffect);
					break;
				end;
			end;
		end;
		
		local eternalslots = {"rh","lh","ranged","armor","helm","boots","gloves","belt","cloak","amulet","ring1","ring2","ring3","ring4","ring5","ring6"};
		if oil_smth > 0 then
			for i=1,#eternalslots do
				slot = eternalslots[i]
				if helpers.inSlot(slot)
				and chars_mobs_npcs[current_mob]["equipment"][slot] > 0
				and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"][slot]].ttxid].class ~= "wand"
				and (oiltype == "eternaloil")
				then
					helpers.oilItemInSlot(current_mob,slot,oiltype,oilpower,oileffect);
					break;
				end;
			end;
		end;	
	end;
--/
end;

function find_free_space_at_inv ()
	local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false);
	for c = 1,15*11 do
		some_crap_under_cursor=0;
		ccy = math.ceil(c/11);
		ccx = c-(ccy-1)*11;
		if holding_smth > 0 then
			for a = ccx,math.min(11,inventory_ttx[list[holding_smth].ttxid].w+ccx) do
				for b = ccy,math.min(15,inventory_ttx[list[holding_smth].ttxid].h+ccy) do
					if bag[selected_char][b][a] > 0 or ccx>(11-(inventory_ttx[list[holding_smth].ttxid].w-1)) or ccy>(15-(inventory_ttx[list[holding_smth].ttxid].h-1)) then --NIL
						some_crap_under_cursor = 1;
					end;
				end;
			end;
		end;
		if some_crap_under_cursor == 0 and holding_smth > 0 then
			table.insert(list, {ttxid=list[holding_smth].ttxid, q=list[holding_smth].q, w=list[holding_smth].w, e=list[holding_smth].e, r=list[holding_smth].r, h=list[holding_smth].h});
--buggy
			if donotsortthis == 0 or sorttarget == "bag" then
				if global.start or sort_switcher == 1 then
					bag[selected_char][ccy][ccx] = #list;
				elseif not global.start and sort_switcher == 0 then
					if slot == 0 then
						bag[selected_char][ccy][ccx] = holding_smth;
						bag[selected_char][ccy][ccx] = #list;
					elseif slot ~= 0 then
						chars_mobs_npcs[current_mob]["equipment"][slot] = holding_smth;
						slot = 0;
					end;
				end;
			end;
 --/buggy
			if exchange == 1 then
				helpers.addToActionLog( chars_stats[current_mob].name .. lognames.actions.gave .. chars_stats[selected_char].name .. inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][holding_smth].ttxid].title);
				table.remove(chars_mobs_npcs[tmp_bagid]["inventory_list"],holding_smth);
				for d=1,11 do
					for e=1,15 do
						if bag[current_mob][e][d] > holding_smth and bag[current_mob][e][d] < 10000 then
							bag[current_mob][e][d] = bag[current_mob][e][d]-1;
						end;
					end;
				end;
				helpers.renumber(holding_smth,current_mob);
				if sorttarget == "char" then
					for key,value in pairs(chars_mobs_npcs[tmp_bagid]["equipment"]) do
						if value > holding_smth then
							chars_mobs_npcs[tmp_bagid]["equipment"].value = chars_mobs_npcs[tmp_bagid]["equipment"].value-1;
						end;
					end;
				end;
			end;
			holding_smth=0;
			find_nonfree_space_at_inv();
		else

		end;
	end;
	holding_smth=0;
end;

function potion_in_inventory_ttx ()
	--print("potion_in_inventory_ttx called");
	for i = 1,#inventory_ttx do
		if inventory_ttx[i].class == "potion" then
			if inventory_ttx[i].c == potioncode then
				--print("potion found");
				if alchstatus == "boiledfromcomponents" then
					local tmpbottleid = alchlab[current_mob].bottle1;
					local temppower=0;
					local temppower2 = 0;
					local tmp1 = 0;
					local tmp2 = 0;
					local tempcomp = 0;
					local homogenization = 1;
					for k=1,6 do
					local tempslot3="comp" .. k
					if alchlab[current_mob][tempslot3] > 0 then
						tempcomp=chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob][tempslot3]].q
					else
						tempcomp=0
					end;
					--print("tempcomp",tempcomp);
					if (tempcomp>0 and temppower==0) or (tempcomp>0 and chars_mobs_npcs[current_mob]["inventory_list"][tempcomp].q<temppower) then
						temppower=tempcomp;
					end;
					print("temppower",temppower);
					if tempcomp>0 and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][tempcomp].ttxid].subclass == "raw" then
						homogenization=0;
					end;
				end;
				if alchlab[current_mob].tool2==0 then
					temppower2=math.random(temppower);
				elseif alchlab[current_mob].tool2>0 and homogenization==0 then
					tmp1=math.ceil(temppower*inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].tool2].ttxid].a/100);
					tmp2=temppower-tmp1;
					temppower2=tmp1+math.random(tmp2);
				elseif alchlab[current_mob].tool2>0 and homogenization==1 then
					temppower2=temppower;
				end;
				--print("temppower2",temppower2);
				local powerlimit = (chars_stats[current_mob].lvl_alchemy*chars_stats[current_mob].num_alchemy+(chars_mobs_npcs[current_mob].num_alchemy-chars_stats[current_mob].num_alchemy));
				local tmppotionpower=math.ceil((temppower2+powerlimit)*inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].tool1].ttxid].a/100);
				table.remove(chars_mobs_npcs[current_mob]["inventory_list"],alchlab[current_mob].bottle1);
				local tempslot2 = 0;
				local tempslot3 = 0;
				helpers.renumber(tmpbottleid,current_mob);
				local tempcomp = 0;
				for h = 1,6 do
					tempslot3 = "comp" .. h;
					tempcomp=alchlab[current_mob][tempslot3];
					if tempcomp>0 then
						table.remove(chars_mobs_npcs[current_mob]["inventory_list"],alchlab[current_mob][tempslot3]);
						alchlab[current_mob][tempslot3] = 0;
						helpers.renumber(tempcomp,current_mob);
					end;
				end;
				table.insert(chars_mobs_npcs[current_mob]["inventory_list"],{ttxid=i,q=tmppotionpower,w=0,e=0,r=1});
				alchlab[current_mob].bottle1=#chars_mobs_npcs[current_mob]["inventory_list"];
				helpers.addToActionLog( chars_stats[current_mob].name .. lognames.actions.boiled[chars_stats[current_mob].gender] .. inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][alchlab[current_mob].bottle1].ttxid].title .. lognames.actions.ofpower .. tmppotionpower);
				elseif alchstatus == "mixedpotions" then
				--print("potion found2");
				mixedpotion = i;
				end;
			end;
		end;
	end;
end;

function mobMoving()
	local trapped = 0;
	local price = 0;
	if path_counter > 0 and #way_of_the_mob > 0 then
		chars_mobs_npcs[current_mob].rot = way_of_the_mob[path_counter][6];
		price = helpers.countCurrentHexPrice(path_counter,current_mob);
	end;
	if (walked_before == 0 and global.timers.n_timer >= 0.2*global.walk_animation_speed) or global.timers.n_timer >= 0.4*global.walk_animation_speed then
		local sound_of_step = stepsound_table[map[chars_mobs_npcs[current_mob].y][chars_mobs_npcs[current_mob].x]]
		local snd = loadstring("return " .. "media.sounds.footstep_short_" .. sound_of_step)();
		utils.playSfx(snd,1);
		b = chars_mobs_npcs[current_mob].x;
		a = chars_mobs_npcs[current_mob].y;
		local rings = boomareas.ringArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
		for i=1,6 do
			for j=1, #chars_mobs_npcs do
				if chars_mobs_npcs[j].x == rings[1][i].x and chars_mobs_npcs[j].y == rings[1][i].y and chars_mobs_npcs[j].invisibility > 0 then
					chars_mobs_npcs[j].invisibility = 0;
				end;
			end;
		end;
		walked_before = walked_before + 1;
		if global.status == "peace" then
			calendar.add_time_interval(calendar.delta_walk_in_peace);
		end;
		if helpers.aliveNature(current_mob) and global.status == "battle" then
			if chars_mobs_npcs[current_mob].st >= price then
				chars_mobs_npcs[current_mob].st = chars_mobs_npcs[current_mob].st-price;
			else
				chars_mobs_npcs[current_mob].st = 0;
				utils.printDebug("out of stamina!");
				--game_status = "restoring";
				local name = helpers.mobName(current_mob);
				chars_mobs_npcs[current_mob].weakness_power = 5;
				chars_mobs_npcs[current_mob].weakness_dur = 5;
				helpers.addToActionLog( name .. " " .. lognames.actions.tired[chars_mobs_npcs[current_mob].gender]);
			end;
		end;
		if chars_mobs_npcs[current_mob].rt >= price and global.status == "battle" then --do not need if count before  FIXME WTF?
			chars_mobs_npcs[current_mob].rt = chars_mobs_npcs[current_mob].rt-price;
		elseif global.status == "battle" then
			chars_mobs_npcs[current_mob].rt = 0;
			utils.printDebug("out of recovery!");
			game_status = "restoring";
			local name = helpers.mobName(current_mob);
			helpers.addToActionLog( name .. " " .. lognames.actions.tired[chars_mobs_npcs[current_mob].gender]);
		end;
		if path_counter > 0 then
			chars_mobs_npcs[current_mob].x = way_of_the_mob[path_counter][1];
			chars_mobs_npcs[current_mob].y = way_of_the_mob[path_counter][2];
			if chars_mobs_npcs[current_mob].stealth > 0 then
				chars_mobs_npcs[current_mob].stealth =  chars_mobs_npcs[current_mob].stealth - ai.mobWatchesTheMobNum (current_mob,false);
				if chars_mobs_npcs[current_mob].stealth < 0 then
					chars_mobs_npcs[current_mob].stealth = 0;
				end;
			end;
			if chars_mobs_npcs[current_mob].ai == "cruiser" then
				for i=1, #chars_mobs_npcs[current_mob].waypoint do
					if chars_mobs_npcs[current_mob].x == chars_mobs_npcs[current_mob].waypoint[i][1] and chars_mobs_npcs[current_mob].y == chars_mobs_npcs[current_mob].waypoint[i][2] then
						if chars_mobs_npcs[current_mob].nextpoint < #chars_mobs_npcs[current_mob].waypoint then
							chars_mobs_npcs[current_mob].nextpoint = chars_mobs_npcs[current_mob].nextpoint + 1;
						else
							chars_mobs_npcs[current_mob].nextpoint = 1;
						end;
					end;
				end;
			end;
			--helpers.findShadows();
			if chars_mobs_npcs[current_mob].torchlight > 0 then
				for i=1,#lights do
					if lights[i].typ == "mob" and lights[i].index == current_mob then
						lights[i].x = chars_mobs_npcs[current_mob].x;
						lights[i].y = chars_mobs_npcs[current_mob].y;
					end;
				end;
			end;
			--shadows[current_mob].y = way_of_the_mob[path_counter][1];
			--shadows[current_mob].x = way_of_the_mob[path_counter][2];
			if chars_mobs_npcs[current_mob].bleeding > 0 then
				boomareas.bloodGround (chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
			end;
			if global.status == "peace" and ai.enemyWatchesYou () then --FIXME SLOWWWW
				helpers.interrupt();
				letaBattleBegin ();
			end;
		end;
		local a = chars_mobs_npcs[current_mob].x;
		local b = chars_mobs_npcs[current_mob].y;

		if chars_mobs_npcs[current_mob].motion == "walking" then
			boomareas.trackGround (a,b,chars_mobs_npcs[current_mob].track,chars_mobs_npcs[current_mob].rot);
			if hlandscape[b][a] > 25 and hlandscape[b][a] <= 50 then
				hlandscape[b][a] = 0;
			end;
			if hlandscape[b][a] > 50 and helpers.mobIgnoresBooshes(current_mob) then
				hlandscape[b][a] = 0;
			end;
		end;
		if chars_mobs_npcs[current_mob].motion == "underground" then
			if hlandscape[b][a] > 25 and hlandscape[b][a] <= 50 then
				hlandscape[b][a] = 0;
			end;
		end;
		
		if chars_mobs_npcs[current_mob].fireprint_dur > 0 then
			local lvl =  chars_mobs_npcs[current_mob].fireprint_power;
			local num =  chars_mobs_npcs[current_mob].fireprint_power;
			boomareas.fireGround (a,b,1,lvl,num);
		end;
		if helpers.trapHere(a,b) then
			bagid = helpers.trapHere(a,b);
			helpers.groundTrapActivated (bagid);
			trapped = 1;
			path_counter=0;
			global.hang = false;
		end;
		if mlandscape_obj[b][a] == "firemine" then  -- FIXME agro and fractions!
			utils.printDebug("mine boom!");
			boomx = a;
			boomy = b;
			trapped = 1;
			missle_type = "fireball"; --FIXME firebomb?
			missle_drive = "trap";
			game_status = "boom";
			dmg = mlandscape_power[b][a];
			global.trapindex = mlandscape_id[b][a];
			mlandscape_id[b][a] = 0;
			draw.boom(); -- count levels! shuld be taken from dlandscape, another missle_drive also
			mlandscape_obj[b][a] = 0;
			mlandscape_duration[b][a] = 0;
			helpers.addToActionLog( magic.spell_tips.firemine.title .. lognames.actions.activated);
			path_counter=0;
			global.hang = false;
		end;
		damage.landscapeHex(current_mob,a,b);
		--if trapped == 1 then --HANGS Explosion
			--damage.RTminus(current_mob,100);
			--game_status = "restore";
		--end;
		local tmp = chars_mobs_npcs[current_mob].sprite .. "_walk";
		local mob_walk = loadstring("return " .. tmp)();
		if path_counter == 1 then
			animation_walk = anim8.newAnimation(mob_walk[way_of_the_mob[path_counter][6]]("1-8",1), 0.075, "pauseAtEnd");
		else
			animation_walk = anim8.newAnimation(mob_walk[chars_mobs_npcs[current_mob].rot]("1-8",1), 0.075, "pauseAtEnd");
		end;
		if path_counter > 0 and chars_mobs_npcs[current_mob].control == "player" then
			tmp_current_mob = current_mob;
			trace.first_watch(current_mob);
			trace.one_around(current_mob);
			trace.clear_rounded();
		end;
		if path_counter>0 and chars_mobs_npcs[current_mob].control == "ai" then
			trace.trace_hexes(current_mob,false,trace.sightArray (current_mob));
		end
		mob_add_mov_x = 0;
		mob_add_mov_y = 0;
		path_counter = path_counter-1;
		--mob ends moving
		if path_counter == 0 and trapped ~= 1 then
			chars_mobs_npcs[current_mob].waterwalking = 0;
			trace.chars_around();
			trace.first_watch(current_mob);
			trace.clear_rounded();
			if chars_mobs_npcs[current_mob].control == "player" then
				helpers.cam_to_mob (current_mob);
			end;
			helpers.findShadows();
			if chars_mobs_npcs[current_mob].control == "player" and going_to_hit == 0 and mob_is_going_to_picklock == 0 and mob_is_going_to_knock == 0 and mob_is_going_to_useobject == 0 then
				game_status = "neutral";
				--helpers.neutralWatch();
				path_status = 0;
				global.hang = false;
			elseif  chars_mobs_npcs[current_mob].control=="player" and going_to_hit==1 and previctim ~=0
			and chars_mobs_npcs[current_mob].id ~= previctim
			and chars_mobs_npcs[previctim].status == 1 then
				if global.status == "battle" and (chars_mobs_npcs[previctim].person ~= "char" or chars_mobs_npcs[previctim].berserk > 0 or chars_mobs_npcs[previctim].control > 0) then
					helpers.turnMob (current_mob);
					local recovery = 0;
					recovery = helpers.countMeleeRecoveryChar (current_mob);
					if chars_mobs_npcs[current_mob].rt >= recovery then
						global.multiattack = damage.countMultiattack(current_mob);
						game_status = "attack";
						utils.printDebug("attack called from moving");
						damage.meleeAttack (damage.meleeAttackTool (current_mob));
					else
						utils.printDebug("out of recovery!");
						game_status = "restoring";
						local name = helpers.mobName(current_mob);
						helpers.addToActionLog( name .. lognames.actions.tired[chars_mobs_npcs[current_mob].gender]);
					end;
				elseif global.status == "peace" and chars_mobs_npcs[previctim].person ~= "char" and not global.steal then
					helpers.turnMob (current_mob);
					chars_mobs_npcs[previctim].rot = helpers.antiDirection(chars_mobs_npcs[current_mob].rot);
					chat (previctim);
					path_status = 0;
					global.hang = false;
					global.steal = false;
				elseif global.status == "peace" and chars_mobs_npcs[previctim].person ~= "char" and global.steal then
					steal(previctim);
					path_status = 0;
					global.hang = false;
					global.steal = false;
				end;
			elseif chars_mobs_npcs[current_mob].control == "player" and going_to_hit == 1 and previctim ~= 0 and mob_is_going_to_picklock == 0
			and chars_mobs_npcs[current_mob].id ~= previctim and chars_mobs_npcs[previctim].status < 1 then
				game_status = "neutral";
			elseif chars_mobs_npcs[current_mob].control == "player" and mob_is_going_to_picklock == 1 then
				game_status = "neutral";
				if bags_list[bagid].typ == "chest" or bags_list[bagid].typ == "door" then
					chars_mobs_npcs[current_mob].rot = last_path_hex_turn;
				else
					helpers.turnMob (current_mob);
				end;
				inventory_bag_call ();
				game_status = "inventory";
				path_status = 0;
				global.hang = false;
			elseif chars_mobs_npcs[current_mob].control == "player" and mob_is_going_to_useobject == 1 then
				helpers.turnMob (current_mob);
				game_status = "neutral";
				helpers.useObject();
				path_status = 0;
				global.hang = false;
			elseif chars_mobs_npcs[current_mob].control == "player" and mob_is_going_to_knock == 1 then
				helpers.knockToDoor ();
				path_status = 0;
				global.hang = false;
			elseif chars_mobs_npcs[current_mob].control == "ai" then
				if global.status == "peace" then
					chars_mobs_npcs[current_mob].rt = math.max(chars_mobs_npcs[current_mob].rt-standart_rtadd,0);
					mob_plus ();
				elseif global.status == "battle" or mob_range == 0 then --FIX LATER
					if mob_is_going_to_hit==1 and helpers.ifMobIsNear (current_mob,previctim) and previctim ~= 0
					and chars_mobs_npcs[current_mob] ~= previctim and chars_mobs_npcs[previctim].status == 1 then
						global.multiattack = damage.countMultiattack(current_mob);
						game_status = "attack";
						utils.printDebug("attack called from path finding");
						damage.meleeAttack (damage.meleeAttackTool (current_mob));
						mob_is_going_to_hit = 0;
					else
						chars_mobs_npcs[current_mob].rt = math.max(chars_mobs_npcs[current_mob].rt-standart_rtadd,0);
						game_status = "restoring";
					end;
				end;
				path_status = 0;
				global.hang = false;
			end;
			for f=1,#way_of_the_mob do
				table.remove(way_of_the_mob,1);
			end;
		end;
		global.timers.n_timer=0;
	end;
end;

function chat (index)
	utils.printDebug("CHAT!");
	victim = index;
	chats.load ();
	chat_log = {};
	global_answer = chats.answers[chars_mobs_npcs[victim]["personality"]["current"].chat][1];
	local a2log = chars_mobs_npcs[victim].name .. ": " .. global_answer; --FIXME for buildings
	table.insert(chat_log,a2log);
	helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.startedchatting[chars_mobs_npcs[current_mob].gender] .. helpers.mobName(victim));
	calendar.add_time_interval(calendar.delta_chat);
	game_status="chat";
	global.hang = false;
end;

function steal (index)
	utils.printDebug("STEAL!");
	game_status="neutral";
	victim = previctim;
	local chance_to_steal = chars_mobs_npcs[current_mob].num_thievery*chars_mobs_npcs[current_mob].lvl_thievery;
	if chars_mobs_npcs[index].sleep > 0 or chars_mobs_npcs[index].paralyze > 0 or chars_mobs_npcs[index].stun > 0 then
		chance_to_steal = chance_to_steal*2;
	end;
	local penalty = 1/helpers.visualConditions(index,chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
	local delta_spd = chars_mobs_npcs[current_mob].spd-chars_mobs_npcs[index].spd;
	local attacked_from = helpers.attackDirection(current_mob,index);
	local steal_dir_coff=0
	if attacked_from=="front" then
		steal_dir_coff=0.5;
	elseif attacked_from=="lh" then
		steal_dir_coff=0.75;
	elseif attacked_from=="rh" then
		steal_dir_coff=0.75;
	elseif attacked_from=="lback" then
		steal_dir_coff=1.25;
	elseif attacked_from=="rback" then
		steal_dir_coff=1.25;
	elseif attacked_from=="back" then
		steal_dir_coff=2;
	end;
	local chance_not_to_be_noticed = math.ceil(steal_dir_coff*chars_mobs_npcs[current_mob].dex) - delta_spd + math.ceil(chars_mobs_npcs[index].sns*penalty);

	if chars_mobs_npcs[index].blind > 0 or chars_mobs_npcs[index].sleep > 0 or chars_mobs_npcs[index].dark_gasp > 0 or (chars_mobs_npcs[index].reye and chars_mobs_npcs[index].reye == 0 and chars_mobs_npcs[index].leye and chars_mobs_npcs[index].leye == 0) or (chars_mobs_npcs[index].ceye and chars_mobs_npcs[index].ceye == 0) then
		chance_not_to_be_noticed = chance_not_to_be_noticed*2;
	end;
	if chars_mobs_npcs[index].fov == 90 then
		chance_not_to_be_noticed = chance_not_to_be_noticed*2;
	elseif chars_mobs_npcs[index].fov == 360 then
		chance_not_to_be_noticed = math.ceil(chance_not_to_be_noticed/2);
	end;
	if chars_mobs_npcs[current_mob].lvl_thievery == 5 then
		chance_to_steal = 100;
		chance_not_to_be_noticed = 100;
	end;
	local roll = math.random(1,100);
	if roll <= chance_to_steal then
		local items_to_remove = {};
		if chars_mobs_npcs[current_mob].num_thievery >= 1 then
		--gold
			local gold = chars_mobs_npcs[victim].gold;
			if gold > 0 then
				party.gold = party.gold + gold;
				chars_mobs_npcs[index].gold = chars_mobs_npcs[index].gold - 1;
				helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.stolen[chars_mobs_npcs[current_mob].gender] .. " " .. gold .. " " .. lognames.actions.withgold);
				helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.robbed[chars_mobs_npcs[current_mob].gender] .. helpers.mobName(victim));
				utils.playSfx(media.sounds.gold_dzen,1);
			end;
		end;
		if chars_mobs_npcs[current_mob].lvl_thievery >= 2 then
		--food,potions,components
			for i=1,#chars_mobs_npcs[index].inventory_list do
				if helpers.isPotion(chars_mobs_npcs[index].inventory_list[i].ttxid)
				or helpers.isFood(chars_mobs_npcs[index].inventory_list[i].ttxid)
				or helpers.isAlchemicalComponent(chars_mobs_npcs[index].inventory_list[i].ttxid)
				then
					table.insert(items_to_remove,chars_mobs_npcs[index].inventory_list[i]);
				end;
			end;
		end;
		if chars_mobs_npcs[current_mob].lvl_thievery >= 3 then
		--letters,keys,picklocks,traptools,maps,messages
			for i=1,#chars_mobs_npcs[index].inventory_list do
				if helpers.isPaper(chars_mobs_npcs[index].inventory_list[i].ttxid)
				or helpers.isKey(chars_mobs_npcs[index].inventory_list[i].ttxid)
				then
					table.insert(items_to_remove,chars_mobs_npcs[index].inventory_list[i]);
				end;
			end;
		end;
		if chars_mobs_npcs[current_mob].lvl_thievery >= 4 then
		--equiped rings and amulets
			for i=1,#chars_mobs_npcs[index].inventory_list do
				if helpers.isjewelry(chars_mobs_npcs[index].inventory_list[i].ttxid) then
					table.insert(items_to_remove,chars_mobs_npcs[index].inventory_list[i]);
				end;
			end;
		end;
		if chars_mobs_npcs[current_mob].lvl_thievery >= 5 then
			--gems,books,gobelens
			for i=1,#chars_mobs_npcs[index].inventory_list do
				if helpers.isBook(chars_mobs_npcs[index].inventory_list[i].ttxid)
				or helpers.isArt(chars_mobs_npcs[index].inventory_list[i].ttxid)
				or helpers.isGem(chars_mobs_npcs[index].inventory_list[i].ttxid)
				then
					table.insert(items_to_remove,chars_mobs_npcs[index].inventory_list[i]);
				end;
			end;
		end;
		if #items_to_remove > 0 then
			table.insert(bags_list,{x=chars_mobs_npcs[index].x,y=chars_mobs_npcs[current_mob].y,xi= chars_mobs_npcs[index].x,yi= chars_mobs_npcs[current_mob].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
			for i=#items_to_remove,1,-1 do
				table.insert(bags_list[#bags_list],{ttxid=chars_mobs_npcs[index].inventory_list[i].ttxid,q=chars_mobs_npcs[index].inventory_list[i].q,w=chars_mobs_npcs[index].inventory_list[i].w,e=chars_mobs_npcs[index].inventory_list[i].e,r=chars_mobs_npcs[index].inventory_list[i].r,h=chars_mobs_npcs[index].inventory_list[i].h});
			end;
			for i=#items_to_remove,1,-1 do
				table.remove(chars_mobs_npcs[victim]["inventory_list"][#bags_list],i);
				helpers.renumber (i,victim);
			end;
		end;
	end;
	local roll = math.random(1,100);
	if roll <= chance_not_to_be_noticed then
		--not noticed!
	else
		if chars_mobs_npcs[victim].person ~= "mob" then
			helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.catchedasthief[chars_mobs_npcs[current_mob].gender]);
			chars_mobs_npcs[victim]["personality"]["current"] = chars_mobs_npcs[victim]["personality"]["thiefcatcher"];
			chat(victim);
		else
			fractions[chars_mobs_npcs[victim].fraction].party = fractions[chars_mobs_npcs[victim].fraction].party - math.ceil(5 + (100-chars_mobs_npcs[current_mob].chr)/10);
			chars_mobs_npcs[current_mob].rt = 0;
			--restoreRT();
			game_status = "restoring";
		end;
	end;
	helpers.addToActionLog( helpers.mobName(current_mob) .. lognames.actions.didntrob[chars_mobs_npcs[current_mob].gender] .. helpers.mobName(victim));
	calendar.add_time_interval(calendar.delta_thievery);
	global.hang = false;
end;

function exp_for_what(value,index) --FIXME
	if global.status == "battle" then
		if chars_mobs_npcs[index].person=="char" then
			chars_mobs_npcs[index].tmpexpdmg = chars_mobs_npcs[index].tmpexpdmg + value;
		elseif chars_mobs_npcs[index].person == "mob" and chars_mobs_npcs[current_mob].person == "char" then
			chars_mobs_npcs[victim].tmpexplost = chars_mobs_npcs[victim].tmpexplost + value;
		end;
	end;
end;

function missle_fly ()
	if global.timers.msla_timer >= 0.02 then
		add_to_mslx = add_to_mslx + add_msl_x;
		if missle_type ~= "bottle" then
			add_to_msly=add_to_msly+add_msl_y;
		else
			local addy = 0;
			if fly_count <= #shot_line/2  then
				addy = math.abs(add_to_mslx^3);
			else
				addy = -1*math.abs(math.sqrt(add_to_mslx));
			end;
			add_to_msly=add_to_msly+add_msl_y;
		end;
		global.timers.msla_timer=0;
	end;
	if global.timers.msl_timer >= 0.05 then -- 0.005 too fast
		missle_x = shot_line[fly_count][1];
		missle_y = shot_line[fly_count][2];
		if missle_x == chars_mobs_npcs[victim].x and missle_y == chars_mobs_npcs[victim].y then
			--if missle_drive == "spellbook" or missle_drive=="scroll" or missle_drive=="wand" then
			if helpers.missleIsAweapon () and missle_type ~= "bottle" and missle_type ~= "bitingcloud" then
				game_status = "damage";
				damage.singledamage();
				fly_count = 1;
			elseif missle_type == "evilswarm" then
				game_status = "damage";
				damage.multidamage();
				fly_count = 1;
			elseif missle_type == "bottle" then
			elseif magic.spell_tips[missle_type].form == "ball"
			or magic.spell_tips[missle_type].form == "arrow" then
			--or missle_type == "toxiccloud" then
				boomx = missle_x;
				boomy = missle_y; --lala
				draw.boom();
				fly_count = 1;
			end

		end
		if fly_count == #shot_line then
			if missle_type == "bottle" then
				boomx = missle_x;
				boomy = missle_y;
				draw.boom();
				fly_count = 1;
			end;
		end;
		if fly_count < #shot_line then
			fly_count = fly_count+1
		end
		global.timers.msl_timer=0;
	end
	in_fly=0;
end

function meteor_fly()
	meteor_y = meteor_y-25;
	if meteor_y <= 0 then
		in_fly=0;
		global.timers.msl_timer=0;
		draw.boom();
	end;
end;

function armageddon_fly()
	meteor_y = meteor_y-15;
	stone_y = stone_y+15
	if meteor_y <= 0 then
		in_fly=0;
		global.timers.msl_timer=0;
		draw.boom();
	end;
end;

function rock_fly()
	if global.timers.msla_timer>=0.02 then
		if rock_step<#rockline then
			local cx1,cy1 = helpers.rockCoords (rockline[rock_step].x,rockline[rock_step].y);
			local cx2,cy2 = helpers.rockCoords (rockline[rock_step + 1].x,rockline[rock_step + 1].y);
			misx=cx1+(cx2-cx1)/2.5;
			misy=cy1+(cy2-cy1)/2.5;
		end
		global.timers.msla_timer=0;
	end
	if global.timers.msl_timer>=0.06 and rock_step<#rockline then
		rock_step=rock_step+1;
		missle_x=rockline[rock_step].x;
		missle_y=rockline[rock_step].y;
		misx,misy = helpers.rockCoords (rockline[rock_step].x,rockline[rock_step].y);
		helpers.clearHlandscape(missle_x,missle_y);
		global.timers.msl_timer=0
	end
	if global.timers.msl_timer>=0.06 and rock_step==#rockline then
		in_fly=1;
		boomx=rockline[rock_step].x;
		boomy=rockline[rock_step].y;
		draw.boom();
	end;
end;

function letaBattleBegin ()
	utils.printDebug("Battle started!");
	global.walk_animation_speed = 0.25;
	if global.status == "peace" then
		for i=1,#chars_mobs_npcs do
			helpers.countMoral(i);
		end;
		utils.playSfx(media.sounds.battle_begins,1);
		helpers.addToActionLog( lognames.actions.battlestarted);
		global.status="battle";
		global.battle_start = true;
		--utils.playSfx(media.sounds.battle, 1);
		utils.playThemeMusic (media.sounds.battle,0,"battle");
		helpers.battleorder();
	end;
end;

function letaBattleFinishes ()
	utils.printDebug("Battle finished!");
	global.walk_animation_speed = 0.1;
	if global.status == "battle" then
		utils.playSfx(media.sounds.battle_finishes,1);
		helpers.addToActionLog(lognames.actions.battlefinished);
		global.status = "peace";
		--love.audio.stop(media.sounds.battle, 0);
		utils.playThemeMusic (media.sounds.peace,0,"peace");
		for i=1,#chars_mobs_npcs do
			chars_mobs_npcs[i].enslave = 0;
			if chars_mobs_npcs[i].summoned then
				chars_mobs_npcs[i].status = 0;
			end;
		end;
	end;
end;

function restoreRT ()
	dodge = 0;
	block = 0;
	parry = 0;
	missle_type = "none";
	missle_drive = "muscles";
	trapped = 0;
	ai_called = 0;
	mob_is_going_to_hit = 0;
	walked_before = 0;
	global.timer200 = global.timer200 + 1;
	calendar.add_time_interval(calendar.delta_restore_in_battle);
	path_failed = 0;
	path_status = 0;
	--clear_elandscape();
	if global.timer200 >= 20 then
		for i=1,#chars_mobs_npcs do
			if chars_mobs_npcs[i].status == 1 and  chars_mobs_npcs[i].ai ~= "building" then
				damaged_mobs = {};
				if chars_mobs_npcs[i].person == "char" then -- oil at stuff expires while equiped
					for key,value in pairs(chars_mobs_npcs[i]["equipment"]) do
						if chars_mobs_npcs[i]["equipment"][key] > 0 then
							if chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][key]].e > 0 and chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][key]].e < 1000 then
								chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][key]].e = chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][key]].e-1;
							end
							if chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][key]].e == 0 then
								chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][key]].w = 0;
							end;
							if chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][key]].h > 0 and chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][key]].h < 1000 then
								chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][key]].h = chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][key]].h-1;
							end
						end;
					end;
				end;
				if chars_mobs_npcs[i].stealth > 0 then
					chars_mobs_npcs[i].stealth =  chars_mobs_npcs[i].stealth - ai.mobWatchesTheMobNum (i,false);
					if chars_mobs_npcs[i].stealth < 0 then
						chars_mobs_npcs[i].stealth = 0;
					end;
				end;
				
				if chars_mobs_npcs[i].dayofgods_dur > 0 then
					chars_mobs_npcs[i].dayofgods_dur = chars_mobs_npcs[i].dayofgods_dur -1;
					if chars_mobs_npcs[i].dayofgods_dur == 0 then
						chars_mobs_npcs[i].dayofgods_power = 0;
						helpers.recalcBattleStats(i);
					end;
				end;
				if chars_mobs_npcs[i].person == "char" then
					if chars_mobs_npcs[i].status == 0 and chars_mobs_npcs[i].nature == "humanoid" then
						damage.HPminus(i,10);
					end;
					if chars_mobs_npcs[i].status == 0 and chars_mobs_npcs[i].nature == "undead" then
						damage.HPplus(i,5); --FIXME liches and deathknights can get hp regen, so no need
					end;
				end;
				damage.landscapeHex(current_mob,chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
				if chars_mobs_npcs[i].fingerofdeath > 0 then
					local chance = math.random(1,math.max(chars_mobs_npcs[i].luk+1,101));
					if chance > chars_mobs_npcs[i].luk then
						damage.HPminus(i,chars_mobs_npcs[i].hp);
					end;
					chars_mobs_npcs[i].fingerofdeath = chars_mobs_npcs[i].fingerofdeath -1;
				end;
				if chars_mobs_npcs[i].darkcontamination > 0 and leveltype == "openair" and calendar.hour >= 6 and calendar.hour <= 21 then
					damage.HPminus(i,math.random(1,100));
					chars_mobs_npcs[i].darkcontamination = chars_mobs_npcs[i].darkcontamination -1;
				end;
				if chars_mobs_npcs[i].freeze>0 then
					chars_mobs_npcs[i].freeze = chars_mobs_npcs[i].freeze-1;
				end
				if chars_mobs_npcs[i].stone > 0 then
					chars_mobs_npcs[i].stone = chars_mobs_npcs[i].stone-1;
				end;
				if chars_mobs_npcs[i].disease > 0 then
					if chars_mobs_npcs[i].disease > chars_mobs_npcs[i].rez_disease and chars_mobs_npcs[i].disease < 100 then
						chars_mobs_npcs[i].disease = chars_mobs_npcs[i].disease + 1;
					elseif chars_mobs_npcs[i].disease < chars_mobs_npcs[i].rez_disease then
						chars_mobs_npcs[i].disease = chars_mobs_npcs[i].disease - 1;
					end;
				end;
				if chars_mobs_npcs[i].disease > 0 then
					local x = chars_mobs_npcs[i].x;
					local y = chars_mobs_npcs[i].y;
					local ring = boomareas.smallRingArea(x,y);
					for k=1,#chars_mobs_npcs do
						if helpers.aliveNature(k) and helpers.mobIsAlive (k) and helpers.cursorAtCurrentMob (k,x,y) then
							local disease = damage.applyCondition (k,1,chars_mobs_npcs[i].disease,"disease","disease",false,false,1,true);
							chars_mobs_npcs[k].disease = disease;
						end;
					end;
				end;
				if chars_mobs_npcs[i].flame_dur > 0 then
					chars_mobs_npcs[i].flame_dur = chars_mobs_npcs[i].flame_dur-1;
					--dmg = chars_mobs_npcs[i].flame_power*math.ceil((100-chars_mobs_npcs[i].rezfire)/100);
					dmg = chars_mobs_npcs[i].flame_power;
					local victim_name = helpers.mobName(i);
					helpers.addToActionLog( victim_name .. lognames.actions.gotdmg[chars_mobs_npcs[i].gender]  .. dmg .. lognames.actions.metr  .. lognames.actions.ofhp .. types_of_damage.fire .. types_of_damage.dot);
					damage.HPminus(i,dmg);
				end
				if chars_mobs_npcs[i].poison_dur > 0 then
					chars_mobs_npcs[i].poison_dur = chars_mobs_npcs[i].poison_dur-1
					local dmg = damage.magicalRes (i,chars_mobs_npcs[i].poison_power,"poison");
					local victim_name = helpers.mobName(i);
					damage.PoisonPlus(i,dmg);
					if	chars_mobs_npcs[i].poison_status >= chars_mobs_npcs[i].hp then
						damage.HPminus(i,dmg);
					end;
					helpers.addToActionLog( victim_name .. lognames.actions.gotdmg[chars_mobs_npcs[i].gender]  .. dmg .. lognames.actions.metr  .. lognames.actions.ofhp .. types_of_damage.poison .. types_of_damage.dot);
				end
				if chars_mobs_npcs[i].bleeding > 0 then
					local victim_name = helpers.mobName(i);
					helpers.addToActionLog( victim_name .. lognames.actions.gotdmg[chars_mobs_npcs[i].gender]  .. bleeding .. lognames.actions.metr  .. lognames.actions.ofhp .. types_of_damage.poison .. types_of_damage.dot);
					damage.HPminus(i,bleeding);
					chars_mobs_npcs[i].bleeding = chars_mobs_npcs[i].bleeding-1;
					boomareas.bloodGround (chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
				end
				if chars_mobs_npcs[i].cold_dur > 0 then
					chars_mobs_npcs[i].cold_dur= chars_mobs_npcs[i].cold_dur-1;
					dmg1 = 0
					if chars_mobs_npcs[i].st > 0 then
						--dmg1=math.min(chars_mobs_npcs[i].st,chars_mobs_npcs[i].cold_power*math.ceil((100-chars_mobs_npcs[i].rezcold)/100))
						dmg1 = chars_mobs_npcs[i].cold_power;
						local victim_name = helpers.mobName(i);
						--helpers.addToActionLog( victim_name .. lognames.actions.gotdmg[chars_mobs_npcs[current_mob].gender]  .. dmg1 .. lognames.actions.metr  .. lognames.actions.ofst .. types_of_damage.cold .. types_of_damage.dot);
						damage.STminus(i,dmg1);
					end
					if chars_mobs_npcs[i].st <= 0 then
						--dmg2 = math.min(chars_mobs_npcs[i].hp,chars_mobs_npcs[i].cold_power*math.ceil((100-chars_mobs_npcs[i].rezcold)/100)-dmg1)
						dmg2 = chars_mobs_npcs[i].cold_power;
						local victim_name = helpers.mobName(i);
						--helpers.addToActionLog( victim_name .. lognames.actions.gotdmg[chars_mobs_npcs[current_mob].gender]  .. dmg2 .. lognames.actions.metr  .. lognames.actions.ofhp .. types_of_damage.cold .. types_of_damage.dot);
						damage.HPminus(i,dmg2);
					end
				end
				if chars_mobs_npcs[i].acid_dur > 0 then
					chars_mobs_npcs[i].acid_dur = chars_mobs_npcs[i].acid_dur-1;
					--dmg= chars_mobs_npcs[i].acid_power*math.ceil((100-chars_mobs_npcs[i].rezacid)/100);
					dmg = chars_mobs_npcs[i].acid_power;
					local victim_name = helpers.mobName(i);
					helpers.addToActionLog( victim_name .. lognames.actions.gotdmg[chars_mobs_npcs[current_mob].gender]  .. dmg .. lognames.actions.metr  .. lognames.actions.ofhp .. types_of_damage.acid .. types_of_damage.dot);
					damage.HPminus(i,dmg);
				end
				if chars_mobs_npcs[i].torchlight > 0 then
					chars_mobs_npcs[i].torchlight = chars_mobs_npcs[i].torchlight-1;
				elseif chars_mobs_npcs[i].torchlight == 0 then
					for h=#lights,1,-1 do
						if lights[h].typ == "mob" and lights[h].index == i then
							lights[h]["light"].clear();
							table.remove(lights,i);
						end;
					end;
				end;
				if chars_mobs_npcs[i].stun > 0 then
					chars_mobs_npcs[i].stun = chars_mobs_npcs[i].stun-1;
				end;
				if chars_mobs_npcs[i].paralyze > 0 then
					chars_mobs_npcs[i].paralyze = chars_mobs_npcs[i].paralyze-1;
				end;
				if chars_mobs_npcs[i].immobilize > 0 then
					chars_mobs_npcs[i].immobilize = chars_mobs_npcs[i].immobilize-1;
				end;
				if chars_mobs_npcs[i].charm > 0 then
					chars_mobs_npcs[i].charm = chars_mobs_npcs[i].charm-1;
				end;
				if chars_mobs_npcs[i].enslave > 0 then
					chars_mobs_npcs[i].enslave = chars_mobs_npcs[i].enslave-1;
				end;
				if chars_mobs_npcs[i].berserk > 0 then
					chars_mobs_npcs[i].berserk =  chars_mobs_npcs[i].berserk-1;
				end;
				if chars_mobs_npcs[i].fear > 0 then
					chars_mobs_npcs[i].fear =  chars_mobs_npcs[i].fear-1;
				end;
				if chars_mobs_npcs[i].panic > 0 then
					chars_mobs_npcs[i].panic =  chars_mobs_npcs[i].panic-1;
				end;
				if chars_mobs_npcs[i].guardian > 0 then
					chars_mobs_npcs[i].guardian =  chars_mobs_npcs[i].guardian-1;
				end;
				tmpi=i;
				helpers.recalcResistances(i);
				if chars_mobs_npcs[i].preservation > 0 then
					chars_mobs_npcs[i].preservation= chars_mobs_npcs[i].preservation-1;
				end;
				if chars_mobs_npcs[i].bless_dur > 0 then
					chars_mobs_npcs[i].bless_dur = chars_mobs_npcs[i].bless_dur - 1;
					if chars_mobs_npcs[i].bless_dur == 0 then
						chars_mobs_npcs[i].bless_power = 0;
					end;
				end;
				if chars_mobs_npcs[i].protection_dur > 0 then
					chars_mobs_npcs[i].protection_dur = chars_mobs_npcs[i].protection_dur - 1;
					if chars_mobs_npcs[i].protection_dur == 0 then
						chars_mobs_npcs[i].protection_power = 0;
					end;
				end;
				if chars_mobs_npcs[i].curse>0 then
					chars_mobs_npcs[i].curse= chars_mobs_npcs[i].curse-1;
				end;
				if chars_mobs_npcs[i].rage>0 then
					chars_mobs_npcs[i].rage= chars_mobs_npcs[i].rage-1;
				end;
				if chars_mobs_npcs[i].thirstofblood>0 then
					chars_mobs_npcs[i].thirstofblood= chars_mobs_npcs[i].thirstofblood-1;
				end;
				if chars_mobs_npcs[i].executor_dur>0 then
					chars_mobs_npcs[i].executor_dur= chars_mobs_npcs[i].executor_dur-1;
				end;
				if chars_mobs_npcs[i].holyblood_dur>0 then
					if chars_mobs_npcs[i].nature == "undead" then
						damage.HPminus(i,chars_mobs_npcs[i].holyblood_power,false);
					end;
					chars_mobs_npcs[i].holyblood_dur= chars_mobs_npcs[i].holyblood_dur-1;
				end;
				if chars_mobs_npcs[i].hourofpower_dur>0 then
					chars_mobs_npcs[i].hourofpower_dur= chars_mobs_npcs[i].hourofpower_dur-1;
					if chars_mobs_npcs[i].hourofpower_dur == 0 then
						chars_mobs_npcs[i].hp = -chars_mobs_npcs[i].enu;
					end;
				end;
				if chars_mobs_npcs[i].protfromfire_dur>0 then
					chars_mobs_npcs[tmpi].protfromfire_dur= chars_mobs_npcs[tmpi].protfromfire_dur-1;
				end;
				if chars_mobs_npcs[i].protfromcold_dur>0 then
					chars_mobs_npcs[tmpi].protfromcold_dur= chars_mobs_npcs[tmpi].protfromcold_dur-1;
				end;
				if chars_mobs_npcs[i].protfromstatic_dur>0 then
					chars_mobs_npcs[tmpi].protfromstatic_dur= chars_mobs_npcs[tmpi].protfromstatic_dur-1;
				end;
				if chars_mobs_npcs[i].protfromacid_dur>0 then
					chars_mobs_npcs[tmpi].protfromacid_dur= chars_mobs_npcs[tmpi].protfromacid_dur-1;
				end;
				if chars_mobs_npcs[i].protfrompoison_dur>0 then
					chars_mobs_npcs[tmpi].protfrompoison_dur= chars_mobs_npcs[tmpi].protfrompoison_dur-1;
				end;
				if chars_mobs_npcs[i].protofmind_dur>0 then
					chars_mobs_npcs[tmpi].protofmind_dur= chars_mobs_npcs[tmpi].protofmind_dur-1;
				end;
				if chars_mobs_npcs[i].protofspirit_dur>0 then
					chars_mobs_npcs[tmpi].protofspirit_dur= chars_mobs_npcs[tmpi].protofspirit_dur-1;
				end;
				if chars_mobs_npcs[i].shieldfromfire_dur>0 then
					chars_mobs_npcs[tmpi].shieldfromfire_dur= chars_mobs_npcs[tmpi].shieldfromfire_dur-1;
				end;
				if chars_mobs_npcs[i].shieldfromcold_dur>0 then
					chars_mobs_npcs[tmpi].shieldfromcold_dur= chars_mobs_npcs[tmpi].shieldfromcold_dur-1;
				end;
				if chars_mobs_npcs[i].shieldfromstatic_dur>0 then
					chars_mobs_npcs[tmpi].shieldfromstatic_dur= chars_mobs_npcs[tmpi].shieldfromstatic_dur-1;
				end;
				if chars_mobs_npcs[i].shieldfromacid_dur>0 then
					chars_mobs_npcs[tmpi].shieldfromacid_dur= chars_mobs_npcs[tmpi].shieldfromacid_dur-1;
				end;
				if chars_mobs_npcs[i].shield>0 then
					chars_mobs_npcs[tmpi].shield= chars_mobs_npcs[tmpi].shield-1;
				end;
				if chars_mobs_npcs[i].stoneskin_dur>0 then
					chars_mobs_npcs[tmpi].stoneskin_dur= chars_mobs_npcs[tmpi].stoneskin_dur-1;
				end;
				if chars_mobs_npcs[i].heroism_dur>0 then
					chars_mobs_npcs[i].heroism_dur= chars_mobs_npcs[i].heroism_dur-1;
				else
					chars_mobs_npcs[i].heroism_power=0;
				end;
				if chars_mobs_npcs[i].prayer>0 then
					chars_mobs_npcs[i].prayer= chars_mobs_npcs[i].prayer-1;
				end;
				if chars_mobs_npcs[i].myrth_dur>0 then
					chars_mobs_npcs[i].myrth_dur= chars_mobs_npcs[i].myrth_dur-1;
				else
					chars_mobs_npcs[i].myrth_power=0;
				end;
				if chars_mobs_npcs[i].despondency_dur>0 then
					chars_mobs_npcs[i].despondency_dur= chars_mobs_npcs[i].despondency_dur-1;
				else
					chars_mobs_npcs[i].despondency_power=0;
				end;
				--mobs only
				if chars_mobs_npcs[i].hp < chars_mobs_npcs[i].hp_max and chars_mobs_npcs[i].hp_regeneration > 0 and helpers.doNotFeelHunger(i) then
					damage.HPplus(i,chars_mobs_npcs[i].hp_regeneration);
					helpers.addHunger(i,value);
				end;
				if chars_mobs_npcs[i].sp < chars_mobs_npcs[i].sp_max and chars_mobs_npcs[i].sp_regeneration > 0 and helpers.doNotFeelHunger(i) then
					damage.SPplus(i,chars_mobs_npcs[i].sp_regeneration,true);
					helpers.addHunger(i,value);
				end;
				--/mobs only

				if chars_mobs_npcs[i].status <= 0 and chars_mobs_npcs[i].st > 0 then
					damage.STminus(i,1);
				end;
				if chars_mobs_npcs[i].hp < chars_mobs_npcs[i].hp_max and chars_mobs_npcs[i].num_regeneration > 0 and helpers.doNotFeelHunger(i) then
					local value = chars_mobs_npcs[i].lvl_regeneration*2 + math.ceil(chars_mobs_npcs[i].num_regeneration/5);
					damage.HPplus(i,value);
					helpers.addHunger(i,value);
				end;
				if chars_mobs_npcs[i].sp < chars_mobs_npcs[i].sp_max and chars_mobs_npcs[i].num_meditation > 0  and helpers.doNotFeelHunger(i) then
					local value = chars_mobs_npcs[i].lvl_meditation*2 + math.ceil(chars_mobs_npcs[i].num_meditation/5);
					damage.SPplus(i,value,true);
					helpers.addHunger(i,value);
				end;
				
				for e=1,#chars_mobs_npcs[i]["equipment"] do
					if chars_mobs_npcs[i]["equipment"][e] > 0 then
						for key,value in pairs (items_modifers[chars_mobs_npcs[i]["inventory_list"][chars_mobs_npcs[i]["equipment"][e]].w].regeneration) do
							if (chars_mobs_npcs[i].person == "char" and chars_mobs_npcs[i].status >= 0) or chars_mobs_npcs[i].status == 1 then
								if key == hp then
									if value > 0 then
										damage.HPplus(i,value,false);
									else
										damage.HPminus(i,value,false);
									end;
								end;
								if key == sp then
									if value > 0 then
										damage.SPplus(i,value,false);
									else
										damage.SPminus(i,value,false);
									end;
								end;
								if key == st then
									if value > 0 then
										damage.STplus(i,value,false);
									else
										damage.STminus(i,value,false);
									end;
								end;
								if key == rt then
									if value > 0 then
										damage.RTplus(i,value,false);
									else
										damage.RTminus(i,value,false);
									end;
								end;
							end;
						end;
					end;
				end;	
								
				if chars_mobs_npcs[i].healaura_dur > 0 then --FIXME rewrite  need hunger or not?
					if chars_mobs_npcs[i].y/2 == math.cail(chars_mobs_npcs[i].y/2) then
						for j=1,#chars_movs_npcs do
							for k=1,6 do
								if chars_mobs_npcs[i].y == chars_mobs_npcs[j].y+directions[1].y[k] and chars_mobs_npcs[i].x == chars_mobs_npcs[j].x+directions[1].xc[k]
								and chars_mobs_npcs[i].person == chars_mobs_npcs[j].person and (chars_mobs_npcs[i].status == 1 or (chars_mobs_npcs[j].person == "char" and chars_mobs_npcs[i].status == 0))	and helpers.doNotFeelHunger(j) then -- FIXME per fraction
									damage.HPplus(j,chars_mobs_npcs[i].healaura_power);
									helpers.addHunger(j,chars_mobs_npcs[i].healaura_power);
								end;
							end;
							for l=1,12 do
								if chars_mobs_npcs[i].y == chars_mobs_npcs[j].y+directions[2].y[l] and chars_mobs_npcs[i].x == chars_mobs_npcs[j].x+directions[2].xc[l]
								and chars_mobs_npcs[i].person == chars_mobs_npcs[j].person and (chars_mobs_npcs[i].status == 1 or (chars_mobs_npcs[j].person == "char" and chars_mobs_npcs[i].status == 0)) and helpers.doNotFeelHunger(j) then
									damage.HPplus(j,chars_mobs_npcs[i].healaura_power);
									helpers.addHunger(j,chars_mobs_npcs[i].healaura_power);
								end;
							end;
							for l=1,18 do
								if chars_mobs_npcs[i].y == chars_mobs_npcs[j].y+directions[3].y[l] and chars_mobs_npcs[i].x == chars_mobs_npcs[j].x+directions[3].xc[l]
								and chars_mobs_npcs[i].person == chars_mobs_npcs[j].person and (chars_mobs_npcs[i].status == 1 or (chars_mobs_npcs[j].person == "char" and chars_mobs_npcs[i].status == 0)) and helpers.doNotFeelHunger(j) then
									damage.HPplus(j,chars_mobs_npcs[i].healaura_power);
									helpers.addHunger(j,chars_mobs_npcs[i].healaura_power);
								end;
							end;
						end;
					elseif chars_mobs_npcs[i].y/2 ~= math.cail(chars_mobs_npcs[i].y/2) then
						for j=1,#chars_mobs_npcs do
							for k=1,6 do
								if chars_mobs_npcs[i].y == chars_mobs_npcs[j].y+directions[1].y[k] and chars_mobs_npcs[i].x == chars_mobs_npcs[j].x+directions[1].xn[k]
								and chars_mobs_npcs[i].person == chars_mobs_npcs[j].person and c(chars_mobs_npcs[i].status == 1 or (chars_mobs_npcs[j].person == "char" and chars_mobs_npcs[i].status == 0)) and helpers.doNotFeelHunger(j) then
									damage.HPplus(j,chars_mobs_npcs[i].healaura_power);
									helpers.addHunger(j,chars_mobs_npcs[i].healaura_power);
								end;
							end;
							for l=1,12 do
								if chars_mobs_npcs[i].y == chars_mobs_npcs[j].y+directions[2].y[l] and chars_mobs_npcs[i].x == chars_mobs_npcs[j].x+directions[2].xn[l]
								and chars_mobs_npcs[i].person == chars_mobs_npcs[j].person and (chars_mobs_npcs[i].status == 1 or (chars_mobs_npcs[j].person == "char" and chars_mobs_npcs[i].status == 0)) and helpers.doNotFeelHunger(j) then
									damage.HPplus(j,chars_mobs_npcs[i].healaura_power);
									helpers.addHunger(j,chars_mobs_npcs[i].healaura_power);
								end;
							end;
							for l=1,18 do
								if chars_mobs_npcs[i].y == chars_mobs_npcs[j].y+directions[3].y[l] and chars_mobs_npcs[i].x == chars_mobs_npcs[j].x+directions[3].xn[l]
								and chars_mobs_npcs[i].person == chars_mobs_npcs[j].person and (chars_mobs_npcs[i].status == 1 or (chars_mobs_npcs[j].person == "char" and chars_mobs_npcs[i].status == 0)) and helpers.doNotFeelHunger(j) then
									damage.HPplus(j,chars_mobs_npcs[i].healaura_power);
									helpers.addHunger(j,chars_mobs_npcs[i].healaura_power);
								end;
							end;
						end;
					end;
				end;
				if chars_mobs_npcs[i].fireprint_dur > 0 then
					chars_mobs_npcs[i].fireprint_dur = chars_mobs_npcs[i].fireprint_dur - 1;
				end;
				if chars_mobs_npcs[i].firebelt_dur > 0 then
					boomy = chars_mobs_npcs[i].y;
					boomx = chars_mobs_npcs[i].x;
					for h=1,6 do
						if (boomy+directions[1].y[h])/2 == math.ceil((boomy+directions[1].y[h])/2) then
							elandscape[boomy+directions[1].y[h] ][boomx+directions[1].xn[h] ] = "flame";
							for j=1,#chars_mobs_npcs do
								if chars_mobs_npcs[j].y == (boomy+directions[1].y[h]) and chars_mobs_npcs[j].x == (boomx+directions[1].xn[h]) then
									dmg = damage.magicalRes (j,chars_mobs_npcs[i].firebelt_power,"fire");
									damage.HPminus(j,dmg);
									table.insert(damaged_mobs,j);
									local victim_name = helpers.mobName(j);
									helpers.addToActionLog( victim_name .. lognames.actions.gotdmg[chars_mobs_npcs[current_mob].gender]  .. dmg .. lognames.actions.metr  .. lognames.actions.ofhp .. types_of_damage.fire .. types_of_damage.dot);
								end;
								if chars_mobs_npcs[j].control == "player" then
									darkness[chars_mobs_npcs[current_mob].party][boomy+directions[1].y[j] ][boomx+directions[1].xc[j]] = 0;
								end;
							end;
						elseif (boomy+directions[1].y[h])/2 ~= math.ceil((boomy+directions[1].y[h])/2) then
							elandscape[boomy+directions[1].y[h]][boomx+directions[1].xc[h]] = "flame";
							for j=1,#chars_mobs_npcs do
								if chars_mobs_npcs[j].y == (boomx+directions[1].y[h]) and chars_mobs_npcs[j].x == (boomy+directions[1].xc[h]) then
									dmg = damage.magicalRes (j,chars_mobs_npcs[i].firebelt_power,"fire");
									damage.HPminus(j,dmg);
									table.insert(damaged_mobs,j);
									local victim_name = helpers.mobName(j);
									helpers.addToActionLog( victim_name .. lognames.actions.gotdmg[chars_mobs_npcs[current_mob].gender]  .. dmg .. lognames.actions.metr .. lognames.actions.ofhp .. types_of_damage.fire);
								end;
								if chars_mobs_npcs[i].control == "player" then
									darkness[chars_mobs_npcs[current_mob].party][boomy+directions[1].y[h] ][boomx+directions[1].xn[h] ] = 0;
								end;
							end;
							chars_mobs_npcs[i].firebelt_dur = chars_mobs_npcs[i].firebelt_dur-1;
						end;
					end;
				end;
			end;
		end;
		helpers.addToActionLog( " dot ");
		missle_type="areadots";
		for a=1,map_w do
			for b=1, map_h do
				if dlandscape_duration[a][b] > 0 then
					dlandscape_duration[a][b] = dlandscape_duration[a][b]-1; --FIX stonewall and pit
				end;
				if vlandscape_duration[a][b] > 0 then
					vlandscape_duration[a][b] = vlandscape_duration[a][b]-1;
				end;
				if alandscape_duration[a][b] > 0 then
					alandscape_duration[a][b] = alandscape_duration[a][b]-1;
				end;
				if dlandscape_duration[a][b] == 0 then
					if dlandscape_obj[a][b] == "fire" then
						boomareas.ashGround (b,a);
						helpers.clearLights (b,a);
					end;
					dlandscape_obj[a][b] = 0;
					dlandscape_power[a][b] = 0;
				end;

				if alandscape_duration[a][b] == 0 then
					if alandscape_obj[a][b] == "poison" then
						helpers.clearLights (b,a);
					end;
					alandscape_obj[a][b] = 0;
					alandscape_power[a][b] = 0;
				end;
				if mlandscape_duration[a][b] > 0 then
					mlandscape_duration[a][b] = mlandscape_duration[a][b]-1;
				end;
				if (mlandscape_obj[a][b] == "mine"  and mlandscape_duration[a][b] == 0) or (mlandscape_obj[a][b] == "mine" and dlandscape_obj[a][b] == "fire") then
					mlandscape_obj[a][b] = 0;
					boomx = b;
					boomy = a;
					trapped = 1;
					missle_type = "fireball";
					game_status = "boom";
					dmg=mlandscape_power[a][b];
					mlandscape_power[a][b] = 0;
					draw.boom();
				end;
				if vlandscape_obj[a][b] == 1  and vlandscape_duration[a][b] == 0 then
					local id = vlandscape_id[a][b];
					vlandscape_obj[a][b] = 0;
					for aa=1,map_w do
						for bb=1, map_h do
							if vlandscape_id[aa][bb] == id then
								vlandscape_id[aa][bb] = 0;
							end;
						end;
					end;
				end;
			end;
		end;
		global.timer200 = 0;
	end;
	
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].rt < 200 and chars_mobs_npcs[i].status == 1 and  chars_mobs_npcs[i].freeze == 0 and chars_mobs_npcs[i].stone == 0 and chars_mobs_npcs[i].slow_dur == 0 then
			chars_mobs_npcs[i].rt = chars_mobs_npcs[i].rt+1;
		end;
		if chars_mobs_npcs[i].rt < 200 and chars_mobs_npcs[i].status == 1 and  chars_mobs_npcs[i].freeze==0 and chars_mobs_npcs[i].stone==0 and chars_mobs_npcs[i].haste > 0 and chars_mobs_npcs[i].slow_dur == 0 then
			chars_mobs_npcs[i].rt = chars_mobs_npcs[i].rt+1;
		end;
		if chars_mobs_npcs[i].rt < 200 and chars_mobs_npcs[i].status == 1 and  chars_mobs_npcs[i].freeze==0 and chars_mobs_npcs[i].stone==0 and chars_mobs_npcs[i].haste > 0 and chars_mobs_npcs[i].slow_dur > 0 and chars_mobs_npcs[i].haste > 0 then
			chars_mobs_npcs[i].rt = chars_mobs_npcs[i].rt+1;
		end;
		if chars_mobs_npcs[i].rt < 200 and chars_mobs_npcs[i].status == 1 and  chars_mobs_npcs[i].freeze==0 and chars_mobs_npcs[i].stone==0 and chars_mobs_npcs[i].haste > 0 and chars_mobs_npcs[i].slow_dur > 0 and chars_mobs_npcs[i].haste == 0 then
			if global.timer200/2 == math.ceil(global.timer200/2) then
				chars_mobs_npcs[i].rt = chars_mobs_npcs[i].rt+1;
			end;
		end;
		if chars_mobs_npcs[i].status > 0 and chars_mobs_npcs[i].st < chars_mobs_npcs[i].st_max and chars_mobs_npcs[i].pneumothorax == 0 and chars_mobs_npcs[i].disease == 0 and chars_mobs_npcs[i].freeze == 0 and chars_mobs_npcs[i].stone == 0 and helpers.doNotFeelHunger(i) then
			chars_mobs_npcs[i].st = chars_mobs_npcs[i].st+1;
			damage.STplus(i,1,false);
			helpers.addHunger(i,1);
		end;
		if chars_mobs_npcs[i].rt >= 200 and damage.mobIsActive(chars_mobs_npcs[current_mob]) then
			chars_mobs_npcs[i].rt = 200;
			current_mob = i;
			if chars_mobs_npcs[i].person == "char" then -- mental effects
				if chars_mobs_npcs[i].panic == 0 and chars_mobs_npcs[i].charm == 0 and chars_mobs_npcs[i].berserk == 0 and chars_mobs_npcs[i].enslave == 0 then
					chars_mobs_npcs[i].control="player";
				elseif chars_mobs_npcs[i].panic>0 then
					chars_mobs_npcs[i].ai="away";
					chars_mobs_npcs[i].control="ai;"
				elseif chars_mobs_npcs[i].charm>0 then
					chars_mobs_npcs[i].ai="rnd";
					chars_mobs_npcs[i].control="ai";
				elseif chars_mobs_npcs[i].berserk>0 then
					chars_mobs_npcs[i].ai="berserk";
					chars_mobs_npcs[i].control="ai";
				elseif chars_mobs_npcs[i].enslave>0 then
					chars_mobs_npcs[i].ai="agr";
					chars_mobs_npcs[i].battleai="melee";
					chars_mobs_npcs[i].control="ai";
				end;
			elseif chars_mobs_npcs[i].person == "mob" then
				tmpclass="mobs_stats." .. chars_mobs_npcs[i].class;
				tmpclass2=loadstring("return " .. tmpclass)();
				if chars_mobs_npcs[i].panic == 0 and chars_mobs_npcs[i].charm == 0 and chars_mobs_npcs[i].berserk == 0 and chars_mobs_npcs[i].enslave == 0 then
					chars_mobs_npcs[i].ai=chars_mobs_npcs[i].defaultai;
					chars_mobs_npcs[i].battleai=tmpclass2.battleai;
					chars_mobs_npcs[i].control="ai";
				elseif chars_mobs_npcs[i].panic>0 then
					chars_mobs_npcs[i].ai="away";
					chars_mobs_npcs[i].control="ai";
				elseif chars_mobs_npcs[i].charm>0 then
					chars_mobs_npcs[i].ai="rnd";
					chars_mobs_npcs[i].control="ai";
				elseif chars_mobs_npcs[i].berserk>0 then
					chars_mobs_npcs[i].ai="berserk";
					chars_mobs_npcs[i].control="ai";
				elseif chars_mobs_npcs[i].enslave>0 then
					chars_mobs_npcs[i].ai="player";
					chars_mobs_npcs[i].control="player";
				end;
			end;
			chars_mobs_npcs[i].protectionmode = "none";
			game_status = "neutral";
			ignore_kb = 0;
			if not global.lookaround then
				--trace.lookaround(i); --FIXME slowdown?
			end;
			if global.status == "peace" and ai.enemyWatchesYou () then
				letaBattleBegin (); --FIXME need or not?
			end;
			if chars_mobs_npcs[i].ai ~= "building" then
				local moral = helpers.countMoral(i);
				if moral < -1*chars_mobs_npcs[i].base_moral and chars_mobs_npcs[i].panic == 0 then
					local demoralEffect = math.random(1,6);
					if demoralEffect == 1 then -- panic
						chars_mobs_npcs[i].control = "ai";
						chars_mobs_npcs[i].panic = 3+math.abs(moral);
						helpers.addToActionLog(helpers.mobName(i) .. " " .. lognames.actions.panic[chars_mobs_npcs[i].gender]);
					elseif demoralEffect == 2 and chars_mobs_npcs[i].fear == 0 then --  dumbfounded (petrified)
						chars_mobs_npcs[i].rt = chars_mobs_npcs[i].rt + 100;
						chars_mobs_npcs[i].control = "ai";
						chars_mobs_npcs[i].ai = "stay";
						helpers.addToActionLog(helpers.mobName(i) .. " " .. lognames.actions.dumbfounded[chars_mobs_npcs[i].gender]);
					elseif demoralEffect == 3 and chars_mobs_npcs[i].fear == 0 then --fear
						chars_mobs_npcs[i].fear = 3+math.abs(moral);
						helpers.addToActionLog(helpers.mobName(i) .. " " .. lognames.actions.feared[chars_mobs_npcs[i].gender]);
					end;
				elseif moral > chars_mobs_npcs[i].base_moral*2 then
					local roll = math.random(1,2);
					if roll == 1 then
						chars_mobs_npcs[i].fear = 0;
						chars_mobs_npcs[i].panic = 0;
						chars_mobs_npcs[i].charm = 0;
						helpers.addToActionLog(helpers.mobName(i) .. " " .. lognames.actions.cheeresup[chars_mobs_npcs[i].gender]);
					end;
				end;
			end;
			helpers.recalcBattleStats (i);
			helpers.battleorder();
			global.lookaround = true;
			global.rem_cursor_world_x = chars_mobs_npcs[i].x;
			global.rem_cursor_world_y = chars_mobs_npcs[i].y;
			break;
		end;
	end;
end;

function mob_plus()
	utils.printDebug("mob_plus called");
	clear_elandscape ();
	game_status = "neutral";
	missle_type = "none";
	if chars_mobs_npcs[current_mob]["equipment"].ammo > 0 then
		missle_type = inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ammo].ttxid].subclass;
	end;
	if chars_mobs_npcs[current_mob]["equipment"].ranged > 0 and inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].ttxid].class == "wand" then
		if chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].q > 0 then
			missle_drive="wand";
			missle_type = chars_mobs_npcs[current_mob]["inventory_list"][chars_mobs_npcs[current_mob]["equipment"].ranged].w;
		else
			missle_drive="muscles";
			missle_type="none";
		end;
	end;
	walked_before = 0;
	drink_smth = 0;
	oil_smth = 0;
	bomb_smth = 0;
	if global.status == "peace" then
		current_mob = current_mob + 1;
		if current_mob > #chars_mobs_npcs then
			current_mob = 1;
		end;
		while not damage.mobIsActive(chars_mobs_npcs[current_mob]) do
			current_mob = current_mob + 1;
			if current_mob > #chars_mobs_npcs then
				current_mob = 1;
			end;
		end;
	end;
	trace.lookaround (current_mob);
	if chars_mobs_npcs[current_mob].control == "ai" then
		ai.behavior();
	end;
end;

function atk_dir_to_hex ()
	atk_direction = helpers.attackDirection (current_mob,victim);
	if chars_mobs_npcs[mob_under_cursor].y/2 == math.ceil(chars_mobs_npcs[mob_under_cursor].y/2) then
		add_x = directions[1].xc[atk_direction];
		add_y = directions[1].y[atk_direction];
	elseif chars_mobs_npcs[mob_under_cursor].y/2 ~= math.ceil(chars_mobs_npcs[mob_under_cursor].y/2) then
		add_x = directions[1].xn[atk_direction];
		add_y = directions[1].y[atk_direction];
	end;
	if chars_mobs_npcs[current_mob].control == "player" then
		point_to_go_x = cursor_world_x+add_x;
		point_to_go_y = cursor_world_y+add_y;
	elseif chars_mobs_npcs[current_mob].control == "ai" then
		point_to_go_x = ai_world_x+add_x;
		point_to_go_y = ai_world_y+add_y;
	end;
	helpers.isAimOnMob (point_to_go_x,point_to_go_y);
end;

function attack_direction ()
	if chars_mobs_npcs[mob_under_cursor].x>chars_mobs_npcs[current_mob].x and chars_mobs_npcs[mob_under_cursor].y>chars_mobs_npcs[current_mob].y then
		atk_direction=6;
	end;
	if chars_mobs_npcs[mob_under_cursor].x<chars_mobs_npcs[current_mob].x and chars_mobs_npcs[mob_under_cursor].y<chars_mobs_npcs[current_mob].y then
		atk_direction=3;
	end;
	if chars_mobs_npcs[mob_under_cursor].x<chars_mobs_npcs[current_mob].x and chars_mobs_npcs[mob_under_cursor].y>chars_mobs_npcs[current_mob].y then
		atk_direction=1;
	end;
	if chars_mobs_npcs[mob_under_cursor].x>chars_mobs_npcs[current_mob].x and chars_mobs_npcs[mob_under_cursor].y<chars_mobs_npcs[current_mob].y then
		atk_direction=4;
	end;
	if chars_mobs_npcs[mob_under_cursor].x>chars_mobs_npcs[current_mob].x and chars_mobs_npcs[mob_under_cursor].y== chars_mobs_npcs[current_mob].y then
		atk_direction=5;
	end;
	if chars_mobs_npcs[mob_under_cursor].x<chars_mobs_npcs[current_mob].x and chars_mobs_npcs[mob_under_cursor].y== chars_mobs_npcs[current_mob].y then
		atk_direction=2;
	end;
	if chars_mobs_npcs[mob_under_cursor].x== chars_mobs_npcs[current_mob].x and chars_mobs_npcs[mob_under_cursor].y>chars_mobs_npcs[current_mob].y and chars_mobs_npcs[mob_under_cursor].y/2==math.ceil(chars_mobs_npcs[mob_under_cursor].y/2) then
		atk_direction=1;
	end;
	if chars_mobs_npcs[mob_under_cursor].x== chars_mobs_npcs[current_mob].x and chars_mobs_npcs[mob_under_cursor].y<chars_mobs_npcs[current_mob].y and chars_mobs_npcs[mob_under_cursor].y/2==math.ceil(chars_mobs_npcs[mob_under_cursor].y/2) then
		atk_direction=4;
	end;
	if chars_mobs_npcs[mob_under_cursor].x== chars_mobs_npcs[current_mob].x and chars_mobs_npcs[mob_under_cursor].y>chars_mobs_npcs[current_mob].y and chars_mobs_npcs[mob_under_cursor].y/2~=math.ceil(chars_mobs_npcs[mob_under_cursor].y/2) then
		atk_direction=6;
	end;
	if chars_mobs_npcs[mob_under_cursor].x== chars_mobs_npcs[current_mob].x and chars_mobs_npcs[mob_under_cursor].y<chars_mobs_npcs[current_mob].y and chars_mobs_npcs[mob_under_cursor].y/2~=math.ceil(chars_mobs_npcs[mob_under_cursor].y/2) then
		atk_direction=3;
	end;
end;

function charstats_call()
	game_status = "stats";
	utils.playSfx(media.sounds.bookopen, 1);
end;

function charskills_call(index)
	helpers.countSkills (index);
	game_status = "skills";
	utils.playSfx(media.sounds.bookopen, 1);
	draw.applyButton ();
end;

function find_raw()
	raws = {};
	for i = 1,#inventory_ttx do
		if inventory_ttx[i].subclass == "gom" and inventory_ttx[i].b == "r" then
			raws.r = i;
		end;
		if inventory_ttx[i].subclass == "gom" and inventory_ttx[i].b == "b" then
			raws.b = i;
		end
		if inventory_ttx[i].subclass == "gom" and inventory_ttx[i].b == "y" then
			raws.y = i;
		end
		if inventory_ttx[i].subclass == "gom" and inventory_ttx[i].b == "w" then
			raws.w = i;
		end
		if inventory_ttx[i].subclass == "gom" and inventory_ttx[i].b == "k" then
			raws.k = i;
		end
		if inventory_ttx[i].class == "bottle" then
			raws.tare = i;
		end
		if inventory_ttx[i].subclass == "catalizator" then
			raws.cat = i;
		end
		--if inventory_ttx[i].subclass == "bubuz" then
			--raws.buz = i;
		--end;
	end;
	raws.buz = 329;
end;

function spellbook_call()
	game_status = "spellbook";
	utils.playSfx(media.sounds.bookopen, 1);
end

function questbook_call()
	game_status = "questbook";
	utils.playSfx(media.sounds.bookopen, 1);
end

function warbook_call()
	game_status = "warbook";
	utils.playSfx(media.sounds.bookopen, 1);
end

function inventory_bag_call ()
	closeAllBags ();
	inv_page=1;
	utils.playSfx(media.sounds.invopen,1);
	bagid = helpers.whatBag (current_mob);
	if bagid then
		th=bagid;
		sorttarget="bag";
		oldsorttarget="bag";
		for i=1,15 do
			for j=1,11 do
				bags[bagid][i][j]=0;
			end;
		end;
		helpers.repackBag()
		if bags_list[bagid].typ == "scullpile" then
			helpers.inspectScullpile ();
		elseif bags_list[bagid].typ == "trashheap" then
			helpers.inspectTrashHeap ();
		elseif bags_list[bagid].typ == "crystals" then
			helpers.inspectCrystals ();
		end;
	end;
end;

function closeAllBags ()
	for j=1, #bags_list do
		bags_list[j].opened = false;
	end;
end;

function from_bag_to_equip()
	local bag_found = false;
	for j=1, #bags_list do
	  if chars_mobs_npcs[current_mob].x==bags_list[j].x and chars_mobs_npcs[current_mob].y==bags_list[j].y and not bag_found then
		  bagid=j;
		  bag_found = true;
	  end;
	end;
	table.insert(chars_mobs_npcs[current_mob]["inventory_list"], {ttxid=bags_list[bagid][holding_smth].ttxid, q=bags_list[bagid][holding_smth].q,w=bags_list[bagid][holding_smth].w,e=bags_list[bagid][holding_smth].e,r=bags_list[bagid][holding_smth].r,h=bags_list[bagid][holding_smth].h});
	helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.taken[chars_mobs_npcs[current_mob].gender] .. inventory_ttx[bags_list[bagid][holding_smth].ttxid].title .. helpers.takenFromWhere(bags_list[bagid].typ));
	bags[bagid][bags_list[bagid].x][bags_list[bagid].y]=0;
	table.remove(bags_list[bagid],holding_smth);
	for i=1,11 do
		for h=1,15 do
			if bags[bagid][h][i]>holding_smth and bags[bagid][h][i]>0 and bags[bagid][h][i]<10000 then
				bags[bagid][h][i]=bags[bagid][h][i]-1;
			end;
		end;
	end;
	if #bags_list[bagid] == 0 then
		table.remove(bags_list,bagid);
		table.remove(bags,bagid);
		bagremoved=1;
	end;
end;

function find_nonfree_space_at_inv ()
	local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false);
	fullness = 0;
	for a=1,11 do
		for b=1,15 do
			if tmp_bagid>0 and bagremoved==0 and bag[tmp_bagid][b][a]>=10000 then
				bag[tmp_bagid][b][a]=0;
			end;
		end;
	end;
	for i=1,11 do
		for h=1,15 do
			if tmp_bagid>0 and bagremoved==0 and bag[tmp_bagid][h][i]~=0 and  bag[tmp_bagid][h][i]<10000 then
				local tmp1=bag[tmp_bagid][h][i];
				local tmp2=list[tmp1].ttxid;
				for a=1,11 do
					for b=1,15 do
						if a < i+inventory_ttx[tmp2].w and a >= i and b<h+inventory_ttx[tmp2].h and b >= h and  bag[tmp_bagid][b][a] == 0 then
							bag[tmp_bagid][b][a] = i*10000+h;
						end;
					end;
				end;
			end;
			if tmp_bagid > 0 and bagremoved == 0 and  bag[tmp_bagid][h][i] > 0 then
				fullness = fullness+1;
			end;
		end;
	end;
	bagremoved = 0;
end;

function playingState.draw()
	--currentState.draw();
	lightWorld.update();
	
	   -- set your canvas
  -- love.graphics.setCanvas(myCanvas) --REF
	
	love.graphics.setFont(mainFont);
	draw.background();
	draw.submap();
	draw.map();
	--draw.numbers();
	if chars_mobs_npcs[current_mob].control=="player" then --FIXME
		if (cursor_world_x == chars_mobs_npcs[current_mob].x and cursor_world_y == chars_mobs_npcs[current_mob].y) == false and game_status == "pathfinding" and path_status==1 then
			draw.way();
		end;
	end;
	draw.fogOfWar();
	draw.cursor();
	draw.line();
	draw.objects();
	--for i=1,#shadows do
		--local x,y =  helpers.hexToPixels(shadows[i].x,shadows[i].y);
		--love.graphics.circle("fill", x, y, 20);
	--end;

	lightWorld.drawShadow();
	lightWorld.drawGlow();
	 --REF
	  -- draw the reflection
   --lightWorld.drawReflection()

   -- draw the refraction
   --lightWorld.drawRefraction()

	
	
	if global.weather == "rain" then
		draw.rain (100,10,10,255,255,255,150);
	end;
	if global.draw_temphud == 1 then --FIXME
		love.graphics.draw(media.images.hud, 0,0);
	end;

	if global.draw_interface == 1 then
		draw.ui();
	end;

	love.graphics.setColor(0, 0, 0);
	love.graphics.setFont(mainFont);
	love.graphics.setColor(255, 255, 255);
    if keyJustBroken > 0 then
		keyJustBroken = keyJustBroken - 1;
		--love.graphics.draw(psPicklockBroken[1].ps, 480, 400);
    end;
    if picklockJustBroken > 0 then
		picklockJustBroken = picklockJustBroken - 1;
		--love.graphics.draw(psPicklockBroken[1].ps, 550, 400);
    end;

	sometable = {

	global.screenWidth/2 - 100 ,350,
	global.screenWidth/2 + 100,350,
	global.screenWidth/2 + 100,400,
	global.screenWidth/2 -100 ,400,
	global.screenWidth/2 - 100,350,
	}

	--love.graphics.line(sometable)


	 sometable = {

	global.screenWidth/2 - 100 ,450,
	global.screenWidth/2 + 100,450,
	global.screenWidth/2 + 100,500,
	global.screenWidth/2 -100 ,500,
	global.screenWidth/2 - 100,450,
	}

	--love.graphics.line(sometable)


	sometable = {

	global.screenWidth/2 - 285 ,250,
	global.screenWidth/2 + 295,250,
	global.screenWidth/2 + 295,475,
	global.screenWidth/2 -285 ,475,
	global.screenWidth/2 - 285,250,
	}

	--love.graphics.line(sometable)
	loveframes.draw();

	local x,y = helpers.centerObject(media.images.inv1);
	
	   -- draw Canvas --REF
   --love.graphics.setCanvas()
   --love.graphics.draw(myCanvas)

 end;

return playingState
