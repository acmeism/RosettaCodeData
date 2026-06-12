Red [
    Title: "Sunflower Fractal"
    Author: "hinjolicious"
    Resources: "Formulae's example, Gemini AI, etc."
]

sunflower-archimedean: func [
    size [integer!]
    n    [integer!]
    s1   [float!]
    s2   [float!]
    /local ga r theta center blk i x y col rad
][
	ga: 2.39996323 ;golden angle in radians
    center: size / 2
    size: (size - s2) / 2

    blk: copy []
    repeat i n [
        r: (i / n) * size
        theta: i * ga

        x: center + (r * cos theta)
        y: center + (r * sin theta)
	
        rad: s1 + (((s2 - s1) * i) / n) ;radius for the dots
		
        col: to-tuple reduce [ ;color
			max min ((i / n * 10) * 255) 255 0
			max min ((1 - (i / n / 1.5)) * 255) 255 0
            50
        ]
		
        append blk compose [ ;drawing commands
            fill-pen (col)  circle (as-pair x y) (rad)
        ]
    ]
    blk
]

sunflower-fermat: func [
    size [integer!]
    n    [integer!]
    s    [float!]
    /local ga r theta center blk i x y col
][
	ga: 2.39996323 ;radians
    center: size / 2
    size: (size - s) / 2

    blk: copy []
    repeat i n [
        r: (sqrt (i / n)) * size
        theta: i * ga

        x: center + (r * cos theta)
        y: center + (r * sin theta)

        col: to-tuple reduce [
			max min ((i / n * 10) * 255) 255 0
			max min ((1 - (i / n / 1.5)) * 255) 255 0
            50
        ]

        append blk compose [
            fill-pen (col)  circle (as-pair x y) (s) ;same radius
        ]
    ]

    blk
]

draw-blk: sunflower-archimedean 600 1500 5.0 7.5

view/tight [
    title "Archimedean Sunflower Fractal"
	base with [size: to-pair 600 600] black
	draw draw-blk
]

draw-blk: sunflower-fermat 600 1500 6.0

view/tight [
    title "Fermat Sunflower Fractal"
	base with [size: to-pair 600 600] black
	draw draw-blk
]
