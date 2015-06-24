chats = {};
function chats.load ()
	chats.whoru_im={"Дед Пыхто!","Конь в пальто!","Хрен в манто!"};
	chats.rules={
	{{question=1,answer=2,nextquestion={4,7},remquestion={0},default=true},{question=2,answer=3,nextquestion={5},remquestion={0},default=true},{question=3,answer=4,nextquestion={6},remquestion={0},default=true},{question=4,answer=5,nextquestion={0},default=false},{question=5,answer=6,nextquestion={0},default=false},{question=6,answer=7,nextquestion={0},default=false},{question=7,answer=math.random(1,2)+7,nextquestion={0},default=false}},
	{{question=1,answer=2,nextquestion={0},remquestion={0},default=true},{question=2,answer=3,nextquestion={0},remquestion={0},default=true},{question=3,answer=4,nextquestion={chats.ifCondition("skill","diplomacy",3,10,2,4,0)},remquestion={0},default=true},{question=4,answer=5001,nextquestion={0},remquestion={0},default=false}},
	{{question=1,answer=2,nextquestion={0},remquestion={0},default=true},{question=2,answer=3,nextquestion={3,4,5},remquestion={6},default=true},{question=3,answer=2001,nextquestion={0},default=false},{question=4,answer=2002,nextquestion={0},default=false},{question=5,answer=2011,nextquestion={0},default=false},{question=6,answer=2101,nextquestion={0},remquestion={0},default=true}},
	{{question=1,answer=2,nextquestion={0},remquestion={0},default=true},{question=2,answer=1001,nextquestion={0},remquestion={0},default=true}},
	{{question=1,answer=2,nextquestion={0},remquestion={0},default=true},{question=2,answer=3,nextquestion={3},remquestion={0},default=true},{question=3,answer=2004,nextquestion={0},default=false}},
	{{question=1,answer=2,nextquestion={0},remquestion={0},default=true},{question=2,answer=3,nextquestion={3},remquestion={0},default=true},{question=3,answer=2006,nextquestion={0},default=false}},
	{{question=1,answer=2,nextquestion={0},remquestion={0},default=true},{question=2,answer=1003,nextquestion={0},remquestion={0},default=true}},
	 --thiefcatched; save by: chr spr int luk also: spd dex str none: sns enu acu
	{{question=1,answer=2,nextquestion={3,4,chats.ifCondition("skill","diplomacy",3,10,2,2,0)},remquestion={0},default=true},{question=2,answer=5001,nextquestion={0},remquestion={0},default=false},{question=3,answer=chats.ifCondition("stat","luk",0,0,4,7777,3),nextquestion={0},remquestion={0},default=false},{question=4,answer=chats.ifCondition("stat","chr",0,0,4,7777,4),nextquestion={0},remquestion={0},default=false},{question=4,answer=chats.ifCondition("stat","int",0,0,4,7777,5),nextquestion={0},remquestion={0},default=false},{question=4,answer=chats.ifCondition("stat","spr",0,0,4,7777,6),nextquestion={0},remquestion={0},default=false},{question=5,answer=7001,nextquestion={0},remquestion={0},default=true}},
	};
	chats.questions = {
	{chats.questionPerEtiquette("whoru",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),chats.questionPerEtiquette("whattheplace",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette), "Кто мы?", "А звать-то как?", "Как мы сюда попали?","Знать бы...","И на кого же ты тут охотишься?"},
	{chats.questionPerEtiquette("whoru",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),chats.questionPerEtiquette("whatrudoinghere",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),"Покажи дорогу к ближайшему городу!","Попробую тебя убедить..."},
	{chats.questionPerEtiquette("whattheplace",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),"Могу я что-нибудь купить?","На данный момент хотелось бы прикупить доспехов.","Оружие — вот что меня интерсует!","Нет ли зачарованного оружия?","Взгляните на то, что есть..."},
	{chats.questionPerEtiquette("whattheplace",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),"Ладно."},
	{chats.questionPerEtiquette("whattheplace",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),"Могу я что-нибудь купить?","Мне б похимичить..."},
	{chats.questionPerEtiquette("whattheplace",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),"Мне требуются магические вещи."},
	{chats.questionPerEtiquette("whattheplace",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),"Мне требуется лечение."},
	{chats.questionPerEtiquette("whathappened",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),chats.questionPerEtiquette("icanprooveit",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),chats.questionPerEtiquette("thiefranaway",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette), chats.questionPerEtiquette("iamnotathief",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette), chats.questionPerEtiquette("leavemealone",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),chats.questionPerEtiquette("notthiefbutsmart",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette),chats.questionPerEtiquette("notthiefbutspritual",chars_mobs_npcs[current_mob]["personality"]["current"].etiquette)}, --thiefcatched
	};
	chats.answers = {
	{"Ты глянь...","Я-то? Охотник, бродяга... Так ли это важно?", "Западный Крюлод, вернее то, что от него осталось после Расплаты.","Четыре подозрительных типа. Перепили или со скалами удачно пободались?","Имя — тлен!", "Вероятно, вас выбросило на берег волнами.", "Амнезия, стало быть. У всех четверых разом, да?", "На кроликов.", "На наивных дурачков вроде вас."};
	{"Принесла нелёгкая...",chats.rndanswer(chats.whoru_im),"Не твоё дело!","Отвали!","Щаззз..."},
	{"У нас посетитель!","В торговую лавку: краденное, конфискат, мародёрка и прочий хабар!","Лучшие цены на десять дней пути!","Отлично!","Поможем продать, починить, опознать!"},
	{"Вы к кому?","Напарника спроси, расскажет."},
	{"У нас посетитель!","Алхимия! Рецепты, реагенты, инструменты!!","Купить, продать, обогатиться знаниями!","Отлично!"},
	{"У нас посетитель!","В волшебную лавку!","Купить, продать, починить, опознать!","Отлично!"},
	{"В здоровом теле — здоровый дух!","К целителю!","Исцеляем тело, душу и разум!","Отлично!"},
	{chats.questionPerEtiquette("gotyouthief",chars_mobs_npcs[victim]["personality"]["current"].etiquette),chats.questionPerEtiquette("youarethief",chars_mobs_npcs[victim]["personality"]["current"].etiquette),chats.questionPerEtiquette("iliketales",chars_mobs_npcs[victim]["personality"]["current"].etiquette),chats.questionPerEtiquette("lookinglikeathief",chars_mobs_npcs[victim]["personality"]["current"].etiquette)}, --thiefcatched
	};
	chats.tags={
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	};
end;

