Red [Needs: 'View]

color: brown
width: 9
view/tight/options/flags/no-wait [	; click image to grow tree
	img: image 1097x617 draw [
		pen brown line-width 9 line 500x600 500x500] [grow]
] [offset: 0x0] [no-border]

ends: reduce [500x500 pi * 3 / 2]	; list of terminal nodes
da: pi * 30 / 180	; angle of branches in radians
ea: pi * 5 / 180	; offset added to angle to break symmetry

l: 200			; branches initial lenght
scale: 0.7		; branches scale factor
grow: does [		; grows branches
	l: l * scale
	color: 2 * color + leaf / 3
	width: width - 1
	newends: copy []
	foreach [p a] ends [
		a1: a + da - ea
		p1: p + as-pair l * cos a1 l * sin a1
		a2: a - da - ea
		p2: p + as-pair l * cos a2 l * sin a2
		append img/draw compose/deep [		
			pen (color)	line-width (width) line (p1) (p) (p2)]
		append newends reduce [p1 a1 p2 a2]
	]
	ends: newends
]
