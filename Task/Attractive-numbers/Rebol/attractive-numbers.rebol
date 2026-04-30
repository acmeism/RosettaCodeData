Rebol [
    title: "Rosetta code: Attractive numbers"
    file:  %Attractive_numbers.r3
    url:   https://rosettacode.org/wiki/Attractive_numbers
]

count-prime-factors: function [n [integer!]][
    if n = 1    [return 0]
    if prime? n [return 1]
    nn: n count: 0 f: 2
    forever [
        either zero? nn % f [
            ++ count
            nn: nn / f
            if nn = 1     [break]
            if prime? nn  [f: nn]
        ][
            f: either f >= 3 [f + 2] [3]
        ]
    ]
    count
]

attractive-numbers: function [max-n [integer!]][
    out: copy []
    repeat i max-n [
        if prime? count-prime-factors i [ append out i ]
    ]
    new-line/skip out true 20
]

print ["The attractive numbers up to and including" max-n: 120 "are:"]
probe attractive-numbers :max-n
