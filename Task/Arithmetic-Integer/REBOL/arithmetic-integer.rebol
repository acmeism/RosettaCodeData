REBOL [
	Title: "Integer"
	URL: http://rosettacode.org/wiki/Arithmetic/Integer
]

x: to-integer ask "Please type in an integer, and press [enter]: "
y: to-integer ask "Please enter another integer: "
print ""

print ["Sum:"  x + y]
print ["Difference:"  x - y]
print ["Product:" x * y]

print ["Integer quotient (coercion)                          :"  to-integer x / y]
print ["Integer quotient (away from zero)                    :"  round x / y]
print ["Integer quotient (halves round towards even digits)  :"  round/even x / y]
print ["Integer quotient (halves round towards zero)         :"  round/half-down x / y]
print ["Integer quotient (round in negative direction)       :"  round/floor x / y]
print ["Integer quotient (round in positive direction)       :"  round/ceiling x / y]
print ["Integer quotient (halves round in positive direction):"  round/half-ceiling x / y]

print ["Remainder:"  r: x // y]

; REBOL evaluates infix expressions from left to right. There are no
; precedence rules -- whatever is first gets evaluated. Therefore when
; performing this comparison, I put parens around the first term
; ("sign? a") of the expression so that the value of /a/ isn't
; compared to the sign of /b/. To make up for it, notice that I don't
; have to use a specific return keyword. The final value in the
; function is returned automatically.

match?: func [a b][(sign? a) = sign? b]

result: copy []
if match? r x [append result "first"]
if match? r y [append result "second"]

; You can evaluate arbitrary expressions in the middle of a print, so
; I use a "switch" to provide a more readable result based on the
; length of the /results/ list.

print [
	"Remainder sign matches:"
	switch length? result [
		0 ["neither"]
		1 [result/1]
		2 ["both"]
	]
]

print ["Exponentiation:" x ** y]
