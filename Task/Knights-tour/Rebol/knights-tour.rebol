Rebol [
    title: "Rosetta code: Knight's tour"
    file: %Knight's_tour.r3
    url: https://rosettacode.org/wiki/Knight%27s_tour
]

knights-tour: function/with [
    board-size [integer!]
][
    ;; Prepare board...
    brd: make block! size: board-size
    loop size [
        row: make block! size
        append/dup row 0 size
        append/only brd row
    ]
    ;; Starting position...
    pos: as-pair random size random size
    brd/(pos/x)/(pos/y): 1

    ;; Found solutions...
    found: solve pos 2

    either found [
        print-brd print ""
    ][  print ["no solutions found:" pos] ]

][
    dirs: [1x2 1x-2 2x1 2x-1 -1x2 -1x-2 -2x-1 -2x1]
    size: brd: pos: none

    cnt-moves: function [m [pair!]] [
        n: 0
        foreach d dirs [
            p: m + d
            rn: p/x
            cn: p/y
            if all [
                rn >= 1 rn <= size
                cn >= 1 cn <= size
                zero? brd/:rn/:cn
            ][
                n: n + 1
            ]
        ]
        n
    ]

    sort-moves: function [movs [block!]] [
        cnt: map-each m movs [cnt-moves m]
        i: 1
        while [i <= ((length? cnt) - 1)] [
            j: i + 1
            while [j <= length? cnt] [
                if cnt/:j < cnt/:i [
                    tmp: cnt/:i  cnt/:i: cnt/:j  cnt/:j: tmp
                    tmp: movs/:i  movs/:i: movs/:j  movs/:j: tmp
                ]
                j: j + 1
            ]
            i: i + 1
        ]
        movs
    ]

    solve: function [pos [pair!] cnt] [
        if cnt > (size * size) [return true]
        movs: make block! 8
        foreach d dirs [
            p: pos + d
            rn: p/x  cn: p/y
            if all [
                rn >= 1 rn <= size
                cn >= 1 cn <= size
                zero? brd/:rn/:cn
            ][
                append movs p
            ]
        ]
        movs: sort-moves movs
        foreach p movs [
            rn: p/x  cn: p/y
            brd/:rn/:cn: cnt
            if solve p cnt + 1 [return true]
            brd/:rn/:cn: 0
        ]
        false
    ]

    print-brd: func [/local fmt] [
        foreach row brd [
            foreach cell row [prin pad cell 4]
            print ""
        ]
    ]
]

knights-tour 8
knights-tour 16
