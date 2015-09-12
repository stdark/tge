chat_functions = {};

function chat_functions.ifStat(index, stat,operator,value,ifsuccess,ifnot)
	if     operator == "Equal" then
		if chars_mobs_npcs[index][stat] == value then
			return ifsuccess;
		end;
	elseif operator == "NotEqual" then
		if chars_mobs_npcs[index][stat] ~= value then
			return ifsuccess;
		end;
	elseif operator == "Random100" then
		local rnd = math.random(1,100);
		if chars_mobs_npcs[index][stat] >= rnd then
			return ifsuccess;
		end;
	elseif operator == "Less" then
		if chars_mobs_npcs[index][stat] < value then
			return ifsuccess;
		end;
	elseif operator == "More" then
		if chars_mobs_npcs[index][stat] > value then
			return ifsuccess;
		end;
	elseif operator == "LessEqual" then
		if chars_mobs_npcs[index][stat] <= value then
			return ifsuccess;
		end;
	elseif operator == "MoreEqual" then
		if chars_mobs_npcs[index][stat] >= value then
			return ifsuccess;
		end;
	end;
	return ifnot;
end;

function chat_functions.ifSkill(index, skill,mode,operator,value,ifsuccess,ifnot)
	local limit1 = nil;
	local limit2 = nil;
	local num1 = chars_mobs_npcs[limit1]["num_" .. subtyp];
	local lvl1 = chars_mobs_npcs[limit1]["lvl_" .. subtyp];
	local tot1 = num1*lvl1;
	local num2 = chars_mobs_npcs[limit2]["num_" .. subtyp];
	local lvl2 = chars_mobs_npcs[limit2]["lvl_" .. subtyp];
	local tot2 = num2*lvl2;
	if mode == "num" then
		limit1 = num1;
		limit2 = num2;
	elseif mode == "lvl" then
		limit1 = lvl1;
		limit2 = lvl2;
	elseif mode == "total" then
		limit1 = tot1;
		limit2 = tot2;
	end;
	if     operator == "Equal" then
		if limit1 == value then
			return ifsuccess;
		end;
	elseif operator == "NotEqual" then
		if limit1 ~= value then
			return ifsuccess;
		end;
	elseif operator == "Less" then
		if limit1 < value then
			return ifsuccess;
		end;
	elseif operator == "More" then
		if limit1 > value then
			return ifsuccess;
		end;
	elseif operator == "LessEqual" then
		if limit1 <= value then
			return ifsuccess;
		end;
	elseif operator == "MoreEqual" then
		if limit1 >= value then
			return ifsuccess;
		end;
	end;
	return ifnot;
end;

function chat_functions.ifPartyCharisma(operator,value,ifsuccess,ifnot)
	local partycharisma = 0;
	for i=1,chars do
		if chars_mobs_npcs[i].control == "player" and chars_mobs_npcs[i].status ==1 and chars_mobs_npcs[i].stone == 0 and chars_mobs_npcs[i].sleep and chars_mobs_npcs[i].freeze == 0
		and chars_mobs_npcs[i].stealth == 0 and chars_mobs_npcs[i].invisibility == 0 
		and helpers.ifMobIsNotFar(victim,current_mob) then
			partycharisma = partycharisma + chars_mobs_npcs[i].chr;
		end;
		local tmp = partycharisma;
		if  operator == "Equal" and tmp == value then
			return ifsuccess;
		elseif   operator == "NotEqual" and tmp ~= value then
			return ifsuccess;
		elseif   operator == "More" and tmp > value then
			return ifsuccess;
		elseif  operator == "Less" and tmp < value then
			return ifsuccess;
		elseif   operator == "MoreEqual" and tmp >= value then
			return ifsuccess;
		elseif  operator == "LessEqual" and tmp <= value then
			return ifsuccess;
		end;
	end;
	return ifnot;
end;

function chat_functions.ifMediumCharisma(operator,value,ifsuccess,ifnot)
	local partycharisma = 0;
	local chars = 0;
	for i=1,chars do
		if chars_mobs_npcs[i].control == "player" and chars_mobs_npcs[i].status ==1 and chars_mobs_npcs[i].stone == 0 and chars_mobs_npcs[i].sleep and chars_mobs_npcs[i].freeze == 0
		and chars_mobs_npcs[i].stealth == 0 and chars_mobs_npcs[i].invisibility == 0 
		and helpers.ifMobIsNotFar(victim,current_mob) then
			partycharisma = partycharisma + chars_mobs_npcs[i].chr;
			chars = chars + 1;
		end;
		local tmp = math.ceil(partycharisma/math.max(1,chars));
		if  operator == "Equal" and tmp == value then
			return ifsuccess;
		elseif   operator == "NotEqual" and tmp ~= value then
			return ifsuccess;
		elseif   operator == "More" and tmp > value then
			return ifsuccess;
		elseif  operator == "Less" and tmp < value then
			return ifsuccess;
		elseif   operator == "MoreEqual" and tmp >= value then
			return ifsuccess;
		elseif  operator == "LessEqual" and tmp <= value then
			return ifsuccess;
		end;
	end;
	return ifnot;
