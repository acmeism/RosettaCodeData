Rebol [
    title: "Rosetta code: Sierpinski triangle"
    file:  %Sierpinski_triangle.r3
    url:   https://rosettacode.org/wiki/Sierpinski_triangle
]

sierpinski: function [
    "Print a Sierpinski triangle of given order using bitwise pattern"
    order [integer!]
][
    s: 1 << order                                      ;; triangle size (2^order)
    repeat y s [
        i: s - y                                       ;; invert row index
        loop i [prin " "]                              ;; indent row
        repeat x s - i [
            prin pick ["* " "  "] zero? ((x - 1) & i)  ;; bitwise check for triangle pattern
        ]
        print ""
    ]
]

sierpinski 4
