Red [
	Title: "Runtime evaluation/in an environment"
	Author: "hinjolicious"
]

; a simple but generic lambda function
; multi-args lambda
; save it or directly evaluate

lambda: func [a b /eval v /local f][
	f: func a b
	either eval [do compose [f (v)]][:f]
]

prog: [x * x + x - 10]
a: lambda/eval [x] prog [2]
b: lambda/eval [x] prog [4]
print b - a

code: [a * b / (a + b)]
c: lambda/eval [a b] code [2 3]
d: lambda/eval [a b] code [3 4]
print d - c

my-func: lambda [x y z][x + y + z]
print my-func 10 20 30
