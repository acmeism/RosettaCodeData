Red [
    Purpose: "Conway's Game of Life"
    Author: "Joe Smith"
]

neigh: [[0 1] [0 -1] [1 0] [-1 0] [1 1] [1 -1] [-1 1] [-1 -1]]
conway: function [petri] [
	new-petri: copy/deep petri
	repeat row length? petri [
		repeat col length? petri [
			live-neigh: 0
			foreach cell neigh [
				try [
					if petri/(:row + cell/1)/(:col + cell/2) = 1 [live-neigh: live-neigh + 1]	
				]
			]
			switch petri/:row/:col [
				1	[if any [live-neigh < 2 live-neigh > 3]
						[new-petri/:row/:col: 0]
					]	
				0	[if live-neigh = 3 [new-petri/:row/:col: 1]]
	]]]
	clear insert petri new-petri
]

*3-3: [
	[0 1 0]
	[0 1 0]
	[0 1 0]
]

*8-8: [
	[0 0 1 0 0 0 0 0]
	[0 0 0 1 0 0 0 0]
	[0 1 1 1 0 0 0 0]
	[0 0 0 0 0 0 0 0]
	[0 0 0 0 0 0 0 0]
	[0 0 0 0 0 0 0 0]
	[0 0 0 0 0 0 0 0]
	[0 0 0 0 0 0 0 0]
]

display: function [table] [
	foreach row table [
		print replace/all (replace/all to-string row "0" "_") "1" "#"	
	] print ""
]

loop 5 [
	display *3-3
	conway *3-3
]
loop 23 [
	display *8-8
	conway *8-8
]
