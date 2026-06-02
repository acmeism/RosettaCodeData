Red [
	title: "Forest Fire"
	author: "hinjolicious"
	resources: "EasyLang, etc."
	needs: 'View
]

pfire: 0.0001
ptree: 0.01

f: []  append/dup f 0 (102 * 102)
p: copy f

show-forest: func [/local r c r1 c1 i h cr clr][
	repeat r 100 [
		repeat c 100 [
			r1: r - 1  c1: c - 1
			i: r1 * 102 + c1 + 104
			h: f/:i
			if h <> p/:i [
				cr: to-pair reduce [c1 * 6 r1 * 6]
				switch/default h [
					0 [ append img/draw compose [
							fill-pen black
							circle (cr) 3 ] ]
							
					1 [ append img/draw compose [
							fill-pen 0.128.0
							circle (cr) 3 ] ]
							
				][	clr: make tuple! reduce [(min 255 h * 25) 30 0]
					append img/draw compose [
						fill-pen (clr)
						circle (cr) 3 ]
				]
			]
		]
	]
]

update-forest: func [/local t r c ri s][
	t: copy f  f: copy p  p: copy t
	
	repeat r 100 [
		repeat c 100 [
			i: (r - 1) * 102 + (c - 1) + 104
			switch/default p/:i [
				0 [ f/:i: 0
					if (random 1.0) < ptree [f/:i: 1] ] ; fire start
					
				1 [ f/:i: 1
					s: p/(i - 103) + p/(i - 102) + p/(i - 101)
					s: s + p/(i - 1) + p/(i + 1)
					s: s + p/(i + 101) + p/(i + 102) + p/(i + 103)
					if any [s >= 9  (random 1.0) < pfire] [f/:i: 9] ]
					
				4 [ f/:i: 0 ]
			][	f/:i: p/:i - 1
			]
		]
	]
]

repeat r 100 [
	repeat c 100 [
		i: (r - 1) * 102 + (c - 1) + 104
		if (random 1.0) < 0.5 [f/:i: 1]
	]
]

view/tight [
	title "Forest Fire"
	img: base 600x600 black
	draw [line-width 0]
	rate 60
	on-time [
		show-forest
		update-forest
	]
	[quit]
]

