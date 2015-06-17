local loader = require 'lib.love-loader'
require "data.party"
require "data.inventory"

local mainmenuState = {}
local margin = 200;
local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight();

--[[
image = love.graphics.newImage("img/obj_dark.png" )
ParticleSystem = love.graphics.newParticleSystem(image,200)
ParticleSystem:setParticleLifetime(20,25)
ParticleSystem:setEmissionRate(10)
ParticleSystem:setPosition(200, 200)
ParticleSystem:setLinearAcceleration( -0.5, 5, 0.5, 10 )
ParticleSystem:setSpread(1)
ParticleSystem:start()
]]
local _image = love.graphics.newImage("img/particles/image_particle_2.png" );
ParticleSystem = love.graphics.newParticleSystem(_image,20);
local _texture = love.graphics.newImage("img/particles/image_particle_2.png" );
ParticleSystem:setTexture(_texture);
ParticleSystem:setBufferSize(20);
ParticleSystem:setParticleLifetime(3,5);
ParticleSystem:setEmissionRate(20);
ParticleSystem:setSpeed(250)
ParticleSystem:setLinearAcceleration( -15, -17, 15, 17);
--ParticleSystem:setLinearDamping( 10, 20 )
ParticleSystem:setSpread(360);
ParticleSystem:setRelativeRotation(true)
ParticleSystem:setSpin(0,1)
ParticleSystem:setSpinVariation(1)
ParticleSystem:setSizes(0.25,0.5,0.75,1)
ParticleSystem:setSizeVariation(1)
ParticleSystem:setRotation(0,1)

--ParticleSystem:start()

function mainmenuState.start(media)
	utils.printDebug("MENU!");
	mainmenuState.load();
end;

function mainmenuState.load()
	love.audio.play(media.sounds.mainmenu, 0);
	mainmenuState.drawButtons ();
end;

function mainmenuState.drawButtons ()
   local background_image = media.images.button10;                            -- background image for menu buttons
   local x_position = (global.screenWidth - background_image:getWidth()) / 2; -- x position for menu images

   -- start game
   global.buttons.start_button = loveframes.Create("imagebutton");
   global.buttons.start_button:SetImage(background_image);
   --global.buttons.start_button:SetPos(global.screenWidth - margin - media.images.button1:getWidth(),200);
   -- global.buttons.start_button:SetPos(global.screenWidth - margin - media.images.button1:getWidth() - 250 ,200);))
   global.buttons.start_button:SetPos(x_position+300, 200);
   global.buttons.start_button:SizeToImage()
   global.buttons.start_button:SetText(lognames.buttons.startgame);
   global.buttons.start_button.OnClick = function(object)
      global.grail_level,global.grail_x,global.grail_y,global.grail_maparray =  utils.generateHolyGrail ();
      mainmenuState.startGame ();
   end;
   -- create party
   global.buttons.create_button = loveframes.Create("imagebutton");
   global.buttons.create_button:SetImage(background_image);
   --global.buttons.create_button:SetPos(global.screenWidth - margin - media.images.button1:getWidth(),350);
   -- global.buttons.create_button:SetPos(global.screenWidth - margin - media.images.button1:getWidth() - 250,350);
   global.buttons.create_button:SetPos(x_position+300, 350);
   global.buttons.create_button:SizeToImage()
   global.buttons.create_button:SetText(lognames.buttons.createparty);
   global.buttons.create_button.OnClick = function(object)
      mainmenuState.createParty ();
   end;
end;

function mainmenuState.update (dt)
	ParticleSystem:update( dt )
end;

function mainmenuState.startGame ()
	game_status = "neutral";
	global.level_to_load = 1;
	charfaces={};
	for i=1,12 do
		for h=1,12 do
			local tmpf=((h-1)*12+i);
			charfaces[tmpf] = love.graphics.newQuad((i-1)*80, (h-1)*90, 80,90, media.images.charfaces:getWidth(), media.images.charfaces:getHeight());
		end;
	end;
	inventory_load ();
	party_load ();
	loveframes.util.RemoveAll();
	nextState = playingState;
	nextStateName = "playingState";
	currentState = loadingState;
	currentState.start(media, loadingFinished);
	local roll = math.random(1,3);
	local tmp = "media.images.preloader" .. roll;
	img_preloader = loadstring("return " .. tmp)();
end;

function mainmenuState.createParty ()
	loveframes.util.RemoveAll();
	nextState = createpartyState;
	nextStateName = "createPartyState";
	currentState = loadingState;
	currentState.start(media, loadingFinished);
	img_preloader =  love.graphics.newImage("img/loadscreens/preloader0.dds");
end;

function mainmenuState.keypressed(key)

end;

function mainmenuState.keyreleased(key)

end;

function mainmenuState.mousepressed(x,y,button)

end;

function mainmenuState.mousereleased(x,y,button)

end;

function mainmenuState.draw()
	love.graphics.draw(media.images.mainmenuback, math.ceil((global.screenWidth-img_preloader:getWidth())/2),math.ceil((global.screenHeight-img_preloader:getHeight())/2));
	--love.graphics.draw(ParticleSystem,200,200,0,1,1)
end;

return mainmenuState
