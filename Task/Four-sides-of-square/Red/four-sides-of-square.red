Red[]

view-square: function [size][
    matrix: copy [
        title "Four sides of a square"
        style cell: base 50x50 font-size 20
        style one: cell brown font-color beige "1"  ; I am not an artist. Please have mercy!
        style zero: cell beige font-color brown "0"
    ]
    repeat i size [
        either any [i = 1 i = size] [
            append matrix append/dup copy [] 'one size
        ][
            row: append/dup copy [] 'zero size
            row/1: row/:size: 'one
            append matrix row
        ]
        append matrix 'return
    ]
    view matrix
]

view-square 9
