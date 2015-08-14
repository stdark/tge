--AR = after Reckoning
--AS = after Silence

calendar = {};

function calendar.calendar_data ()
	calendar.year_of_Reckoning = 1175;
	calendar.year_AR = 100;
	calendar.year_AS =  calendar.year_of_Reckoning + calendar.year_AR;
	calendar.month = 5;
	calendar.week = 1;
	calendar.day = 1;
	calendar.day_of_week = 1;
	calendar.hour = 12;
	calendar.min = 0;
	calendar.sec = 0;
	calendar.delta_restore_in_battle = {years=0,months=0,weeks=0,days=0,hours=0,mins=0,secs=3};
	calendar.delta_restore_in_peace = {years=0,months=0,weeks=0,days=0,hours=0,mins=0,secs=5};
	calendar.delta_chat = {years=0,months=0,weeks=0,days=0,hours=0,mins=5,secs=0};
	calendar.delta_trading = {years=0,months=0,weeks=0,days=0,hours=0,mins=20,secs=0};
	calendar.delta_mindgame = {years=0,months=0,weeks=0,days=0,hours=0,mins=10,secs=0};
	calendar.delta_temple_heals = {years=0,months=0,weeks=0,days=0,hours=1,mins=0,secs=0};
	calendar.delta_training = {years=0,months=0,weeks=0,days=1,hours=0,mins=0,secs=0};
	calendar.delta_thievery = {years=0,months=0,weeks=0,days=0,hours=0,mins=0,secs=30};
	calendar.delta_picklocking = {years=0,months=0,weeks=0,days=0,hours=0,mins=20,secs=0};
	calendar.delta_disarming = {years=0,months=0,weeks=0,days=0,hours=0,mins=10,secs=0};
	calendar.delta_installtrap = {years=0,months=0,weeks=0,days=0,hours=0,mins=5,secs=0};
	calendar.delta_flay = {years=0,months=0,weeks=0,days=0,hours=0,mins=5,secs=0};
	calendar.delta_walk_in_peace = {years=0,months=0,weeks=0,days=0,hours=0,mins=1,secs=0};
	calendar.delta_housewatch = {years=0,months=0,weeks=0,days=0,hours=0,mins=5,secs=0};
end; 

function calendar.add_time_interval(array)
	local secs = array.secs;
	local mins = array.mins;
	local hours = array.hours;
	local days = array.days;
	local weeks = array.weeks;
	local months = array.months;
	local years = array.years;
	while secs >= 60 do
		secs = secs - 60;
		mins = mins + 1;
	end;
	while mins >= 60 do
		mins = mins - 60;
		hours = hours + 1;
	end;
	while hours >= 24 do
		hours = hours - 24;
		days = days + 1;
	end;
	while days >= 7 do
		days = days - 7;
		weeks = weeks + 1;
	end;
	while weeks >= 4 do
		weeks = weeks - 4;
		months = months + 1;
	end;
	while months >= 12 do
		months = months -12;
		years = years + 1;
	end;
	calendar.year_AR = calendar.year_AR + years;
	calendar.year_AS =  calendar.year_of_Reckoning + calendar.year_AR;
	calendar.month = calendar.month + months;
	calendar.week = calendar.week + weeks;
	calendar.day = calendar.day + days;
	calendar.hour = calendar.hour + hours;
	calendar.min = calendar.min + mins;
	calendar.sec = calendar.sec + secs;
	--FIXME may be resting at rt? rt to 199, then do not rise untill timer stops
	local value = array.secs + array.mins*60 + array.hours*3600 + array.days*3600*24 + array.weeks*3600*24*7 + array.months*3600*24*30 + array.years*3600*24*365;
	if party.resting == 0 then
		for i=1,chars do
			if chars_mobs_npcs[i].sleep == 0 and chars_mobs_npcs[i].stone == 0 and chars_mobs_npcs[i].status == 1 then
				helpers.addSleepiness(i,value);
			end;
		end;
	else
		for i=1,chars do
			if chars_mobs_npcs[i].evileye == 0 then
				helpers.vigorPlus(i,value);
			end;
		end;
		party.resting = math.max(0,party.resting - value);
		if party.resting == 0 then
			--rt to 200
			--WAKE UP!
		end;
	end;
	--FIXME add HP SP ST regeneration
end;
