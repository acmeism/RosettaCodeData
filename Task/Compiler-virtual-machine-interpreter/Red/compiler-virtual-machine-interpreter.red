Red [
	Title:	"Compiler/virtual machine interpreter"
	Author: "hinjolicious"
]

#include %lex2-bak.red
#include %parse.red
#include %gen3.red
#include %../../mylib/mylib.red
#include %../../mylib/profiler-greg.red

VM: func [code /local stk var-pool pc op x][
	stk: copy []
	var-pool: #[]

	error: func [msg][ print ["ERROR:" msg  halt] ]

	pc: 1
	forever [
		op: code/:pc
		pc: pc + 1
		switch/default op [
			FETCH [ insert stk var-pool/(code/:pc)		  pc: pc + 1 ]
			STORE [ var-pool/(code/:pc): stk/1  take stk  pc: pc + 1 ]
			PUSH  [ insert stk code/:pc					  pc: pc + 1 ]
			
			ADD   [ stk/2: stk/2 + stk/1			  take stk]
			SUB   [ stk/2: stk/2 - stk/1			  take stk]
			MUL   [ stk/2: stk/2 * stk/1			  take stk]
			DIV   [ stk/2: to integer! stk/2 / stk/1  take stk]
			MOD   [ stk/2: modulo stk/2 stk/1		  take stk]
			
			LT    [ stk/2: either stk/2 <  stk/1 [1][0]  take stk]
			GT    [ stk/2: either stk/2 >  stk/1 [1][0]  take stk]
			LE    [ stk/2: either stk/2 <= stk/1 [1][0]  take stk]
			GE    [ stk/2: either stk/2 >= stk/1 [1][0]  take stk]
			EQ    [ stk/2: either stk/2 =  stk/1 [1][0]  take stk]
			NE    [ stk/2: either stk/2 <> stk/1 [1][0]  take stk]
			
			AND   [ stk/2: stk/2 * stk/1  take stk] ; bit and
			OR    [ stk/2: stk/2 + stk/1  take stk] ; bit or
			NEG   [ stk/1: negate stk/1 ]
			NOT   [ stk/1: either stk/1 = 0 [1][0] ]
			
			JMP   [ pc: pc + code/:pc ]
			JZ    [ pc: either stk/1 = 0 [pc + code/:pc][pc + 1]  take stk ]
			
			PRTC  [ prin to char!    stk/1  take stk ]
			PRTI  [ prin to integer! stk/1  take stk ]
			PRTS  [ x: stk/1
				replace/all x "\\n" "`n`"  replace/all x "\n" "^/"
				prin replace/all x "`n`" "\n"  take stk ]
			HALT  [ exit ]
		][ error rejoin ["Unknown opcode: " op] ]
	]
] ; vm

test: does [
	while [(tx: ask "Code: ") <> ""] [
		case [
			tx = "r" [tx: read fn: request-file]
			all [tx = "s" fn <> "" tcode <> ""] [
				out-fn: replace fn ".t" ".tcode"
				write out-fn tcode
				print ["Saved to " out-fn]
				continue ] ]
		?? fn
		;?? tx
		lx: lex tx
		;?? lx
		ast: parse lx
		;?? ast
		gen ast
		;?? code
		tcode: list-code
		print tx
		print tcode
		timer: [vm code]
		profile/show [timer]
	]
]
test
