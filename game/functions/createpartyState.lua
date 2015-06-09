local loader = require 'lib.love-loader'
require "data.log"
require "data.defaults"
require "data.inventory"
--require "lib.utf8"

local createpartyState = {}
local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight();
local margin = 20;

function createpartyState.start(media)
	utils.printDebug("PARTY CREATION!");
	createpartyState.load();
end;

function createpartyState.load()
	x =  math.ceil((global.screenWidth-1280)/2);
	y =  math.ceil((global.screenWidth-960)/2);
	chars=4                               
	createpartyState.availableRaces = {};
	charfaces={};
	for i=1,12 do
		for h=1,12 do
			local tmpf=((h-1)*12+i);
			charfaces[tmpf] = love.graphics.newQuad((i-1)*80, (h-1)*90, 80,90, media.images.charfaces:getWidth(), media.images.charfaces:getHeight());
		end;
	end;
	for key,value in pairs(defaults.racestats) do
		if defaults.racestats[key].active then
			table.insert(createpartyState.availableRaces,{tostring(key),defaults.racestats[key].index});
		end;
	end;
	table.sort(createpartyState.availableRaces, function(a,b) return a[2] < b[2] end); 
	createpartyState.raceIndex = {11,9,1,7};
	createpartyState.availableClasses = {"fighter","tricker","novice","acolyte"};
	createpartyState.classIndex = {1,2,3,4};
	createpartyState.skillPoints = {};
	createpartyState.statPoints = {};
	createpartyState.defaultStatPoints = 10;
	createpartyState.defaultSkillPoints = 4;
	createpartyState.checkedSkills = {};
	createpartyState.height = 200;
	inventory_load ();
	for i=1,chars do
		createpartyState.statPoints[i] = createpartyState.defaultStatPoints;
		createpartyState.skillPoints[i] = createpartyState.defaultSkillPoints;
	end;
	char_gender={1,1,1,1};
	stats = {"mgt","enu","spd","dex","acu","sns","int","spr","chr","luk"};
	rezs = {"fire","cold","static","acid","poison","disease","mind","spirit","light","darkness"};
	chars_stats={};
	for h=1,chars do
		createpartyState.checkedSkills[h] = {};
		for i=1,13 do
			createpartyState.checkedSkills[h][i] = false; 
		end;
		chars_stats[h] = {};
		chars_stats[h].race = createpartyState.availableRaces[createpartyState.raceIndex[h]][1];
		chars_stats[h].class = createpartyState.availableClasses[createpartyState.classIndex[h]];
		chars_stats[h].gender = char_gender[h];
		local index = createpartyState.availableRaces[createpartyState.raceIndex[h]][2];
		chars_stats[h].face = (index-1)*6+math.random(1,3)+3*(chars_stats[h].gender-1);
		local roll = math.random(1,#defaults.names[chars_stats[h].race][chars_stats[h].gender]);
		chars_stats[h].nameindex = roll;
		chars_stats[h].name = lognames.names[defaults.names[chars_stats[h].race][chars_stats[h].gender][roll]];
		for i = 1,10 do
			chars_stats[h][stats[i]] = defaults.racestats[chars_stats[h].race].stats[stats[i]]+defaults.classstats[chars_stats[h].class][stats[i]];
		end;

		for i=1,#skills do
			local skillnum = "num_" .. skills[i];
			local skilllvl = "lvl_" .. skills[i];
			chars_stats[h][tostring(skillnum)] = 0;
			chars_stats[h][tostring(skilllvl)] = 0;
		end;
		
	end;
	createpartyState.temporal_chars_stats = chars_stats;
	createpartyState.drawText ();
	createpartyState.drawButtons ();
end;

function createpartyState.drawButtons ()
	global.buttons.party_button = loveframes.Create("imagebutton");
	global.buttons.party_button:SetImage(media.images.button1);
	global.buttons.party_button:SetPos(x+math.ceil(screenWidth/2- media.images.button1:getWidth()/2),screenHeight - margin - media.images.button1:getHeight());
	global.buttons.party_button:SizeToImage();
	global.buttons.party_button:SetText("");
	global.buttons.party_button.OnClick = function(object)
		createpartyState.startGame ();
			end;
	for h=1,chars do	
		
		local btn = loveframes.Create("imagebutton");
		btn:SetImage(media.images.button5);
		btn:SetPos(x+180+(h-1)*300, 120);
		btn:SizeToImage();
		btn:SetText("");
		btn.OnClick = function(object)
			local index = createpartyState.availableRaces[createpartyState.raceIndex[h]][2];
			if chars_stats[h].face > (index-1)*6+1+3*(chars_stats[h].gender-1) then
				chars_stats[h].face = chars_stats[h].face - 1;
			else
				chars_stats[h].face = (index-1)*6+3+3*(chars_stats[h].gender-1);
			end;		
		end;
		
		local btn = loveframes.Create("imagebutton");
		btn:SetImage(media.images.button6);
		btn:SetPos(x+320+(h-1)*300, 120);
		btn:SizeToImage();
		btn:SetText("");
		btn.OnClick = function(object)
			local index = createpartyState.availableRaces[createpartyState.raceIndex[h]][2];
			if chars_stats[h].face < (index-1)*6+3+3*(chars_stats[h].gender-1) then
				chars_stats[h].face = chars_stats[h].face + 1;
			else
				chars_stats[h].face = (index-1)*6+1+3*(chars_stats[h].gender-1);
			end;	
		end;
		
		local btn = loveframes.Create("imagebutton");
		btn:SetImage(media.images.button5);
		btn:SetPos(x+180+(h-1)*300, createpartyState.height);
		btn:SizeToImage();
		btn:SetText("");
		btn.OnClick = function(object)
			if chars_stats[h].nameindex > 1 then
				chars_stats[h].nameindex = chars_stats[h].nameindex -1;
			else
				chars_stats[h].nameindex = #defaults.names[chars_stats[h].race][chars_stats[h].gender];
			end;
			chars_stats[h].name = lognames.names[defaults.names[chars_stats[h].race][chars_stats[h].gender][chars_stats[h].nameindex]];
			createpartyState.renew ();
		end;
		
		local btn = loveframes.Create("imagebutton");
		btn:SetImage(media.images.button6);
		btn:SetPos(x+320+(h-1)*300, createpartyState.height);
		btn:SizeToImage();
		btn:SetText("");
		btn.OnClick = function(object)
			if chars_stats[h].nameindex < #defaults.names[chars_stats[h].race][chars_stats[h].gender] then
				chars_stats[h].nameindex = chars_stats[h].nameindex +1;
			else
				chars_stats[h].nameindex = 1;
			end;
			chars_stats[h].name = lognames.names[defaults.names[chars_stats[h].race][chars_stats[h].gender][chars_stats[h].nameindex]];
			createpartyState.renew ();	
		end;
		
		local btn = loveframes.Create("imagebutton");
		btn:SetImage(media.images.button5);
		btn:SetPos(x+180+(h-1)*300, createpartyState.height+20);
		btn:SizeToImage();
		btn:SetText("");
		btn.OnClick = function(object)
			if chars_stats[h].gender == 2 then
				local roll = math.random(1,3);
				local index = createpartyState.availableRaces[createpartyState.raceIndex[h]][2];
				chars_stats[h].gender = 1;
				chars_stats[h].face = (index-1)*6+math.random(1,3)+3*(chars_stats[h].gender-1);
				local roll = math.random(1,#defaults.names[chars_stats[h].race][chars_stats[h].gender]);
				chars_stats[h].nameindex = roll;
				chars_stats[h].name = lognames.names[defaults.names[chars_stats[h].race][chars_stats[h].gender][roll]];
				createpartyState.renew ();
			end;
		end;
		
		local btn = loveframes.Create("imagebutton");
		btn:SetImage(media.images.button6);
		btn:SetPos(x+320+(h-1)*300, createpartyState.height+20);
		btn:SizeToImage();
		btn:SetText("");
		btn.OnClick = function(object)
			if chars_stats[h].gender == 1 then
				local roll = math.random(1,3);
				local index = createpartyState.availableRaces[createpartyState.raceIndex[h]][2];
				chars_stats[h].gender = 2;
				chars_stats[h].face = (index-1)*6+math.random(1,3)+3*(chars_stats[h].gender-1);
				local roll = math.random(1,#defaults.names[chars_stats[h].race][chars_stats[h].gender]);
				chars_stats[h].nameindex = roll;
				chars_stats[h].name = lognames.names[defaults.names[chars_stats[h].race][chars_stats[h].gender][roll]];
				createpartyState.renew ();	
			end;
		end;
		
		local btn = loveframes.Create("imagebutton");
		btn:SetImage(media.images.button6);
		btn:SetPos(x+320+(h-1)*300, createpartyState.height+60);
		btn:SizeToImage();
		btn:SetText("");
		btn.OnClick = function(object)
			createpartyState.raceIndex[h] = createpartyState.raceIndex[h] + 1;
			if createpartyState.raceIndex[h] > #createpartyState.availableRaces then
				createpartyState.raceIndex[h] = 1;
			end;
			chars_stats[h].race = createpartyState.availableRaces[createpartyState.raceIndex[h]][1];
			local roll = math.random(1,#defaults.names[chars_stats[h].race][chars_stats[h].gender]);
			chars_stats[h].nameindex = roll;
			chars_stats[h].name = lognames.names[defaults.names[chars_stats[h].race][chars_stats[h].gender][roll]];
			createpartyState.statPoints[h] =10;
			for i = 1,10 do
				chars_stats[h][stats[i]] = defaults.racestats[chars_stats[h].race].stats[stats[i]]+defaults.classstats[chars_stats[h].class][stats[i]];
			end;
			for i=1,#skills do
				local skillnum = "num_" .. skills[i];
				chars_stats[h][skillnum] = 0;
			end;
			local index = createpartyState.availableRaces[createpartyState.raceIndex[h]][2];
			chars_stats[h].face = (index-1)*6+math.random(1,3)+3*(chars_stats[h].gender-1);
			createpartyState.statPoints[h] = createpartyState.defaultStatPoints;
			createpartyState.skillPoints[h] = createpartyState.defaultSkillPoints;
			createpartyState.renew ();
		end;
			
		local btn = loveframes.Create("imagebutton");
		btn:SetImage(media.images.button5);
		btn:SetPos(x+180+(h-1)*300, createpartyState.height+60);
		btn:SizeToImage();
		btn:SetText("");
		btn.OnClick = function(object)
			createpartyState.raceIndex[h] = createpartyState.raceIndex[h] - 1;
			if createpartyState.raceIndex[h] <= 0 then
				createpartyState.raceIndex[h] = #createpartyState.availableRaces;
			end;
			chars_stats[h].race = createpartyState.availableRaces[createpartyState.raceIndex[h]][1];
			local roll = math.random(1,#defaults.names[chars_stats[h].race][chars_stats[h].gender]);
			chars_stats[h].nameindex = roll;
			chars_stats[h].name = lognames.names[defaults.names[chars_stats[h].race][chars_stats[h].gender][roll]];
			for i = 1,10 do
				chars_stats[h][stats[i]] = defaults.racestats[chars_stats[h].race].stats[stats[i]]+defaults.classstats[chars_stats[h].class][stats[i]];
			end;
			for i=1,#skills do
				local skillnum = "num_" .. skills[i];
				chars_stats[h][skillnum] = 0;
			end;
			local index = createpartyState.availableRaces[createpartyState.raceIndex[h]][2];
			chars_stats[h].face = (index-1)*6+math.random(1,3)+3*(chars_stats[h].gender-1);
			createpartyState.statPoints[h] = createpartyState.defaultStatPoints;
			createpartyState.skillPoints[h] = createpartyState.defaultSkillPoints;
			createpartyState.renew ();	
		end;
		
		local btn = loveframes.Create("imagebutton");
		btn:SetImage(media.images.button6);
		btn:SetPos(x+320+(h-1)*300, createpartyState.height+80);
		btn:SizeToImage();
		btn:SetText("");
		btn.OnClick = function(object)
			createpartyState.classIndex[h] = createpartyState.classIndex[h] + 1;
			if createpartyState.classIndex[h] > #createpartyState.availableClasses then
				createpartyState.classIndex[h] = 1;
			end;
			chars_stats[h].class = createpartyState.availableClasses[createpartyState.classIndex[h]];
			for i = 1,10 do
				chars_stats[h][stats[i]] = defaults.racestats[chars_stats[h].race].stats[stats[i]]+defaults.classstats[chars_stats[h].class][stats[i]];
			end;
			for i=1,#skills do
				local skillnum = "num_" .. skills[i];
				chars_stats[h][skillnum] = 0;
			end;
			createpartyState.statPoints[h] = createpartyState.defaultStatPoints;
			createpartyState.skillPoints[h] = createpartyState.defaultSkillPoints;
			createpartyState.renew ();	
		end;
		
		local btn = loveframes.Create("imagebutton");
		btn:SetImage(media.images.button5);
		btn:SetPos(x+180+(h-1)*300, createpartyState.height+80);
		btn:SizeToImage();
		btn:SetText("");
		btn.OnClick = function(object)
			createpartyState.classIndex[h] = createpartyState.classIndex[h] - 1;
			if createpartyState.classIndex[h] <= 0 then
				createpartyState.classIndex[h] = #createpartyState.availableClasses;
			end;
			chars_stats[h].class = createpartyState.availableClasses[createpartyState.classIndex[h]];
			for i = 1,10 do
				chars_stats[h][stats[i]] = defaults.racestats[chars_stats[h].race].stats[stats[i]]+defaults.classstats[chars_stats[h].class][stats[i]];
			end;
			for i=1,#skills do
				local skillnum = "num_" .. skills[i];
				chars_stats[h][skillnum] = 0;
			end;
			createpartyState.statPoints[h] = createpartyState.defaultStatPoints;
			createpartyState.skillPoints[h] = createpartyState.defaultSkillPoints;
			createpartyState.renew ();	
		end;
		for i = 1,10 do
			local btn = loveframes.Create("imagebutton");
			btn:SetImage(media.images.button4);
			btn:SetPos(x+320+(h-1)*300, createpartyState.height + 100 +i*20);
			btn:SizeToImage();
			btn:SetText("");
			btn.OnClick = function(object)
				if createpartyState.statPoints[h] > 0 and createpartyState.temporal_chars_stats[h][stats[i]] < 25 then
					createpartyState.temporal_chars_stats[h][stats[i]] = createpartyState.temporal_chars_stats[h][stats[i]]+1;
					createpartyState.statPoints[h] = createpartyState.statPoints[h] -1;
					createpartyState.renew ();
				end;
			end;
		end;
		
		for i = 1,10 do
			local btn = loveframes.Create("imagebutton");
			btn:SetImage(media.images.button3);
			btn:SetPos(x+180+(h-1)*300, createpartyState.height + 100 +i*20);
			btn:SizeToImage();
			btn:SetText("");
			btn.OnClick = function(object)
				if createpartyState.temporal_chars_stats[h][stats[i]] > defaults.racestats[chars_stats[h].race].stats[stats[i]] then
					createpartyState.temporal_chars_stats[h][stats[i]] = createpartyState.temporal_chars_stats[h][stats[i]]-1;
					createpartyState.statPoints[h] = createpartyState.statPoints[h] +1;
					createpartyState.renew ();
				end;
			end;
		end;
		
		for i = 1,10 do
			local btn = loveframes.Create("imagebutton");
			btn:SetImage(media.images.button2);
			btn:SetPos(x+50+(h-1)*300, createpartyState.height + 400 +i*20);
			btn:SizeToImage();
			btn:SetText("");
			btn.OnClick = function(object)
				if not createpartyState.checkedSkills[h][i] and createpartyState.skillPoints[h] > 0 then
					createpartyState.checkedSkills[h][i] = true;
					local skillnum = "num_" .. defaults.classskills[chars_stats[h].class][i];
					chars_stats[h][tostring(skillnum)] = chars_stats[h][tostring(skillnum)] +1;
					createpartyState.skillPoints[h] = createpartyState.skillPoints[h] -1;
				elseif createpartyState.checkedSkills[h][i] then
					createpartyState.checkedSkills[h][i] = false;
					local skillnum = "num_" .. defaults.classskills[chars_stats[h].class][i];
					chars_stats[h][tostring(skillnum)] = chars_stats[h][tostring(skillnum)] -1;
					createpartyState.skillPoints[h] = createpartyState.skillPoints[h] +1;
				end;
				createpartyState.renew ();
			end;
			
			local tooltip = loveframes.Create("tooltip");
			tooltip:SetObject(btn);
			tooltip:SetPadding(10);
			tooltip:SetFont(font);
			--tooltip:SetOffsetX(-100);
			tooltip:SetText(lognames.skillDescriptions[defaults.classskills[chars_stats[h].class][i]]);
		end;
		
		for i = 1,3 do
			local btn = loveframes.Create("imagebutton");
			btn:SetImage(media.images.button2);
			btn:SetPos(x+50+(h-1)*300, createpartyState.height + 320 +i*20);
			btn:SizeToImage();
			btn:SetText("");
			btn.OnClick = function(object)
			if not createpartyState.checkedSkills[h][i+10] and createpartyState.skillPoints[h] > 0 then
				createpartyState.checkedSkills[h][i+10] = true;
				local skillnum = "num_" .. defaults.racestats[chars_stats[h].race].skills[i];
				print("skillnum",skillnum);
				chars_stats[h][tostring(skillnum)] = chars_stats[h][tostring(skillnum)] +1;
				createpartyState.skillPoints[h] = createpartyState.skillPoints[h] -1;
				if defaults.racestats[chars_stats[h].race].skills[i] == "leadership" then
					for j=1,chars do
						if j ~= h then
							while chars_stats[j].num_leadership > 0 do
								chars_stats[j].num_leadership = chars_stats[j].num_leadership - 1;
								createpartyState.skillPoints[j] = createpartyState.skillPoints[j] + 1;
								for k=1,3 do
									if defaults.racestats[chars_stats[j].race].skills[k] == "leadership" then 
										createpartyState.checkedSkills[j][k+10] = false;
									end;
								end;
							end;
						end;
					end;
				end
			elseif createpartyState.checkedSkills[h][i+10] then
				createpartyState.checkedSkills[h][i+10] = false;
				local skillnum = "num_" .. defaults.racestats[chars_stats[h].race].skills[i];
				chars_stats[h][tostring(skillnum)] = chars_stats[h][tostring(skillnum)] -1;
				createpartyState.skillPoints[h] = createpartyState.skillPoints[h] +1;
			end;
			createpartyState.renew ();
			end;
			local tooltip = loveframes.Create("tooltip");
			tooltip:SetObject(btn);
			tooltip:SetPadding(10);
			tooltip:SetFont(font);
			--tooltip:SetOffsetX(-100);
			tooltip:SetText(lognames.skillDescriptions[defaults.racestats[chars_stats[h].race].skills[i]]);
		end;	
		
	end;
end;

function createpartyState.drawText ()
	local meleeSkills = {"sword","axe","flagpole","crushing","staff","dagger","unarmed"};
	
	for h=1,chars do
			
			local text = lognames.chars.name;
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+50+(h-1)*300, createpartyState.height);
			textfield:SetWidth(100);
			textfield:SetFont(font);
			textfield:SetText(text);
			
			--[[local text = chars_stats[h].name;
			local textfield = loveframes.Create("textinput");
			textfield:SetPos(200+(h-1)*300, createpartyState.height);
			textfield:SetWidth(120);
			textfield:SetFont(font);
			--print("TXT",text);
			textfield:SetText(text);
			textfield:SetLimit(12);
			--textfield:SetUsable({"0","1","2","3","4","5","6","7","8","9"});
			textfield.OnEnter = function(object, text)
				if text ~= nil then
					chars_stats[h].name = text;
					createpartyState.renew ();
				end;
			end;]]
			
			local text = chars_stats[h].name;
			--local spaces = 20 - #text;
			--for i=1,spaces do
				--text = " " .. text
			--end;
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+200+(h-1)*300, createpartyState.height);
			textfield:SetWidth(120);
			textfield:SetFont(font);
			textfield:SetText(text);

			local text = lognames.chars.gender;
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+50+(h-1)*300, createpartyState.height + 20);
			textfield:SetWidth(100);
			textfield:SetFont(font);
			textfield:SetText(text);
			
			local text = lognames.gender[chars_stats[h].gender];
			--local spaces = 20 - #text;
			--for i=1,spaces do
			--	text = " " .. text
			--end;
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+200+(h-1)*300, createpartyState.height+20);
			textfield:SetWidth(120);
			textfield:SetFont(font);
			textfield:SetText(text);
			
			local text = lognames.chars.race;
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+50+(h-1)*300, createpartyState.height+60);
			textfield:SetWidth(100);
			textfield:SetFont(font);
			textfield:SetText(text);
			
			local text = lognames.races[chars_stats[h].race];
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+200+(h-1)*300, createpartyState.height+60);
			textfield:SetWidth(120);
			textfield:SetFont(font);
			textfield:SetText(text);
			
			local tooltip = loveframes.Create("tooltip");
			tooltip:SetObject(textfield);
			tooltip:SetPadding(10);
			tooltip:SetFont(font);
			tooltip:SetOffsetX(-100);
			tooltip:SetText(lognames.raceDescriptions[chars_stats[h].race]);
			
			local text = lognames.chars.class;
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+50+(h-1)*300, createpartyState.height+80);
			textfield:SetWidth(100);
			textfield:SetFont(font);
			textfield:SetText(text);
			
			local text = lognames.classes[chars_stats[h].class];
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+200+(h-1)*300, createpartyState.height+80);
			textfield:SetWidth(120);
			textfield:SetFont(font);
			textfield:SetText(text);
		
		for i = 1,10 do
			local text = lognames.stats[stats[i]];
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+50+(h-1)*300, createpartyState.height + 100 +i*20);
			textfield:SetWidth(120);
			textfield:SetFont(font);
			textfield:SetText(text);
			
			local tooltip = loveframes.Create("tooltip");
			tooltip:SetObject(textfield);
			tooltip:SetPadding(10);
			tooltip:SetFont(font);
			tooltip:SetOffsetX(-100);
			tooltip:SetText(lognames.statDescriptions[stats[i]]);
			--createpartyState.temporal_chars_stats[h][stats[i]] > defaults.racestats[chars_stats[h].race].stats[stats[i]]
			
			textfield:SetShadow(true)
			if createpartyState.temporal_chars_stats[h][stats[i]] > defaults.racestats[chars_stats[h].race].stats[stats[i]] and createpartyState.temporal_chars_stats[h][stats[i]] < 25 then
				textfield:SetShadowColor(255, 255, 255, 255);
			elseif createpartyState.temporal_chars_stats[h][stats[i]] == defaults.racestats[chars_stats[h].race].stats[stats[i]] then
				textfield:SetShadowColor(255, 0, 0, 255);
			elseif createpartyState.temporal_chars_stats[h][stats[i]] == 25 then
				textfield:SetShadowColor(0, 255, 0, 255);
			end;
			
			local text = createpartyState.temporal_chars_stats[h][stats[i]];
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+250+(h-1)*300, createpartyState.height + 100 +i*20);
			textfield:SetWidth(50);
			textfield:SetFont(font);
			textfield:SetText(text);
		end;
		
		local text = createpartyState.statPoints[h];
		local textfield = loveframes.Create("text");
		textfield:SetPos(x+250+(h-1)*300, createpartyState.height+320);
		textfield:SetWidth(50);
		textfield:SetFont(font);
		textfield:SetText(text);
		
		for i = 1,3 do
			
			local skillname = defaults.racestats[chars_stats[h].race].skills[i];
			local addx = 0;
			if  createpartyState.checkedSkills[h][i+10] then
				rgbcolor = {0, 255, 0, 255};
				addx = 40;
			else
				rgbcolor = {255, 255, 255, 255};
				addx = 0;
			end;
			local text = {color = rgbcolor,lognames.skills[defaults.racestats[chars_stats[h].race].skills[i]]};
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+50+(h-1)*300+addx, createpartyState.height + 320 +i*20);
			textfield:SetWidth(220);
			textfield:SetFont(font);
			textfield:SetText(text);
			
		end;
		
		for i = 1,10 do
			local rgbcolor = {};
			local addx = 0;
			if  createpartyState.checkedSkills[h][i] then
				rgbcolor = {0, 255, 0, 255};
				addx = 40;
			else
				rgbcolor = {255, 255, 255, 255};
				addx = 0;
			end;
			local text = {color = rgbcolor,lognames.skills[defaults.classskills[chars_stats[h].class][i]]};
			local textfield = loveframes.Create("text");
			textfield:SetPos(x+50+(h-1)*300 + addx, createpartyState.height + 400 +i*20);
			textfield:SetWidth(200);
			textfield:SetFont(font);
			textfield:SetText(text);
			for j=1, #meleeSkills do
				if meleeSkills[j] == defaults.classskills[chars_stats[h].class][i] then
					textfield:SetShadow(true)
					textfield:SetShadowColor(255, 255, 0, 255);
				end;
			end;
			for j=1, #defaults.classSkills[chars_stats[h].class] do
				if defaults.classSkills[chars_stats[h].class][j] == defaults.classskills[chars_stats[h].class][i] then
					textfield:SetShadow(true)
					textfield:SetShadowColor(255, 255, 255, 255);
				end;
			end;
		end;
		
		local text = createpartyState.skillPoints[h];
		local textfield = loveframes.Create("text");
		textfield:SetPos(x+250+(h-1)*300, createpartyState.height + 620);
		textfield:SetWidth(50);
		textfield:SetFont(font);
		textfield:SetText(text);
		
	end;
