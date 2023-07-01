Red [Needs: 'View]

points: [a b c d e f g h]
	; 'links' series will be scanned by pairs: [a c], [a d] etc.
links: [a c a d a e b d b e b f c d c g d e d g d h e f e g e h f h]
allpegs: [1 2 3 4 5 6 7 8]

	; check if two points are connected (then game is lost) i.e.
	; both are have a value (not zero) and absolute difference is 1
connected: func [x y] [all [
	x * y <> 0
	1 = absolute (x - y)
]]
	; a list of points is valid if no connexion is found
isvalid: function [pegs [block!]] [
	; assign pegs values to points, or 0 for remaining points
	set points append/dup copy pegs 0 8
	foreach [x y] links [if connected get x get y [return false]]
	true
]
	; recursively build a list of up to 8 valid points
check: function [pegs [block!]] [
	if isvalid pegs [
		rest: difference allpegs pegs
		either empty? rest [
			vis points
		][
			foreach peg rest [check append copy pegs peg]
		]	
	]
]
	; view solution found
vis: function [points] [
	pos: [100x0 200x0 0x100 100x100 200x100 300x100 100x200 200x200]
	offs: 30x30
	pos-of: function [x] [pick pos index? find points x]
	val-at: function [p] [get pick points index? find pos p]
	visu: layout [img: image 362x262 draw []]
	foreach [x y] links [append img/draw reduce [
		'line offs + pos-of x offs + pos-of y]]
	append img/draw [fill-pen snow]
	foreach p pos [append img/draw reduce [
		'circle offs + p 15 'text 21x15 + p form val-at p]]
	view/options visu [text: "Solution to the no-connection puzzle"]
]
	; start with and empty list
check []
