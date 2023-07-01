Red [
    Title: "24 Game"
    Author: "gltewalt"
]

op: charset "*/+-"
term: [opt "(" num opt ")"]
valid-expression: [term op term op term op term]

explode: func [val][
    extract/into val 1 c: copy []
]

check-expression: does [
    if "q" = e: ask "Enter expression: " [halt]
    either parse trim/all e valid-expression [
        either 24 = m: math to-block form explode e [
            print ["You got it!" m]
        ][
            print ["Not quite correct. That's" m]]
    ][
        print "Invalid expression."
    ]
]

main: does [
    numbers: collect [loop 4 [keep random 9]]
    num: charset form numbers
    print [newline "Using the following numbers, enter an expression that equals 24: (pmdas)" numbers]
    if none? attempt [check-expression][print "Invalid expression."]
]

forever [main]
