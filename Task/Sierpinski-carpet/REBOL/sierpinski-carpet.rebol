Rebol [
    title: "Rosetta code: Sierpinski carpet"
    file:  %Sierpinski_carpet.r3
    url:   https://rosettacode.org/wiki/Sierpinski_carpet
    needs: 3.21.16
]

sierpinski-carpet: function/with [
    "Print a Sierpinski carpet of given order"
    n [integer!]
][
    size: -1 + to integer! 3 ** n                ;; grid size (3^n - 1) for zero-based loop
    for i 0 size 1 [
        for j 0 size 1 [
            prin pick ["# ""  "] in-carpet? i j  ;; bitwise check for carpet pattern
        ]
        print ""
    ]
][
    in-carpet?: function [
        ;; Return true if point (x,y) is in the Sierpinski carpet
        x [integer!] y [integer!]
    ][
        forever [
            if any [zero? x zero? y]       [return true ] ;; on edge, always in carpet
            if all [x % 3 == 1 y % 3 == 1] [return false] ;; in center hole, not in carpet
            x: x // 3                                     ;; scale down
            y: y // 3
        ]
    ]
]

sierpinski-carpet 3
