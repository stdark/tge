utils = {};

function utils.printDebug(message)
	if debug then
		print(message);
	end;
end;

function utils.getseed ()
	local sum = 0;
	if love._os == "Linux" then
		local filo = io.open ("/dev/urandom","r")
		local num = string.byte(filo:read());
		filo:close();
	end;
	if sum ~= 0 then
		return sum;
	else
		return 0;
	end;
end;

function utils.randommore ()
	rndCounter = rndCounter + 1;
	if rndCounter >= 20 then
		rndCounter = 1;
	end;
	math.randomseed(randomize[rndCounter]);
end;
