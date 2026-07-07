Rebol [
    title: "Rosetta code: Sudoku"
    file:  %Sudoku.r3
    url:   https://rosettacode.org/wiki/Sudoku
]

sudoku-solver: context [
    grid: none

    init: func [s [string!]] [
        grid: make vector! [u8! 81]
        repeat i 81 [grid/:i: -48 + s/:i]
    ]

    check-validity: func [val x y /local start-x start-y] [
        repeat i 9 [
            if any [
                grid/(y * 9 + i) = val
                grid/(i * 9 + x) = val
            ] [return false]
        ]
        start-x: (x - 1 // 3) * 3 + 1
        start-y: (y - 1 // 3) * 3 + 1
        for i start-y start-y + 2 1 [
            for j start-x start-x + 2 1 [
                if grid/(i * 9 + j - 9) = val [return false]
            ]
        ]
        true
    ]

    place-number: func [pos [integer!]] [
        if pos > 81 [throw 'finished]
        if grid/:pos > 0 [return place-number pos + 1]
        repeat n 9 [
            if check-validity n (pos - 1 % 9 + 1) (pos - 1 // 9 + 1) [
                grid/:pos: n
                place-number pos + 1
                grid/:pos: 0
            ]
        ]
    ]

    print-grid: func [/local sb] [
        sb: clear ""
        repeat i 9 [
            repeat j 9 [
                append sb rejoin [grid/(i * 9 + j - 9) " "]
                if any [j = 3 j = 6] [append sb "| "]
            ]
            append sb newline
            if any [i = 3 i = 6] [
                append sb "------+-------+------^/"
            ]
        ]
        print sb
    ]

    solve: func [s [string!]] [
        init s
        print as-yellow "Starting grid:^/" print-grid
        print as-yellow "Solution:^/"
        either 'finished = catch [place-number 1] [
            print-grid
        ] [
            print "Unsolvable!"
        ]
    ]
]

sudoku-solver/solve
    "850002400720000009004000000000107002305000900040000000000080070017000000000036040"
