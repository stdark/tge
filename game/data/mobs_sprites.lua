mobs_sprites = {};

function mobs_sprites.sprites_data ()

row=1

img_width=2200
img_height=1800
add=880

rogue_dmg={} --and death
rogue_dmg[1] = anim8.newGrid(128, 128,img_width,img_height,32,32,0)
rogue_dmg[2] = anim8.newGrid(128, 128,img_width,img_height,32,176,0)
rogue_dmg[3] = anim8.newGrid(128, 128,img_width,img_height,32,320,0)
rogue_dmg[4] = anim8.newGrid(128, 128,img_width,img_height,32,464,0)
rogue_dmg[5] = anim8.newGrid(128, 128,img_width,img_height,32,608,0)
rogue_dmg[6] = anim8.newGrid(128, 128,img_width,img_height,32,752,0)

rogue_dead={}
dead_height=128
dead_width=128
rogue_dead[1]=love.graphics.newQuad(928, 32, dead_width, dead_height, img_width,  img_height)
rogue_dead[2]=love.graphics.newQuad(928, 176, dead_width, dead_height,img_width,  img_height)
rogue_dead[3]=love.graphics.newQuad(928, 320, dead_width, dead_height, img_width,  img_height)
rogue_dead[4]=love.graphics.newQuad(928, 464, dead_width, dead_height,img_width,  img_height)
rogue_dead[5]=love.graphics.newQuad(928, 608, dead_width, dead_height, img_width,  img_height)
rogue_dead[6]=love.graphics.newQuad(928, 752, dead_width, dead_height, img_width,  img_height)

rogue_stay={}
hero_height=128
hero_width=32
rogue_stay[1]=love.graphics.newQuad(2110, 32, 64, hero_height, img_width, img_height)
rogue_stay[2]=love.graphics.newQuad(2110, 176, 64, hero_height, img_width, img_height)
rogue_stay[3]=love.graphics.newQuad(2110, 320, 64, hero_height, img_width, img_height)
rogue_stay[4]=love.graphics.newQuad(2110, 464, 64, hero_height, img_width, img_height)
rogue_stay[5]=love.graphics.newQuad(2110, 608, 64, hero_height, img_width, img_height)
rogue_stay[6]=love.graphics.newQuad(2110, 752, 64, hero_height, img_width, img_height)
rogue_stay[7]=love.graphics.newQuad(2110, 866, 64, hero_height, img_width, img_height)
rogue_stay[8]=love.graphics.newQuad(2110, 1000, 64, hero_height, img_width, img_height)

rogue_walk={}
rogue_walk[1] = anim8.newGrid(192, 160, img_width, img_height,32,add+0,0)
rogue_walk[2] = anim8.newGrid(192, 160, img_width, img_height,32,add+165,0)
rogue_walk[3] = anim8.newGrid(192, 160, img_width, img_height,32,add+300,0)
rogue_walk[4] = anim8.newGrid(192, 160, img_width, img_height,32,add+450,0)
rogue_walk[5] = anim8.newGrid(192, 140, img_width, img_height,16,add+590,0)
rogue_walk[6] = anim8.newGrid(192, 160, img_width, img_height,32,add+730,0)


img_width=1800
img_height=2800
add=1638
add2=900
--[[
rogue_sht1={}
rogue_sht1[1] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,32,0)
rogue_sht1[2] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,176,0)
rogue_sht1[3] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,320,0)
rogue_sht1[4] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,464,0)
rogue_sht1[5] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,608,0)
rogue_sht1[6] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,752,0)
]]--
rogue_atk1={}
rogue_atk1[1] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),32,32+add2,0)
rogue_atk1[2] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),52,176+add2,0)
rogue_atk1[3] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),32,320+add2,0)  
rogue_atk1[4] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),32,464+add2,0)  
rogue_atk1[5] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),14,608+add2,0)  
rogue_atk1[6] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),32,752+add2,0)

--[[
rogue_cast1={}
rogue_cast1[1] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,160+add,0)
rogue_cast1[2] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,320+add,0)
rogue_cast1[3] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,464+add,0)
rogue_cast1[4] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,608+add,0)
rogue_cast1[5] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,752+add,0)
rogue_cast1[6] = anim8.newGrid(192, 128, media.images.rogue_war:getWidth(), media.images.rogue_war:getHeight(),64,892+add,0)
]]--


