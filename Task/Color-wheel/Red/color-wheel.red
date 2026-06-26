Red [
	title: "HSV Color Wheel"
	author: "hinjolicious"
	note: {
		Adapted from Processing's example.
		Assistance from Gemini AI.
	}
	needs: 'view
]

#include %colors.red ; https://gist.github.com/hinjolicious/ef2beccb53705ed722c4b292a593494c
#include %for-loop.red ; https://gist.github.com/hinjolicious/dcd703007bc4564df64b55b49d0beef1
#include %increment.red ; https://gist.github.com/hinjolicious/151ec4d7a8f270ea1db26493c2e1cfac

w: 400
rad: cx: cy: w / 2

drawing: [pen off]
do for [x: 0][x < w][++ x][
	do for [y: 0][y < w][++ y][
		rx: to-float x - cx
		ry: to-float y - cy
		s: (sqrt ((rx * rx) + (ry * ry))) / rad
		if s <= 1.0 [
			h: (((atan2 ry rx) / pi) + 1.0) / 2.0
			c: hsb-to-rgb
				to-integer (h * 360)
				to-integer (s * 255)
				255
			p: as-pair x y
			append drawing compose [fill-pen (c) circle (p) 1]
		]
	]
]

view [
	title "HSB Color Wheel"
	backdrop black
	box with [size: as-pair w w]
	draw drawing
]
