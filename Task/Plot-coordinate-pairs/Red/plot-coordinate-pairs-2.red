Red [
	title: "Plot Coordinate Pairs"
	author: "hinjolicious"
	resources: "Red Sensei, etc."
	Needs: 'View
]

;-- Configuration
plot-config: object [
	margin: 48x40	; left/bottom margins
	top-margin: 30	; space for title
	right-margin: 15
	tick-length: 5
	font-size: 10
	title-size: 12
	label-size: 10
	scale-size: 8
]

;-- Generate axis ticks and labels
make-ticks: function [min max ticks] [
	collect [
		step: (max - min) / (ticks - 1)
		repeat i ticks [keep min + (step * (i - 1))]
	]
]

;-- Scale data to pixel coordinates
scale-point: function [x y xr yr pa] [ ;x-range y-range plot-area
	pa1x: pa/1/x  pa1y: pa/1/y
	pa2x: pa/2/x  pa2y: pa/2/y
	xr1: xr/1  xr2: xr/2
	yr1: yr/1  yr2: yr/2
	as-pair
		to-integer pa1x + ((x - xr1) / (xr2 - xr1) * (pa2x - pa1x))
		to-integer pa2y - ((y - yr1) / (yr2 - yr1) * (pa2y - pa1y))
]

min-of: func [s [series!] /local m] [m: first s  foreach v s [if v < m [m: v]]  m]
max-of: func [s [series!] /local m] [m: first s  foreach v s [if v > m [m: v]]  m]

