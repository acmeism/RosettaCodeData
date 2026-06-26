Red [
	title: "Partial Function Application in Red"
	author: "hinjolicious"
	posted: "July 21, 2025"
	updated: "June 18, 2026"
	notes: {
		Changed the name from "c!" to "partial^" to correctly reflect the actual work
		of the function.
		Also, the "^" postfix in the name should indicate it's a special "higher-order" function.
	}
]

; define a custome simple 'PFA' function
partial^: func ['f x][func [y] compose [(f) (x) y]]

; test with Red's built-in functions "add" and "multiply"
add10: partial^ add 10
print add10 5
print add10 7

double: partial^ multiply 2
print double 5
print double 100

; test with a custom function to get x to power of y
my-power: func [x y][either y = 0 [1][tot: 1 loop y [tot: tot * x]]]

; create a binary power by doing pfa on it
my-binary-power: partial^ my-power 2
foreach i [0 1 2 3 4 5 6 7 8 9 10] [print my-binary-power i]

; this is doing pfa on the built-in Red's "if" function!
doit: partial^ if true
doit [print "Hello currying world!"]

; simulate a realistic use of pfa
random/seed now
test: func [bCond bAction] [if do bCond bAction]
system-failed?: partial^ test [(random 100) > 80]

; how many time failures in ten years?
fail: 0  year: 1  while [year <= 10] [  print [year " "]
    system-failed? [ fail: fail + 1  print "Maintenance!" ]
    year: year + 1
]
print ["Failed " fail]
