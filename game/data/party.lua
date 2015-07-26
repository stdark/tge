function party_load ()
chars=4                               

chars_stats={};
                   
chars_stats[1]={class="rogue", subclass=1, race="human", sprite = "rogue", name="John Doo", face=1, age=25, lv=1, xp=0, nature="humanoid", size="normal", gender=1, horns=0, feet=2, hoofs=0, arms={"rh","lh"}, fov = 180, motion="walking", hexes = 1, hitzones={{"head","rh","lh","rf","lf","body","body","body","body","body"}},
            hp_base_mod = 12, sp_base_mod = 12, st_base_mod = 12,hp_coff = 1, sp_coff = 1, st_coff = 1, etiquette="none", shader={225, 230, 0, 125},
            mgt=5,enu=24,dex=15,spd=25,acu=15,sns=15,int=50,spr=50,chr=25,luk=50, --stats
            hp_regeneration = 0, sp_regeneration = 0, st_regeneration = 0,moral = 20, nightvision = 0, claws = 0, teeth = 0,
            ac=0,dt=0,dr=0,
            rezfire=0, rezcold=0, rezstatic=0, rezpoison=0, rezacid=0, rezmind=0, rezspirit=0, rezdisease=0, rezlight=0, rezdarkness=0,--resistances
            immunities = {},
            spellbook=1, spells={}, warbook = 1, --flags
            multiattack=1, track=1,
            perks={},
            num_unarmed=1,num_dagger=10,num_sword=20,num_axe=1,num_crushing=1,num_flagpole=1,num_staff=1,num_bow=1,num_crossbow=20,num_throwing=1,num_firearms=1,--skills weapon num
            lvl_unarmed=1,lvl_dagger=3,lvl_sword=5,lvl_axe=1,lvl_crushing=1,lvl_flagpole=1,lvl_staff=1,lvl_bow=1,lvl_crossbow=5,lvl_throwing=1,lvl_firearms=1,--skills weapon lv
            num_dodging=5, num_leather=3,num_chainmail=1, num_plate=1,num_shield=20,--skills armor num
            lvl_dodging=2, lvl_leather=1,lvl_chainmail=1, lvl_plate=1,lvl_shield=5,--skills armor lv
            num_fire=25,num_water=20,num_air=20,num_earth=15,num_body=15,num_spirit=1,num_mind=20,num_light=15,num_darkness=20,--skills magic num
            lvl_fire=5,lvl_water=4,lvl_air=5,lvl_earth=4,lvl_body=3,lvl_spirit=1,lvl_mind=5,lvl_light=4,lvl_darkness=4,---skills magic lv
            num_alchemy=20,num_repair=4,num_bodybuilding=1,num_armmastery=1,num_meditation=20,num_mysticism=20,num_trading=1,num_diplomacy=20, num_stealth=1, num_picklocking=15, num_traps=1, num_spothidden=10, num_monsterid=20,num_stuffid=1, num_thievery = 20, num_leadership = 20,num_regeneration = 0,--skills other num
            lvl_alchemy=5,lvl_repair=1,lvl_bodybuilding=1,lvl_armmastery=1,lvl_meditation=5,lvl_mysticism=5,lvl_trading=1,lvl_diplomacy=5, lvl_stealth=1, lvl_picklocking=3, lvl_traps=1, lvl_spothidden=1, lvl_monsterid=5,lvl_stuffid=1, lvl_thievery = 5, lvl_leadership = 5,lvl_regeneration = 0,--skills other lvl
                   }