;-- Build complete plot
make-plot: func [
	canvas-size [pair!]
	data [block!]
	/title ttl [string!]
	/x-label xl [string!]
	/y-label yl [string!]
	/x-range xr [block!]   ; [min max]
	/y-range yr [block!]
	/x-bands xb ; divide range into bands for a nice tick marks (e.g.: 100 into 10 bands -> 11 tick marks!)
	/y-bands yb
] [
	cfg: plot-config
	
	_lm: cfg/margin/1 ;left margin
	_bm: cfg/margin/2 ;bottom margin
	_tm: cfg/top-margin ;top margin
	_rm: cfg/right-margin ;right margin
	
	_cvx: canvas-size/x
	_cvy: canvas-size/y
	
	; Calculate plot area
	plot-area: reduce [
		as-pair _lm _tm
		as-pair (_cvx - _rm) (_cvy - _bm)
	]
	
	_pw: _cvx - _lm - _rm ;plot area width
	_ph: _cvy - _tm - _bm ;plot area height
	
	; Auto-calculate ranges if not provided
	xs: extract data/1/2 2 ;get all x values
	ys: extract next data/1/2 2 ;get all y values
	unless x-range [xr: reduce [min-of xs max-of xs]]
	unless y-range [yr: reduce [min-of ys max-of ys]]
	
	; Add 5% padding to ranges
	;x-pad: (xr/2 - xr/1) * 0.05
	;y-pad: (yr/2 - yr/1) * 0.05
	;xr: reduce [xr/1 - x-pad  xr/2 + x-pad]
	;yr: reduce [yr/1 - y-pad  yr/2 + y-pad]
	
	blk: copy [] ;drawing block
	
	; Background
	append blk compose [fill-pen white  box 0x0 (canvas-size)]
	
	; Plot area background
	append blk compose [box (plot-area/1) (plot-area/2)]
	
	; Grid lines
	; make tick marks across plotting area
	unless x-bands [xb: 11]
	unless y-bands [yb: 11]
	x-ticks: make-ticks xr/1 xr/2 (xb + 1) ;how many 'band' (ticks = bands + 1)?
	y-ticks: make-ticks yr/1 yr/2 (yb + 1)
	
	append blk [pen 230.230.230 line-width 1] ;grid color
	foreach xt x-ticks [
		pt: scale-point xt yr/1 xr yr plot-area
		append blk compose [line (as-pair pt/x plot-area/1/y) (as-pair pt/x plot-area/2/y)]
	]
	foreach yt y-ticks [
		pt: scale-point xr/1 yt xr yr plot-area
		append blk compose [line (as-pair plot-area/1/x pt/y) (as-pair plot-area/2/x pt/y)]
	]
	
	; Axes
	append blk compose [
		pen black line-width 2
		line (as-pair plot-area/1/x plot-area/2/y) (plot-area/2)		   ; x-axis
		line (plot-area/1) (as-pair plot-area/1/x plot-area/2/y)		   ; y-axis
	]
	
	append blk compose [ ;scale font
		line-width 1
		font (make font! [size: cfg/scale-size style: 'normal])
	]
	
	; X-axis ticks and labels
	foreach xt x-ticks [
		pt: scale-point xt yr/1 xr yr plot-area ;scale points to the available plot area
		_ts: cfg/scale-size ;font size
		_tf: form round/to xt 1
		_tl: length? _tf ;text length
		_tw: _tl * _ts * 0.5 ;text width
		_ypos: pt/y + 5 ;scales position, 3 pixels below tick marks
		append blk compose [
			line (pt) (pt + 0x5) ;draw tick marks
			text
				(as-pair pt/x - _tw ;center scale
					_ypos)
				(_tf)
		]
	]
	
	; Y-axis ticks and labels
	_ysw: 0 ;keep longest scale in this
	y-scales: collect [
		foreach yt y-ticks [
			_ys: form round/to yt 1 ;y scale for each tick marks
			_ysl: length? _ys ;length in chars
			if _ysl > _ysw [_ysw: _ysl] ;find the longest scale
			keep _ys ;keep scales in y-scales
		]
	]
	_ysw: _ysw * cfg/scale-size * 0.6
	_xpos: _lm - _ysw - 5 - 5
	foreach yt y-ticks [
		pt: scale-point xr/1 yt xr yr plot-area
		_ts: cfg/scale-size ;font size
		_tf: form round/to yt 0.1
		_tl: length? _tf ;text length
		_tw: _tl * _ts * 0.5 ;text width		
		append blk compose [
			line (pt) (as-pair pt/x - 5 pt/y) ;tick mark
			text
				(as-pair _lm - 5 - 3 - _tw - 4 ;-4 adjustment
					;_xpos
					pt/y - _ts)
				(_tf) ;form yt) ;round/to yt 0.1)
		]
	]
	
	; Title
	if title [
		; use title length to center text!
		_ts: cfg/title-size ;title font size
		_tl: length? ttl ;title length in characters
		; simple title width calculation in pixels
		_tw: _tl * _ts * 0.5 ;width of each char is about 0.5 size, bold is about 1.2 normal width
		append blk compose [
			pen black
			font (make font! [size: _ts style: 'normal]) ;standard font (arial)
			text
				(as-pair
					canvas-size/x / 2 - (_tw / 2)
					_tm - 3 - _ts - 10) ; -10 adjustment
				(ttl)
		]		
	]
	
	; X axis labels
	if x-label [
		_ts: cfg/label-size ;label font size
		_tl: length? xl ;text length
		_tw: _tl * _ts * 0.5 ;text width
		_ypos: _ypos + 3 + _ts ;add 3px space
		append blk compose [
			;pen is black
			font (make font! [size: _ts style: 'normal])
			text
				(as-pair _lm + (_pw / 2) - (_tw / 2) ;pw is plot area width
					_ypos)
				(xl)	
		]
	]	
	
	; Y axis labels
	if y-label [
		_ts: cfg/label-size ;label font size
		_tl: length? yl ;text length
		_tw: _tl * _ts *  0.5 ;text width
		; Calculate y-label position (centered on y-axis, left side)
		y-label-y: plot-area/1/y + ((plot-area/2/y - plot-area/1/y) / 2 - (_tw / 2))  ; vertical center
		_xpos: _xpos - 3 - _ts - 15

		; Add rotated y-label to blk
		append blk compose/deep [
			font (make font! [size: cfg/font-size style: 'normal])
			; Save current transformation state
			push [
				; Move origin to label position, rotate -90°, then draw
				translate
					(as-pair
						_xpos
						_tm + (_ph / 2) + (_tw / 2))
				rotate -90
				text 0x0 (yl)
			]
		]
	]	
	
	; Plot data
	foreach pl data [
		pinfo: pl/1 ;plot info part
		pdata: pl/2 ;plot data part
		
		ptyp: pinfo/1 ;plot type
		pleg: pinfo/2 ;legend
		pcol: pinfo/3 ;color
		pdot: pinfo/4 ;dot type
		pthk: pinfo/5 ;thickness
		pfit: pinfo/6 ;do polynomial fitting?
		
		case [
			ptyp = 'scatter [
				; Scale data points
				points: collect [
					foreach [x y] pdata [keep scale-point x y xr yr plot-area]
				]
				; Draw markers
				append blk compose [pen (pcol) line-width (pthk) fill-pen (pcol)]
				foreach pt points [
					mrk: marker pdot pt
					append blk compose [(mrk)]
				]
			]
			ptyp = 'line [
				; Scale data points
				points: collect [
					foreach [x y] pdata [keep scale-point x y xr yr plot-area]
				]
				; Draw line
				append blk compose [pen (pcol) line-width (pthk) fill-pen off line (points)]
			]			
			ptyp = 'histogram [
				; Scale data points
				points: collect [
					foreach [x y] pdata [keep scale-point x y xr yr plot-area]
				]
				; Draw histogram
				_hw: (points/2/x - points/1/x) * pthk / 2 ; pthk = bar thickness (1=full, 0.5=half, etc.)
				append blk compose [pen (pcol) line-width 0 fill-pen (pcol)]
				foreach pt points [
					_br: make pair! reduce [_hw (canvas-size/y - _bm - pt/y - 1)]
					_tr: make pair! reduce [_hw 0]
					append blk compose [
						box (pt - _tr) (pt + _br)
					]
				]
			]
		]
	]
	
	; Legends
	
	;find the longest legend, assumed all have legend
	_llen: 0
	foreach pl data [
		_leg: length? pl/1/2 ;legend
		if _leg > _llen [_llen: _leg]
	]
	_lnum: length? data
	_lheight: _lnum * cfg/scale-size * 1.5
	
	;draw a semi-transparent box for the Legends
	_ltl: as-pair _lm + 8 _tm + 8
	_lbr: as-pair
			_ltl/x + (_llen * cfg/scale-size * 0.7) + 12
			_ltl/y + _lheight + 12
	append blk compose/deep [
		;push [
			pen 200.200.200 line-width 1 fill-pen 255.255.255.80
			box (_ltl) (_lbr)
		;]
	]
	
	pt: as-pair _lm + 15 _tm + 15
	foreach pl data [
		pinfo: pl/1
		pdata: pl/2
		ptyp: pinfo/1 ;plot type
		pleg: pinfo/2 ;legend
		pcol: pinfo/3 ;color
		pdot: pinfo/4 ;dot type
		pthk: pinfo/5 ;thickness
		case [
			ptyp = 'scatter [
				mrk: marker pdot pt
				append blk compose [
					pen (pcol) line-width (pthk) fill-pen (pcol)
					(mrk)
				]
			]
			ptyp = 'line [
				append blk compose [
					pen (pcol) line-width (pthk) fill-pen off
					line (pt + -5x0) (pt + 5x0)
				]
			]
			ptyp = 'histogram [
				append blk compose [
					pen (pcol) line-width 0 fill-pen (pcol)
					box (pt - 5) (pt + 5)
				]
			]
		]
		_ts: cfg/scale-size
		append blk compose [
			pen black
			font (make font! [size: _ts style: 'normal])
			text (pt + 15x-8) (pleg)		
		]
		pt: pt + 0x12
	]
	
	blk
]

marker: func [m p /local b][
	b: copy [] ;drawing block
	b: case [
		m = 'dot [[circle (p) 3]]
		m = 'box [[box (p - 3) (p + 3)]]
		m = 'triangle 		[[polygon (pt - 0x3) (pt + -3x3) (pt + 3)]]
		m = 'triangle-down  [[polygon (pt + 0x3) (pt + 3x-3) (pt - 3)]]
		m = 'triangle-left  [[polygon (pt - 3x0) (pt + 3x-3) (pt + 3)]]
		m = 'triangle-right [[polygon (pt + 3x0) (pt + -3x3) (pt - 3)]]
		m = 'cross [[line (pt - 3)    (pt + 3)   line (pt + 3x-3) (pt + -3x3)]]
		m = 'plus  [[line (pt + -4x0) (pt + 4x0) line (pt + 0x-4) (pt + 0x4)]]
	]
	compose b
]

regression: function [
    "Fit a quadratic y = a + bx + cx^2 to data points via least squares. Prints coefficients and residuals."
    xa [block! vector!] "Block of x values"
    ya [block! vector!] "Block of y values; must match length of xa"
][
    n: length? xa
    ;; accumulate raw moment sums
    xm: ym: x2m: x3m: x4m: xym: x2ym: 0.0

    repeat i n [
        xi: xa/:i
        yi: ya/:i
        xm:   xm   +  xi
        ym:   ym   +  yi
        x2m:  x2m  + (xi * xi)
        x3m:  x3m  + (xi * xi * xi)
        x4m:  x4m  + (xi * xi * xi * xi)
        xym:  xym  + (xi * yi)
        x2ym: x2ym + (xi * xi * yi)
    ]

    ;; convert sums to means
    xm:   xm   / n
    ym:   ym   / n
    x2m:  x2m  / n
    x3m:  x3m  / n
    x4m:  x4m  / n
    xym:  xym  / n
    x2ym: x2ym / n

    ;; central moments (variance/covariance terms)
    sxx:   x2m  - (xm  * xm)
    sxy:   xym  - (xm  * ym)
    sxx2:  x3m  - (xm  * x2m)
    sx2x2: x4m  - (x2m * x2m)
    sx2y:  x2ym - (x2m * ym)

    ;; solve 3x3 normal equations for a, b, c
    denom:  sxx  * sx2x2 - (sxx2 * sxx2)
        b: (sxy  * sx2x2 - (sx2y * sxx2)) / denom
        a: (sx2y * sxx   - (sxy  * sxx2)) / denom
        c: ym - (b * xm) - (a * x2m)

	reduce [a b c] ; return polynomial coefficients
]

make-poly: func [a b c /local bd][
	;bd: copy/deep [a * (x ** 2) + (b * x) + c]
	bd: [a * (x ** 2) + (b * x) + c]
	bd/1: a
	bd/5/1: b
	bd/7: c
	func [x] bd
]

plotter: func [
	canvas-size [pair!]
	data [block!]
	/title ttl [string!]
	/x-label xl [string!]
	/y-label yl [string!]
	/x-range xr [block!]   ; [min max]
	/y-range yr [block!]
	/x-bands xb ; divide range into bands for tick marks
	/y-bands yb
] [
	while [not tail? data] [
		d: data/1
		if d/1/6 = 'fit [
			insert/only next data fitting d
		]
		data: next data
	]
	data: head data
	;forall data [?? data/1]	
	make-plot/:title/:x-label/:y-label/:x-range/:y-range/:x-bands/:y-bands
		canvas-size data ttl xl yl xr yr xb yb
]

fitting: func [pl /local xa ya coef fx d][
	xa: copy []  ya: copy []
	foreach [x y] pl/2 [append xa x  append ya y]
	coef: regression xa ya
	f: make-poly coef/1 coef/2 coef/3
	d: collect [ foreach [x y] pl/2 [keep compose [(x) (f x)]] ]
	compose/deep [
		;[line (rejoin [pl/1/2 " regression"]) (pl/1/3) none 1] [(d)]
		[line
			(rejoin [pl/1/2 " (regression)"])	;legend
			(pl/1/7)	;color
			none 		;not used
			(pl/1/8)]	;line thickness
		[(d)]
	]
]

demo-data: [
[[scatter "shell-ones" red dot 1 fit red 1] [10000 0.16511957206281214 20000 0.3572878716910904 30000 0.5320250725888274 40000 0.7655192719897378 50000 0.9553357720847959 60000 1.1439470720837674 70000 1.4348725718140378 80000 1.637107172147238 90000 1.8476706721386762 100000 2.065834672545649]]
[[scatter "shell-sorted" green dot 1 fit green 1] [10000 0.16830757309951333 20000 0.3570521720935939 30000 0.5353163721812715 40000 0.7643441723656402 50000 0.958780872239027 60000 1.14989767240514 70000 1.4392241724451673 80000 1.644214571672504 90000 1.8386434724375533 100000 2.042435072919519]]
[[scatter "shell-rand" blue dot 1 fit blue 1] [10000 0.31186277241363314 20000 0.7217604715314863 30000 1.1776199721130687 40000 1.7255975724965036 50000 2.1917679718299827 60000 2.609641072418026 70000 3.222741573137435 80000 3.920287671537678 90000 4.225132471724803 100000 4.945996272400788]]
[[scatter "radix-ones" red box 1 fit red 1] [10000 0.016804873089027884 20000 0.03508427196387946 30000 0.052853871975730424 40000 0.06666487219025173 50000 0.1063878726423487 60000 0.10924907261747001 70000 0.13587987190755646 80000 0.15243057194403678 90000 0.1673975719853314 100000 0.19845677328742217]]
[[scatter "radix-sorted" green box 1 fit green 1] [10000 0.07020087216043676 20000 0.1742907716004907 30000 0.25017167203295565 40000 0.3531174725673362 50000 0.4226868715100676 60000 0.5148484729034887 70000 0.5981659722378094 80000 0.6853935722061916 90000 0.766636872419443 100000 1.0419052711771426]]
[[scatter "radix-rand" blue box 1 fit blue 1] [10000 0.06610547206008272 20000 0.17828877236178026 30000 0.24113337272542779 40000 0.3399406719337204 50000 0.42203237264529847 60000 0.5031664722650709 70000 0.5994240720646605 80000 0.6824697727104952 90000 0.7645638720904627 100000 0.8635532721362791]]
[[scatter "quick-ones" red cross 1 fit red 1] [10000 0.14600687242055935 20000 0.30385407160369937 30000 0.4399430727408737 40000 0.6445435722984619 50000 0.8014172716407929 60000 0.9270207719959723 70000 1.224472171640374 80000 1.3565827717139982 90000 1.4997494720151447 100000 1.681929672662928]]
[[scatter "quick-sorted" green cross 1 fit green 1] [10000 0.10044727248213793 20000 0.20974787211359325 30000 0.3209921725917652 40000 0.439726273121458 50000 0.5509456724120079 60000 0.6749788728008446 70000 0.7829552729802297 80000 0.8951383728460998 90000 1.023434072205749 100000 1.1425471720944047]]
[[scatter "quick-rand" blue cross 1 fit blue 1] [10000 0.14037627190870386 20000 0.2907157717848148 30000 0.44994187188606183 40000 0.6174729717930928 50000 0.7967219727103879 60000 0.9509653725876088 70000 1.140058172307566 80000 1.29363437194163 90000 1.4449119725139852 100000 1.620031972622915]]
]

view [
	title "Compare Sorting Performance"
	canvas: base 500x500 draw []
	do [
		canvas/draw: plotter/title/x-label/y-label/y-range/x-bands/y-bands
			500x500
			demo-data
			"Compare Sorting Performance" ;title
			"Items" ;x label
			"Seconds" ;y label
			;[-1 11] ;x range
			[0 5] ;y range
			9
			10
	]
]
