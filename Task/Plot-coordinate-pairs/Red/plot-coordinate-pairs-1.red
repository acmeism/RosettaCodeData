Red [
	title: "Plot Coordinate Pairs"
	author: "hinjolicious"
	resources: "Red Sensei, etc."
	Needs: 'View
]

;-- Configuration
plot-config: object [
    margin: 60x40          ; left/bottom margins
    top-margin: 30         ; space for title
    right-margin: 10
    tick-length: 5
    font-size: 10
    title-size: 10
]

;-- Generate axis ticks and labels
make-ticks: func [min-val max-val num-ticks] [
    collect [
        step: (max-val - min-val) / (num-ticks - 1)
        repeat i num-ticks [
            keep min-val + (step * (i - 1))
        ]
    ]
]

;-- Scale data to pixel coordinates
scale-point: func [x y x-range y-range plot-area] [
    px: plot-area/1/x + ((x - x-range/1) / (x-range/2 - x-range/1) * (plot-area/2/x - plot-area/1/x))
    py: plot-area/2/y - ((y - y-range/1) / (y-range/2 - y-range/1) * (plot-area/2/y - plot-area/1/y))
    as-pair to-integer px to-integer py
]

min-of: func [s [series!] /local m][
    m: first s
    foreach v s [if v < m [m: v]]
    m
]

max-of: func [s [series!] /local m][
    m: first s
    foreach v s [if v > m [m: v]]
    m
]

;-- Build complete plot
make-plot: func [
    canvas-size [pair!]
	
    data [block!] ; currently using format: [x1 y1 x2 y2 ...]
	; next improvement could be:
	; [plot-type op1 op2 op3 [x1 y1 x2 y2 ...]]
	; this can have multiple plots with different plotting type!
	
    /title ttl [string!]
    /x-label xl [string!]
    /y-label yl [string!]
    /x-range xr [block!]   ; [min max]
    /y-range yr [block!]
] [
    cfg: plot-config

    ; Calculate plot area
    plot-area: reduce [
        as-pair cfg/margin/x (cfg/top-margin)
        as-pair (canvas-size/x - cfg/right-margin) (canvas-size/y - cfg/margin/y)
    ]

    ; Auto-calculate ranges if not provided
    xs: extract data 2
    ys: extract next data 2
    unless xr [xr: reduce [min-of xs max-of xs]]
    unless yr [yr: reduce [min-of ys max-of ys]]

    ; Add 10% padding to ranges
    x-pad: (xr/2 - xr/1) * 0.05
    y-pad: (yr/2 - yr/1) * 0.05
    xr: reduce [xr/1 - x-pad  xr/2 + x-pad]
    yr: reduce [yr/1 - y-pad  yr/2 + y-pad]

    draw-block: copy []

    ; Background
    append draw-block compose [
        fill-pen white
        box 0x0 (canvas-size)
    ]

    ; Plot area background
    append draw-block compose [
        fill-pen 250.250.250
        box (plot-area/1) (plot-area/2)
    ]

    ; Grid lines
    x-ticks: make-ticks xr/1 xr/2 6
    y-ticks: make-ticks yr/1 yr/2 6

    append draw-block [pen 230.230.230 line-width 1]
    foreach xt x-ticks [
        pt: scale-point xt yr/1 xr yr plot-area
        append draw-block compose [line (as-pair pt/x plot-area/1/y) (as-pair pt/x plot-area/2/y)]
    ]
    foreach yt y-ticks [
        pt: scale-point xr/1 yt xr yr plot-area
        append draw-block compose [line (as-pair plot-area/1/x pt/y) (as-pair plot-area/2/x pt/y)]
    ]

    ; Axes
    append draw-block compose [
        pen black line-width 2
        line (as-pair plot-area/1/x plot-area/2/y) (plot-area/2)           ; x-axis
        line (plot-area/1) (as-pair plot-area/1/x plot-area/2/y)           ; y-axis
    ]

    ; X-axis ticks and labels
    append draw-block [line-width 1]
    foreach xt x-ticks [
        pt: scale-point xt yr/1 xr yr plot-area
        append draw-block compose [
            line (pt) (as-pair pt/x pt/y + cfg/tick-length)
            text (as-pair pt/x - 10 pt/y + 6) (form round/to xt 0.1)
        ]
    ]

    ; Y-axis ticks and labels
    foreach yt y-ticks [
        pt: scale-point xr/1 yt xr yr plot-area
        append draw-block compose [
            line (pt) (as-pair pt/x - cfg/tick-length pt/y)
            text (as-pair 23 pt/y - 8) (form round/to yt 0.1)
        ]
    ]

    ; Title
    if title [
		append draw-block compose [
			pen black
			font (make font! [size: cfg/title-size style: 'bold])
			text (as-pair canvas-size/x / 2 - 50  5) (ttl)
		]		
    ]

    ; Axis labels
    if x-label [
		append draw-block compose [
			font (make font! [size: cfg/title-size style: 'normal])
			text (as-pair canvas-size/x / 2 - 40  canvas-size/y - 20) (xl)		
		]
	]	
    if y-label [
		; Calculate y-label position (centered on y-axis, left side)
		y-label-x: 2  ; distance from left edge
		y-label-y: plot-area/1/y + (plot-area/2/y - plot-area/1/y / 2)  ; vertical center

		; Add rotated y-label to draw-block
		append draw-block compose/deep [
			font (make font! [size: cfg/title-size style: 'normal])
			; Save current transformation state
			push [
				; Move origin to label position, rotate -90°, then draw
				translate (as-pair y-label-x y-label-y)
				rotate -90
				text 0x0 (yl)
			]
		]
    ]	

    ; Data points and line
    append draw-block [pen blue line-width 2]
    points: collect [
        foreach [x y] data [
            keep scale-point x y xr yr plot-area
        ]
    ]
    append draw-block compose [fill-pen off line (points)]

    ; Data point markers
    append draw-block [fill-pen blue]
    foreach pt points [
        append draw-block compose [circle (pt) 3]
    ]

    draw-block
]

;-- Demo: data points [x y x y x y ... ]
demo-data: [0 2.7 1 2.8 2 31.4 3 38.1 4 58.0 5 76.2 6 100.5 7 130.0 8 149.3 9 180.0]

view [
    title "Red Plotting Demo"
    canvas: base 500x400 draw []
    do [
        canvas/draw: make-plot/title/x-label/y-label
            500x400
            demo-data
            "Data Plotting Demo"
            "x"
            "y"
    ]
]