chars_stats[2]={class="rogue", subclass=1, race="human", sprite = "rogue", name="Johnny Bravo", face=2,  age=25, lv=1, xp=0, nature="humanoid", size="normal", gender=1, horns=0, feet=2, hoofs=0, arms={"rh","lh"}, fov = 180, motion="walking", hexes = 1, hitzones={{"head","rh","lh","rf","lf","body","body","body","body","body"}},
            hp_base_mod = 12, sp_base_mod = 12, st_base_mod = 12,hp_coff = 1, sp_coff = 1, st_coff = 1, etiquette="criminal", shader={200, 255, 200, 125},
            mgt=26,enu=19,dex=10,spd=15,acu=25,sns=15,int=15,spr=5,chr=5,luk=5, --stats
			hp_regeneration = 0, sp_regeneration = 0, st_regeneration = 0,moral = 20, nightvision = 0, claws = 0, teeth = 0,
            ac=0,dt=0,dr=0,
            rezfire=0, rezcold=0, rezstatic=0, rezpoison=0, rezacid=0, rezmind=0, rezspirit=0, rezdisease=0, rezlight=0, rezdarkness=0,--resistances
            immunities = {},
            spellbook=1, spells={}, warbook = 1, --flags
            multiattack=1, track=1,
            perks={},
            num_unarmed=1,num_dagger=10,num_sword=5,num_axe=0,num_crushing=1,num_flagpole=1,num_staff=1,num_bow=1,num_crossbow=3,num_throwing=1,num_firearms=1,--skills weapon num
            lvl_unarmed=1,lvl_dagger=3,lvl_sword=2,lvl_axe=0,lvl_crushing=1,lvl_flagpole=1,lvl_staff=1,lvl_bow=1,lvl_crossbow=1,lvl_throwing=1,lvl_firearms=1,--skills weapon lv
            num_dodging=5, num_leather=3,num_chainmail=1, num_plate=1,num_shield=20,--skills armor num
            lvl_dodging=2, lvl_leather=1,lvl_chainmail=1, lvl_plate=1,lvl_shield=5,--skills armor lv
            num_fire=25,num_water=20,num_air=20,num_earth=15,num_body=15,num_spirit=1,num_mind=20,num_light=15,num_darkness=20,--skills magic num
            lvl_fire=5,lvl_water=4,lvl_air=5,lvl_earth=4,lvl_body=3,lvl_spirit=1,lvl_mind=5,lvl_light=4,lvl_darkness=4,---skills magic lv
            num_alchemy=20,num_repair=1,num_bodybuilding=1,num_armmastery=1,num_meditation=20,num_mysticism=20,num_trading=1,num_diplomacy=20, num_stealth=1, num_picklocking=15, num_traps=10, num_spothidden=15, num_monsterid=20,num_stuffid=1, num_thievery = 1, num_leadership = 0,num_regeneration = 0,--skills other num
            lvl_alchemy=5,lvl_repair=1,lvl_bodybuilding=1,lvl_armmastery=1,lvl_meditation=5,lvl_mysticism=5,lvl_trading=1,lvl_diplomacy=5, lvl_stealth=1, lvl_picklocking=3, lvl_traps=3, lvl_spothidden=3, lvl_monsterid=5,lvl_stuffid=1, lvl_thievery = 1, lvl_leadership = 0,lvl_regeneration = 0,--skills other lvl
                   }
