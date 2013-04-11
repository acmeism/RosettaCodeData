REBOL [
    Title: "Stair Climber"
    Date: 2009-12-14
    Author: oofoe
    URL: http://rosettacode.org/wiki/Stair_Climbing
]

random/seed now

step: does [random/only reduce [yes no]]

; Iterative solution with symbol stack. No numbers, draws a nifty
; diagram of number of steps to go. This is intended more to
; demonstrate a correct solution:

step_up: func [/steps s] [
	either not steps [
		print "Starting up..."
		step_up/steps copy [|]
	][
		while [not empty? s][
			print ["    Steps left:" s]
			either step [remove s][append s '|]
		]
	]
]

step_up  print ["Success!" crlf]

; Recursive solution. No numbers, no variables. "R" means a recover
; step, "+" means a step up.

step_upr: does [if not step [prin "R " step_upr  prin "+ " step_upr]]

step_upr  print ["Success!" crlf]

; Small recursive solution, no monitoring:

step_upt: does [if not step [step_upt step_upt]]

step_upt  print "Success!"
