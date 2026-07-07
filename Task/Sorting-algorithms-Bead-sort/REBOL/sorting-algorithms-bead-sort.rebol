Rebol [
    title: "Rosetta code: Sorting algorithms/Bead sort"
    file:  %Sorting_algorithms-Bead_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Bead_sort
]

bead-sort: function [
    "Sort a block of positive integers using bead sort algorithm"
    block [block!]
][
    n: length? block
    mx: first find-max block                    ;; column count = max value
    beads: make vector! reduce ['uint8! n * mx] ;; 2D grid: rows=items, cols=beads

    ;; fill row i with block[i] beads
    repeat i n [
        repeat j block/:i [
            beads/(i - 1 * mx + j): 1
        ]
    ]
    ;; let beads fall column by column
    repeat j mx [
        sum: 0
        repeat i n [
            idx: i - 1 * mx + j
            sum: sum + beads/:idx
            beads/:idx: 0                       ;; clear column
        ]
        loop sum [
            beads/(n - sum * mx + j): 1         ;; stack beads at bottom
            -- sum
        ]
    ]
    ;; count beads per row = sorted value
    repeat i n [
        j: 1
        while [all [j <= mx  0 < beads/(i - 1 * mx + j)]][ ++ j ]
        block/:i: j - 1
    ]
    block
]

probe bead-sort [5 3 1 7 4 1 1 20]
