;-  function without agument
;- first example like a subroutine call
hello: does [print "hello"]
;- calling
hello
;- second return a value
phi: func [][return to-float ((1.0 + sqrt(5.0)) / 2.0)]
;-calling print phi
print phi
;-function with optional arguments
optional: func [arg1 /opt1 /opt2][
	print arg1
	if opt1 [print "option1"]
	if opt2 [print "option2"]
]
;- calling
optional 10
optional/opt1 10
optional/opt2 10
optional/opt1/opt2 10
;function with variable number of arguments
;we can use block type to do it
blocksum: func [b][r: 0 foreach n b [r: r + n] r]
; calling
print blocksum [1]
print blocksum [1 2 3 4 5 6 7 8 9]
;- first class function
;- creating function from à function at run time
square: func[n][return (n * n)]
cube: func[n][ return (n * ( square n))]
;-calling
print cube 3
;- use function as argument of another function
print cube square 3
;- store functions in collections
myfuncs: [square cube]
;-calling
foreach f myfuncs [print reduce [f 2]]