end;

function createpartyState.update (dt)
	
end;

function createpartyState.startGame ()
	
	local meleeSkills = {"sword","axe","flagpole","crushing","staff","dagger","unarmed"};
	local rangeSkills = {"bow","crossbow","throwing"};
	local magicSkills = {"fire","air","water","earth","body","mind","spirit"};

	local checkIfReady = {};
	local weCanStart = true;
	
	for h=1,chars do
		checkIfReady[h] = {melee=0,classskill=0,statpoints=createpartyState.statPoints[h],skillpoints=createpartyState.skillPoints[h]};
		for i=1,#meleeSkills do
			local tmpskillnum = "num_" .. meleeSkills[i];
			if chars_stats[h][tmpskillnum] > 0 then
				checkIfReady[h].melee = checkIfReady[h].melee + 1;
			end;
		end;	
		for i=1,#skills do
			for k=1,#defaults.classSkills[chars_stats[h].class] do
				local tmpskillnum = "num_" .. skills[i];
				if skills[i] == defaults.classSkills[chars_stats[h].class][k] and chars_stats[h][tmpskillnum] > 0 then
					checkIfReady[h].classskill = checkIfReady[h].classskill + 1;	
				end;
			end;
		end;
		if checkIfReady[h].melee == 0 or checkIfReady[h].classskill == 0 or checkIfReady[h].statpoints > 0 or checkIfReady[h].skillpoints > 0 then
			weCanStart = false;
		end;
	end;
	if weCanStart then
		inventory_bag={}
		inventory_list={};
		spellbooks = {};
		equipment = {};
		alchlab = {};
		picklock = {};
		craft = {};
		party.gold = 0;
		party = {};
		party.secrets = {};
		party.guilds = {};
		party.regalia = {};
		party.jokes = {};
		party.nlp={};
		party.affronts={};
		party.threats={1,2,3,4,5,6,7};
		party.connections = {};
		for h=1,chars do
			chars_stats[h]["inventory_list"]={};
			equipment[h] = {};
			alchlab[h] = {};
			picklock[h] = {};
			craft[h] = {};
			for i=1,10 do
				local tmpstat = stats[i];
				chars_stats[h][tmpstat] = createpartyState.temporal_chars_stats[h][tmpstat];
			end;
			
			for i=1,#skills do
				local skillnum = "num_" .. skills[i];
				local skilllvl = "lvl_" .. skills[i];
				if chars_stats[h][tostring(skillnum)] > 0 then
					chars_stats[h][tostring(skilllvl)] = 1;
				end;
			end;
			
			for i=1,#meleeSkills do
				local tmpskillnum = "num_" .. meleeSkills[i];
				if chars_stats[h][tmpskillnum] > 0 then
					if chars_stats[h].race == "minotaur" then
						table.insert(chars_stats[h]["inventory_list"],{ttxid=defaults.weaponSetD[meleeSkills[i]],q=inventory_ttx[defaults.weaponSetD[meleeSkills[i]]].material,w=0,e=0,r=1});
					elseif chars_stats[h].race == "hobgoblin" or chars_stats[h].race == "goblin" or chars_stats[h].race == "orc" or chars_stats[h].race == "ogre" then
						table.insert(chars_stats[h]["inventory_list"],{ttxid=defaults.weaponSetC[meleeSkills[i]],q=inventory_ttx[defaults.weaponSetC[meleeSkills[i]]].material,w=0,e=0,r=1});
					elseif chars_stats[h].race == "human_regnan" or chars_stats[h].race == "ratman" or chars_stats[h].race == "halfling" or chars_stats[h].race == "gremlin" then
						table.insert(chars_stats[h]["inventory_list"],{ttxid=defaults.weaponSetB[meleeSkills[i]],q=inventory_ttx[defaults.weaponSetB[meleeSkills[i]]].material,w=0,e=0,r=1});
					else
						table.insert(chars_stats[h]["inventory_list"],{ttxid=defaults.weaponSetA[meleeSkills[i]],q=inventory_ttx[defaults.weaponSetA[meleeSkills[i]]].material,w=0,e=0,r=1});
					end;
				end;
			end;	
			
			for i=1,#rangeSkills do
				local tmpskillnum = "num_" .. rangeSkills[i];
				if chars_stats[h][tmpskillnum] > 0 then
					if rangeSkills[i] ~= "throwing" then
						table.insert(chars_stats[h]["inventory_list"],{ttxid=defaults.rangeWeaponSet[rangeSkills[i]],q=25,w=0,e=0,r=1});	
					end;
					table.insert(chars_stats[h]["inventory_list"],{ttxid=defaults.ammoSet[rangeSkills[i]],q=25,w=0,e=0,r=1});	
				end;
			end;
			
			if chars_stats[h].num_shield > 0 then
				table.insert(chars_stats[h]["inventory_list"],{ttxid=186,q=inventory_ttx[186].material,w=0,e=0,r=1});
			end;
			
			if chars_stats[h].num_alchemy >= 1 then
				table.insert(chars_stats[h]["inventory_list"],{ttxid=463,q=inventory_ttx[463].material,w=0,e=0,r=1});
				table.insert(chars_stats[h]["inventory_list"],{ttxid=409,q=3,w=0,e=0,r=1});
				table.insert(chars_stats[h]["inventory_list"],{ttxid=469,q=10,w=0,e=0,r=1});
				table.insert(chars_stats[h]["inventory_list"],{ttxid=470,q=10,w=0,e=0,r=1});
				table.insert(chars_stats[h]["inventory_list"],{ttxid=471,q=10,w=0,e=0,r=1});
				table.insert(chars_stats[h]["inventory_list"],{ttxid=472,q=10,w=0,e=0,r=1});
				table.insert(chars_stats[h]["inventory_list"],{ttxid=473,q=10,w=0,e=0,r=1});
			end;
			
			if chars_stats[h].num_alchemy == 2 then
				table.insert(chars_stats[h]["inventory_list"],{ttxid=409,q=1,w=0,e=0,r=1});
			end;
			
			if chars_stats[h].num_armmastery > 0 then
				table.insert(chars_stats[h]["inventory_list"],{ttxid=409,q=11,w=0,e=0,r=1});
			end;
			
			if chars_stats[h].num_bodybuilding > 0 then --FIXME: книги по дипломатии, торговле, бодибилдингу, лидерству (может лидеру трубу выдать?)
				--table.insert(chars_stats[h]["inventory_list"],{ttxid=409,q=11,w=0,e=0,r=0});
			end;
			
			for i=1,#magicSkills do
				local tmpskillnum = "num_" .. magicSkills[i];
				if chars_stats[h][tmpskillnum] > 0 then
					local spell = defaults.Spells[magicSkills[i]][1];
					table.insert(chars_stats[h]["inventory_list"],{ttxid=389,q=1,w=spell,e=0,r=1});
					local spell = defaults.Spells[magicSkills[i]][2];
					table.insert(chars_stats[h]["inventory_list"],{ttxid=389,q=1,w=spell,e=0,r=1});
				end;
			end;
			
			for i=1,10 do
				local tmprez = "rez" .. rezs[i];
				chars_stats[h][tmprez] = defaults.racestats[chars_stats[h].race].resistances[tmprez];
			end;

			for h=1,chars do
				inventory_bag[h]={};
				for i=1,15 do
					inventory_bag[h][i]={};
					for j=1,11 do
						inventory_bag[h][i][j]=0;
					end;
				end;
			end;
			
			chars_stats[h].spells={
			{0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,0},
			--
			{0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,0},
			--
			{0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,0},
			--
			{0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,0},
			};
			
			chars_stats[h].warbook={
			{0,0,0,0,0,0,0,0,0,0,0,0}, --sword,axe,spear
			{0,0,0,0,0,0,0,0,0,0,0,0}, --crushing,staff,dagger
			{0,0,0,0,0,0,0,0,0,0,0,0}, --unarmed,throwing,firearms (sling?)
			{0,0,0,0,0,0,0,0,0,0,0,0}, --bow,crossbow,blaster
			};
			
			chars_stats[h].equipment={rh=0,lh=0,ranged=0,ammo=0, armor=0,head=0,boots=0,gloves=0,cloak=0,belt=0,amulet=0,ring1=0,ring2=0,ring3=0,ring4=0,ring5=0,ring6=0,art=0,teeth=0,horns=0,tail=0};
			alchlab[h]={tool1=0,tool2=0,tool3=0,tool4=0,tool5=0,tool6=0,bottle1=0,bottle2=0,bottle3=0,comp1=0,comp2=0,comp3=0,comp4=0,comp5=0,comp6=0,comp7=0,comp8=0,comp9=0};
			picklock[h]={tool1=0,tool2=0,tool3=0,tool4=0,key=0,picklock=0,traptool=0,forcer=0};
			
			chars_stats[h].sprite = "rogue";
			chars_stats[h].lv=1;
			chars_stats[h].xp=0;
			chars_stats[h].nature="humanoid";
			chars_stats[h].size="normal";
			chars_stats[h].feet=2;
			if chars_stats[h].race ~= "minotaur" then
				chars_stats[h].horns=0;
				chars_stats[h].hoofs=0;
			else
				chars_stats[h].horns=1;
				chars_stats[h].hoofs=1;
			end;
			chars_stats[h].track=1;
			if chars_stats[h].race == "minotaur" then
				chars_stats[h].track=4;
			elseif chars_stats[h].race == "kreegan" then
				chars_stats[h].track=8;
			elseif chars_stats[h].race == "lizardman" then
				chars_stats[h].track=8;
			elseif chars_stats[h].race == "kobold" then
				chars_stats[h].track=8;
			elseif chars_stats[h].race == "gnoll" then
				chars_stats[h].track=6;
			end;
			chars_stats[h].hexes = 1;
			chars_stats[h].arms = {"rh","lh"};
			chars_stats[h].fov = 180;
			chars_stats[h].motion="walking";
			chars_stats[h].hp_base = 12;
			chars_stats[h].sp_base = 12;
			chars_stats[h].st_base = 12;
			chars_stats[h].hp_coff = 1;
			chars_stats[h].sp_coff = 1;
			chars_stats[h].st_coff = 1;
			chars_stats[h].ac = 0;
			chars_stats[h].dt = 0;
			chars_stats[h].dr = 0;
			chars_stats[h].hp_regeneration = 0; --FIXME remove with skill
			chars_stats[h].sp_regeneration = 0; --FIXME remove with skill
			chars_stats[h].st_regeneration = 0;
			chars_stats[h].moral = 20;
			chars_stats[h].etiquette = defaults.etiquette[chars_stats[h].race];
			chars_stats[h].hitzones={{"head","rh","lh","rf","lf","body","body","body","body","body"}};
			if chars_stats[h].race == "dwarf" then --FIXME move to defaults
				chars_stats[h].nightvision = 1;
			elseif chars_stats[h].race == "dwarf_dark" or chars_stats[h].race == "hobgoblin" or chars_stats[h].race == "ogre" then
				chars_stats[h].nightvision = 2;
			elseif chars_stats[h].race == "goblin" or chars_stats[h].race == "orc" then
				chars_stats[h].nightvision = 3;
			elseif chars_stats[h].race == "ratman" or chars_stats[h].race == "gnoll" then
				chars_stats[h].nightvision = 4;
			elseif chars_stats[h].race == "minotaur" or chars_stats[h].race == "kobold" then
				chars_stats[h].nightvision = 5;
			else
				chars_stats[h].nightvision = 0;
			end;
			if chars_stats[h].race == "ratman" or chars_stats[h].race == "gnoll" then
				chars_mobs_npcs[i].claws = 0;
				chars_mobs_npcs[i].teeth = 1;
				chars_mobs_npcs[i].horns = 0;
				chars_mobs_npcs[i].hoofs = 0;
			elseif chars_stats[h].race == "minotaur" then
				chars_mobs_npcs[i].claws = 0;
				chars_mobs_npcs[i].teeth = 0;
				chars_mobs_npcs[i].horns = 1;
				chars_mobs_npcs[i].hoofs = 1;
			elseif chars_stats[h].race == "demon" then
				chars_mobs_npcs[i].claws = 0;
				chars_mobs_npcs[i].teeth = 0;
				chars_mobs_npcs[i].horns = 1;
				chars_mobs_npcs[i].hoofs = 0;
			elseif chars_stats[h].race == "kreegan" then
				chars_mobs_npcs[i].claws = 1;
				chars_mobs_npcs[i].teeth = 1;
				chars_mobs_npcs[i].horns = 0;
				chars_mobs_npcs[i].hoofs = 0;
			else
				chars_mobs_npcs[i].claws = 0;
				chars_mobs_npcs[i].teeth = 0;
				chars_mobs_npcs[i].horns = 0;
				chars_mobs_npcs[i].hoofs = 0;
			end;
			chars_mobs_npcs[i].acbody=0;
			chars_mobs_npcs[i].achead=0;
			chars_mobs_npcs[i].arms={};
			chars_mobs_npcs[i].legs=0;
			if chars_stats[h].class == "fighter" or chars_stats[h].class == "tricker" then
				chars_stats[h].spellbook=0;
			elseif chars_stats[h].class == "acolyte" or chars_stats[h].class == "novice" then
				chars_stats[h].spellbook=1;
			end;
		end;
		
		local roll = math.random(1,3);
		local tmp = "media.images.preloader" .. roll;
		img_preloader = loadstring("return " .. tmp)();
		loveframes.util.RemoveAll();
		nextState = playingState;
		nextStateName = "playingState";
		currentState = loadingState;
		currentState.start(media, loadingFinished);
	else
		-- WRONG PARTY SETUP!
	end;
end;

function createpartyState.renew ()
	loveframes.util.RemoveAll();
	createpartyState.drawText ();
	createpartyState.drawButtons ();
end;

function createpartyState.keypressed(key)

end;

function createpartyState.keyreleased(key)

end;

function createpartyState.mousepressed(x,y,button)

end;

function createpartyState.mousereleased(x,y,button)

end;

function createpartyState.draw()
	local x = math.ceil((global.screenWidth-img_preloader:getWidth())/2);
	local y = math.ceil((global.screenHeight-img_preloader:getHeight())/2);
	love.graphics.draw(media.images.createpartyback, x,y);
	--love.graphics.draw(media.images.createpartyback, 0,0);
	for h=1,chars do
		love.graphics.draw(media.images.charfaces, charfaces[chars_stats[h].face], x+220 + (h-1)*300,y+50);
	end;
end;

return createpartyState

