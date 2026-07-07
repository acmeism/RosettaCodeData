Red [
	Title:  "Mandelbrot (Optimized)"
	Author: "hinjolicious"
	Note: {
		* Adapted from Red's showcase code.
		* Added interactivity: zoom/un-zoom, changing colors, smooth colors, etc.
		* Assistance from Gemini AI
	}
	Needs:  'View
	Tabs:	4
]

width: 1000 height: 1000
zoom-level: 1
random/seed now/time/precise

style: 1 ; Topological

mandel-fast: routine [
	img  [image!] iterations [integer!] width [float!] height [float!]
	xmin [float!] xmax [float!] ymin [float!] ymax [float!]
	redf [integer!] greenf [integer!] bluef [integer!]
/local
	pix [int-ptr!] handle
	w [integer!] h [integer!] row [integer!] col [integer!]
	dx [float!] dy [float!] cx [float!] cy [float!]
	x [float!] y [float!] xx [float!] yy [float!] xy [float!]
	i [integer!] max-i [integer!]
	log-zn [float!] log-2 [float!] nu [float!]
	phase-r [float!] phase-g [float!] phase-b [float!]
	r [integer!] g [integer!] b [integer!]
; New variables for period checking
	old-x [float!] old-y [float!]
	check-interval [integer!] check-counter [integer!]
	diff-x [float!] diff-y [float!]	
][
	handle: 0
	pix: image/acquire-buffer img :handle
	
	w: as integer! width
	h: as integer! height
	
	; 1. Pre-calculate coordinate step sizes
	dx: (xmax - xmin) / (width - 1.0)
	dy: (ymax - ymin) / (height - 1.0)
	
	cy: ymin
	row: 0 while [row < h][
		cx: xmin
		col: 0 while [col < w][
		
			; 2. Inlined escape loop
			x: 0.0 y: 0.0 xx: 0.0 yy: 0.0
			i: iterations
			
			; Initialize periodicity tracking
			old-x: 0.0 old-y: 0.0
			check-interval: 20
			check-counter: 20
			
			while [all [i > 0 (xx + yy) <= 16.0]][ ; Increased escape radius to 16.0 for smoother log math
				xy: x * y
				xx: x * x
				yy: y * y
				x:  xx - yy + cx
				y:  xy + xy + cy
				i:  i - 1

				; --- Periodicity Check ---
				; Calculate absolute distance between current Z and old Z
				diff-x: x - old-x
				diff-y: y - old-y
				if diff-x < 0.0 [diff-x: 0.0 - diff-x]
				if diff-y < 0.0 [diff-y: 0.0 - diff-y]
				
				; Tighten the tolerance gate to prevent early triggers at high zoom
				if all [diff-x < 0.000000000000001 diff-y < 0.000000000000001][
					i: 0  ; Force-break the loop safely
				]
				
				; Update history checkpoint at regular intervals
				check-counter: check-counter - 1
				if check-counter = 0 [
					old-x: x
					old-y: y
					check-interval: check-interval + 10 ; Dynamically expand history window
					if check-interval > 100 [check-interval: 100] ; Cap it
					check-counter: check-interval
				]
				;
			]
			;max-i: iterations - i

			either i > 0 [
				; Calculate log(xx + yy) / 2.0
				log-zn: log-e (xx + yy)
				log-2: 0.69314718056  ; ln(2)
				
				; Fractional iteration count
				nu: (as float! (iterations - i)) + 1.0 - ((log-e (log-zn / 2.0)) / log-2)

				; Convert smooth 'nu' into a cyclic phase (0.0 to 1.0)
				;phase: nu * 0.05 ; Adjust 0.05 to change frequency of color cycles
				; 1. Use a small scaling constant so the factors don't cycle violently fast
				; 2. Multiply 'nu' by each color factor converted to a float
				phase-r: nu * 0.005 * (as float! redf)
				phase-g: nu * 0.005 * (as float! greenf)
				phase-b: nu * 0.005 * (as float! bluef)

				; Fast sine-based procedural color palette
				r: as integer! ((0.5 + (0.5 * sin (phase-r * 6.28318 + 0.0))) * 255.0)
				g: as integer! ((0.5 + (0.5 * sin (phase-g * 6.28318 + 2.0))) * 255.0)
				b: as integer! ((0.5 + (0.5 * sin (phase-b * 6.28318 + 4.0))) * 255.0)
				
				pix/value: FF000000h or (r << 16) or (g << 8) or b
			][
				pix/value: FF000000h  ;or 004400h
			]
			pix: pix + 1
			cx: cx + dx
		col: col + 1
		]
		cy: cy + dy
	row: row + 1
	]
	image/release-buffer img handle yes
]

mandelbrot: function [image xmin xmax ymin ymax iterations redf greenf bluef][
	width:  to float! image/size/x
	height: to float! image/size/y
	t0: now/time/precise
	image/rgb: black
	mandel-fast image iterations width height xmin xmax ymin ymax redf greenf bluef
	dt/data: third now/time/precise - t0
]

zoom: func [event factor xmin xmax ymin ymax redf greenf bluef
	/local cx cy rx ry p px py
][
	zm/data: zm/data * factor
	p: event/offset
	px: p/x py: p/y
	if any [px < 1 px > width py < 1 py > height][return]
	
    cx: xmin/data + ((xmax/data - xmin/data) * event/offset/x / width)
    cy: ymin/data + ((ymax/data - ymin/data) * event/offset/y / height)

    rx: (xmax/data - xmin/data) / 2 / factor
    ry: (ymax/data - ymin/data) / 2 / factor
    xmin/data: cx - rx  xmax/data: cx + rx
    ymin/data: cy - ry  ymax/data: cy + ry
	show fields
	mandelbrot canvas/image xmin/data xmax/data ymin/data ymax/data iterations/data redf/data greenf/data bluef/data
]

view/tight [
	title "Red Mandelbrot (fast)"
	style txt: text 70 right
	style txt2: text 150 right
	below
	fields: group-box 2 [
		style fld: field 70
		txt "x-min" xmin: fld "-2.25"
		txt "x-max" xmax: fld  "0.75"
		txt "y-min" ymin: fld "-1.5"
		txt "y-max" ymax: fld  "1.5"
		txt "iterations" iterations: fld "100"
		txt "zoom factor"  zoomf:	 fld "4.0"
		txt "red factor"   redf:	 fld "32"
		txt "green factor" greenf:	 fld "16"
		txt "blue factor"  bluef:	 fld "8"
	]
	button "Random Colors" [
		redf/data: random 20 greenf/data: random 20 bluef/data: random 20
		mandelbrot canvas/image xmin/data xmax/data ymin/data ymax/data iterations/data redf/data greenf/data bluef/data
	]
	button "Draw" [
		mandelbrot canvas/image xmin/data xmax/data ymin/data ymax/data iterations/data redf/data greenf/data bluef/data
	]
	panel [
		origin 0x0 below
		txt "time(s):" dt: txt2
		txt "zoom:" zm: txt2
	]
	return
	
	canvas: image 1000x1000 all-over
	
	on-down     [zoom event zoomf/data       xmin xmax ymin ymax redf greenf bluef]
	on-alt-down [zoom event (1 / zoomf/data) xmin xmax ymin ymax redf greenf bluef]	
	do [
		redf/data: random 20 greenf/data: random 20 bluef/data: random 20
		zm/data: 1
		mandelbrot canvas/image xmin/data xmax/data ymin/data ymax/data iterations/data redf/data greenf/data bluef/data
	]
]
