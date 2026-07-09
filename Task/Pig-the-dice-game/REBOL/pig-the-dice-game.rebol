Rebol [
    title: "Rosetta code: Pig the dice game"
    file:  %Pig_the_dice_game.r3
    url:   https://rosettacode.org/wiki/Pig_the_dice_game
]

pig-dice-game: function [
    "Play a two-or-more player game of Pig dice"
    players   [integer!] "Number of players"
    max-score [integer!] "Score needed to win"
][
    safe-score: array/initial players 0   ;; banked scores per player
    score:  0                             ;; current turn's unbanked score
    player: 1                             ;; current player

    forever [
        print ajoin ["Player " player ": (" safe-score/:player ", " score ") Rolling? (Y)"]
        switch/default wait-key [
            #"y" [                        ;; roll
                rolled: random 6
                print ["  Rolled" rolled]
                either rolled = 1 [
                    print [
                        "  Bust! you lose" score
                        "but still keep your previous" safe-score/:player
                        newline
                    ]
                    score:  0             ;; lose turn score
                    player: player % players + 1
                ][
                    score: score + rolled ;; accumulate
                ]
            ]
            #"n" space [                  ;; bank and pass
                safe-score/:player: safe-score/:player + score
                if safe-score/:player >= max-score [break]
                print ["  Sticking with" safe-score/:player newline]
                score:  0
                player: player % players + 1
            ]
        ][
            print "Game interupted!"      ;; any other key quits
            exit
        ]
    ]
    print ["^/Player" player "wins with a score of" safe-score/:player]
]

pig-dice-game 2 20
