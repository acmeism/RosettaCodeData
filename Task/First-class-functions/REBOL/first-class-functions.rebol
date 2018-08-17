REBOL [
	Title: "First Class Functions"
	URL: http://rosettacode.org/wiki/First-class_functions
]

; Functions "foo" and "bar" are used to prove that composition
; actually took place by attaching their signatures to the result.

foo: func [x][reform ["foo:" x]]
bar: func [x][reform ["bar:" x]]

cube:  func [x][x * x * x]
croot: func [x][power  x  1 / 3]

; "compose" means something else in REBOL, so I "fashion" an alternative.

fashion: func [f1 f2][
	do compose/deep [func [x][(:f1) (:f2) x]]]

A: [foo sine    cosine    cube]
B: [bar arcsine arccosine croot]

while [not tail? A][
	fn: fashion get A/1 get B/1
	source fn ; Prove that functions actually got composed.
	print [fn 0.5  crlf]

	A: next A  B: next B  ; Advance to next pair.
]
