Red [ title: "Matrix Multiplication" author: "hinjolicious" ]

a: [[1 1 1 1]
	[2 4 8 16]
	[3 9 27 81]
	[4 16 64 256]]
	
b: compose/deep [[4 -3 (4 / 3) (-1 / 4)]
	[(-13 / 3) (19 / 4) (-7 / 3) (11 / 24)]
	[(3 / 2) -2 (7 / 6) (-1 / 4)]
	[(-1 / 6) (1 / 4) (-1 / 6) (1 / 24)]]

mat-mult: func [a[block!] b[block!] /local ar ac br bc sum] [
	a-rows: length? a	; rows of a
	a-cols: length? a/1	; columns of a
	b-rows: length? b	; rows of b
	b-cols: length? b/1	; columns of b
	
	if a-cols <> b-rows [return none]
	
	collect [ repeat ra a-rows [ ; Loop through rows of A
		keep/only collect [ repeat cb b-cols [ ; Loop through columns of B
			sum: 0.0
			repeat ca a-cols [ ; Cross-multiply and sum
				sum: sum + ( a/:ra/:ca * b/:ca/:cb )
			]
			keep sum
		]]
	]]
]

mat-print: func [m[block!] /padding pd /round-to rt] [
	unless padding [pd: 5]
	unless round-to [rt: 1]
	foreach r m [
		prin ["["]
		foreach c r [
			prin [pad/left round/to c rt pd]
		]
		print [" ]"]
	]
]

mat-print/round-to mat-mult a b 0.1

print ""

mat-print/padding mat-mult
	[[1 2][3 4]]
	[[-3 -8 3][-2 1 4]]
	4
