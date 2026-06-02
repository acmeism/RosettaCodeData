identity-matrix: function[size [integer!]][
    matrix: array/initial reduce [size size] 0
    repeat i size [matrix/:i/:i: 1]
    new-line/all matrix true
    matrix
]
probe identity-matrix 5