function chats.questionPerEtiquette(question,etiquette)
	local questions = {
	whoru={none="Кто ты?",peasant="Ты кто?",criminal="Ты чо за фраер?",noble="С кем имею честь беседовать?",warrior="Имя, звание, кто командующий?",lightpriest="Назови имя своё, чадо!",darkpriest="Что написать на твоём надгробии, жертва?",savage="Твоя есть кто?",scientist="Могу я узнать ваше имя?"},
	whatrudoinghere={none="Что ты здесь делаешь?",peasant="Что за дела у вас туточки?",criminal="Ты чо тут творишь?",noble="Соблаговолите назвать цель вашего здесь пребывания!",warrior="Доложить оперативную задачу!",lightpriest="Что за дела привели тебя сюда, чадо?",darkpriest="Что привело тебя сюда в этот недобрый час, жертва?",savage="Твоя тут чего делать?",scientist="Могу я узнать, что вы в настоящий момент делаете?"},
	whattheplace={none="Куда это я зашёл?",peasant="Где это я?",criminal="Чо за место? Вроде не каторга?",noble="Не подскажете ли, что это за место?",warrior="Доложить дислокацию!",lightpriest="В каком месте этого пресветлого мира я нахожусь?",darkpriest="Куда это демоны меня занесли?",savage="Моя не знать где есть...",scientist="Не просветите ли меня по поводу моего нынешнего местонахождения?"},
	--gold
	goldok={none="Хм, золото...",peasant="Монетки!",criminal="Эге, рыжьё!",noble="Эта скромная сумма будет весьма кстати.",warrior="О, золотишко!",lightpriest="Дела твои угодны Свету!",darkpriest="Даже Тьма не против блеска золота!",savage="Моя радоваться!",scientist="Замечательно, обожаю этот благородный металл!"},
	goldnotenough={none="Что это, и почему так мало?!",peasant="Маловато будет!",criminal="Э, шо за? Чо так мало?!",noble="Раздайте эту мелочь нищим!",warrior="Маловато будет!",lightpriest="Жадность есть грех, чадо!",darkpriest="Больше давай, Тьма тебя возьми!",savage="Золота давай-давай!",scientist="Сумма явно недостаточна!"},
	goldtoomuch={none="Тревожно как-то...",peasant="Чой-та мнговато...",criminal="Чо за подстава?!",noble="Вы чего-то не договариваете, господа!",warrior="Ты во что меня втянуть хочешь?!",lightpriest="Чую недоброе ты задумал, чадо!",darkpriest="Твоя душа чернее самой Тьмы!",savage="Твоя странно делать...",scientist="Не могу уверенно интерпретировать ваши действия..."},
	goldagro={none="Сейчас получишь!",peasant="От сейчас по репе-то и словишь!",criminal="За лоха держишь?!",noble="Ваше предложение оскорбительно!",warrior="Жить надоело?!",lightpriest="Ересь великую чувтсвую я в тебе!",darkpriest="Готовься к нежизни!",savage="Моя твоя злиться!",scientist="А не пустить ли вас на опыты?"},
	goldincor={none="Мне чужое без надобности!",peasant="Мне чужой бедноты не нать!",criminal="Себе оставь!",noble="Сдаётся мне, вы пытаетесь меня подкупить...",warrior="Мне взятку предлагать?!",lightpriest="Не ввергни ближнего своего во искушение!",darkpriest="Тьма хранит меня от соблазнов!",savage="Моя такое не есть!",scientist="Презренный металл..."},
	boring={none="Ты тратишь моё время!",peasant="По делу чего сказать можешь?",criminal="Порожняк не гони!",noble="Вы утомительны, подите прочь...",warrior="До чего ж нудные типы среди шпаков встречаются...",lightpriest="Смирение ведёт души к свету...",darkpriest="Сделать бы из тебя зомби — всё повеселей стал бы...",savage="Моя скучать...",scientist="И это всё, что вы можете предложить?"},
	iwilltraityou={none="Я буду жаловаться!",peasant="Доложить о тебе надоть...",criminal="Сдам я тебя пожалуй...",noble="Я вынужден буду доложить о вашем поведении!",warrior="Похоже, кто-то за тебя премию получит...",lightpriest="В Храм Света стоит препроводить тебя, грешник!",darkpriest="Сперва, конечно, пытки, а затем на алтарь...",savage="Моя твоя съесть!",scientist="Вы знаете, мне как раз нужны добровольцы для опытов..."},
	donation={none="Благодарим за пожертвование!",peasant="Вот за это наше вам спасибочки!",criminal="Бг-га-га, ну ты даёшь, красава!",noble="Это воистину благое деяние!",warrior="Отлично, солдат!",lightpriest="Дела твои угодны Свету!",darkpriest="Даже Тьма не против блеска золота!",savage="Твоя делать гуманитарная помощь?",scientist="Это пойдёт на нужды науки!"},
	--threats
	wtfurdoing={none="Э, полегче!",peasant="Ты чегой-та?",criminal="Ты чо, краёв не чуешь?!",noble="Что вы себе позвляете!",warrior="Жить надоело?",lightpriest="Неправедны дела твои, чадо!",darkpriest="Зомби, только тупой зомби из тебя и получится...",savage="Совсем дурной башка, да!",scientist="Уровень вышего интеллектуального развития представляется мне крайне низким."},
	dontpainme={none="Зачем уж так-то?",peasant="Ты чегоё-та прям как зверь какой?",criminal="Совсем беспредельщик?",noble="Мы можем прийти к компромиссу!",warrior="Предлагаю перемирие!",lightpriest="Свет да убережёт меня!",darkpriest="Не стоит убивать бесплатно!",savage="Моя не спорить с большой босс!",scientist="Вынужден уступить под давлением..."},
	dontkillme={none="Не убивай меня!",peasant="Ой как жить охота!",criminal="Честного гражданина убивают!",noble="Ты не посмеешь! Я уважаемый человек!",warrior="Предлагаю перемирие!",lightpriest="Убийство слуг Света суть преступление против него же!",darkpriest="Без Тьмы не будет Света!",savage="Моя сдаваться!",scientist="Моя смерть будеть большой потерей для мировой науки!"},
	panic={none="Спасите-помогите!",peasant="А-а-а!!!",criminal="Разбойники здоровья лишить хотят!",noble="На помощь! Благородный в опасности!",warrior="Враги пришли! Нужно подкрепление!",lightpriest="Все на помощь, а то костёр!",darkpriest="Все на помощь, а то прокляну!",savage="А-а-а!!!",scientist="Спасайте научное светило!"},
	busido={none="Чему быть, того не миновать.",peasant="Двум смертям не бывать, а одной не миновать…",criminal="Все там будем.",noble="Я приму смерть с честью!",warrior="Путь воина ведёт к смерти!",lightpriest="Что ж, я уйду в Свете...",darkpriest="Смерть не является окончанием существования!",savage="Моя сдохнуть. никто не плакать.",scientist="Всё в мире имеет начало и конец."},
	brave={none="Этим меня не напугать!",peasant="А ты не пужжай!",criminal="Ша, сявки, малы ишшо на старших тявкать!",noble="Я смеюсь над вашими угрозами!",warrior="На войне и пострашнее бывало!",lightpriest="Свет хранит меня, чадо!",darkpriest="Пугать Тьму смертью... Как глупо!",savage="Моя быть из гордый племя! Моя не бояться!",scientist="Я многое сделал за свою жизнь, смерть не страшит меня."},
	masohist={none="Да, сделай мне больно!",peasant="А мы к кнуту привычные!",criminal="А-ха, это я люблю!",noble="Что может быть лучше утончённых пыток?!",warrior="Давненько я кнута не получал! Хоть на борделе сэкономлю!",lightpriest="Страдания укрощают плоть!",darkpriest="Тьма и Боль хорошие подруги!",savage="Моя любить боль!",scientist="Вы умеете находить оригинальный подход!"},
	agro={none="Сейчас получишь!",peasant="От сейчас по тыкве настучу!",criminal="Да за такое я тебя на ремни порежу!",noble="Подобные слова смываются кровью!",warrior="Жить надоело?!",lightpriest="Ересь великую чувтсвую я в тебе!",darkpriest="Готовься к нежизни!",savage="Моя твоя злиться!",scientist="Вы вынуждаете меня прекратить ваше существование!"},
	illpainyou={none="Сейчас кому-то будет больно...",peasant="Вот я тя сейчас оглоблей!",criminal="Ща я тя резать-бить буду!",noble="Вы вынуждаете меня прибегнуть к силовому воздействие!",warrior="Сейчас я тебе рыло-то начищу!",lightpriest="Страдания закаляют душу, чадо!",darkpriest="Я знаю о боли всё!",savage="Моя твоя делать бо-бо!",scientist="Сейчас мы проверим работу  ваших болевых рецепторов!"},
	illinjuyou={none="Калекам нынче живётся не очень...",peasant="Изувечу я тебя сейчас!",criminal="Ну чо у тя там лишнего в организме?",noble="Придётся вас немного покалечить!",warrior="Ну что, калека¸приступим?",lightpriest="У светлых храмов калекам неплохо подают...",darkpriest="Кажется, мне понадобятся кое-какие органы для моих зомби...",savage="Моя твоя кромсать!",scientist="Мне пригодятся кое-какие ваши органы для опытов..."},
	illkillyou={none="Сейчас ты умрёшь.",peasant="От сейчас тебя и упокоим!",criminal="Ну чо, жмур, продолжим разговор?",noble="Какой вид казни предпочитаете?",warrior="Зарубить тебя иль повесить?",lightpriest="Да примет тебя Свет!",darkpriest="Готовься к нежизни!",savage="Моя твоя убивать!",scientist="Похоже, ваша жизнь подошла к концу..."},
	suicide={none="Прощай, унылый мир!",peasant="Сдохну, так сдохну. Жизнь моя бесплатная!",criminal="Отбегался таки...",noble="Моё время давно пришло...",warrior="#@X!",lightpriest="Свет примет меня!",darkpriest="Тьма примет меня!",savage="Духи предков ждать меня!",scientist="Вот, собственно, и всё."},
	cry={none="Хнык!",peasant="Эх, долюшка землепашеская...",criminal="Не плачь, не бойся, не проси...",noble="Это печально...",warrior="Эх, жизнь моя портянка!",lightpriest="Свет воздаст за мои слёзы!",darkpriest="Тьма воздаст за мои слёзы!",savage="Моя плакать!",scientist="Уныние и безнадёжность..."},
	
	hit={none="Н-на-нах!",peasant="Хэк!",criminal="Оба!",noble="Ха!",warrior="Ух!",lightpriest="Ха!",darkpriest="Ха!",savage="Ых!",scientist="На!"},
	ear={none="Н-на-нах!",peasant="Хэк!",criminal="Оба!",noble="Ха!",warrior="Ух!",lightpriest="Ха!",darkpriest="Ха!",savage="Ых!",scientist="На!"},
	finger={none="Н-на-нах!",peasant="Хэк!",criminal="Оба!",noble="Ха!",warrior="Ух!",lightpriest="Ха!",darkpriest="Ха!",savage="Ых!",scientist="На!"},
	eye={none="Н-на-нах!",peasant="Хэк!",criminal="Оба!",noble="Ха!",warrior="Ух!",lightpriest="Ха!",darkpriest="Ха!",savage="Ых!",scientist="На!"},
	--magic
	berserk={none="Как ты меня бесишь!",peasant="Ох, зашибу!",criminal="Кровь пущу!",noble="Вы преизрядно меня раздражаете!",warrior="Ага, вражина, попался!",lightpriest="Злоба — грех пред лицом Света!",darkpriest="О да, люблю это чувство!",savage="Моя злиться!",scientist="Я ощущаю некоторую эмоциональную нестабильность."},
	charm={none="А ты ничего так...",peasant="Чот ты мне уже нравишься...",criminal="А ты ничо, из своих...",noble="Вы несомненно вызываете симпатию.",warrior="Дай я тя поцелую!",lightpriest="Ты идёшь в свете, чадо!",darkpriest="А ты ничего так, даже жаль будет убивать...",savage="Моя находить друга!",scientist="Рад знакоству, вне всякого сомнения рад!"},
	fear={none="Не трогай меня!",peasant="Жуть-то кака!",criminal="Ты чо жути напускаешь?!",noble="Вам меня не напугать… …наверное.",warrior="Страшно, как на войне!",lightpriest="Свет, оборони меня!",darkpriest="Тьма, придай мне сил!",savage="Духи предков помогать мне!",scientist="Я испытываю некий душевный дискомфорт."},
	--thievery
	whathappened={none="Что стряслось?",peasant="Ась? Чегось?",criminal="Чо за дела?",noble="Будьте так любезны прояснить сложившуюся ситуацию!",warrior="Доложить обстановку!",lightpriest="Исповедуйтесь, грешники!",darkpriest="Что?!",savage="Что быть?",scientist="А? Что?"},
	icanprooveit={none="Я всё объясню!",peasant="Бесы попутали!",criminal="Ща всё по понятиям перетрём!",noble="Коль вам недостаточно моего слова, я могу привести неопровержимые доказательства своей правоты.",warrior="Сейчас всё разъясню согласно уставу!",lightpriest="Свет подтвердит мои слова!",darkpriest="Тьма мне в свидетели!",savage="Моя объяснять!",scientist="Выслушайте мои аргументы!"},
	leavemealone={none="Отстань от меня!",peasant="А ну посторонись-ка!",criminal="Отвали, терпила!",noble="Отойди, смерд!",warrior="Отставить!",lightpriest="Изыди, отродье тьмы!",darkpriest="Уйди, смертный!",savage="Твоя идти вон!",scientist="Вы отвлекаете меня от мыслей о высоком!"},
	thiefranaway={none="Туда, он побежал туда!",peasant="Держи вора!",criminal="Вон он поскакал, век воли не видать!",noble="Посмотрите в ту сторону!",warrior="Вижу цель! Тащит кошелёк! Ату его!",lightpriest="Будь внимательней, чадо!",darkpriest="Вон он, прячется в тени!",savage="Вор убегать! Твоя смотреть!",scientist="Вы неверно оценили направление угрозы, ваши ценности во-он там!"},
	iamnotathief={none="Чтоб я и воровал?",peasant="От земли кормлюсь, воровству не обучен!",criminal="Гонево! Не я это!",noble="Благородство — это не пустой звук! Воровство — удел низших сословий!",warrior="Дезинформация! Я и на войне неплохо зарабатываю!",lightpriest="Обвиняя меня, чадо, ты обвиняешь Свет!",darkpriest="Тьма не опускается о воровства!",savage="Моя быть честный!",scientist="Любой суд опровергнет ваши голословные обвинения!"},
	notthiefbutspritual={none="В грехе меня обвиняешь!",peasant="Не по совести твои слова сказаны!",criminal="Не суди, да не судим будешь!",noble="Я принадлежу к высокодуховному сословию, что не опускается до воровства!",warrior="Юоги войны, взгляните на это непотребство!",lightpriest="Безблагодатны твои слова!",darkpriest="Чёрен твой дух, и не тьме он подобен, а сухому дерьму!",savage="Духи предков завещали не воровать!",scientist="Призовём в судьи священника!"},
	notthiefbutsmart={none="Так-так, вы свидетель? Сейчас позовём стражу!",peasant="От земли кормлюсь, воровству не обучен!",criminal="Пасмари на себя: кого потянет от такого зрелища на дело?",noble="У меня достаточно средств, чтоб купить любого с потрохами!",warrior="О, разрешите представиться: королевский вербовщик! Желаете наняться на войну?",lightpriest="Давно ли посещали храм, исповедовались ли во грехах?",darkpriest="Пройдемте в наш храм, там будут рады будущей жертве... ... я хотел сказать, несчастной жертве преступления!",savage="Моя быть дикий. Твоя хорошо подумать, прежде чем говорить моя плохие слова?",scientist="Знакомы ли вам законы этой местности в части наказания за ложное обвинение?"},
	
	gotyouthief={none="О, ворюга!",peasant="А-а-а, жулик!",criminal="Попалась, крыса!",noble="Сколь недостойно вы себя ведёте!",warrior="Противник обнаружен!",lightpriest="Свет, помилуй грешников!",darkpriest="Новая жертва!",savage="Моя твоя поймать!",scientist="Сожалею, но вы попались на попытке воровства."},
	youarethief={none="Кое-кто пытался меня ограбить...",peasant="От ворьё!",criminal="Ты чо барана включил?",noble="Никакого благородства...",warrior="Цыц, ворюга, вражья морда!",lightpriest="Покайся ибо лишь раскаившиесф в своих злодеяниях спасутся!",darkpriest="Тем приятней будет тебя препарировать!",savage="Твоя притворяться дурачком!",scientist="Этоn вопрос в ведении нашей судебной системы."},
	iliketales={none="Врёшь!",peasant="Брехня!",criminal="Порожняк гонишь!",noble="Ложь, гнусная ложь.",warrior="Брехня!",lightpriest="Ложь есть грех!",darkpriest="Обмануть меня? Какая наивность!",savage="Твоя врать!",scientist="Ваши слова вопиюще неверны!"},
	lookinglikeathief={none="В зеркало на харю свою вороватую глянь!",peasant="Ворюга, как есть ворюга!",criminal="А то вор вора не узнает! Ой...",noble="Ваша гнуснейшая рожа не внушает мне ни малейшего доверия...",warrior="Вижу цель! Тащит кошелёк! Ату его!",lightpriest="Свет видит твою чёрную душу насквозь, чадо!",darkpriest="Какое восхитительное нахальство!",savage="Твоя моя не провести!",scientist="Глядя на вас и вспоминая последние достижения физиогномики... Нет, не верю!"},
	
	--mindgame phrases
	goodjoke={none="А-ха-ха!!!",peasant="От эт ты мощно!",criminal="От это кора!!!",noble="Это, право, забавно.",warrior="Вот смех-то!",lightpriest="Хорошая штука, но громко выражать радость мне не по сану",darkpriest="Смешно.",savage="Гы-гы-гы!",scientist="Хм, юмор…"},
	badjoke={none="Не смешно.",peasant="Чегось?",criminal="Чот как-то не очень…",noble="Неуместный юмор.",warrior="Несмешные у тебя шутки!",lightpriest="Мне случалось и за меньшее на костёр отправлять…",darkpriest="Люблю юмористов. Когда на алтаре лежат.",savage="Шутка быть плохой.",scientist="Иногда лучше молчать."},
	knownjoke={none="Не новость ни разу.",peasant="Слыхивали ужо...",criminal="Баян.",noble="Современная культура добирается в провинцию с большим опозданием.",warrior="Кто в армии служил — тот в цирке не смеётся!",lightpriest="На исповеди и не такое услышать можно.",darkpriest="На алтаре лёжа и не такое рассказывали.",savage="От шаман ещё дитём быть слыхал.",scientist="Читано и не раз."},
	mysecret={none="Откуда знаешь?!",peasant="Кто растрепал?",criminal="Кто напел?!",noble="Значит, шантаж…",warrior="Утечка секретных данных!",lightpriest="Болтливость грех…",darkpriest="Чувствуется работа мастеров дознания…",savage="Откуда знать?!",scientist="Иглу в мешке не утаить…"},
	interestinginformation={none="Буду знать.",peasant="Эт мы учтём...",criminal="От за наводку наше вам спасибочки!",noble="Благодарю за информацию.",warrior="Свежее донесение разведки!",lightpriest="Верное решение — рассказать всё мне!",darkpriest="Пригодится.",savage="Запомнить.",scientist="Знания лишними не бывают!"},
	whocares={none="Плевать.",peasant="Да наплевать!",criminal="И чо?",noble="Ваши известия не представляют интереса.",warrior="Чушь.",lightpriest="Не интересно.",darkpriest="Не интересно.",savage="Пффф.",scientist="Информация с нулевой ценностью."},
	asphyxia={none="Ы-Ы-Ы!!!",peasant="Ы-Ы-Ы!!!",criminal="Ы-Ы-Ы!!!",noble="Ы-Ы-Ы!!!",warrior="Ы-Ы-Ы!!!",lightpriest="Ы-Ы-Ы!!!",darkpriest="Ы-Ы-Ы!!!",savage="Ы-Ы-Ы!!!",scientist="Ы-Ы-Ы!!!"},
	sleep={none="ХР-ХР-Р!!!",peasant="ХР-ХР-ХР!!!",criminal="ХР-ХР-Р!!!",noble="ВХР-ХР-Р!!!",warrior="ВХР-ХР-Р!!!",lightpriest="ХР-ХР-Р!!!",darkpriest="ХР-ХР-Р!!!",savage="ХР-ХР-Р!!!",scientist="ХР-ХР-Р!!!"},
	likeathreat={none="Звучит как угроза…",peasant="Чего стращаешь?",criminal="Вон ты у кого в авторитете...",noble="Весьма сомнительные знакомства!",warrior="Не пугай, пуганые мы!",lightpriest="Ибо сказано: утащит грешник за собой немало душ невинных!",darkpriest="Кто они в сравнении с Тьмой?",savage="Плохие знакомые быть.",scientist="Скажи мне, кто твой друг…"},
	likeathreat={none="Блат, значит.",peasant="Эт да, эт уважить надоть...",criminal="Авторитеты в ход пошли…",noble="Я вижу, у вас обширные связи!",warrior="Знаем таких, ага.",lightpriest="Достойные знакомства.",darkpriest="Достойные знакомства.",savage="Моя уважать.",scientist="Достойные знакомства."},
	feelglad={none="А-ха-ха!!!",peasant="Прям душа развернулась и свернулась!",criminal="От это кайф!!!",noble="Ощущаю положительные эмоции...",warrior="Радостно-то как!",lightpriest="Свет!",darkpriest="Тьма!",savage="Ы-ы-ы!",scientist="Чувствую прилив позитивной энергии."},
	feelglad={none="У-у-у...",peasant="Тоска-печаль...",criminal="Кайфолом...",noble="Как-то, право, грустно...",warrior="Тоска...",lightpriest="Уныние есть грех пред Светом...",darkpriest="Будто у Светляков в храме...",savage="Моя быть плохо...",scientist="Чувствую отток позитивной энергии."},
	mymaster={none="Слушаюсь!",peasant="Чего изволите?",criminal="Да, начальник!",noble="Да-да?",warrior="Так-точно!",lightpriest="Сам Свет говорит твоими устами...",darkpriest="Сама Тьма говорит твоими устами...",savage="Хозяин?",scientist="Выполняю!"},
	curedmind={none="Отпустило...",peasant="Полегчало...",criminal="Пронесло...",noble="Чувствую себя лучше...",warrior="Мимо прошла!",lightpriest="Свет!",darkpriest="Тьма!",savage="Совсем и не страшно!",scientist="Негативные эмоции отступили!"},
	forgotit={none="А? Что?",peasant="Чегось?",criminal="Об чёи базар?",noble="Что вы сказали?",warrior="Па-автарить!",lightpriest="Моя память...",darkpriest="Моя память...",savage="Моя забыть...",scientist="Похоже, у меня амнезия..."},
	doyouknowhim={none="Знакомое имя?",peasant="Знакомы, не?",criminal="Как те такая погремуха?",noble="Имеете ли честь знать?",warrior="Были ли представлены?",lightpriest="Имя в миру.",darkpriest="Вот такое вот знакомство.",savage="Моя знать.",scientist="Вот такое вот знакомство."},
	
	wannadrink={none="Употребляете?",peasant="Это, за ворот, ага?",criminal="Бухать буишь?",noble="Не желаете ли употребить?",warrior="Накатим перед боем?",lightpriest="Причастись святости Света, чадо!",darkpriest="Как на счёт проспиртоваться?",savage="Твоя хотеть бухать?",scientist="Как вы относитесь к алкоголю?"},
	uknowwhattopresent={none="Это дело!",peasant="Это дело я люблю!",criminal="О, ща вмажу!",noble="Чтож, иногда и благородному нез азорно слегка расслабиться...",warrior="Самое оно перед боем-то!",lightpriest="Кровь сего мира! Нектар!",darkpriest="Самое время употребить...",savage="Моя любить огненный вода!",scientist="Настойка на основе спиритуса? Весьма к месту."},
	reallygoodone={none="Молодца!",peasant="Запой так запой!",criminal="О, гуляем!",noble="Свои в доску, сразу видно!",warrior="Это верная тактика!",lightpriest="Верно ведёшь себя, чадо.",darkpriest="Верное решение.",savage="Моя бухать! Твоя как?",scientist="Употребление алкоголя в умеренных дозах полезно в любом количестве!"},
	iwanttodrink={none="Д-давай сюда!",peasant="Ух, давай-давай!",criminal="Пл-лесни, хваталки др-рожат!",noble="Извините, употрбелю прямо сейчас: очень надо!",warrior="Боеприпасы подвезли! Ик!",lightpriest="Радость посетила моё сердце, чадо.",darkpriest="Давай сюда, мне материал заспиртовать надо!",savage="Моя бухать!",scientist="То, что нужно, то, что нужно... Строго для опытов!"},
	donotdrink={none="Не пью.",peasant="Непьюшшие мы.",criminal="Не, не употребляю.",noble="Не подвержен этому постыдному пороку.",warrior="Меньше выпьешь — дольше проживёшь!",lightpriest="Грешно твоё предложение, чадо.",darkpriest="Живые... ...собрание нелепых пороков.",savage="Моя не пить.",scientist="Вам стоит ознакомиться с научными трудами о вреде алкоголя."},
	bueh={none="Буэээ...",peasant="Ох-хо-хо, кишки мои, да потроха...",criminal="Ой, убери...",noble="Не вздумайте прелагать мне это!",warrior="В голове барабаны, в желудке — кавалерия!",lightpriest="Тяжко мне от вида твоего подношения, чадо.",darkpriest="Выглядит хуже, чем опыты иных моих коллег..",savage="Моя это не пить!",scientist="От вида вашего сомнительного подарка моё состояние заметно ухудщилось."},
	hatealcohol={none="Подите прочь!",peasant="Граблями зашибу!",criminal="Канай отседова!",noble="Можете выплеснуть это в окно!",warrior="Будь моя воля — дюжину нарядов вне очереди влепил бы!",lightpriest="Не вынуждай меня гневаться, чадо!",darkpriest="Меня злят твои жалкие подачки!",savage="Моя бить этим твой голова!",scientist="Мне не нужна эта гадость!"},
	cruelbastard={none="Как бывают некоторые злы...",peasant="Да нельзя мне...",criminal="Подловить хочешь?",noble="К сожалению, лекари запретили мне употребление... ..этого.",warrior="На посту нельзя!",lightpriest="Я отвратил от себя этот порок, чадо.",darkpriest="Былые радости мне недоступны.",savage="Моя не мочь...",scientist="С сожалением констатирую, что состояние моего здоровье вынуждает воздержаться От потребления."},
	andimalcholoic={none="Откуда узнали?",peasant="Есть грех...",criminal="Как прознали?",noble="Увы, и я подвержен этому пороку.",warrior="Давай, чего уж там... ...пока никто не видит.",lightpriest="Свет простит мне мою слабость...",darkpriest="Никому не говори. Услышу от кого — убью!",savage="Твоя не рассказывать!",scientist="Что ж тут поделаешь, такой теперь обмен веществ..."},
	
	};
	local what2say = questions[question][etiquette];
	return what2say;
