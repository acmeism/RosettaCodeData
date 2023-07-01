Red ["Ternary logic"]

		; define trits as a set of 3 Red words: 'oui, 'non and 'bof
		; ('bof is a French teenager word expressing indifference)
trits: [oui bof non]

		; set the value of each word to itself
		; so the expression " oui " will evaluate to word 'oui
foreach t trits [set t to-lit-word t]

		; utility function to test if a word is a trit
trit?: function [t] [not none? find trits t]

		; ------ prefix operators ------
		; unary operator
tnot: !: function [a][
	select [oui non oui bof bof] a
]
		; binary (prefix) operators
tand: function [a b][
	either all [a = oui b = oui][oui][
		either any [a = non b = non][non][bof]
]]
tor: function [a b][
	either any [a = oui b = oui][oui][
		either all [a = non b = non][non][bof]
]]
timp: function [a b][
	either a = oui [b][
		either a = non [oui][
			either b = oui [oui][bof]
]]]
teq: function [a b][
	either any [a = bof b = bof][bof][
		either a = b [oui][non]
]]
		; ------ infix operators ------
&:   make op! :tand
|:   make op! :tor
=>:  make op! :timp
<=>: make op! :teq

		; some examples
probe init: [
a: oui
b: bof
c: non]
do init
foreach s [[! (! a)] [a & b] [a | (b & (oui | non))]
		[! ((a | b) | b & c)] [(a & b) | c]][
	print rejoin [pad mold s 25 " " do s]
]
