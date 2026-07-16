Rebol [
    title: "Rosetta code: Solve a Hidato puzzle"
    file:  %Solve_a_Hidato_puzzle.r3
    url:   https://rosettacode.org/wiki/Solve_a_Hidato_puzzle
]

solve-hidato: function/with [
    "Solve and print a Hidato puzzle from a multiline string"
    puzzle [string!]
][
    setup puzzle
    print-board
    either solve start/1 start/2 1 1 [
        print as-yellow "Solved:"
        print-board
    ][  print as-red "No solution found!" ]
    board
][
    board: copy []  ;; 2D block of rows; 0=free, none=wall, N=given
    given: copy []  ;; sorted list of pre-filled numbers
    start: none     ;; [row col] of the cell containing 1
    digit: charset [#"0" - #"9"]

    setup: func [
        "Parse puzzle string into board, given, and start position"
        puzzle [string!]
        /local r c n row
    ][
        clear board
        clear given
        start: none
        r: 1
        parse puzzle [
            opt CR opt LF
            some [
                (c: 0 row: copy [])
                some [
                    (++ c)
                      "__" opt SP (append row 0)          ;; free cell
                    | " ." opt SP (append row _)          ;; wall/gap
                    | opt SP  copy n: 1 2 digit opt SP (  ;; given number
                        append row n: to integer! n
                        append given n
                        if n = 1 [ start: reduce [r c] ]
                    )
                ]
                [opt CR LF | end] (
                    append/only board row
                    ++ r
                )
            ]
        ]
        sort given
    ]

    solve: function/extern [
        "Recursively place n at (r,c) and search all 8 neighbors for n+1"
        r [integer!] c [integer!]
        n [integer!]    ;; value to place at current cell
        next [integer!] ;; index into given[] for next expected fixed value
    ][
        if n > last given [ return true ]   ;; all numbers placed
        if any [
            none? row: board/:r             ;; out of bounds row
            none? val: row/:c               ;; wall cell
            all [val > 0  val != n]         ;; conflicts with a different given
            all [val = 0  given/:next = n]  ;; n is a given but cell is free
        ][  return false ]

        back: 0
        if val = n [        ;; landing on the correct given cell
            next: next + 1
            back: n         ;; remember to restore if we backtrack
        ]
        row/:c: n
        for i -1 1 1 [
            for j -1 1 1 [
                if solve r + i c + j n + 1 next [
                    return true
                ]
            ]
        ]
        row/:c: back  ;; backtrack
        false
    ][  board ]

    print-board: function [
        "Print the current board state; free cells as __, walls as spaces"
    ][
        buff: clear ""
        foreach row board [
            foreach v row [
                append buff any [
                    select [_ "  " 0 "__"] v
                    pad v -2
                ]
                append buff SP
            ]
            append buff LF
        ]
        print buff
    ]
]

solve-hidato {
__ 33 35 __ __  .  .  .
__ __ 24 22 __  .  .  .
__ __ __ 21 __ __  .  .
__ 26 __ 13 40 11  .  .
27 __ __ __  9 __  1  .
 .  . __ __ 18 __ __  .
 .  .  .  . __  7 __ __
 .  .  .  .  .  .  5 __}
