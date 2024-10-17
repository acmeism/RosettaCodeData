cold-one?: function [
	count [integer!]
][
	case [
		count < 1 [return print "drunk, eh?"]
		count = 1 [print "1 bottle of beer and it's mine."		]		
		'otherwise [
			print [count x: "bottles of beer" y: "on the wall" ","
				count x
			]
			print [
				"take one down pass it around, "
				z: (-1 + count)
				either z = 1 [replace x "s" ""][x]
				y
			]
		]
	]
	cold-one? -1 + count
	
]
