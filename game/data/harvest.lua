function harvest_load ()
	local img_width = media.images.harvest:getWidth(); 
	local img_width = media.images.harvest:getHeight();
	harvest_ttx={
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		--
		
		{sprite=love.graphics.newQuad(320, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=nil,power=nil,title="трава"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
				--
		
		{sprite=love.graphics.newQuad(320, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=nil,power=nil,title="трава"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		--
		
		{sprite=love.graphics.newQuad(638, 0, 96, 96, img_width,  img_width),addx=-12,addy=8,loot=nil,power=nil,title="куст"},
		{sprite=love.graphics.newQuad(734, 0, 96, 96, img_width,  img_width),addx=-12,addy=8,loot=nil,power=nil,title="куст"},
		{sprite=love.graphics.newQuad(830, 0, 96, 96, img_width,  img_width),addx=-12,addy=8,loot=nil,power=nil,title="куст"},
		{sprite=love.graphics.newQuad(926, 0, 96, 96, img_width,  img_width),addx=-12,addy=8,loot=nil,power=nil,title="куст"},
		{sprite=love.graphics.newQuad(1022, 0, 96, 96, img_width, img_width),addx=-12,addy=8,loot=nil,power=nil,title="куст"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),addx=0,addy=0,loot=427,power=math.random(5,10),title="чёрная копоть"},
		
	};
end;