add = 0;

rogue_block = {};
rogue_block[1] = anim8.newGrid(192, 128, media.images.rogue_def:getWidth(), media.images.rogue_def:getHeight(),32,32+add,0);
rogue_block[2] = anim8.newGrid(192, 128, media.images.rogue_def:getWidth(), media.images.rogue_def:getHeight(),32,176+add,0);
rogue_block[3] = anim8.newGrid(192, 128, media.images.rogue_def:getWidth(), media.images.rogue_def:getHeight(),32,320+add,0);
rogue_block[4] = anim8.newGrid(192, 128, media.images.rogue_def:getWidth(), media.images.rogue_def:getHeight(),32,464+add,0);
rogue_block[5] = anim8.newGrid(192, 128, media.images.rogue_def:getWidth(), media.images.rogue_def:getHeight(),32,608+add,0);
rogue_block[6] = anim8.newGrid(192, 128, media.images.rogue_def:getWidth(), media.images.rogue_def:getHeight(),32,752+add,0);

animation_rogue_block = anim8.newAnimation(rogue_block[row]("1-8",1), 0.075);

add = 1184;

rogue_cast1 = {};
rogue_cast1[1] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,32+add,0);
rogue_cast1[2] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,176+add,0);
rogue_cast1[3] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,320+add,0);
rogue_cast1[4] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,464+add,0);
rogue_cast1[5] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,608+add,0);
rogue_cast1[6] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,752+add,0);
rogue_cast1[7] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,896+add,0);
rogue_cast1[8] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,1040+add,0);


animation_rogue_cast1 = anim8.newAnimation(rogue_cast1[row]("1-8",1), 0.075);

rogue_sht1 = {}
rogue_sht1[1] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,32,0);
rogue_sht1[2] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,176,0);
rogue_sht1[3] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,320,0);
rogue_sht1[4] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,464,0);
rogue_sht1[5] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,608,0);
rogue_sht1[6] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,752,0);
rogue_sht1[7] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,896,0);
rogue_sht1[8] = anim8.newGrid(192, 128, media.images.rogue_rng:getWidth(), media.images.rogue_rng:getHeight(),32,1040,0);

animation_rogue_sht1 = anim8.newAnimation(rogue_sht1[row]("1-9",1), 0.075);

rogue_launch = {};
rogue_launch[1] = anim8.newGrid(192, 128, media.images.rogue_rng2:getWidth(), media.images.rogue_rng2:getHeight(),32,32,0);
rogue_launch[2] = anim8.newGrid(192, 128, media.images.rogue_rng2:getWidth(), media.images.rogue_rng2:getHeight(),32,176,0);
rogue_launch[3] = anim8.newGrid(192, 128, media.images.rogue_rng2:getWidth(), media.images.rogue_rng2:getHeight(),32,320,0);
rogue_launch[4] = anim8.newGrid(192, 128, media.images.rogue_rng2:getWidth(), media.images.rogue_rng2:getHeight(),32,464,0);
rogue_launch[5] = anim8.newGrid(192, 128, media.images.rogue_rng2:getWidth(), media.images.rogue_rng2:getHeight(),32,608,0);
rogue_launch[6] = anim8.newGrid(192, 128, media.images.rogue_rng2:getWidth(), media.images.rogue_rng2:getHeight(),32,752,0);
rogue_launch[7] = anim8.newGrid(192, 128, media.images.rogue_rng2:getWidth(), media.images.rogue_rng2:getHeight(),32,896,0);
rogue_launch[8] = anim8.newGrid(192, 128, media.images.rogue_rng2:getWidth(), media.images.rogue_rng2:getHeight(),32,1040,0);

animation_rogue_launch = anim8.newAnimation(rogue_launch[row]("1-9",1), 0.075);

--goblin (mob)


img_width=2200
img_height=1800
add=920

goblin_dmg={} --and death
goblin_dmg[1] = anim8.newGrid(128, 128,img_width,img_height,32,32,0)
goblin_dmg[2] = anim8.newGrid(128, 128,img_width,img_height,32,176,0)
goblin_dmg[3] = anim8.newGrid(128, 128,img_width,img_height,32,320,0)
goblin_dmg[4] = anim8.newGrid(128, 128,img_width,img_height,32,464,0)
goblin_dmg[5] = anim8.newGrid(128, 128,img_width,img_height,32,608,0)
goblin_dmg[6] = anim8.newGrid(128, 128,img_width,img_height,32,752,0)

