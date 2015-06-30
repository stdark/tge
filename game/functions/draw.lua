draw = {};

function draw.background ()
	for i=1,bgmap_h do
		for h=1,bgmap_w do  
			--draw.irradiation (i,h);
			--if (h-map_x) <= 8 and (i-map_y) <= 3 and bgmap[i] and bgmap[i][h] then
			if bgmap[i] and bgmap[i][h] then
				love.graphics.draw(media.images.back, background_[bgmap[i][h]], (h-1)*back_size-map_x*64, (i-1)*back_size-map_y*32*0.75);
			end;
		end;
	end;
	love.graphics.setColor(255, 255, 255);
end

function draw.map()
	for my=1, math.min(map_display_h, map_h-map_y) do
		for mx=1, math.min(map_display_w, map_w-map_x) do
			--draw.irradiation(mx,my);
			if map[my+map_y][mx+map_x] > 20 and map[my+map_y][mx+map_x] < 300 then
				draw.drawHex(mx+map_x,my+map_y,tile[map[my+map_y][mx+map_x]]);
			end;	        	
			for i=3,1,-1 do
				if tlandscape[my+map_y][mx+map_x][i].decal == "ash" and darkness[1][my+map_y][mx+map_x] == 0 then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, ash_dec,((mx-1)*tile_w+left_space+tile_hw)-tile_w-32, (my-1)*tile_h*0.75+top_space);
					else
						love.graphics.draw(media.images.tmpobjs,ash_dec,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-32, (my-1)*tile_h*0.75+top_space);
					end;
				elseif tlandscape[my+map_y][mx+map_x][i].decal == "blood" and darkness[1][my+map_y][mx+map_x] == 0 then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, blood_dec,((mx-1)*tile_w+left_space+tile_hw)-tile_w-32, (my-1)*tile_h*0.75+top_space);
					else
						love.graphics.draw(media.images.tmpobjs,blood_dec,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-32, (my-1)*tile_h*0.75+top_space);
					end;
				elseif tlandscape[my+map_y][mx+map_x][i].decal == "track" and darkness[1][my+map_y][mx+map_x] == 0 and chars_mobs_npcs[current_mob].num_spothidden*chars_mobs_npcs[current_mob].lvl_spothidden >= 10 and chars_mobs_npcs[current_mob].num_monsterid*chars_mobs_npcs[current_mob].lvl_monsterid >= 10 then
					local decal = tlandscape[my+map_y][mx+map_x][i].param;
					local rot = tlandscape[my+map_y][mx+map_x][i].rotation;
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs,track_img[rot][decal],((mx-1)*tile_w+left_space+tile_hw)-tile_w-32, (my-1)*tile_h*0.75+top_space,0,1,1);
					else
						love.graphics.draw(media.images.tmpobjs,track_img[rot][decal],((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-32, (my-1)*tile_h*0.75+top_space,0,1,1);
					end;
				end;
	        end;
		end;
	end;
	love.graphics.setColor(255, 255, 255);
 end;

function draw.submap()
	for my=1, math.min(map_display_h, map_h-map_y) do
		for mx=1, math.min(map_display_w, map_w-map_x) do
			if submap[my+map_y][mx+map_x] > 20 and map[my+map_y][mx+map_x] <= 20 then
				draw.drawHex(mx+map_x,my+map_y,tile[submap[my+map_y][mx+map_x]]);
			end;	        	
		end;
	end;
	love.graphics.setColor(255, 255, 255);
 end; 
 
function draw.numbers()
	for my=1, math.min(map_display_h, map_h-map_y) do
		for mx=1, math.min(map_display_w, map_w-map_x) do
			draw.drawNumberHex (mx+map_x,my+map_y,16,mx);
			draw.drawNumberHex (mx+map_x,my+map_y,32,"x");
			draw.drawNumberHex (mx+map_x,my+map_y,48,my);
		end;
	end;
	love.graphics.setColor(255, 255, 255);
 end;
 
function draw.cursor ()
	local missle_form = nil;
	if chars_mobs_npcs[current_mob].control=="player"
	and cursor_world_x>map_limit_w 
	and cursor_world_x<map_w-map_limit_w 
	and cursor_world_y>map_limit_h 
	and cursor_world_y<map_h-map_limit_h
	and darkness[1][cursor_world_y][cursor_world_x] ~= 2 then
		moveto_hex_y = math.ceil((mY-top_space)/tile_h*1.25-1)*tile_h*0.75+top_space
		if math.ceil(((mY-top_space)/tile_h*1.25-1))/2 == math.ceil(math.ceil(((mY-top_space)/tile_h*1.25-1)/2)) then
			moveto_hex_x = math.ceil((mX-left_space)/tile_w)*tile_w+left_space+tile_w/2;
		else
			moveto_hex_x = math.ceil((mX-left_space)/tile_w)*tile_w+left_space;
		end;
		if chars_mobs_npcs[current_mob].control == "player" then
			if not helpers.isAimOnMob () then
				if game_status == "neutral" then
					draw.drawHex (cursor_world_x,cursor_world_y,cursor_q);
				end;
				if global.status == "battle" and game_status == "path_finding" and (helpers.cursorAtEnemy (cursor_world_x,cursor_world_y) or helpers.cursorAtNPC (cursor_world_x,cursor_world_y)) then
					draw.drawHitHex (cursor_world_x,cursor_world_y);
				end;
				if global.status == "peace" and game_status == "path_finding" and helpers.cursorAtNPC (cursor_world_x,cursor_world_y) then
					draw.drawHex (cursor_world_x,cursor_world_y,cursor_yellow);
				end;
				local cursor_at_chest, pointx,pointy,rotation_to_chest = helpers.cursorAtChest(cursor_world_x,cursor_world_y);
				if cursor_at_chest then
					draw.drawHex (cursor_world_x,cursor_world_y,cursor_yellow);
				end;
				if helpers.cursorAtObject(cursor_world_x,cursor_world_y) then
					draw.drawHex (cursor_world_x,cursor_world_y,cursor_yellow);
				end;
				if helpers.cursorAtMaterialBag(cursor_world_x,cursor_world_y) then
					draw.drawHex (cursor_world_x,cursor_world_y,cursor_yellow);
				end;
				if helpers.cursorAtBuilding(cursor_world_x,cursor_world_y) then
					draw.drawHex (cursor_world_x,cursor_world_y,cursor_yellow);
				end;
			else
				draw.drawHex (cursor_world_x,cursor_world_y,cursor_red);
			end;
			cursor_px_x = moveto_hex_x-tile_w;
			cursor_px_y = moveto_hex_y;
			if game_status == "sensing" then
				local lvl,num = helpers.countBoomNumbers ();
				if missle_drive == "alchemy" or missle_drive == "book" or missle_drive == "scroll" or missle_drive == "wand" then
					local lvl,num = helpers.countBoomNumbers (missle_drive);
				elseif missle_drive == "muscles" and  helpers.missleAtWarBook() then
					missle_form = tricks.tricks_tips[missle_type].form;
				end;
				if helpers.singleShot () and helpers.cursorAtMob (cursor_world_x,cursor_world_y) and trace.arrowStatus(current_mob) then
					draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
				elseif missle_type == "bottle" and helpers.passWalk(cursor_world_x,cursor_world_y) then
					draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
				elseif missle_drive == "muscles" and  helpers.missleAtWarBook() and missle_form == "fan" then
				elseif missle_drive == "muscles" and  helpers.missleAtWarBook() and missle_form == "arrow" then
					draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
				elseif missle_drive == "muscles" and  helpers.missleAtWarBook() and missle_form == "ball" then
					draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
				elseif (missle_drive == "spellbook" or missle_drive == "scroll" or missle_drive == "wand") then
					missle_form = magic.spell_tips[missle_type].form;
					if missle_form == "arrow" and helpers.cursorAtMob (cursor_world_x,cursor_world_y) and trace.arrowStatus(current_mob) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "direct" and helpers.cursorAtMob (cursor_world_x,cursor_world_y) then --and trace.arrowStatus(current_mob) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "enemy" and helpers.cursorAtMob (cursor_world_x,cursor_world_y) then --and trace.arrowStatus(current_mob) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "ally" and helpers.cursorAtPartyMember (cursor_world_x,cursor_world_y) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "proactive" and helpers.cursorAtPartyMember (cursor_world_x,cursor_world_y) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "deadally" and helpers.cursorAtDeadPartyMember (cursor_world_x,cursor_world_y) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "deadenemy" and helpers.cursorAtDeadMob (cursor_world_x,cursor_world_y) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "skyray" and helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "skyrock" then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "ring" and helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "ball" and helpers.cursorAtMob (cursor_world_x,cursor_world_y) and trace.arrowStatus(current_mob) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "rico" and helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "wall" and not helpers.cursorAtMob (cursor_world_x,cursor_world_y) and helpers.passCheck (cursor_world_x,cursor_world_y) then
						--draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "mine" and not helpers.cursorAtMob (cursor_world_x,cursor_world_y) and helpers.passWalk (cursor_world_x,cursor_world_y) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "portal" and not helpers.cursorAtMob (cursor_world_x,cursor_world_y) and helpers.passWalk (cursor_world_x,cursor_world_y) then
						draw.drawHex (chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,cursor_danger);
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "area" then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form ~= "mole" and missle_form ~= "rain" and missle_form ~= "area" and missle_form ~= "sight" then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_white);
					elseif missle_type == "twister" then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "sign" and helpers.cursorAtMob (cursor_world_x,cursor_world_y) and trace.arrowStatus(current_mob) then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "mole" then
						draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
					elseif missle_form == "baff3stage" then
						--[[if stage == 1 and helpers.cursorAtPartyMember (cursor_world_x,cursor_world_y) then --ally
							draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
						elseif stage == 2 then --ball 1
							draw.drawHex (cursor_world_x,cursor_world_y,cursor_danger);
						elseif stage == 3 then -- level
						end;]]
					end;
				end;
				
				if missle_type == "bottle" then
					local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
					for i=1,#rings[1] do
						draw.drawHex(rings[1][i].x,rings[1][i].y,cursor_danger);
					end;
				end;
	
				if missle_type=="inferno" or missle_type=="prismaticlight" or missle_type=="eyeofthestorm"  or missle_type=="moonlight" or missle_type=="souldrinker" or missle_type =="masscurse" or missle_type == "massdispell" or missle_type =="misfortune" or missle_type == "despondency" or missle_type == "weakness"  or missle_type == "violation" then
					local boomarea = boomareas.sightArea(); 
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);	
					end;
				end;
			 
				if missle_type == "evilswarm" then
					if helpers.cursorAtMob (cursor_world_x,cursor_world_y) and trace.arrowStatus(current_mob) then
						local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
						for i=1,#rings[1] do
							draw.drawHex(rings[1][i].x,rings[1][i].y,cursor_danger);
						end;
					end;
				end;
				
				if missle_type == "bitingcloud" then
					local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,3+math.ceil(chars_mobs_npcs[current_mob].mgt/10),false);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "fireball" then
					if helpers.cursorAtMob (cursor_world_x,cursor_world_y) and trace.arrowStatus(current_mob) then
						local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
						for i=1,#rings[1] do
							draw.drawHex(rings[1][i].x,rings[1][i].y,cursor_danger);
						end;
					end;
				end;
				
				if missle_type == "firemine" then
					if not helpers.cursorAtMob (cursor_world_x,cursor_world_y) and helpers.passCheck (cursor_world_x,cursor_world_y) then
						local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
						for i=1,#rings[1] do
							draw.drawHex(rings[1][i].x,rings[1][i].y,cursor_danger);
						end;
					end;
				end;
				
				if missle_type == "jump" then
					local ringA = boomareas.smallRingArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
					local ringB = boomareas.smallRingArea(cursor_world_x,cursor_world_y);
					for i=1,6 do
						if helpers.passCheck(ringA[i].x,ringA[i].y) and  helpers.passCheck(ringB[i].x,ringB[i].y) and not helpers.cursorAtMob (ringB[i].x,ringB[i].y) then
							draw.drawHex(ringA[i].x,ringA[i].y,cursor_danger);
							draw.drawHex(ringB[i].x,ringB[i].y,cursor_danger);
						end;
					end;
					if helpers.passCheck(cursor_world_x,cursor_world_y) and not helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
						draw.drawHex(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,cursor_danger);
						draw.drawHex(cursor_world_x,cursor_world_y,cursor_danger);
					end;
				end;
				
				if missle_type == "firebelt" then
					local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
					for i=1,#rings[1] do
						draw.drawHex(rings[1][i].x,rings[1][i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "iceball" then
					if helpers.cursorAtMob (cursor_world_x,cursor_world_y) and trace.arrowStatus(current_mob) then
						local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
						for i=1,#rings[1] do
							draw.drawHex(rings[1][i].x,rings[1][i].y,cursor_danger);
						end;
					end;
				end;
			 
				if missle_type == "rockblast" then
					local lvl,num = helpers.countBoomNumbers (missle_drive);
					local rings,line = boomareas.ricoBallArea(5 + num[current_mob],1, 0, false);
					rockline = line;
					draw.drawHex(rings[4][1].x,rings[4][1].y,cursor_danger);
					for i=1,#rings[1] do
						draw.drawHex(rings[1][i].x,rings[1][i].y,cursor_danger);
					end;
					for i=1,#line do
						draw.drawHex(line[i].x,line[i].y,cursor_white);
					end;
				end;
				
				if missle_type == "toxiccloud" then
					local lvl,num = helpers.countBoomNumbers (missle_drive);
					local rings,line = boomareas.ricoBallArea(5 + num[current_mob],1, 1, false);
					rockline = line;
					draw.drawHex(rings[4][1].x,rings[4][1].y,cursor_danger);
					for i=1,#rings[1] do
						draw.drawHex(rings[1][i].x,rings[1][i].y,cursor_danger);
					end;
					for i=1,#line do
						draw.drawHex(line[i].x,line[i].y,cursor_white);
					end;
				end;
				
				if missle_type == "deathblossom" then
					local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
					for h=1,2 do
						for i=1,#rings[h] do
							draw.drawHex(rings[h][i].x,rings[h][i].y,cursor_danger);
						end;
					end;
				end;
				
				if missle_type == "comete" then
					local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
					for h=1,3 do
						for i=1,#rings[h] do
							draw.drawHex(rings[h][i].x,rings[h][i].y,cursor_danger);
						end;
					end;
				end
				
				if missle_type == "meteorshower" then
					local power = 1;
					local boomarea,sharea = boomareas.showerArea(cursor_world_x,cursor_world_y,12,power);
					for i=2, #boomarea[1] do
						draw.drawHex(boomarea[1][i].x,boomarea[1][i].y,cursor_danger);	
					end;
					for h=1, #sharea do
						draw.drawHex(sharea[h].x,sharea[h].y,cursor_danger);
					end;
				end;
				
				if missle_type == "starburst" then
					local power = 1;
					local boomarea,sharea = boomareas.showerArea(cursor_world_x,cursor_world_y,18,power);
					for i=2, #boomarea[1] do
						draw.drawHex(boomarea[1][i].x,boomarea[1][i].y,cursor_danger);	
					end;
					for h=1, #sharea do
						draw.drawHex(sharea[h].x,sharea[h].y,cursor_danger);
					end;
				end;
				
				if missle_type == "acidrain" then
					local power = 1;
					local boomarea,sharea = boomareas.showerArea(cursor_world_x,cursor_world_y,18,power);
					for i=2, #boomarea[1] do
						draw.drawHex(boomarea[1][i].x,boomarea[1][i].y,cursor_danger);	
					end;
					for h=1, #sharea do
						draw.drawHex(sharea[h].x,sharea[h].y,cursor_danger);
					end;
				end;
				
				if missle_type == "firewall" then
					local boomarea = boomareas.wallArea(cursor_world_x,cursor_world_y,spell_rotation,1);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "stonewall" then
					local boomarea = boomareas.wallArea(cursor_world_x,cursor_world_y,spell_rotation,1);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "pitfall" then
					local boomarea = boomareas.wallArea(cursor_world_x,cursor_world_y,spell_rotation,1);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "twister" then
					local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
					for h=1,2 do
						for i=1,#rings[h] do
							draw.drawHex(rings[h][i].x,rings[h][i].y,cursor_danger);
						end;
					end;
				end;
				
				if missle_type == "icefield" then
					local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,11,0);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "mud" then
					local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,11,0);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "coldray" then
					local boomarea = boomareas.rayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,11,0);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "lightray" then
					local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,11,0);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "razors" then
					local boomarea = boomareas.pathArea(2,0);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_white);
					end;
				end;
				
				if missle_type == "spikes" then
					local boomarea = boomareas.pathArea(2,1);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "powerheal" then
					local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
					for h=1,3 do
						for i=1,#rings[h] do
							draw.drawHex(rings[h][i].x,rings[h][i].y,cursor_danger);
						end;
					end;
				end;
				
				if missle_type == "pandemia" then
					local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
					for h=1,3 do
						for i=1,#rings[h] do
							draw.drawHex(rings[h][i].x,rings[h][i].y,cursor_danger);
						end;
					end;
				end;
				
				if missle_type == "darkcontamination" then
					local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
					for h=1,3 do
						for i=1,#rings[h] do
							draw.drawHex(rings[h][i].x,rings[h][i].y,cursor_danger);
						end;
					end;
				end;
				
				if missle_type == "dragonbreath" then
					if helpers.cursorAtMob (cursor_world_x,cursor_world_y) and trace.arrowStatus(current_mob) then
						local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
						for h=1,3 do
							for i=1,#rings[h] do
								draw.drawHex(rings[h][i].x,rings[h][i].y,cursor_danger);
							end;
						end;
					end;
				end;
				
				if missle_type == "coldray" then
					local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,0);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "lightray" then
					local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,0);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "fireblast" then
					local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,4,true);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "bell" then
					local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,7,true);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "megavolts" then
					local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,5,true);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				
				if missle_type == "shrapmetal" then
					local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,3+lvl[1],false);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type=="genocide" then
					local boomarea = boomareas.signArea("class",genocidetheme);
					for i=1,#boomarea do
						draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
					end;
				end;
				
				if missle_type == "firering" then
					if helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
						local mobID = helpers.mobIDUnderCursor (cursor_world_x,cursor_world_y);
						local mob = chars_mobs_npcs[mobID];
						if helpers.mobIsAlive(mob) and helpers.ifMobIsCastable(mob) then
							local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
							if lvl[1] == 5 then
								for i=1,#rings[3] do
									draw.drawHex(rings[3][i].x,rings[3][i].y,cursor_danger);
								end;
							end;
							for i=1,#rings[2] do
								draw.drawHex(rings[2][i].x,rings[2][i].y,cursor_danger);
							end;
						end;
					end;
				end;
				
				if missle_type == "coldring" then
					if helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
						local mobID = helpers.mobIDUnderCursor (cursor_world_x,cursor_world_y);
						local mob = chars_mobs_npcs[mobID];
						if helpers.mobIsAlive(mob) and helpers.ifMobIsCastable(mob) then
							local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
							for i=1,#rings[3] do
								draw.drawHex(rings[3][i].x,rings[3][i].y,cursor_danger);
							end;
							for i=1,#rings[2] do
								draw.drawHex(rings[2][i].x,rings[2][i].y,cursor_danger);
							end;
						end;
					end;
				end;
				
				if missle_type == "deadlywave" then
					if helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
						local mobID = helpers.mobIDUnderCursor (cursor_world_x,cursor_world_y);
						local mob = chars_mobs_npcs[mobID];
						if helpers.mobIsAlive(mob) and helpers.ifMobIsCastable(mob) then
							local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
							for i=1,#rings[3] do
								draw.drawHex(rings[3][i].x,rings[3][i].y,cursor_danger);
							end;
							for i=1,#rings[2] do
								draw.drawHex(rings[2][i].x,rings[2][i].y,cursor_danger);
							end;
						end;
					end;
				end;
				
				if missle_type == "shockring" then -- remove conditions to love.
					if helpers.cursorAtPartyMember (cursor_world_x,cursor_world_y) then
						local mobID = helpers.mobIDUnderCursor (cursor_world_x,cursor_world_y);
						local mob = chars_mobs_npcs[mobID];
						if helpers.mobIsAlive(mob) and helpers.ifMobIsCastable(mob) then
							local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
							for i=1,#rings[1] do
								draw.drawHex(rings[1][i].x,rings[1][i].y,cursor_danger);
							end;
						end;
					end;
				end;
				
				if missle_type=="chainlightning" then
					local lvl,num = helpers.countBoomNumbers (missle_drive);
					if helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
						local boomarea, linetable, mobs = boomareas.chainArea(cursor_world_x,cursor_world_y, lvl[1], 3);
						mobsmarked = mobs; -- ARGH!!!
						for i=1,#boomarea do
							draw.drawHex(boomarea[i].x,boomarea[i].y,cursor_danger);
							
						end;
						if #linetable >= 4 then
							love.graphics.setColor(255, 0, 0);
							love.graphics.line(linetable);
							love.graphics.setColor(255, 255, 255);
						end;
					end;
				end;
				
				if missle_type == "ritualofthevoid" then
					local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
					for h=1,3 do
						for i=1,#rings[h] do
							draw.drawHex(rings[h][i].x,rings[h][i].y,cursor_danger);
						end;
					end;
				end;
				--[[if missle_type == "jump" then
					if not helpers.cursorAtMob (cursor_world_x,cursor_world_y) and helpers.passCheck (cursor_world_x,cursor_world_y) then
						local rings = boomareas.ringArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
						local rings2 = boomareas.ringArea(cursor_world_x,cursor_world_y);
						for i=1,#rings[1] do
							draw.drawHex(rings[1][i].x,rings[1][i].y,cursor_danger);
						end;
						for i=1,#rings2[1] do
							draw.drawHex(rings2[1][i].x,rings2[1][i].y,cursor_danger);
						end;
					end;
				end;]]
				
				if missle_type == "armageddon" then
					for mx = map_x,math.min(map_w + map_display_w) do
						for my = map_y,math.min(map_h + map_display_h) do
							draw.drawHex(mx,my,cursor_danger);	
						end;
					end;
				end;
				
			end; --/ end if spell
		end;--/ end if game_status == "sensing"
	end;
end;

