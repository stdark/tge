function quests_load ()
quests={ -- should be duplicated, this form is for simple quests only, need subsections
{id=1,
font = messFont,
title="Выяснить своё прошлое",
stages = {
{story = "Очнувшись на пустынном берегу, мы долго пытались вспомнить, кто мы и как очутились в этой глуши. К сожалению, безрезультатно."},
{story = "После непродолжительных поисков, мы нашли останки двух кораблей. Возможно, мы плыли на одном из них."},
{story = "Мы нашли на берегу странные коробки: одну целую и одну вскрытую."},
{story = "Найдено рекомендательное письмо, выданное некоей четвёрке. Оно должно быть доставлено к кому-то, проживающему в городе Энске."},
},
},

{id=2,
font = messFont,
title="Устроить резню",
stages = {
{story = "Перебить гоблинов."},
{story = "Перебить гноллов."},
{story = "Перебить бандитов."},
{story = "Зайти в трактир и к лекарю."},
},
gold = 0,
},

{id=3,
font = messFont,
title="Найти грааль",
stages = {
{story = "Разузнать о граале."},
{story = "Разыскать грааль."},
{story = "Отнести заказчику."},
},
},

{id=4,
font = messFont,
title="Крысоловка захлопнулась.",
stages = {
{story = "Крысолюд Раттус Палохвост рассказал, что гоблины из лагеря на юге пленили его братца. Он попросил нас вызволить того, пока он не выдал все секреты под пытками."},
{story = "Брат Раттуса спасён. Надо зайти за наградой."},
{story = "К сожалению, спасательная операция не увенчалась успехом: брат Раттуса погиб. Надо сообщить крысолюду об этом печальном событии."},
{story = "Раттус не особенно растроился, и даже выплатил нам обещанное вознаграждение.",gold=1000,expa=1000,done=true},
{story = "Братцы крысолюды снова вместе. А мы при золоте. Хорошо, когда всё хоршо заканчивается.",gold=1000,expa=1000,done=true},
{story = "Поскольку Раттус мёртв, то ничего по поводу его братца предпринимать не нужно.",done=true},
},
},

{id=5,
font = messFont,
title="Угнанный хабар.",
stages = {
{story = "Крысолюд Раттус Палохвост рассказал, что гноллы из лагеря на севере захватили ценный груз, принадлежащий его команде. Он попросил нас вернуть груз."},
{story = "Груз добыт, осталось вернуть его более-менее законным хозяевам."},
{story = "Выполнено. Раттус Палохвост был весьма рад и выплатил нам вознаграждение.",gold=1000,expa=1000,done=true},
{story = "Поскольку Раттус мёртв, то ничего по поводу его груза предпринимать не нужно."},
},
},

};

quests.data={
{id=1,qid=1,personality="alternative",stages={true,false,false}},
{id=2,qid=2,personality="alternative",stages={false,false,false}},
{id=3,qid=3,personality="alternative",stages={true,false,false}},
{id=4,qid=4,stages={true,false,false,false,false,false}},
{id=5,qid=5,stages={true,false,false,false}},
};

end;


