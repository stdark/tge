function logstrings_load ()
end;

lognames={};

lognames.actions={
atk={" атаковал ", " атаковала ", " атаковало "},
sht={" выстрелил в "," выстрелила в "," выстрелило в "},
dmg={" и нанёс урон ", " и нанесла урон ", " и нанесло урон "},
lost={" потерял ", " потеряла ", " потеряло "},
gotdmg={" получил ущерб "," получила ущерб "," получило ущерб "},
metr=" ед. ",
ofhp=" жизни",
ofsp=" маны",
ofst=" бодрости ",
ofac=" брони ",
ofrt=" готовности ",
miss={" и промахнулся", " и промахнулась ", " и промахнулось "},
crit={" и нанёс критический урон", " и нанесла критический урон ", " и нанесло критический урон "},
death={" погибает", " погибает", " погибает"},
cast={" прочёл заклинание ", " прочла заклинание ", " прочло заклинание "},
usedtrick={" применил приём"," применила приём"," применило приём"},
usepotion={" применил зелье"," применила зелье"," применило зелье"};
restored={" восстановил ", " восстановила ", "восстановило"},
andrestored={" и восстановил ", " и восстановила ", " и восстановило"},
condition={" наложил состояние ", " наложила сстояние ", " наложило состояние "},
uncondition={" снял состояние ", " сняла сстояние ", " сняло состояние "},
thinks={" думает: ", " думает: ", " думает: "},
hates={" ненавидит ", " ненавидит ", " ненавидит "},
at=" на ",
andi=" и ",
withgold=" золотом",
ofgold=" золотых",
ofgolds=" золотой",
got={" получил "," получила "," получило "},
rez=" ед. сопротивления ",
gotprot=" получил защиту ",
transported=" перемещён ",
freeze={" заморожен", " заморожена"," заморожено"},
stone={" обращён в камень", " обращена в камень", "обращено в камень"},
flamed={" горит"," горит"," горит"};
cooled={" страдает от холода"," страдает от холода"," страдает от холода"},
poisoned={" отравлен", " отравлена", " отравлено"},
acided={" обожжён кислотой", " обожжена кислотой", " обожжено кислотой"},
diseased={" инфицирован ", "инфицирована", "инфицировано"},
zapped={" получил разряд"," получила разряд"," получило разряд"},
stun={" оглушён ", " оглушена ", " оглушено "},
sleep={" усыплён ", " усыплена ", " усыплено "},
slowed={" замедлен "," замедлена ", " замедлено "},
feared={" испуган "," испугана ", " испугано "},
panic={" в панике"," в панике", " в панике"},
immobilized={"обездвижен", "обездвижена", "обездвижено"},
traumed={"травмирован","травмирована","травмировано"},
paralyzed={" парализован"," парализована"," парализовано"},
mad={" безумен "," безумна "," безумно "},
filthed={" освквернён "," осквернена "," осквернено "},
darkgasped={" под дланью "," под дланью "," под дланью "},
fingerofdeathed={" обречён"," обречена"," обречено"},
tired={"утомлён","утомлена","утомлено"},
stunned={" ошеломлён"," ошеломлена"," ошеломлено"},
feelstheforce={" ощутил силу"," ощутила силу"," ощутило силу"};
desponded={" в унынии"," в унынии"," в унынии"};
hashighmoral={" высокоморален"," высокоморальна"," высокоморально"};
haslowmoral={"деморализован","деморализована","деморализовано"};
cheeresup={" воспрянул духом"," воспрянула духом"," воспрянуло духом"},
controlled={" под контролем"," под контролем"," под контролем"},
dumbfounded={" замер в нерешительности"," замерла в нерешительности"," замерло в нерешительности"},
bleeding={" истекает кровью", " истекает кровью", " истекает кровью"},
cursed={" проклят"," проклята"," проклято"},
contaminated={" загрязнён"," загрязнена"," загрязнено"};
raised={" поднят как нежить"," поднята как нежить"," поднято как нежить"},
sacrificed={" принесён в жертву"," принесена в жертву", " принесено в жертву"},
weaked={" ослаблен"," ослаблена","ослаблено"},
startedchatting={" начал разговор с ", " начала разговор с ", " начало разговор с "};
invisible={" невидим"," невидима"," невидимо"};
trapinstalled=" ловушка установлена ",
deblocked={" пробил блок", " пробила блок", " пробило блок"};
armorpenetrated={" ударил сквозь броню", " ударила сквозь броню", " ударило сквозь броню"};
activated=" активирована ",
noskill=" не владеет ",
noskill2=" не может носить ",
noskill3=" не в состоянии выучить это заклинание",
noskill4=" не знает, что с этим делать",
outofmana="не хватает маны на заклинание",
badammo="не тот боеприпас",
noammo="нет боеприпасов",
charistoofar="надо подойти ближе", 
gave={" передал "," передала ", " передало "},
ground="земля",
bag="сумка",
chest="сундук",
safe="сейф",
secret="тайник",
taken={" взял "," взяла "," взяло "},
frombag=" из мешка",
frominv=" из рюкзака ",
fromchest=" из сундука",
fromsafe=" из сейфа",
fromsecret=" из тайника",
droped={" выбросил ", " выбросила ", " выбросило "},
sold={" продал"," продала"," продало"},
regen=" регенерирует",
tookrh={" взял в левую руку "," взяла в правую руку ", " взяло в правую руку "},
tooklh={" взял в правую руку "," взяла в левую руку ", " взяло в левую руку "},
noeffect="нет эффекта",
scared={"напуган","напугана","напугано"},
charmed={"очарован","очарована","очаровано"},
feebleminded={" слабоумный"," слабоумная"," слабоумное"};
darkgased={" во тьме"," во тьме"," во тьме"};
forgottensnth={" забыл что-то важное"," забыла что-то важное"," забыло что-то важное"};
berserk={"теперь берсерк","теперь берсерк","теперь берсерк"},
enslaved={"порабощён", "порабощена", "порабощено"},
silenced={" онмел"," онемела", " онмело"};
lostself={"растерян","растеряна","растеряно"},
runaway="в страхе убегает",
toenemy = "идёт к противнику",
resurrected={"воскрешён","воскрешена","воскрешено"},
drinked={"выпил","выпила","выпило"},
boiled={" сварил зелье "," сварила зелье "," сварило зелье "},
distillated={" получил перегонкой зелье "," получила перегонкой зелье "," получило перегонкой зелье "},
enchancedpotion={ "усилил катализатором зелье ", " усилила катализатором зелье ", " усилило катализатором зелье " },
diluted={" разбавил зелье "," разбавила зелье "," разбавило перегонкой зелье "},
fixed={" починил предмет: "," починила предмет: "," починило предмет: "},
nothingtofix="нечего чинить!",
drunk={" пьян", " пьяна", " пьяно"},
ofpower="силой",
got=" получил ", " получила ", " получило ",
ofexp=" опыта",
examined={" выучил заклинание "," выучила заклинание "," выучило заклинание "},
alreadyknown=" уже знает заклинание ",
cantreadthis=" не может это прочесть…",
ofpower=" силой ",
inhaste=" теперь в спешке ",
gotspeed={" ускорился ", " ускорилась ", " ускорилось "},
gotstrenght={" обрёл мощь ", " обрела мощь ", " обрело мощь "},
gotcharisma={" стал харизматичней ", "  стала харизматичней ", "  стало харизматичней "},
gotveh={" пройдёт везде ", " пройдёт везде ", " пройдёт везде "},
gotdoused={" потушен ", " потушена ", " потушено "},
uncond=" без сознания",
block={ " заблокировал удар", " заблокировала удар", " заблокировало удар"},
parry={ " парировал удар", " парировала удар", " парировало удар"},
dodge={ " уклонился от удара", " уклонилась от удара", " уклонилось от удара"},
tooktoarmor={ " приняло удар на броню", " приняла удар на броню", " приняло удар на броню"},
greased={" смазал ", " смазала ", " смазало " },
isbleeding={"истекает кровью","истекает кровью","истекает кровью"},
likeahero={"чувтвует себя героем","чувтвует себя героем","чувтвует себя героем"},
likeasaint={"чувтвует себя святым","чувтвует себя святой","чувтвует себя свято"},
blessed={"благославлён","благославлена","благославлено"},
feelsdestiny={"в руках судьбы","в руках судьбы","в руках судьбы"},
feelsprayer={"чувствует силу молитвы","чувствует силу молитвы","чувствует силу молитвы"},
someequipment=" элемент экипировки ",
picklockbroken = "отмычка сломана",
in_enemies_FOV = "в поле зрения противника",
battlestarted="бой начался",
battlefinished="бой окончен",
trapactivated="ловушка активирована",
trapdisarmed="ловушка обезврежена",
ustotal = "Нас ",
ourfriendstotal = " ,и друзей ",
elementalcalled = "вызван элементаль",
clonecreated = "создан клон",
picklocklv="взлом",
mkpicklocklv="изготовление",
inspectlv="изучение",
disarmlv="обезвреживание",
potionpower="сила зелья",
burgled="взломано!",
notenoughmight="недостаточно силы",
nospace="нет места!",
nothingtotake="нечего взять!",
found="найдено: ",
unknown="?",
identified="Опознано!",
cantid="Не опознано!",
itemnotid="Предмет не опознан!",
itembroken="Предмет сломан!",
movingtocall="идёт на зов",
atwaypoint="придерживается маршрута",
stoped={ " остановился", " остановилась", " зостановилось"},
loststamina={" выдохся"," выдохлась"," выдохлось"},
shocked={" в шоке"," в шоке"," в шоке"},
mad={" сошёл с ума"," сошла с ума"," сошло с ума"},
teleported={" переместился"," переместилась"," переместилось"},
healed={" исцелён"," исцелена"," исцелено"},
targetpartlyhided="Цель видна частично!",
for_=" за ",
sufferingofpoison={" страдает от яда"," страдает от яда"," страдает от яда"},
hardened="укреплено",
incorruptable="неуничтожимо",
robbed={" обокрал"," обокрала"," обокрало"},
didntrob={" не смог обокрасть"," не смогла обокрасть"," не смогло обокрасть"},
stolen={" украл"," украла"," украло"},
trapdetected="обнаружена ловушка",
feelangry={" злится "," злится ", " злится "},
suspicionsdiminished={" рассеял подозрения "," рассеяла подозрения "," рассеяло подозрения "},
stoppedthechat={" завершил беседу"," завершила беседу"," завершило беседу"},
catchedasthief={" попался на воровстве "," попалась на воровстве "," попалось на воровстве "},
newsecret="вызнан новый секрет",
broke={" сломал"," сломала"," сломало"},
starves={" страдает от голода"," страдает от голода"," страдает от голода"},
uncondfstarve={" потерял сознание от голода"," потеряла сознание от голода"," потеряло сознание от голода"},
eaten={" поел"," поела"," поело"},
drinkfrombarrel={ " отпил из бочки, параметры увеличены!", " отпила из бочки, параметры увеличены!", " отпило из бочки, параметры увеличены!"},
drinkfromcauldron={ " отпил из котла, сопротивления увеличены!", " отпила из котла, сопротивления увеличены!", " отпило из котла, сопротивления увеличены!"},
usedpedestal={ " приложился к пьедесталу ", " приложилась к пьедесталу ", " приложилось к пьедесталу "},
takenprotectionpose={" принял защитную стойку"," приняла защитную стойку"," приняло защитную стойку"},
hasshored={" подвёл под удар "," подвела под удар "," подвело под удар "},
covered={" прикрыл щитом "," прикрыла щитом "," прикрыло щитом "},
bumpedwithshield={" отбросил щитом "," отбросила щитом "," отбросило щитом "},
hitedwithshield={" ударил щитом "," ударилаа щитом "," ударило щитом "},
fooledwithdodge={" околпачил "," околпачила "," околпачило "},
drunkfromwell={" испил из колодца"," испила из колодца"," испило из колодца"},
gotarchangel={" получил ангела-хранителя"," получила ангела-хранителя", " получило ангела-хранителя"},
protected={" под защитой"," под защитой", " под защитой"},
stuck={ " увяз"," увязла"," увязло"},
behavior="поведение",
party_got_a_quest="Команда получила задание!",
quest_updated="Задания обновлено!",
party_got_an_affront="Команда выучила новое оскорбление!",
party_got_a_joke="Команда узнала новую шутку!",
party_got_an_nlp="Команда узнала новую фразу!",
party_got_an_info="Команда получила полезную информацию!",
calledguards={" позвал охрану"," позвала охрану", " позвало охрану"},
basiliskbreath_prevents_satiation={"сглаз не даёт насытиться"},
};

