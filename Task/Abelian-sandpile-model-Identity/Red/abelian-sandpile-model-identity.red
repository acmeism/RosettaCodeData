Red [Purpose: "implement Abelian sandpile model"]

sadd: make object! [
	comb: function [pile1 [series!] pile2 [series!]] [
		repeat r 3 [
			repeat c 3 [
				pile2/:r/:c: pile2/:r/:c + pile1/:r/:c
			]
		]
		check pile2
	]
	check: func [pile [series!]] [
		stable: true row: col: none
		repeat r 3[
			repeat c 3[
				if pile/:r/:c >= 4 [
					stable: false
					pile/:r/:c: pile/:r/:c - 4
					row: r col: c
					break]
			]
			if stable = false [break]
		]
		unless stable = false [print trim/with mold/only pile "[]" exit]
		spill pile row col
	]
	spill: func [pile [series!] r [integer!] c [integer!]] [
		neigh: reduce [
			right: reduce [r c - 1] up: reduce [r + 1 c]
			left: reduce [r c + 1] down: reduce [r - 1 c]	
		]
		foreach n neigh [
			unless any [(pile/(n/1) = none) (pile/(n/1)/(n/2) = none)] [
				pile/(n/1)/(n/2): pile/(n/1)/(n/2) + 1
			]
		]
		check pile
	]
]

s1: [
	[1 2 0]
	[2 1 1]
	[0 1 3]
]

s2: [
	[2 1 3]
	[1 0 1]
	[0 1 0]
]

s3: [
	[3 3 3]
	[3 3 3]
	[3 3 3]
]

s3_id: [
	[2 1 2]
	[1 0 1]
	[2 1 2]
]

ex: [
	[4 3 3]
	[3 1 2]
	[0 2 3]
]

sadd/check copy/deep ex
sadd/comb copy/deep s1 copy/deep s2
sadd/comb copy/deep s2 copy/deep s1
sadd/comb copy/deep s3 copy/deep s3_id
sadd/comb copy/deep s3_id copy/deep s3_id
