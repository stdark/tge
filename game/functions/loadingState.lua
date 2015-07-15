-- game

local loader = require 'lib.love-loader'
require "data.sprites"
require "data.buildings"
buildings_data ();

local spiral
local spiralAngle = 0

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

local loadingState = {};

function loadingState.start(media, finishCallback)
	if global.level_to_load and global.level_to_load > 0 then
		package.loaded[ 'levels.level1' ] = nil;
		package.loaded[ 'levels.level2' ] = nil;
		if global.level_to_load == 1 then
			require "levels.level1"
			loader.newSource(media.sounds, "peace", "music/location_1.ogg");
		elseif global.level_to_load == 2 then
			require "levels.level2"
			loader.newSource(media.sounds, "peace", "music/location_2.ogg");
		end;
		level ();
	end;
	
	spiral = love.graphics.newImage('img/spiral.dds');
	if nextStateName == "mainmenuState" then
		loader.newImage(media.images, "mainmenuback", "img/loadscreens/mainmenuback.dds");
		loader.newImage(media.images, "button1", "img/buttons/button1.dds"); -- ?
		loader.newImage(media.images, "button10", "img/buttons/button10.dds");
		loader.newSource(media.sounds, "mainmenu", "music/mainmenu.ogg");
		loader.newImage(media.images, "charfaces", "img/charfaces.dds"); -- FIXME for tests only
		loader.newImage(media.images, "preloader1","img/loadscreens/preloader1.dds");
		loader.newImage(media.images, "preloader2","img/loadscreens/preloader2.dds");
		loader.newImage(media.images, "preloader3","img/loadscreens/preloader3.dds");
		loader.newImage(media.images, "gameover","img/gameover.dds");
	elseif nextStateName == "createPartyState" then
		loader.newImage(media.images, "createpartyback", "img/loadscreens/createpartyback.dds");
		loader.newImage(media.images, "button2", "img/buttons/button2.dds");
		loader.newImage(media.images, "button3", "img/buttons/button3.dds");
		loader.newImage(media.images, "button4", "img/buttons/button4.dds");
		loader.newImage(media.images, "button5", "img/buttons/button5.dds");
		loader.newImage(media.images, "button6", "img/buttons/button6.dds");
		loader.newImage(media.images, "charfaces", "img/charfaces.dds");
		loader.newImage(media.images, "ui", "img/ui.dds"); --FIXME
	elseif nextStateName == "playingState" then
		loader.newImage(media.images, "back", images_table[1]);
		loader.newImage(media.images, "hex", images_table[2]);
		loader.newImage(media.images, "obj", images_table[3]);
		
		if not media.images.buildings then
			media.images.buildings = {};
		end;
		for i=1,#buildings_stats do
			loader.newImage(media.images.buildings, "building" .. i, buildings_stats[i].img);
		end;
		
		if global.first_load  then
			loader.newImage(media.images, "hex_ui", "img/hex_ui.dds");
			loader.newImage(media.images, "hud_bottom_left", "img/hud/hud_bottom_left.dds");
			loader.newImage(media.images, "hud_bottom_right", "img/hud/hud_bottom_right.dds");
			loader.newImage(media.images, "hud_bottom_tile", "img/hud/hud_bottom_tile.dds");		
			loader.newImage(media.images, "hud_top_left", "img/hud/hud_top_left.dds");
			loader.newImage(media.images, "hud_top_right", "img/hud/hud_top_right.dds");
			loader.newImage(media.images, "hud_top_tile", "img/hud/hud_top_tile.dds");
			loader.newImage(media.images, "hud_top_center", "img/hud/hud_top_center.dds");
			loader.newImage(media.images, "hud_left_tile", "img/hud/hud_left_tile.dds");
			loader.newImage(media.images, "hud_right_tile", "img/hud/hud_right_tile.dds");
			loader.newImage(media.images, "map", "img/map.dds");
			loader.newImage(media.images, "mindgame_icons_img", "img/mindgame_icons.dds");
			loader.newImage(media.images, "gobelen", "img/gobelen.dds");
			loader.newImage(media.images, "inv1", "img/inv1.dds");
			loader.newImage(media.images, "inv2", "img/inv2.dds");
			loader.newImage(media.images, "alch", "img/alch.dds");
			loader.newImage(media.images, "picklock", "img/picklock.dds");
			loader.newImage(media.images, "stats", "img/stats.dds");
			loader.newImage(media.images, "skills", "img/skills.dds");
			loader.newImage(media.images, "mindgame", "img/mindgame.dds");
			loader.newImage(media.images, "sellidentfix", "img/sellidentfix.dds");
			loader.newImage(media.images, "shoparmor", "img/shoparmor.dds");
			loader.newImage(media.images, "shopmelee", "img/shopmelee.dds");
			loader.newImage(media.images, "shopbooks", "img/shopbooks.dds");
			loader.newImage(media.images, "shopalchemy", "img/shopalchemy.dds");
			loader.newImage(media.images, "ui", "img/ui.dds");
			loader.newImage(media.images, "mobfaces", "img/mobfaces.dds");	-- FIXME
			loader.newImage(media.images, "npcfaces", "img/npcfaces.dds"); -- TWO FILES LATER
			loader.newImage(media.images, "dark", "img/obj_dark.dds");
			loader.newImage(media.images, "greenface", "img/greenface.dds");
			loader.newImage(media.images, "m", "img/bolt.dds");
			loader.newImage(media.images, "book", "img/book.dds");
			loader.newImage(media.images, "sbook", "img/spellbook.dds");
			loader.newImage(media.images, "wbook", "img/warbook.dds");
			loader.newImage(media.images, "msg", "img/message.dds");
			
			loader.newImage(media.images, "animatedobjects","/img/animatedobjects.dds");
			loader.newImage(media.images, "animatedobjects_hex","/img/animatedobjects_hex.dds");
			
			loader.newImage(media.images, "page_1", "img/spellbook/spellbook_fire.dds");
			loader.newImage(media.images, "page_2", "img/spellbook/spellbook_air.dds");
			loader.newImage(media.images, "page_3", "img/spellbook/spellbook_water.dds");
			loader.newImage(media.images, "page_4", "img/spellbook//spellbook_earth.dds");
			loader.newImage(media.images, "page_5", "img/spellbook/spellbook_body.dds");
			loader.newImage(media.images, "page_6", "img/spellbook/spellbook_mind.dds");
			loader.newImage(media.images, "page_7", "img/spellbook/spellbook_spirit.dds");
			loader.newImage(media.images, "page_8", "img/spellbook/spellbook_light.dds");
			loader.newImage(media.images, "page_9", "img/spellbook/spellbook_darkness.dds");
			loader.newImage(media.images, "page_10", "img/spellbook/spellbook_conflux.dds");
			loader.newImage(media.images, "page_11", "img/spellbook/spellbook_life.dds");
			loader.newImage(media.images, "page_12", "img/spellbook/spellbook_conjuction.dds");
			loader.newImage(media.images, "page_13", "img/spellbook/spellbook_distortion.dds");
			loader.newImage(media.images, "page_14", "img/spellbook/spellbook_holy.dds");
			
			loader.newImage(media.images, "wbpage_1", "img/warbook/warbook_1.dds");
			loader.newImage(media.images, "wbpage_2", "img/warbook/warbook_2.dds");
			loader.newImage(media.images, "wbpage_3", "img/warbook/warbook_3.dds");
			loader.newImage(media.images, "wbpage_4", "img/warbook/warbook_4.dds");
			--
			loader.newImage(media.images, "items1", "img/img_items_1.dds");
			loader.newImage(media.images, "items2", "img/img_items_2.dds");
			loader.newImage(media.images, "tmpobjs", "img/img_tmpobjs.dds");
			loader.newImage(media.images, "harvest", "img/harvest.dds");
			loader.newImage(media.images, "boom", "img/effects/sprites_boom.dds");
			loader.newImage(media.images, "buff", "img/effects/sprites_buff.dds");
			loader.newImage(media.images, "missl", "img/effects/sprites_missles.dds");
			loader.newImage(media.images, "spells", "img/effects/sprites_spells.dds");
			loader.newImage(media.images, "waves", "img/effects/sprites_waves.dds");
			--
			--loader.newImage(media.images, "buildings1", "img/buildings1.dds");
			
			loader.newImage(media.images, "button1", "img/buttons/button1.dds");
			loader.newImage(media.images, "button9", "img/buttons/button9.dds");
			
			loader.newImage(media.images, "rogue_base", "img/mobs/img_rogue_base.dds");
			loader.newImage(media.images, "rogue_war", "img/mobs/img_rogue_war.dds");
			loader.newImage(media.images, "rogue_rng", "img/mobs/img_rogue_rng.dds");
			loader.newImage(media.images, "rogue_rng2", "img/mobs/img_rogue_rng2.dds");
			loader.newImage(media.images, "rogue_def", "img/mobs/img_rogue_def.dds");
			
			loader.newImage(media.images, "goblin_base", "img/mobs/img_goblin_base.dds");
			loader.newImage(media.images, "goblin_war", "img/mobs/img_goblin_war.dds");

			loader.newImage(media.images, "golem_base", "img/mobs/img_golem_base.dds");
			loader.newImage(media.images, "golem_war", "img/mobs/img_golem_war.dds");
			
			loader.newImage(media.images, "fireelemental_base", "img/mobs/img_fireelemental_base.dds");
			loader.newImage(media.images, "fireelemental_war", "img/mobs/img_fireelemental_war.dds");
			loader.newImage(media.images, "waterelemental_base", "img/mobs/img_waterelemental_base.dds");
			loader.newImage(media.images, "waterelemental_war", "img/mobs/img_waterelemental_war.dds");
			loader.newImage(media.images, "airelemental_base", "img/mobs/img_airelemental_base.dds");
			loader.newImage(media.images, "airelemental_war", "img/mobs/img_airelemental_war.dds");
			loader.newImage(media.images, "earthelemental_base", "img/mobs/img_earthelemental_base.dds");
			loader.newImage(media.images, "earthelemental_war", "img/mobs/img_earthelemental_war.dds");
			loader.newImage(media.images, "clone_base", "img/mobs/img_clone_base.dds");
			loader.newImage(media.images, "clone_war", "img/mobs/img_clone_war.dds");
			
			loader.newImage(media.images, "comic_bubble", "img/comic_bubble.dds");
			
			loader.newImage(media.images, "comic1_frame1","img/comic/comic1/comic1_frame1.dds");
			loader.newImage(media.images, "comic1_frame2","img/comic/comic1/comic1_frame2.dds");
			loader.newImage(media.images, "comic1_frame3","img/comic/comic1/comic1_frame3.dds");
			loader.newImage(media.images, "comic1_frame4","img/comic/comic1/comic1_frame4.dds");
			loader.newImage(media.images, "comic1_frame5","img/comic/comic1/comic1_frame5.dds");
			loader.newImage(media.images, "comic1_frame6","img/comic/comic1/comic1_frame6.dds");
			loader.newImage(media.images, "comic1_frame7","img/comic/comic1/comic1_frame7.dds");
			loader.newImage(media.images, "comic1_frame8","img/comic/comic1/comic1_frame8.dds");
			loader.newImage(media.images, "comic1_frame9","img/comic/comic1/comic1_frame9.dds");
			loader.newImage(media.images, "comic1_frame10","img/comic/comic1/comic1_frame10.dds");
			
			loader.newImage(media.images, "comic2_frame1","img/comic/comic2/comic2_frame1.dds");
			
			loader.newImage(media.images, "book3_pic1","img/books/book3/book3_pic1.dds");
			loader.newImage(media.images, "book3_pic2","img/books/book3/book3_pic2.dds");
			loader.newImage(media.images, "book3_pic3","img/books/book3/book3_pic3.dds");
			loader.newImage(media.images, "book3_pic4","img/books/book3/book3_pic4.dds");
			loader.newImage(media.images, "book3_pic5","img/books/book3/book3_pic5.dds");
			loader.newImage(media.images, "book1_pic1","img/books/book1/book1_pic1.dds");
			loader.newImage(media.images, "book1_pic2","img/books/book1/book1_pic2.dds");
			loader.newImage(media.images, "book1_pic3","img/books/book1/book1_pic3.dds");
			loader.newImage(media.images, "book1_pic4","img/books/book1/book1_pic4.dds");
			loader.newImage(media.images, "book4_pic1","img/books/book4/book4_pic1.dds");
			loader.newImage(media.images, "book4_pic2","img/books/book4/book4_pic2.dds");
			loader.newImage(media.images, "book11_pic1","img/books/book11/book11_pic1.dds");
			loader.newImage(media.images, "book11_pic2","img/books/book11/book11_pic2.dds");
			loader.newImage(media.images, "book11_pic3","img/books/book11/book11_pic3.dds");
			loader.newImage(media.images, "book13_pic1","img/books/book13/book13_pic1.dds");
			loader.newImage(media.images, "book14_pic1","img/books/book14/book14_pic1.dds");
			loader.newImage(media.images, "book14_pic2","img/books/book14/book14_pic2.dds");
			loader.newImage(media.images, "book14_pic3","img/books/book14/book14_pic3.dds");
			loader.newImage(media.images, "book14_pic4","img/books/book14/book14_pic4.dds");
			loader.newImage(media.images, "book15_pic1","img/books/book15/book15_pic1.dds");
			loader.newImage(media.images, "book15_pic2","img/books/book15/book15_pic2.dds");
			loader.newImage(media.images, "book15_pic3","img/books/book15/book15_pic3.dds");
			loader.newImage(media.images, "book15_pic4","img/books/book15/book15_pic4.dds");
			loader.newImage(media.images, "book15_pic5","img/books/book15/book15_pic5.dds");
			loader.newImage(media.images, "book15_pic6","img/books/book15/book15_pic6.dds");
			loader.newImage(media.images, "book15_pic7","img/books/book15/book15_pic7.dds");
			loader.newImage(media.images, "book15_pic8","img/books/book15/book15_pic8.dds");
			loader.newImage(media.images, "book15_pic9","img/books/book15/book15_pic9.dds");
			loader.newImage(media.images, "book15_pic10","img/books/book15/book15_pic10.dds");

			loader.newImage(media.images, "well_clean","img/wells/well_clean.dds");
			loader.newImage(media.images, "well_magical","img/wells/well_magical.dds");
			loader.newImage(media.images, "well_bad","img/wells/well_bad.dds");
			loader.newImage(media.images, "well_evil","img/wells/well_evil.dds");
			loader.newImage(media.images, "well_dry","img/wells/well_dry.dds");
			loader.newImage(media.images, "well_dungeon","img/wells/well_dungeon.dds");
			
			loader.newImage(media.images, "map1","img/map1.dds");
			
			loader.newImage(media.images, "gobelen1","img/gobelen1.dds");
			
			loader.newSource(media.sounds, "battle", "music/battle.ogg");
			
			loader.newSource(media.sounds, "bookopen", "sounds/book_open.ogg");
			loader.newSource(media.sounds, "bookclose", "sounds/book_close.ogg");
			loader.newSource(media.sounds, "paper", "sounds/paper.ogg");
			loader.newSource(media.sounds, "bookpage", "sounds/book_page.ogg");
			loader.newSource(media.sounds, "invopen", "sounds/inv_open.ogg");
			loader.newSource(media.sounds, "invclose", "sounds/inv_close.ogg");
			loader.newSource(media.sounds, "outofmana", "sounds/outofmana.ogg");
			loader.newSource(media.sounds, "noskill", "sounds/noskill.ogg");
			loader.newSource(media.sounds, "cannotputon", "sounds/cannotputon.ogg");
			loader.newSource(media.sounds, "repair", "sounds/repair.ogg");
			loader.newSource(media.sounds, "magic", "sounds/magic.ogg");
			
			loader.newSource(media.sounds, "spell_fireballimpact", "sounds/spell_fireballimpact.ogg");
			loader.newSource(media.sounds, "spell_iceballimpact", "sounds/spell_iceballimpact.ogg");
			loader.newSource(media.sounds, "spell_flamearrow", "sounds/spell_flamearrow.ogg");
			loader.newSource(media.sounds, "spell_flamearrowimpact", "sounds/spell_flamearrowimpact.ogg");
			loader.newSource(media.sounds, "spell_coldbeam", "sounds/spell_coldbeam.ogg");
			loader.newSource(media.sounds, "spell_coldbeamimpact", "sounds/spell_coldbeamimpact.ogg");
			loader.newSource(media.sounds, "spell_acidburst", "sounds/spell_acidburst.ogg");
			loader.newSource(media.sounds, "spell_acidburstimpact", "sounds/spell_acidburstimpact.ogg");
			loader.newSource(media.sounds, "spell_poisonedspit", "sounds/spell_poisonedspit.ogg");
			loader.newSource(media.sounds, "spell_shocker", "sounds/spell_shocker.ogg");
			loader.newSource(media.sounds, "spell_rezfrom", "sounds/spell_rezfrom.ogg");
			loader.newSource(media.sounds, "spell_rezof", "sounds/spell_rezof.ogg");
			loader.newSource(media.sounds, "spell_stoneskin", "sounds/spell_stoneskin.ogg");
			loader.newSource(media.sounds, "spell_heal", "sounds/spell_heal.ogg");
			loader.newSource(media.sounds, "spell_freeze", "sounds/spell_freeze.ogg");
			loader.newSource(media.sounds, "spell_bell", "sounds/spell_bell.ogg");
			loader.newSource(media.sounds, "spell_fist", "sounds/spell_fist.ogg");
			loader.newSource(media.sounds, "spell_resurrect", "sounds/spell_resurrect.ogg");
			loader.newSource(media.sounds, "spell_rockblast", "sounds/spell_rockblast.ogg");
			loader.newSource(media.sounds, "spell_rockimpact", "sounds/spell_rockimpact.ogg");
			loader.newSource(media.sounds, "spell_toxiccloud", "sounds/spell_toxiccloud.ogg");
			loader.newSource(media.sounds, "spell_toxicimpact", "sounds/spell_toxicimpact.ogg");
			loader.newSource(media.sounds, "spell_meteorsimpact", "sounds/spell_meteorsimpact.ogg");
			loader.newSource(media.sounds, "spell_dragonbreath", "sounds/spell_dragonbreath.ogg");
			loader.newSource(media.sounds, "spell_wizardeye", "sounds/spell_wizardeye.ogg");
			loader.newSource(media.sounds, "spell_torchlight", "sounds/spell_torchlight.ogg");
			
			loader.newSource(media.sounds, "crossbow_shot", "sounds/crossbow_shot.ogg");
			loader.newSource(media.sounds, "sword_impact", "sounds/sword_impact.ogg");
			loader.newSource(media.sounds, "sword_miss", "sounds/sword_miss.ogg");
			loader.newSource(media.sounds, "sword_crit", "sounds/sword_crit.ogg");
			loader.newSource(media.sounds, "block", "sounds/block.ogg");
			loader.newSource(media.sounds, "arrow_impact", "sounds/arrow_impact.ogg");
			
			loader.newSource(media.sounds, "footstep_long_1", "sounds/footstep_1_2.ogg");
			loader.newSource(media.sounds, "footstep_long_2", "sounds/footstep_2_2.ogg");
			loader.newSource(media.sounds, "footstep_long_3", "sounds/footstep_3_2.ogg");
			loader.newSource(media.sounds, "footstep_long_4", "sounds/footstep_4_2.ogg");
			loader.newSource(media.sounds, "footstep_long_5", "sounds/footstep_5_2.ogg");
			loader.newSource(media.sounds, "footstep_long_6", "sounds/footstep_6_2.ogg");
			
			loader.newSource(media.sounds, "footstep_short_1", "sounds/footstep_1_1.ogg");
			loader.newSource(media.sounds, "footstep_short_2", "sounds/footstep_2_1.ogg");
			loader.newSource(media.sounds, "footstep_short_3", "sounds/footstep_3_1.ogg");
			loader.newSource(media.sounds, "footstep_short_4", "sounds/footstep_4_1.ogg");
			loader.newSource(media.sounds, "footstep_short_5", "sounds/footstep_5_1.ogg");
			loader.newSource(media.sounds, "footstep_short_6", "sounds/footstep_6_1.ogg");
			
			loader.newSource(media.sounds, "drink", "sounds/drink.ogg");
			loader.newSource(media.sounds, "chpok", "sounds/chpok.ogg");
			loader.newSource(media.sounds, "grease", "sounds/grease.ogg");
			
			loader.newSource(media.sounds, "inv_sword_take", "sounds/inv_sword_take.ogg");
			loader.newSource(media.sounds, "inv_axe_take", "sounds/inv_axe_take.ogg");
			loader.newSource(media.sounds, "inv_spear_take", "sounds/inv_spear_take.ogg");
			loader.newSource(media.sounds, "inv_belt_take", "sounds/inv_belt_take.ogg");
			loader.newSource(media.sounds, "inv_boots_take", "sounds/inv_boots_take.ogg");
			loader.newSource(media.sounds, "inv_boots_take", "sounds/inv_boots_take.ogg");
			loader.newSource(media.sounds, "inv_bottle_put", "sounds/inv_bottle_put.ogg");
			loader.newSource(media.sounds, "inv_wood_take", "sounds/inv_wood_take.ogg");
			loader.newSource(media.sounds, "inv_cloth_take", "sounds/inv_cloth_take.ogg");
			loader.newSource(media.sounds, "inv_plate_take", "sounds/inv_plate_take.ogg");
			loader.newSource(media.sounds, "inv_other_take", "sounds/inv_other_take.ogg");
			loader.newSource(media.sounds, "inv_helmet_take", "sounds/inv_helmet_take.ogg");
			loader.newSource(media.sounds, "inv_ring_take", "sounds/inv_ring_take.ogg");
			loader.newSource(media.sounds, "inv_sword_put", "sounds/inv_sword_put.ogg");
			loader.newSource(media.sounds, "inv_axe_put", "sounds/inv_axe_put.ogg");
			loader.newSource(media.sounds, "inv_spear_put", "sounds/inv_spear_put.ogg");
			loader.newSource(media.sounds, "inv_belt_put", "sounds/inv_belt_put.ogg");
			loader.newSource(media.sounds, "inv_boots_put", "sounds/inv_boots_put.ogg");
			loader.newSource(media.sounds, "inv_bottle_put", "sounds/inv_bottle_put.ogg");
			loader.newSource(media.sounds, "inv_wood_put", "sounds/inv_wood_put.ogg");
			loader.newSource(media.sounds, "inv_cloth_put", "sounds/inv_cloth_put.ogg");
			loader.newSource(media.sounds, "inv_other_put", "sounds/inv_other_put.ogg");
			loader.newSource(media.sounds, "inv_helmet_put", "sounds/inv_helmet_put.ogg");
			loader.newSource(media.sounds, "inv_ring_put", "sounds/inv_ring_put.ogg");
			loader.newSource(media.sounds, "gold_dzen", "sounds/gold_dzen.ogg");
			loader.newSource(media.sounds, "alch_guggle", "sounds/alch_guggle.ogg");
			loader.newSource(media.sounds, "mill", "sounds/mill.ogg");
			loader.newSource(media.sounds, "glass_broken", "sounds/glass_broken.ogg");
			loader.newSource(media.sounds, "battle_begins", "sounds/battle_begins.ogg");
			loader.newSource(media.sounds, "battle_finishes", "sounds/battle_finishes.ogg");
			loader.newSource(media.sounds, "party_turn", "sounds/party_turn.ogg");
			loader.newSource(media.sounds, "chestopen_unlocked", "sounds/creak.ogg");
			loader.newSource(media.sounds, "chestopen_key", "sounds/creak_key.ogg");
			loader.newSource(media.sounds, "making_picklock", "sounds/making_picklock.ogg");
			loader.newSource(media.sounds, "crack", "sounds/crack.ogg");
			loader.newSource(media.sounds, "click", "sounds/click.ogg");
			loader.newSource(media.sounds, "highmoral", "sounds/highmoral.ogg");
			loader.newSource(media.sounds, "lowmoral", "sounds/lowmoral.ogg");
			loader.newSource(media.sounds, "error", "sounds/sound_error.ogg");
			loader.newSource(media.sounds, "mindgame_loyality", "sounds/mindgame_loyality.ogg");
			loader.newSource(media.sounds, "mindgame_fear", "sounds/mindgame_fear.ogg");
			loader.newSource(media.sounds, "mindgame_boring", "sounds/mindgame_boring.ogg");
			loader.newSource(media.sounds, "mindgame_disdain", "sounds/mindgame_disdain.ogg");
			loader.newSource(media.sounds, "mindgame_agression", "sounds/mindgame_agression.ogg");
			loader.newSource(media.sounds, "mindgame_distrust", "sounds/mindgame_distrust.ogg");
			loader.newSource(media.sounds, "mindgame_duty", "sounds/mindgame_duty.ogg");
			loader.newSource(media.sounds, "mindgame_indiffirent", "sounds/mindgame_indiffirent.ogg");
			loader.newSource(media.sounds, "mindgame_lol", "sounds/mindgame_lol.ogg");
			loader.newSource(media.sounds, "mindgame_cry", "sounds/mindgame_cry.ogg");
			loader.newSource(media.sounds, "mindgame_forgotit", "sounds/mindgame_forgotit.ogg");
			loader.newSource(media.sounds, "mindgame_surprized", "sounds/mindgame_surprized.ogg");
			loader.newSource(media.sounds, "mindgame_respect", "sounds/mindgame_respect.ogg");
			loader.newSource(media.sounds, "mindgame_pity", "sounds/mindgame_pity.ogg");
			loader.newSource(media.sounds, "mindgame_shame", "sounds/mindgame_shame.ogg");
			loader.newSource(media.sounds, "mindgame_mindcured", "sounds/mindgame_mindcured.ogg");
			loader.newSource(media.sounds, "mindgame_mymaster", "sounds/mindgame_mymaster.ogg");
			loader.newSource(media.sounds, "trap_install", "sounds/trap_install.ogg");
			loader.newSource(media.sounds, "clats", "sounds/clats.ogg");
			loader.newSource(media.sounds, "teleport", "sounds/teleport.ogg");
			loader.newSource(media.sounds, "altar", "sounds/altar.ogg");
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
