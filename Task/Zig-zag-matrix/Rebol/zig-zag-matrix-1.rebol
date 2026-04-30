Rebol [
    title: "Rosetta code: Zig-zag matrix"
    file:  %Zig-zag_matrix.r3
    url:   https://rosettacode.org/wiki/Zig-zag_matrix
]

zig-zag-matrix: function [size [integer!]][
    matrix: array/initial size * size 0  ;; Flat array, row-major
    n: 0                                 ;; Current value to assign
    ;; Traverse (2 * size - 1) diagonals
    repeat d (size * 2) - 1 [
        either even? d [
            ;; For even diagonals, go from bottom to top
            x: min d size
            y: d + 1 - x
            while [all [
                x >= 1
                y <= size
            ]][
                pos: (y - 1) * size + x
                matrix/:pos: n
                ++ n
                -- x
                ++ y
            ]
        ][  ;; For odd diagonals, go top to bottom
            y: min d size
            x: d + 1 - y
            while [all [
                y >= 1
                x <= size
            ]][
                pos: (y - 1) * size + x
                matrix/:pos: n
                ++ n
                -- y
                ++ x
            ]
        ]
    ]
    new-line/skip matrix true size
    matrix
]

;; Example usage:
probe zig-zag-matrix 5
