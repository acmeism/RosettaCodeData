Rebol [
    title: "Rosetta code: Greed"
    file: %Greed.r3
    url: https://rosettacode.org/wiki/Greed
    note: "Translated from PicoLisp version"
]

greed-game: function/with [
    "Greed: consume runs of cells in 8 directions"
    /seed val
][
    if seed [random/seed val]

    cols: 79
    rows: 22
    ;; ANSI color palette (terminal fg codes)
    color-pool: random [31 32 33 35 91 92 93 94 96]

    ;; Build grid
    clear grid
    loop rows * cols [
        n: random 9
        append/only grid make-cell n color-pool/:n
    ]

    ; Pick random start cell
    center: as-pair 1 + random rows 1 + random cols
    set-cell-at grid-get center true

    score: 0

    prin "^[[2J" ;; clear-screen
    display

    forever [
        roads: find-roads
        if empty? roads [ break ] ;; no moves left

        ; flash candidates on/off
        set-road-flags roads true
        set-road-flags roads false

        ; pick a random road
        road: random/only roads
        execute-road road
        display
    ]

    print "^/Game over!"
    score
][
    grid: copy []
    cols: rows: score: center: 0
    ; -- Cell object ----------------------------------------------------------------
    ; Each cell is a block: [n color flag? at?]
    ;   n      : integer 1-9  (cleared cell uses -1)
    ;   color  : ANSI color code integer
    ;   flag   : logic  – candidate highlight
    ;   at     : logic  – current-position marker "@"

    make-cell: func [n color] [ reduce [n color false false] ]

    cell-n:     func [c] [c/1]
    cell-color: func [c] [c/2]
    cell-flag:  func [c] [c/3]
    cell-at:    func [c] [c/4]

    set-cell-n:     func [c v] [c/1: v]
    set-cell-color: func [c v] [c/2: v]
    set-cell-flag:  func [c v] [c/3: v]
    set-cell-at:    func [c v] [c/4: v]

    ; -- Grid access ----------------------------------------------------------------
    grid-get: func [pos [pair!]] [
        pick grid ((pos/x - 1) * COLS) + pos/y
    ]

    ; Neighbour helpers – take and return pair! or none if out of bounds
    bounded: func [p [pair!]] [
        if all [p/x >= 1  p/x <= ROWS  p/y >= 1  p/y <= COLS] [p]
    ]

    dir-west:  func [p [pair!]] [ bounded p +  0x-1 ]
    dir-east:  func [p [pair!]] [ bounded p +  0x1  ]
    dir-north: func [p [pair!]] [ bounded p + -1x0  ]
    dir-south: func [p [pair!]] [ bounded p +  1x0  ]
    dir-nw:    func [p [pair!]] [ bounded p + -1x-1 ]
    dir-ne:    func [p [pair!]] [ bounded p + -1x1  ]
    dir-sw:    func [p [pair!]] [ bounded p +  1x-1 ]
    dir-se:    func [p [pair!]] [ bounded p +  1x1  ]

    directions: reduce [
        :dir-west :dir-east :dir-south :dir-north
        :dir-nw   :dir-ne   :dir-sw    :dir-se
    ]

    display: function [] [
        p: 0
        ;wait 0:00:0.1
        out: append clear "" "^[[H"
        repeat r ROWS [
            repeat c COLS [
                cell: grid-get as-pair r c
                if (cell-n cell) < 0 [ p: p + 1 ]
                color-code: either any [
                    cell-at   cell
                    cell-flag cell
                ] [100] [cell-color cell]
                ch: case [
                    cell-at  cell     ["@"]
                    (cell-n cell) < 0 [" "]
                    true              [form cell-n cell]
                ]
                append out ajoin ["^[[0;" color-code "m" ch "^[[0m"]
            ]
            append out newline
        ]
        append out ajoin [
            "Score:     " score
            "       "
            round/to (p / 1738.0 * 100.0) 0.01
            "%"
        ]
        prin out
    ]

    set-road-flags: function [
        "Walk a road, optionally set flags"
        roads "[steps dir-fn]"
        flag
    ][
        foreach road roads [
            steps:   road/1
            dir-fn: :road/2
            pos: center
            loop steps [
                pos: dir-fn pos
                set-cell-flag grid-get pos flag
            ]
        ]
        display
    ]

    find-roads: function [
        "Find valid roads from center"
    ][
        result: copy []
        foreach dir-fn directions [
            ;; step once to peek at the first cell
            unless pos: dir-fn center [continue]
            cell: grid-get pos
            steps: cell-n cell      ;; run length = value of first cell
            if steps <= 0 [continue]
            pos: center             ;; reset and walk the full run
            ok: true
            loop steps [
                unless pos: dir-fn pos [ ok: false  break ]
                if 0 > cell-n grid-get pos [ ok: false  break ]
            ]
            if ok [ repend/only result [steps :dir-fn] ]
        ]
        result
    ]

    execute-road: func [
        "Execute a road (consume cells, update score, move center)"
        road  /local steps dr pos cell
    ][
        steps:   road/1
        dir-fn: :road/2

        cell: grid-get center
        score: score + cell-n cell
        set-cell-n  cell -1
        set-cell-at cell false

        pos: center
        loop steps [
            pos: dir-fn pos
            cell: grid-get pos
            score: score + cell-n cell
            set-cell-n    cell -1
            set-cell-flag cell false
        ]

        center: pos
        set-cell-at grid-get center  true
    ]
]

; -- Main -----------------------------------------------------------------------
greed-game/seed now
