Red [ "First-Class Functions - Hinjolicious" ]

; sine and cosine are natives
cube: function [x][x * x * x]
cube-root: function [x][power x (1 / 3)]

A: [sin cos cube]
B: [asin acos cube-root]

; to show the codes
demo: function [s b] [print ["^/==" s "==^/"] print mold/only b do b]

comp-func: function ['f 'g] [function [x] compose [(get f) (get g) x]]

demo "Composing functions from List A and B and calling it" [
repeat i 3 [
	f: comp-func A/:i B/:i
	print f 0.5
]
]