lognames.calendar={
year_AS="Год ПБ: ",
year_AR="Год ПР: ",
month="Месяц: ",
week="Неделя: ",
day="День: ",
current_time="Время: ",
};

lognames.buttons={
apply="применить",
startgame="начать игру",
createparty="создать команду",
drink="хлебнуть",
};
  
lognames.mob_names={goblin=" гоблин ",ogre=" огр ", rogue=" вор ", mage=" маг ",golem=" голем ", naga=" нага ", fireelemental=" элементал огня ", airelemental=" элементал воздуха ", waterelemental=" элементал воды ", earthelemental=" элементал земли "};

lognames.races={human_continental="эрафиец",human_krewlod="крюлодец",human_islander="островитянин", human_enroth="энротиец", human_regnan="регнанец", human_nihon="нигонец",
elf_wood="лесной эльф",elf_dark="тёмный эльф",elf_snow="снежный эльф",
dwarf="гном",dwarf_dark="тёмный гном",halfling="полурослик", nordling="нордлинг",
hobgoblin="хобгоблин",goblin="гоблин",ogre="огр",
orc="орк", troll="тролль", minotaur="минотавр",
gremlin="гремлин",kreegan="криганин", demon="демон", halfgeany="полуджинн",
lizardman="ящеролюд", gnoll="гнолл", kobold="кобольд", ratman="крысолюд"
};

