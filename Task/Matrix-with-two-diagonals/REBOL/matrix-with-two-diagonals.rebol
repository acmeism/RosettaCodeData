x-matrix: function [size][
    repeat i size [
        repeat j size [
            prin either any [i = j i + j - 1 = size] [1] [0]
            prin sp
        ]
        prin newline
    ]
]

x-matrix 6
prin newline
x-matrix 7
