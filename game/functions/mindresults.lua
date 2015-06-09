mindresults = {};

function mindresults.results (index)
	if index == 1 then
		page = 1;
		current_comic = 2;
		game_status = "comic";
	elseif index == 2 then
		chars_mobs_npcs[victim].dangerai = "agr";
		fractions[chars_mobs_npcs[victim].fraction][chars_mobs_npcs[current_mob].fraction] = math.min(fractions[chars_mobs_npcs[victim].fraction][chars_mobs_npcs[current_mob].fraction],100-chars_mobs_npcs[current_mob].chr);
		game_status = "neutral";
		letaBattleBegin ();
	elseif index == 3 then
		chars_mobs_npcs[victim].dangerai = "away";
		chars_mobs_npcs[victim].panic = 10;
		chars_mobs_npcs[victim].ai = "away";
		fractions[chars_mobs_npcs[victim].fraction][chars_mobs_npcs[current_mob].fraction] = math.min(fractions[chars_mobs_npcs[victim].fraction][chars_mobs_npcs[current_mob].fraction],100-chars_mobs_npcs[current_mob].chr);
		game_status = "neutral";
		letaBattleBegin ();
	end;
end;
