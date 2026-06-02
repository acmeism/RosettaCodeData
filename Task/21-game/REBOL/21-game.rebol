Rebol [
    title: "Rosetta code: 21 game"
    file:  %21_game.r3
    url:   https://rosettacode.org/wiki/21_game
]

game-21: function[][
    total: 0
    human?: true
    while [total <> 21][
        either human? [
            n: ask "Enter a number between 1 and 3 (CTRL+C to quit): "
            if none? n [quit]
            unless parse n [#"1" | #"2" | #"3"][ continue ]
            n: to integer! n
        ][  ;computer
            if 3 < n: 21 - total [ n: random 3 ]
            print ["Computer picks:" as-yellow n]
        ]
        total: total + n
        print ["Total:" as-green total]
        human?: not human?
    ]
    print as-green pick ["Computer wins!" "You win!"] human?
]
game-21
