function dots ()
	for i=1,#chars_mobs_npcs do
		if chars_mobs_npcs[i].status == 1 then
			if chars_mobs_npcs[i].person == "char" then
				tmp_name_dmg= chars_stats[i].name;
			elseif chars_mobs_npcs[i].person == "mob" then
				tmp_name1 = chars_mobs_npcs[i].class;
				tmp_name2 = "lognames.mob_names." .. tmp_name1;
				tmp_name3 = loadstring("return " .. tmp_name2)();
				tmp_name_dmg = tmp_name3;
			end;
			if chars_mobs_npcs[i].flame_dur>0 then
				chars_mobs_npcs[i].hp = chars_mobs_npcs[i].hp-chars_mobs_npcs[i].flame_power;
				dmg = chars_mobs_npcs[i].flame_power*(100-chars_mobs_npcs[i].rezfire)/100;
				helpers.addToActionLog( tmp_name_dmg .. logaction_titles.gotdmg[chars_mobs_npcs[current_mob].gender]  .. logaction_titles.metr .. " " .. logaction_titles.oflife .. types_of_damage.fire);
			end;
			if chars_mobs_npcs[i].poison_dur > 0 then
				chars_mobs_npcs[i].hp = chars_mobs_npcs[i].hp-chars_mobs_npcs[i].poison_power
				dmghp = chars_mobs_npcs[i].poison_power*(100-chars_mobs_npcs[i].rezpoison)/100
				table.insert(damaged_mobs,{i,dmghp})
				helpers.addToActionLog( tmp_name_dmg .. logaction_titles.gotdmg[chars_mobs_npcs[current_mob].gender]  .. logaction_titles.metr .. " " .. dmghp .. logaction_titles.oflife .. types_of_damage.poison);
			end;
			if chars_mobs_npcs[i].cold_dur > 0 then
				chars_mobs_npcs[i].hp = chars_mobs_npcs[i].hp-chars_mobs_npcs[i].cold_power;
				dmghp = chars_mobs_npcs[i].cold_power*(100-chars_mobs_npcs[i].rezcold)/100;
				dmgst = dmghp;
				table.insert(damaged_mobs,{i,dmg});
				--helpers.addToActionLog( tmp_name_dmg .. logaction_titles.gotdmg[chars_mobs_npcs[current_mob].gender]  .. logaction_titles.metr .. " " .. dmghp .. logaction_titles.oflife .. types_of_damage.cold);
				--helpers.addToActionLog( tmp_name_dmg .. logaction_titles.gotdmg[chars_mobs_npcs[current_mob].gender]  .. logaction_titles.metr .. " " .. dmgst .. logaction_titles.ofst);
				damage.HPminus(i,dmghp);
				damage.STminus(i,dmgst);
			end;
			for a=1,map_w do
				for b=1,map_h do
					dmghp = math.min(dlandscape_power[a][b]*math.ceil((100-chars_mobs_npcs[i].hp)/100),chars_mobs_npcs[i].hp);
					if dlandscape_obj[a][b] == "fire" 
					and chars_mobs_npcs[i].x == b
					and chars_mobs_npcs[i].y == a
					and chars_mobs_npcs[i].freeze == 0
					and chars_mobs_npcs[i].stone == 0 then
						chars_mobs_npcs[i].hp= chars_mobs_npcs[i].hp - dmghp;
						table.insert(damaged_mobs,{i,dmghp});
						helpers.addToActionLog( tmp_name_dmg .. logaction_titles.gotdmg[chars_mobs_npcs[current_mob].gender]  .. logaction_titles.metr .. logaction_titles.oflife .. " " .. dmghp .. types_of_damage.fire);
					end;
					if dlandscape_obj[a][b] == "poison" 
					and chars_mobs_npcs[i].x == b
					and chars_mobs_npcs[i].y == a
					and chars_mobs_npcs[i].freeze == 0
					and chars_mobs_npcs[i].stone == 0 then
						if chars_mobs_npcs[i].person == "char" then
							dmghp = math.min(dlandscape_power[a][b],chars_dyns[i].hp-chars_mobs_npcs[i].hp);
							tmp_name_dmg= chars_stats[i].name;
						elseif chars_mobs_npcs[i].person == "mob" then
							dmghp = dlandscape_power[a][b];
							tmp_name1 = chars_mobs_npcs[i].class;
							tmp_name2 = "lognames.mob_names." .. tmp_name1;
							tmp_name3 = loadstring("return " .. tmp_name2)();
							tmp_name_dmg = tmp_name3;
						end;
						if chars_mobs_npcs[i].poison_power <= dlandscape_power[a][b] then -- add poison to a mob only if landscape cloud is stronger curren nob`s poisoning
							chars_mobs_npcs[i].poison_power = math.max(dlandscape_power[a][b],chars_mobs_npcs[i].poison_power)
							chars_mobs_npcs[i].poison_dur = chars_mobs_npcs[i].poison_dur+3;
						end;
						table.insert(damaged_mobs,{i,dmghp});
						helpers.addToActionLog( tmp_name_dmg .. logaction_titles.poisoned);
					end;
				end;
			end;
		end;
	end;
end;
