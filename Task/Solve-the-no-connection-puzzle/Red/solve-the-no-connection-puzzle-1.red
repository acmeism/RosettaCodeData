Red ["Solve the no connection puzzle"]

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
			print rejoin ["Here is a solution: " pegs]
			halt ; comment this line to get all solutions
		][
			foreach peg rest [check append copy pegs peg]
		]	
	]
]
	; start with and empty list
check []
