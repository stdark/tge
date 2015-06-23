--mindfield_editor
function love.load()
	require("loveframes");
	require 'Tserial';
	
	love.mouse.setVisible(true);
	
	mainFont = love.graphics.newFont("fonts/DroidSans-Bold.ttf", 14);
	bigFont = love.graphics.newFont("fonts/DroidSans-Bold.ttf", 32);
	
	img_hud =  love.graphics.newImage("img/hud.png");
	img_back = love.graphics.newImage("img/back.jpg");
	img_hex =  love.graphics.newImage("img/hex_landscape.png");
	img_mindfield = love.graphics.newImage("img/mindgame.dds");
	img_mindicons = love.graphics.newImage("img/mindgame_icons.dds");
	editor_status = "normal";
	
	mindgame_icons = {};
	for i=1,3 do
		for h=1,16 do
			local index = (i-1)*16+h;
			local x = (h-1)*64;
			local y = (i-1)*64;
			mindgame_icons[index] = love.graphics.newQuad(x, y, 64, 64, img_mindicons:getWidth(), img_mindicons:getHeight());
		end;
	end;
	table.insert(mindgame_icons,love.graphics.newQuad(0, 64*5, 64, 64, img_mindicons:getWidth(), img_mindicons:getHeight()));
	
	current_hex = 8;
	
	tile_w=63
	tile_h=32
	map_display_w = 40;
	map_display_h = 48;
	tile_hw = 32;
	tile_qh=tile_h/2;
	tile_34=tile_hw+tile_hw/2;
	tile_row_check=0;
	left_space=20;
	top_space=20;

	cursor_world_x=0;
	cursor_world_y=0;
	
	savename = "mindmap1.lua";
	hex_table={};
	for i=1,9 do
		hex_table[i] = {};
		for h=1,9 do
			hex_table[i][h] = 0;
		end;
	end;
	draw_buttons();
end;
 
function love.update(dt)
	love.mousepressed(x, y, button);
	mX, mY = love.mouse.getPosition();
	cursor_world_y=math.ceil((mY-top_space)/tile_h*4/3);
	if cursor_world_y/2 == math.ceil(cursor_world_y/2) then
		cursor_world_x=math.ceil((mX-left_space)/tile_w+1);
	else
		cursor_world_x=math.ceil((mX-left_space)/tile_w+1.5);
	end;
	loveframes.update(dt);
end;

