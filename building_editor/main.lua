--building_editor
function love.load()
	require("loveframes");
	require 'Tserial';
	
	media = {};
	media.images={};
	
	love.mouse.setVisible(true);
	showmouse = -1;
	
	mainFont = love.graphics.newFont("fonts/DroidSans-Bold.ttf", 14);
	bigFont = love.graphics.newFont("fonts/DroidSans-Bold.ttf", 32);
	
	img_hud =  love.graphics.newImage("img/hud.png");
	img_hex =  love.graphics.newImage("img/hex_ui.dds");
	media.images.buildings1 = love.graphics.newImage("img/buildings1.dds");
	
	--[[if not media.images.buildings then
		media.images.buildings = {};
	end;
	for i=1,#buildings_stats do
		loader.newImage(media.images.buildings, "building" .. i, buildings_stats[i].img);
	end;]]
	
	img_back = love.graphics.newImage("img/back.jpg");
	
	editor_status = "normal";
	
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
	object_status=1;
	hexes_status=1;
	input_size_w=map_w;
	input_size_h=map_h;
	central_hex_x=10;
	central_hex_y=10;
	even = 1;
	buildings_x=0;
	buildings_y=0;
	frame_x1=100;
	frame_y1=100;
	frame_x2=200;
	frame_y2=200;
	
	hex_tile = love.graphics.newQuad(745,172, tile_w+2, tile_h+2, 1024, 1024);
	white_tile = love.graphics.newQuad(745, 257, tile_w+2, tile_h+2, 1024, 1024);
	red_tile = love.graphics.newQuad(745, 257, tile_w+2, tile_h+2, 1024, 1024);
	door_tile = love.graphics.newQuad(893, 215, tile_w+2, tile_h+2, 1024, 1024);
	cursor_red = love.graphics.newQuad(819, 257, tile_w+2, tile_h+2, 1024, 1024);
	yellow_tile = love.graphics.newQuad(745, 215, tile_w+2, tile_h+2, 1024, 1024);
	
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

	cursor_world_x=0;
	cursor_world_y=0;
	
	savename = "building.lua";
	hex_table={};
	for i=1,20 do
		hex_table[i] = {};
		for h=1,30 do
			hex_table[i][h] = 0;
		end;
	end;
end;
 
function love.update(dt)
	love.mousepressed(x, y, button);
	mX, mY = love.mouse.getPosition();
	cursor_world_y=math.ceil((mY-top_space)/tile_h*4/3);
	if cursor_world_y/2 == math.ceil(cursor_world_y/2) then
		cursor_world_x=math.ceil((mX-left_space)/tile_w+1);
	else
		cursor_world_x=math.ceil((mX-left_space)/tile_w+0.5);
	end;
	
	if love.keyboard.isDown("rctrl") then
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
	
	loveframes.update(dt);
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
	local add = 0;
	if not love.keyboard.isDown("lshift") and not love.keyboard.isDown("lctrl") then
		add = 1
	elseif not love.keyboard.isDown("lctrl") then
		add = 10;
	else
		add = 100;
	end;
	if key == 'escape'  then
		editor_status='normal';
	end;
	if love.keyboard.isDown("lctrl") and key == 'h'  then
		editor_status='help';
	end;
	if love.keyboard.isDown("lctrl") and key == 'e'  then
		even = -1*even;
	end;
	if love.keyboard.isDown("lctrl") and key == 'm'  then
		showmouse = -1*showmouse;
		if showmouse == 1 then
			love.mouse.setVisible(true);
		else
			love.mouse.setVisible(false);
		end;
	end;
	
	if love.keyboard.isDown("lctrl") and not love.keyboard.isDown("lshift") and key == 's'  then
		local door_coords = find_door();
		local hexarray1 = count_hexes (true);
		local hexarray2 = count_hexes (false);
		local addx,addy = count_add(hexarray1);
		save(false,-1*(buildings_x-frame_x1),-1*(buildings_y-frame_y1),(frame_x2-frame_x1),(frame_y2-frame_y1),addx,addy,door_coords[1],door_coords[2],door_coords[3],door_coords[4],hexarray1,hexarray2);
	end;
	
	if love.keyboard.isDown("lctrl") and love.keyboard.isDown("lshift") and key == 's'  then
		local door_coords = find_door();
		local hexarray1 = count_hexes (true);
		local hexarray2 = count_hexes (false);
		local addx,addy = count_add(hexarray1);
		save(true,-1*(buildings_x-frame_x1),-1*(buildings_y-frame_y1),(frame_x2-frame_x1),(frame_y2-frame_y1),addx,addy,door_coords[1],door_coords[2],door_coords[3],door_coords[4],hexarray1,hexarray2);
	end;
	
	if key == 'right'  then
		buildings_x = buildings_x-add;
	end;
	if key == 'left'  then
		buildings_x = buildings_x+add;
	end;
	if key == 'down'  then
		buildings_y = buildings_y-add;
	end;
		if key == 'up'  then
		buildings_y = buildings_y+add;
	end;
	if love.keyboard.isDown("rctrl") then
		frame_x1=mX;
		frame_y1=mY;
		frame_x2=mX+1;
		frame_y2=mY+1;
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
   loveframes.keypressed(key, unicode);