end;

function chat_functions.ifReputation(value,operator,ifsuccess,ifnot)
	return ifnot;
end;

function chat_functions.ifQuestsGot(quests_array,ifsuccess,ifnot)
	for i=1, #party.quests do
		for h=1,#quests_array do
			if party.quests[i].id == quests_array[h] then
				return ifsuccess;
			end;
		end;
	end;
	return ifnot;
end;
	
function chat_functions.ifQuestPart(quest_id,quest_part,done,ifsuccess,ifnot)
	for i=1, #party.quests do
		for h=1,#quest_array do
			if party.quests[i].id == quest_id and party.quests[i][stages][quest_part] and (not done and not party.quests[i].done) or (done and party.quests[i].done) then
				return ifsuccess;
			end;
		end;
	end;
	return ifnot;
end;

function chat_functions.ifQuestInProgress(quests_array,quest_part,done,ifsuccess,ifnot)
	for i=1, #party.quests do
		for h=1,#quest_array do
			if party.quests[i].id == quest_id and party.quests[i][stages][quest_part] and (not done and not party.quests[i].done) or (done and party.quests[i].done) then
				return ifsuccess;
			end;
		end;
	end;
	return ifnot;
end;

function chat_functions.ifQuestsDone(quest_id,ifsuccess,ifnot)
	for i=1, #party.quests do
		if party.quests[i].id == quests_id and not party.quests[i].done then
			return ifsuccess;
		end;
	end;
	return ifnot;
end;
		
function chat_functions.ifInformationGot(info_array,ifsuccess,ifnot)
	for i=1, #party.secrets do
		for h=1,#info_array do
			if party.secrets[i] == info_array[h] then
				return ifsuccess;
			end;
		end;
	end;
	return ifnot;
end;

function chat_functions.ifPartyGold(operator,value,ifsuccess,ifnot)
	if operator == "Equal" then
		if party.gold == value then
			return ifsuccess;
		end;
	elseif operator == "NotEqual" then
		if party.gold ~= value then
			return ifsuccess;
		end;	
	elseif operator == "Less" then
		if party.gold < value then
			return ifsuccess;
		end;
	elseif operator == "More" then
		if party.gold > value then
			return ifsuccess;
		end;
	elseif operator == "LessEqual" then
		if party.gold <= value then
			return ifsuccess;
		end;
	elseif operator == "MoreEqual" then
		if party.gold >= value then
			return ifsuccess;
		end;
	end;
	return ifnot;
end;

function chat_functions.ifEtiquette(index,operator,etiquette,ifsuccess,ifnot)
	if operator == "Equal" and chars_mobs_npcs[index].etiquette == etiquette then
		return ifsuccess;
	elseif operator == "NotEqual" and chars_mobs_npcs[index].etiquette ~= etiquette then
		return ifsuccess;
	end;
	return ifnot;
end;

function chat_functions.ifItem(item,ifsuccess,ifnot)
	for i=1,#chars_mobs_npcs[current_mob]["inventory_list"] do
		if #chars_mobs_npcs[current_mob]["inventory_list"][i].ttxid == item then
			return ifsuccess;
		end;
	end;
	return ifnot;
end;

function chat_functions.ifRace(index,race,ifsuccess,ifnot)
	if chars_mobs_npcs[index].race == race then
		return ifsuccess;
	end;
	return ifnot;
end;

function chat_functions.ifNature(index,nature,ifsuccess,ifnot)
	if chars_mobs_npcs[index].nature == nature then
		return ifsuccess;
	end;
	return ifnot;
end;

function chat_functions.ifClass(index,class,ifsuccess,ifnot)
	if chars_mobs_npcs[index].class == class then
		return ifsuccess;
	end;
	return ifnot;
end;

function chat_functions.ifLevel(index,operator,value,ifsuccess,ifnot)
	if operator == "Equal" then
		if chars_mobs_npcs[index].lv == value then
			return ifsuccess;
		end;
	elseif operator == "NotEqual" then
		if chars_mobs_npcs[index].lv ~= value then
			return ifsuccess;
		end;
	elseif operator == "Random100" then
		local rnd = math.random(1,100);
		if chars_mobs_npcs[index].lv >= rnd then
			return ifsuccess;
		end;
	elseif operator == "Less" then
		if chars_mobs_npcs[index].lv < value then
			return ifsuccess;
		end;
	elseif operator == "More" then
		if chars_mobs_npcs[index].lv > value then
			return ifsuccess;
		end;
	elseif operator == "LessEqual" then
		if chars_mobs_npcs[index].lv <= value then
			return ifsuccess;
		end;
	elseif operator == "MoreEqual" then
		if chars_mobs_npcs[index].lv >= value then
			return ifsuccess;
		end;
	end;
	return ifnot;
end;

