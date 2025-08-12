Red [ "Logical Operations - Hinjo, 23 July 2025" ]

test: func [a b] [
	foreach op [and or xor not] [
		either op = 'not
			[ print [op a "==>" do compose [(op) a]] ]
			[ print [a op b "==>" do compose [a (op) b]] ]
	] print ""
]

test true true
test true false
test false true
test false false
