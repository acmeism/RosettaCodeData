Rebol [
    title: "Rosetta code: Conway's Game of Life"
    file:  %Conway's_Game_of_Life.r3
    url:   https://rosettacode.org/wiki/Conway%27s_Game_of_Life
    note: "Based on Joe Smith's Red language implementation!"
]
conway: function/with [
    "Conway's Game of Life"
    petri [block!] "Current grid (Petri dish) as a block of rows, each row a block of 0/1"
    /display       "Print the grid"
][
    if display [print-table petri]  ;; optionally render current generation
    new-petri: copy/deep petri      ;; prepare next generation grid
    repeat row length? petri [      ;; iterate rows
        repeat col length? petri [  ;; iterate columns (assumes square grid; adjust if rectangular)
            live-neigh: 0           ;; count of live neighbors
            ;; Accumulate live neighbors using relative offsets; ignore out-of-bounds via try
            foreach cell neigh [
                try [
                    if petri/(:row + cell/1)/(:col + cell/2) = 1 [
                        live-neigh: live-neigh + 1
                    ]
                ]
            ]
            ;; Apply Conway's Game of Life rules
            switch petri/:row/:col [
                1 [  ;; live cell
                    if any [live-neigh < 2 live-neigh > 3] [
                        new-petri/:row/:col: 0   ;; underpopulation or overcrowding -> dies
                    ]
                ]
                0 [  ;; dead cell
                    if live-neigh = 3 [
                        new-petri/:row/:col: 1   ;; reproduction -> becomes alive
                    ]
                ]
            ]
        ]
    ]
    ;; Replace current grid with the newly computed one (in-place update)
    clear insert petri new-petri
][
    ;; Neighbor offsets: N, S, E, W, and four diagonals
    neigh: [[0 1] [0 -1] [1 0] [-1 0] [1 1] [1 -1] [-1 1] [-1 -1]]

    ;; Render a binary grid using buffered terminal output, with simple ANSI escapes
    print-table: function [table] [
        buf: clear ""                            ;; output buffer (reduces flicker)
        append buf "^[[H^[[2J^[[3J^/"            ;; clear screen and home cursor
        foreach row table [
            append buf replace/all (replace/all to-string row "0" "_") "1" "#"
            append buf LF
        ]
        print buf
        wait 0.2                                 ;; small delay for animation pacing
        table
    ]
]

;- DEMO:

*3-3: [ ;; a 3x3 blinker oscillator
    [0 1 0]
    [0 1 0]
    [0 1 0]
]
*8-8: [ ;; an 8x8 glider pattern (top-left)
    [0 0 1 0 0 0 0 0]
    [0 0 0 1 0 0 0 0]
    [0 1 1 1 0 0 0 0]
    [0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0]
]

print "^[[?25l"          ;; hide cursor for animation
loop 10 [ conway/display *3-3 ]   ;; run 10 generations of the blinker
loop 23 [ conway/display *8-8 ]   ;; run 23 generations of the glider
print "^[[?25h"          ;; show cursor after animation
