Red ["Maze generation"]

size: as-pair to-integer ask "Maze width: " to-integer ask "Maze height: "
random/seed now/time
offsetof: function [pos] [pos/y * size/x + pos/x + 1]
visited?: function [pos] [find visited pos]

newneighbour: function [pos][
	nnbs: collect [
		if all [pos/x > 0 not visited? p: pos - 1x0] [keep p]
		if all [pos/x < (size/x - 1) not visited? p: pos + 1x0] [keep p]
		if all [pos/y > 0 not visited? p: pos - 0x1] [keep p]
		if all [pos/y < (size/y - 1) not visited? p: pos + 0x1] [keep p]
	]
	pick nnbs random length? nnbs
]
expand: function [pos][	
	insert visited pos
	either npos: newneighbour pos [
		insert exploring npos
		do select [
			0x-1 [o: offsetof npos walls/:o/y: 0]
			1x0  [o: offsetof  pos walls/:o/x: 0]
			0x1  [o: offsetof  pos walls/:o/y: 0]
			-1x0 [o: offsetof npos walls/:o/x: 0]
		] npos - pos
	][
		remove exploring
	]
]
visited: []
walls: append/dup [] 1x1 size/x * size/y
exploring: reduce [random size - 1x1]

until [
	expand exploring/1
	empty? exploring
]

print append/dup "" " _" size/x
repeat j size/y [
	prin "|"
	repeat i size/x [
		p: pick walls (j - 1 * size/x + i)
		prin rejoin [pick " _" 1 + p/y pick " |" 1 + p/x]
	]
	print ""
]
