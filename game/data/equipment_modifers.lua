function items_modifers_load () --FIXME check inventory ttx oil/trioil for indexes
items_modifers={

--оружие ближнего боя и боеприпасы

{id=1,name="огня",damage={hp={value=5,element="fire"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="огонь 5"},
{id=2,name="пламени",damage={hp={value=10,element="fire"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={flame={lvl=1,num=5,element="fire"}},personalities={},lv=2,timer=1000,price=1000,description="огонь 10"},
{id=3,name="испепеления",damage={hp={value=15,element="fire"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={flame={lvl=3,num=10,element="fire"}},personalities={},lv=3,timer=1000,price=3000,description="огонь 15"},

{id=4,name="холода",damage={hp={value=5,element="cold"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="холод 5"},
{id=5,name="мороза",damage={hp={value=10,element="cold"},st={value=5,element="cold"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={cold={lvl=1,num=5,element="cold"}},personalities={},lv=2,timer=1000,price=1000,description="холод 10"},
{id=6,name="стужи",damage={hp={value=5,element="cold"},st={value=10,element="cold"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={cold={lvl=3,num=10,element="cold"}},personalities={},lv=3,timer=1000,price=3000,description="холод 15"},

{id=7,name="искр",damage={hp={value=5,element="static"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="статика 5"},
{id=8,name="молнии",damage={hp={value=10,element="static"},rt={value=5,element="static"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="статика 10"},
{id=9,name="грозы",damage={hp={value=15,element="static"},rt={value=10,element="static"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="статика 15"},

{id=10,name="отравы",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={poison={lvl=1,num=5,element="poison"}},personalities={},lv=1,timer=1000,price=500,description="яд 5"},
{id=11,name="яда",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={poison={lvl=3,num=10,element="poison"}},personalities={},lv=2,timer=1000,price=1000,description="яд 45"},
{id=12,name="токсичности",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={poison={lvl=5,num=20,element="poison"}},personalities={},lv=3,timer=1000,price=3000,description="яд 100"},

{id=13,name="коррозии",damage={hp={value=5,element="acid"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={acid={lvl=1,num=5,element="acid"}},personalities={},lv=1,timer=1000,price=500,description="кислота 5"},
{id=14,name="кислоты",damage={hp={value=10,element="acid"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={acid={lvl=3,num=10,element="acid"}},personalities={},lv=2,timer=1000,price=1000,description="кислота 45"},
{id=15,name="растворения",damage={hp={value=15,element="acid"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={acid={lvl=5,num=20,element="acid"}},personalities={},lv=3,timer=1000,price=3000,description="кислота 100"},

{id=16,name="боли",damage={hp={value=5,element="mind"},rt={value=5,element="mind"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="ментал 5"},
{id=17,name="страданий",damage={hp={value=10,element="mind"},rt={value=5,element="mind"},st={value=5,element="mind"},},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="ментал 10"},
{id=18,name="истязаний",damage={hp={value=15,element="mind"},rt={value=5,element="mind"},st={value=5,element="mind"},sp={value=5,element="mind"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="ментал 15"},

{id=19,name="бездуховност",damage={hp={value=5,element="spirit"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="дух 5"},
{id=20,name="безблагодатности",damage={hp={value=10,element="spirit"},sp={value=5,element="spirit"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="дух 10"},
{id=21,name="душегубства",damage={hp={value=15,element="spirit"},sp={value=10,element="spirit"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="дух 15"},

{id=22,name="вспышки",damage={hp={value=5,element="light"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="свет 5"},
{id=23,name="света",damage={hp={value=10,element="light"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={blind={lvl=1,num=5,element="light"}},dots={},personalities={},lv=2,timer=1000,price=1000,description="свет 10"},
{id=24,name="сияния",damage={hp={value=15,element="light"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={blind={lvl=3,num=10,element="light"}},dots={},personalities={},lv=3,timer=1000,price=3000,description="свет 15"},

{id=25,name="тени",damage={hp={value=5,element="darkness"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="тьма 5"},
{id=26,name="сумерек",damage={hp={value=10,element="darkness"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={darkgasp={lvl=1,num=5,element="darkness"}},dots={},personalities={},lv=2,timer=1000,price=1000,description="тьма 10"},
{id=27,name="тьмы",damage={hp={value=15,element="darkness"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={darkgasp={lvl=3,num=10,element="darkness"}},dots={},personalities={},lv=3,timer=1000,price=3000,description="тьма 15"},

{id=28,name="льда",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={freeze={lvl=1,num=5,"cold"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="заморозка 5"},
{id=29,name="оледенения",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={freeze={lvl=3,num=10,"cold"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="заморозка 30"},
{id=30,name="мерзлоты",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={freeze={lvl=5,num=20,"cold"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="заморозка 100"},

{id=31,name="окаменения",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={stone={lvl=1,num=5,false}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="окаменение 5"},
{id=32,name="медузы",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={stone={lvl=3,num=10,false}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="окаменение 30"},
{id=33,name="ваислиска",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={stone={lvl=5,num=20,false}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="окаменение 100"},

{id=34,name="обездвиживания",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={paralyze={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="паралич 5"},
{id=35,name="пареза",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={paralyze={lvl=3,num=10,"mind"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="паралич 30"},
{id=36,name="паралича",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={paralyze={lvl=5,num=20,"mind"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="паралич 100"},

{id=37,name="кровеотворения",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={bleeding={lvl=1,num=5,false}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="кровотечение 5"},
{id=38,name="кровотечения",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={bleeding={lvl=3,num=10,false}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="кровотечение 30"},
{id=39,name="кровепотери",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={bleeding={lvl=5,num=20,false}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="кровотечение 100"},

{id=40,name="шока",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={stun={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="оглушение 5"},
{id=41,name="ошеломления",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={stun={lvl=3,num=10,"mind"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="оглушение 30"},
{id=42,name="оглушения",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={stun={lvl=5,num=20,"mind"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="оглушение 100"},

{id=43,name="усмирения",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="шарм 5"},
{id=44,name="умиротворения",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=3,num=10,"mind"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="шарм 30"},
{id=45,name="нирваны",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=5,num=20,"mind"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="шарм 100"},

{id=46,name="дремоты",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="сон 5"},
{id=47,name="сна",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=3,num=10,"mind"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="сон 30"},
{id=48,name="морфея",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={charm={lvl=5,num=20,"mind"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="сон 100"},

{id=49,name="страха",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={fear={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="страх 5"},
{id=50,name="паники",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={fear={lvl=3,num=10,"mind"},panic={lvl=1,num=5,"mind"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="страх и паника 30/5"},
{id=51,name="террора",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={fear={lvl=5,num=20,"mind"},panic={lvl=3,num=10,"mind"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="страх и паника 100/30"},

{id=52,name="манасожжения",damage={sp={value=5,element="mind"},sp={value=5,element="spirit"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="сжигание маны 10"},
{id=53,name="антимагии",damage={sp={value=10,element="mind"},sp={value=10,element="spirit"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={flame={lvl=1,num=5,element="fire"}},personalities={},lv=2,timer=1000,price=1000,description="сжигание маны 15"},
{id=54,name="безмагии",damage={sp={value=15,element="mind"},sp={value=15,element="spirit"}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={flame={lvl=3,num=10,element="fire"}},personalities={},lv=3,timer=1000,price=3000,description="сжигание маны 20"},

{id=55,name="недомогания",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={disease={lvl=1,num=5,element="disease"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="болезнь 10"},
{id=56,name="болезни",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={disease={lvl=1,num=5,element="disease"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="болезнь 30"},
{id=57,name="чумы",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={disease={lvl=1,num=5,element="disease"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="болезнь 100"},

{id=58,name="замедления",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={slow={lvl=1,num=5,element="poison"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="замедление 10"},
{id=59,name="медлительности",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={slow={lvl=1,num=5,element="poison"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="замедление 30"},
{id=60,name="остановки",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={slow={lvl=1,num=5,element="poison"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="замедление 100"},

{id=61,name="ослабления",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={weakness={lvl=1,num=5,element="poison"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="слабость 10"},
{id=62,name="слабости",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={weakness={lvl=1,num=5,element="poison"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="слабость 30"},
{id=63,name="изнеможения",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={weakness={lvl=1,num=5,element="poison"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="слабость 100"},
--
{id=64,name="опьянения",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={drunk={lvl=1,num=5,element="poison"}},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="опьянение 10"},
{id=65,name="одурманивания",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={drunk={lvl=1,num=5,element="poison"}},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="опьянение 30"},
{id=66,name="дурмана",damage={},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={drunk={lvl=1,num=5,element="poison"}},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="опьянение 100"},

{id=67,name="арахнофобии",damage={},atkadd={},addself={},genocide={insect=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="опьянение 10"},
{id=68,name="гербицида",damage={},atkadd={},addself={},genocide={plant=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="опьянение 30"},
{id=69,name="антихимеризма",damage={},atkadd={},addself={},genocide={hybrid=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="опьянение 100"},

{id=70,name="гигантомахии",damage={},atkadd={},addself={},genocide={giant=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="двойной урон гигантам"},
{id=71,name="гадофобии",damage={},atkadd={},addself={},genocide={reptile=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="двойной урон рептилиям"},
{id=72,name="мизантропии",damage={},atkadd={},addself={},genocide={humanoid=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="двойной урон человекоподобным"},

{id=73,name="драконоборства",damage={},atkadd={},addself={},genocide={dragon=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="двойной урон драконам"},
{id=74,name="упокоения",damage={},atkadd={},addself={},genocide={undead=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="двойной урон големам и горгульям"},
{id=75,name="скульптуры",damage={},atkadd={},addself={},genocide={golem=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="двойной урон нежити"},

{id=76,name="аморфности",damage={},atkadd={},addself={},genocide={ooz=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="двойной урон оозам"},
{id=77,name="звероборства",damage={},atkadd={},addself={},genocide={beast=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="двойной урон зверям"},
{id=78,name="демоноборства",damage={},atkadd={},addself={},genocide={demon=2,kreegan=2},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="двойной урон демонам"},

{id=79,name="вампиризма",damage={hp={value=0,vampirism=0.2}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=1,timer=1000,price=500,description="двойной урон оозам"},
{id=80,name="астрального воровства",damage={sp={value=10,vampirism=1}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=2,timer=1000,price=1000,description="двойной урон зверям"},
{id=81,name="истощения",damage={st={value=10,vampirism=1}},atkadd={},addself={},genocide={},regeneration={},selfstatbuffs={},selfrezbuffs={},conditions={},twofacotconditions={},dots={},personalities={},lv=3,timer=1000,price=3000,description="двойной урон демонам"},

};

end;
