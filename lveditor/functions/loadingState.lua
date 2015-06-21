--level_editor
 
local loader = require 'lib.love-loader';
local spiral;
local spiralAngle = 0;

local function drawSpiral()
  local w,h = spiral:getWidth(), spiral:getHeight()
  local x,y =  w/2 + 20, global.screenHeight - h/2 -20;
  love.graphics.draw(spiral, x, y, spiralAngle, 1, 1, w/2, h/2)
end

local function drawLoadingBar()
  local separation = 30;
  local w = global.screenWidth - 2*separation - spiral:getWidth() -20;
  local h = 25;
  local x,y = separation + spiral:getWidth() + 20 , global.screenHeight - separation - spiral:getHeight()/2;
  
  love.graphics.rectangle("line", x, y, w, h)

  x, y = x + 3, y + 3
  w, h = w - 6, h - 7

  if loader.loadedCount > 0 then
    w = w * (loader.loadedCount / loader.resourceCount)
  end
  love.graphics.rectangle("fill", x, y, w, h)
end

-- the state

local loadingState = {}

function loadingState.start(media, finishCallback)
	if global.level_to_load and global.level_to_load > 0 then
		package.loaded[ 'levels.level1' ] = nil;
		package.loaded[ 'levels.level2' ] = nil;
		if global.level_to_load == 1 then
			require "levels.level1"
		elseif global.level_to_load == 2 then
			require "levels.level2"
		end;
		level ();
	end;
	
	spiral = love.graphics.newImage('img/spiral.dds');
	if nextStateName == "playingState" then
		loader.newImage(media.images, "back", images_table[1]);
		loader.newImage(media.images, "hex", images_table[2]);
		loader.newImage(media.images, "obj", images_table[3]);
		if global.first_load  then
			loader.newImage(media.images, "hud_bottom_left", "img/hud/hud_bottom_left.png");
			loader.newImage(media.images, "hud_bottom_right", "img/hud/hud_bottom_right.png");
			loader.newImage(media.images, "hud_bottom_tile", "img/hud/hud_bottom_tile.png");		
			loader.newImage(media.images, "hud_top_left", "img/hud/hud_top_left.png");
			loader.newImage(media.images, "hud_top_right", "img/hud/hud_top_right.png");
			loader.newImage(media.images, "hud_top_tile", "img/hud/hud_top_tile.png");
			loader.newImage(media.images, "hud_top_center", "img/hud/hud_top_center.png");
			loader.newImage(media.images, "hud_left_tile", "img/hud/hud_left_tile.png");
			loader.newImage(media.images, "hud_right_tile", "img/hud/hud_right_tile.png");
			loader.newImage(media.images, "hud_right_wall_tile", "img/hud/hud_right_wall_tile.png");
			loader.newImage(media.images, "harvest", "img/harvest.dds");
			loader.newImage(media.images, "img", "img/hex_landscape.dds");
			loader.newImage(media.images, "imgsub", "img/hex_landscape.dds");
			loader.newImage(media.images, "img_obj", "img/hex_foreground.dds");
			loader.newImage(media.images, "img_back", "img/background.dds");
			loader.newImage(media.images, "img_map", "img/map.png");
			loader.newImage(media.images, "buildings1", "img/buildings1.dds");
			loader.newImage(media.images, "tmpobjs","/img/img_tmpobjs.dds");
		end;
	end;
	utils.printDebug("started loading")
	print("finishCallback",finishCallback);
	loader.start(finishCallback, print)
end

function loadingState.draw()
  love.graphics.draw(img_preloader, math.ceil((global.screenWidth-img_preloader:getWidth())/2),math.ceil((global.screenHeight-img_preloader:getHeight())/2));
  drawSpiral()
  drawLoadingBar()
end

function loadingState.update(dt)
  loader.update()
  spiralAngle = spiralAngle + 2*dt
end

return loadingState
