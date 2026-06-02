Red [
    title: "Archimedean spiral"
	author: "hinjolicious"
	resources: "Rebol's example"
]

arc-spiral: func [
    "Draw an Archimedean spiral."
    size [pair!]    "Image dimensions (width x height)"
    ri   [number!]  "Radius increment per step"
    ti   [number!]  "Angle increment per step (in radians)"
][
    p: c: size / 2    ;; Calculate center point of the image
    r: t: 0.0         ;; Initialize radius and angle to zero
    blk: copy [pen white line-width 1]  ;; Initialize empty block to store spiral points

    ;; Generate spiral points until radius reaches edge of image
    while [ r < c/x ][
        ;; Store current point
		p0: p

        ;; Calculate next point using polar coordinates
        ;; Convert from polar (r, t) to cartesian (x, y)
        p/x: to-integer c/x + (r * cos t)
		p/y: to-integer c/y + (r * sin t)
        ;; Increment radius (spiral expands outward)
        r: r + ri
        ;; Increment angle (spiral rotates)
        t: t + ti
        append blk compose [line (p0) (p)]
    ]
	blk
]

blk: arc-spiral 400x400 0.03 0.02

view/tight compose [
	title "Archimedean Spiral"
	base 400x400 black
	draw blk
]
