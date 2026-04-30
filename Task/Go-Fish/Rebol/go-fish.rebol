Rebol [
    title: "Rosetta code: Go Fish"
    file:  %Go_fish.r3
    url:   https://rosettacode.org/wiki/Go_Fish
]

go-fish-game: function/with [
    "Play a game of Go Fish"
][
    deck: fisher-yates-shuffle copy ordered-deck
    clear ai-hand  clear ai-book-list  clear ai-guess
    clear my-hand  clear my-book-list
    ai-books: my-books: 0
    deal-cards/ai 9 ai-hand
    deal-cards    9 my-hand
    message: clear ""
    draw-screen
    while [ai-books + my-books < 13][
        computer-turn
        if ai-books + my-books < 13 [player-turn]
    ]
    clear-screen
    draw-screen
    print ""
    print as-yellow "GAME OVER"
    print ["^/Computer books:" as-red   pad ai-books -3
           "^/Player   books:" as-green pad my-books -3]
][
    ;; Build deck
    ordered-deck: []
    foreach r ranks: "A23456789TJQK" [
        foreach s "♣♦♥♠" [
            append ordered-deck ajoin [r s]
        ]
    ]
    ;; Charsets used to filter key inputs
    player-card-keys: charset join ranks "x"
    player-yes-no:    charset "ynx"

    ;; Game states
    ai-hand: [] ai-book-list: [] ai-guess: []
    my-hand: [] my-book-list: []
    deck: []
    ai-books: my-books: 0


    message:       ""

    ;; Shuffle function
    fisher-yates-shuffle: func [list [block!] /local len j] [
        len: length? list
        repeat i len [
            j: i + random (len - i)
            swap at list i at list j
        ]
        list
    ]
    ;; Cards sorting
    rank-modifiers: #[
        #"A" 130 #"K" 120 #"Q" 110 #"J" 100 #"T" 90
        #"9" 80  #"8" 70  #"7" 60  #"6" 50  #"5" 40
        #"4" 30  #"3" 20  #"2" 10
    ]
    card-rank: func [card] [rank-modifiers/(card/1)]
    sort-hand: func [hand] [
        sort/compare hand func [a b] [
            (card-rank a) < (card-rank b)
        ]
    ]
    ;; Screen output
    clear-screen: does [prin "^[[2J^[[H"]
    draw-screen: does [
        clear-screen
        ;; title bar
        print as-yellow "=================================="
        print as-yellow "          G O   F I S H          "
        print as-yellow "=================================="
        print ""
        ;; deck count
        print ajoin [as-cyan "  Deck: " length? deck " cards remaining"]
        print ""
        ;; books lines
        print ajoin [as-red   "  Computer books: " pad ai-books -2 " [ " ai-book-list " ]"]
        print ajoin [as-green "  Your     books: " pad my-books -2 " [ " my-book-list " ]"]
        print as-yellow "----------------------------------"
        print ""
        ;; my hand
        print [as-cyan "Your hand:" as-yellow sort-hand my-hand]
        print ""
        ;; last message
        unless empty? message [ print message ]
        print as-yellow "----------------------------------"
    ]
    status: func[txt][
        if block? txt [txt: ajoin txt]
        append append message txt LF
    ]
    ;; Game functions
    deal-cards: function [num hand /ai] [
        new: take/part deck num
        unless ai [
            status ["You draw new card" if num > 1 ["s"] ": " new]
        ]
        append hand new
    ]
    find-in: func [hand kind [char!]] [
        forall hand [
            if hand/1/1 = kind [return kind]
        ]
        none
    ]
    guess-from: function [hand guessed] [
        kind: first random/only exclude hand guessed
        append guessed kind
        kind
    ]
    check-for-books: func [hand /ai /local kind n count] [
        if empty? hand [exit]
        sort hand
        kind: hand/1/1  n: count: 0
        while [not tail? hand][
            either kind = hand/1/1 [
                n: n + 1
                if n = 4 [
                    remove/part next hand -4
                    ++ count
                    append either ai [ai-book-list][my-book-list] kind
                    if tail? hand [break]
                    kind: hand/1/1  n: 0
                    continue
                ]
            ][
                kind: hand/1/1
                n: 1
            ]
            ++ hand
        ]
        either ai [
            ai-books: ai-books + count
        ][  my-books: my-books + count]
        if count > 0 [
            status ["New " as-green count " book" if count > 1 "s" " collected!"]
        ]
        count
    ]
    transfer-cards: func [
        ;; Move all cards of a given rank from src to trg
        src [block!] trg [block!] kind [char!]
    ][
        while [not tail? src] [
            either kind = src/1/1 [append trg take src][++ src]
        ]
    ]
    computer-turn: func [/local kind a] [
        forever [
            if empty? ai-hand [
                if empty? deck [exit]
                deal-cards/ai 3 ai-hand
            ]
            ai-guess: unique ai-guess
            kind: guess-from ai-hand ai-guess
            draw-screen
            print as-red {  -------------------^/  -  COMPUTER TURN  -^/  -------------------}
            clear message
            prin ajoin ["  Do you have any " as-green kind "s? "]
            a: wait-for-key/only player-yes-no
            if any [none? a a = #"x"][ halt ]
            either a = #"y" [
                transfer-cards my-hand ai-hand kind
                status ["Computer took your " as-green kind "s!"]
                check-for-books/ai ai-hand
                draw-screen
            ][
                status ["Go Fish! Computer draws a card."]
                deal-cards/ai 1 ai-hand
                check-for-books/ai ai-hand
                draw-screen
                exit
            ]
        ]
    ]

    player-turn: func [/local kind n] [
        forever [
            if empty? my-hand [
                if empty? deck [exit]
                deal-cards 3 my-hand
            ]
            draw-screen
            print as-green {  -------------------^/  -   PLAYER TURN   -^/  -------------------}
            clear message
            prin "  Your guess: "
            kind: wait-for-key/only player-card-keys
            if any [none? kind kind = #"x"][ halt ]
            kind: uppercase kind
            unless find-in my-hand kind [
                status as-red "You must hold that rank to ask for it!"
                draw-screen
                exit
            ]
            either find-in ai-hand kind [
                transfer-cards ai-hand my-hand kind
                status ["You took the computer's " as-green kind "s!"]
                check-for-books my-hand
                draw-screen
            ][
                status ["Computer don't have any " as-green kind "s!"]
                deal-cards 1 my-hand
                check-for-books my-hand
                draw-screen
                exit
            ]
        ]
    ]
]
;--- Main ---
go-fish-game