end;

function chats.valuablePhrase(phrase,value)
	local phrases = {
	givegold = "Вот " .. value .. lognames.actions.withgold,
	};
	return phrases[phrase];
end;

function chats.rndanswer(chatq)
	local rnd = math.random(1,#chatq);
	return chatq[rnd];
end;

function chats.ifCondition(typ,subtyp,var,limit,comp,ifsuccess,ifnot)
	local roll = math.random(1,100);
	if typ == "skill" then
		local num = chars_mobs_npcs[current_mob]["num_" .. subtyp];
		local lvl = chars_mobs_npcs[current_mob]["lvl_" .. subtyp];
		local tot = num*lvl;
		local array = {num,lvl,tot};
		local tmp = array[var];
		if comp == 1 and tmp == limit then
			return ifsuccess;
		elseif  comp == 2 and tmp >= limit then
			return ifsuccess;
		elseif comp == 3 and tmp <= limit then
			return ifsuccess;
		elseif comp == 4 and tot >= roll then
			return ifsuccess;
		end;
	elseif typ == "stat" then
		local stat = chars_mobs_npcs[current_mob][subtyp];
		if comp == 1 and stat == limit then
			return ifsuccess;
		elseif comp == 2 and stat >= limit then
			return ifsuccess;
		elseif comp == 3 and stat <= limit then
			return ifsuccess;
		elseif comp == 4 and stat >= roll then
			return ifsuccess;
		end;
	elseif typ == "reputation" then
	elseif typ == "questgot" then
	elseif typ == "questdone" then
	elseif typ == "partygold" then
	elseif typ == "etiquette" then
	end;
	return ifnot;
end;
