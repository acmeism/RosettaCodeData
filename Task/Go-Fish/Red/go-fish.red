Red [
    Title:  "Go Fish"
    Author: "gltewalt"
]

chand: []   ;-- c and p = computer and player
cguesses: []
phand: []
cbooks: 0
pbooks: 0
gf: {
    ***************
    *   GO FISH   *
    ***************
}
pip: ["a" "2" "3" "4" "5" "6" "7" "8" "9" "10" "j" "q" "k"] ;-- suits are not relevant
pile: []    ;-- where discarded cards go

;---------------------
;  Helper functions  -
;---------------------

clear-screen: does [
    "clears the console"
    call/console either system/platform = 'Linux ["clear"]["cls"]
]

clear-and-show: func [duration str][
    {
        Poor persons animation.
        Blips message to screen after a pause of duration length.

    }
    clear-screen
    print str
    wait duration
    clear-screen
]

deal-cards: func [num hand][
    loop num [
        append hand rejoin [trim/all form take deck]
    ]
]

find-in: func [blk str][
    "Finds a string value in a block. Series in series."
    foreach i blk [if find i str [return i]]
]

go-fish: func [num hand][
    either not empty? deck [
        deal-cards num hand
    ][
        append hand rejoin [trim/all form take pile]    ;-- take from pile if deck is empty
    ]
]

guess-from: func [hand guessed][
    {
        Randomly picks from hand minus guessed.

        Simulates a person asking for different cards on
        their next turn if their previous guess resulted
        in a Go Fish.
    }
    random/seed now/time
    either any [empty? guessed empty? exclude hand guessed][
        random/only hand
    ][
        random/only exclude hand guessed
    ]
]

make-deck: function [] [
    "make-deck and shuffle from https://rosettacode.org/wiki/Playing_cards#Red"
     new-deck: make block! 52
     foreach p pip [loop 4 [append/only new-deck p]]
     return new-deck
]

show-cards: does [
    clear-and-show 0 ""
    print [newline "Player cards:" newline sort phand newline]
    print ["Computer books:" cbooks]
    print ["Player books:" pbooks newline]
]

shuffle: function [deck [block!]] [deck: random deck]

;------------- end of helper functions -----------------

check-for-books: func [
    {
        Checks for a book in a players hand.
        Increments the players book score, and
        discards the book from the players hand
    }
    hand "from or to hand"
    kind "rank of cards"
    /local
        c "collected"
][
    c: collect [
        forall hand [keep find hand/1 kind]
    ]
    remove-each i c [none = i]
    if 4 = length? c [
        either hand = phand [pbooks: pbooks + 1][cbooks: cbooks + 1]
        remove-each i hand [if find/only c i [i]]   ;-- remove book from hand
        forall c [append pile c/1]  ;-- append discarded book to the pile
    ]
]

transfer-cards: func [
    "Transfers cards from player to player"
    fhand "from hand"
    thand "to hand"
    kind "rank of cards"
    /local
        c "collected"
][
    c: collect [forall fhand [keep find fhand/1 kind]]
    remove-each i c [none = i]  ;-- remove none values from collected
    forall c [append thand c/1] ;-- append remaining values to "to hand"
    remove-each i fhand [if find/only c i [i]] ;-- remove those values from "from hand"
]

computer-turn: func [
    fhand "from hand"
    thand "to hand"
    kind  "rank of cards"
    /local
        a
][
    a: ask rejoin ["Do you have any " kind " s? "]
    if a = "x" [halt]
    either any [a = "y" a = "yes"][
        check-for-books thand kind
        transfer-cards fhand thand kind
        show-cards
        computer-turn fhand thand guess-from thand cguesses
    ][
        clear-and-show 0.4 gf
        go-fish 1 thand
        append cguesses kind
    ]
]

player-turn: func [
    fhand "from hand"
    thand "to hand"
    kind  "rank of cards"
    /local
        p
][
    if empty? fhand [go-fish 3 fhand]

    if none? find-in thand kind [   ;-- player has to hold rank asked for
        clear-and-show 1.0
        "You have to have that rank in your hand to ask for it.^/Computers turn..."
        exit
    ]

    either find-in fhand kind [
        check-for-books thand kind
        transfer-cards fhand thand kind
        show-cards
        if find-in thand kind [
            p: ask "Your guess: "
            either p = "x" [halt][player-turn fhand thand p]
            check-for-books thand p
        ]
    ][
        clear-and-show 0.4 gf
        go-fish 1 thand
    ]
]

game-round: has [c p][
    print {
          -------------------
          -  COMPUTER TURN  -
          -------------------
          }

    if empty? chand [  ; computer has no more cards? fish 3 cards.
        go-fish 3 chand
        show-cards
    ]
    computer-turn phand chand c: guess-from chand cguesses
    check-for-books chand c
    show-cards

    print {
          -------------------
          -   PLAYER TURN   -
          -------------------
          }

    if empty? phand [   ;-- player has no more cards? fish 3 cards.
        go-fish 3 phand
        show-cards
    ]
    p: ask "Your guess: "
    either p = "x" [halt][player-turn chand phand find-in phand p]
    check-for-books phand p
    show-cards
]

main: does [
    deck: shuffle make-deck
    deal-cards 9 chand
    deal-cards 9 phand
    show-cards
    while [cbooks + pbooks < 13][
        game-round
    ]
    clear-and-show 0 ""
    print "GAME OVER"
    print [newline "Computer books:" cbooks newline "Player books:" pbooks]
]

main