function chat_functions.randomAnswer(chatq)
	local rnd = math.random(1,#chatq);
	return chatq[rnd];
end;

function chat_functions.changeFractionRelations(phrase,fracs) --fracs = {{fraction1,fraction2,value},{fraction1,fraction2,value},{fraction1,fraction2,value}}
	for i=1,#fracs do
		fractions[fracs[i][1]][fracs[i][2]] = fractions[fracs[i][1]][fracs[i][2]] + fracs[i][3];
		fractions[fracs[i][2]][fracs[i][1]] = fractions[fracs[i][2]][fracs[i][1]] + fracs[i][3];
		helpers.addToActionLog(lognames.actions.fractions_relations_changed);
	end;
	return phrase;
end;

function chat_functions.questCompleted(phrase,qas) --qas = {{quest_id,stage_id,{...}}
	for i=1,#party.quests do
		for h=1,#qas do
			if party.quests[i].id == qas[h][1] then
				party.quests[i].stage = qas[h][2];
				party.quests[i].done = true;
				local divisor = 0;
				if quests[qas[h][1]][qas[h][2]].done then
					helpers.addToActionLog(lognames.actions.quest_done);
					--utils.playSfx(media.sounds.questdone,1);	
				end;
				if quests[qas[h][1]][qas[h][2]].xp then
					for i=1,chars do
						if chars_mobs_npcs[i].status == 1 and chars_mobs_npcs[i].stone == 0 and chars_mobs_npcs[i].freeze == 0 then
							divisor = divisor + 1;
						end;
					end;
					for i=1,chars do
						if chars_mobs_npcs[i].status == 1 and chars_mobs_npcs[i].stone == 0 and chars_mobs_npcs[i].freeze == 0 then
							local xp =  math.ceil(quests[qas[h][1]][qas[h][2]]/divisor);
							chars_mobs_npcs[i].xp = chars_mobs_npcs[i].xp + xp;
							helpers.addToActionLog( chars_stats[i].name .. lognames.actions.got[chars_mobs_npcs[current_mob].gender] .. xp .. lognames.actions.ofexp);
						end;
					end;	
					--utils.playSfx(media.sounds.exp,1);	
				end;
				if quests[qas[h][1]][qas[h][2]].promotion then
					for i=1,chars do
						if chars_mobs_npcs[i].class == chars_mobs_npcs[i]["oldclass"] then
							chars_mobs_npcs[i].class = chars_mobs_npcs[i]["newclass"];
							helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.gotpromotion[i][gender]);
							--utils.playSfx(media.sounds.promotion,1);
						end;
					end;
				end;
				if quests[qas[h][1]][qas[h][2]].fractions then
					chat_functions.changeFractionRelations(nil,quests[qas[h][1]][qas[h][2]].fractions);
				end;
				if quests[qas[h][1]][qas[h][2]].gold then
					party.gold = party.gold + quests[qas[h][1]][qas[h][2]].gold;
					utils.playSfx(media.sounds.gold_dzen,1);
					helpers.addToActionLog(lognames.actions.partygot .. quests[qas[h][1]][qas[h][2]].gold .. lognames.actions.withgold);
				end;
				if quests[qas[h][1]][qas[h][2]].items_plus then
					table.insert(bags_list,{x=chars_mobs_npcs[current_mob].x,y=chars_mobs_npcs[index].y,xi= chars_mobs_npcs[current_mob].x,yi= chars_mobs_npcs[index].y,typ="bag",opened=false,locked=false,dir=0,img=bag_img});
					for i=1,#quests[qas[h][1]][qas[h][2]].items_plus do
						table.insert(bags_list[#bags_list],{ttxid=quests[qas[h][1]][qas[h][2]]["items_plus"].ttxid,q=quests[qas[h][1]][qas[h][2]]["items_plus"].q,w=quests[qas[h][1]][qas[h][2]]["items_plus"].w,e=quests[qas[h][1]][qas[h][2]]["items_plus"].e,r=quests[qas[h][1]][qas[h][2]]["items_plus"].r,h=quests[qas[h][1]][qas[h][2]]["items_plus"].h});
						helpers.zeroLastBag ();
						sorttarget = "bag";
						dragfrom="bag"
						current_bag = #bags_list;
						th = #bags_list;
						bagid = #bags_list;
						helpers.resort_inv(bagid);
					end;
				end;
				if quests[qas[h][1]][qas[h][2]].items_minus then
					for i=1,chars do
						for k=1,#quests[qas[h][1]][qas[h][2]].items_minus do
							for j=1,#chars_mobs_npcs[i]["inventory_list"] do
								if quests[qas[h][1]][qas[h][2]]["items_minus"][k] == chars_mobs_npcs[i]["inventory_list"][j].ttxid then
									local given_item = quests[qas[h][1]][qas[h][2]]["items_minus"][k]
									helpers.addToActionLog(helpers.mobName(current_mob) .. lognames.actions.gave[chars_mobs_npcs[current_mob].gender] .. inventory_ttx[chars_mobs_npcs[current_mob]["inventory_list"][given_item].ttxid].title .. lognames.actions.frominv);
									table.remove(chars_mobs_npcs[i]["inventory_list"],given_item);
									helpers.renumber(given_item,i);
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	return phrase;
end;