--function boom (boomx,boomy,level,skill) --visual effects of spell explosions and landscape effects
--function boom (boomx,boomy,var1,var2)
function draw.boom ()
	utils.printDebug("BOOM!");
	draw.shaderIrradiation ();
	--print(missle_type,missle_subtype);
	helpers.clearMissleLight ();
	local lvl,num = helpers.countBoomNumbers ();
	game_status="boom";
	local boomdur = 1;
	local boompower = 1;
	local lvl,num = helpers.countBoomNumbers (missle_drive);
	bm_timer = 0;
	sfx.boomSound ();
	--print(missle_type ,missle_subtype);
	if (missle_type == "bottle" and missle_subtype == "firebomb") or missle_type == "firebomb" then
		boomareas.fireExploGround (boomx,boomy);
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				boomareas.startFireGround(rings[1][i].x,rings[1][i].y,1,lvl,num);
			end;
		end;
	end;
	
	if (missle_type == "bottle" and missle_subtype == "acidbomb") or missle_type == "acidbomb" then
		boomareas.acidExploGround (boomy,boomx);
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				boomareas.acidExploGround(rings[1][i].x,rings[1][i].y,1,lvl,num);
			end;
		end;
	end;
	
	if (missle_type == "bottle" and missle_subtype == "toxicbomb") or missle_type == "toxicbomb" then
		boomareas.acidExploGround (boomx,boomy,1,lvl,num);
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				boomareas.poisonAir(rings[1][i].x,rings[1][i].y,1,lvl[1],num[1]);
			end;
		end;
	end;
	
	if missle_drive == "revenge" and missle_type == "revenge" then
		local boomarea = {};
		for i=1,#mobs_revengers do
			local rings = boomareas.ringArea(chars_mobs_npcs[mobs_revengers[i]].x,chars_mobs_npcs[mobs_revengers[i]].y);
			   if chars_mobs_npcs[mobs_revengers[i]].revenge_type == "acid" then
					boomareas.acidExploGround (chars_mobs_npcs[mobs_revengers[i]].x,chars_mobs_npcs[mobs_revengers[i]].y);
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "poison" then
					boomareas.poisonExploGround (chars_mobs_npcs[mobs_revengers[i]].x,chars_mobs_npcs[mobs_revengers[i]].y);
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "disease" then
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "fire" then
					boomareas.fireExploGround (chars_mobs_npcs[mobs_revengers[i]].x,chars_mobs_npcs[mobs_revengers[i]].y);
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "static" then
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "cold" then
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "light" then
				end;
			for h=1,6 do
				table.insert(boomarea,{x=rings[1][h].x,y=rings[1][h].y});
				if chars_mobs_npcs[mobs_revengers[i]].revenge_type == "acid" then
					boomareas.acidExploGround (rings[1][h].x,rings[1][h].y);
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "poison" then
					boomareas.poisonAir(rings[1][h].x,rings[1][h].y);
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "disease" then
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "fire" then
					boomareas.fireStartGround (rings[1][h].x,rings[1][h].y);
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "static" then
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "cold" then
				elseif chars_mobs_npcs[mobs_revengers[i]].revenge_type == "light" then
				end;
			end;
		end;
	end;
	
	if missle_type == "fireball" then
		boomareas.fireExploGround (boomx,boomy);
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				boomareas.startFireGround(rings[1][i].x,rings[1][i].y,i,lvl,num);
			end;
		end;
	end;
	
	if missle_type == "dragonbreath" then
		boomareas.poisonAir(boomx,boomy);
		local i = 1;
		boomareas.poisonAir(boomx,boomy);
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,3 do
			for i=1,#rings[h] do
				boomareas.poisonAir(rings[h][i].y,rings[h][i].x);
			end;
		end;
	end;
	
	if missle_type == "earthquake" then
		elandscape[boomy][boomx] = "dust";
		local i = 1;
		boomareas.poisonAir(boomx,boomy);
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,3 do
			for i=1,#rings[h] do
				elandscape[rings[h][i].y][rings[h][i].x] = "dust";
			end;
		end;
	end;
	
	if missle_type == "deadlywave" then
		elandscape[boomy][boomx] = "deadlywave";
	end;
	
	if missle_type == "friendlyfire" then
		local xx,yy = helpers.hexToPixels (x,y);
		table.insert(lights,{x=boomx,y=boomy,light=lightWorld.newLight(xx, yy, 255, 255, 255, 128),typ="boom"});
		elandscape[boomy][boomx] = "flame";
		boomareas.poisonAir(boomx,boomy);
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,3 do
			for i=1,#rings[h] do
				elandscape[rings[h][i].y][rings[h][i].x] = "flame";
			end;
		end;
	end;
	
	if missle_type == "jump" then
		local ringA = boomareas.smallRingArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y);
		local ringB = boomareas.smallRingArea(cursor_world_x,cursor_world_y);
		for i=1,6 do
			if helpers.passCheck(ringA[i].x,ringA[i].y) and  helpers.passCheck(ringB[i].x,ringB[i].y) then
				elandscape[ringA[i].y][ringA[i].x] ="dust";
				elandscape[ringB[i].y][ringB[i].x] ="dust";
			end;
		end;
		if helpers.passCheck(cursor_world_x,cursor_world_y) then
			elandscape[chars_mobs_npcs[current_mob].y][chars_mobs_npcs[current_mob].x] ="dust";
		end;
	end;

	if missle_type == "firebelt" then
		local rings = boomareas.ringArea(boomx,boomy);
		for i=1,#rings[1] do
			elandscape[rings[1][i].y][rings[1][i].x] = "flame";
		end;
	end;
	
	if missle_type == "iceball" then --destroy poison, destroy snow/ice with low
		--elandscape[boomy][boomx] ="snow";
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[1] do
				if helpers.passJump(rings[1][i].x,rings[1][i].y) then
					elandscape[rings[1][i].y][rings[1][i].x] = "frost";
				end;
			end;
		end;
	end;
	
	if missle_type == "toxiccloud" then
		boomareas.poisonAir(boomx,boomy);
		local rings = boomareas.ringArea(boomx,boomy);
	end;
	
	if missle_type == "rockblast" then
		elandscape[boomy][boomx] ="dust";
		local rings = boomareas.ringArea(boomx,boomy);
		for h=1,boompower do
			for i=1,#rings[h] do
				if helpers.passJump(rings[h][i].y,rings[h][i].x) then
					elandscape[rings[h][i].y][rings[h][i].x] = "dust";
				end;
			end;
		end;
	end;
	
	if missle_type == "fireblast" then
		local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,4,0);
		for i=1,#boomarea do
			boomareas.flameAir(boomarea[i].x,boomarea[i].y);
		end;
	end;
	
	if missle_type == "bell" then
		local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,7,1);
		for i=1,#boomarea do
			boomareas.windAir (boomarea[i].x,boomarea[i].y)
		end;
	end;
	
	if missle_type == "megavolts" then
		local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,5,0);
		for i=1,#boomarea do
			boomareas.staticGround (boomarea[i].x,boomarea[i].y)
		end;
	end;
	
	if missle_type == "shrapmetal" then
		local boomarea = boomareas.waveArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,3+lvl[1],0);
		for i=1,#boomarea do
			elandscape[boomarea[i].y][boomarea[i].x] = "shrap";
		end;
	end;
	
	if missle_type == "shockring" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for i=1,#rings[1] do
			boomareas.staticGround (rings[1][i].x,rings[1][i].y);
		end;
	end;
	
	if missle_type == "firering" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for i=1,#rings[3] do
			if lvl[1] == 5 then
				boomareas.flameAir (rings[3][i].x,rings[3][i].y);
			end;
		end;
		for i=1,#rings[2] do
			boomareas.flameAir (rings[3][i].x,rings[3][i].y);
		end;
	end;
	
	if missle_type == "coldring" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for i=1,#rings[3] do
			boomareas.frostAir (rings[3][i].x,rings[3][i].y);
		end;
		for i=1,#rings[2] do
			boomareas.frostAir (rings[3][i].x,rings[3][i].y);
		end;
	end;
	
	if missle_type == "firewall" then
		local boomarea = boomareas.wallArea(cursor_world_x,cursor_world_y,spell_rotation,1);
		for i=1,#boomarea do
			boomareas.startFireGround(boomarea[i].x,boomarea[i].y,1,lvl[1],num[1]);
		end;
	end;
	
	if missle_type == "stonewall" then
		local boomarea = boomareas.wallArea(cursor_world_x,cursor_world_y,spell_rotation,1);
		for i=1,#boomarea do
			boomareas.startWallGround(boomarea[i].y,boomarea[i].x,1,lvl[1],num[1]);
		end;
	end;
	
	if missle_type == "pitfall" then
		local boomarea = boomareas.wallArea(cursor_world_x,cursor_world_y,spell_rotation,1);
		for i=1,#boomarea do
			boomareas.pitGround(boomarea[i].x,boomarea[i].y,1,lvl[1],num[1]);
		end;
	end;
	
	if missle_type == "twister" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		dlandscape_obj[cursor_world_y][cursor_world_x] = "twister";
		dlandscape_power[cursor_world_y][cursor_world_x] = num[1];
		dlandscape_duration[cursor_world_y][cursor_world_x] = 3+lvl[1];
		alandscape_obj[cursor_world_y][cursor_world_x] = 0;
		alandscape_power[cursor_world_y][cursor_world_x] = 0;
		alandscape_duration[cursor_world_y][cursor_world_x] = 0;	
		for h=1,2 do
			for i=1,#rings[h] do
				--boomareas.twisterGround(boomarea[i].y,boomarea[i].x,1,lvl[1],num[1]);
				--elandscape[rings[h][i].y][rings[h][i].x] = "dust";
				dlandscape_obj[rings[h][i].y][rings[h][i].x] = "twisterpart";
				dlandscape_power[rings[h][i].y][rings[h][i].x] = 1;
				dlandscape_duration[rings[h][i].y][rings[h][i].x] = 3+lvl[1];
				alandscape_obj[rings[h][i].y][rings[h][i].x] = 0;
				alandscape_power[rings[h][i].y][rings[h][i].x] = 0;
				alandscape_duration[rings[h][i].y][rings[h][i].x] = 0;
			end;
		end;
	end;
	
	if missle_type == "powerheal" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,3 do
			for i=1,#rings[h] do
				if helpers.passJump(rings[h][i].y,rings[h][i].x) then
					for i=1,chars do
						if chars_mobs_npcs[i].x == rings[h][i].y and chars_mobs_npcs[i].y == rings[h][i].x then
							elandscape[rings[h][i].y][rings[h][i].x] = "heal";
						end;
					end;
				end;
			end;
		end;
	end;
	
	if missle_type == "ritualofthevoid" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,3 do
			for i=1,#rings[h] do
				if helpers.passJump(rings[h][i].y,rings[h][i].x) then
					elandscape[rings[h][i].y][rings[h][i].x] = "void";
				end;
			end;
		end;
	end;
	
	if missle_type == "razors" then
		local boomarea = boomareas.pathArea(2,1);
		for i=1,math.min(5+chars_mobs_npcs[current_mob].lvl_earth,#boomarea) do
			elandscape[boomarea[i].y][boomarea[i].x] = "dust";
			elandscape[boomy][boomx] = "razor";
		end;
	end;
	
	if missle_type == "spikes" then
		local boomarea = boomareas.pathArea(2,2);
		table.insert(boomarea,{x=boomy,y=boomx});
		--for i=1,math.min(5+chars_mobs_npcs[current_mob].lvl_earth,#boomarea) do
		for i=1,#boomarea do
			elandscape[boomarea[i].y][boomarea[i].x] = "spike";
		end;
	end;
	
	if missle_type == "inferno" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			if i/3 == math.ceil(i/3) then
				boomareas.flameAir(boomarea[i].x,boomarea[i].y);
			else
				elandscape[boomarea[i].y][boomarea[i].x] = "flame";
			end;
		end;
	end;
	
	if missle_type == "prismaticlight" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			if i/3 == math.ceil(i/3) then
				boomareas.lightAir(boomarea[i].x,boomarea[i].y);
			else
				elandscape[boomarea[i].y][boomarea[i].x] = "light";
			end;
		end;
	end;
	
	if missle_type == "violation" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y == boomarea[i].y and chars_mobs_npcs[j].person ~= "char" and chars_mobs_npcs[j].status <= 0 and helpers.aliveNature(j) then
					elandscape[boomarea[i].y][boomarea[i].x] = "souldrinker";
				end;
			end;
		end;
	end;
	
	if missle_type == "souldrinker" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y == boomarea[i].y and chars_mobs_npcs[j].person ~= "char" and chars_mobs_npcs[j].status > 0 then
					elandscape[boomarea[i].y][boomarea[i].x] = "souldrinker";
				end;
			end;
		end;
	end;
	
	if missle_type == "masscurse" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y == boomarea[i].y and chars_mobs_npcs[j].person ~= "char" then
					elandscape[boomarea[i].y][boomarea[i].x] = "souldrinker";
				end;
			end;
		end;
	end;
	
	if missle_type == "misfortune" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y == boomarea[i].y and chars_mobs_npcs[j].person ~= "char" then
					elandscape[boomarea[i].y][boomarea[i].x] = "souldrinker";
				end;
			end;
		end;
	end;
	
	if missle_type == "despondency" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y == boomarea[i].y and chars_mobs_npcs[j].person ~= "char" then
					elandscape[boomarea[i].y][boomarea[i].x] = "souldrinker";
				end;
			end;
		end;
	end;
	
	if missle_type == "weakness" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y == boomarea[i].y and chars_mobs_npcs[j].person ~= "char" then
					elandscape[boomarea[i].y][boomarea[i].x] = "souldrinker";
				end;
			end;
		end;
	end;
	
	if missle_type == "massdispell" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y == boomarea[i].y and chars_mobs_npcs[j].person ~= "char" then
					elandscape[boomarea[i].y][boomarea[i].x] = "moonlight";
				end;
			end;
		end;
	end;
	
	if missle_type == "filth" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y == boomarea[i].y and chars_mobs_npcs[j].person ~= "char" then
					elandscape[boomarea[i].y][boomarea[i].x] = "souldrinker";
				end;
			end;
		end;
	end;
	
		if missle_type == "evileye" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			for j=1,#chars_mobs_npcs do
				if chars_mobs_npcs[j].x == boomarea[i].x and chars_mobs_npcs[j].y == boomarea[i].y and chars_mobs_npcs[j].person ~= "char" then
					elandscape[boomarea[i].y][boomarea[i].x] = "souldrinker";
				end;
			end;
		end;
	end;
	
	if missle_type == "moonlight" then
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			if i/3 == math.ceil(i/3) then
				boomareas.moonlightAir(boomarea[i].y,boomarea[i].x);
			else
				elandscape[boomarea[i].x][boomarea[i].y] = "moonlight";
			end;
		end;
	end;
	
	if missle_type == "icefield" then
		local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,11,0);
		for i=1,#boomarea do
			boomareas.coldAir (boomarea[i].x,boomarea[i].y);
		end;
	end;
	
	if missle_type == "mud" then
		local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,11,0);
		for i=1,#boomarea do
			--boomareas.coldAir (boomarea[i].x,boomarea[i].y);
		end;
	end;
	
	if missle_type == "coldray" then
		local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,0);
		for i=1,#boomarea do
			boomareas.coldAir (boomarea[i].x,boomarea[i].y);
		end;
	end;
				
	if missle_type == "lightray" then
		local boomarea = boomareas.vrayArea(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,chars_mobs_npcs[current_mob].rot,0);
		for i=1,#boomarea do
			boomareas.lightAir (boomarea[i].x,boomarea[i].y);
		end;
	end;
	
	if missle_type == "eyeofthestorm" then
		snoweffect[1].ps:reset();
		snoweffect[1].ps:start();
		local boomarea = boomareas.sightArea(); 
		for i=1,#boomarea do
			elandscape[boomarea[i].y][boomarea[i].x] = "snow";	
		end;
	end;
	
	if missle_type == "meteorshower" then 
		local power = 1;
		local boomarea,sharea = boomareas.showerArea(cursor_world_x,cursor_world_y,12,power);
		for i=2, #boomarea[1] do
			if helpers.passWalk(boomarea[1][i].y,boomarea[1][i].x) then
				boomareas.ashGround (boomarea[1][i].x,boomarea[1][i].y);
				boomareas.fireExploGround (boomarea[1][i].x,boomarea[1][i].y);
			end;
		end;
		for i=1, #sharea do
			if helpers.passWalk(sharea[i].y,sharea[i].x) then
				boomareas.startFireGround(sharea[i].x,sharea[i].y,i,lvl[1],num[1]);
			end;
		end;
	end;
	
	if missle_type == "armageddon" then
		local mx = map_x;
		local my = map_y;
		for i = 1,12 do
			mx = mx + math.ceil(i/3);
			my =  5*(mx - 4*math.ceil(i/3));	
			if helpers.passCheck (mx,my) then
				boomareas.fireExploGround (my,mx);
			end;
		end;
		local mx = map_x;
		local my = map_y
		for i = 1,16 do
			mx = mx + math.ceil(i/4);
			my =  5*(mx - 3*math.ceil(i/4));	
			if helpers.passCheck (my,mx) then	
				elandscape[my][mx] = "dust";
			end;
		end;
	end;
	
	if missle_type == "deathblossom" then
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,2 do
			for i=1,#rings[h] do
				elandscape[rings[h][i].y][rings[h][i].x] = "dust";
			end;
		end;
	end;
	
	if missle_type == "comete" then
		boomareas.ashGround (boomx,boomy);
		local rings = boomareas.ringArea(cursor_world_x,cursor_world_y);
		for h=1,3 do
			for i=1,#rings[h] do
				local roll = math.random(1,6);
				if roll == 1 then
					boomareas.flameAir (rings[h][i].x,rings[h][i].y);
				elseif roll == 2 then
					boomareas.coldAir (rings[h][i].x,rings[h][i].y);
				elseif roll == 3 then
					boomareas.frostAir (rings[h][i].x,rings[h][i].y);
				elseif roll == 4 then
					boomareas.lightAir (rings[h][i].x,rings[h][i].y);
				elseif roll == 5 then
					boomareas.staticGround (rings[h][i].x,rings[h][i].y);
				elseif roll == 6 then
					elandscape[rings[h][i].y][rings[h][i].x] = "dust";
				end;
				boomareas.ashGround (rings[h][i].x,rings[h][i].y);
			end;
		end;
	end
	
	if missle_type == "starburst" then 
		local power = 1;
		local boomarea,sharea = boomareas.showerArea(cursor_world_x,cursor_world_y,18,power);
		for i=2, #boomarea[1] do
			if helpers.passWalk(boomarea[1][i].y,boomarea[1][i].x) then
				boomareas.ashGround (boomarea[1][i].x,boomarea[1][i].y);
				boomareas.staticGround (boomarea[1][i].x,boomarea[1][i].y);
			end;
		end;
		for i=1, #sharea do
			if helpers.passWalk(sharea[i].y,sharea[i].x) then
				boomareas.staticGround(sharea[i].x,sharea[i].y,i,lvl[1],num[1]);
			end;
		end;
	end;
	
	if missle_type == "acidrain" then 
		local power = 3;
		local boomarea,sharea = boomareas.showerArea(cursor_world_x,cursor_world_y,18,power);
		for i=2, #boomarea[1] do
			if helpers.passWalk(boomarea[1][i].y,boomarea[1][i].x) then
				boomareas.ashGround (boomarea[1][i].x,boomarea[1][i].y);
				boomareas.acidExploGround (boomarea[1][i].x,boomarea[1][i].y);
			end;
		end;
		for i=1, #sharea do
			if helpers.passWalk(sharea[i].y,sharea[i].x) then
				boomareas.ashGround(sharea[i].x,sharea[i].y,i,lvl[1],num[1]);
				boomareas.acidExploGround(sharea[i].x,sharea[i].y,i,lvl[1],num[1]);
			end;
		end;
	end;
	
	if missle_type == "chainlightning" then
		local boomarea, linetable = boomareas.chainArea(cursor_world_x,cursor_world_y, lvl[1], 3);
		for i=1,#boomarea do
			boomareas.staticGround(boomarea[i].x,boomarea[i].y);
		end;
	end;
	
	if missle_type == "genocide" then
		local boomarea = boomareas.signArea("class",genocidethem);
		for i=1,#boomarea do
			elandscape[boomarea[i].y][boomarea[i].x] = "souldrinker";
		end;
	end;
	
	helpers.findShadows();
end;

function draw.papermap ()
	local x,y = helpers.centerObject(media.images.map);
	love.graphics.draw(media.images.map, x,y-50);
	local tile_w_paper = 8;
	local tile_h_paper = 4;
	for my=1 + map_y, map_h do
		for mx=1 + map_x, map_w do	
			if darkness[1][my][mx] < 2 then 
				if (my)/2 == math.ceil((my)/2) then
					if map[my][mx] <= 300 then
						love.graphics.setColor(255, 255, 255,125);
						love.graphics.draw(media.images.hex, tile[map[my][mx]],((mx - map_x -1)*tile_w_paper)+x+55, (my- map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
						love.graphics.setColor(255, 255, 255,255);
						love.graphics.draw(media.images.hex, minimap_hexes[minimap_table[map[my][mx]]],((mx - map_x -1)*tile_w_paper)+x+55, (my- map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
					else
						love.graphics.draw(media.images.hex, minimap_hexes[13],((mx - map_x -1)*tile_w_paper)+x+55, (my- map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
					end;
					for e=1,chars do
						if chars_mobs_npcs[e].x == mx and chars_mobs_npcs[e].y == my then
							--love.graphics.draw(media.images.hex, cursor_danger,((mx - map_x - 1)*tile_w_paper)+320, (my - map_y - 1)*tile_h_paper*0.75+100,0,0.3);
							love.graphics.draw(media.images.ui, papermap_pin,((mx - map_x - 1)*tile_w_paper)+x+60, (my - map_y - 1)*tile_h_paper*0.75+y-20,0,1);--
						end;
					end;
				else
					if map[my][mx] <= 300 then
						love.graphics.setColor(255, 255, 255,125);
						love.graphics.draw(media.images.hex, tile[map[my][mx]],((mx - map_x - 1)*tile_w_paper+tile_w_paper/2)+x+55, (my - map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
						love.graphics.setColor(255, 255, 255,255);
						love.graphics.draw(media.images.hex, minimap_hexes[minimap_table[map[my][mx]]],((mx - map_x - 1)*tile_w_paper+tile_w_paper/2)+x+55, (my - map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
					else
						love.graphics.draw(media.images.hex, minimap_hexes[13],((mx - map_x - 1)*tile_w_paper+tile_w_paper/2)+x+55, (my - map_y - 1)*tile_h_paper*0.75+y+15,0,0.15);
					end;
					for e=1,chars do
						if chars_mobs_npcs[e].x==mx and chars_mobs_npcs[e].y==my then
							--love.graphics.draw(media.images.hex, cursor_danger,((mx - map_x - 1)*tile_w_paper)+320+tile_w_paper/2, (my - map_y - 1)*tile_h_paper*0.75+100,0,0.3);
							love.graphics.draw(media.images.ui, papermap_pin,((mx - map_x - 1)*tile_w_paper)+x+60+tile_w_paper/2, (my - map_y - 1)*tile_h_paper*0.75+y-20,0,1);--
						end;
					end;
				end;
			end;
		end;
	end;
end;

function draw.gameover ()
	local x,y = helpers.centerObject(media.images.gameover);
	love.graphics.draw(media.images.gameover, x,y-50);
end;

function draw.obelisk ()
	local x,y = helpers.centerObject(media.images.map);
	love.graphics.draw(media.images.map, x,y-50);
	local tile_w_paper=64;
	local tile_h_paper=32;
	for my=1,23 do
		for mx=1,11 do	
			if (my)/2 == math.ceil((my)/2) then
				love.graphics.draw(media.images.hex, minimap_hexes[global.grail_maparray[my][mx]],((mx-1)*tile_w_paper)+x+8, (my-1)*tile_h_paper*0.75+y+45,0,1);
			else
				love.graphics.draw(media.images.hex, minimap_hexes[global.grail_maparray[my][mx]],((mx-1)*tile_w_paper+tile_w_paper/2)+x+8, (my-1)*tile_h_paper*0.75+y+45,0,1);
			end;
		end;
	end;
end;

function draw.well ()
	local x,y = helpers.centerObject(media.images.map);
	love.graphics.draw(media.images.map, x,y-50);
	if objects_list[global.object].infected and objects_list[global.object].mask and (chars_mobs_npcs[current_mob].lvl_body*chars_mobs_npcs[current_mob].num_body + chars_mobs_npcs[current_mob].lvl_spothidden*chars_mobs_npcs[current_mob].num_spothidden + chars_mobs_npcs[current_mob].lvl_spothidden*chars_mobs_npcs[current_mob].num_spothidden) >= objects_list[global.object].mask then
		media.images[objects_list[global.object].wimg] = img_bad;
	elseif objects_list[global.object].poisoned and objects_list[global.object].mask and (chars_mobs_npcs[current_mob].lvl_alchemy*chars_mobs_npcs[current_mob].num_alchemy + chars_mobs_npcs[current_mob].lvl_spothidden*chars_mobs_npcs[current_mob].num_spothidden) >= objects_list[global.object].mask then
		media.images[objects_list[global.object].wimg] = img_bad;
	elseif objects_list[global.object].cursed and objects_list[global.object].mask and (chars_mobs_npcs[current_mob].lvl_spirit*chars_mobs_npcs[current_mob].num_spirit + chars_mobs_npcs[current_mob].lvl_darkness*chars_mobs_npcs[current_mob].num_darkness + chars_mobs_npcs[current_mob].lvl_light*chars_mobs_npcs[current_mob].num_light + chars_mobs_npcs[current_mob].lvl_spothidden*chars_mobs_npcs[current_mob].num_spothidden) >= objects_list[global.object].mask then
		media.images[objects_list[global.object].wimg] = img_evil;
	end;
	love.graphics.draw(media.images[objects_list[global.object].wimg], x,y-50);
end;

function draw.wellButtons ()
	loveframes.util.RemoveAll();
	local x,y = helpers.centerObject(media.images.map);
	if objects_list[global.object].infected and objects_list[global.object].mask and (chars_mobs_npcs[current_mob].lvl_body*chars_mobs_npcs[current_mob].num_body + chars_mobs_npcs[current_mob].lvl_spothidden*chars_mobs_npcs[current_mob].num_spothidden) >= objects_list[global.object].mask then
		media.images[objects_list[global.object].story] = imgbad;
	elseif objects_list[global.object].poisoned and objects_list[global.object].mask and (chars_mobs_npcs[current_mob].lvl_alchemy*chars_mobs_npcs[current_mob].num_alchemy + chars_mobs_npcs[current_mob].lvl_spothidden*chars_mobs_npcs[current_mob].num_spothidden) >= objects_list[global.object].mask then
		media.images[objects_list[global.object].story] = imgbad;
	elseif objects_list[global.object].cursed and objects_list[global.object].mask and (chars_mobs_npcs[current_mob].lvl_spirit*chars_mobs_npcs[current_mob].num_spirit + chars_mobs_npcs[current_mob].lvl_darkness*chars_mobs_npcs[current_mob].num_darkness + chars_mobs_npcs[current_mob].lvl_light*chars_mobs_npcs[current_mob].num_light + chars_mobs_npcs[current_mob].lvl_spothidden*chars_mobs_npcs[current_mob].num_spothidden) >= objects_list[global.object].mask then
		media.images[objects_list[global.object].story] = imgevil;
	end;
	local text = lognames.descriptions[objects_list[global.object].story];
	wellTextField = loveframes.Create("text");
	wellTextField:SetPos(x+50,y + 450);
	wellTextField:SetMaxWidth(700);
	wellTextField:SetFont(bookFont);
	wellTextField:SetText(text);
	if objects_list[global.object].subtyp == "drink" then
		global.buttons.drink_button = loveframes.Create("imagebutton");
		global.buttons.drink_button:SetImage(media.images.button9);
		global.buttons.drink_button:SetPos(x+300,y+600);
		global.buttons.drink_button:SizeToImage()
		global.buttons.drink_button:SetText(lognames.buttons.drink);
		global.buttons.drink_button.OnClick = function(object)
			helpers.drinkFromWell ();
				end;	
	end;
end;

function draw.stats(index)
	local x,y = helpers.centerObject(media.images.stats);
	love.graphics.draw(media.images.stats, x,y-70);
	--402x254
	love.graphics.setFont(statFont);
	love.graphics.draw(media.images.charfaces, charfaces[chars_mobs_npcs[current_mob].face], x+390, y-50);
	love.graphics.setColor(0, 0, 0);
	love.graphics.print(lognames.stats.name, x+475,y-50);
	love.graphics.print(chars_mobs_npcs[index].name, x+595,y-50);
	love.graphics.print(lognames.stats.class, x+475,y-20);
	love.graphics.print(lognames.classes[chars_mobs_npcs[index].class], x+595,y-20);
	love.graphics.print(lognames.stats.lv, x+475,y+10);
	love.graphics.print(chars_stats[index].lv, x+595,y+10);
	love.graphics.print(lognames.stats.xp, x+475,y+40);
	love.graphics.print(chars_stats[index].xp, x+595,y+40);
	love.graphics.print("/ ", x+615,y+40);
	love.graphics.print(1000*chars_stats[index].lv^2, x+635,y+40);
	
	for i=1,#stats do
		local stat_name = stats[i];
		love.graphics.print(lognames.stats[stat_name], x+40,y-40+(i-1)*30);
		love.graphics.print(chars_mobs_npcs[index][stat_name], x+210,y-40+(i-1)*30);
		love.graphics.print("/", x+240,y-40+(i-1)*30);
		love.graphics.print(chars_stats[index][stat_name], x+250,y-40+(i-1)*30);
	end;
	--
	love.graphics.print(lognames.stats.hp, x+40,y+270);
	love.graphics.print(chars_mobs_npcs[index].hp, x+210,y+270);
	love.graphics.print("/", x+240,y+270)
	love.graphics.print(chars_mobs_npcs[index].hp_max, x+250,y+270);

	love.graphics.print(lognames.stats.sp, x+40,y+300);
	love.graphics.print(chars_mobs_npcs[index].sp, x+210,y+300);
	love.graphics.print("/", x+240,y+300);
	love.graphics.print(chars_mobs_npcs[index].sp_max, x+250,y+300);

	love.graphics.print(lognames.stats.st, x+40,y+330);
	love.graphics.print(chars_mobs_npcs[index].st, x+210,y+330);
	love.graphics.print("/", x+240,y+330);
	love.graphics.print(chars_mobs_npcs[index].st_max, x+250,y+330);

	love.graphics.print(lognames.stats.rt, x+40,y+360);
	love.graphics.print(chars_mobs_npcs[index].rt, x+210,y+360);
	love.graphics.print("/", x+240,y+360);
	love.graphics.print("200", x+250,y+360);
	
	love.graphics.print(lognames.stats.moral, x+40,y+390);
	love.graphics.print(chars_mobs_npcs[index].moral, x+210,y+390);
	love.graphics.print("/", x+240,y+390);
	love.graphics.print(chars_mobs_npcs[index].base_moral, x+250,y+390);
	
	love.graphics.print(lognames.stats.satiation, x+40,y+420);
	love.graphics.print(chars_mobs_npcs[index].satiation, x+210,y+420);
	love.graphics.print("/", x+240,y+420);
	love.graphics.print(chars_mobs_npcs[index].enu*10, x+250,y+420);
	
	--
	love.graphics.print(lognames.stats.atkm, x+400,y+220);
	love.graphics.print(chars_mobs_npcs[index]["melee_stats"]["rh"].atkm, x+600,y+220);
	love.graphics.print(chars_mobs_npcs[index]["melee_stats"]["lh"].atkm, x+640,y+220);

	love.graphics.print(lognames.stats.dmgm, x+400,y+250);
	love.graphics.print(damage.countDamage(index,"rh","min"),x+600,y+250);
	love.graphics.print(" — ", x+620,y+250);
	love.graphics.print(damage.countDamage(index,"rh","max"),x+640,y+250);
	love.graphics.print(",", x+660,y+250);
	
	love.graphics.print(damage.countDamage(index,"lh","min"),x+680,y+250);
	love.graphics.print(" — ", x+700,y+250);
	love.graphics.print(damage.countDamage(index,"lh","max"),x+720,y+250);

	if chars_mobs_npcs[index]["equipment"].ranged ~= 0  and chars_mobs_npcs[index]["equipment"].ammo ~= 0 then
		love.graphics.print(lognames.stats.atkr, x+400,y+280);
		love.graphics.print(chars_mobs_npcs[index].atkr, x+600,y+280);

		love.graphics.print(lognames.stats.dmgr, x+400,y+310);
		love.graphics.print(1*chars_mobs_npcs[index].arng+chars_mobs_npcs[index].crng+math.ceil(chars_mobs_npcs[index].acu/100),x+600,y+310);
		love.graphics.print(" — ", x+620,y+310);
		love.graphics.print(chars_mobs_npcs[index].brng*chars_mobs_npcs[index].arng+chars_mobs_npcs[index].crng+math.ceil(chars_mobs_npcs[index].acu/100),x+640,y+310);
	else
		love.graphics.print(lognames.stats.atkr, x+400,y+280);
		love.graphics.print(0, x+600,y+280);

		love.graphics.print(lognames.stats.dmgr, x+400,y+310);
		love.graphics.print(0,x+600,y+310);
		love.graphics.print(" — ", x+630,y+310);
		love.graphics.print(0,x+640,y+310);
	end;
	--
	local protection = helpers.countProtection (index);
	local ac = protection[1] .. "/" .. 	protection[4];
	local dt = protection[2] .. "/" .. 	protection[5];
	local dr = protection[3] .. "/" .. 	protection[6];
	
	love.graphics.print(lognames.stats.ac, x+400,y+340);
	love.graphics.print(ac, x+600,y+340);
	
	love.graphics.print(lognames.stats.dt, x+400,y+370);
	love.graphics.print(dt, x+600,y+370);
	
	love.graphics.print(lognames.stats.dr, x+400,y+400);
	love.graphics.print(dr, x+600,y+400);
	
	love.graphics.print(lognames.protectionmodes.protectionmode, x+400,y+430);
	love.graphics.print(lognames.protectionmodes[chars_mobs_npcs[current_mob].protectionmode], x+600,y+430);
	
	--
	for i=1,#rezs do
		local rezname = rezs[i];
		love.graphics.print(lognames.stats[rezname], x+794,y-40+(i-1)*30);
		love.graphics.print(chars_mobs_npcs[index][rezname], x+1005,y-40+(i-1)*30);
		love.graphics.print("/", x+1025,y-40+(i-1)*30);
		love.graphics.print(chars_stats[index][rezname], x+1035,y-40+(i-1)*30);
	end;
	
	local addy3 = 0;
	local addy4 = 0;
	love.graphics.setColor(0, 255, 0);
	if chars_mobs_npcs[current_mob].torchlight > 0 then
		local str = tips_conditions.torchlight;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].regen_dur > 0 then
		local str = tips_conditions.regen;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].haste > 0 then
		local str = tips_conditions.haste;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].mobility_dur > 0 then
		local str = tips_conditions.veh;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].invisibility > 0 then
		local str = tips_conditions.invisibility;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].waterwalking > 0 then
		local str = tips_conditions.waterwalking;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].levitation > 0 then
		local str = tips_conditions.levitation;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].dayofgods_dur > 0 then
		local str = tips_conditions.dayofgods;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].hourofpower_dur > 0 then
		local str = tips_conditions.hourofpower;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].protection_dur > 0 then
		local str = tips_conditions.protection;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].angel > 0 then
		local str = tips_conditions.angel;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].heroism_dur > 0 then
		local str = tips_conditions.heroism;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].fateself > 0 then
		local str = tips_conditions.fate;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].bless_dur > 0 then
		local str = tips_conditions.bless;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].prayer > 0 then
		local str = tips_conditions.prayer;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].rage > 0 then
		local str = tips_conditions.rage;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].thirstofblood > 0 then
		local str = tips_conditions.thirstofblood;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].shield > 0 then
		local str = tips_conditions.shield;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].protfromfire_dur > 0 then
		local str = tips_conditions.shieldfromfire;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].protfromcold_dur > 0 then
		local str = tips_conditions.shieldfromcold;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].protfromstatic_dur > 0 then
		local str = tips_conditions.shieldfromstatic;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].protfromacid_dur > 0 then
		local str = tips_conditions.shieldfromacid;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].shieldoflight > 0 then
		local str = tips_conditions.shieldoflight;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].painreflection > 0 then
		local str = tips_conditions.painreflection;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].firebelt_dur > 0 then
		local str = tips_conditions.firebelt_;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].fireprint_dur > 0 then
		local str = tips_conditions.fireprint;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].stoneskin_dur > 0 then
		local str = tips_conditions.stoneskin;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].ironshirt_dur > 0 then
		local str = tips_conditions.ironshirt;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].hammerhands_dur > 0 then
		local str = tips_conditions.hammerhands;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].slow_dur > 0 then
		local str = tips_conditions.slow;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].executor_dur > 0 then
		local str = tips_conditions.executor;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].wingsoflight > 0 then
		local str = tips_conditions.wingsoflight;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].myrth_dur > 0 then
		local str = tips_conditions.myrth;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].might_dur > 0 then
		local str = tips_conditions.might;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].dash_dur > 0 then
		local str = tips_conditions.dash;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].precision_dur > 0 then
		local str = tips_conditions.precision;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].concentration_dur > 0 then
		local str = tips_conditions.concentration;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].luckyday_dur > 0 then
		local str = tips_conditions.luckyday;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	if chars_mobs_npcs[current_mob].glamour_dur > 0 then
		local str = tips_conditions.glamour;
		love.graphics.print(str, x+794,y+260 + addy3*15);
		addy3 = addy3 + 1;
	end;
	love.graphics.setColor(255, 0, 0);
	if chars_mobs_npcs[current_mob].freeze > 0 then
		local str = tips_conditions.freeze;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].stone > 0 then
		local str = tips_conditions.stone;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].paralyze > 0 then
		local str = tips_conditions.paralyze;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].stun > 0 then
		local str = tips_conditions.stun;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].enslave > 0 then
		local str = tips_conditions.enslave;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].berserk > 0 then
		local str = tips_conditions.berserk;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].berserk > 0 then
		local str = tips_conditions.berserk;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].charm > 0 then
		local str = tips_conditions.charm;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].insane > 0 then
		local str = tips_conditions.insane;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].immobilize > 0 then
		local str = tips_conditions.immobilized;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].drunk > 0 then
		local str = tips_conditions.drunk;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].curse > 0 then
		local str = tips_conditions.curse;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].fate > 0 then
		local str = tips_conditions.fate;
		love.graphics.print(str, x+794,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].fear > 0 then
		local str = tips_conditions.fear;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].panic > 0 then
		local str = tips_conditions.panic;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].silence > 0 then
		local str = tips_conditions.silence;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].insane > 0 then
		local str = tips_conditions.insane;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].filth_dur > 0 then
		local str = tips_conditions.filth;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].darkgasp > 0 then
		local str = tips_conditions.darkgasp;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].despondency_dur > 0 then
		local str = tips_conditions.despondency;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].blind_dur > 0 then
		local str = tips_conditions.blind;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].flame_dur > 0 then
		local str = tips_conditions.flame;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].poison_dur > 0 then
		local str = tips_conditions.poison;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].cold_dur > 0 then
		local str = tips_conditions.cold;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].acid_dur > 0 then
		local str = tips_conditions.acid;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].bleeding > 0 then
		local str = tips_conditions.bleeding;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].disease > 0 then
		local str = tips_conditions.disease;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	if chars_mobs_npcs[current_mob].pneumothorax > 0 or chars_mobs_npcs[current_mob]["arms_health"].rh == 0 or chars_mobs_npcs[current_mob]["arms_health"].lh == 0 or chars_mobs_npcs[current_mob].rf == 0 or chars_mobs_npcs[current_mob].lf == 0 or chars_mobs_npcs[current_mob].reye == 0 or chars_mobs_npcs[current_mob].leye == 0 then
		local str = tips_conditions.traumed;
		love.graphics.print(str, x+944,y+260 + addy4*15);
		addy4 = addy4 + 1;
	end;
	
	love.graphics.setFont(mainFont);
end;

