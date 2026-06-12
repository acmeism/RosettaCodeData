Red [
    title: "Perceptron"
    author: "hinjolicious"
	resources: "P5js code from Open-Processing, Gemini AI, Nature of Code, etc."
    needs: 'view
]

; == parameters

width: 400
height: 400

f: func [x][0.5 * x - 0.2] ; line function
learning-rate: 0.001

; == helper functions

sign: func [n][either n >= 0 [1][-1]]

map: func [v a1 z1 a2 z2 /local r][
    r: (v - a1) / (z1 - a1)
    a2 + (r * (z2 - a2))
]

new: func [obj args][ ; make new object and call the init!
	inst: make obj []
	if in inst 'init [
		apply :inst/init args
	]
	inst
]

; == objects

PERCEPTRON: make object! [
    weights: copy []
	
    init: func [n][
        weights: collect [loop n [keep (random 2.0) - 1.0]]
    ]

    guess: func [inputs [block!] /local sum][
        sum: 0.0
        repeat i (length? inputs) [
            ; Fixed: Added parentheses to prevent left-to-right evaluation bugs
            sum: sum + (inputs/(i) * weights/(i))
        ]
        sign sum
    ]

    guess-y: func [x /local w0 w1 w2][
        w0: weights/1
        w1: weights/2
        w2: weights/3
        if w1 = 0 [w1: 0.00001] ; Prevent structural division-by-zero errors
        (negate (w0 / w1) * x) - (w2 / w1)
    ]

    train: func [inputs target /local error][
        error: target - guess inputs
        repeat i length? weights [
            weights/(i): weights/(i) + (error * inputs/(i) * learning-rate)
        ]
    ]
]

POINT: make object! [
    x: 0.0  y: 0.0  bias: 1.0  label: 0

    init: func [x_ y_][
        x: x_
        y: y_
        label: either y > (f x) [1][-1]
    ]

    pixel-x: func [][map x -1.0 1.0 0.0 (to-float width)]
    pixel-y: func [][map y -1.0 1.0 (to-float height) 0.0]

    show: func [/local pxy fil][
        pxy: as-pair to-integer pixel-x to-integer pixel-y
        fil: either label = 1 [white][black]
        append blk compose [fill-pen (fil) circle (pxy) 5]
    ]
]

; == Setup

points: collect [loop 200 [keep new POINT [(random 2.0) - 1.0  (random 2.0) - 1.0]]]
brain: new PERCEPTRON [3]

blk: copy [] ; drawing block

; == Drawing loop

update: does [
    clear blk
	append blk [pen off]

    ; 1. Draw background dots
    foreach pt points [pt/show]

    ; 2. Draw Target Line (RED)
    p1: new POINT [-1.0 (f -1.0)]
    p2: new POINT [ 1.0 (f  1.0)]
    pt1: as-pair p1/pixel-x p1/pixel-y
    pt2: as-pair p2/pixel-x p2/pixel-y
    append blk compose [line-width 3 pen red line (pt1) (pt2)]

    ; 3. Draw Guess Line (BLUE)
    p3: new POINT [-1.0 (brain/guess-y -1.0)]
    p4: new POINT [ 1.0 (brain/guess-y  1.0)]
    pt3: as-pair p3/pixel-x p3/pixel-y
    pt4: as-pair p4/pixel-x p4/pixel-y
    append blk compose [line-width 2 pen blue line (pt3) (pt4)]

    ; 4. Train the brain
    foreach pt points [
        brain/train reduce [pt/x pt/y pt/bias] pt/label
    ]

    ; 5. Accuracy checks AND count total mistakes
    wrong-guesses: 0
    foreach pt points [
        guess-result: brain/guess reduce [pt/x pt/y pt/bias]
        either guess-result = pt/label [
            fil: green
        ][
            fil: red
            wrong-guesses: wrong-guesses + 1 ; Found a mistake!
        ]
        pxy: as-pair pt/pixel-x pt/pixel-y
        append blk compose [pen off fill-pen (fil) circle (pxy) 3]
    ]

    ; 6. Evaluation Check: Did we reach perfection?
	if wrong-guesses = 0 [
		canv/rate: none
		show canv
		alert "Convergence Reached!"
	]
]

; == Start

view/tight compose [
    title "Perceptron"
    canv: base (as-pair width height)
	draw blk
    rate 60 on-time [update]
]
