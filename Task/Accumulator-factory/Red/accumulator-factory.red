Red [ "Accumulator factory - hinjolicious" ]

; just a helper func to display informative output
demo: function [s b] [print ["^/==" s "==^/^/" mold/only b "^/>>"] do b]

demo "Accumulator" [
foo: function [init] [
	acc: init
	closure [val][acc: acc + val]
]
x: foo 1
print x 5 ; 6
foo 3 ; no effect!
print x 2.3 ; 8.3
]
