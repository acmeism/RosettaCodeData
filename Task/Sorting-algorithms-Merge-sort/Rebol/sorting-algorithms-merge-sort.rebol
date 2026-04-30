msort: function [a compare] [msort-do merge] [
    if (length? a) < 2 [return a]
    ; define a recursive Msort-do function
    msort-do: function [a b l] [mid] [
        either l < 4 [
            if l = 3 [msort-do next b next a 2]
            merge a b 1 next b l - 1
        ] [
            mid: make integer! l / 2
            msort-do b a mid
            msort-do skip b mid skip a mid l - mid
            merge a b mid skip b mid l - mid
        ]
    ]
    ; function Merge is the key part of the algorithm
    merge: func [a b lb c lc] [
        until [
            either (compare first b first c) [
                change/only a first b
                b: next b
                a: next a
                zero? lb: lb - 1
            ] [
                change/only a first c
                c: next c
                a: next a
                zero? lc: lc - 1
            ]
        ]
        loop lb [
            change/only a first b
            b: next b
            a: next a
        ]
        loop lc [
            change/only a first c
            c: next c
            a: next a
        ]
    ]
    msort-do a copy a length? a
    a
]
