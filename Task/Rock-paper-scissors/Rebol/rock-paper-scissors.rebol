Rebol [
    title: "Rosetta code: Rock-paper-scissors"
    file:  %Rock-paper-scissors.r3
    url:   https://rosettacode.org/wiki/Rock-paper-scissors
]

rock-paper-scissors: function[
    "Rock-Paper-Scissors game - adaptive AI opponent"
][
    choices: [#"r" rock #"p" paper #"s" scissors]
    prior: "rps" ;; AI's weighted choice pool (starts balanced)

    while [
        print "Choose — rock (r), paper (p), or scissors (s)"
        find choices pl: wait-for-key
    ][
        ;; AI picks from its weighted pool
        ai: random/only prior
        print ["You draws:" as-yellow choices/:pl]
        print [" AI draws:" as-yellow choices/:ai]

        ;; What would beat the player's choice, and what would lose to it
        win:  select "rpsr" pl  ;; beats player
        lose: select "rspr" pl  ;; loses to player
        print ["----------"
            case [
                pl = ai  ["It's a tie!"]
                ai = win [as-red   "You lose."]
                'else    [as-green "You win!"]
        ]]

        ;; Adapt: reward winning moves, penalise losing ones
        append      prior win  ;; add what beats the player (AI prefers it)
        remove find prior lose ;; remove what loses to the player
    ]
]
rock-paper-scissors