end;

----

function love.mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button);
end

function love.mousereleased(x, y, button)
	if not love.keyboard.isDown("lctrl") and not love.keyboard.isDown("lshift") and not love.keyboard.isDown("rctrl") then
		if hex_table[cursor_world_x][cursor_world_y] == 0 then
			hex_table[cursor_world_x][cursor_world_y] = 1;
		else
			hex_table[cursor_world_x][cursor_world_y] = 0;
		end;
	elseif not love.keyboard.isDown("lshift") and not love.keyboard.isDown("rctrl") then
		central_hex_x = cursor_world_x;
		central_hex_y = cursor_world_y;
		for my=1, 30 do
			for mx=1, 20 do	
				if hex_table[mx][my] == 2 then
					hex_table[mx][my] = 0;
				end;
			end;
		end;
	elseif not love.keyboard.isDown("rctrl") then
		if door_hex_x ~= cursor_world_x or door_hex_y ~= cursor_world_y then
			door_hex_x = cursor_world_x;
			door_hex_y = cursor_world_y;
		else
			door_hex_x = nil;
			door_hex_y = nil;
		end;
		for my=1, 30 do
			for mx=1, 20 do	
				if hex_table[mx][my] == 3 then
					hex_table[mx][my] = 0;
				end;
			end;
		end;
	end;
    loveframes.mousereleased(x, y, button);
end;

function love.mousereleased(x, y, button)
	if not love.keyboard.isDown("lctrl") and not love.keyboard.isDown("lshift") and not love.keyboard.isDown("rctrl") then
		if hex_table[cursor_world_x][cursor_world_y] == 0 then
			hex_table[cursor_world_x][cursor_world_y] = 1;
		else
			hex_table[cursor_world_x][cursor_world_y] = 0;
		end;
	elseif not love.keyboard.isDown("lshift") and not love.keyboard.isDown("rctrl") then
		central_hex_x = cursor_world_x;
		central_hex_y = cursor_world_y;
		for my=1, 30 do
			for mx=1, 20 do	
				if hex_table[mx][my] == 2 then
					hex_table[mx][my] = 0;
				end;
			end;
		end;
	elseif not love.keyboard.isDown("rctrl") then
		if door_hex_x ~= cursor_world_x or door_hex_y ~= cursor_world_y then
			door_hex_x = cursor_world_x;
			door_hex_y = cursor_world_y;
		else
			door_hex_x = nil;
			door_hex_y = nil;
		end;
		for my=1, 30 do
			for mx=1, 20 do	
				if hex_table[mx][my] == 3 then
					hex_table[mx][my] = 0;
				end;
			end;
		end;
	end;
    loveframes.mousereleased(x, y, button);
end;

function love.textinput(text)
    -- your code
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

function draw_cursor ()
	if not love.keyboard.isDown("rctrl") then
		drawHex(cursor_world_x,cursor_world_y,cursor_red);
	end;
end;

