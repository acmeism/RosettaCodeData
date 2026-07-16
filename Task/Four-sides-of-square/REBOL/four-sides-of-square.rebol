Rebol [
    title: "Rosetta code: Four sides of square"
    file:  %Four_sides_of_square.r3
    url:   https://rosettacode.org/wiki/Four_sides_of_square
]

draw-square: function [
    "Returns a block of rows representing a square border of 1s with 0s inside."
    side [integer!]
][
    out: copy []
    repeat x side [
        append out new-line collect [
            repeat y side [
                keep either any [x = 1  y = 1  x = side  y = side] [1][0]
            ]
        ] true
    ]
    out
]

probe draw-square 4
print ""
probe draw-square 6