tips_titles={
 skill="Навык:", subclass="Тип:", dmg="Ущерб:", atk="Атака:", block="Блок:", ac="Класс брони:", dt="Порог брони"; dr = "Поглощение:", price="Цена:",
 add="Дополнительно:", mana="Мана:", recovery="ВВ:", eff="Эффект:", dur="Длительность", radius="Радиус:", stamina = "бодрость",
 dot="Ущерб со временем:", immunity="иммунитет", quantity="Количество:", power="Сила:",
 spellbookcontains="Данная книга содержит заклинание ", fromschool=" из школы", color="Цвет: ", modificator="Мод:",
 condition="Состояние:",charges="Зарядов:",spell="Заклинание:",
};

types_of_damage={fire=" огнём ", cold=" холодом ", static=" статикой ", poison=" ядом ", acid=" кислотой ", light=" светом ", darkness=" тьмой ", mind=" менталом ", spirit=" духом ", energy=" энергией ", trap=" от ловушки ", dot=" по ходу дела ", shraps=" осколками ", hit=" от удара ",
tofire=" к огню ", tocold=" к холоду ", tostatic=" к статике ", toacid=" к кислоте ", topoison=" к яду ", todisease=" к болезням ", tomind=" к менталу ", tospirit=" к духу ", toac=" к классу брони ", torng=" от метательных снарядов ",tolight=" к свету ", todarkness=" к тьме ", rezists="сопр.:", stats="х-ки:"
};

lognames.stats={mgt="сила ",enu="выносливость ", dex="ловкость ", spd="скорость ", acu="меткость ", sns="восприятие ", int="интеллект ", spr="духовность ", chr="харизма ", luk="удача ",
hp="единицы жизни ", sp="единицы маны ", st="единицы бодрости ", rt="единицы готовности",
atkm="атака ", atkr="стрельба ", dmgm="урон в ближнем бою", dmgr="урон в стрелковом бою", dmg="урон",
ac="класс брони", dt="порог брони",dr="поглощение",dodge="шанс на клонение", parry="шанс на парирование", block="шанс на блок",
rezfire="устойчивость к огню", rezcold="устойчивость к холоду",rezstatic="устойчивость к статике",rezacid="устойчивость к кислоте",rezpoison="устойчивость к ядам",rezdisease="устойчивость к болезням",rezmind="устойчивость к менталу",rezspirit="устойчивость к проклятьям",rezlight="устойчивость к свету",rezdarkness="устойчивость к тьме",
lv="уровень",xp="опыт", class="класс", moral = "мораль", satiation="сытость", name="имя"
};

