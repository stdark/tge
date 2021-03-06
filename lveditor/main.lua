--level_editor

jit.on();
love.keyboard.setKeyRepeat(0.01, 0.2);

loadingState = require 'functions.loadingState';
playingState = require 'functions.playingState';

require "lib.loveframes";
require 'functions.utils';

currentState = nil;
nextState = nil;
nextStateName = "playingState";

media = { images = {}, sounds = {} };

function loadingFinished()
  utils.printDebug("loading finished");
  currentState = nextState;
  currentState.start(media);
end;

function love.load()
	debug = true;
	global = {};
	global.level_to_load = 0;
	global.screenWidth = love.graphics.getWidth();
	global.screenHeight = love.graphics.getHeight();
	global.first_load = true;
	global.buttons={};
	global.level_to_load = 1;
	--font = love.graphics.newFont("fonts/Neocyr.ttf", 16);
	--font = love.graphics.newFont("fonts/DroidSans.ttf", 16);
	--font = love.graphics.newFont("fonts/HoMMFontCyr.ttf", 16);
	--love.graphics.setFont(font);
	img_preloader =  love.graphics.newImage("img/loadscreens/preloader0.dds");
	currentState = loadingState;
	nextState = playingState;
	currentState.start(media, loadingFinished);
	randomX = os.time();
	randomize = {};
	local tmp = 0;
	rndCounter = 1;
	randomize[1],tmp = math.modf((84589*randomX + 45989),(217728));
	for i=2,20 do
		randomize[i],tmp = math.modf((84589*randomize[i-1] + 45989 ),(217728));
	end;
	--love.window.setMode(1366, 768, {resizable=false});
	--love.window.setMode(1920, 1080, {resizable=true});
	--love.window.setMode(1280, 960, {resizable=false});
	local width, height = love.window.getDesktopDimensions(1); -- get our display size
	love.window.setMode(width, height, {resizable=false}); 
end;

function love.update(dt)
	--math.randomseed(os.time()*utils.getseed ());
	global.screenWidth = love.graphics.getWidth();
	global.screenHeight = love.graphics.getHeight();
	fps = love.timer.getFPS( );
	randomXX = os.time();
	if randomX ~= randomXX then
		randomX = randomXX;
		randomize = {};
		local tmp = 0;
		rndCounter = 1;
		randomize[1],tmp = math.modf((84589*randomX + 45989),(217728));
		for i=2,20 do
			randomize[i],tmp = math.modf((84589*randomize[i-1] + 45989 ),(217728));
		end;
	end;
	math.randomseed(randomize[rndCounter]);
	rndCounter = rndCounter + 1;
	if rndCounter >= 20 then
		rndCounter = 1;
	end;
	currentState.update(dt);
	loveframes.update(dt);
end;

function love.keypressed(key)
  if currentState.keypressed then
    currentState.keypressed(key)
  end 
  loveframes.keypressed(x, y, button);
end

function love.keyreleased(key)
  if currentState.keyreleased then
    currentState.keyreleased(key)
  end
  loveframes.keyreleased(x, y, button);
end

function love.mousepressed(x,y,button)
  if currentState.mousepressed then
    currentState.mousepressed(x,y,button)
  end
  loveframes.mousepressed(x, y, button);
end

function love.mousereleased(x,y,button)
  if currentState.mousereleased then
    currentState.mousereleased(x,y,button)
  end
  loveframes.mousereleased(x, y, button);
end

function love.textinput(text)
    loveframes.textinput(text); 
end;

function love.draw()
	currentState.draw();
	loveframes.draw();
 end;
 
