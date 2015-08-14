defaults = {};

defaults.racestats = { -- resistances!
human_continental={index=1,active=true,skills={"diplomacy","leadership","trading"},stats={mgt=5,enu=5,spd=5,dex=5,acu=6,sns=5,int=6,spr=7,chr=9,luk=5},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
human_krewlod={index=2,active=true,skills={"bodybuilding","armmastery","leadership"},stats={mgt=7,enu=5,spd=6,dex=6,acu=5,sns=6,int=5,spr=7,chr=4,luk=5},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
human_islander={index=3,active=true,skills={"bodybuilding","flagpole","throwing"},stats={mgt=7,enu=6,spd=5,dex=5,acu=5,sns=5,int=5,spr=7,chr=3,luk=5},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
human_enroth={index=4,active=true,skills={"meditation","mysticism","bodybuilding"},stats={mgt=5,enu=5,spd=5,dex=5,acu=5,sns=5,int=5,spr=7,chr=9,luk=7},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
human_regnan={index=5,active=true,skills={"sword","picklocking","trap"},stats={mgt=5,enu=5,spd=5,dex=5,acu=5,sns=5,int=5,spr=7,chr=9,luk=7},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
human_nihon={index=6,active=true,skills={"dagger","alchemy","mysticism"},stats={mgt=5,enu=5,spd=5,dex=5,acu=5,sns=5,int=7,spr=7,chr=5,luk=5},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 10}},
elf_wood={index=7,active=true,skills={"bow","meditation","monsterid"},stats={mgt=3,enu=3,spd=5,dex=5,acu=9,sns=5,int=9,spr=8,chr=7,luk=5},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
elf_dark={index=8,active=true,skills={"bow","trading","diplomacy"},stats={mgt=3,enu=3,spd=5,dex=5,acu=9,sns=5,int=9,spr=8,chr=3,luk=9},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 10}},
elf_snow={index=9,active=true,skills={"leadership","meditation","mysticism"},stats={mgt=3,enu=3,spd=5,dex=5,acu=9,sns=5,int=9,spr=8,chr=5,luk=8},resistances={rezfire = 0, rezcold = 10, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
dwarf={index=10,active=true,skills={"axe","trading","repair"},stats={mgt=6,enu=9,spd=4,dex=6,acu=4,sns=5,int=4,spr=7,chr=10,luk=5},resistances={rezfire = 5, rezcold = 5, rezstatic = 5, rezpoison = 5, rezacid = 5, rezdisease = 5, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
dwarf_dark={index=11,active=true,skills={"crossbow","traps","picklocking"},stats={mgt=8,enu=8,spd=9,dex=9,acu=4,sns=5,int=4,spr=7,chr=3,luk=3},resistances={rezfire = 3, rezcold = 3, rezstatic = 3, rezpoison = 3, rezacid = 3, rezdisease = 3, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 10}},
hobgoblin={index=12,active=true,skills={"armmastery","sword","bodybuilding"},stats={mgt=9,enu=7,spd=8,dex=7,acu=7,sns=5,int=6,spr=5,chr=3,luk=3},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
nordling={index=13,active=false,skills={"stealth","throwing","spothidden"},stats={mgt=6,enu=6,spd=8,dex=8,acu=8,sns=6,int=6,spr=6,chr=3,luk=3},resistances={rezfire = 0, rezcold = 20, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}};
goblin={index=14,active=false,skills={"stealth","thievery","spothidden"},stats={mgt=7,enu=5,spd=9,dex=8,acu=5,sns=5,int=6,spr=7,chr=6,luk=1},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 10, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}};
ogre={index=15,active=false,skills={"spirit","staff","bodybuilding"},stats={mgt=10,enu=10,spd=5,dex=5,acu=4,sns=5,int=5,spr=6,chr=7,luk=3},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 20, rezlight = 0, rezdarkness = 0}},
orc={index=16,active=false,skills={"armmastery","crossbow","axe"},stats={mgt=9,enu=9,spd=8,dex=8,acu=8,sns=5,int=6,spr=3,chr=3,luk=1},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 10, rezacid = 0, rezdisease = 10, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
troll={index=17,active=false,skills={"crushing","unarmed","regeneration"},stats={mgt=18,enu=18,spd=3,dex=3,acu=3,sns=5,int=3,spr=3,chr=3,luk=1},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 20, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
minotaur={index=18,active=false,skills={"axe","spirit","mysticism"},stats={mgt=15,enu=12,spd=5,dex=5,acu=4,sns=5,int=3,spr=4,chr=4,luk=3},resistances={rezfire = 10, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 10, rezspirit = 10, rezlight = 0, rezdarkness = 0}},
halfling={index=19,active=false,skills={"dodging","stealth","spothidden"},stats={mgt=3,enu=4,spd=8,dex=9,acu=7,sns=5,int=5,spr=7,chr=5,luk=7},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
gremlin={index=20,active=false,skills={"repair","trap","picklocking"},stats={mgt=4,enu=4,spd=8,dex=10,acu=8,sns=5,int=5,spr=7,chr=3,luk=1},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
lizardman={index=21,active=false,skills={"bow","alchemy","regeneration"},stats={mgt=4,enu=6,spd=7,dex=9,acu=8,sns=5,int=8,spr=6,chr=6,luk=1},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 20, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
ratman={index=22,active=false,skills={"thievery","picklocking","trap"},stats={mgt=4,enu=4,spd=9,dex=9,acu=8,sns=5,int=8,spr=6,chr=6,luk=9},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 20, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
gnoll={index=23,active=false,skills={"crushing","shield","spothidden"},stats={mgt=7,enu=7,spd=6,dex=7,acu=5,sns=5,int=10,spr=5,chr=5,luk=3},resistances={rezfire = 0, rezcold = 5, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 5, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
kobold={index=24,active=false,skills={"spothidden","stealth","dagger"},stats={mgt=5,enu=6,spd=8,dex=8,acu=8,sns=5,int=8,spr=3,chr=3,luk=1},resistances={rezfire = 0, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
kreegan={index=25,active=false,skills={"fire","unarmed","dodging"},stats={mgt=9,enu=9,spd=9,dex=9,acu=6,int=5,sns=5,spr=6,chr=1,luk=1},resistances={rezfire = 50, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
demon={index=26,active=false,skills={"trading","diplomacy","leadership"},stats={mgt=7,enu=7,spd=7,dex=7,acu=7,sns=5,int=7,spr=7,chr=1,luk=5},resistances={rezfire = 20, rezcold = 0, rezstatic = 0, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
halfgeany={index=26,active=false,skills={"air","mysticism","trading"},stats={mgt=6,enu=6,spd=6,dex=6,acu=6,sns=5,int=9,spr=9,chr=3,luk=4},resistances={rezfire = 0, rezcold = 0, rezstatic = 20, rezpoison = 0, rezacid = 0, rezdisease = 0, rezmind = 0, rezspirit = 0, rezlight = 0, rezdarkness = 0}},
};

defaults.classstats = {
fighter={mgt=4,enu=3,spd=2,dex=2,acu=2,sns=2,int=0,spr=0,chr=0,luk=0},
tricker={mgt=2,enu=1,spd=3,dex=3,acu=3,sns=3,int=0,spr=0,chr=0,luk=0},
acolyte={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=15,spr=0,chr=0,luk=0},
novice={mgt=1,enu=2,spd=0,dex=0,acu=0,sns=0,int=0,spr=12,chr=0,luk=0},
};

defaults.classskills_ = {
fighter={melee={"sword","axe","flagpole","crushing","unarmed"},spec={},add={"armmastery","bodybuilding","bow","throwing","shield"}},
tricker={melee={"dagger","unarmed","sword"},spec={"stealth","picklocking","thievery","traps"},add={"spothidden","throwing","crossbow"}},
acolyte={melee={"dagger","staff"},spec={"fire","water","air","earth"},add={"alchemy","stuffid","meditation","mysticism"}},
novice={melee={"crushing","staff","unarmed"},spec={"body","mind","spirit"},add={"alchemy","shield","meditation","mysticism"}}
};

defaults.classskills = {
fighter={"sword","axe","flagpole","crushing","unarmed","armmastery","bodybuilding","bow","throwing","shield"},
tricker={"dagger","unarmed","sword","stealth","picklocking","thievery","traps","spothidden","throwing","crossbow"},
acolyte={"dagger","staff","fire","water","air","earth","alchemy","stuffid","meditation","mysticism"},
novice={"crushing","staff","unarmed","body","mind","spirit","alchemy","shield","meditation","mysticism"}
};

defaults.male_names = {
{
"Aaron",
"Abe",
"Abel",
"Adam",
"Adrian",
"Ahmed",
"Al",
"Alan",
"Albert",
"Alexander",
"Ali",
"Alton",
"Alvin",
"Ambrose",
"Amos",
"Andrew",
"Anthony",
"Arnold",
"Arthur",
"Barett",
"Bart",
"Bele",
"Benedict",
"Benjamin",
"Bob",
"Brad",
"Brent",
"Bruce",
"Bruno",
"Cal",
"Caleb",
"Cameron",
"Carl",
"Carlos",
"Ceasar",
"Cedric",
"Charles",
"Christian",
"Chuck",
"Clark",
"Cyrano",
"Daniel",
"Desmond",
"Dustin",
"Edgar",
"Edward",
"Elton",
"Ervin",
"Eugene",
"Fabian",
"Ferdinand",
"Frank",
"Gary",
"Guillerno",
"Gus",
"Guy",
"Hank",
"Harcourt",
"Hector",
"Henry",
"Hernert",
"Horace",
"Howard",
"Jack",
"Jaime",
"James",
"Jean",
"John",
"Joshua",
"Kurl",
"Lazare",
"Lewis",
"Louis",
"Luke",
"Manfred",
"Mark",
"Maxwell",
"Micle",
"Morton",
"Nicolas",
"Norman",
"Patrick",
"Paul",
"Phil",
"Ramsey",
"Reginald",
"Robert",
"Roderick",
"Roger",
"Scott",
"Sethrick",
"Sherlock",
"Sherman",
"Simon",
"Tarvick",
"Victor",
"Wade",
"Walton",
"Warren",
"William",
"Zack"
},
{
"Aznog",
"Hamlet",
"Toognor",
"Urtharg",
"Zoltahn",
},
};

defaults.names={
human_continental={{"Roderick","Tarvick","Sethrick","Caleb","Ceasar"},{"Anna","Andrea"}},
human_krewlod={{"Giltor","Milgor","Dendor"},{}},
human_islander={{"Mbvana","Mbenge","Kvaba"},{"Mzini","Llucky","Oo"}},
human_enroth={{},{}},
human_regnan={{},{}},
human_nihon={{},{}},
elf_wood={{"Maerin","Dalerin","Kyriin"},{"Alexis"}},
elf_dark={{"Jerar"},{"Josephine"}},
elf_snow={{"Yoloo","Niloo","Keloo"},{}},
dwarf={{"Gortar","Arkgar","Dugkar"},{}},
dwarf_dark={{},{}},
hobgoblin={{"Toognor", "Aznog", "Urtharg"},{}},
goblin={{},{}},
ogre={{},{}},
orc={{},{}},
troll={{},{}},
minotaur={{},{}},
halfling={{},{}},
gremlin={{},{}},
lizardman={{},{}},
ratman={{},{}},
gnoll={{},{}},
kobold={{},{}},
kreegan={{},{}},
demon={{},{}},
halfgeany={{},{}},
};

defaults.etiquette={
human_continental="none",
human_krewlod="none",
human_islander="none",
human_enroth="none",
human_regnan="none",
human_nihon="none",
elf_wood="none",
elf_dark="none",
elf_snow="none",
dwarf="none",
dwarf_dark="none",
hobgoblin="none",
goblin="none",
ogre="none",
orc="none",
troll="none",
minotaur="none",
halfling="none",
gremlin="none",
lizardman="none",
ratman="none",
gnoll="none",
kobold="none",
kreegan="none",
demon="none",
halfgeany="none",
};

defaults.weaponSetA={sword=1,axe=26,flagpole=46,crushing=66,staff=100,dagger=86,unarmed=440};
defaults.weaponSetB={sword=16,axe=26,flagpole=52,crushing=66,staff=100,dagger=96,unarmed=440};
defaults.weaponSetC={sword=11,axe=26,flagpole=62,crushing=66,staff=100,dagger=96,unarmed=440};
defaults.weaponSetD={sword=6,axe=31,flagpole=46,crushing=66,staff=100,dagger=96,unarmed=440};
defaults.rangeWeaponSet={bow=111,crossbow=131,throwing=156};
defaults.ammoSet={bow=141,crossbow=146,throwing=151};

defaults.Spells={
fire={"flamearrow","torchlight"},
air={"staticcharge","shocker"},
water={"coldbeam","poisonedspit"},
earth={"razors","mobility"},
body={"heal","harm"},
mind={"fear","mindblast"},
spirit={"spiritualarrow","fate"},
light={"lightbolt","lightspark"},
darkness={"raisedead","darkgasp"};
};

defaults.classSkills={
fighter={"sword","axe","flagpole","crushing","unarmed"},
tricker={"thievery","picklocking","traps","stealth"},
acolyte={"fire","air","water","earth"},
novice={"body","mind","spirit"},
};

skills={"unarmed","sword","axe","flagpole","crushing","staff","dagger","bow","crossbow","throwing","firearms",
"dodging","leather","chainmail","plate","shield",
"fire","water","air","earth","body","mind","spirit","light","darkness",
"alchemy","repair","stuffid","stealth","picklocking","traps","spothidden","monsterid","thievery",
"bodybuilding","armmastery","meditation","mysticism",
"trading","thievery","diplomacy","leadership","regeneration","music",
};

stats={"mgt","enu","spd","dex","acu","sns","int","spr","luk","chr"};

rezs={"rezfire","rezcold","rezstatic","rezacid","rezpoison","rezdisease","rezmind","rezspirit","rezlight","rezdarkness"};

elements={"fire","cold","static","acid","poison","disease","mind","spirit","light","darkness"};

points_for_upgrade={5,10,15,20};