lognames.skills={
unarmed="без оружия",sword="меч",axe="топор",flagpole="древковое",crushing="дробящее",staff="посох",dagger="кинжал",bow="лук",crossbow="арбалет",throwing="метательное",firearms="огнестрел",
dodging="уклонение",leather="кожаный доспех", chainmail="кольчужный доспех", plate="латный доспех", shield="щит",
fire="магия огня",water="магия воды",air="магия воздуха",earth="магия земли",body="магия тела",spirit="магия духа",mind="магия разума",light="магия света",darkness="магия тьмы",
alchemy="алхимия",repair="ремонт",stealth="скрытность",picklocking="замки",traps="ловушки",spothidden="обнаружение",monsterid="монстроведенье",stuffid="опознание",
trading="торговля", thievery="воровство", diplomacy="дипломатия", leadership="лидерство", bodybuilding="бодибилдинг",armmastery="вооружение", meditation="медитация", mysticism="мистицизм", regeneration="регенерация",
cantbeequiped="не требует умений",none="не требует умений", reading="чтение"
};

lognames.skillsr={
unarmed="рукопашным боем",sword="мечом",axe="топором",flagpole="древковым оружием",crushing="дробяшим оружием",staff="посохом",dagger="кинжалом",bow="луком",crossbow="арбалетом",throwing="метательным",firearms="огнестрелом",
leather="кожаный доспех", chainmail="кольчужный доспех", plate="латный доспех", shield="щит",
cantbeequiped="не требует умений",none="не требует умений",
};

lognames.chars={class="класс",race="раса",gender="пол",name="имя",voice="голос"};

lognames.classes={fighter="боец",tricker="ловкач",novice="послушник",acolyte="одарённый",
warrior="воин",savage="дикарь",mage="маг",druid="друид",warlock="варлок", cleric="клерик",heretic="еретик",monk="монах", sorcerer="волшебник",
archmage="архимаг",lich="лич", archdruid="архидруид", heresiarh="ересиарх", yeromonk="иеромонах",priest="священник",bishop="епископ",
assasin="убийца",spy="шпион",thief="вор",rogue="разбойник",burglar="налётчик",brigant="бандит",seccol="сексот",agent="агент",
sniper="снайпер",marxman="стрелок",archer="лучник",hunter="охотник",ranger="рейнджер",
paladin="паладин",knight="рыцарь",gladiator="гладиатор",barbarian="варвар",crusader="крестоносец",templair="храмовник",prelat="прелат",
};

magic_tips_skills={
lvl_fire="магия огня",lvl_air="магия воздуха",lvl_water="магия воды",lvl_eath="магия земли",
lvl_body="магия тела",lvl_mind="магия разума",lvl_spirit="магия духа",
lvl_light="магия света",lvl_darkness="магия тьмы"
};

healthstatus={
healthy="здоров", 
lighty="легко ранен", 
wonded="ранен", 
seriously="серьёзно ранен", 
subgrave="при смерти", 
dead="мёртв",
uncond="без сознания"
};

mind_status={agr="Смерть врагам! ",away="А-а-а!!! ", rnd="Туда-сюда… ",stay="Стою на месте… ",
charm=" Как мило... ", berserk=" Всех убью! ",enslave=" Счастье в служении! ", madness=" Гы-ы-ы! ", hoorah=" У-р-ра-а! ", blood=" Кровышша!!! ", killmepls = " О-хо-хо, доля тяжкая... ",
drunk=" Ик! ",nogold=" И золота нет… ",abitgold=" И золотом-то всего ",somegold=" Золота где-то ",enoughgold=" Золота аж ",
};

fractions={party="партия",greens="зеленухи",bandidos="бандиты",bloggers="неписи",vagrants="бродяги",merchants="торговцы"};
mind_fractions={party="Я в лучшей команде на свете!",greens="Зеленухи, вперёд!",bandidos="Обчищу, на нож посажу!",bloggers="Хочу поговорить!",vagrants="Эх, путь-дорога!",merchants="Прибытку бы."};

moralstatus={"высокоморален", "мораль в норме", "деморализован", "мораль отсутствует"};

manastatus={
idk="не известно", nobook="не маг", full="полон маны", morethanhalf="маны ещё достаточно", lessthanhalf="мана не в избытке", quaterorless="крохи маны", nomana="опустошён"
};

staminastatus={
full="полон сил", ok="вполне бодр", abittired="устал", tired="утомлён", disabled="обессилен"
};

recoverystatus={
full="готов к действиям", ok="почти готов", half="копит силы", quater="ещё не скоро", abit="в запасе"
};

resistsvalues = {
none="нет",weak="слабо",medium="средне",high="хорошо",veryhigh="отлично",immune="иммунитет"
}

nature={
humanoid="гуманоид", monster="монстр", undead="undead", giant="гигант", droid="дроид", golem="голем", elemental="элементаль", hybrid="гибрид"
};

skilllevelnames={"базовый","ученик","эксперт","мастер","магистр"};

typo={" «", "» "};

tip_schools={"огня","воздуха","воды","земли","тела","разума","духа","света","тьмы", "сопряжения","жизни","объединения","искажения","святости"};

level_letter={"баз.","уч.","эксп.","мастер","гранд"};

item_type={book="книга", message="записка", letter="письмо",scroll="свиток с заклинанием", map = "карта", picture="картина",gobelen = "гобелен"};

locks={"простой","цилиндровый","сувальдный","дисковый","кодовый","сверхсложный"};

