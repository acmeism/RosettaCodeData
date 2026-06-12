Red [ title: "Snake and Ladder" author: "hinjolicious" ]

portals: #[
	4 14
	9 31
	17 7
	20 38
	28 84
	40 59
	51 67
	54 34
	62 19
	63 81
	64 60
	71 91
	87 24
	93 73
	95 75
	99 78
]

players: #[]
p: none
pn: none ; number of players

roll-dice: function [][1 + random 5]

move-player: function [d][
	prin ["Player " p " rolled DICE " d " --> "]
	players/(p) + d
]

snake-or-ladder: function [m][
	prin ["Moved to " m " "]
	if m > 100 [
		m: 100 - (m - 100)
		prin ["BUMPED to " m "! "]
	]
	j: portals/(m)
	either none? j [
		players/(p): m ;no jump
	][
		players/(p): j
		either j > m [
			print ["Climbed a LADDER to " j]
		][
			print ["A SNAKE carried to " j]
		]	
	]
	print ""
	j
]

check-winner: function [][players/(p) = 100]

random/seed now/time/precise
play: does [
	print "== SNAKE AND LADDER =="
	pn: to-integer ask "How many player? "
	repeat i pn [put players i 1] ;add players on cell 1
	
	print "Game is starting..."
	winner: false
	p: 1
	while [not winner] [
		d: roll-dice
		m: move-player d
		snake-or-ladder m
		winner: check-winner
		if winner [
			print ["HURRAY, player " p " is a WINNER!!!"]
			break
		]
		p: (p // pn) + 1
	]
	print "Game ended"
]

play
