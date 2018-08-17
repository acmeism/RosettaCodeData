REBOL [
    Title: "Factorial"
    URL: http://rosettacode.org/wiki/Factorial_function
]

; Standard recursive implementation.

factorial: func [n][
	either n > 1 [n * factorial n - 1] [1]
]

; Iteration.

ifactorial: func [n][
	f: 1
	for i 2 n 1 [f: f * i]
	f
]

; Automatic memoization.
; I'm just going to say up front that this is a stunt. However, you've
; got to admit it's pretty nifty. Note that the 'memo' function
; works with an unlimited number of arguments (although the expected
; gains decrease as the argument count increases).

memo: func [
	"Defines memoizing function -- keeps arguments/results for later use."
	args [block!] "Function arguments. Just specify variable names."
	body [block!] "The body block of the function."
	/local m-args m-r
][
	do compose/deep [
		func [
			(args)
			/dump "Dump memory."
		][
			m-args: []
			if dump [return m-args]
			
			if m-r: select/only m-args reduce [(args)] [return m-r]
			
			m-r: do [(body)]
			append m-args reduce [reduce [(args)] m-r]
			m-r
		]
	]
]

mfactorial: memo [n][
	either n > 1 [n * mfactorial n - 1] [1]
]

; Test them on numbers zero to ten.

for i 0 10 1 [print [i ":" factorial i  ifactorial i  mfactorial i]]
