Red [Purpose: "Implement a rock-paper-scissors game with weighted probability"]

prior: rejoin choices: ["r" "p" "s"]

while [
	find choices pchoice: ask "choose rock: r, paper: p, or scissors: s^/"
] [	
	print ["AI Draws:" cchoice: random/only prior]
	cwin: select "rpsr" pchoice
	close: select "rspr" pchoice
	
	print case [
		pchoice = cchoice ["tie"]
		cchoice = cwin ["you lose"]
		'else ["you win"]
	]
	
	append prior cwin		;adds what would have beaten player
	remove find prior close		;removes what would have lost to player
]