tips_conditions={
poison="отравление",
freeze="заморозка",
stone="окаменение",
paralyze="паралич",
stun="оглушение",
immobilize="обездвиживание",
silence="молчание",
enslave="порабощение",
berserk="берсерк",
insane="безумие",
charm="шарм",
fear="страх",
sleep="сон",
flame="воспламанение",
cold="холод",poison="яд",
acid="кислота",
disease="болезнь",
pain="боль",
bleeding="кровотечение",
eyetruma="травма глаза",
blind="слепота",
pneumotorax="пневмоторакс",
handtrauma="трама руки",
legtrauma="травма ноги",
curse="проклятье",
misfortune="сглаз",
filth="скверна",
fingerofdeath="перст смерти",
revenge="месть",
weakness="слабость",
despondency="уныние",
fate="судьба-злодейка",
protection_from_fire="защита от огня",
protection_from_cold="защита от холода",
protection_from_static="защита от электричества",
protection_from_poison="защита от яда",
rotection_from_acid="защита от кислоты",
protection_from_disease="защита от болезней",
protection_of_mind="защита разума",
protection_of_spirit="защита от проклятий",
painreflection="отражение боли",
shieldoflight="щит света",
firebelt="щит ифрита",
stoneskin="каменная кожа",
shield="щит",
heroism="героизм",
rage="ярость",
thirstofbloof="жажда крови",
stoutness="отвага",
bless="благословение",
prayer="молитва",
protection="защита",
might="мощь",
dash="стремительность",
haste="спешка",
egeneration="регенерация",
fateself="судьба",
dash="мобильность",
wingsoflight="крылья света",
torchlight="факел",
executor="палач",
myrth="радость",
invisibility="невидимость",
waterwalking="хождение по воде",
levitation="левитация",
precision="меткость",
meditation="медитация",
concentration="концентрация",
glamour="гламур",
luckyday="удачный день",
angel="ангел-хранитель",
protection="защита",
hourofpower="час силы",
dayofgods="день богов",
cold="холод",
darkgasp="тёмная длань",
};

lognames.names={Roderick="Родерик",Tarvick="Тарвик",Sethrick="Сетрик",Caleb="Калеб",Ceasar="Цезарь",
Anna="Анна",Andrea="Андрэа",
Giltor="Гилтор",Milgor="Милгор",Dendor="Дэндор",
Mbvana="Мбвана",Mbenge="Мбенге",Kvaba="Кваба",
Maerin="Маэрин", Dalerin="Далерин", Kyriin="Кириин",
Alexis="Алексис",
Zherar="Жерар",Zhosephine="Жозефина",
Yoloo="Йолу",Niloo="Нилу",Keloo="Кэлу",
Gortar="Гортар",Arkgar="Аркгар",Dugkar="Дугкар",
Toognor="Тугнор", Aznog="Азног", Urtharg="Уртарг",

Aaron="Аарон",
Abe="Эйб",
Abel="Абель",
Adam="Адам",
Adrian="Эдриан",
Ahmed="Ахмед",
Al="Эл",
Ali="Али",
Alan="Алан",
Albert="Альберт",
Alexander="Александр",
Alton="Элтон",
Alvin="Элвин",
Ambrose="Эмброуз",
Amos="Амос",
Andrew="Эндрю",
Anthony="Энтони",
Arnold="Арнольд",
Arthur="Артур",
Barett="Барет",
Bart="Барт",
Bele="Бель",
Benedict="Бенедикт",
Benjamin="Бенджамин",
Bob="Боб",
Brad="Брэд",
Brent="Брэнт",
Bruce="Брюс",
Bruno="Бруно",
Cal="Кэл",
Caleb="Калеб",
Cameron="Камерон",
Carl="Карл",
Carlos="Карлос",
Ceasar="Цезарь",
Cedric="Седрик",
Charles="Чарльз",
Christian="Кристиан",
Chuck="Чак",
Clark="Кларк",
Cyrano="Цирано",
Daniel="Даниэль",
Desmond="Дэзмонд",
Dustin="Дастин",
Edgar="Эдгар",
Edward="Эдвард",
Elton="Элтон",
Ervin="Эрвин",
Eugene="Евгений",
Fabian="Фабиан",
Ferdinand="Фердинанд",
Frank="Фрэнк",
Gary="Гари",
Guillerno="Гильермо",
Gus="Газ",
Guy="Гай",
Hank="Хэнк",
Harcourt="Харкурт",
Hector="Гектор",
Henry="Генри",
Herbert="Герберт",
Horace="Хораз",
Howard="Говард",
Jack="Джек",
Jaime="Джейми",
James="Джеймс",
Jean="Джин",
John="Джон",
Joshua="Джошуа",
Kurl="Карл",
Lazare="Лазарь",
Lewis="Льюис",
Louis="Луис",
Luke="Люк",
Manfred="Манфред",
Mark="Марк",
Maxwell="Максвэл",
Micle="Майкл",
Morton="Мортан",
Norman="Норман",
Nicolas="Николас",
Patrick="Патрик",
Paul="Пол",
Phil="Фил",
Ramse="Рэймс",
Reginald="Реджинальд",
Robert="Роберт",
Roderick="Родерик",
Roger="Роджер",
Scott="Скотт",
Sethrick="Сетрик",
Sherman="Шерман",
Sherlok="Шерлок",
Simon="Симон",
Tarvick="Тарвик",
Victor="Виктор",
Wade="Вейд",
Walton="Волтон",
Warren="Уорен",
William="Вильям",
Zack="Зак",
};

lognames.npcnames={Schors="Щорс",Meroving="Меровинг"};

lognames.gender = {"мужчина","женщина"};