function save(create_new_file,x,y,w,h,addx,addy,doorev_x,doorev_y,doorne_x,doorne_y,hexesev,hexesne)
	local addx_hex = math.ceil(addx/32);
	local addy_hex = math.ceil(addy/16);
	local data = "\r\n" .. "{img=media.images.buildings1,sprite=love.graphics.newQuad(" .. x .. "," .. y .. "," .. w .. "," .. h .. ", media.images.buildings1:getWidth(), media.images.buildings1:getHeight()),addx=" .. addx_hex .. ",addy=" .. addy_hex .. ","
  .. "\r\n" .. "door_ev={" .. doorev_x .. "," .. doorev_y .. "},door_ne={" .. doorne_x .. "," .. doorne_y .. "},"
  .. "\r\n" .. "hexes_ne=" .. Tserial.pack(hexesev, true, false) .. ",hexes_ev=" .. Tserial.pack(hexesne, true, false) .. "},";
	if create_new_file then
		love.filesystem.write(savename,data);
	 else
		love.filesystem.append(savename,data);
	 end;
	print("SAVED!");
	editor_status = "saved";
end;

function drawHex (x,y,hex)
	moveto_hex_y = math.ceil((y-1)*tile_h*0.75+top_space);
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2)*tile_w+left_space;
	else
		moveto_hex_x = (x-2)*tile_w+tile_w/2+left_space;
	end;
	love.graphics.draw(img_hex, hex, moveto_hex_x, moveto_hex_y);
end;

function draw_numbers()
	local add = 0;
	local addx = 0;
	if even == -1 then
		add = 1;
	end;
	for my=1, 30 do
		for mx=1, 20 do
			if central_hex_y/2 ~= math.ceil(central_hex_y/2) then
				if my/2 == math.ceil(my/2) then
					addx = central_hex_x-mx + add;
				else
					addx = central_hex_x-mx;
				end;
			else
				if my/2 ~= math.ceil(my/2) then
					addx = central_hex_x-mx - add;
				else
					addx = central_hex_x-mx;
				end;
			end;
			drawNumberHex (mx,my,5,addx);
			drawNumberHex (mx,my,25,"x");
			drawNumberHex (mx,my,40,central_hex_y-my);
		end;
	end;
	love.graphics.setColor(255, 255, 255);
 end;
 
function find_door ()
	local add = 0;
	local addx = 0;
	local door_coords={0,0,0,0};
	for i=1, 2 do
		add = i-1;
		for my=1, 30 do
			for mx=1, 20 do
				if hex_table[mx][my] == 3 then
					if central_hex_y/2 ~= math.ceil(central_hex_y/2) then
						if my/2 == math.ceil(my/2) then
							addx = central_hex_x-mx + add;
						else
							addx = central_hex_x-mx;
						end;
					else
						if my/2 ~= math.ceil(my/2) then
							addx = central_hex_x-mx - add;
						else
							addx = central_hex_x-mx;
						end;
					end;
					door_coords[i] = addx;
					door_coords[i+1] = central_hex_y-my;
				end;
			end;
		end;
	end;
	return door_coords;
end;

function count_hexes (evenornot)
	local addx = 0;
	local add = 0;
	local hex_array = {};
	add = 0;
	for my=1, 30 do
		for mx=1, 20 do
			if hex_table[mx][my] > 0 then
				if not evenornot then
					if cursor_world_y/2 == math.ceil(cursor_world_y/2) then
						addx = central_hex_x-mx;
					else
						if my/2 ~= math.ceil(my/2) then
							addx = central_hex_x-mx - 1;
						else
							addx = central_hex_x-mx;
						end;
					end;
				else
					if cursor_world_y/2 == math.ceil(cursor_world_y/2) then
						if my/2 ~= math.ceil(my/2) then
							addx = central_hex_x-mx - 1;
						else
							addx = central_hex_x-mx;
						end;
					else
						addx = central_hex_x-mx;
					end;
				end;
				table.insert(hex_array,{addx,central_hex_y-my});
			end;
		end;
	end;
	return hex_array;
end;

function drawNumberHex (x,y,add,txt)
	moveto_hex_y = math.ceil((y-1)*tile_h*0.75+top_space)+8;
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2)*tile_w+left_space+add;
	else
		moveto_hex_x = (x-2)*tile_w+tile_w/2+left_space+add;
	end;
	love.graphics.print(txt,moveto_hex_x,moveto_hex_y);
end;

