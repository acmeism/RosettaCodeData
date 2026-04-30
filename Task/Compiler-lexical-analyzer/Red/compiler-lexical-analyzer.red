Red [
	Title:  "Compiler/lexical analyzer"
	Author: "hinjolicious"
]

LEXER: context [

is-space:	 function [c][find "^/^- " c]
is-varchars: function [c][find "abcdefghijklmnopqrstuvwxyz0123456789_" lowercase c]
is-digit: 	 function [c][find "0123456789" c]

source: object [
	txt: copy ""  len: 0  row: 1  col: ix: 0  ch: ""
	
	open: func [fil][
		txt: read fil  len: length? txt  row: 1  col: ix: 0  ch: ""
		source
	]
	read-text: func [tx][
		txt: copy tx  len: length? txt  row: 1  col: ix: 0  ch: ""
		source
	]	
	getc: does [
		ix: ix + 1  col: col + 1
		either ix <= len [
			ch: to-string txt/:ix
			if ch = "^/" [row: row + 1  col: 0]
		][ch: ""]
		ch
	]
] ; /source

lex: object [
	list: copy []
	
	analyze: does [
		source/getc
		until [token/get-tok  token/id = 'EOI]
		list
	]
	
	show: does [
		foreach t list [
			r: t/1  c: t/2  id: t/3  val: either string? t/4 [copy t/4][t/4]
			prin [pad r 3  pad c 3  pad id 10
				pad either id = 'STR [mold val][val] 20 "^/"]
		]
	]
	
	save-to-file: func [fil][
		out: copy ""
		foreach t list [
			append out
				rejoin [pad t/1 5 pad t/2 5 pad t/3 20
					pad case [t/3 = 'STR [mold t/4] true [t/4]] 20 "^/"]
		]
		out-fil: replace fil ".t" ".out"
		write out-fil out
		print ["Saved to " out-fil]
	]	
	save-lex: func [fil][
		out-fil: replace fil ".t" ".lex"
		write out-fil list
		print ["Saved to " out-fil]
	]	
]

token: object [
	id: val: none  row: col: 0
	id-type: #[
		"if"	'IF
		"else"	'ELSE
		"while"	'WHILE
		"print"	'PRINT
		"putc"	'PUTC
	]
	
	ident-type: func [txt][
		typ: id-type/:txt
		either typ [new typ ""][new 'ID txt]
	]
	
	new: func [t v] [
		id: t  val: v
		append/only lex/list compose [(row) (col) (t) (v)]
		token
	]
	
	get-tok: does [
		while [is-space source/ch][source/getc]
		row: source/row  col: source/col
		switch/default source/ch [
			"*" [source/getc new 'MUL ""]
			"%" [source/getc new 'MOD ""]
			"+" [source/getc new 'ADD ""]
			"-" [source/getc new 'SUB ""]
			"<" [source/getc follow "=" 'LEQ 'LT]
			">" [source/getc follow "=" 'GEQ 'GT]
			"=" [source/getc follow "=" 'EQ  'ASGN]
			"!" [source/getc follow "=" 'NEQ 'NOT]
			"&" [source/getc follow "&" 'AND 'EOI]
			"|" [source/getc follow "|" 'OR  'EOI]
			"(" [source/getc new 'LP ""]
			")" [source/getc new 'RP ""]		
			"{" [source/getc new 'LB ""]
			"}" [source/getc new 'RB ""]
			";" [source/getc new 'SEMI ""]
			"," [source/getc new 'COMMA ""]
			"/" [source/getc div-comment]
			"'" [source/getc char-lit]
			{"} [string-lit]
			"" [new 'EOI ""]
		][ident-int]		
	]
	
	div-comment: does [
		if source/ch <> "*" [return new 'DIV ""]
		source/getc
		forever [
			switch/default source/ch [
				"*" [
					if source/getc = "/" [
						source/getc
						return get-tok
					]
				]
				"" [error "EOF in comment"]
			][source/getc]
		]
		new 'COMMENT ""
	]	
	
	error: func [msg][
		print [row col msg source/ch]
		halt
	]
	
	ident-int: does [
		is-number: true
		text: copy ""
		while [is-varchars source/ch][
			append text source/ch
			unless is-digit source/ch [is-number: false]
			source/getc
		]
		if (length? text) = 0 [
			error "token/get-tok: unrecognized character"
		]
		if is-digit text/1 [
			unless is-number [
				error "invalid number:" text
			]
			n: to-integer text
			if n > 2147483647 [error "number exceeds maximum value"]
			if n < -2147483648 [error "number exceeds minimum value"]
			return new 'INT n
		]
		ident-type text
	]
	
	char-lit: does [
		case [
			source/ch = "'" [error "token/get-tok: empty character constant"]
			source/ch = "\" [
				switch/default source/getc [
					"n" [n: 10]
					"\" [n: to-integer #"\"]
				][error "token/get-tok: uknown escape sequence"]
			]
			source/ch = " " [n: 32]
			true [ n: to-integer to-char source/ch ]
		]	
		if source/getc <> "'" [error "multi-character constant"]
		source/getc
		new 'INT n
	]
	
	string-lit: does [
		text: copy ""
		while [source/getc <> {"}][
			if source/ch = "\n" [error "EOL in string" ""]
			if source/ch = "" [error "EOF in string" ""]
			append text source/ch
		]
		source/getc
		new 'STR text
	]
	
	follow: func [ex tok-yes tok-no][
		if source/ch = ex [
			source/getc
			return new tok-yes ""
		]
		if tok-no = 'EOI [error "follow: unrecognized character"]
		new tok-no ""
	]
] ; /token

_lex: func [tx][
	clear lex/list
	source/read-text tx
	lex/analyze
]
] ; /LEXER context

lex: :lexer/_lex
prt-lex: :lexer/lex/show

test: func [][
	inp: copy ""  fil: copy ""  lx: copy []
	forever [
		print ["Code:" inp]
		print ["File:" fil]
		print ["Lex:" lx]
		print "Type code or 'r' to read from file, 's' to save, 'q' to quit."
		inp: ask "Code: "
		if inp = "q" [quit]
		if inp = "r" [
			fil: request-file
			print "Source:" fil
			inp: read fil
		]
		if inp = "s" [
			if lx = [] [print "Lex is empty!"  continue]
			fil: request-file
			write fil lx
			continue
		]	
		lx: lex inp
		prt-lex lx
	]
]
;test