lognames.raceDescriptions={
human_continental="Житель центральной части\nАнтагарича. Общителен, сойдёт\nза своего в любом городе континента.",
human_krewlod="Грубый дикарь, которому будут рады.\nна Западных Островах и в Расплатных пустошах:\nуж больно много их оттуда сбежало за последнее время.",
human_islander="Слава каннибалов с островов Залива Контрабандистов\nгремит по всей планете.",
human_enroth="Бывший мигрант не пойми откуда:\nтысячи демонопоклонников когда-то наводнили Свободную гавань и окрестности\nда так там и остались после разгрома культа.",
human_regnan="Пират, чьи предки веками наводили ужас\nна мореходов трёх континентов.",
elf_wood="лесной эльф",
elf_dark="тёмный эльф",
elf_snow="снежный эльф",
dwarf="Гном, грубая подгорная скотина, жрущая пиво пинтами.\nУстойчив к огнню, потому что кузнец, холоду, потому что борода,\nэлектричеству, потому что толстая шкура и к ядам,\nпотому что иначе сдох бы от алкогольного отравления.",
dwarf_dark="тёмный гном",
halfling="полурослик",
nordling="нордлинг",
hobgoblin="хобгоблин",
goblin="гоблин",
ogre="огр",
orc="орк",
troll="тролль",
minotaur="минотавр",
gremlin="гремлин",
kreegan="криганин",
demon="демон",
lizardman="ящеролюд",
gnoll="гнолл",
kobold="кобольд",
ratman="крысолюд"
};

lognames.classDescriptions={
fighter="Много мышц, мало мозгов,\nвладение колюще-режуще-дробяще-рубящими\nорудиями убийства. Таков боец.\nБоец может предпочитать ближний бой,\nлибо стрелковый, носить тяжёлые доспехи\n или делать ставку на подвижность.",
tricker="Вскрытие замкув и ловушек,\nразведка и подлые удары в спину —\nтакова специализация ловкача.",
novice="Магия послушника направлена\nпрежде всего на исцеление. Впрочем, он\nможет практиковаться и в боевых искусствах.",
acolyte="Одарённый владеет магией стихий: огонь и молнии, каменные шары и холод."
};

lognames.statDescriptions={
mgt="Сила — первейший атрибут для любого воина,\nведь именно от силы зависит количество наносимых в ближнем бою повреждений.\nКроме того, сила позволяет взламывать сундуки, сносить двери,\n и тащить на своём горбу уйма барахла, не считая доспехов.",
enu="Выносливость позволяет выдержать большее количество ударов и самому наносить оные без устали.",
spd="Скорость влияет на инициативу в бою,\nпозволяет чаще наносить удары и стрелять,\nпозволяет быстрее передвигаться и с большей эффективностью\nуклоняться от ударов.",
dex="Ловкость влияет на координацию движений,\nвесьма полезную характеристику\nдля взломщиков, специалистов по скрытым атакам\n и перемещениям.",
acu="Меткость очень полезна для тех,\nкто предпочитает бой на расстоянии,\nведь от того куда попадёт метательный снаряд,\nзависит сколько ущерба он нанесёт.\nВпрочем, полезна она и в ближнем бою.	",
sns="Восприятие позволяет видеть дальше,\nпотому весьма полезно для стрелков и атакующих магов.\nПомимо этого восприятие позволяет подмечать сокрытое,\nтщательней изучать различные механизмы и устройства.",
int="Интеллект определяет количество маны у элементалистов,\nпомогает вести умные беседы и находить неожиданные решения.",
spr="Духовность определяет количество маны у целителей,\nпомогает вести проникновенные беседы и убеждать в своей правоте.",
chr="Харизма влияет на отношение к вам жителей,\nснижает урон для репутации от враждебных или необдуманных действий.",
luk="Удача определяет вероятность критического удара,\n а также влияет на многие аспекты игры,\nособенно заметно её влияние\nна успех взлома замков, обезвреживания ловушек, краж.",
};

lognames.skillDescriptions={
sword="Навык владения мечами, палашами и саблями.",
axe="Навык владения топорами, секирами и полэксами.",
crushing="Навык владения дубинами, палицами, боевыми цепами и молотами.",
flagpole="Навык владения копьями, трезубцами, алебардами.",
staff="Навык владения посохами",
dagger="Навык владения кинжалами и ножами",
unarmed="Навык боя без оружия",
bow="Навык стрельбы из лука.",
crossbow="Навык стрельбы из арбалета",
throwing="Навык использования метательных ножей, топориков, звёзд.",
bodybuilding="Увеличивает живучесть и сатмину.",
armmastery="Улучшает владение оружием ближнего боя, влияет на парирование, контрудары, время восстановления.",
shield="Навык владения щитом",
dodge="Навык уклонения от атак",
fire="Магический навык",
water="Магический навык",
air="Магический навык",
earth="Магический навык",
body="Магический навык",
spirit="Магический навык",
mind="Магический навык",
alchemy="Приготовление зелий из собранных ингридиентов.",
picklocking="Навык вскрытия замков при помощи отмычек.",
traps="Навык обезвреживания ловушек",
diplomacy="Снижает негативное влияние поступков на репутацию, открывает новые ветки в диалогах",
leadership="Повышает мораль союзников.",
trading="Позволяет покупать дешевле, а продавать — дороже.",
repair="Навык починки оружия и доспехов.",
stealths="Навык скрытного перемещения.",
spothidden="Этот навык позволяет замечать тайники и ловушки",
meditation="Позволяет восстанавливать ману и стамину со временем.",
mysticism="Увеличивает максимальный запас маны.",
regeneration="Восстанавдивает очки жизни со временем.",
thievery="Навык избавления карманов прохожих от содержимого",
};