function draw.skills(index)
	local x,y = helpers.centerObject(media.images.stats);
	--402x254
	local kk = 0;
	local ll = 0;
	local mm = 0;
	local nn = 0;
	love.graphics.setFont(statFont);
	love.graphics.draw(media.images.skills, x,y-70); -- UI
	love.graphics.setColor(0, 0, 0);
	for i=1,#skills do
		local tmpnum2 = temporal_skills[i];
		local tmplvl1 = "skilllevelnames[chars_mobs_npcs[" .. index .. "].lvl_" .. skills[i] .. "]";
		local tmplvl2 = loadstring("return " .. tmplvl1)();
		local tmpname1 = "lognames.skills." .. skills[i];
		local tmpname2 = loadstring("return " .. tmpname1)();
		if tmpnum2 > 0 then
			if i <= 11 then
				love.graphics.print(tmpname2, x+20,y-30+kk*30);
				love.graphics.print(tmpnum2, x+200,y-30+kk*30);
				love.graphics.print(tmplvl2, x+250,y-30+kk*30);
				love.graphics.setColor(255, 255, 255);
				love.graphics.draw(media.images.ui, btn_minus, x+180,y-30+kk*30);
				love.graphics.draw(media.images.ui, btn_plus, x+220,y-30+kk*30);
				love.graphics.setColor(0, 0, 0);
				kk = kk+1;
			elseif i > 11 and i <= 16 then
			
				love.graphics.print(tmpname2, x+20,y+300+ll*30);
				love.graphics.print(tmpnum2, x+200,y+300+ll*30);
				love.graphics.print(tmplvl2, x+250,y+300+ll*30);
				love.graphics.setColor(255, 255, 255);
				love.graphics.draw(media.images.ui, btn_minus, x+180,y+300+ll*30);
				love.graphics.draw(media.images.ui, btn_plus, x+220,y+300+ll*30);
				love.graphics.setColor(0, 0, 0);
				ll = ll+1;
			elseif i>16 and i <= 25 then
				love.graphics.print(tmpname2, x+410,y-30+mm*30);
				love.graphics.print(tmpnum2, x+590,y-30+mm*30);
				love.graphics.print(tmplvl2, x+640,y-30+mm*30);
				love.graphics.setColor(255, 255, 255);
				love.graphics.draw(media.images.ui, btn_minus, x+570,y-30+mm*30);
				love.graphics.draw(media.images.ui, btn_plus, x+610,y-30+mm*30);
				love.graphics.setColor(0, 0, 0);
				mm = mm+1;
			elseif i > 25 and i <= #skills then
				love.graphics.print(tmpname2, x+810,y-30+nn*30);
				love.graphics.print(tmpnum2, x+990,y-30+nn*30);
				love.graphics.print(tmplvl2, x+1040,y-30+nn*30);
				love.graphics.setColor(255, 255, 255);
				love.graphics.draw(media.images.ui, btn_minus, x+970,y-30+nn*30);
				love.graphics.draw(media.images.ui, btn_plus, x+1010,y-30+nn*30);
				love.graphics.setColor(0, 0, 0);
				nn = nn+1;
			end;
		end;
		love.graphics.print(temp_skillpoints, x+570,y+370);
	end;
end;

function draw.applyButton ()
	local x,y = helpers.centerObject(media.images.skills);
	global.buttons.apply_button = loveframes.Create("imagebutton");
	global.buttons.apply_button:SetImage(media.images.button9);
	global.buttons.apply_button:SetPos(x+530,y+400);
	global.buttons.apply_button:SizeToImage()
	global.buttons.apply_button:SetText(lognames.buttons.apply);
	global.buttons.apply_button.OnClick = function(object)
		helpers.applySkills (current_mob);
			end;	
end;

function draw.miniLog ()
	love.graphics.setColor(0, 0, 0);
	love.graphics.setFont(heroesFont);
	local counter = 0;
	local tmp = (global.screenWidth-300)/2;
	for i=math.max(1,#logactions-10),#logactions do
		local text = logactions[i];
		love.graphics.print(text,math.max(610,tmp+10), global.screenHeight-150+counter*10);
		counter = counter + 1;
	end;
	love.graphics.setColor(255, 255, 255);
end;

function draw.mindgameLog ()
	love.graphics.setColor(0, 0, 0);
	local x,y = helpers.centerObject(media.images.map);
		local chatlog_height = 0;
		local chatlogTextField = {};
		for i=#mindgame_log-1,#mindgame_log do
			local text = mindgame_log[i];
			if chatlogTextField[i-1] then
				chatlog_height = chatlog_height + chatlogTextField[i-1]:GetHeight();
			end;
			if chatlog_height < 300 then
				chatlogTextField[i] = loveframes.Create("text");
				chatlogTextField[i]:SetPos(x+140,y + chatlog_height);
				chatlogTextField[i]:SetMaxWidth(500);
				chatlogTextField[i]:SetFont(bookFont);
				chatlogTextField[i]:SetText(text);
			end;
		end;
	love.graphics.setColor(255, 255, 255);
end;

function draw.bigLog ()
	loveframes.util.RemoveAll();
	love.graphics.setFont(heroesFont);
	local x,y = helpers.centerObject(media.images.map);
	love.graphics.draw(media.images.map, x,y-50);
	love.graphics.setColor(0, 0, 0);
	local counter = 0;
	for i = #logactions,math.max(1,#logactions-100),-1 do
		local text = logactions[i];
		love.graphics.print(text,x+55,y+350-(y+counter*10));
		counter = counter + 1;
	end;
	love.graphics.setColor(255, 255, 255);
end;

function draw.calendar ()
	loveframes.util.RemoveAll();
	local x,y = helpers.centerObject(media.images.map);
	love.graphics.draw(media.images.map, x,y-50);
	love.graphics.setFont(heroesLargeFont);
	love.graphics.setColor(0, 0, 0);
	love.graphics.print(lognames.calendar.year_AR, x+100,y+100);
	love.graphics.print(lognames.calendar.year_AS, x+100,y+150);
	love.graphics.print(lognames.calendar.month, x+100,y+200);
	love.graphics.print(lognames.calendar.week, x+100,y+250);
	love.graphics.print(lognames.calendar.day, x+100,y+300);
	love.graphics.print(lognames.calendar.current_time, x+100,y+350);
	--
	love.graphics.print(calendar.year_AR, x+450,y+100);
	love.graphics.print(calendar.year_AS, x+450,y+150);
	love.graphics.print(calendar.month, x+450,y+200);
	love.graphics.print(calendar.week, x+450,y+250);
	love.graphics.print(calendar.day, x+450,y+300);
	--
	local hour_str = "";
	local min_str = "";
	local sec_str = "";
	if calendar.hour < 10 then
		hour_str = "0" .. tostring(calendar.hour);
	else
		hour_str = tostring(calendar.hour);
	end;
	if calendar.min < 10 then
		min_str = "0" .. tostring(calendar.min);
	else
		min_str = tostring(calendar.min);
	end;
	if calendar.sec < 10 then
		sec_str = "0" .. tostring(calendar.sec);
	else
		sec_str = tostring(calendar.sec);
	end;
	local time_str = hour_str .. " : " .. min_str .. " : " .. sec_str;
	love.graphics.print(time_str, x+450,y+350);
	love.graphics.setColor(255, 255, 255);
end;

function draw.chat()
	loveframes.util.RemoveAll();
	local x,y = helpers.centerObject(media.images.map);
	love.graphics.draw(media.images.map, x,y-50);
	love.graphics.draw(media.images.npcfaces, npcfaces[chars_mobs_npcs[victim].face], x+55, y);
	love.graphics.setFont(mainFont);
	love.graphics.setColor(0, 0, 0);
	love.graphics.print(helpers.mobName(victim), x+55,y+100);
	love.graphics.setColor(255, 255, 255);
	local index = chars_mobs_npcs[victim]["personality"]["current"].chat;
	local questions = {};
	local counter = 1;
	for i=1,10 do
		local textfield = loveframes.Create("text");
		table.insert(questions,textfield);
	end;
	for i=1,#chats.rules[index] do
		if chats.rules[index][i].default then
			local text = chats.questions[index][chats.rules[index][i].question];
			questions[counter]:SetPos(x+55,y+300+counter*50);
			questions[counter]:SetMaxWidth(800);
			questions[counter]:SetFont(bookFont);
			questions[counter]:SetText(text);
			counter = counter + 1;
		end;
	end;
	local chatlog_height = 0;
	local chatlogTextField = {};
	for i=1,math.min(#chat_log,10) do
		local text = chat_log[i];
		if chatlogTextField[i-1] then
			chatlog_height = chatlog_height + chatlogTextField[i-1]:GetHeight();
		end;
		if chatlog_height < 500 then
			chatlogTextField[i] = loveframes.Create("text");
			chatlogTextField[i]:SetPos(x+140,y + chatlog_height);
			chatlogTextField[i]:SetMaxWidth(500);
			chatlogTextField[i]:SetFont(bookFont);
			chatlogTextField[i]:SetText(text);
		end;
	end;
end;

function draw.mindgame()
	local x,y = helpers.centerObject(media.images.map);
	love.graphics.draw(media.images.map, x,y-50);
	love.graphics.draw(media.images.mindgame,x+15,y+75);
	love.graphics.draw(media.images.npcfaces, npcfaces[chars_mobs_npcs[victim].face], x+55, y);
	love.graphics.setFont(mainFont);
	love.graphics.setColor(0, 0, 0);
	love.graphics.print(helpers.mobName(victim), x+55,y+100);
	local attempts = global.mindgame_attempts - global.mindgame_counter;
	love.graphics.print(attempts,x+535,y+75);
	love.graphics.setFont(mainFont);
	draw.mindway ();
	
	local chatlog_height = 0;
	local chatlogTextField = {};
	--[[
	for key,value in pairs (loveframes.base.children) do
		if value == "instance of class loveframes_object_text" then
		 --table.remove(loveframes.base.children,key);
		 loveframes.base.children[key] = nil;
		end;
	end;
	
	for i=1,math.min(#mindgame_log,5) do
		local text = mindgame_log[i];
		if chatlogTextField[i-1] then
			chatlog_height = chatlog_height + chatlogTextField[i-1]:GetHeight();
		end;
		if chatlog_height < 300 then
			chatlogTextField[i] = loveframes.Create("text");
			chatlogTextField[i]:SetPos(x+140,y + chatlog_height);
			chatlogTextField[i]:SetMaxWidth(500);
			chatlogTextField[i]:SetFont(bookFont);
			chatlogTextField[i]:SetText(text);
		end;
	end;
	]]
	love.graphics.setColor(255, 255, 255);
	local draw_cursor = true;
	if mindgame.map[global.mindcursor_x][global.mindcursor_y] ~= 0 then
		draw_cursor = false;
	end;
	for i=1,#mindgame.dest_coords do
		if mindgame.dest_coords[i][1] == global.mindcursor_x and mindgame.dest_coords[i][2] == global.mindcursor_y then
			draw_cursor = false;
		end;
	end;
	--FIXME ifnear (but not for neuro)
	local array =  boomareas.smallRingArea(global.mindhero_x,global.mindhero_y);
	local _near = false
	for i=1,6 do
		if global.mindcursor_x == array[i].x and global.mindcursor_y == array[i].y then
			_near = true;
		end;
	end;
	if draw_cursor and _near then
		draw.drawMindHex (global.mindcursor_x,global.mindcursor_y,cursor_danger);
	end;
	draw.mindgameCycle(true);
	draw.drawMindObject(media.images.ui,green_fishka,global.mindhero_x,global.mindhero_y,-348,-210);
	draw.mindgameCycle(false);
	local total_diplomacy = chars_mobs_npcs[current_mob].lvl_diplomacy*chars_mobs_npcs[current_mob].num_diplomacy;
	if total_diplomacy >= 1 then
		local counter = 0;
		for i=1,#chars_mobs_npcs[current_mob].inventory_list do
			if chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid == raws.buz then
				counter = counter+1;
			end;
		end;
		for i=1,#chars_mobs_npcs[current_mob].inventory_list do
			if inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid].class == "food" then
				love.graphics.draw(media.images.items2, tiles_items[raws.buz],345+counter*200,550);--FIXME
				counter = counter+1;
			end;
		end;
	end;
	if total_diplomacy >= 1 and #global.minddrink_array >= 1 then
		local id = global.minddrink_array[global.drinkmissle].spriteid
		--love.graphics.draw(media.images.items2,tiles_items[id],x+496,y+360);
		love.graphics.draw(media.images.items2,tiles_items[id],x+496,y+370);
	end;
	--local coords = global.mindcursor_x .. "X" .. global.mindcursor_y;
	--love.graphics.print(coords, 750,200);
	--if mindmissle then
		--love.graphics.print(mindmissle, 750,200);
	--end;
	--[[for i=1,9 do
		for h=1,9 do
			local string = i .. "*" .. h .. " " .. mindgame.map[i][h];
			draw.drawMindHexDebug (i,h,string);
		end;
	end;]]
end;

function draw.mindgameCycle(before)
	for h=1,9 do
		for i=1,9 do
			local condition = false;
			if before then
				if h < global.mindhero_y then
					condition = true;
				end;
			elseif not before then
				if h >= global.mindhero_y then
					condition = true;
				end;
			end;
			if condition then
				if mindgame.map[i][h] >= 1 and mindgame.map[i][h] <= 7 then
					if mindgame.map[i][h] == 1 then
						--draw.drawMindObject(media.images.ui,gold_icons[5],i,h,-325,-115);
						draw.drawMindObject(media.images.ui,gold_icons[4],i,h,-332,-130);
					elseif  mindgame.map[i][h] == 2 then
						draw.drawMindObject(media.images.ui,gold_icons[4],i,h,-332,-130);
					elseif  mindgame.map[i][h] == 3 then
						draw.drawMindObject(media.images.ui,gold_icons[3],i,h,-355,-128);
					elseif  mindgame.map[i][h] == 4 then
						draw.drawMindObject(media.images.ui,gold_icons[2],i,h,-353,-135);
					elseif  mindgame.map[i][h] > 4 then
						draw.drawMindObject(media.images.ui,gold_icons[1],i,h,-385,-155);
					end;
				elseif mindgame.map[i][h] == 10 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_pain_icon,i,h,-350,-145);
				elseif mindgame.map[i][h] == 11 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_injur_icon,i,h,-340,-220);
				elseif mindgame.map[i][h] == 12 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_death_icon,i,h,-350,-160);
				elseif mindgame.map[i][h] == 13 then
					draw.drawMindObject(media.images.items2,tiles_items[raws.buz],i,h,-355,-125);
				elseif mindgame.map[i][h] == 9 then
				elseif mindgame.map[i][h] == 8 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindbarrier,i,h,-350,-140);
				elseif mindgame.map[i][h] == 31 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_secret_icon,i,h,-384,-200);
				elseif mindgame.map[i][h] == 32 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_joke_icon,i,h,-415,-205);
				elseif mindgame.map[i][h] == 33 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_hypno_icon,i,h,-384,-200);
				elseif mindgame.map[i][h] == 34 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_connection_icon,i,h,-384,-200);
				elseif mindgame.map[i][h] == 35 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_affront_icon,i,h,-384,-200);
				elseif mindgame.map[i][h] == 36 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_troll_icon,i,h,-384,-200);
				elseif mindgame.map[i][h] == 37 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_sad_icon,i,h,-384,-200);
				elseif mindgame.map[i][h] > 100 and mindgame.map[i][h] <= 165 then
					draw.drawMindObject(media.images.mindgame_icons_img,mindgame_icons[mindgame.map[i][h]-100],i,h,-350,-200);
				elseif mindgame.map[i][h] > 1000 then
					local tileid = mindgame.map[i][h] - 1000;
					draw.drawMindObject(media.images.items2,tiles_items[tileid],i,h,-336,-170);
				end;
			end;
		end;
	end;
end;

function draw.comic()
	local x,y = helpers.centerObject(comics_ttx[current_comic][page].pic);
	love.graphics.draw(comics_ttx[current_comic][page].pic, x,y-50);
	local font = comicFont;
	local text = comics_ttx[current_comic][page].text;
	if text ~= "" then
		love.graphics.draw(media.images.comic_bubble, x+190,y+800);
	end;
	local textfield = loveframes.Create("text");
	textfield:SetPos(x+220, y+830);
	textfield:SetMaxWidth(950);
	textfield:SetFont(font);
	textfield:SetText(text);
end;

function draw.book()
	local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
	if littype == "book" then
		local x,y = helpers.centerObject(media.images.book);
		--140x180
		love.graphics.draw(media.images.book, x,y-80);
		local picl = "picl" .. pagebook;
		local picr = "picr" .. pagebook;
		if books_ttx[list[tmp_book].q][picl] ~= "" then
			local path_to_pic = books_ttx[list[tmp_book].q][picl]
			local pic=media.images[path_to_pic ];
			
			love.graphics.draw(pic, x+100,y-60);
		end;
		if books_ttx[list[tmp_book].q][picr] ~= "" then
			local path_to_pic = books_ttx[list[tmp_book].q][picr]
			local pic=media.images[path_to_pic ];
			love.graphics.draw(pic, x+520,y-60);
		end;
		loveframes.util.RemoveAll();
		pagel = "pgtxtl" .. pagebook;
		pager = "pgtxtr" .. pagebook;
		local font = books_ttx[list[tmp_book].q]["font"];
		local textl = books_ttx[list[tmp_book].q][pagel];
		local text = loveframes.Create("text");
		text:SetPos(x+140, y-40);
		text:SetMaxWidth(340);
		text:SetFont(font);
		text:SetText(textl);
		local textr = books_ttx[list[tmp_book].q][pager];
		local text = loveframes.Create("text");
		text:SetPos(x+540, y-40);
		text:SetMaxWidth(340);
		text:SetFont(font);
		text:SetText(textr);
	elseif littype == "message" or littype == "letter" then
		local x,y = helpers.centerObject(media.images.msg);
		--400x160
		love.graphics.draw(media.images.msg, x+40,y-60);
		if messages_ttx[list[tmp_book].q].pic ~= "" then
			love.graphics.draw(messages_ttx[list[tmp_book].q].pic, x+40,y-60);
		end;
		loveframes.util.RemoveAll();
		love.graphics.setColor(0, 0, 0);
		love.graphics.setFont(messFont);
		love.graphics.print(messages_ttx[list[tmp_book].q].title, x+200,y+20);
		love.graphics.setColor(255, 255, 255);
		local font = messages_ttx[list[tmp_book].q]["font"];
		local texto = messages_ttx[list[tmp_book].q].body;
		local text = loveframes.Create("text");
		text:SetPos(x+100, y+40);
		text:SetMaxWidth(360);
		text:SetFont(font);
		text:SetText(texto);
		local tmpy = math.ceil(#messages_ttx[list[tmp_book].q].body/40);
		love.graphics.setColor(0, 0, 0);
		love.graphics.print(messages_ttx[list[tmp_book].q].signature, x+300,tmpy*20+y+40);
		love.graphics.setColor(255, 255, 255);
		if messages_ttx[list[tmp_book].q].stamp~="" then
			love.graphics.draw(messages_ttx[list[tmp_book].q].stamp, x+300,tmpy*20+y+40);
		end;
	elseif littype == "map" then
		local x,y = helpers.centerObject(media.images.map);
		--265x105
		loveframes.util.RemoveAll();
		love.graphics.draw(media.images.map, x,y-50)
		local path_to_pic = maps_ttx[list[tmp_book].q]["pic"];
		local pic = media.images[path_to_pic];
		love.graphics.draw(pic, x,y-50);
	elseif littype == "gobelen" then
		local x,y = helpers.centerObject(media.images.gobelen);
		--265x105
		loveframes.util.RemoveAll();
		love.graphics.draw(media.images.gobelen, x,y-50)
		local path_to_pic = gobelens_ttx[list[tmp_book].q]["pic"]
		local pic = media.images[path_to_pic];
		love.graphics.draw(pic, x,y-50);
	end;
end;

function draw.spellbook ()
	local x,y = helpers.centerObject(media.images.sbook);
	local spelliconcoods={{x+40,y+8-70},{x+200,y+8-70},{x+200,y+138-70},{x+40,y+138-70},{x+40,y+268-70},{x+200,y+268-70},{x+410,y+8-70},{x+570,y+8-70},{x+410,y+138-70},{x+570,y+138-70},{x+410,y+268-70},{x+570,y+268-70}};
	love.graphics.draw(media.images.sbook, x,y-70);
	for i=1,12 do
		if chars_mobs_npcs[current_mob]["spells"][page][i]==1 then
			local tmpb = "media.images.page_" .. page;
			local spell_page = loadstring("return " .. tmpb)();
			love.graphics.draw(spell_page, spellicons[page][i], spelliconcoods[i][1]+128,spelliconcoods[i][2]+50);
		end;
	end;
end;

function draw.warbook ()
	local x,y = helpers.centerObject(media.images.wbook);
	love.graphics.draw(media.images.wbook, x,y-70);
	for i=1,12 do
		if chars_mobs_npcs[current_mob]["warbook"][page][i] == 1 then
			local tmpb = "media.images.wbpage_" .. page;
			local warbook_page = loadstring("return " .. tmpb)();
			local x,y = helpers.centerObject(media.images.wbook);
			local spelliconcoods={{x+40,y+8-70},{x+200,y+8-70},{x+200,y+138-70},{x+40,y+138-70},{x+40,y+268-70},{x+200,y+268-70},{x+410,y+8-70},{x+570,y+8-70},{x+410,y+138-70},{x+570,y+138-70},{x+410,y+268-70},{x+570,y+268-70}};
			love.graphics.draw(warbook_page, spellicons[page][i], spelliconcoods[i][1]+128,spelliconcoods[i][2]+50);
		end;
	end;
end;

function draw.questbook ()
	local x,y = helpers.centerObject(media.images.book);
	love.graphics.draw(media.images.book, x,y-70);
	loveframes.util.RemoveAll();
	local text_field_story = {};
	if #party.quests > 0 then
		local quest_id = party.quests[global.questbook_page].id;
		--local font = quests[quest_id]["font"];
		local font = messFont;
		local text_title = quests[quest_id].title;
		local text_field_title = loveframes.Create("text");
		text_field_title:SetPos(x+200, y-40);
		text_field_title:SetMaxWidth(340);
		text_field_title:SetFont(font);
		text_field_title:SetText(text_title);
		local quest_height = 0; 
		for i=1,#party.quests[global.questbook_page]["stages"] do
			if party.quests[global.questbook_page]["stages"][i] then
				local text_story = quests[quest_id]["stages"][i].story;
				
				local addx = 0;
				if quests[quest_id]["stages"][i].pager then
					addx = 400;
				end;
				text_field_story[i] = loveframes.Create("text");
				text_field_story[i]:SetPos(x+140+addx, y + quest_height + 20*i);
				text_field_story[i]:SetMaxWidth(340);
				text_field_story[i]:SetFont(font);
				text_field_story[i]:SetText(text_story);
			end;
			if text_field_story[i] then
				quest_height = quest_height + text_field_story[i]:GetHeight();
			end;
		end;
	end;
end;

function draw.equipment ()
	local x,y = helpers.centerObject(media.images.inv1);
	love.graphics.draw(media.images.charfaces, charfaces[chars_mobs_npcs[current_mob].face], x+390, y-20);
	love.graphics.print(chars_stats[current_mob].name, x+365+math.ceil(#chars_stats[current_mob].name/2)*10, y+75);
	local tempeq1 = nil;
	local tempeq2 = nil;
	if inv_page == 1 then
		if chars_mobs_npcs[current_mob]["equipment"].rh ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].rh;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid
			if inventory_ttx[tempeq2].class == "sword"
			or inventory_ttx[tempeq2].class == "axe"
			or inventory_ttx[tempeq2].class == "flagpole"
			or inventory_ttx[tempeq2].class == "crushing"
			or inventory_ttx[tempeq2].class == "dagger"
			or inventory_ttx[tempeq2].class == "staff" then
				local x = x+430-inventory_ttx[tempeq2].w/2*32;
				draw.drawItem(tempeq1,tempeq2,x,y+130,false,0);
			end;
		end;
		if chars_mobs_npcs[current_mob]["equipment"].armor ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].armor;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			if inventory_ttx[tempeq2].class == "armor" then
				draw.drawItem(tempeq1,tempeq2,x+480,y+130,false,0);
			end;
		end;
		if chars_mobs_npcs[current_mob]["equipment"].lh ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].lh;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			if inventory_ttx[tempeq2].class == "shield"  then
				draw.drawItem(tempeq1,tempeq2,x+620,y+130,false,0);
			elseif (inventory_ttx[tempeq2].class == "dagger" or inventory_ttx[tempeq2].class == "sword") then
				draw.drawItem(tempeq1,tempeq2,x+670,y+130,false,0);
			end;
		end;
		if chars_mobs_npcs[current_mob]["equipment"].head ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].head;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+520,y+10,false,0);
		end;
		if chars_mobs_npcs[current_mob]["equipment"].boots ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].boots;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+500,y+350,false,0);
		end;
		if chars_mobs_npcs[current_mob]["equipment"].gloves ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].gloves;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+640,y+500,false,0);
		end;
	elseif inv_page == 2 then
		if chars_mobs_npcs[current_mob]["equipment"].ranged ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].ranged;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			if inventory_ttx[tempeq2].class == "bow" 
			or inventory_ttx[tempeq2].class == "crossbow"
			or inventory_ttx[tempeq2].class == "firearms"
			or inventory_ttx[tempeq2].class == "blaster" 
			or inventory_ttx[tempeq2].class == "wand"
			then
				local x = x+420-inventory_ttx[tempeq2].w/2*32;
				draw.drawItem(tempeq1,tempeq2,x,y+170,false,0);
			end;
		end;
		if chars_mobs_npcs[current_mob]["equipment"].ammo ~= 0  then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].ammo
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid
			if inventory_ttx[tempeq2].class == "ammo" or inventory_ttx[tempeq2].class == "throwing" then
				love.graphics.draw(media.images.items1, tiles_items[tempeq2],x+634+inventory_ttx[tempeq2].w/2*32,y+170); --q means quantity, so not from draw.drawItem
			end;
		end;
		if chars_mobs_npcs[current_mob]["equipment"].amulet ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].amulet
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+520,y+50,false,0);
		end;
		if chars_mobs_npcs[current_mob]["equipment"].art ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].art;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+490,y+400,false,0);
		end;
		if chars_mobs_npcs[current_mob]["equipment"].ring1 ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].ring1;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+500,y+390,false,0);
		end
		if chars_mobs_npcs[current_mob]["equipment"].ring2 ~= 0 then
			tempeq1=chars_mobs_npcs[current_mob]["equipment"].ring2;
			tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+500,y+430,false,0);
		end
		if chars_mobs_npcs[current_mob]["equipment"].ring3 ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].ring3;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+500,y+470,false,0);
		end;
		if chars_mobs_npcs[current_mob]["equipment"].ring4 ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].ring4;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+590,y+390,false,0);
		end;
		if chars_mobs_npcs[current_mob]["equipment"].ring5 ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].ring5;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+590,y+430,false,0);
		end
		if chars_mobs_npcs[current_mob]["equipment"].ring6 ~= 0 then
			tempeq1 = chars_mobs_npcs[current_mob]["equipment"].ring6;
			tempeq2 = chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+590,y+470,false,0);
		end;
		if chars_mobs_npcs[current_mob]["equipment"].cloak ~= 0 then
			tempeq1=chars_mobs_npcs[current_mob]["equipment"].cloak
			tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+510,y+100,false,0);
		end
		if chars_mobs_npcs[current_mob]["equipment"].belt ~= 0 then
			tempeq1=chars_mobs_npcs[current_mob]["equipment"].belt
			tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
			draw.drawItem(tempeq1,tempeq2,x+490,y+295,false,0);
		end
	end;
end;

function draw.alchemy ()
	local x,y = helpers.centerObject(media.images.inv1);
	love.graphics.draw(media.images.charfaces, charfaces[chars_mobs_npcs[current_mob].face], x+390, y-20);
	love.graphics.print(chars_stats[current_mob].name, x+365+math.ceil(#chars_stats[current_mob].name/2)*10, y+75);
	love.graphics.print(chars_mobs_npcs[current_mob].lvl_alchemy, x+520, y-30);
	love.graphics.print(chars_mobs_npcs[current_mob].num_alchemy, x+520, y-10);
	love.graphics.print(lognames.actions.potionpower .. " ".. chars_stats[current_mob].lvl_alchemy*chars_stats[current_mob].num_alchemy, x+520, y+10);
	if alchlab[current_mob].tool1~=0 then
		local tempeq1=alchlab[current_mob].tool1;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+395,y+185);
	end
	if alchlab[current_mob].tool2~=0 then
		local tempeq1=alchlab[current_mob].tool2;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+415,y+105);
	end
	if alchlab[current_mob].tool3~=0 then
		local tempeq1=alchlab[current_mob].tool3;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+415,y+345);
	end
	if alchlab[current_mob].tool4~=0 then
		local tempeq1=alchlab[current_mob].tool4;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+405,y+470);
	end
	if alchlab[current_mob].tool5~=0 then
		local tempeq1=alchlab[current_mob].tool5;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+520,y+450);
	end
	if alchlab[current_mob].tool6~=0 then
		local tempeq1=alchlab[current_mob].tool6;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+630,y+450);
	end
	if alchlab[current_mob].bottle1~=0 then
		local tempeq1=alchlab[current_mob].bottle1;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+660,y+205);
	end
	if alchlab[current_mob].bottle2~=0 then
		local tempeq1=alchlab[current_mob].bottle2;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+630,y+325);
	end
	if alchlab[current_mob].bottle3~=0 then
		local tempeq1=alchlab[current_mob].bottle3;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+690,y+325);
	end
	if alchlab[current_mob].comp1~=0 then
		local tempeq1=alchlab[current_mob].comp1;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+625,y+190);
	end
	if alchlab[current_mob].comp2~=0 then
		local tempeq1=alchlab[current_mob].comp2;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+625,y+230);
	end
	if alchlab[current_mob].comp3~=0 then
		local tempeq1=alchlab[current_mob].comp3;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+625,y+270);
	end
	if alchlab[current_mob].comp4~=0 then
		local tempeq1=alchlab[current_mob].comp4
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+700,y+190)
	end
	if alchlab[current_mob].comp5~=0 then
		local tempeq1=alchlab[current_mob].comp5;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+700,y+230);
	end
	if alchlab[current_mob].comp6~=0 then
		local tempeq1=alchlab[current_mob].comp6;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+700,y+270);
	end
	if alchlab[current_mob].comp7~=0 then
		tempeq1=alchlab[current_mob].comp7;
		tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+625,y+105);
	end
	if alchlab[current_mob].comp8~=0 then
		local tempeq1=alchlab[current_mob].comp8;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+660,y+105);
	end
	if alchlab[current_mob].comp9~=0 then
		local tempeq1=alchlab[current_mob].comp9;
		local tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+695,y+105);
	end;
end;

