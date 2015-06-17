function items_modifers_load () --FIXME check inventory ttx oil/trioil for indexes
items_modifers={

--оружие ближнего боя и боеприпасы

{id=1,name="огня",damage={hp={value=5,element="fire"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="огонь 5"},
{id=2,name="пламени",damage={hp={value=10,element="fire"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={flame={lvl=1,num=5,element="fire"}},personalities={},lv=2,timer=1000,price=1000,description="огонь 10"},
{id=3,name="испепеления",damage={hp={value=15,element="fire"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={flame={lvl=3,num=10,element="fire"}},personalities={},lv=3,timer=1000,price=3000,description="огонь 15"},

{id=4,name="холода",damage={hp={value=5,element="cold"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="холод 5"},
{id=5,name="мороза",damage={hp={value=10,element="cold"},st={value=5,element="cold"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={cold={lvl=1,num=5,element="cold"}},personalities={},lv=2,timer=1000,price=1000,description="холод 10"},
{id=6,name="стужи",damage={hp={value=5,element="cold"},st={value=10,element="cold"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={cold={lvl=3,num=10,element="cold"}},personalities={},lv=3,timer=1000,price=3000,description="холод 15"},

{id=7,name="искр",damage={hp={value=5,element="static"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="статика 5"},
{id=8,name="молнии",damage={hp={value=10,element="static"},rt={value=5,element="static"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="статика 10"},
{id=9,name="грозы",damage={hp={value=15,element="static"},rt={value=10,element="static"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="статика 15"},

{id=10,name="отравы",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={poison={lvl=1,num=5,element="poison"}},personalities={},lv=1,timer=1000,price=500,description="яд 5"},
{id=11,name="яда",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={poison={lvl=3,num=10,element="poison"}},personalities={},lv=2,timer=1000,price=1000,description="яд 45"},
{id=12,name="токсичности",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={poison={lvl=5,num=20,element="poison"}},personalities={},lv=3,timer=1000,price=3000,description="яд 100"},

{id=13,name="коррозии",damage={hp={value=5,element="acid"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={acid={lvl=1,num=5,element="acid"}},personalities={},lv=1,timer=1000,price=500,description="кислота 5"},
{id=14,name="кислоты",damage={hp={value=10,element="acid"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={acid={lvl=3,num=10,element="acid"}},personalities={},lv=2,timer=1000,price=1000,description="кислота 45"},
{id=15,name="растворения",damage={hp={value=15,element="acid"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={acid={lvl=5,num=20,element="acid"}},personalities={},lv=3,timer=1000,price=3000,description="кислота 100"},

{id=14,name="боли",damage={hp={value=5,element="mind"},rt={value=5,element="mind"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="ментал 5"},
{id=15,name="страданий",damage={hp={value=10,element="mind"},rt={value=5,element="mind"},st={value=5,element="mind"},},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="ментал 10"},
{id=16,name="истязаний",damage={hp={value=15,element="mind"},rt={value=5,element="mind"},st={value=5,element="mind"},sp={value=5,element="mind"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="ментал 15"},

{id=17,name="бездуховност",damage={hp={value=5,element="spirit"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="дух 5"},
{id=18,name="безблагодатности",damage={hp={value=10,element="spirit"},sp={value=5,element="spirit"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="дух 10"},
{id=19,name="душегубства",damage={hp={value=15,element="spirit"},sp={value=10,element="spirit"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="дух 15"},

{id=20,name="вспышки",damage={hp={value=5,element="light"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="свет 5"},
{id=21,name="света",damage={hp={value=10,element="light"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={blind={lvl=1,num=5,element="light"}},dots={},personalities={},lv=2,timer=1000,price=1000,description="свет 10"},
{id=22,name="сияния",damage={hp={value=15,element="light"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={blind={lvl=3,num=10,element="light"}},dots={},personalities={},lv=3,timer=1000,price=3000,description="свет 15"},

{id=23,name="тени",damage={hp={value=5,element="darkness"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="тьма 5"},
{id=24,name="сумерек",damage={hp={value=10,element="darkness"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={darkgasp={lvl=1,num=5,element="darkness"}},dots={},personalities={},lv=2,timer=1000,price=1000,description="тьма 10"},
{id=25,name="тьмы",damage={hp={value=15,element="darkness"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={darkgasp={lvl=3,num=10,element="darkness"}},dots={},personalities={},lv=3,timer=1000,price=3000,description="тьма 15"},

{id=26,name="льда",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={freeze={lvl=1,num=5,"cold"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="заморозка 5"},
{id=27,name="оледенения",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={freeze={lvl=3,num=10,"cold"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="заморозка 30"},
{id=28,name="мерзлоты",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={freeze={lvl=5,num=20,"cold"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="заморозка 100"},

{id=29,name="окаменения",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={stone={lvl=1,num=5,false}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="окаменение 5"},
{id=30,name="медузы",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={stone={lvl=3,num=10,false}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="окаменение 30"},
{id=31,name="ваислиска",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={stone={lvl=5,num=20,false}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="окаменение 100"},

{id=32,name="обездвиживания",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={paralyze={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="паралич 5"},
{id=33,name="пареза",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={paralyze={lvl=3,num=10,"mind"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="паралич 30"},
{id=34,name="паралича",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={paralyze={lvl=5,num=20,"mind"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="паралич 100"},

{id=35,name="кровеотворения",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={bleeding={lvl=1,num=5,false}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="кровотечение 5"},
{id=36,name="кровотечения",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={bleeding={lvl=3,num=10,false}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="кровотечение 30"},
{id=37,name="кровепотери",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={bleeding={lvl=5,num=20,false}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="кровотечение 100"},

{id=38,name="шока",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={stun={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="оглушение 5"},
{id=39,name="ошеломления",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={stun={lvl=3,num=10,"mind"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="оглушение 30"},
{id=40,name="оглушения",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={stun={lvl=5,num=20,"mind"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="оглушение 100"},

{id=41,name="усмирения",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="шарм 5"},
{id=42,name="умиротворения",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=3,num=10,"mind"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="шарм 30"},
{id=43,name="нирваны",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=5,num=20,"mind"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="шарм 100"},

{id=44,name="дремоты",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="сон 5"},
{id=45,name="сна",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=3,num=10,"mind"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="сон 30"},
{id=46,name="морфея",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=5,num=20,"mind"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="сон 100"},

{id=47,name="страха",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={fear={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="страх 5"},
{id=48,name="паники",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={fear={lvl=3,num=10,"mind"},panic={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="страх и паника 30/5"},
{id=49,name="террора",damage={},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={fear={lvl=5,num=20,"mind"},panic={lvl=3,num=10,"mind"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="страх и паника 100/30"},

{id=50,name="манасожжения",damage={sp={value=5,element="mind"},sp={value=5,element="spirit"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="сжигание маны 10"},
{id=51,name="антимагии",damage={sp={value=10,element="mind"},sp={value=10,element="spirit"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={flame={lvl=1,num=5,element="fire"}},personalities={},lv=2,timer=1000,price=1000,description="сжигание маны 15"},
{id=52,name="безмагии",damage={sp={value=15,element="mind"},sp={value=15,element="spirit"}},atkadd={},addself={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={flame={lvl=3,num=10,element="fire"}},personalities={},lv=3,timer=1000,price=3000,description="сжигание маны 20"},
--[[
арахнофобии
веганоненавистничества
???

{id=55,name="гигантомании",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="zero",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={},dots={},victimrace=0,victimclass=0,victimnature=0,victimgender=0,victimsize="giant",victimracemod=1,victimclassmod=1,victimnaturemod=1,victimgendermod=1,victimsizemod=2,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=500,description="двойной ущерб гигантам"},
{id=56,name="гадофобии",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="zero",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={},dots={},victimrace=0,victimclass=0,victimnature="reptile",victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=2,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=500,description="двойной ущерб рептилиям"},
{id=57,name="мизантропии",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="zero",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={},dots={},victimrace=0,victimclass=0,victimnature="humanoid",victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=2,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=500,description="двойной ущерб гуманоидам"},

{id=58,name="драконоборства",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="zero",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={},dots={},victimrace=0,victimclass=0,victimnature="dragon",victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=2,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=500,description="двойной ущерб драконам"},
{id=59,name="упокоения",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="zero",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={},dots={},victimrace=0,victimclass=0,victimnature="undead",victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=2,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=500,description="двойной ущерб нежити"},
{id=60,name="скульптуры",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="zero",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_acid=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={},dots={},victimrace=0,victimclass=0,victimnature="golem",victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=2,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=500,description="двойной ущерб големам"},

{id=61,name="недомогания",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="disease",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={{typ="disease",element="disease",stat=false,lvl=1,num=5}},dots={},victimrace=0,victimclass=0,victimnature=0,victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=1,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=500,description="болезнь 3/15"},
{id=62,name="болезни",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="disease",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={{typ="disease",element="disease",stat=false,lvl=2,num=10}},dots={},victimrace=0,victimclass=0,victimnature=0,victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=1,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=500,description="болезнь 3/15"},
{id=63,name="эпидемии",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="disease",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={{typ="disease",element="disease",stat=false,lvl=3,num=10}},dots={},victimrace=0,victimclass=0,victimnature=0,victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=1,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=500,description="болезнь 3/15"},

--оружие доспехи
{id=64,name="укрепления",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="zero",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={{typ="disease",element="disease",stat=false,lvl=1,num=5}},dots={},victimrace=0,victimclass=0,victimnature=0,victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=1,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=1500,description="укрепление вещи"},
{id=65,name="прочности",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="zero",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={{typ="disease",element="disease",stat=false,lvl=2,num=10}},dots={},victimrace=0,victimclass=0,victimnature=0,victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=1,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=2500,description="укрепление вещи"},
{id=66,name="неразрушимости",dmghp=0,dmgsp=0,dmgst=0,dmgrt=0,element="zero",protstat=0,selfstatbuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfstatdebuffs={mgt=0,enu=0,spd=0,dex=0,acu=0,sns=0,int=0,spr=0,chr=0,luk=0},selfrezbuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},selfrezdebuffs={rez_fire=0,rez_cold=0,rez_static=0,rez_poison=0,rez_acid=0,res_disease=0,rez_spirit=0,rez_mind=0,rez_light=0,rez_darkness=0},conditions={{typ="disease",element="disease",stat=false,lvl=3,num=10}},dots={},victimrace=0,victimclass=0,victimnature=0,victimgender=0,victimsize=0,victimracemod=1,victimclassmod=1,victimnaturemod=1,victimgendermod=1,victimsizemod=1,selfclass=0,selfrace=0,selfnature=0,selfgender=0,lv=1,timer=1000,price=3500,description="укрепление вещи"},
]]
--[[
{id=52, name="удобства", typ="modwep", dmg="none", powerdmg=1, effects={{"atk_mel",5}}, lv=1, timer=1000, price=500,description="атака +1"},
{id=53, name="лёгкости", typ="modwep", dmg="none", powerdmg=1, effects={{"rec_time",-5}}, lv=1, timer=1000, price=500,description="время восстановления -5"},
{id=54, name="баланса", typ="dmg", dmg="sp", powerdmg=1, effects={{"sp",-5}}, lv=1, timer=1000, price=500,description="время восстановления -5"},

--заторможенности
{id=55, name="медлительности", typ="dmg", dmg="none", powerdmg=0,  effects={{"slow",-5}}, lv=4, price=1000, timer=4000,description="страх 5"},
{id=56, name="утомления", typ="dmg", dmg="none", powerdmg=0,  effects={{"st",-5}}, lv=4, price=1000, timer=4000,description="страх 5"},
{id=57, name="антимагии", typ="dmg", dmg="sp", powerdmg=1, effects={{"sp",-5}}, lv=1, timer=1000, price=500,description="время восстановления -5"},

астрального вора
вампиризма
истощения

ослабления
слабости
изнеможения

-- оружие, доспехи, амулеты

{id=60, name="силы", typ="buff", dmg="", powerdmg="", effects={{"mgt",3}}, lv=1, timer=1000, price=500,description="сила +3"},
{id=61, name="мощи", typ="buff", dmg="", powerdmg="", effects={{"mgt",5}}, lv=3, timer=1000, price=700,description="сила +5"},
{id=62, name="могущества", typ="buff", dmg="", powerdmg="", effects={{"mgt",7}}, lv=5, timer=1000, price=1000,description="сила +7"},

{id=63, name="живучести", typ="buff", dmg="", powerdmg="", effects={{"enu",3}}, lv=1, timer=1000, price=500,description="стойкость +3"},
{id=64, name="стойкости", typ="buff", dmg="", powerdmg="", effects={{"enu",5}}, lv=3, timer=1000, price=700,description="стойкость +5"},
{id=65, name="неубиваемости", typ="buff", dmg="", powerdmg="", effects={{"enu",7}}, lv=5, timer=1000, price=1000,description="стойкость +7"},

{id=66, name="ловкости", typ="buff", dmg="", powerdmg="", effects={{"dex",3}}, lv=1, timer=1000, price=500,description="ловкость +3"},
{id=67, name="гибкости", typ="buff", dmg="", powerdmg="", effects={{"dex",5}}, lv=3, timer=1000, price=700,description="ловкость +5"},
{id=68, name="координации", typ="buff", dmg="", powerdmg="", effects={{"dex",7}}, lv=5, timer=1000, price=1000,description="ловкость +7"},

{id=69, name="скорости", typ="buff", dmg="", powerdmg="", effects={{"spd",3}}, lv=1, timer=1000, price=500,description="скорость +3"},
{id=70, name="стремительности", typ="buff", dmg="", powerdmg="", effects={{"spd",5}}, lv=3, timer=1000, price=700,description="скорость +5"},
{id=71, name="реакции", typ="buff", dmg="", powerdmg="", effects={{"spd",7}}, lv=5, timer=1000, price=1000,description="скорость +7"},

{id=72, name="точности", typ="buff", dmg="", powerdmg="", effects={{"acu",3}}, lv=1, timer=1000, price=500,description="точность +3"},
{id=73, name="меткости", typ="buff", dmg="", powerdmg="", effects={{"acu",5}}, lv=3, timer=1000, price=700,description="точность +5"},
{id=74, name="аккуратности", typ="buff", dmg="", powerdmg="", effects={{"acu",7}}, lv=5, timer=1000, price=1000,description="точность +7"},

{id=75, name="зрения", typ="buff", dmg="", powerdmg="", effects={{"sns",3}}, lv=1, timer=1000, price=500,description="восприятие +3"},
{id=76, name="чувствительности", typ="buff", dmg="", powerdmg="", effects={{"sns",5}}, lv=3, timer=1000, price=700,description="восприятие +5"},
{id=77, name="восприятия", typ="buff", dmg="", powerdmg="", effects={{"sns",7}}, lv=5, timer=1000, price=1000,description="восприятие +7"},

{id=78, name="интеллекта", typ="buff", dmg="", powerdmg="", effects={{"int",3}}, lv=1, timer=1000, price=500,description="интеллект +3"},
{id=79, name="большого ума", typ="buff", dmg="", powerdmg="", effects={{"int",5}}, lv=3, timer=1000, price=700,description="интеллект +5"},
{id=80, name="гениальности", typ="buff", dmg="", powerdmg="", effects={{"int",7}}, lv=5, timer=1000, price=1000,description="интеллект +7"},

{id=81, name="духовности", typ="buff", dmg="", powerdmg="", effects={{"spr",3}}, lv=1, timer=1000, price=500,description="духовность +3"},
{id=82, name="благодати", typ="buff", dmg="", powerdmg="", effects={{"spr",5}}, lv=3, timer=1000, price=700,description="духовность +5"},
{id=83, name="святости", typ="buff", dmg="", powerdmg="", effects={{"spr",7}}, lv=5, timer=1000, price=1000,description="духовность +7"},

{id=84, name="харизмы", typ="buff", dmg="", powerdmg="", effects={{"chr",3}}, lv=1, timer=1000, price=500,description="харизма +3"},
{id=85, name="общительности", typ="buff", dmg="", powerdmg="", effects={{"chr",5}}, lv=3, timer=1000, price=700,description="харизма +5"},
{id=86, name="коммуникабельности", typ="buff", dmg="", powerdmg="", effects={{"chr",7}}, lv=5, timer=1000, price=1000,description="харизма +7"},

{id=87, name="удачи", typ="buff", dmg="", powerdmg="", effects={{"luk",3}}, lv=1, timer=1000, price=500,description="удача +3"},
{id=88, name="везучести", typ="buff", dmg="", powerdmg="", effects={{"luk",5}}, lv=3, timer=1000, price=700,description="удача +5"},
{id=89, name="игры", typ="buff", dmg="", powerdmg="", effects={{"luk",7}}, lv=5, timer=1000, price=1000,description="удача +7"},

-- доспехи

--кольца (ослабленный вариант)

-- уники, артефакты, реликвии
]]
}


end;
