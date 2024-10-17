w: 99
while [w][
	print [
		reform [
			w x: either 1 < w ["bottles"] ["bottle"] y: "of beer" z: "on the wall" ","
			w x y
		]
	]
	w: w - 1
	if w = 1 [remove at x length? x]
	print [
		"take one down pass it around, "
		either 0 < w [
			reform [w x y z]
		][
			w: false reform [
				"no more bottles " y rejoin [z "."]
			]
		]
	]
]
