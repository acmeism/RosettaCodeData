Red [
	Source:     https://github.com/vazub/rosetta-red
	Tabs:       4
	Needs:       'View
]

comment {
	This is a naive and therefore inefficient approach. For production-related tasks,
	a proper full implementation of Fortune's algorithm should be preferred.
}

canvas: 500x500
num-points: 50
diagram-l1: make image! canvas
diagram-l2: make image! canvas

distance: function [
	"Find Taxicab (d1) and Euclidean (d2) distances between two points"
	pt1 [pair!]
	pt2 [pair!]
][
	d1: (absolute (pt1/x - pt2/x)) + absolute (pt1/y - pt2/y)
	d2: square-root ((pt1/x - pt2/x) ** 2 + ((pt1/y - pt2/y) ** 2))
	reduce [d1 d2]
]

;-- Generate random origin points with respective region colors
points: collect [
	random/seed now/time/precise
	loop num-points [
		keep random canvas
		keep random white
	]
]

;-- Color each pixel, based on region it belongs to
repeat y canvas/y [
	repeat x canvas/x [
		coord: as-pair x y
		min-dist: distance 1x1 canvas
		color-l1: color-l2: none
		foreach [point color] points [
			d: distance point coord
			if d/1 < min-dist/1 [min-dist/1: d/1 color-l1: color]
			if d/2 < min-dist/2 [min-dist/2: d/2 color-l2: color]
		]
		poke diagram-l1 coord color-l1
		poke diagram-l2 coord color-l2
	]
]

;-- Draw origin points for regions
foreach [point color] points [
	draw diagram-l1 compose [circle (point) 1]
	draw diagram-l2 compose [circle (point) 1]
]

;-- Put results on screen
view [
	title "Voronoi Diagram"
	image diagram-l1 image diagram-l2
]
