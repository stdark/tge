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
gold = 0,
item = false,
experience = 1000,
promotion_class = 0,
promotion_level = 0;
done = false,
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
item = false,
experience = 1000,
promotion_class = 0,
promotion_level = 0;
done = false,
},

{id=3,
font = messFont,
title="Найти грааль",
stages = {
{story = "Разузнать о граале."},
{story = "Разыскать грааль."},
{story = "Отнести заказчику."},
},
gold = 0,
item = false,
experience = 1000,
promotion_class = 0,
promotion_level = 0;
done = false,
},

};

quests.data={
{id=1,qid=1,personality="alternative",stages={true,false,false}},
{id=2,qid=2,personality="alternative",stages={false,false,false}},
{id=3,qid=3,personality="alternative",stages={true,false,false}},
};

end;