lognames.traders={
GoodChoice=" Торговец: Отличный выбор! \n",
PriceIs="Цена —",
RepairFor="Починю за ",
UsuallyI=" Торговец: Обычно я \n",
selling="прошу за такие вещи ",
buying="плачу за такие вещи ",
repairing="чиню такие вещи за ",
butyouaretradinggood="\nНо вы хорошо торгуетесь, \n моя цена — ",
butyourreputationbadsohigher="\nНо в связи с вашей репутацией \n цена выше — ",
butyourreputationbadsolower="\nНо в связи с вашей репутацией \n цена ниже — ",
notinterested="Не интересует!",
notmyspec="Не моя специализация!",
notenoughgold="Не хватает денег!",
canidfor="Оценю за "
};

lognames.zones={
total="", --общ.
head="голова",
body="тело",
hands="руки",
legs="ноги",
wings="крылья",
tail="хвост",
def="врожд."
};

lognames.buffs={
heroism="героизм",
fate="судьба",
bless="благословение",
prayer="молитва",
rage="ярость",
thirstofblood="жажда крови",
protfromfire="защита от огня", -- а надо ли?
protfromstatic="защита от статики",
protfromcold="защита от холода",
protfromlight="защита от света",
protfromdarkness="защита от тьмы",
protfromdisease="защита от болезни",
protofmind="защита разума",
protofspirit="защита духа",
shield="щит",
shieldoflight="щит света",
painreflection="отражение боли",
firebelt="щит ифрита",
fireprint="огненный след",
stoneskin="каменная кожа",
warrioroflight="воин света",
stoneskin="каменная кожа",
hammerhead="руки-молоты",
ironshirt="железная рубашка",
shieldfromfire = "щит от огня";
shieldfromcold = "щит от холода";
shieldfromstatic = "щит от статики";
shieldfromacid = "щит от кислоты";
regen="регенерация",
haste="спещшка",
mobility="вездеход",
torchlight="факел",
executor="палач",
wingsoflight="крылья света",
myrth="радость",
invisibility="невидимость",
waterwalking="хождение по воде",
levitation="левитация",
might="мощь",
dash="стремительность",
precision="меткость",
meditation="медитация",
glamour="гламур",
luckyday="удачный день"};

lognames.protectionmodes={
protectionmode="стойка: ",
dodge="уклонение",
parry="парирование",
block="блок",
none="боевая"
};

lognames.mindgame={
actionslost="осталось действий",
threat="угроза",
pain="побью",
injur="покалечу",
death="убью",
hit="ударить",
bribery="подкуп",
gift="подарок",
joke="пошутить",
secret="рассказать",
say="сказать",
call="назвать",
affront="оскорбить",
--
beggar={"нищий","нищенка","нищее"},
poor={"бедняк","бедная","бедное"},
middleclass={"средний класс","средний класс","средний класс"},
prosperous={"зажиточный","зажиточная","зажиточное"},
rich={"богатый","богатая","богатое"},
superrich={"очень богатый","очень богатая","очень богатое"},
fantasticrich={"безумно богатый","безумно богатая","безумно богатое"},
greedy={"жадина","жадина","жадина"},
donationstaker={"сборщик пожертвований","сборщица пожертвований","сборщик пожертвований"},
incorruptable={"неподкупный","неподкупная","неподкупное"},
disinterested={"аскет","аскет","аскет"},
goldhater={"златоненавистник","златоненавистница","златоненавистник"},
--
fatalist={"фаталист","фаталистка","фаталист"},
masohist={"мазохист","мазохистка","мазохист"},
coward={"трус","трусиха","трусливое"},
scaremonger={"паникёр","паникёрша","паникёр"},
brave={"храбрец","храбрая","храброе"},
honored={"гордец","гордячка","гордое"},
suicider={"самоубийца","самоубийца","самоубийца"},
--
teetotaller={"трезвенник","трезвенница","не пьёт"},
suffering={"язвенник","язвенница","язвенник"},
boozer={"выпивоха","бухает","любит выпить"},
alcoholic={"алкоголик","алкоголик","алкоголик"},
enophil={"знаток","знаток","знаток"},
drinkswithfriends={"пьёт с друзьями","пьёт с друзьями","пьёт с друзьями"},
drinkswithequal={"пьёт с кем надо","пьёт с кем надо","пьёт с кем надо"},
--
weak_willed={"слабовольный","слабовольная","слабовольное"},
inflexible={"несгибаемый","несгибаемая","несгибаемое"},
boundless={"беспредельщик","беспредельщица","беспредельное"},
--
informer={"доносчик","доносчица","доносчик"},
};

lognames.bodypartsr = {
hand="руку",
leg="ногу",
eye="глаз",
head="голову",
body="тело"
};

lognames.descriptions = {
wellclean="Колодец наполнен чистой холодной водой.",
wellmagical="Колодец наполнен чистой холодной водой, по которой пробегают разноцветные искорки.",
welldry="Колодец давно пересох: песок почти достиг бортиков.",
wellbad="Вода в колодце мутная от неё исходит сильный неприятный запах.",
wellevil="Колодец будто заполнен смолой, чёрной и вязкой.",
welldungeon="В колодцы нет воды, вы не видите в темноте дна. Туда, во тьму, спускается верёвка...",
};

