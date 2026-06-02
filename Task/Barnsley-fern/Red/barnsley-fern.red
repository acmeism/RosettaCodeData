Red [
    title: "Barnsley Fern"
    author: "hinjolicious"
	resources: "DeepSeek, Rebol's example, Wikipedia"
]

barnsley-fern: function [size [pair!]] [
    img: make image! reduce [size black]
    width: size/x
    height: size/y

    p: 0x0
    x: y: 0.0
    random/seed now/time

    repeat i 200000 [
        xt: yt: 0.0
        r: random 1.0

        case [
            r < 0.01 [
				xt: 0.0
				yt: 0.16 * y ]
            r < 0.86  [
				xt: (0.85 * x) + (0.04 * y)
				yt: (-0.04 * x) + (0.85 * y) + 1.60 ]			
			r < 0.93 [
				xt: (0.20 * x) - (0.26 * y)
				yt: (0.23 * x) + (0.22 * y) + 1.60 ]
            true [
				xt: (-0.15 * x) + (0.28 * y)
				yt: (0.26 * x) + (0.24 * y) + 0.44 ]
        ]

        x: xt  y: yt
        p: as-pair
			to-integer (width / 2 + (60 * x))
			to-integer (height - (60 * y))

        if within? p 0x0 size [poke img p 50.150.0]
    ]
    img
]

img: barnsley-fern 640x640

view/tight [
    title "Barnsley Fern"
	image img
]
