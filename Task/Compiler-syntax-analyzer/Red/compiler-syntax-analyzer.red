Red [
	Title:  "Compiler/syntax analyzer"
	Author: "hinjolicious"
]

#include %lex2-bak.red

parser: context [
	lex: copy []
	ast: copy []
	row: col: 0
	tok: none
	val: none
	atr: #[
		EOI		#[txt "EOI"			ra? no bin? no  un? no  prec -1 type -1	  ]
		MUL		#[txt "*"			ra? no bin? yes un? no  prec 13 type MUL  ]
		DIV		#[txt "/"			ra? no bin? yes un? no  prec 13 type DIV  ]
		MOD		#[txt "%"			ra? no bin? yes un? no  prec 13 type MOD  ]
		ADD		#[txt "+"			ra? no bin? yes un? no  prec 12 type ADD  ]
		SUB		#[txt "-"			ra? no bin? yes un? no  prec 12 type SUB  ]
		NEG		#[txt "-"			ra? no bin? no  un? yes prec 14 type NEG  ]
		NOT		#[txt "!"			ra? no bin? no  un? yes prec 14 type NOT  ]
		LT		#[txt "<"			ra? no bin? yes un? no  prec 10 type LT	  ]
		LEQ		#[txt "<="			ra? no bin? yes un? no  prec 10 type LEQ  ]
		GT		#[txt ">"			ra? no bin? yes un? no  prec 10 type GT	  ]
		GEQ 	#[txt ">="			ra? no bin? yes un? no  prec 10 type GEQ  ]
		EQ		#[txt "=="			ra? no bin? yes un? no  prec  9 type EQ	  ]
		NEQ		#[txt "!="			ra? no bin? yes un? no  prec  9 type NEQ  ]
		ASGN	#[txt "="			ra? no bin? no  un? no  prec -1 type ASGN ]
		AND		#[txt "&&"			ra? no bin? yes un? no  prec  5 type AND  ]
		OR		#[txt "||"			ra? no bin? yes un? no  prec  4 type OR	  ]
		IF		#[txt "if"			ra? no bin? no  un? no  prec -1 type IF	  ]
		ELSE	#[txt "else"		ra? no bin? no  un? no  prec -1 type -1	  ]
		WHILE	#[txt "while"		ra? no bin? no  un? no  prec -1 type WHILE]
		PRINT	#[txt "print"		ra? no bin? no  un? no  prec -1 type -1	  ]
		PUTC	#[txt "putc"		ra? no bin? no  un? no  prec -1 type -1	  ]
		LP		#[txt "("			ra? no bin? no  un? no  prec -1 type -1	  ]
		RP		#[txt ")"			ra? no bin? no  un? no  prec -1 type -1	  ]
		LB		#[txt "{"			ra? no bin? no  un? no  prec -1 type -1	  ]
		RB		#[txt "}"			ra? no bin? no  un? no  prec -1 type -1	  ]
		SEMI	#[txt ";"			ra? no bin? no  un? no  prec -1 type -1	  ]
		COMMA	#[txt ","			ra? no bin? no  un? no  prec -1 type -1	  ]
		ID		#[txt "identifier"	ra? no bin? no  un? no  prec -1 type ID	  ]
		INT		#[txt "integer"		ra? no bin? no  un? no  prec -1 type INT  ]
		STR		#[txt "string"		ra? no bin? no  un? no  prec -1 type STR  ]
	]

error: func [msg][
	print rejoin ["(" row ", " col ") ERROR: " msg]
	halt
]

gettok:    func [][tok: first lex  lex: next lex]
make-node: func [t l r][compose/only [(t) (l) (r)]]	
make-leaf: func [t v][compose [(t) (v)]]

expect: func [msg s][
	row: tok/1  col: tok/2
	if tok/3 <> s [
		error rejoin [msg " expecting '" atr/:s/txt "', found '" atr/(:tok/3)/txt "'"]
	]
	gettok
]

