Red ["Multiplicative digital root"]

mdr: function [
    "Returns a block containing the mdr and persistence of an integer"
    n [integer!]
][
    persistence: 0
    while [n > 10][
        product: 1
        m: n
        while [m > 0][
            product: m % 10 * product
            m: to-integer m / 10
        ]
        persistence: persistence + 1
        n: product
    ]
    reduce [n persistence]
]

foreach n [123321 7739 893 899998][
    result: mdr n
    print [pad n 6 "has multiplicative persistence" result/2 "and MDR" result/1]
]

print [newline "First five numbers with MDR of"]

repeat i 10 [
    prin rejoin [i - 1 ": "]
    hits: n: 0
    while [hits < 5][
        if i - 1 = first mdr n [
            prin pad n 5
            hits: hits + 1
        ]
        n: n + 1
    ]
    prin newline
]
