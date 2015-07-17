--game
require 'functions.utils';
utils.printDebug(_VERSION);

-- check luajit, to prevent falling if luajit is not installed
if jit then
   jit.on();				-- an run if any
   utils.printDebug("Running with luajit");
else					-- else run without luajit
   utils.printDebug("Running WITHOUT luajit");
end

love.keyboard.setKeyRepeat(0.01, 0.2);

loadingState = require 'functions.loadingState';
mainmenuState = require 'functions.mainmenuState';
createpartyState = require 'functions.createpartyState';
playingState = require 'functions.playingState';

require "lib.loveframes";

--require "lib.utf8"

currentState = nil;
nextState = nil;
nextStateName = "mainmenuState";

media = { images = {}, sounds = {} };

function loadingFinished()
  utils.printDebug("loading finished");
  currentState = nextState;
  currentState.start(media);
end;

function love.load()
	debug = false;
	global = {};
	global.level_to_load = 0;
	global.screenWidth = love.graphics.getWidth();
	global.screenHeight = love.graphics.getHeight();
	global.first_load = true;
	global.buttons={};
	--font = love.graphics.newFont("fonts/Neocyr.ttf", 16);
	font = love.graphics.newFont("fonts/DroidSans.ttf", 16);
	--font = love.graphics.newFont("fonts/HoMMFontCyr.ttf", 16);
	love.graphics.setFont(font);
	loveframes.util.SetActiveSkin("GreyStone");
	img_preloader =  love.graphics.newImage("img/loadscreens/preloader0.dds");
	currentState = loadingState;
	nextState = mainmenuState;
	currentState.start(media, loadingFinished);

	randomX = os.time();          -- take seconds from 'epoch' as base for random
	utils.initRandomize(randomX); -- init randomize arrray

	--love.window.setMode(1920, 1080, {resizable=true});
	--love.window.setMode(1280, 960, {resizable=false});
	-- love.window.setMode(1200, 600, {resizable=false});
	local width, height = love.window.getDesktopDimensions(1);  -- get our display size
	love.window.setMode(width, height, {resizable=false});      -- set screen size
	
	global.music_mainmenu = 0;
	global.music_battle = 0;
	global.music_peace = 0;
	global.music_switch_to = "mainmenu";
	global.theme_music_array = {};
	global.theme_music_volume = 1;
	global.theme_sfx_volume = 1;
end;

function love.update(dt)
	--math.randomseed(os.time()*utils.getseed ());
	global.screenWidth = love.graphics.getWidth();
	global.screenHeight = love.graphics.getHeight();
	fps = love.timer.getFPS( );
	local randomXX = os.time();
	if randomX ~= randomXX then
		randomX = randomXX;
		utils.initRandomize(randomX);
	end;
	utils.randommore(); 	-- init lua random generator
	utils.themeMusicVolumeDynamic ()
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
