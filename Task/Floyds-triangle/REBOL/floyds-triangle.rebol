Rebol [
    title: "Rosetta code: Floyd's triangle"
    file:  %Floyd's_triangle.r3
    url:   https://rosettacode.org/wiki/Floyd%27s_triangle
]

print-floyd: function [
    "Prints Floyd's triangle with aligned columns"
    rows [integer!]
][
    c: 1
    h: rows * (rows - 1) >> 1          ;; starting number of the last row
    repeat i rows [
        s: clear ""
        repeat j i [
            width: length? form h + j  ;; column width based on last row's value
            if j > 1 [append s space]
            append s pad c negate width
            ++ c
        ]
        print [pad i -3 "|" s]
    ]
]

foreach rows [5 14][
    print [as-yellow "Floyd's triangle with rows:" rows]
    print-floyd rows
    print ""
]
