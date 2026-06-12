Rebol [
    title: "Rosetta code: N'th"
    file:  %N'th.r3
    url:   https://rosettacode.org/wiki/N'th
]

nth: function [
    "Returns a string with the ordinal suffix appended to an integer"
    n [integer!] "The integer to format as an ordinal"
][
    d:  n % 10
    dd: n % 100
    suffix: either any [
        all [ dd > 3 dd < 20 ]
        d < 1 d > 4
        1 = to integer! n / 10
    ] [4] [d]

    ajoin [n #"'" pick [st nd rd th] suffix]
]

;; test:

foreach [low high] [0 25  250 265  1000 1025][
    for i low high 1 [
        if zero? i % 10 [prin newline]
        prin pad nth i -8
    ]
    print ""
]
