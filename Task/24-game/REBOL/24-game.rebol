Rebol [
    title: "Rosetta code: 24 game"
    file: %24_game.r3
    url: https://rosettacode.org/wiki/24_game
    needs: 3.10.0 ; or something like that (ajoin/with)
]
game-24: function/with [
    /seed val
][
    random/seed any [val now/precise]
    valid: copy/part random digits 4
    prin  "Using the following numbers, enter an expression that equals 24: "
    print [valid/1 ", " valid/2 ", " valid/3 " and " valid/4]
    print "Evaluation from left to right with no precedence, unless you use parenthesis."
    sort valid

    sucess: false

    while [not sucess] [
        guess: ask "Enter your expression: "
        if guess = "q" [halt]
        numbers: sort copy guess
        numbers: take/part find numbers digit 4
        either all [
            valid = numbers
            parse guess [some chars end]
            integer? result: try load ajoin/with split guess 1 #" "
        ][
            print ["The result of your expression is: " result]
            if result = 24 [sucess: true]
        ][
            print "Something is wrong with the expression, try again."
        ]
    ]
    print "You got it right!"
][
    valid: guess: none
    digits: "123456789"
    digit:   charset digits
    chars:   union digit charset "+-*/()"
]

game-24/seed 1
