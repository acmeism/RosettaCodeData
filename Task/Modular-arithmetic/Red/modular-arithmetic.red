Red ["Modular arithmetic"]

; defining the modular integer class, and a constructor
modulus: 13
m: function [n] [
	either object? n [make n []] [context [val: n % modulus]]
]
; redefining operators +, -, *, / to include modular integers
foreach [op fun][+ add - subtract * multiply / divide][
	set op make op! function [a b] compose/deep [
		either any [object? a object? b][
			a: m a
			b: m b
			m (fun) a/val b/val
		][(fun) a b]	
	]
]
; redefining power - ** ; second operand must be an integer
**: make op! function [a n] [
	either object? a [
		tmp: 1
		loop n [tmp: tmp * a/val % modulus]
		m tmp
	][power a n]	
]
; testing
f: function [x] [x ** 100 + x + 1]
print ["f definition is:" mold :f]
print ["f((integer) 10) is:" f 10]
print ["f((modular) 10) is: (modular)" f m 10]