chars_stats[3]={class="rogue", subclass=1, race="human", sprite = "rogue", name="John Rambo", face=3,  age=25, lv=1, xp=0,  nature="humanoid", size="normal", gender=1, horns=0, feet=2, hoofs=0, arms={"rh","lh"}, fov = 180, motion="walking", hexes = 1, hitzones={{"head","rh","lh","rf","lf","body","body","body","body","body"}},
            hp_base_mod = 12, sp_base_mod = 12, st_base_mod = 12,hp_coff = 1, sp_coff = 1, st_coff = 1, etiquette="warrior", shader={200, 200, 255, 125},
            mgt=5,enu=17,dex=5,spd=10,acu=5,sns=15,int=25,spr=15,chr=5,luk=5, --stats
			hp_regeneration = 0, sp_regeneration = 0, st_regeneration = 0,moral = 20, nightvision = 0, claws = 0, teeth = 0,
            ac=0,dt=0,dr=0,
            immunities = {},
            rezfire=0, rezcold=0, rezstatic=0, rezpoison=0, rezacid=0, rezmind=0, rezspirit=0, rezdisease=0, rezlight=0, rezdarkness=0,--resistances
            spellbook=1, spells={}, warbook = 1, --flags
            multiattack=1, track=1,
            perks={},
            num_unarmed=1,num_dagger=10,num_sword=5,num_axe=0,num_crushing=1,num_flagpole=1,num_staff=1,num_bow=0,num_crossbow=3,num_throwing=1,num_firearms=1,--skills weapon num
            lvl_unarmed=1,lvl_dagger=3,lvl_sword=2,lvl_axe=0,lvl_crushing=1,lvl_flagpole=1,lvl_staff=1,lvl_bow=0,lvl_crossbow=1,lvl_throwing=1,lvl_firearms=1,--skills weapon lv
            num_dodging=5, num_leather=3,num_chainmail=1, num_plate=1,num_shield=20,--skills armor num
            lvl_dodging=2, lvl_leather=1,lvl_chainmail=1, lvl_plate=1,lvl_shield=5,--skills armor lv
            num_fire=25,num_water=20,num_air=20,num_earth=15,num_body=15,num_spirit=1,num_mind=20,num_light=15,num_darkness=20,--skills magic num
            lvl_fire=5,lvl_water=4,lvl_air=5,lvl_earth=4,lvl_body=3,lvl_spirit=1,lvl_mind=5,lvl_light=4,lvl_darkness=4,---skills magic lv
            num_alchemy=20,num_repair=1,num_bodybuilding=1,num_armmastery=1,num_meditation=20,num_mysticism=20,num_trading=1,num_diplomacy=1, num_stealth=1, num_picklocking=15, num_traps=1, num_spothidden=1, num_monsterid=20,num_stuffid=1, num_thievery = 1, num_leadership = 0,num_regeneration = 0,--skills other num
            lvl_alchemy=5,lvl_repair=1,lvl_bodybuilding=1,lvl_armmastery=1,lvl_meditation=5,lvl_mysticism=5,lvl_trading=1,lvl_diplomacy=1, lvl_stealth=1, lvl_picklocking=3, lvl_traps=1, lvl_spothidden=1, lvl_monsterid=5,lvl_stuffid=1, lvl_thievery = 1, lvl_leadership = 0,lvl_regeneration = 0,--skills other lvl
                   }
