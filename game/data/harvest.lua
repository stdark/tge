function harvest_load ()
	local img_width = media.images.harvest:getWidth(); 
	local img_width = media.images.harvest:getHeight();
	harvest_ttx={
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		--
		
		{sprite=love.graphics.newQuad(320, 0, 64, 96, img_width,  img_width),loot=nil,power=nil,title="трава"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		{sprite=love.graphics.newQuad(0, 0, 64, 96, img_width,  img_width),loot=423,power=math.random(5,10),title="ярутка красная"},
		{sprite=love.graphics.newQuad(64, 0, 64, 96, img_width,  img_width),loot=424,power=math.random(5,10),title="волшебная полынь"},
		{sprite=love.graphics.newQuad(128, 0, 64, 96, img_width,  img_width),loot=425,power=math.random(5,10),title="жёлтая лилия"},
		{sprite=love.graphics.newQuad(192, 0, 64, 96, img_width,  img_width),loot=426,power=math.random(5,10),title="пещерный гриб"},
		{sprite=love.graphics.newQuad(256, 0, 64, 96, img_width,  img_width),loot=427,power=math.random(5,10),title="чёрная копоть"},
		
		
	};
end;