expr: func [p /local x][
	x: none
	switch to-lit-word tok/3 [
		'LP  [ x: paren-expr ]
		'ADD [ gettok  x: expr atr/ADD/prec ]
		'SUB [ gettok  x: make-node 'NEG expr atr/NEG/prec none ]
		'NOT [ gettok  x: make-node 'NOT expr atr/NOT/prec none ]
		'ID  [ x: make-leaf 'ID  tok/4  gettok ]
		'INT [ x: make-leaf 'INT tok/4  gettok ]
		;'STR [ x: make-leaf 'STR tok/4  gettok ]
	][ error rejoin ["Expecting a primary, found '" atr/(:tok/3)/txt "'"] ]
	
	while [all [atr/(:tok/3)/bin?  atr/(:tok/3)/prec >= p]][
		op: tok/3
		gettok
		q: atr/:op/prec
		;if not atr/:op/ra? [q: q + 1]
		if atr/:op/ra? [q: q + 1] ; fix!
		x: make-node atr/:op/type x (expr q)
	]
	x
]

paren-expr: func [/local t][
	expect 'PAREN-EXPR 'LP
	t: expr 0
	expect 'PAREN-EXPR 'RP
	t
]

stmt: func [/local t e s s2 v][
	t: none  row: tok/1  col: tok/2
	
	switch/default to-lit-word tok/3 [
		'IF [
			gettok
			e: paren-expr  s: stmt  s2: none
			if tok/3 = 'ELSE [gettok  s2: stmt]
			t: make-node 'IF e (make-node 'IF s s2)
		]
		'PUTC [
			gettok
			t: make-node 'PRTC paren-expr none
			expect 'PUTC 'SEMI
		]
		'PRINT [
			gettok
			expect 'PRINT 'LP
			forever [
				either tok/3 = 'STR [
					e: make-node 'PRTS (make-leaf 'STR tok/4) none
					gettok
				][
					e: make-node 'PRTI (expr 0) none
				]
				t: make-node 'SEQ t e
				if tok/3 <> 'COMMA [break]
				gettok
			]
			expect 'PRINT 'RP
			expect 'PRINT 'SEMI
		]
		'SEMI [gettok]
		'ID	[	
			v: make-leaf 'ID tok/4
			gettok
			expect 'ASSIGN 'ASGN
			t: make-node 'ASGN v (expr 0)
			expect 'ASSIGN 'SEMI
		]
		'WHILE [
			gettok
			t: make-node 'WHILE paren-expr stmt
		]
		'LB [
			expect 'LB 'LB
			while [all [tok/3 <> 'RB  tok/3 <> 'EOI]][
				t: make-node 'SEQ t stmt
			]
			expect 'LB 'RB
		]
		'EOI [return t]
	][ error rejoin ["expecting start of statement, found '" atr/(:tok/3)/txt "'"] ]
	t
]

parse: func [lx /local t][
	lex: lx  t: none  gettok
	until [
		t: make-node 'SEQ t stmt
		any [t = none  tok/3 = 'EOI]
	]
	ast: t
]

prt-ast: func [t][
	either t = none[
		print [";"]
	][
		prin [t/1]
		either any [t/1 = 'ID  t/1 = 'INT  t/1 = 'STR][
			print ["^- " either t/1 = 'STR [mold t/2][t/2]]
		][
			print ""
			prt-ast t/2
			prt-ast t/3
		]
	]	
]

flatten-ast: func [t][
	either t = none[
		append flt ";^/"
	][
		append flt form t/1
		either any [t/1 = 'ID  t/1 = 'INT  t/1 = 'STR][
			append flt rejoin ["^- " form either t/1 = 'STR [mold t/2][t/2] "^/"]
		][
			append flt "^/"
			flatten-ast t/2
			flatten-ast t/3
		]
	]
	flt
]

save-ast: func [ast fil /flat][
	flt: copy ""
	out-fil: replace fil ".lex" ".ast"
	write out-fil either flat [flatten-ast ast][ast]
	print ["Saved to" out-fil]
]
] ; parser context

parse:	  :parser/parse
save-ast: :parser/save-ast

test: does [
	while [(tx: ask "Code: ") <> ""] [
		if tx = "r" [tx: read request-file]
		?? tx
		lx: lex tx
		?? lx
		ast: parse lx
		?? ast
		parser/prt-ast ast
		;gen ast
		;list-code
	]
]
test