lognames.itemmodifers = {
offire="огня",
offlame="пламени",
ofinferno="испепеления",

ofcold="холода",
offrost="мороза",
ofblizzard="стужи",

ofsparks="искр",
oflightning="молнии",
ofthunderbolts="грозы",

ofpoison="отравы",
ofvenom="яда",
oftoxicity="токсичности",

ofcorrosion="коррозии",
ofacid="кислоты",
oferosion="растворения",

ofpain="боли",
ofdistress="страданий",
ofsuffering="истязаний",

ofspiritless="бездуховност",
ofunholiness="безблагодатности",
ofsoulkilling="душегубства",

ofsparkle="вспышки",
oflight="света",
sunshining="сияния",

ofshadow="тени",
oftwilight="сумерек",
ofdarkness="тьмы",

ofice="льда",
ofglaciation="оледенения",
ofpermalfrost="мерзлоты",

ofstone="окаменения",
ofmedusa="медузы",
ofbasilisk="василиска",

ofimmobilizing="обездвиживания",
ofparesis="пареза",
ofparalize="паралича",

ofblooddropping="кровеотворения",
ofbleeding="кровотечения",
ofbloodloosing="кровепотери",

ofshock="шока",
ofdeafen="ошеломления",
ofstun="оглушения",

ofpacify="усмирения",
ofpeacemaking="умиротворения",
ofnirvana="нирваны",

ofdoze="дремоты",
ofsleeping="сна",
ofmorpheus="морфея",

offear="страха",
ofpanic="паники",
ofterror="террора",

ofmanaburning="манасожжения",
ofantimagic="антимагии",
ofmagicless="безмагии",

ofindisposition="недомогания",
ofdisease="болезни",
ofplague="чумы",

ofdelay="замедления",
ofslowing="медлительности",
ofstopping="остановки",

ofweakening="ослабления",
ofweakness="слабости",
ofweariness="изнеможения",

ofvinocity="опьянения",
ofdoping="одурманивания",
ofthornapple="дурмана",

ofarachnophobia="арахнофобии",
ofherbicide="гербицида",
ofantichimerism="антихимеризма",

ofgiantomachia="гигантомахии",
ofreptilehating="гадофобии",
ofmisanthropy="мизантропии",

ofdragonslaying="драконоборства",
ofallaying="упокоения",
ofsculpture="скульптуры",

ofamorphism="аморфности",
ofbeastslaying="звероборства",
ofdemonslaying="демоноборства",

ofvampirism="вампиризма",
ofastralthievery="астрального воровства",
ofstarvation="истощения",

ofmight="мощи", --mgt
ofthought="дум", --int
ofvigor="бодрости", --enu
ofprecision="прицеливания", --acu
offash="сипемительности", --spd
ofluck="удачи", --luk
ofcharm="шарма", --chr
ofspirituality="духовности", --spr
ofperception="восприятия", --sns
ofcoordination="координации", --dex

ofwizards="волшебника", --int/spr
ofwarriors="воина", --mgt/enu
ofrogues="плута", --spd/dex
ofarchers="лучника", --acu/sns
ofbards="барда", --chr/luk

ofsun="солнца", --mgt/spr
ofmoon="луны", --int/luk
ofstars="звёзд", --enu/acu
ofsky="неба",--sns/spd
ofgame="игры",--dex/chr

ofgods="богов", --all

offireresistance="устойчивости к огню",
ofcoldreresistance="устойчивости к холоду",
ofstaticreresistance="устойчивости к статике",
ofpoisonreresistance="устойчивости к яду",
ofacidreresistance="устойчивости к кислоте",
ofdiseasereresistance="устойчивости к болезни",
ofmindreresistance="устойчивости к разуму",
ofspritreresistance="устойчивости к духу",
oflightreresistance="устойчивости к свету",
ofdarknessreresistance="устойчивости к тьме",
ofelementsreresistance="устойчивости к элементам", --fire/cold/static
ofegoreresistance="устойчивости к эго", --mind/spirit
ofdualreresistance="устойчивости к двойственности", --light/darkness
ofchemistryreresistance="устойчивости к алхимии", --acid/poison
ofmagicalreresistance="устойчивости к магии", --all

oflife="жизни",
ofmana="маны",
ofstamina="выносливости",
ofregeneration="регенерации",
ofmeditation="медитации",
oftireless="неутомимости",

ofalarms="тревоги", --sleep
ofantidotes="антидота", --poison
ofincombastibility="неопалимости", --flame
ofunbelieving="безверья", --all types of curses (curse,misfortune,fingerofdeth,filth,darkcontamination,darkgasp,evileye*,basilisbreath*)
ofantifreeze="антифриза", --freeze
ofimmunity="иммунитета", --disease
ofsanity="святости", --madness, massfear?
ofselfcontrol="самоконтроля", --panic,berserk,control
ofreedom="свободы", --paralyse
ofmedusa="медузы", --stone
ofbonehead="костяной башки", --stun

ofdefence="защиты",
ofshielding="щита",
ofifrit="ифрита",
offiretrack="огненного следа",
officetrack="ледяного следа",
ofpoisontrack="ядовитого следа",
ofplaguetrack="чумного следа",
ofpower="силы",
ofrecovery="восстановления",
ofsaintblood="святой крови",

ofdoom="судьбы", 	--all stats +1

ofpheonix="феникса", --fire rez +30, regen HP 	
oftroll="тролля", 	--enu +15, regen HP
ofgolem="голема", 	--AC +5, DT+5, DR+20
ofunicorn="единорога", --luk +15, regen SP
ofevileye="злобоглаза", --int/acu/sns
oftitan="титана", --rez static +30, regen ST
oficegiant="ледяного великана", --cold rez +30, mgt+15

ofdrunkorc="пьяного орка", --перманентное опьянение
ofbloodymadness="кровавого безумия", --перманентно жажда крови, постоянная потеря hp, периодические берсерки 
--ofmagic * schools ?
};

fountains={
"В вашу голову закрадывается мысль, что вы ещё вернётесь к этому фонтану...",
"Последнее время даже паладины не купаются в фонтанах!",
"Вы уже купались в этом фонтане в прошлый раз!",
"Знакомый фонтанчик!"
};
