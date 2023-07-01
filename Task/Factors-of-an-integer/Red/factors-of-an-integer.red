Red []

factors: function [n [integer!]] [
    n: absolute n
    collect [
        repeat i (sq: sqrt n) - 1 [
            if n % i = 0 [
                keep i
                keep n / i
            ]
        ]
        if sq = sq: to-integer sq [keep sq]
    ]
]

foreach num [
    24
   -64        ; negative
    64        ; square
    101       ; prime
    123456789 ; large
][
    print mold/flat sort factors num
]
