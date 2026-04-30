Rebol [
    title: "Rosetta code: Nim game"
    file:  %Nim_game.r3
    url:   https://rosettacode.org/wiki/Nim_game
]

nim-game: function/with [
    "Nim (12-token variant) - the computer always wins with perfect play"
][
    tokens: 12
    while [
        print [newline "Tokens remaining:" as-yellow tokens]
        tokens > 0
    ][
        ;; Player's turn - validated input ensures n is 1, 2, or 3
        n: take-tokens
        print ["You took" as-yellow n "tokens."]
        tokens: tokens - n
        ;; Computer's turn - always picks the complement to 4,
        ;; guaranteeing the pile stays on a multiple of 4 after each round
        computer: 4 - n
        print ["Computer takes" as-yellow computer "tokens."]
        tokens: tokens - computer
    ]
    print as-green "Computer wins!"
][
    ;; --- Local helper -------------------------------------------------
    take-tokens: function [][
        forever [
            print "Take 1, 2, or 3 tokens (q to quit)?"
            n: wait-for-key
            if n = #"q" [quit]
            n: n - #"0"
            either any [n < 1  n > 3][
                print as-red "Please enter a number between 1 and 3."
            ][  return n ]
        ]
    ]
]
nim-game
