mindgame = {};

mindgame.attempts = {3,4,5,6,7};

mindgame.dest_coords = {{7,1,"loyality"},{8,3,"disdain"},{9,5,"boring"},{8,7,"fear"},{7,9,"distrust"},{3,9,"sad"},{2,7,"respect"},{1,5,"surprise"},{2,3,"agression"},{3,1,"glad"},{5,9,"pity"},{5,1,"shame"}};

mindgame.map = {};

mindgame.counter={loyality,fear,ignorance,disdain,agression,distrust,cry,surprise,respect,gladness, pity, shame};
mindgame.snd_array = {"loyality","fear","boring","disdain","agression","distrust","cry","surprized","respect","lol","pity","shame","indifferent"};

function mindgame.updateFlags()
	local etiquette = chars_mobs_npcs[victim]["personality"]["current"].etiquette
	local rnd_chr_1 = math.ceil(math.random(1,chars_mobs_npcs[current_mob].chr/20));
	local rnd_chr_2 = math.ceil(math.random(3,chars_mobs_npcs[current_mob].chr/20*1.5));
	local rnd_chr_3 = math.ceil(math.random(5,chars_mobs_npcs[current_mob].chr/20*2));
	local rnd_chr_4 = math.ceil(math.random(1,10));
	local rnd_chr_5 = math.ceil(math.random(3,15));
	local rnd_chr_6 = math.ceil(math.random(5,20));
	local rnd_achr_1 =   math.ceil(math.random(1,math.max(1,10-chars_mobs_npcs[current_mob].chr/10)));
	mindgame.flags_gold = {
	beggar         = {{{1,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{2,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{0,1,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,2,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,3,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,4,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,5,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,5,-1,0,0,0,100,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)}},
	poor           = {{{0,-1,1,0,0,0,0,0,0,0,0,0},true,"boring",chats.questionPerEtiquette("boring",etiquette)},{{1,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{2,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{0,1,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,2,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,3,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,4,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,5,-1,0,0,0,1000,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)}},
	middleclass    = {{{0,-1,0,1,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("goldnotenough",etiquette)},{{0,-1,1,0,0,0,0,0,0,0,0,0},true,"boring",chats.questionPerEtiquette("boring",etiquette)},{{1,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{2,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{0,1,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,2,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,3,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,5,-1,0,0,0,10000,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)}},
	prosperous     = {{{0,-1,-1,0,1,0,0,0,0,0,0,0},false,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-1,0,1,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("goldnotenough",etiquette)},{{0,-1,1,0,0,0,0,0,0,0,0,0},true,"boring",chats.questionPerEtiquette("boring",etiquette)},{{1,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{2,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{2,1,0},true},{{0,1,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,5,-1,0,0,0,100000,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)}},
	rich           = {{{0,-1,-1,0,1,0,0,0,0,0,0,0},false,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-1,0,3,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("goldnotenough",etiquette)},{{0,-1,0,1,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("goldnotenough",etiquette)},{{0,-1,1,0,0,0,0,0,0,0,0,0},true,"boring",chats.questionPerEtiquette("boring",etiquette)},{{1,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{2,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{0,1,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)},{{0,3,-1,0,0,0,1000000,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)}};
	superrich      = {{{0,-1,-1,0,3,0,0,0,0,0,0,0},false,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-1,-1,0,1,0,0,0,0,0,0,0},false,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-1,0,3,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("goldnotenough",etiquette)},{{0,-1,0,1,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("goldnotenough",etiquette)},{{0,-1,1,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("boring",etiquette)},{{1,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{2,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{0,1,-1,0,0,0,10000000,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)}},
	fantasticrich  = {{{0,-1,-1,0,5,0,0,0,0,0,0,0},false,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-1,-1,0,3,0,0,0,0,0,0,0},false,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-1,-1,0,1,0,0,0,0,0,0,0},false,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-1,0,3,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("goldnotenough",etiquette)},{{0,-1,0,1,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("goldnotenough",etiquette)},{{0,-1,1,0,0,0,0,0,0,0,0,0},true,"boring",chats.questionPerEtiquette("boring",etiquette)},{{1,-1,-1,0,0,0,0,0,0,0,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{0,1,-1,0,0,0,100000000,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("goldtoomuch",etiquette)}},
	greedy         = {{{1,-1,-1,0,0,0,0,0,1,0,0},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{2,-1,-1,0,0,0,0,0,0,2},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{3,-1,-1,0,0,0,0,0,0,3},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{4,-1,-1,0,0,0,0,0,0,4},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{5,-1,-1,0,0,0,0,0,0,5},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{10,-1,0,0,0,0,0,0,0,10},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{25,-1,0,0,0,0,0,0,0,25},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)},{{50,50,-1,0,0,0,0,0,0,0,50},true,"loyality",chats.questionPerEtiquette("goldok",etiquette)}},
	donationstaker = {{{0,-1,0,0,0,1,0,0,0,0,0,0},true,"donation",chats.questionPerEtiquette("donation",etiquette)},{{0,-1,0,0,0,1,0,0,0,0,0,0},true,"donation",chats.questionPerEtiquette("donation",etiquette)},{{0,-1,0,0,0,1,0,0,0,0,0,0},true,"donation",chats.questionPerEtiquette("donation",etiquette)},{{0,-1,0,0,0,1,0,0,0,0,0,0},true,"donation",chats.questionPerEtiquette("donation",etiquette)},{{0,-1,0,0,0,0,0,0,0,0,0,0},true,"donation",chats.questionPerEtiquette("donation",etiquette)},{{0,-1,0,0,0,1,0,0,0,0,0,0},true,"donation",chats.questionPerEtiquette("donation",etiquette)},{{0,-1,0,0,0,1,0,0,0,0,0,0},true,"donation"},{{0,5,-1,0,0,0,1000000,0,0,0,0,0,0},true,"donation",chats.questionPerEtiquette("donation",etiquette)}},
	incorruptable  = {{{0,-1,1,1,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("boring",etiquette)},{{0,-1,0,1,0,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("goldincor",etiquette)},{{0,-1,0,0,0,1,0,0,0,0,0,0},false,"distrust",chats.questionPerEtiquette("iwilltraityou",etiquette)},{{0,-1,0,0,0,2,0,0,0,0,0,0},false,"distrust",chats.questionPerEtiquette("iwilltraityou",etiquette)},{{0,-1,0,0,0,3,0,0,0,0,0,0},false,"distrust",chats.questionPerEtiquette("iwilltraityou",etiquette)},{{0,-1,0,0,0,4,0,0,0,0,0,0},false,"distrust"},{{0,-1,0,0,0,5,0,0,0,0,0,0},false,"distrust"},{{0,5,-1,0,0,0,1000000,0,0,0,0,0,0},true,"distrust",chats.questionPerEtiquette("iwilltraityou",etiquette)}},
	disinterested  = {{{0,-1,1,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("boring",etiquette)},{{0,-1,1,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("boring",etiquette)},{{0,-1,1,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("boring",etiquette)},{{0,-1,1,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("boring",etiquette)},{{0,-1,1,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("boring",etiquette)},{{0,-1,1,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("boring",etiquette)},{{0,-1,0,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("boring",etiquette)},{{0,1,0,0,0,0,1000000,0,0,0,0,0,0},true,"boring",chats.questionPerEtiquette("boring",etiquette)}},
	goldhater      = {{{0,-1,-1,0,0,0,0,0,0,0,0,0},true,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-2,-2,0,2,0,0,0,0,0,0,0},true,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-3,3,0,3,0,0,0,0,0,0,0},true,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-4,-4,0,4,0,0,0,0,0,0,0},true,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-5,-5,0,5,0,0,0,0,0,0,0},true,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-6,-6,0,10,0,0,0,0,0,0,0},true,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-7,-7,0,7,0,0,0,0,0,0,0},true,"agression",chats.questionPerEtiquette("goldagro",etiquette)},{{0,-10,-10,0,10,0,1000000,0,0,0,0,0,0},true,"agression",chats.questionPerEtiquette("goldagro",etiquette)}},
	};
	--FIXME
	mindgame.flags_threat = {
	fatalist       = {{0,0,1,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("busido",etiquette)},
	masohist       = {{1,0,-1,0,0,0,0,0,1,0,0},false,"lol",chats.questionPerEtiquette("masohist",etiquette)},
	normal         = {{0,1,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("wtfurdoing",etiquette)},
	coward         = {{0,2,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("dontpainme",etiquette)},
	scaremonger    = {{0,3,-1,0,0,0,0,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("panic",etiquette)},
	crybaby        = {{0,0,-1,0,0,0,1,0,0,0,0,0},true,"fear",chats.questionPerEtiquette("cry",etiquette)},
	brave          = {{0,0,0,1,0,0,0,0,0,0,0,0},true,"disdain",chats.questionPerEtiquette("brave",etiquette)},
	honored        = {{0,0,0,3,0,0,0,0,0,0,0,0},true,"disdain",chats.questionPerEtiquette("brave",etiquette)},
	agressive      = {{0,0,0,0,1,0,0,0,0,0,0,0},true,"agression",chats.questionPerEtiquette("berserk",etiquette)},
	};
	local rnd = math.random(1,13);
	local snd_index = rnd;
	local snd = mindgame.snd_array[snd_index];

	mindgame.flags_default = {
	indifferent   = {7,0,"indifferent"}, -- nothing happens
	loyal         = {1,1,"loyality"},
	frighten      = {2,1,"fear"},
	boring        = {3,1,"boring"},
	arrogant      = {4,1,"disdain"},
	evil          = {5,1,"agression"},
	responsible   = {6,1,"distrust"},
	sad           = {7,1,"cry"},
	respectful    = {8,1,"respect"},
	credulous	  = {9,1,"surprized"},
	happy		  = {10,1,"lol"},
	pitful	      = {11,1,"pitful"},
	shy		  	  = {12,1,"shame"},
	unloyal       = {1,-1,"boring"},
	brave         = {2,-1,"boring"},
	lively        = {3,-1,"boring"},
	modest        = {4,-1,"boring"},
	kind          = {5,-1,"boring"},
	irresponsible = {6,-1,"boring"},
	restoring     = {7,-1,"boring"},
	rude	      = {8,-1,"boring"},
	sceptic		  = {9,-1,"boring"},
	unhappy       = {10,-1,"boring"},
	pitiless      = {12,-1,"boring"},
	shameless     = {12,-1,"boring"},
	chaotic       = {rnd,1,snd},
	};

	mindgame.flags_drinks = {
	
	drinker     = {{1,0,0,0,0,0,0,0,0,0,0,0},false,"loyality",chats.questionPerEtiquette("uknowwhattopresent",etiquette)},
	boozer      = {{0,0,0,0,0,0,0,0,1,0,0,0},false,"respect",chats.questionPerEtiquette("reallygoodone",etiquette)},
	drunkard 	= {{0,0,0,0,0,0,0,0,0,1,0,0},false,"lol",chats.questionPerEtiquette("iwanttodrink",etiquette)},
	teetotaller = {{0,0,1,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("donotdrink",etiquette)},
	abstainer   = {{0,1,0,0,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("bueh",etiquette)},
	agressive   = {{0,0,0,0,0,0,0,0,1,0,0,0},false,"agression",chats.questionPerEtiquette("hatealcohol",etiquette)},
	ulcer       = {{0,0,0,0,0,1,0,0,0,0,0,0},false,"cry",chats.questionPerEtiquette("cruelbastard",etiquette)},
	anonymous	= {{0,0,0,0,0,0,0,0,0,0,0,1},false,"shame",chats.questionPerEtiquette("andimalcholoic",etiquette)},
	taster		= {{1,0,0,0,0,0,0,0,0,0,0,0},false,"loyality",chats.questionPerEtiquette("winenotbad",etiquette)},
	taster2		= {{0,1,0,0,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("disgustingwine",etiquette)},
	winepoisoned	= {{0,0,0,0,1,0,0,0,0,0,0,0},false,"distrust",chats.questionPerEtiquette("winepoisoned",etiquette)},
	};
	
	mindgame.flags_food = { --FIXME need phrases for food
	
	hungry     	 = {{1,0,0,0,0,0,0,0,0,0,0,0},false,"loyality",chats.questionPerEtiquette("foodisgood",etiquette)},
	starving    = {{0,0,0,0,0,0,0,0,1,0,0,0},false,"respect",chats.questionPerEtiquette("iamstarving",etiquette)},
	glutton 	= {{0,0,0,0,0,0,0,0,0,1,0,0},false,"lol",chats.questionPerEtiquette("iamglutton",etiquette)},
	full        = {{0,0,1,0,0,0,0,0,0,0,0,0},false,"boring",chats.questionPerEtiquette("fulloffood",etiquette)},
	overfed     = {{0,1,0,0,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("overfed",etiquette)},
	agressive   = {{0,0,0,0,0,0,0,0,1,0,0,0},false,"agression",chats.questionPerEtiquette("donotneedeat",etiquette)},
	diabetic    = {{0,0,0,0,0,1,0,0,0,0,0,0},false,"cry",chats.questionPerEtiquette("diet",etiquette)},
	fat	        = {{0,0,0,0,0,0,0,0,0,0,0,1},false,"shame",chats.questionPerEtiquette("iamfat",etiquette)},
	taster3		= {{1,0,0,0,0,0,0,0,0,0,0,0},false,"loyality",chats.questionPerEtiquette("delicios",etiquette)},
	taster4		= {{0,1,0,0,0,0,0,0,0,0,0,0},false,"disdain",chats.questionPerEtiquette("disgustingfood",etiquette)},
	foodpoisoned	= {{0,0,0,0,1,0,0,0,0,0,0,0},false,"distrust",chats.questionPerEtiquette("foodpoisoned",etiquette)},
	};
	
	mindgame.flags_informed = {
	};
	
	mindgame.flags_chantage = {
	};
	
	mindgame.flags_humor = {
	};
end;

function mindgame.destination ()
	local x = 0;
	local y = 0;
	local maxcounter = 0;
	local array = {};
	for i=1,10 do
		if chars_mobs_npcs[victim]["personality"]["current"].mindstatus[i] > maxcounter and chars_mobs_npcs[victim]["personality"]["current"].mindstatus[i] >= 0 then
			maxcounter = chars_mobs_npcs[victim]["personality"]["current"].mindstatus[i]; --FIXME blocked before, zero blocks if path finding fails, all 6 blocked situation
		end;
	end;
	for i=1,10 do
		if chars_mobs_npcs[victim]["personality"]["current"].mindstatus[i] >= 0 and chars_mobs_npcs[victim]["personality"]["current"].mindstatus[i] == maxcounter and maxcounter >= 0 then
			table.insert(array,i);
		end;
	end;
	local destination = array[math.random(1,#array)];
	x = mindgame.dest_coords[destination][1];
	y = mindgame.dest_coords[destination][2];
	n = destination;
	return x,y,n;
end;

function mindgame.path ()
	local checked_path = {};
	local checked_path2 = {};
	local point_to_go_x,point_to_go_y,destination = mindgame.destination ();
	if not point_to_go_x or not point_to_go_y or not destination then
		game_status = "neutral"; --FAIL BERSERK MADNESS FLAG BRAINFUCKER for a party member
		print("MINDGAME FAILED_");
		party.gold = party.gold - global.mindgold; --?
		global.mindgold = 0;
		loveframes.util.RemoveAll();
		return;
	end;
	local mindpath_status = 0;
	local hex_to_check_next_wave = {};
	local modepf = math.random(1,2)*2-3;
	local mind_way = {};
	table.insert(checked_path2,{global.mindhero_x,global.mindhero_y,1,1,0,0,0});
	table.insert(hex_to_check_next_wave,1,{global.mindhero_x, global.mindhero_y,1,0}) -- 0,0 current coordinates
	local wave = 1;
--making waves
	local new_wave = 0;
	while (new_wave <= 81 and mindpath_status == 0 and #hex_to_check_next_wave > 0) do
		new_ppoint_x = hex_to_check_next_wave[1][1];
		new_ppoint_y = hex_to_check_next_wave[1][2];
		new_index = hex_to_check_next_wave[1][3];
		table.remove(hex_to_check_next_wave,1);
		for p=1,6 do
			if new_ppoint_x > 0 and new_ppoint_x <= 9 and new_ppoint_y > 0 and new_ppoint_y <= 9 then
				ppoint_y = new_ppoint_y+directions[1].y[p];
				if modepf == 1 then
					if new_ppoint_x > global.mindhero_x then
						if ppoint_y/2 == math.ceil(ppoint_y/2) then
							ppoint_x = new_ppoint_x+directions[1].xn[p];
						else
							ppoint_x = new_ppoint_x+directions[1].xc[p]; 
						end;
					elseif new_ppoint_x<=global.mindhero_x then
						if ppoint_y/2 == math.ceil(ppoint_y/2) then
							ppoint_x = new_ppoint_x+directions[1].xnr[p];
						else
							ppoint_x = new_ppoint_x+directions[1].xcr[p];
						end;
					end;
				elseif  modepf == -1 then
					if  new_ppoint_x < global.mindhero_x then
						if ppoint_y/2 == math.ceil(ppoint_y/2) then
							ppoint_x = new_ppoint_x+directions[1].xn[p];
						else
							ppoint_x = new_ppoint_x+directions[1].xc[p];
						end;
					elseif new_ppoint_x >= global.mindhero_x then
						if ppoint_y/2 == math.ceil(ppoint_y/2) then
							ppoint_x = new_ppoint_x+directions[1].xnr[p];
						else
							ppoint_x = new_ppoint_x+directions[1].xcr[p];
						end;
					end; 
				end;
			end;
			if checked_path2[#checked_path2][1] == point_to_go_x and checked_path2[#checked_path2][2] == point_to_go_y then
				mindpath_status = 1;
				dest_point_x = checked_path2[#checked_path2][1];
				dest_point_y = checked_path2[#checked_path2][2];						
				break; -- breaking while
			end;
			if mindpath_status == 1 then
					break;
				end;
			local already_chkd = 0;
			for k=1,#checked_path2 do
				if checked_path2[k][1] == ppoint_x and checked_path2[k][2] == ppoint_y then
					already_chkd = 1;
				end;
			end;
			wave_delta_x = math.abs(global.mindhero_x-ppoint_x);
			wave_delta_y = math.abs(global.mindhero_y-ppoint_y);
			wave_delta_m = math.max(wave_delta_x,wave_delta_y);
			if wave_delta_m > new_wave then
				new_wave=wave_delta_m;
			end;
			if already_chkd == 0 and mindgame.passCheck(ppoint_x,ppoint_y) then
				table.insert(checked_path2,{ppoint_x,ppoint_y,#checked_path2+1,new_index,new_wave});
				table.insert(hex_to_check_next_wave,checked_path2[#checked_path2]);
			end;
		end;
		wave = wave+1;
	end;
	if mindpath_status == 1  then
		current_point_x=dest_point_x;
		current_point_y=dest_point_y;
		local paint_index=checked_path2[#checked_path2][3];
		while (current_point_x ~= global.mindhero_x or current_point_y ~= global.mindhero_y) do
			table.insert(mind_way,{checked_path2[paint_index][1],checked_path2[paint_index][2]});
			paint_index=checked_path2[paint_index][4];
			current_point_x=checked_path2[paint_index][1];
			current_point_y=checked_path2[paint_index][2];
		end;
		global.mindway = mind_way;
		return mind_way;
	else
		chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][destination] = -1;
		local sum = 0;
		for i=1,10 do
			if chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][i] == -1 then
				sum = sum + 1;
			end;
		end;
		if sum == 6 then
			game_status = "neutral"; --FAIL BERSERK MADNESS FLAG BRAINFUCKER for a party member
			print("MINDGAME FAILED");
			party.gold = party.gold - global.mindgold; --?
			global.mindgold = 0;
			global.status = "peace";
			loveframes.util.RemoveAll();
			return;
		else
			mindgame.path ();
			return;
		end;
	end;
end;

function mindgame.passCheck(x,y)
	if x > 0 and x <= 9 and y > 0 and y <= 9 then
		if mindgame.map[x][y] and mindgame.map[x][y] >= 1 and  mindgame.map[x][y] <= 7 then --gold
			local _index = mindgame.map[x][y];
			if _index <= 7 and mindgame.flags_gold[chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["gold"]][_index][2] then
				return false;
			end;
		end;
		local drinkmode =  chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["drinks"];
		if mindgame.map[x][y] and mindgame.map[x][y] > 1000 and (drinkmode == "drinker" or drinkmode == "boozer" or drinkmode == "drunkard" or drinkmode == "taster") then
			return false;
		end;
		local foodmode =  chars_mobs_npcs[victim]["personality"]["current"]["mindflags"]["food"];
		if mindgame.map[x][y] and mindgame.map[x][y] > 2000 and (foodmode == "hungry" or foodmode == "starving" or foodmode == "glutton" or foodmode == "taster3") then
			return false;
		end;
		if mindgame.map[x][y] and mindgame.map[x][y] > 7 and mindgame.map[x][y] <= 100 then
			return false;
		end;
	else
		return false;
	end;
	return true;
end;

function mindgame.passTurn()
	local mindcounter = mindgame["flags_default"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"].default][1];
	if mindcounter >= 0 then
		local mindadd = mindgame["flags_default"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"].default][2];
		chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][mindcounter] = chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][mindcounter] + mindadd;
		if chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][mindcounter] < 0 then
			chars_mobs_npcs[victim]["personality"]["current"]["mindstatus"][mindcounter] = 0;
		end;
		local snd = "mindgame_" .. mindgame["flags_default"][chars_mobs_npcs[victim]["personality"]["current"]["mindflags"].default][3];
		utils.playSfx(media["sounds"][snd],1);
	end;
	mindgame.path ();
end;

function mindgame.calcGoldSums()
	local moneysums = {1,10,100,1000,10000,100000,1000000};
	local coff = 1-(chars_mobs_npcs[current_mob].num_trading*chars_mobs_npcs[current_mob].lvl_trading-chars_mobs_npcs[victim].num_trading*chars_mobs_npcs[victim].lvl_trading)/200;
	for i=2,7 do
		moneysums[i] = math.ceil(moneysums[i]*coff);
	end;
	return moneysums;
end;

function mindgame.notTriggerHex(x,y)
	for i=1,6 do
		if mindgame.dest_coords[i][1] == x and mindgame.dest_coords[i][2] == y then
			return false;
		end;
	end;
	return true;
end;

function mindgame.checkJoke(joke,mobindex)
	local _reaction = 0;
	--likes topic
	for i=1,#chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][1] do
		for h=1,#jokes_ttx[joke]["code"][1] do
			if chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][1][h] == jokes_ttx[joke]["code"][1][i] then
				_reaction = _reaction + 1;
				--print("likes topic");
			end;
		end;
	end;
	--dislikes topic
	for i=1,#chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][2] do
		for h=1,#jokes_ttx[joke]["code"][1] do
			if chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][2][h] == jokes_ttx[joke]["code"][1][i] then
				_reaction = _reaction - 1;
				--print("dislikes topic");
			end;
		end;
	end;
	--likes positive
	for i=1,#chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][3] do
		for h=1,#jokes_ttx[joke]["code"][2] do
			if chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][3][h] == jokes_ttx[joke]["code"][2][i] then
				_reaction = _reaction + 1;
				--print("likes positive");
			end;
		end;
	end;
	--dislikes positives
	for i=1,#chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][3] do
		for h=1,#jokes_ttx[joke]["code"][3] do
			if chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][3][h] == jokes_ttx[joke]["code"][3][i] then
				_reaction = _reaction - 1;
				--print("dislikes positive");
			end;
		end;
	end;
	--likes negatives
	for i=1,#chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][4] do
		for h=1,#jokes_ttx[joke]["code"][2] do
			if chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][4][h] == jokes_ttx[joke]["code"][2][i] then
				_reaction = _reaction - 1;
			--print("likes pnegatives");
			end;
		end;
	end;
	--dislikes negatives
	for i=1,#chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][4] do
		for h=1,#jokes_ttx[joke]["code"][3] do
			if chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["code"][4][h] == jokes_ttx[joke]["code"][3][i] then
				_reaction = _reaction + 1;
				--print("dislikes negatives");
			end;
		end;
	end;
	--print("REACTION",_reaction);
	if _reaction == 0 then
		--_reaction = (math.random(1,2)*2-3)*math.ceil(chars_mobs_npcs[current_mob].chr/20);
		_reaction = (math.random(1,2)*2-3);
	end;
	_reaction = _reaction*chars_mobs_npcs[mobindex]["personality"]["current"]["humor"].multi;
	for i=1, #chars_mobs_npcs[mobindex]["personality"]["current"]["humor"].known_jokes do
		if joke == chars_mobs_npcs[mobindex]["personality"]["current"]["humor"]["known_jokes"][i] then
			_reaction = 0;
		end;
	end;
	return _reaction;
end;

function mindgame.recreateDrinkAndFoodArray()
	global.minddrink_array = {};
	for i=1,#chars_mobs_npcs[current_mob]["inventory_list"] do
		if chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid == raws.buz then
			table.insert(global.minddrink_array,{itemid=i,spriteid=chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid,typ="alco",price=1});
		end;
	end;
	
	for i=1,#chars_mobs_npcs[current_mob]["inventory_list"] do
		if inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid].class == " alcohol" then
			table.insert(global.minddrink_array,{itemid=i,spriteid=chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid,typ="alco",price=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid].price});
		end;
	end;
	
	for i=1,#chars_mobs_npcs[current_mob]["inventory_list"] do
		if inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid].class == "food" then
			table.insert(global.minddrink_array,{itemid=i,spriteid=chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid,typ="food",price=inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid].price});
		end;
	end;
end;
