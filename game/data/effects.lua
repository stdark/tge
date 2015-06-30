 function effects_data ()

	bolt = {};
	bolt[1] = anim8.newGrid(128, 96, media.images.missl:getWidth(), media.images.missl:getHeight(),0,0,0);
	bolt[2] = anim8.newGrid(128, 96, media.images.missl:getWidth(), media.images.missl:getHeight(),0,96,0);
	bolt[3] = anim8.newGrid(128, 96, media.images.missl:getWidth(), media.images.missl:getHeight(),0,192,0);
	bolt[4] = anim8.newGrid(128, 96, media.images.missl:getWidth(), media.images.missl:getHeight(),0,288,0);
	bolt[5] = anim8.newGrid(128, 96, media.images.missl:getWidth(), media.images.missl:getHeight(),0,384,0);
	bolt[6] = anim8.newGrid(128, 96, media.images.missl:getWidth(), media.images.missl:getHeight(),0,480,0);
	bolt[8] = anim8.newGrid(128, 96, media.images.missl:getWidth(), media.images.missl:getHeight(),0,576,0);
	bolt[7] = anim8.newGrid(128, 96, media.images.missl:getWidth(), media.images.missl:getHeight(),0,672,0);

	grenade = {};
	grenade[1] = anim8.newGrid(32, 32, media.images.missl:getWidth(), media.images.missl:getHeight(),400,0,0);
	grenade[2] = anim8.newGrid(32, 32, media.images.missl:getWidth(), media.images.missl:getHeight(),400,32,0);
	grenade[3] = anim8.newGrid(32, 32, media.images.missl:getWidth(), media.images.missl:getHeight(),400,64,0);
	grenade[4] = anim8.newGrid(32, 32, media.images.missl:getWidth(), media.images.missl:getHeight(),400,96,0);
	grenade[5] = anim8.newGrid(32, 32, media.images.missl:getWidth(), media.images.missl:getHeight(),400,128,0);
	grenade[6] = anim8.newGrid(32, 32, media.images.missl:getWidth(), media.images.missl:getHeight(),400,160,0);
	grenade[8] = anim8.newGrid(32, 32, media.images.missl:getWidth(), media.images.missl:getHeight(),400,192,0);
	grenade[7] = anim8.newGrid(32, 32, media.images.missl:getWidth(), media.images.missl:getHeight(),400,256,0);

	fireball = {};
	fireball[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,0,0);
	fireball[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,96,0);
	fireball[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,192,0);
	fireball[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,288,0);
	fireball[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,384,0);
	fireball[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,480,0);
	fireball[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,576,0);
	fireball[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,672,0);
   
	toxiccloud = {};
	toxiccloud[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,768,0);
	toxiccloud[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,864,0);
	toxiccloud[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,960,0);
	toxiccloud[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,1056,0);
	toxiccloud[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,1152,0);
	toxiccloud[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,1248,0);
	toxiccloud[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,1344,0);
	toxiccloud[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,1440,0);
	
	windfist = {};
	local addy = 768;
	windfist[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,768+addy,0);
	windfist[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,864+addy,0);
	windfist[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,960+addy,0);
	windfist[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,1056+addy,0);
	windfist[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,1152+addy,0);
	windfist[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,1248+addy,0);
	windfist[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,1344+addy,0);
	windfist[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0,1440+addy,0);
   
	local add = 7*64;
	rockblast = {};
	rockblast[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0,0);
	rockblast[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96,0);
	rockblast[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192,0);
	rockblast[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288,0);
	rockblast[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384,0);
	rockblast[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480,0);
	rockblast[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576,0);
	rockblast[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672,0);
   
	local add = 7*64;
	iceball = {};
	iceball[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,768,0);
	iceball[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,864,0);
	iceball[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,960,0);
	iceball[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,1056,0);
	iceball[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,1152,0);
	iceball[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,1248,0);
	iceball[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,1344,0);
	iceball[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,1440,0);
   
	local add = 14*64;
	coldbeam = {};
	coldbeam[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0,0);
	coldbeam[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96,0);
	coldbeam[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192,0);
	coldbeam[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288,0);
	coldbeam[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384,0);
	coldbeam[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480,0);
	coldbeam[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576,0);
	coldbeam[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672,0);
   
	local add = 14*64;
	local addy = 768;
	flamearrow = {};
	flamearrow[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	flamearrow[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	flamearrow[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	flamearrow[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	flamearrow[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	flamearrow[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);
	flamearrow[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576+addy,0);
	flamearrow[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672+addy,0);
   
	local add = 21*64;
	local addy = 768;
	poisonedspit = {};
	poisonedspit[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	poisonedspit[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	poisonedspit[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	poisonedspit[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	poisonedspit[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	poisonedspit[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);
	poisonedspit[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576+addy,0);
	poisonedspit[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672+addy,0);
	
	local add = 28*64;
	local addy = 0;
	cold = {};
	cold[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	cold[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	cold[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	cold[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	cold[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	cold[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);

	local add = 32*64;
	local addy = 0;
	light = {};
	light[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	light[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	light[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	light[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	light[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	light[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);

	local add = 28*64;
	local addy = 768;
	darkflame = {};
	darkflame[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	darkflame[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	darkflame[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	darkflame[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	darkflame[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	darkflame[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);
	darkflame[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576+addy,0);
	darkflame[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672+addy,0);
	
	local add = 35*64;
	local addy = 768;
	spiritualarrow = {};
	spiritualarrow[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	spiritualarrow[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	spiritualarrow[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	spiritualarrow[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	spiritualarrow[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	spiritualarrow[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);
	spiritualarrow[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576+addy,0);
	spiritualarrow[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672+addy,0);
   
	local add = 21*64;
	local addy = 0;
	acidburst = {};
	acidburst[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	acidburst[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	acidburst[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	acidburst[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	acidburst[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	acidburst[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);
	acidburst[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576+addy,0);
	acidburst[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672+addy,0);
	
	local add = 7*64;
	local addy = 768;
	deadlyswarm = {};
	deadlyswarm[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight()+addy,0+add,768,0);
	deadlyswarm[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight()+addy,0+add,864,0);
	deadlyswarm[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight()+addy,0+add,960,0);
	deadlyswarm[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight()+addy,0+add,1056,0);
	deadlyswarm[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight()+addy,0+add,1152,0);
	deadlyswarm[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight()+addy,0+add,1248,0);
	deadlyswarm[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight()+addy,0+add,1344,0);
	deadlyswarm[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight()+addy,0+add,1440,0);
	
	local add = 21*64;
	local addy = 1600;
	dragonbreath = {};
	dragonbreath[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	dragonbreath[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	dragonbreath[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	dragonbreath[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	dragonbreath[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	dragonbreath[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);
	dragonbreath[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576+addy,0);
	dragonbreath[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672+addy,0);
   
	local add = 28*64;
	local addy = 1600;
	mindblast = {};
	mindblast[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	mindblast[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	mindblast[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	mindblast[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	mindblast[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	mindblast[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);
	mindblast[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576+addy,0);
	mindblast[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672+addy,0);
	
	local add = 35*64;
	local addy = 1550;
	lightbolt = {};
	lightbolt[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	lightbolt[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	lightbolt[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	lightbolt[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	lightbolt[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	lightbolt[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);
	lightbolt[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576+addy,0);
	lightbolt[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672+addy,0);
   
	local add = 14*64;
	local addy = 1600;
	staticharge = {};
	staticharge[1] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,0+addy,0);
	staticharge[2] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,96+addy,0);
	staticharge[3] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,192+addy,0);
	staticharge[4] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,288+addy,0);
	staticharge[5] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,384+addy,0);
	staticharge[6] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,480+addy,0);
	staticharge[7] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,576+addy,0);
	staticharge[8] = anim8.newGrid(128, 96, media.images.spells:getWidth(), media.images.spells:getHeight(),0+add,672+addy,0);
   
	meteor = anim8.newGrid(75, 200, media.images.spells:getWidth(), media.images.spells:getHeight(),1700,2350,0);
	star = anim8.newGrid(75, 200, media.images.spells:getWidth(), media.images.spells:getHeight(),2000,2350,0);
	armageddonsky = anim8.newGrid(75, 200, media.images.spells:getWidth(), media.images.spells:getHeight(),1400,2350,0);
	armageddonground = anim8.newGrid(75, 200, media.images.spells:getWidth(), media.images.spells:getHeight(),1100,2350,0);
	acidrain = anim8.newGrid(75, 200, media.images.spells:getWidth(), media.images.spells:getHeight(),800,2350,0);
	deathblossom = anim8.newGrid(150, 130, media.images.spells:getWidth(), media.images.spells:getHeight(),2370,2400,0);
	comete = anim8.newGrid(75, 200, media.images.spells:getWidth(), media.images.spells:getHeight(),2140,2350,0);
	waves = anim8.newGrid(448,168,media.images.waves:getWidth(), media.images.waves:getHeight(), 0,0,0);
	
	local atk_direction = 1;
	animation_flamearrow = anim8.newAnimation(flamearrow[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_coldbeam = anim8.newAnimation(coldbeam[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_poisonedspit = anim8.newAnimation(poisonedspit[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_staticharge = anim8.newAnimation(staticharge[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_lightbolt = anim8.newAnimation(lightbolt[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_spiritualarrow = anim8.newAnimation(spiritualarrow[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_darkflame = anim8.newAnimation(darkflame[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_dragonbreath = anim8.newAnimation(dragonbreath[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_mindblast = anim8.newAnimation(mindblast[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	--animation_harm = anim8.newAnimation(harm[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_fireball = anim8.newAnimation(fireball[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_cold = anim8.newAnimation(cold[atk_direction]("1-9",1), 0.02,"pauseAtEnd");
	animation_light = anim8.newAnimation(light[atk_direction]("1-9",1), 0.02,"pauseAtEnd");
	animation_deadlyswarm = anim8.newAnimation(deadlyswarm[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_bolt = anim8.newAnimation(bolt[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_grenade = anim8.newAnimation(grenade[atk_direction]("1-6",1), 0.02,"pauseAtEnd");
	animation_toxiccloud = anim8.newAnimation(toxiccloud[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_iceball = anim8.newAnimation(toxiccloud[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_acidburst = anim8.newAnimation(acidburst[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
	animation_meteor = anim8.newAnimation(meteor("1-3",1), 0.02);
	animation_star = anim8.newAnimation(star("1-3",1), 0.02);
	animation_armageddonsky = anim8.newAnimation(armageddonsky("1-3",1), 0.02);
	animation_armageddonground = anim8.newAnimation(armageddonground("1-3",1), 0.02);
	animation_acidrain = anim8.newAnimation(acidrain("1-3",1), 0.02);
	animation_deathblossom = anim8.newAnimation(deathblossom("1-1",1), 0.06);
	animation_comete = anim8.newAnimation(comete("1-3",1), 0.02);
	animation_deadlywave = anim8.newAnimation( waves:getFrames(1,1,1,2,1,3,1,4,1,5,1,6), 0.02, false);
	toxicexplo=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,0,0,"pauseAtEnd");
	animation_toxicexplo = anim8.newAnimation(toxicexplo("1-9",1), 0.075);
 
	spike=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,0,0,"pauseAtEnd");
	animation_spike = anim8.newAnimation(spike("1-9",1), 0.075);
 
	stonewall=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128,0,"pauseAtEnd");
	animation_stonewall = anim8.newAnimation(stonewall("1-9",1), 0.075);
 
	pitfall=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,2*128,0,"pauseAtEnd");
	animation_pitfall = anim8.newAnimation(pitfall("1-9",1), 0.075);
 
	fireburn=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128,0);
	animation_fireburn = anim8.newAnimation(fireburn("1-9",1), 0.075);
	
	startfireburn=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,2100,0);
	animation_startfireburn = anim8.newAnimation(startfireburn("1-9",1), 0.075);
	
	firexplo=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*2,0,"pauseAtEnd");
	animation_firexplo = anim8.newAnimation(firexplo("1-9",1), 0.075);
  
	poisoned=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*3,0);
	animation_poisoned = anim8.newAnimation(poisoned("1-9",1), 0.075);
 
	snow=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*4,0,"pauseAtEnd");
	animation_snow = anim8.newAnimation(snow("1-9",1), 0.075);
 
	acidexplo=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*5,0,"pauseAtEnd");
	animation_acidexplo = anim8.newAnimation(acidexplo("1-9",1), 0.075);
 
	staticexplo=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*6,0,"pauseAtEnd");
	animation_staticexplo=anim8.newAnimation(staticexplo("1-9",1), 0.075);

	icexplo=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*7,0,"pauseAtEnd");
	animation_icexplo=anim8.newAnimation(icexplo("1-9",1), 0.075);
 
	flame=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*8,0,"pauseAtEnd");
	animation_flame = anim8.newAnimation(flame("1-9",1), 0.075);
 
	shrapexplo=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*3,0,"pauseAtEnd");
	animation_shrapexplo = anim8.newAnimation(shrapexplo("1-9",1), 0.075);
 
	dehydratation=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*5,0,"pauseAtEnd");
	animation_dehydratation = anim8.newAnimation(dehydratation("1-9",1), 0.075);
 
	implosion=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*4,0,"pauseAtEnd");
	animation_implosion = anim8.newAnimation(implosion("1-9",1), 0.075);
 
	sunray=anim8.newGrid(128, 256, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*6,0,"pauseAtEnd");
	animation_sunray = anim8.newAnimation(sunray("1-9",1), 0.075);
 
	--moonlight=anim8.newGrid(128, 256, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*8,0,"pauseAtEnd");
	moonlight=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*17,0,"pauseAtEnd");
	animation_moonlight = anim8.newAnimation(moonlight("1-8",1), 0.075);
	
	souldrinker=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*15,0,"pauseAtEnd");
	animation_souldrinker = anim8.newAnimation(souldrinker("1-8",1), 0.075);
 
	massdistortion=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*10,0,"pauseAtEnd");
	animation_massdistortion = anim8.newAnimation(massdistortion("1-9",1), 0.075);
 
	frost=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*11,0,"pauseAtEnd");
	animation_frost = anim8.newAnimation(frost("1-9",1), 0.075);
	
	--[[cold=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*11,0,"pauseAtEnd");
	animation_cold = anim8.newAnimation(cold("1-9",1), 0.075);
	
	light=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*11,0,"pauseAtEnd");
	animation_light = anim8.newAnimation(light("1-9",1), 0.075);]]
 
	razor=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*12,0,"pauseAtEnd");
	animation_razor = anim8.newAnimation(razor("1-9",1), 0.075);
	
	acidbomb=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),9*128,128*13,0,"pauseAtEnd");
	animation_acidbomb = anim8.newAnimation(acidbomb("1-9",1), 0.075);

	bloodsprayer=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*9,0,"pauseAtEnd");
	animation_bloodsprayer=anim8.newAnimation(bloodsprayer("1-9",1), 0.075);
 
	windexplo=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*10,0,"pauseAtEnd");
	animation_windexplo=anim8.newAnimation(windexplo("1-9",1), 0.075);
 
	dustexplo=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*11,0,"pauseAtEnd");
	animation_dustexplo=anim8.newAnimation(dustexplo("1-9",1), 0.075);
 
	incexplo=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*12,0,"pauseAtEnd");
	animation_incexplo=anim8.newAnimation(incexplo("1-9",1), 0.075);

	prism=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*13,0,"pauseAtEnd");
	animation_prism=anim8.newAnimation(prism("1-9",1), 0.075);

	lightning=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),0,128*14,0,"pauseAtEnd");
	animation_lightning=anim8.newAnimation(lightning("1-9",1), 0.075);
	
	twister=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.boom:getHeight(),128*9,128*14,0);
	animation_twister = anim8.newAnimation(twister("1-9",1), 0.075);
 

 --buffs
 
	healbuff=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,0,0,"pauseAtEnd");
	animation_healbuff = anim8.newAnimation(healbuff("1-9",1), 0.075);
 
	chargebuff=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128,0,"pauseAtEnd");
	animation_chargebuff = anim8.newAnimation(chargebuff("1-9",1), 0.075);
 
	encourage=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*2,0,"pauseAtEnd");
	animation_encourage = anim8.newAnimation(encourage("1-9",1), 0.075);
 
	bloodfirst=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*3,0,"pauseAtEnd");
	animation_bloodfirst = anim8.newAnimation(bloodfirst("1-9",1), 0.075);
 
	regeneration=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*4,0,"pauseAtEnd");
	animation_regeneration = anim8.newAnimation(regeneration("1-9",1), 0.075);
 
	protfromfire=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*5,0,"pauseAtEnd");
	animation_protfromfire = anim8.newAnimation(protfromfire("1-9",1), 0.075);
 
	protfromcold=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*6,0,"pauseAtEnd");
	animation_protfromcold = anim8.newAnimation(protfromcold("1-9",1), 0.075);
 
	protfromstatic=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*7,0,"pauseAtEnd");
	animation_protfromstatic = anim8.newAnimation(protfromstatic("1-9",1), 0.075);
  
	shield=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.buff:getHeight(),0,128*8,0,"pauseAtEnd");
	animation_shield=anim8.newAnimation(shield("1-9",1), 0.075);

	stoneskin=anim8.newGrid(128, 128, media.images.boom:getWidth(), media.images.buff:getHeight(),0,128*9,0,"pauseAtEnd");
	animation_stoneskin=anim8.newAnimation(stoneskin("1-9",1), 0.075);
 
	protfrompoison=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*10,0,"pauseAtEnd");
	animation_protfrompoison = anim8.newAnimation(protfrompoison("1-9",1), 0.075);
 
	protfromacid=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*11,0,"pauseAtEnd");
	animation_protfromacid = anim8.newAnimation(protfromacid("1-9",1), 0.075);
 
	protofmind=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*12,0,"pauseAtEnd");
	animation_protofmind= anim8.newAnimation(protofmind("1-9",1), 0.075);
 
	protofspirit=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*13,0,"pauseAtEnd");
	animation_protofspirit = anim8.newAnimation(protofspirit("1-9",1), 0.075);
 
	protfromdisease=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*16,0,"pauseAtEnd");
	animation_protfromdisease = anim8.newAnimation(protfromdisease("1-9",1), 0.075);
  
	resurrect=anim8.newGrid(128, 256, media.images.buff:getWidth(), media.images.buff:getHeight(),0,128*15,0,"pauseAtEnd");
	animation_resurrect = anim8.newAnimation(resurrect("1-9",1), 0.075);
 
	charm=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,0,0,"pauseAtEnd");
	animation_charm = anim8.newAnimation(charm("1-9",1), 0.075);
 
	berserk=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,128,0,"pauseAtEnd");
	animation_berserk = anim8.newAnimation(berserk("1-9",1), 0.075);
 
	enslave=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,128*2,0,"pauseAtEnd");
	animation_enslave = anim8.newAnimation(enslave("1-9",1), 0.075);
 
	sleep=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,128*3,0,"pauseAtEnd");
	animation_sleep = anim8.newAnimation(sleep("1-9",1), 0.075);
 
	fear=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,128*4,0,"pauseAtEnd");
	animation_fear = anim8.newAnimation(fear("1-9",1), 0.075);
 
	haste=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,128*5,0,"pauseAtEnd");
	animation_haste = anim8.newAnimation(haste("1-9",1), 0.075);
 
	dash=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,128*6,0,"pauseAtEnd");
	animation_dash = anim8.newAnimation(dash("1-9",1), 0.075);
 
	douse=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,128*7,0,"pauseAtEnd");
	animation_douse = anim8.newAnimation(douse("1-9",1), 0.075);
 
	strenght=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,128*8,0,"pauseAtEnd");
	animation_strenght = anim8.newAnimation(strenght("1-9",1), 0.075);
 
	dash=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,128*9,0,"pauseAtEnd");
	animation_dash = anim8.newAnimation(dash("1-9",1), 0.075);
 
	precision=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*10,128*11,0,"pauseAtEnd");
	animation_precision = anim8.newAnimation(precision("1-9",1), 0.075);
 
	mobility=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*12,128*10,0,"pauseAtEnd");
	animation_mobility = anim8.newAnimation(mobility("1-9",1), 0.075);
 
	preservation=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*12,128*12,0,"pauseAtEnd");
	animation_preservation = anim8.newAnimation(preservation("1-9",1), 0.075);
 
	heroism=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*12,128*13,0,"pauseAtEnd");
	animation_heroism = anim8.newAnimation(heroism("1-9",1), 0.075);
 
	luckyday=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*12,128*14,0,"pauseAtEnd");
	animation_luckyday = anim8.newAnimation(luckyday("1-9",1), 0.075);
 
	removecurse=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*12,128*15,0,"pauseAtEnd");
	animation_removecurse = anim8.newAnimation(removecurse("1-9",1), 0.075);
 
	glamour=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*12,128*16,0,"pauseAtEnd");
	animation_glamour = anim8.newAnimation(glamour("1-9",1), 0.075);
 
	cure=anim8.newGrid(128, 128, media.images.buff:getWidth(), media.images.buff:getHeight(),128*12,128*17,0,"pauseAtEnd");
	animation_cure = anim8.newAnimation(cure("1-9",1), 0.075);
 
	bigfreeze = love.graphics.newQuad(0, 15*128, 128,128, media.images.boom:getWidth(), media.images.boom:getHeight());
	freeze = love.graphics.newQuad(128, 15*128, 128,128, media.images.boom:getWidth(), media.images.boom:getHeight());
	firemine = love.graphics.newQuad(128*2, 15*128, 128,128, media.images.boom:getWidth(), media.images.boom:getHeight());
	stonewall_ = love.graphics.newQuad(128*17, 128, 128,128, media.images.boom:getWidth(), media.images.boom:getHeight());
	pitfall_ = love.graphics.newQuad(128*17, 2*128, 128,128, media.images.boom:getWidth(), media.images.boom:getHeight());
	earthteeths_ = love.graphics.newQuad(128*3, 15*128, 128,128, media.images.boom:getWidth(), media.images.boom:getHeight());
	ice = love.graphics.newQuad(128*5, 15*128, 128,128, media.images.boom:getWidth(), media.images.boom:getHeight());
	mud = love.graphics.newQuad(128*4, 15*128, 128,128, media.images.boom:getWidth(), media.images.boom:getHeight());
	
	--buildings
	fountain = anim8.newGrid(250, 224, media.images.animatedobjects:getWidth(), media.images.animatedobjects:getHeight(),0,0,0);
	animation_fountain = anim8.newAnimation(fountain("1-5",1), 0.05);
end;