function count_add (hex_array)
	local addx = 0;
	local addy = 0;
	local min_hex_x = 0;
	local max_hex_x = 0;
	local min_hex_y = 0;
	local max_hex_y = 0;
	for i=1,#hex_array do
		if hex_array[i][1] < min_hex_x then
			min_hex_x = hex_array[i][1];
		elseif hex_array[i][1] > max_hex_x then
			max_hex_x = hex_array[i][1];
		end;
		if hex_array[i][2] < min_hex_y then
			min_hex_y = hex_array[i][2];
		elseif hex_array[i][2] > max_hex_y then
			max_hex_y = hex_array[i][2];
		end;
	end;
	local addx = -1*math.abs(max_hex_x-min_hex_x)/2;
	local addy = -1*math.abs(max_hex_y-min_hex_y)/2;
	return addx,addy;
end;

function love.draw()
	love.graphics.setFont(mainFont);
	if editor_status == "normal" then
		love.graphics.draw(img_back, 0,0);
		love.graphics.draw(media.images.buildings1, buildings_x,buildings_y);
		draw_hexfield();
		draw_numbers();
		 sometable = {

			frame_x1,frame_y1,
			frame_x2,frame_y1,
			frame_x2,frame_y2,
			frame_x1,frame_y2,
			frame_x1,frame_y1,
		}
		love.graphics.setColor(255, 0, 0);
		love.graphics.line(sometable);
		love.graphics.setColor(255, 255, 255);
		draw_cursor();
	end;
	if editor_status == "help" then
		love.graphics.print("[LCTRL]+[H] - this screen (вызов справки)", 40,30);
		love.graphics.print("[LCTRL]+[E] - numbers for even/not even row (числа для чётных и нечётных рядов)", 40,50);
		love.graphics.print("[LCTRL]+LMB - initial point (начальная точка)", 40,70);
		love.graphics.print("[LSHIFT]+LMB - mark door (пометить дверь)", 40,90);
		love.graphics.print("[UP]/[DOWN]/[LEFT]/[RIGHT] - move image (движение изображения)", 40,110);
		love.graphics.print("[SAME]+[LSHIFT] - speed x10 (скорость x10)", 40,130);
		love.graphics.print("[SAME]+[LCTRL]+[LSHIFT] - speed x100 (скорость x100)", 40,150);
		love.graphics.print("[LCTRL]+[S] - save-append (сохранить, дописать)", 40,170);
		love.graphics.print("[LCTRL]+[LSHIFT]+[S] - save-rewrite (сохранить, переписать)", 40,190);
		love.graphics.print("[RCTRL] - mark quad (разметить спрайт)", 40,210);
		love.graphics.print("[ESC] - quit help (выйти из справки)", 40,230);
	end;

	love.graphics.draw(img_hud, 0,0);
	--draw_hexbuttons();
	love.graphics.print("[LCTRL]+[H]elp (Справка) ", 460, 10);
	local picture_coords = -1*buildings_x .. " x " .. -1*buildings_y;
	love.graphics.print(picture_coords, 100, 10);
	if editor_status == "saved" then
		love.graphics.print("SAVED!", 450, 400);
    end
    
    local addx = 1025;
    local addy = 30;
    local scale = 0.1;
    local wxh = media.images.buildings1:getWidth()*scale;
	
	love.graphics.draw(media.images.buildings1,addx,addy,0,scale,scale);
	sometable = {
	addx,addy,
	addx+wxh,addy,
	addx+wxh,addy+wxh,
	addx,wxh+addy,
	addx,addy,
	
	}
	love.graphics.setColor(0, 0, 0);
	local frame_w = 100;
	local frame_h = 70;
	love.graphics.line(sometable);
	sometable = {
		addx-buildings_x*scale,-buildings_y*scale+addy,
		addx-buildings_x*scale+frame_w,-buildings_y*scale+addy,
		addx-buildings_x*scale+frame_w,-buildings_y*scale+addy+frame_h,
		addx-buildings_x*scale,-buildings_y*scale+addy+frame_h,
		addx-buildings_x*scale,-buildings_y*scale+addy,
	}
	love.graphics.setColor(255, 0, 0);
	love.graphics.line(sometable);
	love.graphics.setColor(255, 255, 255);
	local hexarray = count_hexes (true);
	love.graphics.print(#hexarray,250,10);
	love.graphics.print(cursor_world_y,750,10);
    loveframes.draw();
end;