chars_stats[4]={class="rogue", subclass=1, race="woodelf", sprite = "rogue", name="John Galt", face=7,  age=25,  lv=1, xp=0,  nature="humanoid", size="normal", gender=1, horns=0, feet=2, hoofs=0, arms={"rh","lh"}, fov = 180, motion="walking", hexes = 1, hitzones={{"head","rh","lh","rf","lf","body","body","body","body","body"}},
            hp_base_mod = 12, sp_base_mod = 12, st_base_mod = 12,hp_coff = 1, sp_coff = 1, st_coff = 1, etiquette="noble", shader={255, 125, 255, 125},
            mgt=5,enu=18,dex=5,spd=5,acu=5,sns=15,int=5,spr=15,chr=5,luk=5, --stats
			hp_regeneration = 0, sp_regeneration = 0, st_regeneration = 0,moral = 20, nightvision = 0, claws = 0, teeth = 0,
            ac=0,dt=0,dr=0,
            rezfire=0, rezcold=0, rezstatic=0, rezpoison=0, rezacid=0, rezmind=0, rezspirit=0, rezdisease=0, rezlight=0, rezdarkness=0,--resistances
            immunities = {},
            spellbook=1, spells={}, warbook = 1, --flags
            multiattack=1, track=1,
            perks={},
            num_unarmed=1,num_dagger=10,num_sword=5,num_axe=0,num_crushing=1,num_flagpole=1,num_staff=1,num_bow=0,num_crossbow=3,num_throwing=1,num_firearms=1,--skills weapon num
            lvl_unarmed=1,lvl_dagger=3,lvl_sword=2,lvl_axe=0,lvl_crushing=1,lvl_flagpole=1,lvl_staff=1,lvl_bow=0,lvl_crossbow=1,lvl_throwing=1,lvl_firearms=1,--skills weapon lv
            num_dodging=5, num_leather=3,num_chainmail=1, num_plate=1,num_shield=20,--skills armor num
            lvl_dodging=2, lvl_leather=1,lvl_chainmail=1, lvl_plate=1,lvl_shield=5,--skills armor lv
            num_fire=25,num_water=20,num_air=20,num_earth=15,num_body=15,num_spirit=1,num_mind=20,num_light=15,num_darkness=20,--skills magic num
            lvl_fire=5,lvl_water=4,lvl_air=5,lvl_earth=4,lvl_body=3,lvl_spirit=1,lvl_mind=5,lvl_light=4,lvl_darkness=4,---skills magic lv
            num_alchemy=20,num_repair=1,num_bodybuilding=1,num_armmastery=1,num_meditation=20,num_mysticism=20,num_trading=1,num_diplomacy=1, num_stealth=1, num_picklocking=15, num_traps=1, num_spothidden=1, num_monsterid=20,num_stuffid=0, num_thievery = 1, num_leadership = 0,num_regeneration = 0,--skills other num
            lvl_alchemy=5,lvl_repair=1,lvl_bodybuilding=1,lvl_armmastery=1,lvl_meditation=5,lvl_mysticism=5,lvl_trading=1,lvl_diplomacy=1, lvl_stealth=1, lvl_picklocking=3, lvl_traps=1, lvl_spothidden=1, lvl_monsterid=5,lvl_stuffid=0, lvl_thievery = 1, lvl_leadership = 0,lvl_regeneration = 0,--skills other lvl
                   }               

chars_stats[1].spells={
{1,1,1,1,1,1,1,1,1,1,1,1},	--fire
{1,1,1,1,1,1,1,1,1,1,1,1},	--air
{1,1,1,1,1,1,1,1,1,1,1,1},	--water
{1,1,1,1,1,1,1,1,1,1,1,1},	--earth
--
{1,1,1,1,1,1,1,1,1,1,1,1},	--body
{1,1,1,1,1,1,1,1,1,1,1,1},	--mind
{1,1,1,1,1,1,1,1,1,1,1,1},	--spirit
--
{1,1,1,1,1,1,1,1,1,1,1,1},	--light
{1,1,1,1,1,1,1,1,1,1,1,1},	--darkness
--
{1,1,1,1,1,1,1,1,1,1,1,1},	--conflux
{1,1,1,1,1,1,1,1,1,1,1,1},	--life
{1,1,1,1,1,1,1,1,1,1,1,1},	--nature
{1,1,1,1,1,1,1,1,1,1,1,1},	--distortion
{1,1,1,1,1,1,1,1,1,1,1,1},	--holy
}

