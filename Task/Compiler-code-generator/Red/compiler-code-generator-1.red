Red [
    Title:  "Compiler/code generator"
	Author: "hinjolicious"
]

#include %lex2.red
#include %parse.red

ast: copy []

ops: #[MUL: MUL  DIV: DIV  MOD: MOD  ADD: ADD  SUB: SUB  NEG: NEG  NOT: NOT
	LT: LT  GT: GT  LEQ: LE  GEQ: GE  EQ: EQ  NEQ: NE  AND: AND  OR: OR]
unary: [NEG: NEG  NOT: NOT]

code: copy []
str-pool: #[]
var-pool: #[]
str-n: var-n: 0
wsize: 4

error: func [msg][ print ["ERROR:" msg  halt] ]
slice: func [blk st n][ copy/part at blk st n ]
i2b: func [v][ to-binary v ]
b2i: func [v][ to-integer v ]

i2blk: func [i /local b blk x][
	b: to-binary i
	blk: copy []
	foreach x b [append blk x]
	blk ]
	
blk2i: func [blk /local b x][
    b: make binary! wsize
    foreach x blk [append b x]
    to-integer b ]	
	
emit-byte:    func [x][ append code x ]
emit-word:	  func [x][ append code i2blk x ]
emit-word-at: func [a n][ change/part (at code a) (i2blk n) wsize ]

hole: func [/local t][
	t: length? code
	emit-word 0
	t ]
	
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
		'ID  = a/1  [ emit-byte 'FETCH  emit-word var-offset a/2 ]
		'INT = a/1  [ emit-byte 'PUSH   emit-word a/2 ]
		'STR = a/1  [ emit-byte 'PUSH   emit-word str-offset a/2 ]
		'ASGN = a/1 [ n: var-offset a/2/2  _gen a/3  emit-byte 'STORE  emit-word n ]
		'IF = a/1 [
			_gen a/2 ; if cond
			emit-byte 'JZ ; if false, jump to to else
			p1: hole ; reserve for else address
			_gen a/3/2 ; then body
			if a/3/3 <> none [
				emit-byte 'JMP ; skip the else body
				p2: hole ] ; reserve the location
			emit-word-at (p1 + 1) ((length? code) - p1) ; fix for jz
			if a/3/3 <> none [
				_gen a/3/3 ; else body
				emit-word-at (p2 + 1) ((length? code) - p2) ] ] ; fix for jmp
		'WHILE = a/1 [
			p1: length? code ; before while
			_gen a/2 ; while cond
			emit-byte 'JZ ; if false, jump to after while
			p2: hole ; reserve after while address
			_gen a/3 ; while body
			emit-byte 'JMP ; jump-back to before while
			emit-word (p1 - (length? code))
			emit-word-at (p2 + 1) ((length? code) - p2) ] ; fix jz to this location
		'SEQ  = a/1  [ _gen a/2  _gen a/3 ]
		'PRTC = a/1  [ _gen a/2  emit-byte 'PRTC ]
		'PRTI = a/1  [ _gen a/2  emit-byte 'PRTI ]
		'PRTS = a/1  [ _gen a/2  emit-byte 'PRTS ]
		ops/(:a/1)   [ _gen a/2  _gen a/3  emit-byte ops/(:a/1) ]
		unary/(:a/1) [ _gen a/2			   emit-byte unary/(:a/1) ]
		true [ error rejoin ["Expecting operator, found '" a/1 "'"] ]
	]
] ; _gen

gen: func [ast][
	clear code  clear str-pool  clear var-pool  str-n: var-n: 0
	_gen ast  emit-byte 'HALT
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
			'FETCH [ x: blk2i slice code (pc + 1) wsize  c: rejoin [pad-op op "[" x "]"]  pc: pc + wsize ]
			'STORE [ x: blk2i slice code (pc + 1) wsize  c: rejoin [pad-op op "[" x "]"]  pc: pc + wsize ]
			'PUSH  [ x: blk2i slice code (pc + 1) wsize  c: rejoin [pad-op op x]		  pc: pc + wsize ]
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
			'JMP   [ x: blk2i slice code (pc + 1) wsize  c: rejoin [pad-op op "(" x ") " pc + x]  pc: pc + wsize ]
			'JZ    [ x: blk2i slice code (pc + 1) wsize  c: rejoin [pad-op op "(" x ") " pc + x]  pc: pc + wsize ]
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
