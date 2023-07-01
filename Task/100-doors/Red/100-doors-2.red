Red ["Doors"]

doors: make bitset! len: 100
repeat step len [
	repeat n to-integer len / step [
		m: step * n
		doors/:m: not doors/:m
	]
]
repeat n len [if doors/:n [print n]]