chars_stats[2].spells={
{1,0,0,0,0,0,0,0,0,0,0,0},
{1,0,0,0,0,0,0,0,0,0,0,0},
{1,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
--
{1,1,1,1,0,0,1,1,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
--
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
--
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
}


chars_stats[3].spells={
{1,0,1,1,1,1,1,1,0,1,1,1},
{1,1,1,1,1,1,0,0,0,0,0,0},
{1,1,1,1,1,1,0,0,0,0,0,0},
{0,0,0,1,0,0,0,0,0,0,0,0},
--
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
--
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
--
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
}


chars_stats[4].spells={
{1,0,0,0,1,0,0,0,0,0,0,0},
{0,0,1,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
--
{1,1,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
--
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
--
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0},
}

global.warbook_skills = {
{"sword","axe","flagpole"},
{"crushing","staff","dagger"},
{"unarmed","dodging","shield"},
{"bow","crossbow","throwing"},
};
	
for i=1,chars do
	chars_stats[i].warbook={
	{0,0,0,0,0,0,0,0,0,0,0,0}, --sword,axe,spear
	{0,0,0,0,0,0,0,0,0,0,0,0}, --crushing,staff,dagger
	{0,0,0,0,0,0,0,0,0,0,0,0}, --unarmed,dodging,shield
	{0,0,0,0,0,0,0,0,0,0,0,0}, --bow,crossbow,throwing
	};
	for j=1,#global.warbook_skills do
		for k=1,#global.warbook_skills[j] do
			local skill = "lvl_" .. global.warbook_skills[j][k];
			for l=1,4 do
				if chars_stats[i][skill] >= l+1 then
					local order = {
					{1,2,7,8},
					{4,3,10,9},
					{5,6,11,12},
					};
					chars_stats[i]["warbook"][j][order[k][l]] = 1;
				end;
			end;
		end;
	end;
end;

--q quntity, integrity
--w code of key,spell of wand, scroll or book, effect of weapon,armor or jewerly (builtin, oil)
--e power of effect, charge of wand
--r identificated
--h hardened
chars_stats[1].inventory_list={
{ttxid=17,q=1,w=0,e=0,r=1,h=0},
{ttxid=7,q=0,w=1,e=1000,r=1,h=0},
{ttxid=26,q=15,w=0,e=0,r=0,h=0},
{ttxid=132,q=1,w=0,e=0,r=1,h=0},
{ttxid=88,q=1,w=0,e=0,r=1,h=0},
{ttxid=147,q=1,w=0,e=0,r=1,h=0},
{ttxid=67,q=1,w=0,e=0,r=1,h=0},
{ttxid=46,q=1,w=0,e=0,r=1,h=0},
{ttxid=146,q=10,w=0,e=0,r=1,h=0},
{ttxid=221,q=1,w=0,e=0,r=1,h=0},
{ttxid=261,q=20,w=0,e=0,r=1,h=0},
{ttxid=262,q=20,w=0,e=0,r=1,h=0},
{ttxid=171,q=25,w=0,e=0,r=1,h=0},
{ttxid=186,q=10,w=0,e=0,r=1,h=0},
{ttxid=201,q=1,w=0,e=0,r=1,h=0},
{ttxid=231,q=1,w=0,e=0,r=1,h=0},
{ttxid=281,q=32,w=0,e=0,r=1,h=0},
{ttxid=303,q=32,w=0,e=0,r=1,h=0},
{ttxid=477,q=1,w="3232544315",e=0,r=1,h=0},
{ttxid=477,q=1,w="5555555555",e=0,r=1,h=0},
{ttxid=477,q=1,w="7457612465",e=0,r=1,h=0},
{ttxid=478,q=1,w=0,e=0,r=1,h=0},
{ttxid=478,q=1,w=0,e=0,r=1,h=0},
{ttxid=479,q=1,w=0,e=0,r=1,h=0},
{ttxid=389,q=1,w="flamearrow",e=0,r=1,h=0},
{ttxid=423,q=inventory_ttx[423].a,w=0,e=0,r=1,h=0},
{ttxid=423,q=inventory_ttx[423].a,w=0,e=0,r=1,h=0},
{ttxid=424,q=inventory_ttx[424].a,w=0,e=0,r=1,h=0},
{ttxid=425,q=inventory_ttx[425].a,w=0,e=0,r=1,h=0},
{ttxid=426,q=inventory_ttx[426].a,w=0,e=0,r=1,h=0},
{ttxid=427,q=inventory_ttx[427].a,w=0,e=0,r=1,h=0},
{ttxid=463,q=1,w=0,e=0,r=1,h=0},
{ttxid=409,q=1,w=0,e=0,r=1,h=0},
{ttxid=409,q=3,w=0,e=0,r=1,h=0},
{ttxid=409,q=4,w=0,e=0,r=1,h=0},
{ttxid=409,q=12,w=0,e=0,r=1,h=0},
{ttxid=409,q=11,w=0,e=0,r=1,h=0},
{ttxid=376,q=1,w=0,e=0,r=1,h=0},
{ttxid=460,q=1,w=0,e=0,r=1,h=0},
{ttxid=273,q=35,w=0,e=0,r=1,h=0},
{ttxid=315,q=35,w=0,e=0,r=1,h=0},
{ttxid=399,q=1,w=0,e=0,r=1,h=0},
{ttxid=394,q=1,w="flamearrow",e=0,r=1,h=0},
{ttxid=493,q=1,w=0,e=0,r=1,h=0},
{ttxid=494,q=1,w=0,e=0,r=1,h=0},
{ttxid=409,q=14,w=0,e=0,r=1,h=0},
{ttxid=409,q=15,w=0,e=0,r=1,h=0},
{ttxid=409,q=16,w=0,e=0,r=1,h=0},
{ttxid=329,q=16,w=0,e=0,r=1,h=0},
}
chars_stats[2].inventory_list={
{ttxid=111,q=1,w=0,e=0,r=1,h=0},
{ttxid=141,q=10,w=0,e=0,r=1,h=0},
{ttxid=171,q=1,w=0,e=0,r=1,h=0},
{ttxid=186,q=1,w=0,e=0,r=1,h=0},
{ttxid=480,q=1,w=0,e=0,r=1,h=0},
{ttxid=481,q=1,w=0,e=0,r=1,h=0},
{ttxid=482,q=1,w=0,e=0,r=1,h=0},
{ttxid=483,q=1,w=0,e=0,r=1,h=0},
{ttxid=484,q=1,w=0,e=0,r=1,h=0},
{ttxid=485,q=1,w=0,e=0,r=1,h=0},
{ttxid=486,q=1,w=0,e=0,r=1,h=0},
{ttxid=487,q=1,w=0,e=0,r=1,h=0},
{ttxid=488,q=1,w=0,e=0,r=1,h=0},
{ttxid=409,q=13,w=0,e=0,r=1,h=0},
{ttxid=489,q=1,w=0,e=0,r=1,h=0},
{ttxid=329,q=16,w=0,e=0,r=1,h=0},
{ttxid=384,q=2,w="coldbeam",e=0,r=1,h=0},
{ttxid=241,q=1,w=0,e=0,r=1,h=0},
{ttxid=251,q=1,w=0,e=0,r=1,h=0},
{ttxid=394,q=1,w="fear",e=0,r=1,h=0},
{ttxid=498,q=5,w="firebomb",e=0,r=1,h=0},
}
chars_stats[3].inventory_list={
{ttxid=1,q=1,w=0,e=0,r=1,h=0},
{ttxid=26,q=1,w=0,e=0,r=1,h=0},
{ttxid=1,q=1,w=0,e=0,r=1,h=0},
{ttxid=112,q=1,w=0,e=0,r=1,h=0},
{ttxid=141,q=10,w=0,e=0,r=1,h=0},
{ttxid=171,q=1,w=0,e=0,r=1,h=0},
{ttxid=186,q=1,w=0,e=0,r=1,h=0},
{ttxid=490,q=1,w=0,e=0,r=1,h=0},
{ttxid=491,q=1,w=0,e=0,r=1,h=0},
{ttxid=492,q=1,w=0,e=0,r=1,h=0},
}
chars_stats[4].inventory_list={
{ttxid=3,q=1,w=0,e=0,r=1,h=0},
{ttxid=3,q=1,w=0,e=0,r=0,h=0},
{ttxid=3,q=1,w=0,e=0,r=1,h=0},
{ttxid=133,q=1,w=0,e=0,r=1,h=0},
{ttxid=146,q=10,w=0,e=0,r=1,h=0},
{ttxid=171,q=1,w=0,e=0,r=1,h=0},
{ttxid=186,q=1,w=0,e=0,r=1,h=0},
}

inventory_bag={};

for h=1,chars do
	inventory_bag[h]={};
	for i=1,15 do
		inventory_bag[h][i]={};
		for j=1,11 do
			inventory_bag[h][i][j]=0;
		end;
	end;
end;

alchlab = {};
picklock = {};
craft = {};

chars_stats[1].equipment={rh=1,lh=14,ranged=4,ammo=9, armor=13,head=15,boots=0,gloves=0,cloak=0,belt=0,amulet=0,ring1=0,ring2=0,ring3=0,ring4=0,ring5=0,ring6=0,art=0,teeth=0,horns=0,tail=0};
--chars_stats[1].equipment={rh=0,lh=0,ranged=0,ammo=0, armor=0,head=0,boots=0,gloves=0,cloak=0,belt=0,amulet=0,ring1=0,ring2=0,ring3=0,ring4=0,ring5=0,ring6=0,art=0,teeth=0,horns=0,tail=0};
chars_stats[2].equipment={rh=0,lh=0,ranged=0,ammo=0, armor=0,head=0,boots=0,gloves=0,cloak=0,belt=0,amulet=0,ring1=0,ring2=0,ring3=0,ring4=0,ring5=0,ring6=0,art=0,teeth=0,horns=0,tail=0};
chars_stats[3].equipment={rh=0,lh=0,ranged=0,ammo=0, armor=0,head=0,boots=0,gloves=0,cloak=0,belt=0,amulet=0,ring1=0,ring2=0,ring3=0,ring4=0,ring5=0,ring6=0,art=0,teeth=0,horns=0,tail=0};
chars_stats[4].equipment={rh=0,lh=0,ranged=0,ammo=0, armor=0,head=0,boots=0,gloves=0,cloak=0,belt=0,amulet=0,ring1=0,ring2=0,ring3=0,ring4=0,ring5=0,ring6=0,art=0,teeth=0,horns=0,tail=0};

alchlab[1]={tool1=0,tool2=0,tool3=0,tool4=0,tool5=0,tool6=0,bottle1=0,bottle2=0,bottle3=0,comp1=0,comp2=0,comp3=0,comp4=0,comp5=0,comp6=0,comp7=0,comp8=0,comp9=0};
alchlab[2]={tool1=0,tool2=0,tool3=0,tool4=0,tool5=0,tool6=0,bottle1=0,bottle2=0,bottle3=0,comp1=0,comp2=0,comp3=0,comp4=0,comp5=0,comp6=0,comp7=0,comp8=0,comp9=0};
alchlab[3]={tool1=0,tool2=0,tool3=0,tool4=0,tool5=0,tool6=0,bottle1=0,bottle2=0,bottle3=0,comp1=0,comp2=0,comp3=0,comp4=0,comp5=0,comp6=0,comp7=0,comp8=0,comp9=0};
alchlab[4]={tool1=0,tool2=0,tool3=0,tool4=0,tool5=0,tool6=0,bottle1=0,bottle2=0,bottle3=0,comp1=0,comp2=0,comp3=0,comp4=0,comp5=0,comp6=0,comp7=0,comp8=0,comp9=0};

picklock[1]={tool1=0,tool2=0,tool3=0,tool4=0,key=0,picklock=0,traptool=0,forcer=0};
picklock[2]={tool1=0,tool2=0,tool3=0,tool4=0,key=0,picklock=0,traptool=0,forcer=0};
picklock[3]={tool1=0,tool2=0,tool3=0,tool4=0,key=0,picklock=0,traptool=0,forcer=0};
picklock[4]={tool1=0,tool2=0,tool3=0,tool4=0,key=0,picklock=0,traptool=0,forcer=0};
end

party = {};

party.threats = {1,2,3,4,5,6,7};

party.secrets = {1,2,3}; --npc_id,secret_id (all six reactions)

party.ob = {{},{},{}}; --npc,fraction

party.guilds = {}; --guild_id

party.regalia = {}; --regalia

party.jokes = {1,2,3};

party.nlps={1,2,3};

party.affronts={1};

party.connections = {"nilslarsen"};

party.gold = 9800000;

party.quests = {
{id=1,stages={true,true,true,false,false},done=false},
{id=2,stages={true,true,true,true,false},done=false},
}

party.known_fountains = {};
