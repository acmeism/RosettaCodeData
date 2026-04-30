Rebol [
    title: "Rosetta code: Spiral matrix"
    file:  %Spiral_matrix.r3
    url:   https://rosettacode.org/wiki/Spiral_matrix
]

spiral-matrix: function [size [integer!]] [
    matrix: array/initial size * size 0 ;; Flat array, row-major
    x: y: 1                             ;; Current (x, y) position (1-based indexing)
    dx: 1 dy: 0                         ;; Initial direction: move right
    n: 0                                ;; Next value to insert
    loop size * size [                  ;; Number of values to insert
        pos: (y - 1) * size + x         ;; Map 2D (x, y) to 1D flat array index
        matrix/:pos: n: n + 1           ;; Fill value
        ;; Calculate next position
        nx: x + dx
        ny: y + dy
        ;; If out of bounds or already filled, turn direction (right -> down -> left -> up)
        if any [
            nx < 1
            nx > size
            ny < 1
            ny > size
            matrix/((ny - 1) * size + nx) <> 0
        ][
            ny: dx
            dx: negate dy
            dy: ny
            nx: x + dx
            ny: y + dy
        ]
        x: nx
        y: ny
    ]
    new-line/skip matrix true size
    matrix
]

;; Example usage:
probe spiral-matrix 5
