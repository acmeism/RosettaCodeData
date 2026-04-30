Red [
	Title: "Organic Fractal Tree"
	Author: "hinjolicious"
	Needs: 'View
	Note: "Some code are adapted from Red example in Rosetta Code"
]

xsize: 1920 ; display width
ysize: 1080 ; height
xmid: to integer! xsize / 2 ; horiz middle
ymid: to integer! ysize / 2 ; vert middle
dist: to integer! ysize * 0.8
iter: 0
plant: yes

INIT: does [
	if iter > 10 [ ; enough trees?
		iter: 0
		clear img/draw
		dist: to integer! ysize * 0.8
	]	
	trunk-height: ysize * random 0.2 ; trunk height
	root-xpos: random xsize
	root-ypos: dist + random trunk-height
	dist: dist + (10 + random 20)
	root-pos: as-point2d root-xpos root-ypos
	branch-ypos: root-ypos - trunk-height
	branch-pos: as-point2d root-xpos branch-ypos

	if branch-ypos > ysize [ ; how many times branch pos is out of screen?
		iter: iter + 1
	]
	color: as-color random 10 random 30 random 10 ; trunk/branch color
	width: 5 + random 10 ; trunk width
	ends: reduce [branch-pos pi * 1.5] ; list of terminal nodes
	l: 50 + random 50 ; branches initial lenght
]

GROW: does [ ; grow branches
	scale: 0.6 + random 0.4	
	l: l * scale
	if l < 15 [init  plant: yes]	

	color: color * 1.3
	width: width * 0.8
	newends: copy []
	
	; flower color
	flower: do random/only [red orange yellow cyan blue violet purple magenta pink white]
	
	foreach [p a] ends [
		da: pi * (  2 + random 30) / 180 ; angle of branches in radians
		ea: pi * (-10 + random 20) / 180 ; offset added to angle to break symmetry		

		a1: a + da - ea  p1: p + as-point2d l * cos a1 l * sin a1
		a2: a - da - ea  p2: p + as-point2d l * cos a2 l * sin a2
		
		either l < 21 [ ; draw leaves or flowers
			either (random 100) > 97 [ ; flowers
				lc:  flower * (0.5 + random 1.5) rad:  3 + random 10
				lc1: flower * (0.5 + random 1.5) rad1: 3 + random 10
				lc2: flower * (0.5 + random 1.5) rad2: 3 + random 10
				append img/draw compose/deep [		
					line-width 0
					pen (lc)  fill-pen (lc)  circle (p)  (rad)
					pen (lc1) fill-pen (lc1) circle (p1) (rad1)
					pen (lc2) fill-pen (lc2) circle (p2) (rad2)
					fill-pen 00.00.00.255 ]			
			][ ; leaves
				lc: color * (0.5 + random 1.5)
				append img/draw compose/deep [		
					line-width 0
					pen (lc)
					fill-pen (lc)
					line (p) (p1) (p2) (p)
					fill-pen 00.00.00.255 ]			
			]
		][ ; branches
			append img/draw compose/deep [		
				line-width (width)
				pen (color)
				line (p1) (p) (p2) ]
		]
		append newends reduce [p1 a1 p2 a2]
	]
	ends: newends
]

TREES: does [ ; not used!
	append img/draw compose/deep [ ; trunk
		line-width (width)
		pen (color)
		line (root-pos) (branch-pos) ]
]

GARDEN: does [
	either plant [plant: no  trees][grow]
]

MAIN: does [
	init
	view/tight/options/flags [
		img: base
		with [size: as-pair xsize ysize]
		black ; background
		draw [] ; draw are in "on-time"
		rate 10
		on-time [garden]
		[quit] ; click mouse to quit
	]
	[offset: 0x0] ; not-needed
	[no-border] ; no border!
]

random/seed now/time
main
