Red [
	Title:	"Compiler/code generator"
	Author:	"hinjolicious"
	Purpose: "list-based code generator that is more suitable Red's native block data structure"
]

#include %lex2-bak.red
#include %parse.red

ast: copy []

ops: #[MUL: MUL  DIV: DIV  MOD: MOD  ADD: ADD  SUB: SUB  NEG: NEG  NOT: NOT
	LT: LT  GT: GT  LEQ: LE  GEQ: GE  EQ: EQ  NEQ: NE  AND: AND  OR: OR]
unary: [NEG: NEG  NOT: NOT]

code: copy []
str-pool: #[]
var-pool: #[]
str-n: var-n: 0
wsize: 1 ; we're using an integer based code

error: func [msg][ print ["ERROR:" msg  halt] ]
	
emit:	 func [x][ append code x ]
emit-at: func [a n][ change at code a n ]
hole:	 func [/local t][ t: length? code  emit 0  t ]
	
var-offset: func [name /local n][
	n: var-pool/:name
	if n == none [
		var-pool/:name: var-n
		n: var-n
		var-n: var-n + 1 ]
	n ]
	
str-offset: func [str /local n][
	n: str-pool/:str
	if n = none [
		str-pool/:str: str-n
		n: str-n
		str-n: str-n + 1 ]
	n ]	

_gen: func [a /local n p1 p2 ][
	case [
		none = a	[exit]
		'ID  = a/1  [ emit 'FETCH  emit a/2 ] ;var-offset a/2 ]
		'INT = a/1  [ emit 'PUSH   emit a/2 ]
		'STR = a/1  [ emit 'PUSH   emit a/2 ] ;str-offset a/2 ]
		;'ASGN = a/1 [ n: var-offset a/2/2  _gen a/3  emit 'STORE  emit n ]
		'ASGN = a/1 [ n: a/2/2  _gen a/3  emit 'STORE  emit n ]
		'IF = a/1 [
			_gen a/2 ; if cond
			emit 'JZ ; if false, jump to to else
			p1: hole ; reserve for else address
			_gen a/3/2 ; then body
			if a/3/3 <> none [
				emit 'JMP ; skip the else body
				p2: hole ] ; reserve the location
			emit-at (p1 + 1) ((length? code) - p1) ; fix for jz
			if a/3/3 <> none [
				_gen a/3/3 ; else body
				emit-at (p2 + 1) ((length? code) - p2) ] ] ; fix for jmp
		'WHILE = a/1 [
			p1: length? code ; before while
			_gen a/2 ; while cond
			emit 'JZ ; if false, jump to after while
			p2: hole ; reserve after while address
			_gen a/3 ; while body
			emit 'JMP ; jump-back to before while
			emit (p1 - (length? code))
			emit-at (p2 + 1) ((length? code) - p2) ] ; fix jz to this location
		'SEQ  = a/1  [ _gen a/2  _gen a/3 ]
		'PRTC = a/1  [ _gen a/2  emit 'PRTC ]
		'PRTI = a/1  [ _gen a/2  emit 'PRTI ]
		'PRTS = a/1  [ _gen a/2  emit 'PRTS ]
		ops/(:a/1)   [ _gen a/2  _gen a/3  emit ops/(:a/1) ]
		unary/(:a/1) [ _gen a/2			   emit unary/(:a/1) ]
		true [ error rejoin ["Expecting operator, found '" a/1 "'"] ]
	]
] ; _gen

gen: func [ast][
	;clear code  clear str-pool  clear var-pool  str-n: var-n: 0
	code: copy []
	str-pool: #[]
	var-pool: #[]
	str-n: var-n: 0
	
	_gen ast  emit 'HALT
	code ]

list-code: func[/local out s op c][
	out: copy ""

	pad-pc: func [x][pad/left x 5]
	pad-op: func [x][pad x 6]
	
	append out rejoin ["Datasize: " length? var-pool " Strings: " length? str-pool "^/"]
	foreach [a b] sort/skip (to-block str-pool) 2 [
		append out rejoin [mold a "^/"] ]
	
	pc: 0
	while [pc < length? code][
		s: pad-pc pc
		op: code/(:pc + 1) ; 1-based block
		pc: pc + 1
		switch/default to-lit-word op [
			'FETCH [ x: code/(pc + 1)  c: rejoin [pad-op op x] pc: pc + 1 ]
			'STORE [ x: code/(pc + 1)  c: rejoin [pad-op op x] pc: pc + 1 ]
			'PUSH  [ x: code/(pc + 1)  c: rejoin [pad-op op x] pc: pc + 1 ]
			'ADD   [ c: "ADD" ]
			'SUB   [ c: "SUB" ]
			'MUL   [ c: "MUL" ]
			'DIV   [ c: "DIV" ]
			'MOD   [ c: "MOD" ]
			'LT    [ c: "LT"  ]
			'GT    [ c: "GT"  ]
			'LE    [ c: "LE"  ]
			'GE    [ c: "GE"  ]
			'EQ    [ c: "EQ"  ]
			'NE    [ c: "NE"  ]
			'AND   [ c: "AND" ]
			'OR    [ c: "OR"  ]
			'NEG   [ c: "NEG" ]
			'NOT   [ c: "NOT" ]
			'JMP   [ x: code/(pc + 1)  c: rejoin [pad-op op "(" x ") " pc + x] pc: pc + 1 ]
			'JZ    [ x: code/(pc + 1)  c: rejoin [pad-op op "(" x ") " pc + x] pc: pc + 1 ]
			'PRTC  [ c: "PRTC" ]
			'PRTI  [ c: "PRTI" ]
			'PRTS  [ c: "PRTS" ]
			'HALT  [ c: "HALT" ]
		][ error rejoin ["list-code: Unknown opcode " op] ]
		append out rejoin [s " " c "^/"]
	]
	out
] ; list-code

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
		?? tx
		lx: lex tx
		?? lx
		ast: parse lx
		?? ast
		gen ast
		?? code
		tcode: list-code
		print tcode
	]
]
test
