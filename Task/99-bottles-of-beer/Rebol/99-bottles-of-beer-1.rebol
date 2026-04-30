rebol [
    Title: "99 Bottles of Beer"
    URL: http://rosettacode.org/wiki/99_Bottles_of_Beer
]

; The 'bottles' function maintains correct grammar.

bottles: func [n /local b][
	b: either 1 = n ["bottle"]["bottles"]
	if 0 = n [n: "no"]
	reform [n b]
]

for n 99 1 -1 [print [
	bottles n  "of beer on the wall" crlf
	bottles n  "of beer" crlf
	"Take one down, pass it around" crlf
	bottles n - 1  "of beer on the wall" crlf
]]
