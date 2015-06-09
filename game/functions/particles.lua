particles = {};

function particles.getPSO(filename,imgname)
	local templates = loadstring("return " .. love.filesystem.read(filename))();
	local pss = {};
	local degToRad = function(d) return d*math.pi/180 end;
	local getPS = function(template)
	local sprite = love.graphics.newImage(imgname);
	local ps = love.graphics.newParticleSystem(sprite, template.buffer_size);
	ps:setBufferSize(template.buffer_size);
	local colors = {};
	for i = 1, 8 do
		if template.colors[i] then
			table.insert(colors, template.colors[i][1]);
			table.insert(colors, template.colors[i][2]);
			table.insert(colors, template.colors[i][3]);
			table.insert(colors, template.colors[i][4]);
		end
	end
	ps:setColors(unpack(colors));
	ps:setDirection(degToRad(template.direction));
	ps:setEmissionRate(template.emission_rate);
	--ps:setGravity(template.gravity[1], template.gravity[2]);
	--ps:setLifetime(template.lifetime);
	ps:setOffset(template.offset[1], template.offset[2])
	ps:setParticleLife(template.particle_life[1], template.particle_life[2]);
	ps:setRadialAcceleration(template.radial_acc[1], template.radial_acc[2]);
	ps:setRotation(degToRad(template.rotation[1]), degToRad(template.rotation[2]));
	ps:setSizeVariation(template.size_variation);
	ps:setSizes(unpack(template.sizes));
	ps:setSpeed(template.speed[1], template.speed[2]);
	ps:setSpin(degToRad(template.spin[1]), degToRad(template.spin[2]));
	ps:setSpinVariation(template.spin_variation);
	ps:setSpread(degToRad(template.spread));
	ps:setTangentialAcceleration(template.tangent_acc[1], template.tangent_acc[2]);
	return ps;
	end;
	for _, t in pairs(templates) do
		if t then table.insert(pss, {name = t.name, ps = getPS(t.template)}) end;
		end;
	return pss;
end;

psPicklockBroken = particles.getPSO("ps1.pso","image_particle_2.png");
snoweffect = particles.getPSO("spelleffects.pso","image_particle_3.png");
