Red [
	Title:	"Compiler/AST interpreter"
	Author: "hinjolicious"
]

#include %lex2-bak.red
#include %parse.red
#include %../../mylib/mylib.red
#include %../../mylib/profiler-greg.red

INTERP: func [a /local var-pool x][
	var-pool: #[]
	error: func [msg][ print ["ERROR:" msg] halt ]

	EVAL: func [a /local x][
		if none? a [ return none ]
		switch/default a/1 [
		SEQ   [ eval a/2  eval a/3 ]
		INT   [ to integer! a/2 ]
		ID    [ var-pool/(:a/2) ]
		STR   [ a/2 ]
		ASGN  [ var-pool/(:a/2/2): eval a/3 ]
		ADD   [ (eval a/2) + (eval a/3) ]
		SUB   [ (eval a/2) - (eval a/3) ]
		MUL   [ (eval a/2) * (eval a/3) ]
		DIV   [ to integer! (eval a/2) / (eval a/3) ]
		MOD   [ to integer! modulo (eval a/2) (eval a/3) ]
		LT    [ either (eval a/2) <  (eval a/3) [1][0] ]
		GT    [ either (eval a/2) >  (eval a/3) [1][0] ]
		LEQ   [ either (eval a/2) <= (eval a/3) [1][0] ]
		GEQ   [ either (eval a/2) >= (eval a/3) [1][0] ]
		EQ    [ either (eval a/2) =  (eval a/3) [1][0] ]
		NEQ   [ either (eval a/2) <> (eval a/3) [1][0] ]
		AND   [ (eval a/2) * (eval a/3) ]
		OR    [ either any [(eval a/2) <> 0  (eval a/3) <> 0] [1][0] ]
		NEG   [ negate eval a/2 ]
		NOT   [ either (eval a/2) =  0 [1][0] ]
		IF    [ either (eval a/2) <> 0 [eval a/3/2][eval a/3/3] ]
		WHILE [ while [(eval a/2) <> 0][eval a/3] ]
		PRTC  [ prin to char!    eval a/2 ]
		PRTI  [ prin to integer! eval a/2 ]
		PRTS  [ x: eval a/2
			replace/all x "\\n" "`n`"  replace/all x "\n" "^/"
			prin replace/all x "`n`" "\n" ]
		][ error rejoin ["Expecting operator, found '" a/1 "'"] ]
	]
	eval a	
]

test: does [
	while [(tx: ask "Code: ") <> ""] [
		case [
			tx = "r" [tx: read fn: request-file]
			all [tx = "s" fn <> "" ast <> []] [
				out-fn: replace fn ".t" ".ast"
				write out-fn ast
				print ["Saved to " out-fn]
				continue ] ]
		?? fn
		;?? tx
		;print tx
		lx: lex tx
		;?? lx
		ast: parse lx
		?? ast
		timer: [interp ast]
		profile/show [timer]
	]
]
test
