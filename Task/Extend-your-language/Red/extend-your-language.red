Red [ "Extend your language - Hinjolicious"]

; This function will print a string as a heading and print any codes
; to the screen before executing it.
demo: function [s b] [print ["^/==" s "==^/"] print [mold/only b "^/^/Output:"] do b]

demo "Creating a custom control structure if-both" [
if-both: function [cond1 cond2 both-body first-body second-body none-body] [
	c1: do cond1
	c2: do cond2
    case [
        all [c1 c2] [do both-body]
        c1 [do first-body]
        c2 [do second-body]
        true [do none-body]
    ]
]
]

demo "Testing it" [
random/seed now

test: does [
	if-both [(random 100) > 50] [(random 100) < 50] [
		print "both"
	][
		print "first"
	][
		print "second"
	][
		print "none"
	]
]

loop 10 [test]
]
