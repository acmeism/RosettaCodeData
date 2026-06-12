Rebol [
    title: "Rosetta code: Wave function collapse"
    file:  %Wave_function_collapse.r3
    url:   https://rosettacode.org/wiki/Wave_function_collapse
]

wave-function-collapse: function [
    "Generates a tileable output by collapsing a wave of superposed tile states."
    blocks [block!]  "flat tile pixel data: num-tiles * tile-rows * tile-cols"
    tdim   [block!]  "[num-tiles tile-rows tile-cols]"
    target [block!]  "[out-rows out-cols] in tiles"
][
    fill: func [n val] [append/dup make block! n val n]

    out-rows:  target/1
    out-cols:  target/2
    num-cells: out-rows * out-cols  ;; total cells in output grid

    num-tiles: tdim/1
    tile-rows: tdim/2
    tile-cols: tdim/3

    ;; --- adjacency table ---
    ;; For each cell, store the 4 neighbour cell indices (above/left/right/below)
    ;; with wraparound so the output tiles seamlessly on a torus.
    neighbours: fill num-cells * 4 0
    for row 0 out-rows - 1 1 [
        for col 0 out-cols - 1 1 [
            cell:    col + (out-cols * row)
            nb-base: 4 * cell
            pokez neighbours nb-base     col + (out-cols * ((out-rows + row - 1) % out-rows)) ;; above
            pokez neighbours nb-base + 1 ((out-cols + col - 1) % out-cols) + (out-cols * row) ;; left
            pokez neighbours nb-base + 2 ((col + 1) % out-cols) + (out-cols * row)            ;; right
            pokez neighbours nb-base + 3 col + (out-cols * ((row + 1) % out-rows))            ;; below
        ]
    ]

    ;; --- compatibility tables ---
    ;; horz(i,j)=1 when tile i can sit immediately left of tile j:
    ;;   right edge of i (last col) must match left edge of j (first col),
    ;;   checked for every row of the tile.
    ;; vert(i,j)=1 when tile i can sit immediately above tile j:
    ;;   bottom edge of i (last row) must match top edge of j (first row),
    ;;   checked for every col of the tile.
    horz: fill num-tiles * num-tiles 0
    for ti 0 num-tiles - 1 1 [
        for tj 0 num-tiles - 1 1 [
            pokez horz tj + (ti * num-tiles) 1
            for tr 0 tile-rows - 1 1 [  ;; iterate rows, compare right col of ti vs left col of tj
                if (pickz blocks 0                + (tile-cols * (tr + (tile-rows * ti))))
                != (pickz blocks (tile-cols - 1)  + (tile-cols * (tr + (tile-rows * tj)))) [
                    pokez horz tj + (ti * num-tiles) 0
                    break
                ]
            ]
        ]
    ]

    vert: fill num-tiles * num-tiles 0
    for ti 0 num-tiles - 1 1 [
        for tj 0 num-tiles - 1 1 [
            pokez vert tj + (ti * num-tiles) 1
            for tc 0 tile-cols - 1 1 [  ;; iterate cols, compare bottom row of ti vs top row of tj
                if (pickz blocks tc + (tile-cols * (0               + (tile-rows * ti))))
                != (pickz blocks tc + (tile-cols * ((tile-rows - 1) + (tile-rows * tj)))) [
                    pokez vert tj + (ti * num-tiles) 0
                    break
                ]
            ]
        ]
    ]

    ;; --- allow table ---
    ;; Flattens horz/vert into 4 directional slices for fast lookup in the collapse loop.
    ;; allow[dir*stride + ti*num-tiles + tj] = 1 if tj is allowed in direction dir from ti
    stride: (num-tiles + 1) * num-tiles
    allow: fill 4 * stride 1
    for ti 0 num-tiles - 1 1 [
        for tj 0 num-tiles - 1 1 [
            pokez allow                (ti * num-tiles) + tj   pickz vert (tj * num-tiles) + ti ;; above
            pokez allow      stride  + (ti * num-tiles) + tj   pickz horz (tj * num-tiles) + ti ;; left
            pokez allow (2 * stride) + (ti * num-tiles) + tj   pickz horz (ti * num-tiles) + tj ;; right
            pokez allow (3 * stride) + (ti * num-tiles) + tj   pickz vert (ti * num-tiles) + tj ;; below
        ]
    ]

    ;; --- WFC state ---
    collapsed:  fill num-cells num-tiles      ;; chosen tile per cell; num-tiles = not yet collapsed
    pending:    fill num-cells 0              ;; indices of uncollapsed cells this iteration
    wave:       fill num-cells * num-tiles 0  ;; wave[cell*num-tiles + t] = is tile t still possible?
    entropy:    fill num-cells 0              ;; number of still-possible tiles per pending cell
    candidates: fill num-cells 0              ;; pending cells sharing the minimum entropy
    possible:   fill num-tiles 0              ;; scratch: possible tiles for the chosen cell

    ;; --- collapse loop ---
    forever [
        ;; collect all not-yet-collapsed cells
        cnt: 0
        for ci 0 num-cells - 1 1 [
            if num-tiles = pickz collapsed ci [
                pokez pending cnt ci
                cnt: cnt + 1
            ]
        ]
        if cnt = 0 [break]  ;; all cells collapsed — done

        ;; compute entropy for each pending cell by ANDing neighbour allow-masks
        min-entropy: num-tiles
        for ei 0 cnt - 1 1 [
            pokez entropy ei 0
            cell: pickz pending ei
            nb-off: 4 * cell
            for t 0 num-tiles - 1 1 [
                possible-here:
                    (pickz allow                (num-tiles * (pickz collapsed (pickz neighbours nb-off      ))) + t)
                  * (pickz allow      stride  + (num-tiles * (pickz collapsed (pickz neighbours (nb-off + 1)))) + t)
                  * (pickz allow (2 * stride) + (num-tiles * (pickz collapsed (pickz neighbours (nb-off + 2)))) + t)
                  * (pickz allow (3 * stride) + (num-tiles * (pickz collapsed (pickz neighbours (nb-off + 3)))) + t)
                pokez wave (ei * num-tiles + t) possible-here
                pokez entropy ei ((pickz entropy ei) + possible-here)
            ]
            min-entropy: min min-entropy pickz entropy ei
        ]

        if min-entropy = 0 [return none]  ;; contradiction — caller should retry

        ;; collect all pending cells sharing the minimum entropy
        d: 0
        for ei 0 cnt - 1 1 [
            if min-entropy = pickz entropy ei [
                pokez candidates d ei
                d: d + 1
            ]
        ]

        ;; pick one at random and collapse it to a random allowed tile
        chosen:    pickz candidates ((random d) - 1)
        wave-base: chosen * num-tiles
        d: 0
        for t 0 num-tiles - 1 1 [
            unless zero? pickz wave (wave-base + t) [
                pokez possible d t
                d: d + 1
            ]
        ]
        pokez collapsed (pickz pending chosen) (pickz possible ((random d) - 1))
    ]

    ;; --- assemble pixel output ---
    ;; Stitch chosen tiles together, overlapping shared edges by 1 pixel.
    out-w:  1 + (out-cols * (tile-cols - 1))
    out-h:  1 + (out-rows * (tile-rows - 1))
    output: fill out-w * out-h 0
    for oi 0 out-rows  - 1 1 [
    for pi 0 tile-rows - 1 1 [
    for qi 0 out-cols  - 1 1 [
    for si 0 tile-cols - 1 1 [
        src-tile: pickz collapsed qi + (out-cols * oi)
        out-idx: si + ((tile-cols - 1) * qi) + ((1 + (out-cols * (tile-cols - 1))) * (pi + ((tile-rows - 1) * oi)))
        blk-idx: si + (tile-cols * (pi + (tile-rows * src-tile)))
        pokez output out-idx (pickz blocks blk-idx)
    ]]]]
    output
]

;; --- main ---
blocks: [
    0 0 0
    0 0 0
    0 0 0

    0 0 0
    1 1 1
    0 1 0

    0 1 0
    0 1 1
    0 1 0

    0 1 0
    1 1 1
    0 0 0

    0 1 0
    1 1 0
    0 1 0
]
tdims: [5 3 3] ;; num-tiles tile-rows tile-cols
size:  [8 8]   ;; output grid in tiles

;; retry until a contradiction-free collapse is found
until [
    not none? tile: wave-function-collapse blocks tdims size
]
;; pretty-print
width: 1 + (size/2 * (tdims/3 - 1))
tile: mold/only new-line/skip tile true width
replace/all tile #" " ""
replace/all tile #"0" #" "
replace/all tile #"1" #"█"
foreach line split-lines tile [
    print ajoin [line line line]
]
