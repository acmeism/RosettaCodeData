Red[]

identity-matrix: function [size][
    matrix: copy []
    repeat i size [
        append/only matrix append/dup copy [] 0 size
        matrix/:i/:i: 1
    ]
    matrix
]

probe identity-matrix 5
