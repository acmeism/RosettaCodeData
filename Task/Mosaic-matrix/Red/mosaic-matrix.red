Red[]

mosaic: function [size][
    matrix: copy [
        title "Mosaic matrix"
        style cell: base 50x50 font-size 20
        style one: cell brown font-color beige "1"
        style zero: cell beige
    ]
    repeat i size [
        repeat j size [
            append matrix either even? i + j ['one] ['zero]
        ]
        append matrix 'return
    ]
    view matrix
]

mosaic 8
