Red [
	title: "Real Currying in Red"
	author: "hinjolicious"
	note: {
		June 18, 2026 - Added "^" as the postfix to the name "curry" to indicate it's
		a special "higher-order" function.
	}
]

; helper func
get-args: function [f][
	collect [foreach e spec-of :f [
		if refinement? e [break]
		if any [word? e lit-word? e] [keep e]
	]]
]

; currying
curry^: function [f v][
	f?: function? :f ; a func?
	ff: either f? [:f][get f] ; get func directly or by its name
	
	sp: spec-of :ff ; raw spec
	a: get-args :ff ; cleaned args
	
	; curried? get skip counter
	sc: either c?: sp/1 = "C!" [to-integer sp/2][0]
	
	ca: copy a  na: copy a
	
	either v = [] [ ; skipping
		sc: sc + 1 ; spec unchanged
	][
		either sc > 0 [ ; skip some args
			remove skip ca sc ; removed curried arg from spec
			na/(sc + 1): v ; replace with value
			na: skip na sc  a: skip a sc ; point to next args
		][ ; normal
			ca: next ca ; skip curried arg
			na/1: v ; replace with value
		]
	]

	; add marker and counter
	f: func compose ["C!" (to-string sc) (ca)] either c? [ ; curried?
		replace copy body-of :ff a na ; chained curry		
	][
		compose [(:f)(na)] ; first curry
	]
	either empty? ca [f][:f] ; return function or result
]

->: make op! :curry^ ; curry operator (shortcut)

; This function will print a string as a heading and print any codes
; to the screen before executing it.
demo: function [s b] [print ["^/==" s "==^/^/" mold/only b "^/>>"] do b]

demo "Real Currying in Red" [

sum: func [a b c][a + b + c]
]

demo "Curry one arg from 'sum', return func with two args (s1)" [
s1: 'sum -> 1
print s1 2 3	; 6
]

demo "Curry one arg from 's2', return func with one arg (s2)" [
s2: 's1 -> 2
print s2 3		; 6
]

demo "Curry one arg from 's3', return the result" [
s3: 's2 -> 3
print s3		; 6
]

demo "Currying all args at once, return the result" [
print 'sum -> 1 -> 2 -> 3	; 6
]

demo "Currying native control" [
i: 1
'while -> [i <= 10] -> [print i i: i + 1]
]

demo "Currying native control" [
'repeat -> 'i -> 10 -> [print ["repeating" i]]
]

demo "Currying anonymous function (lambda)" [
print (func [a b][a + b]) -> 10 -> 20 ; 30
]

demo "Skipping args" [
f: 'sum -> [] -> [] -> 30
print f 10 20
]

demo "Sample generated code" [
?? f
]