function draw_buttons()
	buttons = {};
	for i=1,8 do
		for h=1,8 do
			local index = (h-1)*8+i;
			local x = (i-1)*64;
			local y = (h-1)*64;
			buttons[index] = loveframes.Create("button");
			buttons[index]:SetPos(740+x,30+y);
			buttons[index]:SetText("");
			buttons[index]:SetHeight(64);
			buttons[index]:SetWidth(64);
			buttons[index].OnClick = function(object)
				button_pressed (index);
					end;	
		end;
	end;
	buttons[#buttons] = loveframes.Create("button");
	buttons[#buttons]:SetPos(740,600);
	buttons[#buttons]:SetText("save");
	buttons[#buttons]:SetHeight(64);
	buttons[#buttons]:SetWidth(64);
	buttons[#buttons].OnClick = function(object)
		save()
			end;	
end;

function draw_icons_at_buttons ()
	for i=1,8 do
		for h=1,8 do
			local index = (i-1)*8+h;
			local x = (h-1)*64;
			local y = (i-1)*64;
			if mindgame_icons[index] then
				love.graphics.draw(img_mindicons, mindgame_icons[index], 740+x, 30+y);
			end;
		end;
	end;
end;

function button_pressed(index)
	print("BTN:",index);
	current_hex = index + 100;
	if index == 64 then
		current_hex = 0; --erase
	elseif index == 49 then
		current_hex = 8;
	end;
	return;
end;

function draw_hexfield()
	for i=1,20 do
		for h=1,30 do
			if central_hex_x == i and central_hex_y == h then
				hex_table[i][h] = 2;
			end;
			if door_hex_x and door_hex_x == i and door_hex_y and door_hex_y == h then
				hex_table[i][h] = 3;
			end;
		end;
	end;
	for my=1, 30 do
		for mx=1, 20 do	
			if hex_table[mx][my] == 0 then
				drawHex(mx,my,hex_tile);
			elseif hex_table[mx][my] == 1 then
				drawHex(mx,my,white_tile);
			elseif hex_table[mx][my] == 2 then
				drawHex(mx,my,door_tile);
			elseif hex_table[mx][my] == 3 then
				drawHex(mx,my,yellow_tile);
			end;
		end;
	end;
 end;
 
function love.keypressed(key, unicode)
	
end;

----

function love.mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button);
end

function love.mousereleased(x, y, button)
	local xx = cursor_world_x-2;
	local yy = cursor_world_y-5;
	if mX >= 70 and mX <= 650 and mY >= 140 and mY <= 360 and xx >= 1 and xx <= 9 and yy >= 1 and yy <= 9 and (xx ~=5 or yy ~= 5) and checkDestHex(xx,yy) then
		hex_table[xx][yy] = current_hex;	
		print("HEX:",xx,yy);
    end;
    loveframes.mousereleased(x, y, button);
end;

function checkDestHex(x,y)
	local dest_coords = {{7,1,"loyality"},{8,3,"disdain"},{9,5,"boring"},{8,7,"fear"},{7,9,"distrust"},{3,9,"sad"},{2,7,"respect"},{1,5,"surprise"},{2,3,"agression"},{3,1,"glad"},{5,9,"pity"},{5,1,"shame"}};
	for i=1,#dest_coords do
		if dest_coords[i][1] == x and dest_coords[i][2] == y then
			return false
		end;
	end;
	return true;
end;

function love.textinput(text)
    loveframes.textinput(text); 
end;

function love.keyreleased(key)
    if key == "rctrl" then
		frame_x2=mX;
		frame_y2=mY;
		if frame_x2 < frame_x1 then
			local tmp = frame_x1;
			frame_x1 = frame_x2
			frame_x2 = tmp;
		end;
		if frame_y2 < frame_y1 then
			local tmp = frame_y1;
			frame_y1 = frame_y2
			frame_y2 = tmp;
		end;
	end;
    loveframes.keyreleased(key)
end;

function save(x,y,w,h,addx,addy,doorev_x,doorev_y,doorne_x,doorne_y,hexesev,hexesne)
	local addx_hex = math.ceil(addx/32);
	local addy_hex = math.ceil(addy/16);
	love.filesystem.write( savename, Tserial.pack(hex_table, true, false) 
	 );
	print("SAVED!");
	editor_status = "saved";
end;

function draw_icons_at_field()
	for h=1,9 do
		for i=1,9 do
			if hex_table[i][h] > 0 then
				if hex_table[i][h] == 8 then
					draw_mind_object(img_mindicons,mindgame_icons[#mindgame_icons],i,h,0,0);
				else
					draw_mind_object(img_mindicons,mindgame_icons[hex_table[i][h]-100],i,h,0,0);
				end;
			end;
		end;
	end;
end;

function draw_mind_object(image,object,hx,hy,addx,addy)
	local x,y = -5.65*64,-6.8*32*0.75;
	local moveto_hex_x = 0;
	local moveto_hex_y = 0;
	moveto_hex_y = math.ceil(hy*tile_h*0.75+y+245)+addy;
	if hy/2 == math.ceil(hy/2) then
		moveto_hex_x = hx*tile_w+x+345+addx;
	else
		moveto_hex_x = hx*tile_w+tile_w/2+x+345+addx;
	end;
	if object then
		love.graphics.draw(image, object, moveto_hex_x, moveto_hex_y);
	end;
end;

function love.draw()
	love.graphics.setColor(255, 255, 255);
	love.graphics.setFont(mainFont);
	if editor_status == "normal" then
		love.graphics.draw(img_back, 0,0);
		love.graphics.draw(img_mindfield, 0,70);
		draw_icons_at_field();
	end;
	
	if editor_status == "help" then

	end;

	love.graphics.draw(img_hud, 0,0);

	if editor_status == "saved" then
		love.graphics.print("SAVED!", 450, 400);
    end
    
    local addx = 1025;
    local addy = 30;
    local scale = 0.1;
   
	love.graphics.setColor(0, 0, 0);
	local frame_w = 100;
	local frame_h = 70;

    loveframes.draw();
    love.graphics.setColor(255, 255, 255);
    draw_icons_at_buttons ();
end;
