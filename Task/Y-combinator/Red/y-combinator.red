Red [
	Title: "Y-Combinator in Red"
	Author: "hinjolicious"
	Purpose: "To show how a "Y-Combinator" function could be be implemented in Red"
	Notes: {This code actually implemented the Z-Combinator, a work-around to allow this method run in
			an strict language, as most other languages, including Red.
		}
	Credits: "Red/Sensei"
]

; Red didn't have(as of now) a proper 'closure', so we have to implement one:
; (this is still not a perfect one, though)

closure: func [vars spec body /local ctx pairs][
    ;; Step 1: Build a list of [word none word none ...] for the object skeleton
    pairs: copy []
    foreach [w v] vars [append pairs reduce [to set-word! w none]]

    ;; Step 2: Create object with empty slots (no evaluation traps)
    ctx: make object! pairs

    ;; Step 3: Stuff values in directly, bypassing evaluation
    foreach [w v] vars [set in ctx w :v]

    ;; Step 4: Bind the body and wrap in a function
    func spec bind body ctx
]

; The Y-Combinator for strict language:

Z: func [g][
    wrap: closure reduce ['g :g] [x][
        g closure reduce ['x :x] [v][	;-- the [v] wrapper IS the delay!
            inner-fn: x :x          	;-- call x with x, get back the lambda
            inner-fn v              	;-- apply it to v
        ]
    ]
    wrap :wrap
]

; Creating factorial function:

fact*: func [h][
    closure reduce ['h :h] [n][
        either n <= 1 [1][n * h n - 1]
    ]
]

fact: Z :fact*

print "Factorial:"
repeat i 10 [print fact i]


; Creating Fibonacci function:

fibo*: func [h][
	closure reduce ['h :h][n][
		either n < 2 [1][
			(h n - 1) + (h n - 2)
		]
	]
]

fibo: Z :fibo*

print "Fibonacci:"
repeat i 10 [print fibo i]
