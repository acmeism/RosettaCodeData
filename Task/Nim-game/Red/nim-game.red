Red [
    date: 2021-10-24
    version: 0.6.4
    summary: "Demonstrate the game of Nim in Red for Rosetta Code"
]

take-tokens: function [
    "Ask the user to take between 1 and 3 tokens."
][
    forever [
        n: trim ask "Would you like to take 1, 2, or 3 tokens (q to quit)? "
        if n = "q" [quit]
        n: try [to-integer n]
        case [
            not integer? n [print "Please enter an integer."]
            any [n < 1 n > 3] [print "Please enter a number between 1 and 3."]
            true [return n]
        ]
    ]
]

tokens: 12
while [tokens > 0][
    print ["There are" tokens "tokens remaining."]
    n: take-tokens
    print ["You took" n "tokens."]
    tokens: tokens - n
    print ["Computer takes" 4 - n "tokens."]
    tokens: subtract tokens subtract 4 n
]
print "Computer wins!"
