Red[ "Currying in Red - Hinjo, 21 July 2025" ]

; define a custome simple currying function
c!: func ['f x][do compose/deep [func [y] [do compose [(get f) (x) y]]]]

; test with Red's built-in functions "add" and "multiply"
add10: c! add 10
print add10 5
print add10 7

double: c! multiply 2
print double 5
print double 100

; test with a custom function to get x to power of y
my-power: func [x y][either y = 0 [1][tot: 1 loop y [tot: tot * x]]]

; create a binary power by currying it
my-binary-power: c! my-power 2
foreach i [0 1 2 3 4 5 6 7 8 9 10] [print my-binary-power i]

; this is currying the built-in Red's "if" function!
doit: c! if true
doit [print "Hello currying world!"]

; simulate a realistic use
random/seed now
test: func [bCond bAction] [if do bCond bAction]
system-failed?: c! test [(random 100) > 80]

; how many time failures in ten years?
fail: 0  year: 1  while [year <= 10] [  print [year " "]
    system-failed? [ fail: fail + 1  print "Maintenance!" ]
    year: year + 1
]
print ["Failed " fail]
