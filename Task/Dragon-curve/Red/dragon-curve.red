Red [
	title: "Dragon Curve"
	author: "hinjolicious"
	note: {
		Adapted from takowasabi's code on openprocessing.
		Assistance from Gemini AI.
	}
	needs: 'view
]

cycle-hue: func [
    h [number!] ; hue 0-360
    /local x
][
    h: mod h 360.0
    if h < 0 [h: h + 360.0]

    ; Calculate intermediate color projection value
    x: to integer! (255.0 * (1.0 - absolute ((mod (h / 60.0) 2.0) - 1.0)))

    ; Directly route to RGB tuple based on the 60-degree wheel sector
    case [
        h < 60.0  [as-color 255 x 0]
        h < 120.0 [as-color x 255 0]
        h < 180.0 [as-color 0 255 x]
        h < 240.0 [as-color 0 x 255]
        h < 300.0 [as-color x 0 255]
        true      [as-color 255 0 x]
    ]
]

width: 1100
height: width * 0.6
l: width / 3
r: l / 2
ax: l / 1.3
ay: r / 1.2
bx: width - r
by: height - l / 1.1

drawing: [pen off]

dragon: func [x1 y1 x2 y2 n h /local dx dy d x3 y3][
	dx: x2 - x1
	dy: negate (y2 - y1)
	d: (dx + dy) / 2
	x3: x1 + d
	y3: y2 + d
	either n < 1 [
		clr: random 2.0 * cycle-hue h
		append drawing compose/deep [
			fill-pen (clr)
			;line (as-pair x1 y1) (as-pair x3 y3) (as-pair x2 y2)
			circle (as-pair x1 y1) 3 circle (as-pair x3 y3) 2 circle (as-pair x2 y2) 4
		]
	][
		dragon x1 y1 x3 y3 (n - 1) (h - 5)
		dragon x2 y2 x3 y3 (n - 1) (h + 5)
	]
]

dragon ax ay bx by 12 0

view [
	title "Dragon Curve"
	backdrop black
	box with [size: as-pair width height]
	draw drawing
]