goblin_dead={}
dead_height=128
dead_width=128
goblin_dead[1]=love.graphics.newQuad(928, 32, dead_width, dead_height, img_width,  img_height)
goblin_dead[2]=love.graphics.newQuad(928, 176, dead_width, dead_height,img_width,  img_height)
goblin_dead[3]=love.graphics.newQuad(928, 320, dead_width, dead_height, img_width,  img_height)
goblin_dead[4]=love.graphics.newQuad(928, 464, dead_width, dead_height,img_width,  img_height)
goblin_dead[5]=love.graphics.newQuad(928, 608, dead_width, dead_height, img_width,  img_height)
goblin_dead[6]=love.graphics.newQuad(928, 752, dead_width, dead_height, img_width,  img_height)

goblin_stay={}
hero_height=128
hero_width=32
goblin_stay[1]=love.graphics.newQuad(2110, 32, 64, hero_height, img_width, img_height)
goblin_stay[2]=love.graphics.newQuad(2110, 176, 64, hero_height, img_width, img_height)
goblin_stay[3]=love.graphics.newQuad(2110, 320, 64, hero_height, img_width, img_height)
goblin_stay[4]=love.graphics.newQuad(2110, 464, 64, hero_height, img_width, img_height)
goblin_stay[5]=love.graphics.newQuad(2110, 608, 64, hero_height, img_width, img_height)
goblin_stay[6]=love.graphics.newQuad(2110, 752, 64, hero_height, img_width, img_height)

goblin_walk={}
goblin_walk[1] = anim8.newGrid(192, 160, img_width, img_height,32,add+0,0)
goblin_walk[2] = anim8.newGrid(192, 128, img_width, img_height,32,add+170,0)
goblin_walk[3] = anim8.newGrid(192, 160, img_width, img_height,32,add+300,0)
goblin_walk[4] = anim8.newGrid(192, 160, img_width, img_height,32,add+450,0)
goblin_walk[5] = anim8.newGrid(192, 128, img_width, img_height,0,add+600,0)
goblin_walk[6] = anim8.newGrid(192, 160, img_width, img_height,32,add+750,0)

img_width=2200
img_height=1800

goblin_atk1={}
goblin_atk1[1] = anim8.newGrid(192, 128, media.images.goblin_war:getWidth(), media.images.goblin_war:getHeight(),32,32,0)
goblin_atk1[2] = anim8.newGrid(192, 128, media.images.goblin_war:getWidth(), media.images.goblin_war:getHeight(),32,176,0)
goblin_atk1[3] = anim8.newGrid(192, 128, media.images.goblin_war:getWidth(), media.images.goblin_war:getHeight(),32,320,0)
goblin_atk1[4] = anim8.newGrid(192, 128, media.images.goblin_war:getWidth(), media.images.goblin_war:getHeight(),32,464,0)
goblin_atk1[5] = anim8.newGrid(192, 128, media.images.goblin_war:getWidth(), media.images.goblin_war:getHeight(),32,608,0)
goblin_atk1[6] = anim8.newGrid(192, 128, media.images.goblin_war:getWidth(), media.images.goblin_war:getHeight(),32,752,0)

-- golem mob

img_width=2200
img_height=1800
add=920

golem_dmg={} --and death
golem_dmg[1] = anim8.newGrid(128, 128,img_width,img_height,32,32,0)
golem_dmg[2] = anim8.newGrid(128, 128,img_width,img_height,32,176,0)
golem_dmg[3] = anim8.newGrid(128, 128,img_width,img_height,32,320,0)
golem_dmg[4] = anim8.newGrid(128, 128,img_width,img_height,32,464,0)
golem_dmg[5] = anim8.newGrid(128, 128,img_width,img_height,32,608,0)
golem_dmg[6] = anim8.newGrid(128, 128,img_width,img_height,32,752,0)

