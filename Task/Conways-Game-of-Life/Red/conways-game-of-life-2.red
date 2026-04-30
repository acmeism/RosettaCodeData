Red [
	title: "Conway's Game of Life (graphical view)"
	author: "hinjolicious"
	needs: 'view
]

func-to-string: func [f][rejoin ["func [" form spec-of :f "] [" body-of :f "]"]] ; not used!

PLOTTER: make object! [
	; just some defaults:
	display-size: 500x500
	x-range: [-4.0 4.0]  y-range: [-4.0 4.0]
	x1: -1.0  x2:  1.0  y1: -1.0  y2:  1.0  x-step: 0.01
	color: blue  background-color: black  line-size: 1
	fn: func [x][sin x] ; a function
	draws: none
	header: none
	
	; Internal function to map a math coordinate (x,y) to a pixel pair (xp, yp)
	MAP-TO-PIXELS: function [x y][
		xp: (x - x1) * (display-size/1 / (x2 - x1))
		; Invert y because screen origin is top-left
		yp: display-size/2 - ((y - y1) * (display-size/2 / (y2 - y1)))
		as-point2D xp yp
	]
	
	DRAW: func [/local points x y][
		x-step: 0.01
		points: collect [
			x: x1  while [x <= x2][
				y: fn x
				keep map-to-pixels x y
			x: x + x-step]
		]
		draws: compose [line-width (line-size) pen (color) line (points)]
	]
	
	SHOW: func [][
		if none? header [header: func-to-string :fn]
		view/tight/flags [
			title header
			canv: base display-size
			background-color
			draw draws
			rate 100 ; for on-time func!
			on-time [CHANGER]
			[quit] ; mouse click = quit
		][no-border]
	]
	
	CHANGER: func[/local x y xy s n t][
		clear skip draws 5 ; clear display
		; display update and process next generation
		repeat x xmax [
			repeat y ymax [
				s: mat/:x/:y ; current status? 1=live 0=dead
				n: nb x y ; neigbours

				; display current states with color indicators
				color: case [
					all [s = 1  n < 2] [00.127.00]	; lonely
					all [s = 1  n > 3] [127.00.00]	; crowded
					s = 1 [00.127.00]				; n would be 2,3 --> stable
					all [s = 0  n = 3] [00.00.127]	; new birth
					true [black]					; barren
				]
				xy: map-to-pixels x y
				append draws compose [fill-pen (color) circle (xy) (rad)]	
				
				; process next generation
				nxt/:x/:y: either any [
					all [mat/:x/:y = 1  n > 1  n < 4] ; lives on
					all [mat/:x/:y = 0  n = 3]		  ; birth
				][1][0]
			]
		]
		; swap matrix
		t: mat  mat: nxt  nxt: t
		if (gen: gen + 1) > maxgen [init]
	] ; changer
]

matrix-rand: func [a b][collect [loop a [keep/only collect [loop b [keep random/only [0 1]]]]]]
matrix-zero: func [a b][collect [loop a [keep/only collect [loop b [keep 0]]]]]

; neighbour counting in a wrapped world!
nb: func [x y][
	xm1: x - 1  if xm1 < 1    [xm1: xmax]
	xp1: x + 1  if xp1 > xmax [xp1: 1]
	ym1: y - 1  if ym1 < 1    [ym1: ymax]
	yp1: y + 1  if yp1 > ymax [yp1: 1]
	mat/:xm1/:ym1 + mat/:xm1/:y + mat/:xm1/:yp1 +
	mat/:x/:ym1   +               mat/:x/:yp1   +
	mat/:xp1/:ym1 + mat/:xp1/:y + mat/:xp1/:yp1
]

xmax: 100 ; number of cells, horiz
ymax: 100 ; vert
dispx: xmax * 10 ; display size for 10 pixels cell size
dispy: ymax * 10 ; vert
rad: 0 ; radial size for cells (calculated)

; matrixes for generations:
mat: matrix-rand xmax ymax
nxt: matrix-zero xmax ymax

; counters:
gen: 0
maxgen: 500

init: does [
	mat: matrix-rand xmax ymax
	nxt: matrix-zero xmax ymax
	gen: 0
]

main: func [/local p][
	p: make plotter []
	p/header "Conway's Game of Life"
	p/display-size: to-pair reduce [dispx dispy] ; display size regardless for x and y range
	p/x1: 1  p/x2: xmax
	p/y1: 1  p/y2: ymax
	p/fn: func [x][x] ; dummy, not used
	rad: (min (dispx / xmax) (dispy / ymax)) / 2
	p/draw ; generate drawing
	p/draws/line-width: 0
	;p/draws/pen: white
	p/show ; display it
]	
main
