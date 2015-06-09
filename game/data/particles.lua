particles = {};

local _image = love.graphics.newImage("img/particles/image_particle_1.png" );
particles[1] = love.graphics.newParticleSystem(_image,20);
particles[1]:setParticleLifetime(5,10);
particles[1]:setEmissionRate(10);
particles[1]:setLinearAcceleration( -5, -10, 5, 10 );
particles[1]:setSpread(1);