golem_dead={}
dead_height=128
dead_width=128
golem_dead[1]=love.graphics.newQuad(928, 32, dead_width, dead_height, img_width,  img_height)
golem_dead[2]=love.graphics.newQuad(928, 176, dead_width, dead_height,img_width,  img_height)
golem_dead[3]=love.graphics.newQuad(928, 320, dead_width, dead_height, img_width,  img_height)
golem_dead[4]=love.graphics.newQuad(928, 464, dead_width, dead_height,img_width,  img_height)
golem_dead[5]=love.graphics.newQuad(928, 608, dead_width, dead_height, img_width,  img_height)
golem_dead[6]=love.graphics.newQuad(928, 752, dead_width, dead_height, img_width,  img_height)

golem_stay={}
hero_height=128
hero_width=32
golem_stay[1]=love.graphics.newQuad(2110, 32, 64, hero_height, img_width, img_height)
golem_stay[2]=love.graphics.newQuad(2110, 176, 64, hero_height, img_width, img_height)
golem_stay[3]=love.graphics.newQuad(2110, 320, 64, hero_height, img_width, img_height)
golem_stay[4]=love.graphics.newQuad(2110, 464, 64, hero_height, img_width, img_height)
golem_stay[5]=love.graphics.newQuad(2110, 608, 64, hero_height, img_width, img_height)
golem_stay[6]=love.graphics.newQuad(2110, 752, 64, hero_height, img_width, img_height)

golem_walk={}
golem_walk[1] = anim8.newGrid(192, 160, img_width, img_height,32,add+0,0)
golem_walk[2] = anim8.newGrid(192, 128, img_width, img_height,32,add+170,0)
golem_walk[3] = anim8.newGrid(192, 160, img_width, img_height,32,add+300,0)
golem_walk[4] = anim8.newGrid(192, 160, img_width, img_height,32,add+450,0)
golem_walk[5] = anim8.newGrid(192, 128, img_width, img_height,0,add+600,0)
golem_walk[6] = anim8.newGrid(192, 160, img_width, img_height,32,add+750,0)

img_width=2200
img_height=1800

golem_atk1={}
golem_atk1[1] = anim8.newGrid(192, 128, media.images.golem_war:getWidth(), media.images.golem_war:getHeight(),32,32,0)
golem_atk1[2] = anim8.newGrid(192, 128, media.images.golem_war:getWidth(), media.images.golem_war:getHeight(),32,176,0)
golem_atk1[3] = anim8.newGrid(192, 128, media.images.golem_war:getWidth(), media.images.golem_war:getHeight(),32,320,0)
golem_atk1[4] = anim8.newGrid(192, 128, media.images.golem_war:getWidth(), media.images.golem_war:getHeight(),32,464,0)
golem_atk1[5] = anim8.newGrid(192, 128, media.images.golem_war:getWidth(), media.images.golem_war:getHeight(),32,608,0)
golem_atk1[6] = anim8.newGrid(192, 128, media.images.golem_war:getWidth(), media.images.golem_war:getHeight(),32,752,0)

-- fireelemental mob

img_width=2200
img_height=1800
add=920

fireelemental_dmg={} --and death
fireelemental_dmg[1] = anim8.newGrid(128, 128,img_width,img_height,32,32,0)
fireelemental_dmg[2] = anim8.newGrid(128, 128,img_width,img_height,32,176,0)
fireelemental_dmg[3] = anim8.newGrid(128, 128,img_width,img_height,32,320,0)
fireelemental_dmg[4] = anim8.newGrid(128, 128,img_width,img_height,32,464,0)
fireelemental_dmg[5] = anim8.newGrid(128, 128,img_width,img_height,32,608,0)
fireelemental_dmg[6] = anim8.newGrid(128, 128,img_width,img_height,32,752,0)

fireelemental_dead={}
dead_height=128
dead_width=128
fireelemental_dead[1]=love.graphics.newQuad(928, 32, dead_width, dead_height, img_width,  img_height)
fireelemental_dead[2]=love.graphics.newQuad(928, 176, dead_width, dead_height,img_width,  img_height)
fireelemental_dead[3]=love.graphics.newQuad(928, 320, dead_width, dead_height, img_width,  img_height)
fireelemental_dead[4]=love.graphics.newQuad(928, 464, dead_width, dead_height,img_width,  img_height)
fireelemental_dead[5]=love.graphics.newQuad(928, 608, dead_width, dead_height, img_width,  img_height)
fireelemental_dead[6]=love.graphics.newQuad(928, 752, dead_width, dead_height, img_width,  img_height)

