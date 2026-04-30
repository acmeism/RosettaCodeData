identity-matrix: function [size [integer!]][
    matrix: array/initial size * size 0  ;; Create a flat array with size^2 elements, all zeros
    repeat i size [
        matrix/((i - 1) * size + i): 1   ;; Set 1 on the diagonal: row-major position
    ]
    new-line/skip matrix true size
    matrix
]
probe identity-matrix 5