function draw.objects ()
	love.graphics.setColor(255, 255, 255);
	if map_x < 12 then
		mxx = 1
	else
		mxx = -10
	end;
	if map_y < 4 then
		myy = 1
	else
		myy = -2
	end;
	for my=myy, math.min(map_display_h, map_h-map_y) do
      for mx=mxx, math.min(map_display_w, map_w-map_x) do
	--for my=1, math.min(map_display_h, map_h-map_y) do
		--for mx=1, math.min(map_display_w, map_w-map_x) do		
			--draw.irradiation (mx,my);
			if wlandscape[my+map_y][mx+map_x] > 0 then 
				if (my+map_y)/2 == math.ceil((my+map_y)/2) then
					love.graphics.draw(media.images.tmpobjs, eye,((mx-1)*tile_w+left_space+tile_hw)-tile_w-32, (my-1)*tile_h*0.75+top_space - 128);
				else
					love.graphics.draw(media.images.tmpobjs,eye,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-32, (my-1)*tile_h*0.75+top_space - 128);
				end;
			end;
			if  (hlandscape[my+map_y][mx+map_x] > 0 and hlandscape[my+map_y][mx+map_x] <= 25 and darkness[1][my+map_y][mx+map_x] == 0)
			or	hlandscape[my+map_y][mx+map_x] > 25 then --harvest
				if  darkness[1][my+map_y][mx+map_x] == 0 then
				elseif darkness[1][my+map_y][mx+map_x] == 1 then
					love.graphics.setColor(125, 125,125);
				elseif darkness[1][my+map_y][mx+map_x] == 2 then
					love.graphics.setColor(0, 0,0);
				end;
				draw.drawHarvest (mx+map_x,my+map_y,hlandscape[my+map_y][mx+map_x]);
			end;
			if (my+map_y)/2 == math.ceil((my+map_y)/2) then
				if map[my+map_y][mx+map_x]>120 and  map[my+map_y][mx+map_x] <= 220 then
					if  darkness[1][my+map_y][mx+map_x] == 0 then
					elseif darkness[1][my+map_y][mx+map_x] == 1 then
						love.graphics.setColor(125,125,125);
					elseif darkness[1][my+map_y][mx+map_x] == 2 then
						love.graphics.setColor(0,0,0);				
					end;
					love.graphics.draw(media.images.obj, objects[map[my+map_y][mx+map_x]-120], ((mx-1)*tile_w+left_space)-tile_w+top_space+objects_table[map[my+map_y][mx+map_x]-120][5], (my-1)*tile_h*0.75+top_space-objects_table[map[my+map_y][mx+map_x]-120][6]);
					love.graphics.setColor(255, 255, 255);
				elseif map[my+map_y][mx+map_x] > 300 then
					local index = map[my+map_y][mx+map_x] - 300;
					local corner_hexes_array = helpers.cornersOfBuilding(index,mx+map_x,my+map_y);
					--local img = media.images[buildings_stats[index].img];
					local img = buildings_stats[index].img;
					local sprite = buildings_stats[index].sprite;
					local addx = buildings_stats[index].addx;
					local addy = buildings_stats[index].addy;
					if darkness[1][corner_hexes_array[1][2]][corner_hexes_array[1][1]] == 0
					or darkness[1][corner_hexes_array[2][2]][corner_hexes_array[2][1]] == 0
					or darkness[1][corner_hexes_array[3][2]][corner_hexes_array[3][1]] == 0
					or darkness[1][corner_hexes_array[4][2]][corner_hexes_array[4][1]] == 0
					--or darkness[1][my+map_y+buildings_stats[index]["door_ev"][1]][mx+map_x+buildings_stats[index]["door_ev"][2]] == 0
					then
						for i=1,#buildings_stats[index].hexes_ev do
							--if helpers.insideMap(mx-map_x+buildings_stats[index].hexes_ev[i][1],my+map_y-buildings_stats[index].hexes_ev[i][2]) then
								darkness[1][my+map_y-buildings_stats[index].hexes_ev[i][1]][mx+map_x-buildings_stats[index].hexes_ev[i][2]] = 0;
							--end;
						end;
					elseif darkness[1][corner_hexes_array[1][2]][corner_hexes_array[1][1]] == 1
					and darkness[1][corner_hexes_array[2][2]][corner_hexes_array[2][1]] == 1
					and darkness[1][corner_hexes_array[3][2]][corner_hexes_array[3][1]] == 1
					and darkness[1][corner_hexes_array[4][2]][corner_hexes_array[4][1]] == 1 then
						love.graphics.setColor(125, 125,125);
					elseif darkness[1][corner_hexes_array[1][2]][corner_hexes_array[1][1]] == 2
					and darkness[1][corner_hexes_array[2][2]][corner_hexes_array[2][1]] == 2
					and darkness[1][corner_hexes_array[3][2]][corner_hexes_array[3][1]] == 2
					and darkness[1][corner_hexes_array[4][2]][corner_hexes_array[4][1]] == 2 then
						love.graphics.setColor(0, 0, 0);
					end;
					if not buildings_stats[index].animation then
						love.graphics.draw(img, sprite, ((mx-1)*tile_w+left_space)-tile_w+top_space+addx, (my-1)*tile_h*0.75+addy+top_space);
					else
						local animation = loadstring("return " .. buildings_stats[index].animation)();
						local image = media.images[buildings_stats[index].animation_source];
						animation:draw(image, ((mx-1)*tile_w+left_space)-tile_w+top_space+addx, (my-1)*tile_h*0.75+addy+top_space);
					end;
					love.graphics.setColor(255, 255, 255);
				end;      
			else
				if map[my+map_y][mx+map_x]>120 and  map[my+map_y][mx+map_x] <= 220 then
					if  darkness[1][my+map_y][mx+map_x] == 0 then
					elseif darkness[1][my+map_y][mx+map_x] == 1 then
						love.graphics.setColor(125,125,125);
					elseif darkness[1][my+map_y][mx+map_x] == 2 then
						love.graphics.setColor(0,0,0);						
					end;
					love.graphics.draw(media.images.obj, objects[map[my+map_y][mx+map_x]-120], ((mx-1)*tile_w+left_space+tile_hw)-tile_w+top_space+objects_table[map[my+map_y][mx+map_x]-120][5], (my-1)*tile_h*0.75+top_space-objects_table[map[my+map_y][mx+map_x]-120][6]);
					love.graphics.setColor(255, 255, 255);
				elseif map[my+map_y][mx+map_x] > 300 then
					local index = map[my+map_y][mx+map_x] - 300;
					local corner_hexes_array = helpers.cornersOfBuilding(index,mx+map_x,my+map_y);
					--local img = media.images[buildings_stats[index].img];
					local img = buildings_stats[index].img;
					local sprite = buildings_stats[index].sprite;
					local addx = buildings_stats[index].addx;
					local addy = buildings_stats[index].addy;
					if darkness[1][corner_hexes_array[1][2]][corner_hexes_array[1][1]] == 0
					or darkness[1][corner_hexes_array[2][2]][corner_hexes_array[2][1]] == 0
					or darkness[1][corner_hexes_array[3][2]][corner_hexes_array[3][1]] == 0
					or darkness[1][corner_hexes_array[4][2]][corner_hexes_array[4][1]] == 0
					--or darkness[1][my+map_y+buildings_stats[index]["door_ne"][1]][mx+map_x+buildings_stats[index]["door_ne"][2]] == 0
					then
						for i=1,#buildings_stats[index].hexes_ne do
							--if helpers.insideMap(mx+map_x-buildings_stats[index].hexes_ne[i][1],my+map_y-buildings_stats[index].hexes_ne[i][2]) then
								darkness[1][my+map_y-buildings_stats[index].hexes_ne[i][1]][mx+map_x-buildings_stats[index].hexes_ne[i][2]] = 0;
							--end;
						end;
					elseif darkness[1][corner_hexes_array[1][2]][corner_hexes_array[1][1]] == 1
					and darkness[1][corner_hexes_array[2][2]][corner_hexes_array[2][1]] == 1
					and darkness[1][corner_hexes_array[3][2]][corner_hexes_array[3][1]] == 1
					and darkness[1][corner_hexes_array[4][2]][corner_hexes_array[4][1]] == 1 then
						love.graphics.setColor(125, 125,125);
					elseif darkness[1][corner_hexes_array[1][2]][corner_hexes_array[1][1]] == 2
					and darkness[1][corner_hexes_array[2][2]][corner_hexes_array[2][1]] == 2
					and darkness[1][corner_hexes_array[3][2]][corner_hexes_array[3][1]] == 2
					and darkness[1][corner_hexes_array[4][2]][corner_hexes_array[4][1]] == 2 then
						love.graphics.setColor(0, 0, 0);
					end;
					if not buildings_stats[index].animation then
						love.graphics.draw(img, sprite, ((mx-1)*tile_w+left_space+tile_hw)-tile_w+top_space+addx, (my-1)*tile_h*0.75+addy+top_space);
					else
						local animation = loadstring("return " .. buildings_stats[index].animation)();
						local image = media.images[buildings_stats[index].animation_source];
						animation:draw(image, ((mx-1)*tile_w+left_space+tile_hw)-tile_w+top_space+addx, (my-1)*tile_h*0.75+addy+top_space);
					end;
					love.graphics.setColor(255, 255, 255);	
				end;  
			end;
			for j=1,#bags_list do
				if bags_list[j].typ == "bag" then
					addx = 16;
					addy = 12;
				elseif bags_list[j].typ == "chest" then
					addx = 16;
					addy = 12;
				elseif bags_list[j].typ == "barrel" or  bags_list[j].typ == "cauldron" then
					addx = 32;
					addy = 32;
				elseif bags_list[j].typ == "brokenbarrel" then
					addx = 32;
					addy = 32;
				elseif bags_list[j].typ == "door" then
					addx = 32;
					addy = 64;
				elseif bags_list[j].typ == "box" then
					addx = 16;
					addy = 8;
				elseif bags_list[j].typ == "crystals" then
					addx = 32;
					addy = 64;
				elseif bags_list[j].typ == "trashheap" then
					addx = 32;
					addy = 32;
				elseif bags_list[j].typ == "scullpile" then
					addx = 32;
					addy = 32;
				elseif bags_list[j].typ == "well" then
					addx = 64;
					addy = 96;
				end;
				if bags_list[j].xi == mx+map_x and bags_list[j].yi == my+map_y and darkness[1][my+map_y][mx+map_x] == 0 and helpers.bagIsVisible(j) then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w-addx, (my-1)*tile_h*0.75+top_space-addy);
					else  
						love.graphics.draw(media.images.tmpobjs,bags_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-addx, (my-1)*tile_h*0.75+top_space-addy);
					end;
				end;
			end;
			for j=1, #objects_list do
				local addx = 0;
				local add y = 0;
				if objects_list[j].typ == "barrel" or  objects_list[j].typ == "cauldron" then
					addx = 32;
					addy = 32;
				elseif objects_list[j].typ == "obelisk" then
					addx = 32;
					addy = 96;
				elseif objects_list[j].typ == "pedestal" then
					addx = 32;
					addy = 68;			
				elseif objects_list[j].typ == "altar" then
					addx = 32;
					addy = 32;
				elseif objects_list[j].typ == "competition" then
					addx = 32;
					addy = 68;
				elseif objects_list[j].typ == "portal" then
					addx = 32;
					addy = 0;
				elseif objects_list[j].typ == "well" then
					addx = 64;
					addy = 90;
				elseif objects_list[j].typ == "fountain" then
					--addx = 64;
					--addy = 64;
					addx = 16;
					addy = 32;
				end;
				if objects_list[j].xi == mx+map_x and objects_list[j].yi == my+map_y and darkness[1][my+map_y][mx+map_x] == 0 and  objects_list[j].typ ~= "fountain" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.tmpobjs, objects_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w-addx, (my-1)*tile_h*0.75+top_space-addy);
					else  
						love.graphics.draw(media.images.tmpobjs,objects_list[j].img,((mx-1)*tile_w+left_space+tile_hw)-tile_w/2-addx, (my-1)*tile_h*0.75+top_space-addy);
					end;
				end;
			end;
			if darkness[1][my+map_y][mx+map_x] == 0 then
				if dlandscape_obj[my+map_y][mx+map_x] == "stone" then 
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.boom, stonewall_, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-95);
					else
						love.graphics.draw(media.images.boom, stonewall_, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-95);
					end;
				end;
				if dlandscape_obj[my+map_y][mx+map_x] == "pit" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.boom, pitfall_, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-85);
					else
						love.graphics.draw(media.images.boom, pitfall_, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-85);
					end;
				end;
				if dlandscape_obj[my+map_y][mx+map_x] == "ice" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.boom, ice, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-85);
					else
						love.graphics.draw(media.images.boom, ice, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-85);
					end;
				end;
				if dlandscape_obj[my+map_y][mx+map_x] == "mud" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.boom, mud, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-85);
					else
						love.graphics.draw(media.images.boom, mud, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-85);
					end;
				end; 
				if elandscape[my+map_y][mx+map_x] == "dust" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_dustexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_dustexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;   
				if elandscape[my+map_y][mx+map_x] == "razor" and (game_status == "boom" or game_status == "restoring") then  
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_razor:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_razor:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "spike" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_spike:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-50-tile_w, (my-1)*tile_h*0.75+top_space-90);
					else
						animation_spike:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-50-tile_w/2, (my-1)*tile_h*0.75+top_space-90);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "stone" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_stonewall:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-95);
					else
						animation_stonewall:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-95);
					end;
				end;   
				if elandscape[my+map_y][mx+map_x] == "pit" then 
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_pitfall:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-85);
					else
						animation_pitfall:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-85);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "toxic" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_toxicexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_toxicexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "wind" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_windexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_windexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "shrap" then
					  if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_shrapexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_shrapexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "frost" and (game_status == "boom" or game_status == "restoring") then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_frost:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_frost:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "acidbomb" then
					  if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_acidbomb:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_acidbomb:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if vlandscape_duration[my+map_y][mx+map_x] > 0 then --void
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_light:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_light:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "snow" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						--animation_snow:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
						love.graphics.draw(snoweffect[1].ps, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						--animation_snow:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
						love.graphics.draw(snoweffect[1].ps, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "cold" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_cold = anim8.newAnimation(cold[atk_direction]("1-9",1), 0.02,"pauseAtEnd");
						animation_cold:draw(media.images.spells, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-56);
					else
						animation_cold = anim8.newAnimation(cold[atk_direction]("1-9",1), 0.02,"pauseAtEnd");
						animation_cold:draw(media.images.spells, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-56);
					end;
				end;
				
				if elandscape[my+map_y][mx+map_x] == "deadlywave" then
					local addx = 0;
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						addx = tile_w/2
					end;
					animation_deadlywave:draw(media.images.waves,(mx+map_x)*tile_w-addx-448/2,(my+map_y)*tile_h*0.74-168/2);		
				end;
				
		--effects  with irradiation    
				love.graphics.setColor(255, 255, 255);
				if dlandscape_obj[my+map_y][mx+map_x] == "fire" then  
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_fireburn:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);		
					else
						animation_fireburn:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end; 
				if elandscape[my+map_y][mx+map_x] == "fire" then  
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_startfireburn:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_startfireburn:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if dlandscape_obj[my+map_y][mx+map_x] == "twister" then  
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_twister:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_twister:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
						if dlandscape_obj[my+map_y][mx+map_x] == "twisterpart" then  
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_dustexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_dustexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if alandscape_obj[my+map_y][mx+map_x] == "poison" then 
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_poisoned:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_poisoned:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if mlandscape_obj[my+map_y][mx+map_x] == "firemine" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						love.graphics.draw(media.images.boom,firemine,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else  
						love.graphics.draw(media.images.boom, firemine, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "flame" and (game_status== "boom" or game_status == "restoring") then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_flame:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_flame:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "static" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_staticexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_staticexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "prism" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_prism:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_prism:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "explo" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_firexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
					else
						animation_firexplo:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "light" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_light = anim8.newAnimation(light[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
						animation_light:draw(media.images.spells, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-56);		
					else		
						animation_light = anim8.newAnimation(light[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
						animation_light:draw(media.images.spells, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-56);
					end;
				end;
				if elandscape[my+map_y][mx+map_x] == "violation" then
					if (my+map_y)/2 == math.ceil((my+map_y)/2) then
						animation_souldrinker = anim8.newAnimation(light[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
						animation_souldrinker:draw(media.images.spells, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-56);		
					else		
						animation_souldrinker = anim8.newAnimation(light[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
						animation_souldrinker:draw(media.images.spells, ((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-56);
					end;
				end;
	        end;
--z-sorting + mobs
			if game_status == "missle" and in_fly == 0 and my == missle_y-map_y and mx == missle_x-map_x then
				if missle_y/2 == math.ceil(missle_y/2) then
					misto_hex_y = (missle_y-map_y)*tile_h*0.75+top_space-mob_h-hero_height/3;
					misto_hex_x = (missle_x-map_x)*tile_w+left_space+mob_x_add-hero_width/2;
				else
					misto_hex_y = (missle_y-map_y)*tile_h*0.75+top_space-mob_h+mob_add_mov_y-hero_height/3;
					misto_hex_x = (missle_x-map_x)*tile_w+left_space+mob_x_add+mob_add_mov_x-hero_width/2;
				end;
				
				for i=1,#lights do
					if lights[i].typ == "missle" then
						lights[i]["light"].setPosition(misto_hex_x,misto_hex_y+64);
					end;
				end;
				
				if missle_type=="bolt" then 
					animation_bolt = anim8.newAnimation(bolt[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_bolt:draw(media.images.missl, misto_hex_x-64,misto_hex_y);
				elseif missle_type=="arrow" then 
					animation_bolt = anim8.newAnimation(bolt[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_bolt:draw(media.images.missl, misto_hex_x-64,misto_hex_y);
				elseif missle_type=="battery" then
					--FIXME different missle types
				elseif missle_drive == "muscles" and  helpers.missleAtWarBook() and tricks.tricks_tips[missle_type].form == "range" and (tricks.tricks_tips[missle_type].skill == "bow" or tricks.tricks_tips[missle_type].skill == "crossbow") then
					animation_bolt = anim8.newAnimation(bolt[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_bolt:draw(media.images.missl, misto_hex_x-64,misto_hex_y);
				elseif missle_drive == "muscles" and  helpers.missleAtWarBook() and tricks.tricks_tips[missle_type].form == "range" and tricks.tricks_tips[missle_type].skill == "throwing" then
					--FIXME knives, surikense,axes,chakras, boomerangs					
					--animation_bolt = anim8.newAnimation(bolt[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					--animation_bolt:draw(media.images.missl, misto_hex_x-64,misto_hex_y);
				elseif missle_type=="bottle" then
					animation_grenade = anim8.newAnimation(grenade[atk_direction]("1-6",1), 0.02,"pauseAtEnd");
					animation_grenade:draw(media.images.missl, misto_hex_x-64,misto_hex_y);
				elseif missle_type=="flamearrow" then
					animation_flamearrow = anim8.newAnimation(flamearrow[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_flamearrow:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="coldbeam" then
					animation_coldbeam = anim8.newAnimation(coldbeam[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_coldbeam:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="lightbolt" then
					animation_lightbolt = anim8.newAnimation(lightbolt[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_lightbolt:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="spiritualarrow" then
					animation_spiritualarrow = anim8.newAnimation(spiritualarrow[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_spiritualarrow:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="darkflame" then
					animation_darkflame = anim8.newAnimation(darkflame[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_darkflame:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="mindblast" then
					animation_mindblast = anim8.newAnimation(mindblast[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_mindblast:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="dragonbreath" then
					animation_dragonbreath = anim8.newAnimation(dragonbreath[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_dragonbreath:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="acidburst" then
					animation_acidburst = anim8.newAnimation(acidburst[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_acidburst:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="staticharge" then
					animation_staticharge = anim8.newAnimation(staticharge[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_staticharge:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="poisonedspit" then
					animation_poisonedspit = anim8.newAnimation(poisonedspit[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_poisonedspit:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="deadlyswarm" then
					animation_deadlyswarm = anim8.newAnimation(deadlyswarm[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_deadlyswarm:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="fireball" then
					animation_fireball = anim8.newAnimation(fireball[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_fireball:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
					--elseif missle_type=="toxiccloud" then
					--animation_toxiccloud = anim8.newAnimation(toxiccloud[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					--animation_toxiccloud:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="windfist" then
					animation_windfist = anim8.newAnimation(windfist[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_windfist:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="iceball" then
					animation_iceball = anim8.newAnimation(iceball[atk_direction]("1-3",1), 0.02,"pauseAtEnd");
					animation_iceball:draw(media.images.spells, add_to_mslx*tile_w-tile_w*2,add_to_msly*tile_h*0.75-64);
				elseif missle_type=="sphericallightning" then
				elseif missle_type=="rockblast" then
					animation_rockblast = anim8.newAnimation(rockblast[rockline[rock_step].dir]("1-3",1), 0.02,"pauseAtEnd");
					animation_rockblast:draw(media.images.spells, misx-tile_w*2,misy+30);
				elseif missle_type=="toxiccloud" then
					animation_toxiccloud = anim8.newAnimation(toxiccloud[rockline[rock_step].dir]("1-3",1), 0.02,"pauseAtEnd");
					animation_toxiccloud:draw(media.images.spells, misx-tile_w*2,misy-64);
				end;
				in_fly=1;
			end;
			if game_status == "missle" then
				if missle_type=="meteorshower" then
					animation_meteor = anim8.newAnimation(meteor("1-3",1), 0.02);
					for i=1,6 do
						if boomy/2==math.ceil(boomy/2) then
							animation_meteor:draw(media.images.spells, (boomx+directions[2].xc[i])*64-300,(boomy+directions[2].y[i])*32*0.75-meteor_y-200);
						else
							animation_meteor:draw(media.images.spells, (boomx+directions[2].xn[i])*64-300,(boomy+directions[2].y[i])*32*0.75-meteor_y-200);
						end;
					end;
				end;
				if missle_type=="starburst" then
					animation_star = anim8.newAnimation(star("1-3",1), 0.02);
					for i=1,6 do
						if boomy/2==math.ceil(boomy/2) then
							animation_star:draw(media.images.spells, (boomx+directions[2].xc[i])*64-300,(boomy+directions[2].y[i])*32*0.75-meteor_y-200);
						else
							animation_star:draw(media.images.spells, (boomx+directions[2].xn[i])*64-300,(boomy+directions[2].y[i])*32*0.75-meteor_y-200);
						end;
					end;
				end;
				if missle_type=="acidrain" then
					animation_star = anim8.newAnimation(star("1-3",1), 0.02);
					for i=1,6 do
						if boomy/2==math.ceil(boomy/2) then
							animation_acidrain:draw(media.images.spells, (boomx+directions[2].xc[i])*64-300,(boomy+directions[2].y[i])*32*0.75-meteor_y-200);
						else
							animation_acidrain:draw(media.images.spells, (boomx+directions[2].xn[i])*64-300,(boomy+directions[2].y[i])*32*0.75-meteor_y-200);
						end;
					end;
				end;
				if missle_type=="armageddon" then
					local mx = map_x;
					local my = map_y;
					for i = 1,12 do
						mx = mx + math.ceil(i/3);
						my =  5*(mx - 4*math.ceil(i/3));	
						if helpers.passCheck (mx,my) then
							animation_armageddonsky:draw(media.images.spells, mx*64-300,my*32*0.75-meteor_y-200);
						end;
					end;
					local mx = map_x;
					local my = map_y;
					for i = 1,16 do
						mx = mx + math.ceil(i/4);
						my =  5*(mx - 3*math.ceil(i/4));
						if helpers.passCheck (mx,my) then
							animation_armageddonground:draw(media.images.spells, mx*64-300,my*32*0.75-stone_y+200);
						end;
					end;
				end;
				if missle_type=="deathblossom" then
					if boomy/2==math.ceil(boomy/2) then
						animation_deathblossom:draw(media.images.spells, boomx*64-300,boomy*32*0.75-meteor_y-200);
					else
						animation_deathblossom:draw(media.images.spells, boomx*64-300,boomy*32*0.75-meteor_y-200);
					end;
				end;
				if missle_type=="comete" then
					if boomy/2==math.ceil(boomy/2) then
						animation_comete:draw(media.images.spells, boomx*64-300,boomy*32*0.75-meteor_y-200);
					else
						animation_comete:draw(media.images.spells, boomx*64-300,boomy*32*0.75-meteor_y-200);
					end;
				end;
			end;
			for i=1,#chars_mobs_npcs do
				if chars_mobs_npcs[i].y/2 == math.ceil(chars_mobs_npcs[i].y/2) then
					mob_x_add=-0.75*tile_w;
				else
					mob_x_add=-0.25*tile_w;
				end;
				if i~= current_mob then
					mobto_hex_y=math.ceil((chars_mobs_npcs[i].y-map_y)*tile_h*0.75+top_space-mob_h-hero_height/3);
					mobto_hex_x=math.ceil((chars_mobs_npcs[i].x-map_x)*tile_w+left_space+mob_x_add-hero_width/2);
				elseif i==current_mob then
					mobto_hex_y=math.ceil((chars_mobs_npcs[i].y-map_y)*tile_h*0.75+top_space-mob_h+mob_add_mov_y-hero_height/3);
					mobto_hex_x=math.ceil((chars_mobs_npcs[i].x-map_x)*tile_w+left_space+mob_x_add+mob_add_mov_x-hero_width/2);
				end;
				damaged = 0;
				if game_status == "multidamage" then
					for d=1,#damaged_mobs do
						if damaged_mobs[d] == i then
							damaged=1;
						end;
					end;
				end;
				--draw.irradiation (mx,my);
				if my== chars_mobs_npcs[i].y-map_y and mx== chars_mobs_npcs[i].x-map_x then
					
					if chars_mobs_npcs[i].stone > 0  then
						love.graphics.setColor(125, 125, 125);
					elseif chars_mobs_npcs[i].freeze > 0 then
						love.graphics.setColor(150, 150, 255);
					end;
					
					if game_status =="neutral"
					or game_status == "premoving" --ai only
					or (game_status == "moving" and i ~= current_mob)
					or game_status =="sensing"
					or game_status =="path_finding"
					or game_status == "missle"
					or game_status == "boom"
					or game_status == "pause"
					or game_status == "restoring"
					or game_status == "spellbook"
					or game_status == "warbook"
					or game_status == "questbook"
					or game_status == "inventory"
					or game_status == "alchemy"
					or game_status == "picklocking"
					or game_status == "crafting"
					or game_status == "stats"
					or game_status == "skills"
					or game_status == "literature"
					or game_status == "map"
					or game_status == "chat"
					or game_status == "mindgame"
					or game_status == "housewatch"
					or game_status == "buying"
					or game_status == "selling"
					or game_status == "npcrepair"
					or game_status == "npcidentify"
					or game_status == "ai"
					or game_status == "switchlevel"
					or game_status == "calendar"
					or game_status == "obelisk"
					or game_status == "well"
					or game_status == "log"
					or (game_status == "shot" and i ~= current_mob)
					or (game_status == "damage" and i ~= victim)
					or (game_status == "multidamage" and damaged==0)
					or (i ~= current_mob and i ~= victim and damaged==0) then
						if i == selected_mob and darkness[1][chars_mobs_npcs[i].y][chars_mobs_npcs[i].x] == 0  then
							love.graphics.draw(media.images.hex, cursor_white,mobto_hex_x-tile_w,mobto_hex_y+86); -- selection from portraits marked
						end
						if chars_mobs_npcs[i].control=="player" or (darkness[1][chars_mobs_npcs[i].y ][chars_mobs_npcs[i].x ]==0 and chars_mobs_npcs[i].invisibility == 0 and chars_mobs_npcs[i].stealth == 0) then
							if chars_mobs_npcs[i].control=="player" and i == current_mob then --mark player character whoose turn is now
								love.graphics.draw(media.images.hex, cursor_yellow,mobto_hex_x-tile_w,mobto_hex_y+86); --current char marked
							end;
							if chars_mobs_npcs[i].invisibility > 0 then
								love.graphics.setColor(255, 255, 255, 150);
							elseif chars_mobs_npcs[i].stealth > 0 then
								love.graphics.setColor(125, 125, 125, 150);
							end;
							if chars_mobs_npcs[i].status==1 then
								local tmp = chars_mobs_npcs[i].sprite .. "_stay";
								local mob_stay = loadstring("return " .. tmp)();
								local tmpi = "media.images." .. chars_mobs_npcs[i].sprite .. "_base";
								local img_mob_base = loadstring("return " .. tmpi)();
								love.graphics.draw(img_mob_base, mob_stay[chars_mobs_npcs[i].rot ],mobto_hex_x-tile_w,mobto_hex_y);
							else
								local tmp = chars_mobs_npcs[i].sprite .. "_dead";
								local mob_dead=loadstring("return " .. tmp)();
								local tmpi="media.images." .. chars_mobs_npcs[i].sprite .. "_base";
								local img_mob_base=loadstring("return " .. tmpi)();
								love.graphics.draw(img_mob_base,mob_dead[chars_mobs_npcs[i].rot ], mobto_hex_x-tile_w-tile_w/2,mobto_hex_y);
							end;
							love.graphics.setColor(255, 255, 255,255);
						end;
					elseif game_status == "moving" and i == current_mob then
							if chars_mobs_npcs[i].invisibility > 0 then
								love.graphics.setColor(255, 255, 255, 150);
							elseif chars_mobs_npcs[i].stealth > 0 then
								love.graphics.setColor(125, 125, 125, 150);
							end;
						if chars_mobs_npcs[i].control=="player" or (darkness[1][chars_mobs_npcs[i].y ][chars_mobs_npcs[i].x ] == 0 and chars_mobs_npcs[i].invisibility == 0 and chars_mobs_npcs[i].stealth == 0) then
							local tmpi="media.images." .. chars_mobs_npcs[i].sprite .. "_base";
							local img_mob_base=loadstring("return " .. tmpi)();
							if global.use_walk_animation then
								animation_walk:draw(img_mob_base, mobto_hex_x-tile_w-tile_w/2,mobto_hex_y);
							else
								local tmp = chars_mobs_npcs[i].sprite .. "_stay";
								local mob_stay = loadstring("return " .. tmp)();
								local tmpi = "media.images." .. chars_mobs_npcs[i].sprite .. "_base";
								local img_mob_base = loadstring("return " .. tmpi)();
								love.graphics.draw(img_mob_base, mob_stay[chars_mobs_npcs[i].rot ],mobto_hex_x-tile_w,mobto_hex_y);
							end;
						end;
						love.graphics.setColor(255, 255, 255,255);
					elseif game_status == "attack" then
						if i == current_mob and i~=victim then
							local tmpi="media.images." .. chars_mobs_npcs[i].sprite .. "_war";
							local img_mob_war=loadstring("return " .. tmpi)();
							animation_atk1:draw(img_mob_war, mobto_hex_x-tile_w-32,mobto_hex_y); --low quality (
						end
						--if  i == victim and chars_mobs_npcs[victim].status == 1 then
						if  i == victim then
							if chars_mobs_npcs[i].status == 1 and chars_mobs_npcs[i].freeze == 0 and chars_mobs_npcs[i].stone == 0 and block == 0 and parry == 0 then
								local tmpi="media.images." .. chars_mobs_npcs[i].sprite .. "_base";
								local img_mob_base=loadstring("return " .. tmpi)();
								animation_dmg[chars_mobs_npcs[i].rot ]:draw(img_mob_base, mobto_hex_x-tile_w*1.5,mobto_hex_y-8);		
							elseif chars_mobs_npcs[i].freeze~=0 or chars_mobs_npcs[i].stone~=0 then
								local tmp= chars_mobs_npcs[i].sprite .. "_stay";
								local mob_stay=loadstring("return " .. tmp)();
								local tmpi="media.images." .. chars_mobs_npcs[i].sprite .. "_base";
								local img_mob_base=loadstring("return " .. tmpi)();
								love.graphics.draw(img_mob_base, mob_stay[chars_mobs_npcs[i].rot ],mobto_hex_x-tile_w,mobto_hex_y);
							elseif dodge == 1 then
								--local tmpi="media.images." .. chars_mobs_npcs[i].sprite .. "_def";
								--local img_mob_def=loadstring("return " .. tmpi)();
								--animation_block[chars_mobs_npcs[i].rot ]:draw(img_mob_def, mobto_hex_x-tile_w*1.5,mobto_hex_y-8);
							elseif hands == 1 then
								--local tmpi="media.images." .. chars_mobs_npcs[i].sprite .. "_def";
								--local img_mob_def=loadstring("return " .. tmpi)();
								--animation_block[chars_mobs_npcs[i].rot ]:draw(img_mob_def, mobto_hex_x-tile_w*1.5,mobto_hex_y-8);
							elseif block==1 then
								local tmpi="media.images." .. chars_mobs_npcs[i].sprite .. "_def";
								local img_mob_def=loadstring("return " .. tmpi)();
								animation_block[chars_mobs_npcs[i].rot ]:draw(img_mob_def, mobto_hex_x-tile_w*1.5,mobto_hex_y-8);
							elseif parry==1 then
								--local tmpi="media.images." .. chars_mobs_npcs[i].sprite .. "_def";
								--local img_mob_def=loadstring("return " .. tmpi)();
								--animation_block[chars_mobs_npcs[i].rot ]:draw(img_mob_def, mobto_hex_x-tile_w*1.5,mobto_hex_y-8);
							end;
						end;
					elseif game_status == "shot" and i == current_mob then
						local tmpi = "media.images." .. chars_mobs_npcs[i].sprite .. "_rng";
						local img_mob_rng=loadstring("return " .. tmpi)();
						if missle_type == "bolt" or missle_type == "arrow" 
						or (missle_drive == "muscles" and  helpers.missleAtWarBook() and tricks.tricks_tips[missle_type].form == "range" and (tricks.tricks_tips[missle_type].skill == "bow" or tricks.tricks_tips[missle_type].skill == "crossbow"))
						then
							animation_sht1:draw(img_mob_rng, mobto_hex_x-tile_w*1.5,mobto_hex_y);
						elseif missle_type == "bottle" then
							animation_sht1:draw(media.images.rogue_rng2, mobto_hex_x-tile_w*1.5,mobto_hex_y);
						elseif missle_drive == "spellbook" or  missle_drive == "scroll" or missle_drive == "wand" then
							animation_sht1:draw(img_mob_rng, mobto_hex_x-tile_w*1.5,mobto_hex_y);
						end;
					elseif game_status == "missle" then
					elseif game_status == "multidamage" then
						if damaged == 1 and (darkness[1][chars_mobs_npcs[i].y][chars_mobs_npcs[i].x] == 0 and chars_mobs_npcs[i].invisibility == 0 and chars_mobs_npcs[i].stealth == 0) then
							if chars_mobs_npcs[victim].freeze==0 and chars_mobs_npcs[victim].stone==0 then
								local tmpi = "media.images." .. chars_mobs_npcs[i].sprite .. "_base";
								local img_mob_base = loadstring("return " .. tmpi)();
								animation_dmg[chars_mobs_npcs[i].rot ]:draw(img_mob_base, mobto_hex_x-tile_w*1.5,mobto_hex_y-8);
							elseif chars_mobs_npcs[victim].freeze ~= 0 and chars_mobs_npcs[victim].stone ~= 0 then
								local tmp = chars_mobs_npcs[i].sprite .. "_stay";
								local mob_stay = loadstring("return " .. tmp)();
								local tmpi = "media.images." .. chars_mobs_npcs[i].sprite .. "_base";
								local img_mob_base = loadstring("return " .. tmpi)();
								love.graphics.draw(img_mob_base, mob_stay[chars_mobs_npcs[i].rot ],mobto_hex_x-tile_w,mobto_hex_y);
							end;
						end;
					elseif game_status =="damage" and i == victim then
						if chars_mobs_npcs[victim].freeze == 0 and chars_mobs_npcs[victim].stone == 0 and (missle_drive == "spellbook" or  missle_drive == "scroll" or missle_drive == "wand") and magic.spell_tips[missle_type].form == "ally" then
							local tmp = chars_mobs_npcs[i].sprite .. "_stay";
							local mob_stay = loadstring("return " .. tmp)();
							local tmpi = "media.images." .. chars_mobs_npcs[i].sprite .. "_base";
							local img_mob_base = loadstring("return " .. tmpi)();
							love.graphics.draw(img_mob_base, mob_stay[chars_mobs_npcs[i].rot ],mobto_hex_x-tile_w,mobto_hex_y);
						elseif chars_mobs_npcs[victim].freeze == 0 and chars_mobs_npcs[victim].stone == 0 then
							local tmpi = "media.images." .. chars_mobs_npcs[i].sprite .. "_base";
							local img_mob_base = loadstring("return " .. tmpi)();
							animation_dmg[chars_mobs_npcs[i].rot ]:draw(img_mob_base, mobto_hex_x-tile_w*1.5,mobto_hex_y-8);
						elseif chars_mobs_npcs[victim].freeze ~= 0 or chars_mobs_npcs[victim].stone ~= 0 then
							local tmp = chars_mobs_npcs[i].sprite .. "_stay";
							local mob_stay=loadstring("return " .. tmp)();
							local tmpi = "media.images." .. chars_mobs_npcs[i].sprite .. "_base";
							local img_mob_base = loadstring("return " .. tmpi)();
							love.graphics.draw(img_mob_base, mob_stay[chars_mobs_npcs[i].rot ],mobto_hex_x-tile_w,mobto_hex_y);
						end;
					end;
					love.graphics.setColor(255, 255, 255);
					if  chars_mobs_npcs[i].stone>0 then
					elseif chars_mobs_npcs[i].freeze>0 then
						love.graphics.draw(media.images.boom, freeze,mobto_hex_x-tile_w*1.5,mobto_hex_y);
					end;
					if  chars_mobs_npcs[i].control == "player" and chars_mobs_npcs[i].protectionmode ~= "none" then
						if chars_mobs_npcs[i].protectionmode == "dodge" then
							love.graphics.draw(media.images.ui, dodge_icon,mobto_hex_x-tile_w*1.5+32,mobto_hex_y-50);
						elseif chars_mobs_npcs[i].protectionmode == "hands" then
							love.graphics.draw(media.images.ui, hadblock_icon,mobto_hex_x-tile_w*1.5+32,mobto_hex_y-50);
						elseif chars_mobs_npcs[i].protectionmode == "block" then
							love.graphics.draw(media.images.ui, block_icon,mobto_hex_x-tile_w*1.5+32,mobto_hex_y-50);
						elseif chars_mobs_npcs[i].protectionmode == "parry" then
							love.graphics.draw(media.images.ui, parry_icon,mobto_hex_x-tile_w*1.5+32,mobto_hex_y-50);
						end;
					end;
					if game_status == "boom" then
						misto_hex_y = (boomy-map_y)*tile_h*0.75+top_space;
						if boomy/2 == math.ceil(boomy/2) then
							misto_hex_x = (boomx-map_x)*tile_w+left_space-96;
						else
							misto_hex_x = (boomx-map_x)*tile_w+left_space-64;
						end;
						love.graphics.setColor(255, 255, 255);
						if missle_type=='fireball' then
							animation_firexplo:draw(media.images.boom, misto_hex_x-64,misto_hex_y-96);
						elseif missle_type=='toxiccloud' then
							animation_toxicexplo:draw(media.images.boom, misto_hex_x-64,misto_hex_y-96);
						elseif missle_type=='iceball' then
							animation_icexplo:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='comete' then
							animation_icexplo:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='flamearrow' then
							animation_flame:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='coldbeam' then
							animation_snow:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128); 
						elseif missle_type=='staticharge' then
							animation_staticexplo:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='poisonedspit' then
							animation_poisoned:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='acidburst' then
							animation_acidexplo:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='sphericallightning' then
							animation_staticexplo:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='heal' then
							animation_healbuff:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='charge' then
							animation_chargebuff:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='regeneration' then
							animation_regeneration:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='encourage' then
							animation_chargebuff:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='windfist' then
							animation_windexplo:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='rockblast' then
							animation_dustexplo:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='incineration' then
							animation_incexplo:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='implosion' then
							animation_implosion:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='dehydratation' then
							animation_dehydratation:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='massdistortion' then
							animation_massdistortion:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='sunray' then
							animation_sunray:draw(media.images.boom, misto_hex_x-64,misto_hex_y-246);
						elseif missle_type=='monlight' then
							animation_monlight:draw(media.images.boom, misto_hex_x-64,misto_hex_y-256);
						elseif missle_type=='lightning' then
							animation_lightning:draw(media.images.boom, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='protfromfire' then
							animation_protfromfire:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='protfromcold' then
							animation_protfromcold:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='protfromstatic' then
							animation_protfromstatic:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='protfromacid' then
							animation_protfromacid:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='protfrompoison' then
							animation_protfrompoison:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='protfromdisease' then
							animation_protfromdisease:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='protofmind' then
							animation_protofmind:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='protofspirit' then
							animation_protofspirit:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='shield' then
							animation_shield:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='stoneskin' then
							animation_stoneskin:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='charm' then
							animation_charm:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='berserk' then
							animation_berserk:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='enslave' then
							animation_berserk:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='controlundead' then
							animation_berserk:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='fear' then
							animation_fear:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='resurrect' then
							animation_resurrect:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='haste' then
							animation_haste:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='speed' then
							animation_speed:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='strenght' then
							animation_strenght:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='dash' then
							animation_dash:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=='mobility' then
							animation_mobility:draw(media.images.buff, misto_hex_x-64,misto_hex_y-128);
						elseif missle_type=="chainlightning" then
							local linetable={};
							while (#linetable>0) do
								table.remove(linetable,1);
							end;
							for i=1,#mobsmarked do
								moveto_hex_y=math.ceil(chars_mobs_npcs[mobsmarked[i]].y-1)*tile_h*0.75+top_space;
								if chars_mobs_npcs[mobsmarked[i]].y/2 == math.ceil(chars_mobs_npcs[mobsmarked[i]].y/2 ) then
									moveto_hex_x=math.ceil(chars_mobs_npcs[mobsmarked[i]].x-1)*tile_w+left_space;
								else
									moveto_hex_x=math.ceil(chars_mobs_npcs[mobsmarked[i]].x-1)*tile_w+left_space+tile_w/2;
								end;
								local tmprnd=anim_rnd[i]*3;
								table.insert(linetable,moveto_hex_x-tile_w/2);
								table.insert(linetable,moveto_hex_y-tile_h/4+tmprnd+math.random(5));
							end;
							love.graphics.setColor(225, 225, 255);
							love.graphics.setLineStyle("rough");
							love.graphics.line(linetable);
							love.graphics.setColor(255, 255, 255);
						 end;
					end; 
				end;
			end;
			
			if elandscape[my+map_y][mx+map_x] == "moonlight" then  
				if (my+map_y)/2 == math.ceil((my+map_y)/2) then
					animation_moonlight:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
				else
					animation_moonlight:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
				end;
			end;
			if elandscape[my+map_y][mx+map_x] == "souldrinker" then  
				if (my+map_y)/2 == math.ceil((my+map_y)/2) then
					animation_souldrinker:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
				else
					animation_souldrinker:draw(media.images.boom,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
				end;
			end;
			if elandscape[my+map_y][mx+map_x] == "heal" then
				if (my+map_y)/2 == math.ceil((my+map_y)/2) then
					animation_healbuff:draw(media.images.buff,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w, (my-1)*tile_h*0.75+top_space-106);
				else
					animation_healbuff:draw(media.images.buff,((mx-1)*tile_w+left_space+tile_hw)-70-tile_w/2, (my-1)*tile_h*0.75+top_space-106);
				end;
			end;
		end;
	end;
end;

function draw.bag ()
	local x,y = helpers.centerObject(media.images.inv1);
	local inv_add_x = x+12;
	local inv_add_y = y-25;
	local inv_part2 = x+654+3*32;
	sorttarget="bag";
	sorttarget=oldsorttarget;
	for i=1,11 do
		for h=1,15 do
			if bags[bagid][h][i] > 0 and bags[bagid][h][i] < 10000 then
				tempid=bags[bagid][h][i];
				if bags_list[bagid][tempid] then			
					draw.drawItem(tempid,bags_list[bagid][tempid].ttxid,(i-1)*32+inv_part2,(h-1)*32+inv_add_y,true,bagid);
				end;
			end;
			if bagid > 0 and bags[bagid][h][i] > 0 then
			end;
		end;
	end;
end;

function draw.showinventory()
	love.graphics.setFont(statFont);
	love.graphics.draw(media.images.charfaces, charfaces[chars_mobs_npcs[current_mob].face], 470, 150);
	love.graphics.print(chars_stats[current_mob].name, 445+math.ceil(#chars_stats[current_mob].name/2)*10, 245);
	
	--[[if not global.buttons.sell_button then
	
	global.buttons.sell_button = loveframes.Create("imagebutton");
	global.buttons.sell_button:SetImage(media.images.button1);
	global.buttons.sell_button:SetPos(math.ceil(global.screenWidth/2 - media.images.button1:getWidth()/2),400);
	global.buttons.sell_button:SizeToImage()
	global.buttons.sell_button:SetText("SELL");
	global.buttons.sell_button.OnClick = function(object)
		global.showinventory_flag = "sell";
			end;
	global.buttons.ident_button = loveframes.Create("imagebutton");
	global.buttons.ident_button:SetImage(media.images.button1);
	global.buttons.ident_button:SetPos(math.ceil(global.screenWidth/2 - media.images.button1:getWidth()/2),500);
	global.buttons.ident_button:SizeToImage()
	global.buttons.ident_button:SetText("ID");
	global.buttons.ident_button.OnClick = function(object)
		global.showinventory_flag = "id";
			end;	
	
	global.buttons.repair_button = loveframes.Create("imagebutton");
	global.buttons.repair_button:SetImage(media.images.button1);
	global.buttons.repair_button:SetPos(math.ceil(global.screenWidth/2 - media.images.button1:getWidth()/2),600);
	global.buttons.repair_button:SizeToImage()
	global.buttons.repair_button:SetText("REP");
	global.buttons.repair_button.OnClick = function(object)
		global.showinventory_flag = "repair";
			end;	
	end;]]
	
	local bag_found = false;
	for j=1, #bags_list do
		if chars_mobs_npcs[current_mob].x == bags_list[j].x and chars_mobs_npcs[current_mob].y == bags_list[j].y and not bag_found then
			bagid = j;
			bag_found = true;
			if bags_list[j].typ == "bag" or (bags_list[j].typ == "chest" and not bags_list[j].locked and chars_mobs_npcs[current_mob].rot == bags_list[j].dir) then
				if bags_list[j].typ == "chest" and not bags_list[j].opened then
					utils.playSfx(media.sounds.chestopen_unlocked, 1);
					bags_list[j].opened = true;
					if bags_list[j].traped then
						if bags_list[j].locktype == 1 then
							helpers.chestTrapDisk(j);
						end;
						bags_list[j].traped = false;
					end;
				end;
				draw.bag();
			elseif bags_list[j].typ == "bag" or (bags_list[j].typ == "chest" and bags_list[j].locked and chars_mobs_npcs[current_mob].rot == bags_list[j].dir) or (bags_list[j].typ == "door" and helpers.cursorAtClosedDoor(helpers.hexInFronTOfMob(current_mob))) then
				if not start_picklock then
					start_picklock = true;
					lock_elements = {};
					diskcode = {};
					local lockcode = {};
					local code = bags_list[bagid].lockcode;
					for w in string.gmatch(code, "%d") do
						table.insert(lockcode, tonumber(w));
					end;
					for i=1,10 do
						if lockcode[i] > 0 then
							lock_elements[i] = 1;
						else
							lock_elements[i] = 0;
						end;
					end;
					for i=1,10 do
						if lockcode[i] > 0 then
							diskcode[i] = math.random(2,8); -- not 1 to prevent trap activation at start
						else
							diskcode[i] = 8;
						end;
					end;
				end;
				for i=1,#chars_stats[current_mob]["inventory_list"] do
					if helpers.checkPickLock (bags_list[j].lockcode,bags_list[j].locktype) then
						bags_list[j].locked = false;
						for h=1,10 do
							lock_elements[h] = 0;
						end;
						utils.playSfx(media.sounds.chestopen_key, 1);
					end;	
				end;
				if bags_list[j].locked then
					game_status = "picklocking";
				end;
			else
				--draw_zaglushka ()
			end;
		end;
	end;
	--love.graphics.print(chars_stats[current_mob].name, 445+math.ceil(#chars_stats[current_mob].name/2)*10, 245);
	--love.graphics.print(chars_mobs_npcs[current_mob].lvl_alchemy, 600, 150);
	--love.graphics.print(chars_mobs_npcs[current_mob].num_alchemy, 600, 170);
	--love.graphics.print(lognames.actions.potionpower .. " ".. chars_stats[current_mob].lvl_alchemy*chars_stats[current_mob].num_alchemy, 600, 190);	
end;

function  draw.mobtips () --FIXME inventory and weapon in rh/lh/ranged + armor
	loveframes.util.RemoveAll();
	love.graphics.draw(media.images.ui, tip,mX,mY);
	local x, y, w, h = tip:getViewport( );
	if chars_mobs_npcs[current_mob].lvl_monsterid >= 3 then
		love.graphics.draw(media.images.ui, tip,mX+w,mY); 
	end;
	if chars_mobs_npcs[tmpc].person == "mob" then
		local tmpclass="mobs_stats." .. chars_mobs_npcs[tmpc].class
		--tmpclass3=loadstring("return " .. tmpclass)()
		tmpclass3=loadstring("return " .. "chars_mobs_npcs[" .. tmpc .. "]")();
	elseif chars_mobs_npcs[tmpc].person == "char" then
		--tmpclass3=loadstring("return " .. "chars_stats[" .. tmpc .. "]")();
		tmpclass3=loadstring("return " .. "chars_mobs_npcs[" .. tmpc .. "]")();
	elseif chars_mobs_npcs[tmpc].person == "npc" then
		tmpclass3=loadstring("return " .. "chars_mobs_npcs[" .. tmpc .. "]")();
    end;
	if tmpclass3.person == "char" then
		love.graphics.draw(media.images.charfaces, charfaces[tmpclass3.face], mX+5,  mY+5, 0, 1,1);
	elseif tmpclass3.person == "npc" then
		love.graphics.draw(media.images.npcfaces, npcfaces[tmpclass3.face], mX+5,  mY+5, 0, 1,1);
	elseif tmpclass3.person == "mob" then
		love.graphics.draw(media.images.mobfaces, mobfaces[tmpclass3.face], mX+5,  mY+5, 0, 1,1);
	end;
	love.graphics.setColor(0, 0, 0);
	love.graphics.setFont(mainFont);
	love.graphics.print(helpers.mobName(tmpc), mX+100,mY+5);
	love.graphics.print(lognames.mob_names[chars_mobs_npcs[tmpc].class], mX+100,mY+20);
	love.graphics.print(nature[chars_mobs_npcs[tmpc].nature], mX+100+#lognames.mob_names[chars_mobs_npcs[tmpc].class]/2,mY+35);
	if chars_mobs_npcs[tmpc].hp>=chars_mobs_npcs[tmpc].hp_max then
		love.graphics.setColor(0, 155, 0);
		love.graphics.print(healthstatus.healthy, mX+100,mY+50);
	elseif chars_mobs_npcs[tmpc].hp<chars_mobs_npcs[tmpc].hp_max and chars_mobs_npcs[tmpc].hp>=chars_mobs_npcs[tmpc].hp_max*0.9 then
		love.graphics.setColor(255, 255, 0);
		love.graphics.print(healthstatus.lighty, mX+100,mY+50);
	elseif chars_mobs_npcs[tmpc].hp<chars_mobs_npcs[tmpc].hp_max*0.9 and chars_mobs_npcs[tmpc].hp>=chars_mobs_npcs[tmpc].hp_max*0.5 then
		love.graphics.setColor(255, 255, 0);
		love.graphics.print(healthstatus.wonded, mX+100,mY+50);
	elseif chars_mobs_npcs[tmpc].hp<chars_mobs_npcs[tmpc].hp_max*0.5 and chars_mobs_npcs[tmpc].hp>=chars_mobs_npcs[tmpc].hp_max*0.9 then
		love.graphics.setColor(255, 125, 0);
		love.graphics.print(healthstatus.seriously, mX+100,mY+50);
	elseif chars_mobs_npcs[tmpc].hp<chars_mobs_npcs[tmpc].hp_max*0.5 and chars_mobs_npcs[tmpc].hp>chars_mobs_npcs[tmpc].hp_max*0.9 then
		love.graphics.setColor(255, 125, 0);
		love.graphics.print(healthstatus.seriously, mX+100,mY+50);
	elseif chars_mobs_npcs[tmpc].hp<=chars_mobs_npcs[tmpc].hp_max*0.9 and chars_mobs_npcs[tmpc].hp>0 then
		love.graphics.setColor(255, 0, 0);
		love.graphics.print(healthstatus.subgrave, mX+100,mY+50);
	elseif chars_mobs_npcs[tmpc].hp<=0 then
		love.graphics.setColor(0, 0, 0);
		if chars_mobs_npcs[tmpc].status==0 then
			love.graphics.print(healthstatus.uncond, mX+100,mY+50);
		elseif chars_mobs_npcs[tmpc].status==-1 then
			love.graphics.print(healthstatus.dead, mX+100,mY+50);
		end;
	end;
	if chars_stats[current_mob].spellbook==1 or chars_mobs_npcs[current_mob].lvl_monsterid >= 1 then
		if tmpclass3.spellbook==0 then
			love.graphics.setColor(0, 0, 0);
			love.graphics.print(manastatus.nobook, mX+100,mY+65);
		else
			if chars_mobs_npcs[tmpc].sp>=chars_mobs_npcs[tmpc].sp_max*0.75 then
				love.graphics.setColor(0, 0, 255) ;
				love.graphics.print(manastatus.full, mX+100,mY+65);
			elseif chars_mobs_npcs[tmpc].sp<chars_mobs_npcs[tmpc].sp_max*0.75 and chars_mobs_npcs[tmpc].sp>=chars_mobs_npcs[tmpc].sp_max*0.5 then
				love.graphics.setColor(0, 0, 225);
				love.graphics.print(manastatus.morethanhalf, mX+100,mY+65);
			elseif chars_mobs_npcs[tmpc].sp<chars_mobs_npcs[tmpc].sp_max*0.5 and chars_mobs_npcs[tmpc].sp>=chars_mobs_npcs[tmpc].sp_max*0.25 then
				love.graphics.setColor(0, 0, 200) ;
				love.graphics.print(manastatus.lessthanhalf, mX+100,mY+65);
			elseif chars_mobs_npcs[tmpc].sp<chars_mobs_npcs[tmpc].sp_max*0.25 and chars_mobs_npcs[tmpc].sp>0 then
				love.graphics.setColor(0, 0, 150);
				love.graphics.print(manastatus.quaterorless, mX+100,mY+65);
			elseif chars_mobs_npcs[tmpc].sp<=0 then
				love.graphics.setColor(0, 0, 0);
				love.graphics.print(manastatus.nomana, mX+100,mY+65);
			end;
		end;
	else
		love.graphics.setColor(0, 0, 0);
		love.graphics.print(manastatus.idk, mX+100,mY+65);
	end;
	if chars_mobs_npcs[current_mob].lvl_monsterid >= 1 then 
		if chars_mobs_npcs[tmpc].st>=chars_mobs_npcs[tmpc].st_max*0.75 then
			love.graphics.setColor(125, 125, 125);
			love.graphics.print(staminastatus.full, mX+100,mY+80);
		elseif chars_mobs_npcs[tmpc].st<chars_mobs_npcs[tmpc].st_max*0.75 and chars_mobs_npcs[tmpc].st>=chars_mobs_npcs[tmpc].st_max*0.5 then
			love.graphics.setColor(125, 125, 125); 
			love.graphics.print(staminastatus.ok, mX+100,mY+80);
		elseif chars_mobs_npcs[tmpc].st<chars_mobs_npcs[tmpc].st_max*0.5 and chars_mobs_npcs[tmpc].st>=chars_mobs_npcs[tmpc].st_max*0.25 then
			love.graphics.setColor(125, 125, 125);
			love.graphics.print(staminastatus.abittired, mX+100,mY+80);
		elseif chars_mobs_npcs[tmpc].st<chars_mobs_npcs[tmpc].st_max*0.25 and chars_mobs_npcs[tmpc].st>=chars_mobs_npcs[tmpc].st_max*0.1 then
			love.graphics.setColor(125, 125, 125);
			love.graphics.print(staminastatus.tired, mX+100,mY+80);
		elseif chars_mobs_npcs[tmpc].st<=chars_mobs_npcs[tmpc].st_max*0.1 then
			love.graphics.setColor(125, 125, 125);
			love.graphics.print(staminastatus.disabled, mX+100,mY+80);
		end;
	   
		if chars_mobs_npcs[tmpc].rt==200 then
			love.graphics.setColor(125, 125, 125);
			love.graphics.print(recoverystatus.full, mX+100,mY+95);
		elseif chars_mobs_npcs[tmpc].rt>=150 then
			love.graphics.setColor(125, 125, 125);
			love.graphics.print(recoverystatus.ok, mX+100,mY+95);
		elseif chars_mobs_npcs[tmpc].rt>=100 then
			love.graphics.setColor(125, 125, 125);
			love.graphics.print(recoverystatus.half, mX+100,mY+95);
		elseif chars_mobs_npcs[tmpc].rt>=50 then
			love.graphics.setColor(125, 125, 125);
			love.graphics.print(recoverystatus.quater, mX+100,mY+95);
		elseif chars_mobs_npcs[tmpc].rt>50 then
			love.graphics.setColor(125, 125, 125);
			love.graphics.print(recoverystatus.abit, mX+100,mY+95);
		end;
		love.graphics.setColor(0, 0, 0)
		local moral_index = 4;
		if chars_mobs_npcs[tmpc].moral < chars_mobs_npcs[tmpc].base_moral and chars_mobs_npcs[tmpc].moral > -1*chars_mobs_npcs[tmpc].base_moral then
			moral_index = 2;
		elseif chars_mobs_npcs[tmpc].moral > chars_mobs_npcs[tmpc].base_moral then
			moral_index = 1;
		elseif chars_mobs_npcs[tmpc].moral < -1*chars_mobs_npcs[tmpc].base_moral then
			moral_index = 3;
		end;
		if not helpers.aliveNature(tmpc) then
			moral_index = 4;
		end;
		love.graphics.print(chars_mobs_npcs[tmpc].moral, mX+10,mY+110);
		love.graphics.print(moralstatus[moral_index], mX+100,mY+110);
	end;
	if chars_mobs_npcs[current_mob].lvl_monsterid == 5 then
		if chars_mobs_npcs[tmpc].hp>=chars_mobs_npcs[tmpc].hp_max then
			love.graphics.setColor(0, 155, 0);
		elseif chars_mobs_npcs[tmpc].hp<chars_mobs_npcs[tmpc].hp_max and chars_mobs_npcs[tmpc].hp>=chars_mobs_npcs[tmpc].hp_max*0.9 then
			love.graphics.setColor(255, 255, 0);
		elseif chars_mobs_npcs[tmpc].hp<chars_mobs_npcs[tmpc].hp_max*0.9 and chars_mobs_npcs[tmpc].hp>=chars_mobs_npcs[tmpc].hp_max*0.5 then
			love.graphics.setColor(255, 255, 0);
		elseif chars_mobs_npcs[tmpc].hp<chars_mobs_npcs[tmpc].hp_max*0.5 and chars_mobs_npcs[tmpc].hp>=chars_mobs_npcs[tmpc].hp_max*0.9 then
			love.graphics.setColor(255, 125, 0);
		elseif chars_mobs_npcs[tmpc].hp<chars_mobs_npcs[tmpc].hp_max*0.5 and chars_mobs_npcs[tmpc].hp>chars_mobs_npcs[tmpc].hp_max*0.9 then
			love.graphics.setColor(255, 125, 0);
		elseif chars_mobs_npcs[tmpc].hp<=chars_mobs_npcs[tmpc].hp_max*0.9 and chars_mobs_npcs[tmpc].hp>0 then
			love.graphics.setColor(255, 0, 0);
		elseif chars_mobs_npcs[tmpc].hp<=0 then
			love.graphics.setColor(0, 0, 0);
		end;
		local str_hp = "(" .. chars_mobs_npcs[tmpc].hp .. ")";
		love.graphics.print(str_hp, mX+200,mY+50);
		
		love.graphics.setColor(0, 0, 255) ;
		local str_sp = "(" .. chars_mobs_npcs[tmpc].sp .. ")";
		love.graphics.print(str_sp, mX+200,mY+65);
		
		love.graphics.setColor(125, 125, 125);
		local str_st = "(" .. chars_mobs_npcs[tmpc].st .. ")";
		love.graphics.print(str_st, mX+200,mY+80);
		
		local str_rt = "(" .. chars_mobs_npcs[tmpc].rt .. ")";
		love.graphics.print(str_rt, mX+200,mY+95);
		
		love.graphics.setColor(0, 0, 0) ;
	end;
	addx=115;
	addx2=215;
	
	local torez = {"tofire","tocold","tostatic","toacid","topoison","todisease","tomind","tospirit","tolight","todarkness"};
	--local rezs = {"rezfire","rezcold","rezstatic","rezacid","rezpoison","rezdisease","rezmind","rezspirit","rezlight","rezdarkness"};
		if chars_mobs_npcs[current_mob].lvl_monsterid >= 2 then
		love.graphics.print(types_of_damage.rezists, mX+addx,mY+125);
		for i=1,10 do
			local rez = helpers.resistsFromIDSkill(chars_mobs_npcs[current_mob].lvl_monsterid,chars_mobs_npcs[tmpc][rezs[i]])
			love.graphics.print(types_of_damage[torez[i]], mX+addx,mY+125+15*i);
			love.graphics.print(rez, mX+addx2-10,mY+125+15*i);
		end;
	end;
	addx=5;
	addx2=100;
	
	if chars_mobs_npcs[current_mob].lvl_monsterid >= 2 then
		love.graphics.print(types_of_damage.stats, mX+addx,mY+125);
		love.graphics.print(lognames.stats.mgt, mX+addx,mY+140);
		love.graphics.print(chars_mobs_npcs[tmpc].mgt, mX+addx2,mY+140);
		love.graphics.print(lognames.stats.enu, mX+addx,mY+155);
		love.graphics.print(chars_mobs_npcs[tmpc].enu, mX+addx2,mY+155);
		love.graphics.print(lognames.stats.dex, mX+addx,mY+170);
		love.graphics.print(chars_mobs_npcs[tmpc].dex, mX+addx2,mY+170);
		love.graphics.print(lognames.stats.spd, mX+addx,mY+185);
		love.graphics.print(chars_mobs_npcs[tmpc].spd, mX+addx2,mY+185);
		love.graphics.print(lognames.stats.acu, mX+addx,mY+200);
		love.graphics.print(chars_mobs_npcs[tmpc].acu, mX+addx2,mY+200);
		love.graphics.print(lognames.stats.sns, mX+addx,mY+215);
		love.graphics.print(chars_mobs_npcs[tmpc].sns, mX+addx2,mY+215);
		love.graphics.print(lognames.stats.int, mX+addx,mY+230);
		love.graphics.print(chars_mobs_npcs[tmpc].int, mX+addx2,mY+230);
		love.graphics.print(lognames.stats.spr, mX+addx,mY+245);
		love.graphics.print(chars_mobs_npcs[tmpc].spr, mX+addx2,mY+245);
		love.graphics.print(lognames.stats.chr, mX+addx,mY+260);
		love.graphics.print(chars_mobs_npcs[tmpc].chr, mX+addx2,mY+260);
		love.graphics.print(lognames.stats.luk, mX+addx,mY+275);
		love.graphics.print(chars_mobs_npcs[tmpc].luk, mX+addx2,mY+275);
	end;
	
	if chars_mobs_npcs[current_mob].lvl_monsterid >= 2 then
		local protection = helpers.countProtection (tmpc);
		local ac = lognames.zones["total"] .. " " .. protection[1] .. ":" .. 	protection[4] .. "-" .. protection[7] .. ":" .. protection[10] .. "-" .. protection[13];
		local dt = lognames.zones["total"] .. " " .. protection[2] .. ":" .. 	protection[5] .. "-" .. protection[8] .. ":" .. protection[11] .. "-" .. protection[14];
		local dr = lognames.zones["total"] .. " " .. protection[3] .. ":" .. 	protection[6] .. "-" .. protection[9] .. ":" .. protection[12] .. "-" .. protection[15];
		love.graphics.print(lognames.stats.ac, mX+addx,mY+290);
		love.graphics.print(ac, mX+addx2,mY+290);
		love.graphics.print(lognames.stats.dt, mX+addx,mY+305);
		love.graphics.print(dt, mX+addx2,mY+305);
		love.graphics.print(lognames.stats.dr, mX+addx,mY+320);
		love.graphics.print(dr, mX+addx2,mY+320);
		love.graphics.print(lognames.protectionmodes.protectionmode, mX+addx,mY+335);
		love.graphics.print(lognames.protectionmodes[chars_mobs_npcs[tmpc].protectionmode], mX+100,mY+335);
	end;
	
	if chars_mobs_npcs[current_mob].lvl_monsterid == 5 then
		local str = chars_mobs_npcs[tmpc].ai;
			if chars_mobs_npcs[tmpc].battleai then
			str = str .. "/" .. chars_mobs_npcs[tmpc].battleai;
		end;
		love.graphics.print(lognames.actions.behavior, mX+addx,mY+350);
		love.graphics.print(str, mX+addx2,mY+350);
	end;

	local addy3 = 0;
	for i=1,#skills do
		local  numskill = "num_" .. skills[i];
		local  lvlskill = "lvl_" .. skills[i];
		if chars_mobs_npcs[current_mob].lvl_monsterid >= 3 and chars_mobs_npcs[tmpc][numskill] > 1 then
			local printskill =  lognames["skills"][skills[i]] .. ":";
			local printlvl = skilllevelnames[chars_mobs_npcs[tmpc][lvlskill]];
			love.graphics.print(printskill, mX+addx+w,mY+10 + addy3*15);
			love.graphics.print(printlvl, mX+addx2+w+50,mY+10 + addy3*15);
			addy3 = addy3 + 1;
		end;
	end;
	if chars_mobs_npcs[current_mob].lvl_monsterid >= 4 and chars_mobs_npcs[tmpc].spellnames and #chars_mobs_npcs[tmpc].spellnames > 0 then
		for i=1, #chars_mobs_npcs[tmpc].spellnames do
			local spellid = chars_mobs_npcs[tmpc]["spellnames"][i];
			local spell = magic.spell_tips[spellid].title;
			love.graphics.print(spell, mX+w,mY+150 + i*15);
		end;
	end;
	local slots = {"teeth","rh","lh","horns","tail","ranged","ammo","armor"};
	local addy3 = 0;
	if chars_mobs_npcs[current_mob].lvl_monsterid >= 5 then
		for i=1, #slots do
			local slot = chars_mobs_npcs[tmpc]["equipment"][slots[i]];
			if slot > 0 then
				local tmp = chars_mobs_npcs[tmpc]["inventory_list"][slot].ttxid;
				local title = inventory_ttx[tmp].title;
				love.graphics.print(title, mX+w,mY+300 + addy3*15);
				addy3 = addy3 + 1;
			end;
		end;
	end;
	local addy3 = 0;
	if chars_mobs_npcs[current_mob].lvl_monsterid >= 4 then --FIXME add positive powers too for lv 5
		love.graphics.setColor(255, 0, 0);
		if chars_mobs_npcs[tmpc].freeze > 0 then
			local string = tips_conditions.freeze;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].stone > 0 then
			local string = tips_conditions.stone;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].paralyze > 0 then
			local string = tips_conditions.paralyze;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].stun > 0 then
			local string = tips_conditions.stun;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].enslave > 0 then
			local string = tips_conditions.enslave;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].berserk > 0 then
			local string = tips_conditions.berserk;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].berserk > 0 then
			local string = tips_conditions.berserk;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].charm > 0 then
			local string = tips_conditions.charm;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].insane > 0 then
			local string = tips_conditions.insane;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].immobilize > 0 then
			local string = tips_conditions.immobilize;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].drunk > 0 then
			local string = tips_conditions.drunk;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].curse > 0 then
			local string = tips_conditions.curse;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].fate > 0 then
			local string = tips_conditions.fate;
			love.graphics.print(string, 600,300 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].fear > 0 then
			local string = tips_conditions.fear;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].panic > 0 then
			local string = tips_conditions.panic;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].silence > 0 then
			local string = tips_conditions.silence;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].madness > 0 then
			local string = tips_conditions.mad;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].filth_dur > 0 then
			local string = tips_conditions.filth;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].darkgasp > 0 then
			local string = tips_conditions.darkgasp;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].despondency_dur > 0 then
			local string = tips_conditions.despondency;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].blind_dur > 0 then
			local string = tips_conditions.blind;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].flame_dur > 0 then
			local string = tips_conditions.flame;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].poison_dur > 0 then
			local string = tips_conditions.poison;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].cold_dur > 0 then
			local string = tips_conditions.cold;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].acid_dur > 0 then
			local string = tips_conditions.acid;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].bleeding > 0 then
			local string = tips_conditions.bleeding;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].disease > 0 then
			local string = tips_conditions.disease;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;
		if chars_mobs_npcs[tmpc].pneumothorax > 0 or chars_mobs_npcs[tmpc].rh == 0 or chars_mobs_npcs[tmpc].lh == 0 or chars_mobs_npcs[tmpc].rf == 0 or chars_mobs_npcs[tmpc].lf == 0 or chars_mobs_npcs[tmpc].reye == 0 or chars_mobs_npcs[tmpc].leye == 0 then
			local string = tips_conditions.traumed;
			love.graphics.print(string, mX+w+addx2,mY+150 + addy3*15);
			addy3 = addy3 + 1;
		end;

	end;
	--love.graphics.print(lognames.stats.atkm, mX+addx,mY+335);
	--love.graphics.print(chars_mobs_npcs[tmpc].atkm, mX+addx2,mY+335);
	--love.graphics.print(lognames.stats.dmg, mX+addx,mY+350);
	--love.graphics.print(chars_mobs_npcs[tmpc].amel .. "d" .. chars_mobs_npcs[tmpc].bmel .. "+" .. chars_mobs_npcs[tmpc].cmel, mX+50,mY+350);
end;

function draw.spellbooktips ()
	loveframes.util.RemoveAll();
	love.graphics.draw(media.images.ui, tip,mX,mY);
	love.graphics.setColor(0, 0, 0);
	love.graphics.setFont(statFont);
	love.graphics.print(magic.spell_tips[missle_type].title, mX+70-#magic.spell_tips[missle_type].title,mY+10);
	spell_pretip = "magic.spell_tips." .. missle_type;
	spell_tip = loadstring("return " .. spell_pretip)();
	local text = loveframes.Create("text");
	text:SetPos(mX+10, mY+30);
	text:SetMaxWidth(230);
	text:SetFont(tipFont);
	text:SetText(spell_tip.story);
	love.graphics.setFont(tipFont);
	if spell_tip.eff == "dmg" then
		love.graphics.print(tips_titles.dmg, mX+10,mY+120);
	elseif spell_tip.eff == "eff" then
		love.graphics.print(tips_titles.eff, mX+10,mY+120);
	elseif spell_tip.eff == "radius" then
		love.graphics.print(tips_titles.radius, mX+10,mY+120);
	elseif spell_tip.eff2 == "dur" then
		love.graphics.print(tips_titles.dur, mX+10,mY+120);
	elseif spell_tip.eff2 == "imunity" then
		love.graphics.print(tips_titles.immunity, mX+10,mY+120);
	end;
	love.graphics.print(skilllevelnames[1] .. ":", mX+10,mY+130);
	love.graphics.print(skilllevelnames[2] .. ":", mX+10,mY+140);
	love.graphics.print(skilllevelnames[3] .. ":", mX+10,mY+150);
	love.graphics.print(skilllevelnames[4] .. ":", mX+10,mY+160);
	love.graphics.print(skilllevelnames[5] .. ":", mX+10,mY+170);  
	love.graphics.print(spell_tip.dmg1, mX+70,mY+130);
	love.graphics.print(spell_tip.dmg2, mX+70,mY+140);
	love.graphics.print(spell_tip.dmg3, mX+70,mY+150);
	love.graphics.print(spell_tip.dmg4, mX+70,mY+160);
	love.graphics.print(spell_tip.dmg5, mX+70,mY+170);
	if spell_tip.eff2 ~= "" then
		if spell_tip.eff2 == "add" then
			love.graphics.print(tips_titles.add, mX+10,mY+190);
		elseif spell_tip.eff2 == "dmg" then
			love.graphics.print(tips_titles.dmg, mX+10,mY+190);
		elseif spell_tip.eff2 == "dur" then
			love.graphics.print(tips_titles.dur, mX+10,mY+190);
		elseif spell_tip.eff2 == "immunity" then
			love.graphics.print(tips_titles.immunity, mX+10,mY+190);
		elseif spell_tip.eff2 == "radius" then
			love.graphics.print(tips_titles.radius, mX+10,mY+190);
		elseif spell_tip.eff2 == "eff" then
			love.graphics.print(tips_titles.eff, mX+10,mY+190);
		end;
		love.graphics.print(skilllevelnames[1] .. ":", mX+10,mY+200);
		love.graphics.print(skilllevelnames[2] .. ":", mX+10,mY+210);
		love.graphics.print(skilllevelnames[3] .. ":", mX+10,mY+220);
		love.graphics.print(skilllevelnames[4] .. ":", mX+10,mY+230);
		love.graphics.print(skilllevelnames[5] .. ":", mX+10,mY+240);
		love.graphics.print(spell_tip.add1, mX+70,mY+200);
		love.graphics.print(spell_tip.add2, mX+70,mY+210);
		love.graphics.print(spell_tip.add3, mX+70,mY+220);
		love.graphics.print(spell_tip.add4, mX+70,mY+230);
		love.graphics.print(spell_tip.add5, mX+70,mY+240); 
	end;
	if spell_tip.eff3 ~= "" then
		if spell_tip.eff3 == "add" then
			love.graphics.print(tips_titles.add, mX+10,mY+260);
		elseif spell_tip.eff3 == "dmg" then
			love.graphics.print(tips_titles.dmg, mX+10,mY+260);
		elseif spell_tip.eff3 == "dur" then
			love.graphics.print(tips_titles.dur, mX+10,mY+260);
		elseif spell_tip.eff3 == "immunity" then
			love.graphics.print(tips_titles.immunity, mX+10,mY+260);
		elseif spell_tip.eff3 == "radius" then
			love.graphics.print(tips_titles.radius, mX+10,mY+260);
		elseif spell_tip.eff3 == "eff" then
			love.graphics.print(tips_titles.eff, mX+10,mY+260);
		end;
		love.graphics.print(skilllevelnames[1] .. ":", mX+10,mY+270);
		love.graphics.print(skilllevelnames[2] .. ":", mX+10,mY+280);
		love.graphics.print(skilllevelnames[3] .. ":", mX+10,mY+290);
		love.graphics.print(skilllevelnames[4] .. ":", mX+10,mY+300);
		love.graphics.print(skilllevelnames[5] .. ":", mX+10,mY+310); 
		love.graphics.print(spell_tip.add6, mX+70,mY+270);
		love.graphics.print(spell_tip.add7, mX+70,mY+280);
		love.graphics.print(spell_tip.add8, mX+70,mY+290);
		love.graphics.print(spell_tip.add9, mX+70,mY+300);
		love.graphics.print(spell_tip.add10, mX+70,mY+310);
	end;
	love.graphics.setFont(statFont);
	love.graphics.print(tips_titles.recovery, mX+10,mY+320);
	love.graphics.print(tips_titles.mana, mX+10,mY+335);
	love.graphics.print(spell_tip.recovery, mX+100,mY+320);
	love.graphics.print(spell_tip.mana, mX+100,mY+335);
end;

function draw.warbooktips ()
	loveframes.util.RemoveAll();
	love.graphics.draw(media.images.ui, tip,mX,mY);
	love.graphics.setColor(0, 0, 0);
	love.graphics.setFont(statFont);
	love.graphics.print(tricks.tricks_tips[missle_type].title, mX+70-#tricks.tricks_tips[missle_type].title,mY+10);
	spell_pretip = "tricks.tricks_tips." .. missle_type;
	trick_tip = loadstring("return " .. spell_pretip)();
	local text = loveframes.Create("text");
	text:SetPos(mX+10, mY+30);
	text:SetMaxWidth(230);
	text:SetFont(tipFont);
	text:SetText(trick_tip.story);
	love.graphics.setFont(tipFont);
	if trick_tip.eff == "dmg" then
		love.graphics.print(tips_titles.dmg, mX+10,mY+120);
	elseif trick_tip.eff == "eff" then
		love.graphics.print(tips_titles.eff, mX+10,mY+120);
	elseif trick_tip.eff == "radius" then
		love.graphics.print(tips_titles.radius, mX+10,mY+120);
	elseif trick_tip.eff2 == "dur" then
		love.graphics.print(tips_titles.dur, mX+10,mY+120);
	elseif trick_tip.eff2 == "imunity" then
		love.graphics.print(tips_titles.immunity, mX+10,mY+120);
	end;
	love.graphics.print(skilllevelnames[1] .. ":", mX+10,mY+130);
	love.graphics.print(skilllevelnames[2] .. ":", mX+10,mY+140);
	love.graphics.print(skilllevelnames[3] .. ":", mX+10,mY+150);
	love.graphics.print(skilllevelnames[4] .. ":", mX+10,mY+160);
	love.graphics.print(skilllevelnames[5] .. ":", mX+10,mY+170);  
	love.graphics.print(trick_tip.dmg1, mX+70,mY+130);
	love.graphics.print(trick_tip.dmg2, mX+70,mY+140);
	love.graphics.print(trick_tip.dmg3, mX+70,mY+150);
	love.graphics.print(trick_tip.dmg4, mX+70,mY+160);
	love.graphics.print(trick_tip.dmg5, mX+70,mY+170);
	if trick_tip.eff2 ~= "" then
		if trick_tip.eff2 == "add" then
			love.graphics.print(tips_titles.add, mX+10,mY+190);
		elseif trick_tip.eff2 == "dmg" then
			love.graphics.print(tips_titles.dmg, mX+10,mY+190);
		elseif trick_tip.eff2 == "dur" then
			love.graphics.print(tips_titles.dur, mX+10,mY+190);
		elseif trick_tip.eff2 == "immunity" then
			love.graphics.print(tips_titles.immunity, mX+10,mY+190);
		elseif trick_tip.eff2 == "radius" then
			love.graphics.print(tips_titles.radius, mX+10,mY+190);
		elseif trick_tip.eff2 == "eff" then
			love.graphics.print(tips_titles.eff, mX+10,mY+190);
		end;
		love.graphics.print(skilllevelnames[1] .. ":", mX+10,mY+200);
		love.graphics.print(skilllevelnames[2] .. ":", mX+10,mY+210);
		love.graphics.print(skilllevelnames[3] .. ":", mX+10,mY+220);
		love.graphics.print(skilllevelnames[4] .. ":", mX+10,mY+230);
		love.graphics.print(skilllevelnames[5] .. ":", mX+10,mY+240);
		love.graphics.print(trick_tip.add1, mX+70,mY+200);
		love.graphics.print(trick_tip.add2, mX+70,mY+210);
		love.graphics.print(trick_tip.add3, mX+70,mY+220);
		love.graphics.print(trick_tip.add4, mX+70,mY+230);
		love.graphics.print(trick_tip.add5, mX+70,mY+240); 
	end;
	if trick_tip.eff3 ~= "" then
		if trick_tip.eff3 == "add" then
			love.graphics.print(tips_titles.add, mX+10,mY+260);
		elseif trick_tip.eff3 == "dmg" then
			love.graphics.print(tips_titles.dmg, mX+10,mY+260);
		elseif trick_tip.eff3 == "dur" then
			love.graphics.print(tips_titles.dur, mX+10,mY+260);
		elseif trick_tip.eff3 == "immunity" then
			love.graphics.print(tips_titles.immunity, mX+10,mY+260);
		elseif trick_tip.eff3 == "radius" then
			love.graphics.print(tips_titles.radius, mX+10,mY+260);
		elseif trick_tip.eff3 == "eff" then
			love.graphics.print(tips_titles.eff, mX+10,mY+260);
		end;
		love.graphics.print(skilllevelnames[1] .. ":", mX+10,mY+270);
		love.graphics.print(skilllevelnames[2] .. ":", mX+10,mY+280);
		love.graphics.print(skilllevelnames[3] .. ":", mX+10,mY+290);
		love.graphics.print(skilllevelnames[4] .. ":", mX+10,mY+300);
		love.graphics.print(skilllevelnames[5] .. ":", mX+10,mY+310); 
		love.graphics.print(trick_tip.add6, mX+70,mY+270);
		love.graphics.print(trick_tip.add7, mX+70,mY+280);
		love.graphics.print(trick_tip.add8, mX+70,mY+290);
		love.graphics.print(trick_tip.add9, mX+70,mY+300);
		love.graphics.print(trick_tip.add10, mX+70,mY+310);
	end;
	love.graphics.setFont(statFont);
	love.graphics.print(tips_titles.recovery, mX+10,mY+320);
	love.graphics.print(tips_titles.stamina, mX+10,mY+335);
	love.graphics.print(trick_tip.recovery, mX+100,mY+320);
	love.graphics.print(trick_tip.stamina, mX+100,mY+335);
end;

function draw.inventorytips ()
	helpers.inv_tips_add();
	loveframes.util.RemoveAll();
	love.graphics.draw(media.images.ui, tip,mX,mY);
	love.graphics.setColor(0, 0, 0);
	love.graphics.setFont(statFont);
	love.graphics.print(tip_title, mX,mY+10);
	love.graphics.print(tip_mod, mX+100-#tip_mod,mY+20);
	local text = loveframes.Create("text");
	text:SetPos(mX+10, mY+40);
	text:SetMaxWidth(230);
	text:SetFont(tipFont);
	text:SetText(tip_story);
	if tip_class ~= "gold" then
		love.graphics.print(tips_titles.skill, mX+10,mY+200);
	end;
	if tip_class == "book" then
		love.graphics.print(tip_author, mX+10+#tip_author/2,mY+25);
	end;
	if tip_class ~= "spellbook" and tip_class ~= "gold" then
		love.graphics.print(tip_titleskill, mX+70,mY+200);
		love.graphics.print(tips_titles.subclass, mX+10,mY+220);
		love.graphics.print(tip_subclasstitle, mX+70,mY+220);
	end;
	if tip_class == "scroll" then
		love.graphics.print(tip_titleskill, mX+70,mY+200);
		--love.graphics.print(tip_classtitle, mX+70,mY+240);
	end;
	if tip_class == "spellbook" then
		love.graphics.setFont(tipFont);
		love.graphics.print(tips_titles.spellbookcontains , mX+10,mY+80)
		local tmp=typo[1] .. magic.spell_tips[tmpinv3].title .. typo[2]
		love.graphics.setFont(statFont);
		love.graphics.print(tmp, mX+45,mY+100)
		love.graphics.setFont(tipFont);
		love.graphics.print(tips_titles.fromschool, mX+60,mY+120)
		love.graphics.print(tip_schools[magic.spell_tips[tmpinv3].school], mX+125,mY+120)
		love.graphics.setFont(statFont);
		for i=1,chars do
			local tmpskill = magic.spell_tips[tmpinv3].skill[i];
			local tmpskill2 = magic_tips_skills[tmpskill];
			local tmpskill3 = magic.spell_tips[tmpinv3].level[i];
			local tmplv = level_letter[tmpskill3];
			if tmpskill ~= "none" then
				tips_skills = tmpskill2 .. " (" .. tmplv .. ")";
				love.graphics.print(tips_skills, mX+70,mY+180+i*20);
			end;
		end;
	end;   
	if tip_class == "sword" or tip_class == "axe" or tip_class == "flagpole" or tip_class == "crushing" or
	tip_class == "staff" or tip_class == "dagger" or tip_class == "bow" or tip_class == "crossbow" or
	tip_class == "throwing" or tip_class == "firearm" or tip_class == "ammo" then
		love.graphics.print(tips_titles.dmg, mX+10,mY+260);
		love.graphics.print(tip_formula, mX+70,mY+260);
		love.graphics.print(tips_titles.atk, mX+10,mY+280);
		love.graphics.print(tip_atk, mX+70,mY+280);
		if tip_effect ~= "" then
			love.graphics.print(tips_titles.modificator, mX+10,mY+300);
			love.graphics.print(tip_effect, mX+50,mY+300);
		end;
		if  tip_class	~= "ammo" and tip_class ~= "throwing" then
			love.graphics.print(tips_titles.condition, mX+10,mY+320);
			love.graphics.print(tip_condition, mX+100,mY+320);
			love.graphics.print("/", mX+120,mY+320);
			love.graphics.print(tip_material, mX+130,mY+320);
		end;
	elseif tip_class == "armor" or tip_class == "helm" or tip_class == "crown" or tip_class == "hat" or
	tip_class == "boots" or tip_class == "cloak" or tip_class == "belt" or tip_class == "gloves" then
		love.graphics.print(tips_titles.ac, mX+10,mY+240);
		love.graphics.print(tip_ac, mX+120,mY+240);
		
		love.graphics.print(tips_titles.dt, mX+10,mY+260);
		love.graphics.print(tip_dt, mX+120,mY+260);
		
		love.graphics.print(tips_titles.dr, mX+10,mY+280);
		love.graphics.print(tip_dr, mX+120,mY+280);
		
		love.graphics.print(tips_titles.condition, mX+10,mY+320);
		love.graphics.print(tip_condition, mX+100,mY+320);
		love.graphics.print("/", mX+120,mY+320);
		love.graphics.print(tip_material, mX+130,mY+320);
	elseif tip_class == "shield" then
		love.graphics.print(tips_titles.block, mX+10,mY+280);
		love.graphics.print(tip_block, mX+70,mY+280);
		love.graphics.print(tips_titles.condition, mX+10,mY+320);
		love.graphics.print(tip_condition, mX+100,mY+320);
		love.graphics.print("/", mX+120,mY+320);
		love.graphics.print(tip_material, mX+130,mY+320);
	end;
	if tip_class == "ammo" or tip_class == "throwing" then
		love.graphics.print(tips_titles.quantity .. " ", mX+10,mY+300);
		love.graphics.print(tip_quantity, mX+100,mY+300);
	end;
	if tip_class == "wand" then
		love.graphics.print(tips_titles.spell .. " ", mX+10,mY+180);
		love.graphics.print(tip_spell, mX+100,mY+180);
		love.graphics.print(tips_titles.charges .. " ", mX+10,mY+300);
		love.graphics.print(tip_quantity, mX+100,mY+300);
	end;
	if tip_class == "potion" then
		love.graphics.print(tips_titles.power .. " ", mX+10,mY+300);
		love.graphics.print(tip_quantity, mX+100,mY+300);
	end;
	if tip_class == "component" then
		love.graphics.print(tips_titles.power .. " ", mX+10,mY+300);
		love.graphics.print(tip_quantity, mX+100,mY+300);
	end;
    if tip_class ~= "gold" and tip_class ~= "message"  and tip_class ~= "letter" and tip_class ~= "map" then
		love.graphics.print(tips_titles.price, mX+10,mY+340);
		love.graphics.print(tip_price, mX+70,mY+340);
		if tips_titles.price ~= lognames.actions.unknown then
			love.graphics.print(lognames.actions.withgold,mX+150,mY+340);
		end;
		love.graphics.setFont(mainFont); 
	end;
	if tip_class == "gold" then
		love.graphics.print(tips_titles.quantity .. " ", mX+10,mY+300);
		love.graphics.print(tip_quantity, mX+100,mY+300);
	end;
	love.graphics.print(tip_hardened, mX+10,mY+360);
    love.graphics.setColor(255, 255, 255);
end;

function draw.ui ()
	love.graphics.setColor(255, 255, 255);
	local bottom_hud_tiles = math.floor(global.screenWidth - media.images.hud_bottom_left:getWidth()*2)/media.images.hud_bottom_tile:getWidth()+1;
	for i=1,bottom_hud_tiles do
		love.graphics.draw(media.images.hud_bottom_tile, media.images.hud_bottom_left:getWidth()+(i-1)*media.images.hud_bottom_tile:getWidth(),global.screenHeight - media.images.hud_bottom_tile:getHeight());
	end;
	local top_hud_tiles = math.floor(global.screenWidth/media.images.hud_top_tile:getWidth())+1;
	for i=1,top_hud_tiles do
		love.graphics.draw(media.images.hud_top_tile, (i-1)*media.images.hud_top_tile:getWidth(),0);
	end;
	local side_hud_tiles = math.floor(global.screenHeight/media.images.hud_left_tile:getWidth())+1;
	for i=1,side_hud_tiles do
		love.graphics.draw(media.images.hud_left_tile, 0,(i-1)*media.images.hud_left_tile:getHeight());
		love.graphics.draw(media.images.hud_right_tile, global.screenWidth-media.images.hud_right_tile:getWidth(),(i-1)*media.images.hud_right_tile:getHeight());
	end;
	love.graphics.draw(media.images.hud_bottom_left, 0,global.screenHeight - media.images.hud_bottom_left:getHeight());
	love.graphics.draw(media.images.hud_bottom_right, global.screenWidth - media.images.hud_bottom_right:getWidth() ,global.screenHeight - media.images.hud_bottom_right:getHeight());
	love.graphics.draw(media.images.hud_top_center, global.screenWidth/2 - media.images.hud_top_center:getWidth()/2 ,0);
	love.graphics.draw(media.images.hud_top_left, 0,0);
	love.graphics.draw(media.images.hud_top_right, global.screenWidth - media.images.hud_top_right:getWidth() ,0);
	local screen_mod_x = 0;
	local screen_mod_y = global.screenHeight - 110; --850
	for i=1,chars do --indicators and portraits
		local delta_hp = math.max(chars_mobs_npcs[i].hp/chars_mobs_npcs[i].hp_max,0);
		local delta_sp = math.max(chars_mobs_npcs[i].sp/chars_mobs_npcs[i].sp_max,0);
		local delta_st = math.max(chars_mobs_npcs[i].st/chars_mobs_npcs[i].st_max,0);
		local delta_rt = math.max(chars_mobs_npcs[i].rt/200,0);
		
		local delta_ps = math.max(chars_mobs_npcs[i].poison_status/chars_mobs_npcs[i].hp_max,0);
		
		local delta_sp2spend = 0;
		local delta_st2spend = 0;
		local delta_rt2spend = 0;
		
		local dhp = screen_mod_y-100*(delta_hp-1);
		local dsp = screen_mod_y-100*(delta_sp-1);
		local dst = screen_mod_y-100*(delta_st-1);
		local drt = screen_mod_y-100*(delta_rt-1);
		
		local dps = screen_mod_y-100*(delta_ps-1);
		
		local dsp2s = 0;
		local dst2s = 0;
		local drt2s = 0;
		
		local add_effect_st = 0;
		local add_effect_rt = 0;
		
		local addx = 10; --125 for six in party!
		if i == current_mob and chars_mobs_npcs[current_mob].control == "player" then
			--if missle_effect ~= "none" then
				--add_effect_st = hold_tips[missle_effect].stamina;			
			--end;
			
			if missle_drive == "muscles" and helpers.missleAtWarBook() then
				delta_st2spend = delta_st2spend + price_in_st/chars_mobs_npcs[i].st_max;
				add_effect_st = delta_st2spend;
				delta_rt2spend = delta_rt2spend + price_in_rt/200;
				add_effect_rt = delta_rt2spend;
			end;
			
			if game_status == "path_finding" then
				delta_rt2spend = math.max(#way_of_the_mob*5/200,0);
				delta_st2spend = math.max(#way_of_the_mob*5/chars_mobs_npcs[i].st_max,0);
				if helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
					local recovery = 0;
					recovery = helpers.countMeleeRecoveryChar (current_mob) + helpers.countPathPrice(current_mob) + add_effect_st;
					delta_st2spend = delta_st2spend + recovery/chars_mobs_npcs[i].st_max;
					delta_rt2spend = delta_rt2spend + recovery/200;
				end;
				dst2s = screen_mod_y-100*(delta_st2spend-1);
				drt2s = screen_mod_y-100*(delta_rt2spend-1);
			elseif game_status == "sensing" then
				if helpers.cursorAtMob (cursor_world_x,cursor_world_y) then
					local recovery = 0;
					if missle_type == "arrow" or missle_type == "bolt" or missle_type == "throwing" or missle_type == "bullet" or missle_type == "battery" 
					or (missle_drive == "muscles" and  helpers.missleAtWarBook() and tricks.tricks_tips[missle_type].form == "range" and (tricks.tricks_tips[missle_type].skill == "bow" or tricks.tricks_tips[missle_type].skill == "crossbow"))
					or (missle_drive == "muscles" and  helpers.missleAtWarBook() and tricks.tricks_tips[missle_type].form == "range" and tricks.tricks_tips[missle_type].skill == "throwing")
					then
						recovery = helpers.countRangeRecoveryChar (current_mob);
						delta_st2spend = delta_st2spend + recovery/chars_mobs_npcs[i].st_max + add_effect_st;
						delta_rt2spend = delta_rt2spend + add_effect_rt;
					end;
					if missle_type == "bottle" then
						recovery = helpers.countBottleRecovery (current_mob);
						delta_st2spend = delta_st2spend + recovery/chars_mobs_npcs[i].st_max;
					end;
					if missle_drive == "spellbook" or missle_drive == "wand" or missle_drive == "scroll" then
						recovery = helpers.countMagicRecovery (current_mob,missle_type,missle_drive);
					end;
					delta_rt2spend = delta_rt2spend + recovery/200;
					dst2s = screen_mod_y-100*(delta_st2spend-1);
					drt2s = screen_mod_y-100*(delta_rt2spend-1);
				end;
				if missle_drive == "spellbook" then
					delta_sp2spend = delta_st2spend + price_in_mana/chars_mobs_npcs[i].sp_max;
					if missle_type == "incineration" or missle_type == "dehydratation" then
						delta_sp2spend = 1;
					end;
					dsp2s = screen_mod_y-100*(delta_sp2spend-1);
				end;
			end;
		end;
		
		delta_sp2spend = math.min(delta_sp2spend,chars_mobs_npcs[i].sp_max);
		delta_st2spend = math.min(delta_st2spend,chars_mobs_npcs[i].st_max);
		delta_rt2spend = math.min(delta_rt2spend,200);
		
		love.graphics.draw(media.images.ui, bl_indic, i*125-addx, screen_mod_y,0, 1, 1);
		love.graphics.draw(media.images.ui, bl_indic, i*125+10-addx, screen_mod_y,0, 1, 1);
		love.graphics.draw(media.images.ui, bl_indic, i*125+20-addx, screen_mod_y,0, 1, 1);
		love.graphics.draw(media.images.ui, bl_indic, i*125+30-addx, screen_mod_y,0, 1, 1);
		love.graphics.draw(media.images.ui, hp_indic, i*125-addx, dhp,0, 1, delta_hp);
		love.graphics.draw(media.images.ui, sp_indic, i*125-addx+10, dsp,0, 1, delta_sp);
		love.graphics.draw(media.images.ui, st_indic, i*125-addx+20, dst,0, 1, delta_st);
		love.graphics.draw(media.images.ui, rt_indic, i*125+30-addx, drt,0, 1, delta_rt);
		
		love.graphics.draw(media.images.ui, ps_indic, i*125-addx, dps,0, 1, delta_ps);
		
		love.graphics.draw(media.images.ui, wt_indic, i*125+10-addx, dsp2s,0, 1, delta_sp2spend);
		love.graphics.draw(media.images.ui, wt_indic, i*125+20-addx, dst2s,0, 1, delta_st2spend);
		love.graphics.draw(media.images.ui, wt_indic, i*125+30-addx, drt2s,0, 1, delta_rt2spend);
		
		if chars_mobs_npcs[i].status == 1 then
			love.graphics.draw(media.images.charfaces, charfaces[chars_stats[i].face], i*125-85-addx, screen_mod_y)
		elseif chars_mobs_npcs[i].status == 0 then
			love.graphics.setColor(125, 125, 125);
			love.graphics.draw(media.images.charfaces, charfaces[chars_stats[i].face], i*125-85-addx, screen_mod_y);
			love.graphics.setColor(255, 255, 255);
		elseif chars_mobs_npcs[i].status == -1 then
			love.graphics.draw(media.images.mobfaces, mobfaces[6], i*125-85, screen_mod_y);
		end;
		love.graphics.print(chars_stats[i].name, i*125-85, screen_mod_y + 90);
	end;
	---love.graphics.draw(media.images.ui, logpaper,600,global.screenHeight-150);
	local tmp = (global.screenWidth-300)/2;
	love.graphics.draw(media.images.ui, logpaper, math.max(600,tmp),global.screenHeight-150)
	--[[love.graphics.setFont(heroesFont);
	for i=1,#logactions do -- print game log
	   love.graphics.setColor(0, 0, 0);
	   love.graphics.print(logactions[i], math.max(610,tmp+10), global.screenHeight-150+i*10);
	   love.graphics.setColor(255, 255, 255);
	end;]]
	draw.miniLog ();
	if chars_mobs_npcs[current_mob].person=="char" and chars_mobs_npcs[current_mob].control=="player" and game_status ~= "chat" and game_status ~= "mindgame" and global.status ~= "mindgame" then
		love.graphics.draw(media.images.ui, warbook_icon, global.screenWidth-200,global.screenHeight-200); -- draw spellbook icon at HUD
		love.graphics.draw(media.images.ui, questbook_icon, global.screenWidth-330,global.screenHeight-185); -- draw questbook icon at HUD
		if game_status == "neutral" then
			love.graphics.draw(media.images.ui, glove_icon_1, 520,global.screenHeight-200);	
		else
			love.graphics.draw(media.images.ui, glove_icon_2, 520,global.screenHeight-160);	
		end;
		if game_status == "path_finding" then
			love.graphics.draw(media.images.ui, boot_icon_1, 520,global.screenHeight-140);
		else
			love.graphics.draw(media.images.ui, boot_icon_2, 520,global.screenHeight-140);
		end;
		if game_status == "sensing" then
			love.graphics.draw(media.images.ui, spyglass_icon_1, 580,global.screenHeight-155);
		else
			love.graphics.draw(media.images.ui, spyglass_icon_2, 580,global.screenHeight-155);
		end;
	end;
	if chars_mobs_npcs[current_mob].person == "char" and chars_mobs_npcs[current_mob].control == "player" and (game_status == "neutral" or game_status == "pathfinding" or game_status == "sense")  and global.status ~= "mindgame" then
		love.graphics.draw(media.images.ui, bin_icon, global.screenWidth-180, global.screenHeight-160,0);
	end;	
	if chars_mobs_npcs[current_mob].person == "char" and chars_mobs_npcs[current_mob].control == "player" and game_status ~= "chat" and chars_stats[current_mob].spellbook == 1 and (game_status == "neutral" or game_status == "pathfinding" or game_status == "sense" or game_status == "mindgame") then
		love.graphics.draw(media.images.ui, spellbook_icon, global.screenWidth-280,global.screenHeight-160); -- draw spellbook icon at HUD
	end;	
	if chars_mobs_npcs[current_mob].person == "char" and chars_mobs_npcs[current_mob].control == "player" and (game_status == "neutral" or game_status == "pathfinding" or game_status == "sense")  and global.status ~= "mindgame" then
		love.graphics.draw(media.images.ui, gnomon_icon,global.screenWidth-300,global.screenHeight-105);
    end;
    if chars_mobs_npcs[current_mob].person=="char" then
		love.graphics.draw(media.images.ui, current_char_img,chars_mobs_npcs[current_mob].id*125-70,screen_mod_y - 20);
    end;
	if chars_mobs_npcs[current_mob].person=="char" and (game_status == "neutral" or game_status == "pathfinding" or game_status == "sense" or game_status == "mindgame") then
		love.graphics.draw(media.images.ui, bag_inv,global.screenWidth-210,global.screenHeight-110);
		love.graphics.draw(media.images.ui,veksel_icon,global.screenWidth-180,global.screenHeight-90);
		local addx=0;
		local addy=0;
		local goldsum=0;
		if party.gold<10000 then
		   goldsum=4;
		   addx=global.screenWidth-77;
		   addy=global.screenHeight-45;
		elseif party.gold>=10000 and party.gold<100000 then
		   goldsum=3;
		   addx=global.screenWidth-173;
		   addy=global.screenHeight-45;
		elseif party.gold>=100000 and party.gold<1000000 then
		   goldsum=2;
		   addx=global.screenWidth-175;
		   addy=global.screenHeight-45;
		elseif party.gold>=1000000 then
		   goldsum=1;
		   addx=1053;
		   addy=895;
		   addx=global.screenWidth-227;
		   addy=global.screenHeight-65;
		end;
	   if party.gold>0 then
			love.graphics.draw(media.images.ui, gold_icons[goldsum],addx,addy);
			love.graphics.setColor(0,0,0);
			love.graphics.setFont(smallMessFont);
			love.graphics.print(party.gold,global.screenWidth-165,global.screenHeight-60,-0.15);
			love.graphics.setFont(mainFont);
			love.graphics.setColor(255,255,255);
	   end;
   end;
   if chars_mobs_npcs[current_mob].control == "player" and (game_status == "neutral" or game_status == "pathfinding" or game_status == "sense" or game_status == "mindgame") then
		love.graphics.draw(media.images.ui, pass_turn,global.screenWidth-80,global.screenHeight-160);
    end;
	if global.status == "peace"  and game_status ~= "chat" and game_status ~= "mindgame" and global.status ~= "mindgame" then
		love.graphics.draw(media.images.ui, swords_indic[1],global.screenWidth-140, global.screenHeight-220);
	elseif global.status == "battle" then
		love.graphics.draw(media.images.ui, swords_indic[2],global.screenWidth-170,global.screenHeight-220);
	end;
	love.graphics.draw(media.images.ui, system,global.screenWidth-40,global.screenHeight-45);
	if global.status == "battle"  and game_status ~= "chat" and game_status ~= "mindgame" and global.status ~= "mindgame" then
		draw.lineOfOrder();
	end;
	if chars_mobs_npcs[current_mob].person == "char" and chars_mobs_npcs[current_mob].control == "player" and (game_status == "neutral" or game_status == "pathfinding" or game_status == "sense") and global.status ~= "mindgame" then
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(media.images.ui, mask_icon, global.screenWidth-580, global.screenHeight-30,0);
		love.graphics.draw(media.images.ui, map_icon, global.screenWidth-380, global.screenHeight-150,0);
		love.graphics.draw(media.images.ui, retorta_icon, global.screenWidth-330,global.screenHeight-110);
		love.graphics.draw(media.images.ui, anvil_icon,global.screenWidth-405,global.screenHeight-75);
		love.graphics.draw(media.images.ui, picklock_icon, global.screenWidth-335, global.screenHeight-35);
	end;
	
	local distance = helpers.countDistance (chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y,cursor_world_x,cursor_world_y);
	--love.graphics.print(distance, 430, 10);
  --/text shit  
	if game_status == "literature" then
		draw.book();
	end
	if game_status == "map" then
		draw.papermap();
	end
	if game_status == "spellbook" then
		draw.spellbook ();
	end;
	if game_status == "questbook" then
		draw.questbook ();
	end;
	if game_status == "warbook" then
		draw.warbook ();
	end;
	if game_status == "stats" then
		draw.stats(tmp_mob);
	end;
	if game_status == "skills" then
		draw.skills(tmp_mob);
	end;
	if game_status == "calendar" then
		draw.calendar ();  
	end;
	if game_status == "log" then
		draw.bigLog();
	end;
	if game_status == "obelisk" then
		draw.obelisk ();
	end;
	if game_status == "well" then
		draw.well ();
	end;
	if (game_status == "inventory" or game_status == "alchemy" or game_status == "picklocking" or game_status == "crafting" or game_status == "showinventory") then
		draw.inventory_bag();
		if game_status == "inventory" then
			draw.equipment();
		elseif game_status =="alchemy" then
			draw.alchemy();
		elseif game_status == "picklocking" then
			draw.picklock ();
		elseif game_status == "crafting" then
		elseif game_status == "showinventory" then
			draw.showinventory();
		end;
		draw.hold();
	end ;
	if game_status == "housewatch" then
		draw.housewatch(current_house);
	end;
	if game_status == "buying" then
		draw.trading();
	end;
	if game_status == "chat" then
		draw.chat();
	end;
	if game_status == "mindgame" then
		draw.mindgame();
	end;
	if show_inventory_tips == 1 then 
		draw.inventorytips();
		if game_status == "buying" or game_status == "showinventory" then
			draw.tradersSpeech();
		end;
	end;
   if show_spellbook_tips == 1 then
		draw.spellbooktips();
   end;
   if show_warbook_tips == 1 then
	draw.warbooktips();
   end;
   if show_monsterid_tip == 1 then
	draw.mobtips();
   end;
   if game_status == "comic" then
		draw.comic();
   end;
   if game_status == "gameover" then
		draw.gameover();
   end;
    if game_status == "switchlevel" then
		local x,y = helpers.centerObject(media.images.map);
		love.graphics.draw(media.images.map, x,y-50);
	end;
	local _txt = cursor_world_x .. "x" .. cursor_world_y;
	love.graphics.print(_txt,50,10);
	if current_mob then
		local _txt = current_mob .. " " .. chars_mobs_npcs[current_mob].ai;
		if chars_mobs_npcs[current_mob].battleai then
			_txt = _txt .. " " .. chars_mobs_npcs[current_mob].battleai;
		else
			_txt = _txt .. " " .. "no bAI";
		end;
		love.graphics.print(_txt,250,10);
	end;
	love.graphics.print(game_status,450,10);
	--love.graphics.print(missle_type,100,10);
	--love.graphics.print(missle_drive,150,10);
end;

function draw.lineOfOrder ()
	local facecount = 1;
	for k=1,#order_of_turns do
		local pshift = 0;
		if chars_mobs_npcs[current_mob].control=="player" then
			if helpers.cursorAtMobID(cursor_world_x,cursor_world_y) == order_of_turns[k][1] and (game_status == "neutral" or game_status == "sensing" or game_status == "path_finding" or game_status == "damage" or game_status == "missle" or game_status == "boom") then
				pshift = 5;
			else
				pshift = 0;
			end
		end
		if selected_mob == order_of_turns[k][1] then
			pshift = 5;
		end
		if k <= 10 then
			if chars_mobs_npcs[order_of_turns[k][1]].person == "char" and chars_mobs_npcs[order_of_turns[k][1]].status == 1 then
				love.graphics.draw(media.images.charfaces, charfaces[chars_mobs_npcs[order_of_turns[k][1]].face], global.screenWidth/2-240+facecount*45, 2+pshift, 0, 0.50,0.5)
				facecount = facecount+1;
			elseif chars_mobs_npcs[order_of_turns[k][1]].person == "mob" and chars_mobs_npcs[order_of_turns[k][1]].status == 1 then
				love.graphics.draw(media.images.mobfaces, mobfaces[chars_mobs_npcs[order_of_turns[k][1]].face], global.screenWidth/2-240+facecount*45,  2+pshift, 0, 0.50,0.5)
				facecount = facecount+1;
			elseif chars_mobs_npcs[order_of_turns[k][1]].person == "npc" and chars_mobs_npcs[order_of_turns[k][1]].status == 1 then
				love.graphics.draw(media.images.npcfaces, npcfaces[chars_mobs_npcs[order_of_turns[k][1]].face], global.screenWidth/2-240+facecount*45,  2+pshift, 0, 0.50,0.5)
				facecount = facecount+1;
			end;
			love.graphics.draw(media.images.greenface, global.screenWidth/2-240+(facecount-1)*45, 2+pshift+(200-chars_mobs_npcs[order_of_turns[k][1]].rt)/100*22, 0, 0.50,chars_mobs_npcs[order_of_turns[k][1]].rt/400);
		end;
		-- love.graphics.print(chars_mobs_npcs[order_of_turns[k][1]][11], 400+k*45,  2)
		-- love.graphics.print(chars_mobs_npcs[order_of_turns[k][1]][24], 400+k*45,  12)
	end;
end;

function draw.picklock () --chest/door/groundtrap
	local x,y = helpers.centerObject(media.images.inv1);
	love.graphics.draw(media.images.charfaces, charfaces[chars_mobs_npcs[current_mob].face], x+390, y-20);
	love.graphics.print(chars_stats[current_mob].name, x+365+math.ceil(#chars_stats[current_mob].name/2)*10, y+75);	
	local chanceToMakePicklock = chars_mobs_npcs[current_mob].dex + math.ceil(chars_mobs_npcs[current_mob].lvl_picklocking*chars_mobs_npcs[current_mob].num_picklocking);
	love.graphics.print(lognames.actions.mkpicklocklv .. " ".. chanceToMakePicklock, x+520, y-15);
	love.graphics.print(lognames.actions.picklocklv .. " ".. chars_mobs_npcs[current_mob].lvl_picklocking*chars_mobs_npcs[current_mob].num_picklocking, x+520, y);
	love.graphics.print(lognames.actions.inspectlv .. " ".. chars_mobs_npcs[current_mob].lvl_traps*chars_mobs_npcs[current_mob].num_traps+chars_mobs_npcs[current_mob].sns, x+520, y+15);
	love.graphics.print(lognames.actions.disarmlv .. " ".. chars_mobs_npcs[current_mob].lvl_traps*chars_mobs_npcs[current_mob].num_traps+chars_mobs_npcs[current_mob].dex+chars_mobs_npcs[current_mob].luk, x+520, y+30);
	
	local _x,_y = helpers.hexInFronTOfMob(current_mob);
	local at_door,doorid,locked,traped = helpers.cursorAtClosedDoor(_x,_y);
	if at_door then
		bagid = doorid;
	end;
	local condition = false;
	if helpers.BagNear(chars_mobs_npcs[current_mob].x,chars_mobs_npcs[current_mob].y) or at_door then
		condition = true;
	end;
	if picklock[current_mob].key ~= 0 then
		tempeq1=picklock[current_mob].key;
		tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+450,y+205);
	end;
	if picklock[current_mob].picklock ~= 0 then
		tempeq1=picklock[current_mob].picklock;
		tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+400,y+205);
	end;
	if picklock[current_mob].traptool ~= 0 then
		tempeq1=picklock[current_mob].traptool;
		tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+455,y+325);
	end;
	if picklock[current_mob].forcer ~= 0 then
		tempeq1=picklock[current_mob].forcer;
		tempeq2=chars_stats[current_mob]["inventory_list"][tempeq1].ttxid;
		love.graphics.draw(media.images.items2, tiles_items[tempeq2],x+393,y+100);
	end;
	
	if condition and bags_list[bagid].locktype == 1 then
		local lockcode = {};
		local tmp = tostring(bags_list[bagid].lockcode);
		for w in string.gmatch(tmp, "%d") do
			table.insert(lockcode, 5-w);
		end;
		lockmatrix = {};
		for i=1,10 do
			lockmatrix[i] = {};
			for h=1,10 do
				lockmatrix[i][h] = 0;
			end;
		end;
		local watchlock = 1;
		--for i=1,math.min(10,chars_mobs_npcs[current_mob].lvl_picklocking*chars_mobs_npcs[current_mob].num_picklocking) do
		for i=1,10 do	
			for h=1,lockcode[i] do
				lockmatrix[i][h] = 1;
				love.graphics.draw(media.images.ui, keypart,x+525+i*17,y+200-(10-h)*14);
			end;
		end;
	end;
	
	if condition and bags_list[bagid].locktype == 2 then
		local lockcode = {};
		local tmp = tostring(bags_list[bagid].lockcode);
		for w in string.gmatch(tmp, "%d") do
			table.insert(lockcode, 5-w);
		end;
		love.graphics.draw(media.images.ui, lock_2_base,x+525,y+80);
		lockmatrix = {};
		for i=1,10 do
			if lock_elements[i] == 1 and lockcode[i] < 5 then
				if picklock[current_mob].key == 0 then
					love.graphics.draw(media.images.ui, lock_2_closed_elements[6][lockcode[i]+1],x+540+i*16,y+95);
				else
					local keycode = {};
					local tmp = tostring(chars_stats[current_mob]["inventory_list"][picklock[current_mob].key].w);
					for w in string.gmatch(tmp, "%d") do
						table.insert(keycode, w);
					end;
					if lockcode[i] == 5 - keycode[i] then
						lock_elements[i] = 0;
						love.graphics.draw(media.images.ui, lock_2_opened_elements[lockcode[i]+1],x+560+i*16,y+95);
					elseif tonumber(keycode[i]) <= 5 then
						love.graphics.draw(media.images.ui, lock_2_closed_elements[tonumber(keycode[i])][lockcode[i]+1],x+560+i*16,y+95);
						love.graphics.draw(media.images.ui, lock_2_closed_elements[tonumber(keycode[i])][lockcode[i]+1],x+560+i*16,y+95);
					end;
				end;
			elseif lockcode[i] < 5 then
				love.graphics.draw(media.images.ui, lock_2_opened_elements[lockcode[i]+1],x+560+i*16,y+95);
			end;
		end;
		if bags_list[bagid].traped then
			local traptriggers = {};
			local tmp = tostring(bags_list[bagid].triggers);
			for w in string.gmatch(tmp, "%d") do
				table.insert(traptriggers, tonumber(w));
			end;
			for i=1,10 do
				if traptriggers[i] == 1 then
					love.graphics.draw(media.images.ui, locktrap_trigger,x+555+i*13,y+151);	
				end;
			end;	
		end;
	end;
	
	if condition and bags_list[bagid].locktype == 3 then
		
		local lockcode = {};
		local tmp = tostring(bags_list[bagid].lockcode);
		for w in string.gmatch(tmp, "%d") do
			table.insert(lockcode, w);
		end;
		local keycode = {};
		if picklock[current_mob].key > 0 then
			local tmp = tostring(chars_stats[current_mob]["inventory_list"][picklock[current_mob].key].q);
			for w in string.gmatch(tmp, "%d") do
				table.insert(keycode, w);
			end;
		end;
		love.graphics.draw(media.images.ui, lock_3_base,x+525,y+80);
		--for i=1,math.min(10,chars_mobs_npcs[current_mob].lvl_picklocking*chars_mobs_npcs[current_mob].num_picklocking) do
		for i=1,10 do	
			if picklock[current_mob].key > 0 then
				if lockcode[i] == keycode[i] then
					diskcode[i] = 8;
				end;
			end
			love.graphics.draw(media.images.ui, lock_3_elements[diskcode[i]],x+540+i*17,y+85);
		end;
		if bags_list[bagid].traped then
			local traptriggers = {};
			local tmp = tostring(bags_list[bagid].triggers);
			for w in string.gmatch(tmp, "%d") do
				table.insert(traptriggers, tonumber(w));
			end;
			for i=1,10 do
				if traptriggers[i] == 1 then
					love.graphics.draw(media.images.ui, locktrap_trigger,x+535+i*13,y+151);	
				end;
			end;	
		end;
	end;
	
	if picklock[current_mob].key~=0 then
		local keycode = {};
		local tmp = tostring(chars_stats[current_mob]["inventory_list"][picklock[current_mob].key].w);
		for w in string.gmatch(tmp, "%d") do
			table.insert(keycode, w);
		end;
		keymatrix = {};
		for i=1,10 do
			keymatrix[i] = {};
			for h=1,10 do
				keymatrix[i][h] = 0;
			end;
		end;
		for i=1,10 do
			for h=1,keycode[i] do
				keymatrix[i][h] = 1;
				love.graphics.draw(media.images.ui, keypart,x+522+i*17,y+300-h*14);
			end;
		end;
	end;
	if not bagid then
		bagid = helpers.trapInFrontOf(current_mob);
	end;
	if bagid and bagid > 0 then
		draw.disarming (bags_list[bagid].typ);
	end;
end;

function draw.disarming (mode) --mode door/chest/ground --FIME in progress
	local x,y = helpers.centerObject(media.images.inv1);
	local condition = 0;
	local tmp = "";
	local object = "";
	if mode == "chest" then
		object = bags_list[bagid];
		condition = bagid and bagid > 0 and object.traped;
	elseif mode == "door" then
		object = bags_list[bagid];
		condition = bagid and bagid > 0 and object.traped;
	elseif mode == "trap" then 
		object = bags_list[bagid];
		condition = helpers.trapInFrontOf(current_mob);
	end;
	if condition then
		love.graphics.draw(media.images.ui, trap_elements[10],x+528,y+102);
		local trapcode = {};
		local inspcode = {};
		tmp = tostring(object.trapcode);
		local openCells = math.ceil((chars_mobs_npcs[current_mob].num_traps*chars_mobs_npcs[current_mob].lvl_traps+chars_mobs_npcs[current_mob].sns/2)/5);
		if chars_mobs_npcs[current_mob].num_traps*chars_mobs_npcs[current_mob].lvl_traps == 0 then
			openCells = 0;
		end;
		local complication = math.sqrt(#object.trapcode);
		if not object.inspected then -- first attempt
			draw.inspectioncode = {};
			local opened = {};
			for i=1,#object.trapcode do
				opened[i] = false;
				if i <= openCells then
					opened[i] = true;
				end;
			end;
			local opened_ = helpers.randomizeArray1D (opened);
			for i=1,#object.trapcode do
				table.insert(draw.inspectioncode,opened_[i]);
			end;
			object.inspcode = draw.inspectioncode;
			object.inspected = openCells;
		end;
		if  object.inspected and openCells > object.inspected then -- second attempt
			draw.inspectioncode2 = {};
			local opened = {};
			for i=1,#object.trapcode do
				if not object.inspcode[i] then
					table.insert(opened,i);
				end;
			end;
			local opened_ = helpers.randomizeArray1D (opened);
			for i=1,openCells-object.inspected do
				object["inspcode"][opened_[i]] = true;
			end;
			object.inspected = openCells;
		end;
		for w in string.gmatch(tmp, "%d") do
			table.insert(trapcode, tonumber(w));
		end;
		local counter = 1;
		for i=1,complication do
			for h=1,complication do
				if trapcode[counter] > 0 and object.inspcode[counter] then
					if  object.inspcode[counter]  then
						love.graphics.draw(media.images.ui, trap_elements[trapcode[counter]],x+575+h*25,y+440-i*25);
					else
						love.graphics.draw(media.images.ui, trap_elements[10],x+575+h*25,y+440-i*25);
					end;
				elseif not object.inspcode[counter] then
					love.graphics.draw(media.images.ui, trap_elements[10],x+575+h*25,y+440-i*25);
				end;
				counter = counter + 1;
			end;
		end;
		if chars_mobs_npcs[current_mob].lvl_traps > 0 then --complication?
			local model = object.trapmodel;
			love.graphics.draw(media.images.ui, trap_typeofdamage[model],x+525,y+345);
		end;
	end;
end;

function draw.inventory_bag ()
	local x,y = helpers.centerObject(media.images.inv1);
	local inv_add_x = x+12;
	local inv_add_y = y-25;
	local inv_part2 = x+654;
	local mbx,mby = helpers.hexInFronTOfMob(current_mob);
	if game_status == "inventory" then
		if inv_page == 1 then
			love.graphics.draw(media.images.inv1, x,y-50);
		else
			love.graphics.draw(media.images.inv2, x,y-50);
		end;
	elseif game_status == "alchemy" then
		love.graphics.draw(media.images.alch,  x,y-50);
	elseif game_status == "crafting" then
		love.graphics.draw(media.images.craft,  x,y-50);
	elseif game_status == "picklocking" then
		love.graphics.draw(media.images.picklock,  x,y-50);
	elseif game_status == "showinventory" then
		love.graphics.draw(media.images.sellidentfix, x,y-50);
	end;
	
	local bags_at_hex = 0;
	for j=1, #bags_list do
		if (chars_mobs_npcs[current_mob].x == bags_list[j].x and chars_mobs_npcs[current_mob].y == bags_list[j].y) or (bags_list[j].x == mbx and bags_list[j].y == mby and helpers.cursorAtMaterialBag(mbx,mby)) then
			love.graphics.draw(media.images.tmpobjs, bags_list[j].img,x+740+bags_at_hex*96,y-80+media.images.inv1:getHeight());
			bags_at_hex = bags_at_hex + 1;
		end;
	end;
	sorttarget = "char";
	for i=1,11 do
		for h=1,15 do
			if inventory_bag[current_mob][h][i] ~= 0 and inventory_bag[current_mob][h][i] < 10000 then
				tempid = inventory_bag[current_mob][h][i];
				draw.drawItem(tempid,chars_stats[current_mob]["inventory_list"][tempid].ttxid,(i-1)*32+inv_add_x,(h-1)*32+inv_add_y,false,0);
			end;
		end;
	end;
	local bag_found = false;
	local _x,_y = helpers.hexInFronTOfMob(current_mob)
	for j=1, #bags_list do
		if ((chars_mobs_npcs[current_mob].x == bags_list[j].x and chars_mobs_npcs[current_mob].y == bags_list[j].y) or (bags_list[j].typ == "door" and bags_list[j].x == _x and bags_list[j].y == _y)) and not bag_found then
			bagid = j;
			bag_found = true;
			if bags_list[j].typ == "bag" or (bags_list[j].typ == "chest" and not bags_list[j].locked and chars_mobs_npcs[current_mob].rot == bags_list[j].dir) then
				if bags_list[j].typ == "chest" and not bags_list[j].opened then
					utils.playSfx(media.sounds.chestopen_unlocked, 1);
					bags_list[j].opened = true;
					if bags_list[j].traped then
						if bags_list[j].locktype == 1 then
							helpers.chestTrapDisk(j);
						end;
						bags_list[j].traped = false;
					end;
				end;
				draw.bag();
			elseif bags_list[j].typ == "bag" or (bags_list[j].typ == "chest" and bags_list[j].locked and chars_mobs_npcs[current_mob].rot == bags_list[j].dir) or (bags_list[j].typ == "door" and bags_list[j].locked) then
				if not start_picklock then
					print("{}!");
					start_picklock = true;
					lock_elements = {};
					diskcode = {};
					local lockcode = {};
					local code = bags_list[bagid].lockcode;
					for w in string.gmatch(code, "%d") do
						table.insert(lockcode, tonumber(w));
					end;
					for i=1,10 do
						if lockcode[i] > 0 then
							lock_elements[i] = 1;
						else
							lock_elements[i] = 0;
						end;
					end;
					for i=1,10 do
						if lockcode[i] > 0 then
							diskcode[i] = math.random(2,8); -- not 1 to prevent trap activation at start
						else
							diskcode[i] = 8;
						end;
					end;
				end;
				for i=1,#chars_stats[current_mob]["inventory_list"] do
					if helpers.checkPickLock (bags_list[j].lockcode,bags_list[j].locktype) then
						bags_list[j].locked = false;
						for h=1,10 do
							lock_elements[h] = 0;
						end;
						utils.playSfx(media.sounds.chestopen_key, 1);
					end;	
				end;
				if bags_list[j].locked then
					game_status = "picklocking";
				end;
			else
				--draw_zaglushka ()
			end;
		elseif bags_list[j].x == mbx and bags_list[j].y == mby and helpers.cursorAtMaterialBag(mbx,mby) then
			bags_list[j].opened = true;
			bagid = j;
			draw.bag();
		end;
		if helpers.trapInFrontOf(current_mob) then
			game_status = "picklocking";
		end;
	end;
	sorttarget = oldsorttarget;
end;

function draw.hold ()
	if holding_smth > 0 then
		local list,bag,tmp_bagid = helpers.whatSortTarget(dragfrom,false,false);
		temphold=list[holding_smth].ttxid;
		if sorttarget=="char" then
			draw.drawItem(holding_smth,temphold,mX-32,mY-32,false,0);
		else
			draw.drawItem(holding_smth,temphold,mX-32,mY-32,true,bagid);
		end;
	end;
end;

function draw.tradersSpeech()
	love.graphics.draw(media.images.ui, tip_sub,mX,mY+360);
	local text = "";
	if game_status == "buying" then
		if global.preprice == global.price then
			text = lognames.traders.GoodChoice .. lognames.traders.PriceIs .. global.price .. ".";
		elseif global.preprice > global.price then
			text = lognames.traders.UsuallyI .. lognames.traders.selling .. global.preprice .. " " .. "\n" .. lognames.actions.withgold .. "." .. lognames.traders.butyouaretradinggood .. global.price .. ".";
		elseif global.preprice < global.price then
			text = lognames.traders.UsuallyI .. lognames.traders.selling .. global.preprice .. " " .. "\n" .. lognames.actions.withgold .. "." .. lognames.traders.butyourreputationbadsohigher .. global.price .. ".";
		end;
	else
		local tmpinv2=list[tmpinv].ttxid;
		local class = inventory_ttx[tmpinv2].class;
		if global.showinventory_flag == "sell" then 
			if helpers.tradersBuysThisItem(victim,class) then
				if global.price == 0 then
					text = lognames.traders.notinterested;
				else
					if global.preprice == global.price then
						text = lognames.traders.GoodChoice .. lognames.traders.PriceIs .. global.price .. ".";
					elseif global.preprice < global.price then
						text = lognames.traders.UsuallyI .. lognames.traders.buying .. global.preprice .. " " .. "\n" .. lognames.actions.withgold .. "." .. lognames.traders.butyouaretradinggood .. global.price .. ".";
					elseif global.preprice > global.price then
						text = lognames.traders.UsuallyI .. lognames.traders.buying .. global.preprice .. " " .. "\n" .. lognames.actions.withgold .. "." .. lognames.traders.butyourreputationbadsolower .. global.price .. ".";
					end;
				end;
			else
				text = lognames.traders.notinterested;
			end;
		elseif global.showinventory_flag == "id" then
			if helpers.tradersIdentifiesThisItem(victim,class) then
				local price = math.ceil(100*traders[chars_mobs_npcs[victim].shop].prices[1]);
				price = helpers.recountPrice(price,current_mob,victim);
				if list[tmpinv].r == 0 then
					text = lognames.traders.canidfor .. price .. lognames.actions.withgold .. ".";
				end;
			else
				text = lognames.traders.notmyspec;
			end;
		elseif global.showinventory_flag == "repair" then
			if helpers.tradersRepairsThisItem(victim,class) then
				local list,bag,tmp_bagid = helpers.whatSortTarget(sorttarget,false,false);
				global.preprice = math.ceil(global.preprice*0.25);
				global.price = math.ceil(global.price*0.25);
				if inventory_ttx[tmpinv2].material ~= list[tmpinv].q then
					if global.preprice == global.price then
						text = lognames.traders.RepairFor .. global.price .. lognames.actions.withgold .. ".";
					elseif global.preprice > global.price then
						text = lognames.traders.UsuallyI .. lognames.traders.repairing .. global.preprice .. " " .. "\n" .. lognames.actions.withgold .. "." .. lognames.traders.butyouaretradinggood .. global.price .. ".";
					elseif global.preprice < global.price then
						text = lognames.traders.UsuallyI .. lognames.traders.repairing .. global.preprice .. " " .. "\n" .. lognames.actions.withgold .. "." .. lognames.traders.butyourreputationbadsohigher .. global.price .. ".";
					end;
				end;
			else
				text = lognames.traders.notmyspec;
			end;
		end;
	end;
	local textfield = loveframes.Create("text");
	textfield:SetPos(mX,mY+370);
	textfield:SetMaxWidth(340);
	textfield:SetFont(statFont);
	textfield:SetText(text);
end;

function draw.trading ()
	if wares == "armor" then
		local part = math.ceil(media.images.shoparmor:getWidth()/8);
		local x,y = helpers.centerObject(media.images.shoparmor);
		love.graphics.draw(media.images.shoparmor, x,y-50);
		local bagid = traders[current_shop].bars[1];
		for i=1,8 do
			if bars_list[bagid][i] ~= "none" then
				local id = bars_list[bagid][i]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+220);
			end;
		end;
		for i=1,8 do
			if bars_list[bagid][8+i] ~= "none" then
				local id = bars_list[bagid][i+8]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+100);
			end;
		end;
	elseif wares == "melee" then
		local part = math.ceil(media.images.shoparmor:getWidth()/8);
		local x,y = helpers.centerObject(media.images.shoparmor);
		love.graphics.draw(media.images.shopmelee,  x,y-50);
		local bagid = traders[current_shop].bars[3+global.wares_flag];
		for i=1,8 do
			if bars_list[bagid][i] ~= "none" then
				local id = bars_list[bagid][i]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				love.graphics.draw(media.images.items1, tiles_items[id],64+x+(i-1)*part-dcpl,y+200-math.ceil(inventory_ttx[id].h/2*32));
			end;
		end;
	elseif wares == "ranged" then
		local x,y = helpers.centerObject(media.images.shopbooks);
		love.graphics.draw(media.images.shopbooks, x,y-50);
	elseif wares == "books" then
		local part = math.ceil(media.images.shopbooks:getWidth()/8);
		local x,y = helpers.centerObject(media.images.shopbooks);
		love.graphics.draw(media.images.shopbooks,  x,y-50);
		local bagid = traders[current_shop].bars[11];
		for i=1,8 do
			if bars_list[bagid][i] ~= "none" then
				local id = bars_list[bagid][i]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+150-item_height);
			end;
		end;
		for i=1,8 do
			if bars_list[bagid][8+i] ~= "none" then
				local id = bars_list[bagid][i+8]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+300-item_height);
			end;
		end;
		for i=1,8 do
			if bars_list[bagid][8+i] ~= "none" then
				local id = bars_list[bagid][i+16]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+430-item_height);
			end;
		end;
	elseif wares == "magic" then
		local part = math.ceil(media.images.shopmagic:getWidth()/8);
		local x,y = helpers.centerObject(media.images.shopmagic);
		love.graphics.draw(media.images.shopmagic,  x,y-50);
		local bagid = traders[current_shop].bars[11];
		for i=1,8 do
			if bars_list[bagid][i] ~= "none" then
				local id = bars_list[bagid][i]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+150-item_height);
			end;
		end;
		for i=1,8 do
			if bars_list[bagid][8+i] ~= "none" then
				local id = bars_list[bagid][i+8]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+300-item_height);
			end;
		end;
		for i=1,8 do
			if bars_list[bagid][8+i] ~= "none" then
				local id = bars_list[bagid][i+16]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+430-item_height);
			end;
		end;
	elseif wares == "jewelry" then
		local part = math.ceil(media.images.shopjewelry:getWidth()/8);
		local x,y = helpers.centerObject(media.images.shopjewelry);
		love.graphics.draw(media.images.shopjewelry,  x,y-50);
		local bagid = traders[current_shop].bars[11];
		for i=1,8 do
			if bars_list[bagid][i] ~= "none" then
				local id = bars_list[bagid][i]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+150-item_height);
			end;
		end;
		for i=1,8 do
			if bars_list[bagid][8+i] ~= "none" then
				local id = bars_list[bagid][i+8]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+300-item_height);
			end;
		end;
		for i=1,8 do
			if bars_list[bagid][8+i] ~= "none" then
				local id = bars_list[bagid][i+16]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+430-item_height);
			end;
		end;
	elseif wares == "alchemy" then
		local part = math.ceil(media.images.shopalchemy:getWidth()/8);
		local x,y = helpers.centerObject(media.images.shopalchemy);
		love.graphics.draw(media.images.shopalchemy,  x,y-50);
		local bagid = traders[current_shop].bars[11];
		for i=1,8 do
			if bars_list[bagid][i] ~= "none" then
				local id = bars_list[bagid][i]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+150-item_height);
			end;
		end;
		for i=1,8 do
			if bars_list[bagid][8+i] ~= "none" then
				local id = bars_list[bagid][i+8]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+300-item_height);
			end;
		end;
		for i=1,8 do
			if bars_list[bagid][8+i] ~= "none" then
				local id = bars_list[bagid][i+16]["ttxid"];
				local dcpl = math.ceil(inventory_ttx[id].w/2*32);
				local item_height = math.ceil(inventory_ttx[id].h*32);
				love.graphics.draw(media.images.items2, tiles_items[id],64+x+(i-1)*part-dcpl,y+430-item_height);
			end;
		end;
	elseif wares == "criminal" then
		love.graphics.draw(media.images.shopbooks, 400,200);
	elseif wares == "food" then
		love.graphics.draw(media.images.shopbooks, 400,200);
	elseif wares == "guild" then
		love.graphics.draw(media.images.shopbooks, 400,200);
	end;
end;

function draw.line()
	if #shot_line>0 and game_status == "sensing" then
		for i=1,#shot_line do
			draw.drawHex(shot_line[i][1],shot_line[i][2],cursor_empty);
		end;
	end;
end;

function draw.irradiation (mx,my)
	--[[if irradiation == "day" then
		love.graphics.setColor(255, 255, 255);
	elseif irradiation == "twilight" then
		love.graphics.setColor(200, 200, 220);
	elseif irradiation == "night" then
		local light_is_near = helpers.lightIsNear(my+map_y,mx+map_x);
		if dlandscape_obj[my+map_y][mx+map_x] == "fire" then
			love.graphics.setColor(255, 150, 100);
		elseif dlandscape_obj[my+map_y][mx+map_x] ~= "fire" and not light_is_near then
			love.graphics.setColor(50, 50, 50);
		elseif dlandscape_obj[my+map_y][mx+map_x] ~= "fire" and light_is_near then
			love.graphics.setColor(255, 150, 100);
		end;
	elseif irradiation == "dawn" or irradiation == "afterglow" then
		love.graphics.setColor(255, 200, 200);
	elseif irradiation == "firelight" then
		love.graphics.setColor(255, 150, 100);
	elseif irradiation == "dungeon" then
		love.graphics.setColor(125, 125, 125);
	end;]]
end;


function draw.shaderIrradiation ()
	if (game_status ~= "missle" or missle_type ~= "armageddon") and (game_status ~= "shot" or missle_type ~= "inferno" or missle_type ~= "souldrinker" or missle_type ~= "moonlight") then
		if irradiation == "day" then
			lightWorld.setAmbientColor(255, 255, 255);
		elseif irradiation == "twilight" then
			lightWorld.setAmbientColor(200, 200, 220);
		elseif irradiation == "night" then
			lightWorld.setAmbientColor(25, 25, 50);
		elseif irradiation == "dawn" or irradiation == "afterglow" then
			lightWorld.setAmbientColor(255, 200, 200);
		elseif irradiation == "firelight" then
			lightWorld.setAmbientColor(255, 150, 100);
		elseif irradiation == "dungeon" then
			lightWorld.setAmbientColor(0, 0, 0);
		end;
	elseif game_status == "missle" and missle_type == "armageddon" then
		lightWorld.setAmbientColor(255, 50, 50);
	elseif game_status == "shot" and missle_type == "inferno" then
		lightWorld.setAmbientColor(255, 150, 0);
	elseif game_status == "shot" and missle_type == "moonlight" then
		lightWorld.setAmbientColor(150, 150, 255);
	elseif game_status == "shot" and missle_type == "souldrinker" then
		lightWorld.setAmbientColor(200, 255, 255);
	end;
end;


function draw.way ()
	for i=1,#way_of_the_mob do
		draw.drawHex (way_of_the_mob[i][1],way_of_the_mob[i][2],cursor_way[way_of_the_mob[i][6]]);
	end;
end;

function draw.mindway ()
	if global.mindway then
		for i=1,#global.mindway do
			draw.drawMindHex (global.mindway[i][1],global.mindway[i][2],cursor_white);
		end;
	end;
end;

function draw.fogOfWar()
	if game_status ~= "sensing" then
		trace.wizardEye ();
	end;
	for my=1, math.min(map_display_h, map_h-map_y) do
		for mx=1, math.min(map_display_w, map_w-map_x) do
			if darkness[1][my+map_y][mx+map_x] == 2 then
				draw.drawHex (mx+map_x,my+map_y,tile_black);
			end
			if darkness[1][my+map_y][mx+map_x] == 1 and global.grey then
				draw.drawHex (mx+map_x,my+map_y,tile_grey);
			end;
		end;
	end;
 end;

function draw.housewatch (current_house)
	loveframes.util.RemoveAll();
	local x,y = helpers.centerObject(media.images.map);
	love.graphics.draw(media.images.map, x,y-50);
	for i=1, #localtriggers[global.level_to_load][current_house].npcs do
		local index = helpers.findNPCindex(localtriggers[global.level_to_load][current_house]["npcs"][i]);
		love.graphics.draw(media.images.npcfaces, npcfaces[chars_mobs_npcs[index].face], x+55+100*(i-1), y);
		local name = chars_mobs_npcs[index].name;
		love.graphics.print(name, x+55+100*(i-1), y+100);
	end;
end;

function draw.rain (dencity,offsetx,offsety,r,g,b,a)
	raintable = {};
	for i=1,dencity do
		raintable[i] = {};
		local initialX = math.random(1,1280);
		local initialY = math.random(1,1024);
		table.insert(raintable[i],initialX);
		table.insert(raintable[i],initialY);
		table.insert(raintable[i],initialX+offsetx);
		table.insert(raintable[i],initialY+offsety);
		love.graphics.setColor(r, g, b,a);
		love.graphics.line(raintable[i]);
		love.graphics.setColor(255, 255, 255,255);
	end;
end;

function draw.drawItem(index,id,x,y,ifbag,bagid)
	if helpers.ifItemIsNotBroken(index,ifbag,bagid) then
		love.graphics.setColor(255, 255, 255);
	else
		love.graphics.setColor(255, 0, 0);
	end;
	if helpers.ifItemIsNotBroken(index,ifbag,bagid) and helpers.ifItemIsIdentified(index,ifbag,bagid) then
		love.graphics.setColor(255, 255, 255);
	elseif helpers.ifItemIsNotBroken(index,ifbag,bagid) then
		love.graphics.setColor(0, 255, 0);
	end;
	if helpers.itemIsAtFile1(id) then
		love.graphics.draw(media.images.items1, tiles_items[id],x,y);
	else
		love.graphics.draw(media.images.items2, tiles_items[id],x,y);
	end;
	love.graphics.setColor(255, 255, 255);
end;

function draw.drawMindHex (hx,hy,cursor)
	local x,y = helpers.centerObject(media.images.map);
	local moveto_hex_x = 0;
	local moveto_hex_y = 0;
	moveto_hex_y = math.ceil(hy*tile_h*0.75+y+123);
	if hy/2 == math.ceil(hy/2) then
		moveto_hex_x = hx*tile_w+x-7;
	else
		moveto_hex_x = hx*tile_w+tile_w/2+x-7;
	end;
	love.graphics.draw(media.images.hex, cursor, moveto_hex_x, moveto_hex_y);
	--local coords = x .. "x" .. y;
	--love.graphics.print(coords,moveto_hex_x+32, moveto_hex_y+16)
end;

function draw.drawMindHexDebug (x,y,string)
	local moveto_hex_x = 0;
	local moveto_hex_y = 0;
	moveto_hex_y = math.ceil(y*tile_h*0.75+222);
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = x*tile_w+258;
	else
		moveto_hex_x = x*tile_w+tile_w/2+258;
	end;
	love.graphics.setColor(0, 0, 0);
	love.graphics.print(string,moveto_hex_x+32, moveto_hex_y+16)
	love.graphics.setColor(255, 255, 255);
end;

function draw.drawMindObject (image,object,hx,hy,addx,addy)
	local x,y = helpers.centerObject(media.images.map);
	local moveto_hex_x = 0;
	local moveto_hex_y = 0;
	moveto_hex_y = math.ceil(hy*tile_h*0.75+y+245)+addy;
	if hy/2 == math.ceil(hy/2) then
		moveto_hex_x = hx*tile_w+x+345+addx;
	else
		moveto_hex_x = hx*tile_w+tile_w/2+x+345+addx;
	end;
	love.graphics.draw(image, object, moveto_hex_x, moveto_hex_y);
end;

function draw.drawHex (x,y,cursor)
	local moveto_hex_x = 0;
	local moveto_hex_y = 0;
	moveto_hex_y = math.ceil((y-1-map_y)*tile_h*0.75+top_space);
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2-map_x)*tile_w+left_space;
	else
		moveto_hex_x = (x-2-map_x)*tile_w+tile_w/2+left_space;
	end;
	local newhex = love.graphics.draw(media.images.hex, cursor, moveto_hex_x, moveto_hex_y);
	--love.graphics.print(slandscape[y][x],moveto_hex_x+32, moveto_hex_y+16)
	--love.graphics.print(visibility_table[map[y][x]],moveto_hex_x+2, moveto_hex_y+16)
	--love.graphics.print(darkness[1][y][x],moveto_hex_x+4, moveto_hex_y+20)
end;

function draw.drawNumberHex (x,y,add,txt)
	moveto_hex_y = math.ceil((y-1-map_y)*tile_h*0.75+top_space)+8;
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2-map_x)*tile_w+left_space+add;
	else
		moveto_hex_x = (x-2-map_x)*tile_w+tile_w/2+left_space+add;
	end;
	love.graphics.print(txt,moveto_hex_x,moveto_hex_y);
end;

function draw.drawHarvest (x,y,img_index)
	moveto_hex_y = math.ceil((y-1-map_y)*tile_h*0.75+top_space)-tile_h*2;
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2-map_x)*tile_w+left_space;
	else
		moveto_hex_x = (x-2-map_x)*tile_w+tile_w/2+left_space;
	end;
		love.graphics.draw(media.images.harvest, harvest_ttx[img_index].sprite, moveto_hex_x, moveto_hex_y);
end;

function draw.drawHitHex (hitHex_x,hitHex_y)
	if hitHex_x > 0 and hitHex_y > 0 then
		draw.drawHex(hitHex_x,hitHex_y,cursor_red);
	end;
end;

function draw.drawAnimationHex (x,y,image,cursor)
	moveto_hex_y = math.ceil((y-1-map_y)*tile_h*0.75+top_space);
	if y/2 == math.ceil(y/2) then
		moveto_hex_x = (x-2-map_x)*tile_w+left_space;
	else
		moveto_hex_x = (x-2-map_x)*tile_w+tile_w/2+left_space;
	end;
		cursor:draw(imgage,moveto_hex_x,moveto_hex_y);
end;

function draw.mindgameButtons()
	loveframes.util.RemoveAll();
	mindgame.moneysums = mindgame.calcGoldSums();
	love.graphics.setColor(0, 0, 0);
	--love.graphics.setFont(heroesLargeFont);
	love.graphics.setFont(bookFont);
	local x,y = helpers.centerObject(media.images.map);
	local total_diplomacy = chars_mobs_npcs[current_mob].lvl_diplomacy*chars_mobs_npcs[current_mob].num_diplomacy;
	--gold
	if total_diplomacy >= 1 and #global.mindgold_array > 1 then
		global.buttons.g1_button = loveframes.Create("imagebutton");
		global.buttons.g1_button:SetImage(media.images.button9);
		global.buttons.g1_button:SetPos(x+35,y+395);
		global.buttons.g1_button:SizeToImage()
		global.buttons.g1_button:SetText("<<<");
		global.buttons.g1_button.OnClick = function(object)
			if global.goldmissle > 1 then
				global.goldmissle = global.goldmissle - 1;
			else
				global.goldmissle = #global.mindgold_array;
			end;
			local text = global.mindgold_array[global.goldmissle];
			global.gold_text_field:SetText(text);
			mindmissle = global.goldmissle;
		end;
	end;
	if total_diplomacy >= 1 and #global.mindgold_array > 1 then
		local text = mindgame.moneysums[global.goldmissle];
		local addx = math.ceil(5*(7-#tostring(text)));
		global.gold_text_field = loveframes.Create("text");
		global.gold_text_field:SetPos(x+95+addx,y+400);
		global.gold_text_field:SetMaxWidth(100);
		global.gold_text_field:SetFont(bookFont);
		global.gold_text_field:SetText(text);
	end;
	
	if total_diplomacy >= 1 and #global.mindgold_array > 1 then
		global.buttons.g3_button = loveframes.Create("imagebutton");
		global.buttons.g3_button:SetImage(media.images.button9);
		global.buttons.g3_button:SetPos(x+190,y+395);
		global.buttons.g3_button:SizeToImage()
		global.buttons.g3_button:SetText(">>>");
		global.buttons.g3_button.OnClick = function(object)
			if global.goldmissle < #global.mindgold_array then
				global.goldmissle = global.goldmissle + 1;
			else
				global.goldmissle = 1;
			end;
			local text = global.mindgold_array[global.goldmissle];
			global.gold_text_field:SetText(text);
			mindmissle = global.goldmissle;
		end;
	end;
	if total_diplomacy >= 1 and #global.mindgold_array > 1 then
		global.buttons.g4_button = loveframes.Create("imagebutton");
		global.buttons.g4_button:SetImage(media.images.button9);
		global.buttons.g4_button:SetPos(x+290,y+395);
		global.buttons.g4_button:SizeToImage()
		global.buttons.g4_button:SetText(lognames.mindgame.bribery);
		global.buttons.g4_button.OnClick = function(object)
			mindmissle = global.goldmissle;
		end;
	end;
	
	--drink
	local addx2 = 355;
	
	if total_diplomacy >= 1 and #global.minddrink_array >= 1 then
		global.buttons.d1_button = loveframes.Create("imagebutton");
		global.buttons.d1_button:SetImage(media.images.button9);
		global.buttons.d1_button:SetPos(x+35+addx2,y+395);
		global.buttons.d1_button:SizeToImage()
		global.buttons.d1_button:SetText("<<<");
		global.buttons.d1_button.OnClick = function(object)
			if global.drinkmissle > 1 then
				global.drinkmissle = global.drinkmissle - 1;
			else
				global.drinkmissle = #global.minddrink_array;
			end;
			mindmissle = 1000 + global.minddrink_array[global.drinkmissle].spriteid;
		end;
	end;
	
	if total_diplomacy >= 1 and #global.minddrink_array >= 1 then
		global.buttons.d3_button = loveframes.Create("imagebutton");
		global.buttons.d3_button:SetImage(media.images.button9);
		global.buttons.d3_button:SetPos(x+180+addx2,y+395);
		global.buttons.d3_button:SizeToImage()
		global.buttons.d3_button:SetText(">>>");
		global.buttons.d3_button.OnClick = function(object)
			if global.drinkmissle < #global.minddrink_array then
				global.drinkmissle = global.drinkmissle + 1;
			else
				global.drinkmissle = 1;
			end;
			mindmissle = 1000 + global.minddrink_array[global.drinkmissle].spriteid;
		end;
	end;
	if total_diplomacy >= 1 and #global.minddrink_array >= 1 then
		global.buttons.d4_button = loveframes.Create("imagebutton");
		global.buttons.d4_button:SetImage(media.images.button9);
		global.buttons.d4_button:SetPos(x+280+addx2,y+395);
		global.buttons.d4_button:SizeToImage()
		global.buttons.d4_button:SetText(lognames.mindgame.gift);
		global.buttons.d4_button.OnClick = function(object)
			mindmissle = 1000 + global.minddrink_array[global.drinkmissle].spriteid;
		end;
	end;
	
	--threats

	if total_diplomacy >= 1 and #global.threats_pull > 0 then
		
		global.buttons.t1_button = loveframes.Create("imagebutton");
		global.buttons.t1_button:SetImage(media.images.button9);
		global.buttons.t1_button:SetPos(x+35,y+440);
		global.buttons.t1_button:SizeToImage()
		global.buttons.t1_button:SetText("<<<");
		global.buttons.t1_button.OnClick = function(object)
			if global.current_threat > 1 then
				global.current_threat = global.current_threat - 1;
			else
				global.current_threat = #global.threats_pull;
			end;
			local _phraseid = threats_ttx[global.threats_pull[global.current_threat] ].phrase;
			local text = chats.questionPerEtiquette(_phraseid,chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
			global.threat_text_field:SetText(text);
			mindmissle = threats_ttx[global.current_threat].missle;
		end;
		
		local text = chats.questionPerEtiquette(threats_ttx[global.threats_pull[1] ].phrase,chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
		global.threat_text_field = loveframes.Create("text");
		global.threat_text_field:SetPos(x+140,y+440);
		global.threat_text_field:SetMaxWidth(400);
		global.threat_text_field:SetFont(bookFont);
		global.threat_text_field:SetText(text);


		global.buttons.t6_button = loveframes.Create("imagebutton");
		global.buttons.t6_button:SetImage(media.images.button9);
		global.buttons.t6_button:SetPos(x+535,y+440);
		global.buttons.t6_button:SizeToImage()
		global.buttons.t6_button:SetText(">>>");
		global.buttons.t6_button.OnClick = function(object)
			if global.current_threat < #global.threats_pull then
				global.current_threat = global.current_threat + 1;
			 else
				global.current_threat = 1;
			 end;
			local _phraseid = threats_ttx[global.threats_pull[global.current_threat] ].phrase;
			local text = chats.questionPerEtiquette(_phraseid,chars_mobs_npcs[current_mob]["personality"]["current"].etiquette);
			global.threat_text_field:SetText(text);
			mindmissle = threats_ttx[global.current_threat].missle;
		end;

		global.buttons.t7_button = loveframes.Create("imagebutton");
		global.buttons.t7_button:SetImage(media.images.button9);
		global.buttons.t7_button:SetPos(x+635,y+440);
		global.buttons.t7_button:SizeToImage()
		global.buttons.t7_button:SetText(lognames.mindgame.threat);
		global.buttons.t7_button.OnClick = function(object)
			mindmissle = threats_ttx[global.current_threat].missle;
		end;
	end;
	
	--secrets rumours
	if total_diplomacy >= 1 and #global.secrets_pull > 0 then
		
		global.buttons.s1_button = loveframes.Create("imagebutton");
		global.buttons.s1_button:SetImage(media.images.button9);
		global.buttons.s1_button:SetPos(x+35,y+485);
		global.buttons.s1_button:SizeToImage()
		global.buttons.s1_button:SetText("<<<");
		global.buttons.s1_button.OnClick = function(object)
			if global.current_secret > 1 then
				global.current_secret = global.current_secret - 1;
			else
				global.current_secret = #global.secrets_pull;
			end;
			local text = secrets_ttx[global.secrets_pull[global.current_secret]].title;
			global.secret_text_field:SetText(text);
			mindmissle = 31;
		end;
		

		local text = secrets_ttx[global.secrets_pull[1]].title;
		global.secret_text_field = loveframes.Create("text");
		global.secret_text_field:SetPos(x+140,y+485);
		global.secret_text_field:SetMaxWidth(400);
		global.secret_text_field:SetFont(bookFont);
		global.secret_text_field:SetText(text);


		global.buttons.s6_button = loveframes.Create("imagebutton");
		global.buttons.s6_button:SetImage(media.images.button9);
		global.buttons.s6_button:SetPos(x+535,y+485);
		global.buttons.s6_button:SizeToImage()
		global.buttons.s6_button:SetText(">>>");
		global.buttons.s6_button.OnClick = function(object)
			if global.current_secret < #global.secrets_pull then
				global.current_secret = global.current_secret + 1;
			 else
				global.current_secret = 1;
			 end;
			local text = secrets_ttx[global.secrets_pull[global.current_secret]].title;
			global.secret_text_field:SetText(text);
			mindmissle = 31;
		end;

		global.buttons.s7_button = loveframes.Create("imagebutton");
		global.buttons.s7_button:SetImage(media.images.button9);
		global.buttons.s7_button:SetPos(x+635,y+485);
		global.buttons.s7_button:SizeToImage()
		global.buttons.s7_button:SetText(lognames.mindgame.secret);
		global.buttons.s7_button.OnClick = function(object)
			mindmissle = 31;
		end;
	end;
	--jokes
	if total_diplomacy >= 1  and #global.jokes_pull > 0 then
	
		global.buttons.w1_button = loveframes.Create("imagebutton");
		global.buttons.w1_button:SetImage(media.images.button9);
		global.buttons.w1_button:SetPos(x+35,y+530);
		global.buttons.w1_button:SizeToImage()
		global.buttons.w1_button:SetText("<<<");
		global.buttons.w1_button.OnClick = function(object)
			if global.current_joke > 1 then
				global.current_joke = global.current_joke - 1;
			else
				global.current_joke = #global.jokes_pull;
			end;
			local text = jokes_ttx[party.jokes[global.current_joke]].title;
			global.joke_text_field:SetText(text);
			mindmissle = 32;
		end;
	
		local text = jokes_ttx[party.jokes[1]].title;
		global.joke_text_field = loveframes.Create("text");
		global.joke_text_field:SetPos(x+140,y+525);
		global.joke_text_field:SetMaxWidth(400);
		global.joke_text_field:SetFont(bookFont);
		global.joke_text_field:SetText(text);

		global.buttons.w6_button = loveframes.Create("imagebutton");
		global.buttons.w6_button:SetImage(media.images.button9);
		global.buttons.w6_button:SetPos(x+535,y+530);
		global.buttons.w6_button:SizeToImage()
		global.buttons.w6_button:SetText(">>>");
		global.buttons.w6_button.OnClick = function(object)
			if global.current_joke < #global.jokes_pull then
				global.current_joke = global.current_joke + 1;
			else
				global.current_joke = 1;
			end;
			local text = jokes_ttx[party.jokes[global.current_joke]].title;
			global.joke_text_field:SetText(text);
			mindmissle = 32;
		end;
	
		global.buttons.w7_button = loveframes.Create("imagebutton");
		global.buttons.w7_button:SetImage(media.images.button9);
		global.buttons.w7_button:SetPos(x+635,y+530);
		global.buttons.w7_button:SizeToImage()
		global.buttons.w7_button:SetText(lognames.mindgame.joke);
		global.buttons.w7_button.OnClick = function(object)
			mindmissle = 32;
			end;
	end;
	
	--socialengeneering --FIXME: 3 missles hypno,troll,sad
	if total_diplomacy >= 1 and #global.nlps_pull > 0 then
		global.buttons.w1_button = loveframes.Create("imagebutton");
		global.buttons.w1_button:SetImage(media.images.button9);
		global.buttons.w1_button:SetPos(x+35,y+575);
		global.buttons.w1_button:SizeToImage()
		global.buttons.w1_button:SetText("<<<");
		global.buttons.w1_button.OnClick = function(object)
			if global.current_nlp > 1 then
				global.current_nlp = global.current_nlp - 1;
			else
				global.current_nlp = #global.nlps_pull;
			end;
			local text = nlps_ttx[party.nlps[global.current_nlp]].phrase;
			global.nlp_text_field:SetText(text); 
			mindmissle = nlps_ttx[party.nlps[global.current_nlp]].missle;
		end;

		local text = nlps_ttx[party.nlps[1]].phrase;
		global.nlp_text_field = loveframes.Create("text");
		global.nlp_text_field:SetPos(x+140,y+575);
		global.nlp_text_field:SetMaxWidth(400);
		global.nlp_text_field:SetFont(bookFont);
		global.nlp_text_field:SetText(text);

		global.buttons.w6_button = loveframes.Create("imagebutton");
		global.buttons.w6_button:SetImage(media.images.button9);
		global.buttons.w6_button:SetPos(x+535,y+575);
		global.buttons.w6_button:SizeToImage()
		global.buttons.w6_button:SetText(">>>");
		global.buttons.w6_button.OnClick = function(object)
			if global.current_nlp < #global.nlps_pull then
				global.current_nlp = global.current_nlp + 1;
			else
				global.current_nlp = 1;
			end;
			local text = nlps_ttx[party.nlps[global.current_nlp]].phrase;
			global.nlp_text_field:SetText(text);
			mindmissle = nlps_ttx[party.nlps[global.current_nlp]].missle;
		end;

		global.buttons.w7_button = loveframes.Create("imagebutton");
		global.buttons.w7_button:SetImage(media.images.button9);
		global.buttons.w7_button:SetPos(x+635,y+575);
		global.buttons.w7_button:SizeToImage()
		global.buttons.w7_button:SetText(lognames.mindgame.say);
		global.buttons.w7_button.OnClick = function(object)
			mindmissle = nlps_ttx[party.nlps[global.current_nlp]].missle;
			end;
	end;
	
	--affronts

	if total_diplomacy >= 1 and #global.affronts_pull > 0 then
		
		global.buttons.t1_button = loveframes.Create("imagebutton");
		global.buttons.t1_button:SetImage(media.images.button9);
		global.buttons.t1_button:SetPos(x+35,y+620);
		global.buttons.t1_button:SizeToImage()
		global.buttons.t1_button:SetText("<<<");
		global.buttons.t1_button.OnClick = function(object)
			if global.current_affront > 1 then
				global.current_affront = global.current_affront - 1;
			else
				global.current_affront = #global.affronts_pull;
			end;
			local text = affronts_ttx[global.affronts_pull[global.current_affront] ].phrase;
			global.affront_text_field:SetText(text);
			mindmissle = 35;
		end;

		local text = affronts_ttx[global.affronts_pull[1] ].phrase;
		global.affront_text_field = loveframes.Create("text");
		global.affront_text_field:SetPos(x+140,y+620);
		global.affront_text_field:SetMaxWidth(400);
		global.affront_text_field:SetFont(bookFont);
		global.affront_text_field:SetText(text);


		global.buttons.t6_button = loveframes.Create("imagebutton");
		global.buttons.t6_button:SetImage(media.images.button9);
		global.buttons.t6_button:SetPos(x+535,y+620);
		global.buttons.t6_button:SizeToImage()
		global.buttons.t6_button:SetText(">>>");
		global.buttons.t6_button.OnClick = function(object)
			if global.current_affront < #global.affronts_pull then
				global.current_affront = global.current_affront + 1;
			 else
				global.current_affront = 1;
			 end;
			local text = affronts_ttx[global.affronts_pull[global.current_affront] ].phrase;
			global.affront_text_field:SetText(text);
			mindmissle = 35;
		end;

		global.buttons.t7_button = loveframes.Create("imagebutton");
		global.buttons.t7_button:SetImage(media.images.button9);
		global.buttons.t7_button:SetPos(x+635,y+620);
		global.buttons.t7_button:SizeToImage()
		global.buttons.t7_button:SetText(lognames.mindgame.affront);
		global.buttons.t7_button.OnClick = function(object)
			mindmissle = 35;
		end;
	end;
	
	--connections
	if total_diplomacy >= 1  and #global.connections_pull > 0 then
		global.buttons.w1_button = loveframes.Create("imagebutton");
		global.buttons.w1_button:SetImage(media.images.button9);
		global.buttons.w1_button:SetPos(x+35,y+665);
		global.buttons.w1_button:SizeToImage()
		global.buttons.w1_button:SetText("<<<");
		global.buttons.w1_button.OnClick = function(object)
			if global.current_connection > 1 then
				global.current_connection = global.current_connection - 1;
			else
				global.current_connection = #global.connections_pull;
			end;
			local text = npc_ttx[party.connections[global.current_connection]].name .. ". " .. chats.questionPerEtiquette("doyouknowhim",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette); --FIXME
			global.connections_text_field:SetText(text);
			mindmisle = 34;
		end;

		local text = npc_ttx[party.connections[global.current_connection]].name .. ". " .. chats.questionPerEtiquette("doyouknowhim",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette); --FIXME
		global.connections_text_field = loveframes.Create("text");
		global.connections_text_field:SetPos(x+140,y+665);
		global.connections_text_field:SetMaxWidth(400);
		global.connections_text_field:SetFont(bookFont);
		global.connections_text_field:SetText(text);

		global.buttons.w6_button = loveframes.Create("imagebutton");
		global.buttons.w6_button:SetImage(media.images.button9);
		global.buttons.w6_button:SetPos(x+535,y+665);
		global.buttons.w6_button:SizeToImage()
		global.buttons.w6_button:SetText(">>>");
		global.buttons.w6_button.OnClick = function(object)
			if global.current_connection < #global.connections_pull then
				global.current_connection = global.current_connection + 1;
			else
				global.current_connection = 1;
			end;
			print("NAME",party.connections[global.current_connection],npc_ttx[party.connections[global.current_connection]].name);
			local text = npc_ttx[party.connections[global.current_connection]].name .. ". " .. chats.questionPerEtiquette("doyouknowhim",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette); --FIXME
			global.connections_text_field:SetText(text);
			mindmisle = 34;
		end;

		global.buttons.w7_button = loveframes.Create("imagebutton");
		global.buttons.w7_button:SetImage(media.images.button9);
		global.buttons.w7_button:SetPos(x+635,y+665);
		global.buttons.w7_button:SizeToImage()
		global.buttons.w7_button:SetText(lognames.mindgame.call);
		global.buttons.w7_button.OnClick = function(object)
			mindmisle = 34;
			end;
	end;
	draw.mindgameLog ();
	love.graphics.setColor(255, 255, 255);
	love.graphics.setFont(mainFont);
end;