fireelemental_stay={}
hero_height=128
hero_width=32
fireelemental_stay[1]=love.graphics.newQuad(2110, 32, 64, hero_height, img_width, img_height)
fireelemental_stay[2]=love.graphics.newQuad(2110, 176, 64, hero_height, img_width, img_height)
fireelemental_stay[3]=love.graphics.newQuad(2110, 320, 64, hero_height, img_width, img_height)
fireelemental_stay[4]=love.graphics.newQuad(2110, 464, 64, hero_height, img_width, img_height)
fireelemental_stay[5]=love.graphics.newQuad(2110, 608, 64, hero_height, img_width, img_height)
fireelemental_stay[6]=love.graphics.newQuad(2110, 752, 64, hero_height, img_width, img_height)

fireelemental_walk={}
fireelemental_walk[1] = anim8.newGrid(192, 160, img_width, img_height,32,add+0,0)
fireelemental_walk[2] = anim8.newGrid(192, 128, img_width, img_height,32,add+170,0)
fireelemental_walk[3] = anim8.newGrid(192, 160, img_width, img_height,32,add+300,0)
fireelemental_walk[4] = anim8.newGrid(192, 160, img_width, img_height,32,add+450,0)
fireelemental_walk[5] = anim8.newGrid(192, 128, img_width, img_height,0,add+600,0)
fireelemental_walk[6] = anim8.newGrid(192, 160, img_width, img_height,32,add+750,0)

img_width=2200
img_height=1800

fireelemental_atk1={}
fireelemental_atk1[1] = anim8.newGrid(192, 128, media.images.fireelemental_war:getWidth(), media.images.fireelemental_war:getHeight(),32,32,0)
fireelemental_atk1[2] = anim8.newGrid(192, 128, media.images.fireelemental_war:getWidth(), media.images.fireelemental_war:getHeight(),32,176,0)
fireelemental_atk1[3] = anim8.newGrid(192, 128, media.images.fireelemental_war:getWidth(), media.images.fireelemental_war:getHeight(),32,320,0)
fireelemental_atk1[4] = anim8.newGrid(192, 128, media.images.fireelemental_war:getWidth(), media.images.fireelemental_war:getHeight(),32,464,0)
fireelemental_atk1[5] = anim8.newGrid(192, 128, media.images.fireelemental_war:getWidth(), media.images.fireelemental_war:getHeight(),32,608,0)
fireelemental_atk1[6] = anim8.newGrid(192, 128, media.images.fireelemental_war:getWidth(), media.images.fireelemental_war:getHeight(),32,752,0)
end

function mobs_sprites.animation_rows ()

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
	animation_death = anim8.newAnimation(mob_dmg[chars_mobs_npcs[current_mob].rot]("1-8",1), 0.075,"pauseAtEnd");
	animation_sht1 = anim8.newAnimation(mob_sht1[chars_mobs_npcs[current_mob].rot]("1-9",1), 0.075,"pauseAtEnd");
	animation_launch = anim8.newAnimation(mob_launch[chars_mobs_npcs[current_mob].rot]("1-9",1), 0.075,"pauseAtEnd");
	animation_cast1 = anim8.newAnimation(mob_cast1[chars_mobs_npcs[current_mob].rot]("1-9",1), 0.075,"pauseAtEnd");
	--animation_block = anim8.newAnimation(mob_block[chars_mobs_npcs[current_mob].rot]("1-8",1), 0.075,"pauseAtEnd");

	animation_dmg = {};
	animation_death = {};
	animation_block = {};

	for i=1,6 do
		local tmp = chars_mobs_npcs[current_mob].sprite .. "_dmg";
		mob_dmg = loadstring("return " .. tmp)();
		animation_dmg[i] = anim8.newAnimation(mob_dmg[i]("9-16",1), 0.075,"pauseAtEnd");
	end;

	for i=1,6 do
		local tmp = chars_mobs_npcs[current_mob].sprite .. "_death";
		mob_death = loadstring("return " .. tmp)();
		animation_death[i] = anim8.newAnimation(mob_dmg[i]("9-16",1), 0.075,"pauseAtEnd");
	end;

	for i=1,6 do
		local tmp = chars_mobs_npcs[current_mob].sprite .. "_block";
		mob_dmg = loadstring("return " .. tmp)();
		animation_block[i] = anim8.newAnimation(mob_block[i]("1-8",1), 0.075, "pauseAtEnd");
	end;
end;
