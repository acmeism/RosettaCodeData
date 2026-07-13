Rebol [
    title: "Rosetta code: Flipping bits game"
    file:  %Flipping_bits_game.r3
    url:   https://rosettacode.org/wiki/Flipping_bits_game
]

random/seed now/time/precise               ;; seed RNG

flipping-bits: function/with [
    "Flipping bits game"
    size [pair!] "Board size"
][
    init size
    ;;--- main loop -----------------------------------------------------
    target: copy/deep board                ;; save target
    random kValid
    repeat pos 3 [flip pick kValid pos]    ;; scramble 3 moves

    run: -1
    forever [
        ++ run
        prin "^[[2J^[[H"
        print as-green "TARGET       BOARD"
        print [header "  " header]
        repeat row kRows [
            b1: append clear "" row
            b2: append clear "" row
            repeat col kCols [
                append b1 ajoin [SP target/:row/:col]
                append b2 ajoin [SP  board/:row/:col]
            ]
            print [b1 "  " b2]
        ]
        if board = target [
            print as-green "^/BINGO!"
            print ["You solved it in" as-green run "move(s)!"]
            halt
        ]
        print ["^/Moves:" as-green run]
        until [
            prin "^MEnter row number or column letter: "
            prin inp: wait-key
            unless char? inp [exit]
            find kValid inp: uppercase inp
        ]
        flip inp
    ]
][
    board: target: header: kValid: _ kCols: kRows: 3
    init: func [size /local letter] [
        kRows: max 3 min 9 to integer! size/x
        kCols: max 3 min 9 to integer! size/y
        board: array/initial 10 []             ;; build kRows empty rows
        kValid: copy "1A"                      ;; validation chars e.g. "321ABC"
        loop (kRows - 1) [insert kValid (first kValid) + 1]
        loop (kCols - 1) [append kValid (last  kValid) + 1]

        repeat row kRows [                     ;; fill board with random 0/1
            loop kCols [append board/:row -1 + random 2]
        ]
        letter: #"A" header: copy " "
        loop kCols [append header ajoin [SP letter]  letter: letter + 1]
    ]
    ;;--- helpers -------------------------------------------------------
    xorme: func ['val] [                       ;; flip a board cell in place
        set val 1 xor get val
    ]

    flip: function [what [char!]] [            ;; flip a full row or column
        row: -48 + what
        either row <= kRows [
            repeat col  kCols [xorme board/:row/:col]
        ][  repeat row2 kRows [xorme board/:row2/(row - 16)] ]
    ]
]

flipping-bits 3x3 ;-- Start game!
