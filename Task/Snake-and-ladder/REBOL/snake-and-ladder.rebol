Rebol [
    title: "Rosetta code: Snake and ladder"
    file:  %Snake_and_ladder.r3
    url:   https://rosettacode.org/wiki/Snake_and_ladder
]

snake-or-ladder: function/with [
    "Play a game of Snakes and Ladders with the given number of players."
    players [integer!] "Number of players (must be > 1)"
][
    assert [players > 1]
    random/seed now/time/precise
    print-hline/width 70
    print as-blue "== SNAKE AND LADDER =="
    repeat i players [positions/:i: 1]  ;; start all players on cell 1

    print "Game is starting...^/"
    player: 1
    forever [
        move-player roll-dice
        if positions/:player = 100 [
            print-hline/width 70
            print ["^/HURRAY, Player" as-green player "wins!!!"]
            break
        ]
        player: (player % players) + 1  ;; advance to next player (wrap around)
    ]
    print "Game ended."
][
    portals: #[    ;; map: landing cell -> destination
         4  14    9  31   20  38   28  84   ;; ladders
        40  59   51  67   63  81   71  91   ;; ladders
        17   7   54  34   62  19   64  60   ;; snakes
        87  24   93  73   95  75   99  78   ;; snakes
    ]
    positions: #[]                  ;; player index -> current cell
    player: 0                       ;; current player index

    roll-dice: does [1 + random 5]  ;; returns 1–6

    move-player: function [dice] [
        cell: positions/:player + dice
        prin [
            "Player" as-green player
            "rolled" as-yellow dice
            "--> Moved to" as-yellow pad cell 4
        ]
        if cell > 100 [             ;; overshoot: bounce back from 100
            cell: 100 - (cell - 100)
            prin [as-red "BUMPED to" as-yellow cell ""]
        ]
        positions/:player: either portal: portals/:cell [
            print either/only portal > cell [
                as-green "Climbed a LADDER to" as-yellow portal  ;; ladder up
            ][  as-red "A SNAKE carried to"    as-yellow portal] ;; snake down
            portal
        ][  print "" cell ]         ;; plain move, no portal
    ]
]

snake-or-ladder 2 ;- Start a game
