function npc_load ()
	npc = {};
	npc.names = {
	rattusparchedtail="Раттус Палохвост",
	dortussmarttooth="Дортус Хитрозуб",
	};
	
	npc.ttx={
		nilslarsen={
			uid=101,defaultai="cruiser",ai="cruiser",dangerai="away",waypoint={{16,11},{13,11},{8,11},{8,5},{13,4},{17,6}},nextpoint=2,
			class="goblin",fraction="vagrants", party=2, name="Nils Larsen", chat=2, face = 8, 
			personality={
				current={chat=2,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="coward"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown=3,known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblins"},{"elfs"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
				default={chat=2,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="coward"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown=3,known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblins"},{"elfs"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
				alternative={chat=2,etiquette = "criminal",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="disdain",gold="middleclass",drinks="boozer",threat="coward"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblins"},{"elfs"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
				thiefcatcher={chat=8,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="boozer",threat="coward"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblins"},{"elfs"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
			},
		},
		
		ivansusanin={
			uid=100,defaultai="stay",ai="stay",dangerai="away",
			class="goblin",fraction="vagrants",  party=2, name="Ivan Susanin", face = 8,
			personality={
				current={chat=2,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="coward"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown=3,known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblins"},{"elfs"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
				default={chat=2,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="boozer",threat="coward"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown=3,known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblins"},{"elfs"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
				alternative={chat=2,etiquette = "criminal",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="disdain",gold="middleclass",drinks="boozer",threat="coward"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblins"},{"elfs"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
				thiefcatcher={chat=8,etiquette = "none",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="boozer",threat="coward"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","massacre","rasist","sex","stupidness"},{},{"goblins"},{"elfs"}}},secrets={chantage={{id=1,emo=2,pow=1}},rumours={{id=2,emo=1,pow=1},{id=3,emo=1,pow=1}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={}},connections={{npc=2,emo=8,power=1}},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
			},
		},
		
		rattusparchedtail = {
			uid=2,person="npc",control="ai",defaultai="stay",ai="stay",dangerai="agr",x=20,y=10,rot=2,class="ratman",fraction="contrabandists", party=2, name=npc.names.rattusparchedtail, face = 8,
			personality={
				default={chat="rattusparchedtail",etiquette = "criminal",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="poisoner",food="full",threat="brave"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","rasist","sex","stupidness"},{},{"ratman"},{"goblin","gnoll","guard"}}},secrets={chantage={{}},rumours={{},{}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={1,3,4,5,6,7,8,9,10,11}},connections={{npc=2,emo=8,power=1}},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil},
				guards_x=20,guards_y=10,
				guards={{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=38,y=52,rot=5,class="ratman",fraction="contrabandists",party=4},{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=38,y=52,rot=5,class="ratman",fraction="contrabandists",party=4},{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=38,y=52,rot=5,class="ratman",fraction="contrabandists",party=4}},
				},
				current={chat="rattusparchedtail",etiquette = "criminal",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="poisoner",food="full",threat="brave"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","rasist","sex","stupidness"},{},{"ratman"},{"goblin","gnoll","guard"}}},secrets={chantage={{}},rumours={{},{}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={1,3,4,5,6,7,8,9,10,11}},connections={{npc=2,emo=8,power=1}},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil},
				guards_x=20,guards_y=10,
				guards={{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=38,y=52,rot=5,class="ratman",fraction="contrabandists",party=4},{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=38,y=52,rot=5,class="ratman",fraction="contrabandists",party=4},{uid=0,person="mob",control="ai",defaultai="agr",ai="agr",dangerai="agr", x=38,y=52,rot=5,class="ratman",fraction="contrabandists",party=4}},
				},
				thiefcatcher={chat="catchedthief",etiquette = "criminal",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="poisoner",food="full",threat="brave"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","rasist","sex","stupidness"},{},{"ratman"},{"goblin","gnoll","guard"}}},secrets={chantage={{}},rumours={{},{}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={1,3,4,5,6,7,8,9,10,11}},connections={{npc=3,emo=8,power=1}},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}}
				},
		},
		
		dortussmarttooth = {
			uid=3,person="npc",control="ai",defaultai="stay",ai="stay",dangerai="stay",x=25,y=7,rot=3,class="ratman",fraction="contrabandists", party=3, name=npc.names.dortussmarttooth, face = 8,
			personality={
				default={chat="dortussmarttooth",etiquette = "criminal",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="poisoner",food="starving",threat="coward"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","rasist","sex","stupidness"},{},{"ratman"},{"goblin","gnoll","guard"}}},secrets={chantage={{}},rumours={{},{}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={1,3,4,5,6,7,8,9,10,11}},connections={{npc=2,emo=8,power=1}},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
				current={chat="dortussmarttooth",etiquette = "criminal",mindmap=1,mindstatus={0,0,0,0,0,0,0,0,0,0,0,0},mindflags={default="boring",gold="middleclass",drinks="poisoner",food="starving",threat="coward"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","rasist","sex","stupidness"},{},{"ratman"},{"goblin","gnoll","guard"}}},secrets={chantage={{}},rumours={{},{}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={1,3,4,5,6,7,8,9,10,11}},connections={{npc=2,emo=8,power=1}},mindgameresults={1,3,nil,nil,2,nil,nil,nil,nil,nil,nil,nil}},
				thiefcatcher={chat="catchedthief",etiquette = "criminal",mindmap=1,mindstatus={0,0,0,0,5,0,0,0,0,0,0,0},mindflags={default="agression",gold="middleclass",drinks="poisoner",food="full",threat="brave"},music={main="none",bestsongs={},hatedsongs={},bestinstruments={},hatedinstruments={}},humor={multi=1,ifsuccess=10,ifnot=4,ifknown={3},known_jokes={},code={{"revenge","trick","rasist","sex","stupidness"},{},{"ratman"},{"goblin","gnoll","guard"}}},secrets={chantage={{}},rumours={{},{}},known_secrets={}},known_nlps={},affronts={emo=5,modifer=1,additional_tags={},known_affronts={1,3,4,5,6,7,8,9,10,11}},connections={{npc=3,emo=8,power=1}},mindgameresults={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}},
			},
		},
	
	};	

end;
