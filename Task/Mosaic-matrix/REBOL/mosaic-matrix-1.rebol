mosaic-matrix: function [size [integer!]][
    matrix: copy []
    repeat i size [
        repeat j size [
            append matrix either even? i + j [1] [0]
        ]
    ]
    new-line/skip matrix true size
]

probe mosaic-matrix 4
probe mosaic-matrix 5
