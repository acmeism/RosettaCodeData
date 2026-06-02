Red [
	title: "Kronecker Product"
	author: "hinjolicious"
	note: "Based on Python's example"
]

a1: [[1 2] [3 4]]
b1: [[0 5] [6 7]]

a2: [[0 1 0] [1 1 1] [0 1 0]]
b2: [[1 1 1 1] [ 1 0 0 1] [1 1 1 1]]

kronecker-product: func [m1 m2 /local count e counter check sub-list n1 n2][
	count: length? m2
	
	collect [	
		foreach e m1 [
			counter: 1
			check: 0

			while [check < count][
				sub-list: collect [
					foreach n1 e [
						foreach n2 m2/:counter [keep n1 * n2]
					]
				]
				keep/only sub-list				
				counter: counter + 1
				check: check + 1
			]
		]
	]
]

r1: kronecker-product a1 b1
r2: kronecker-product a2 b2

foreach e r1 [print mold e]
print ""
foreach e r2 [print mold e]
