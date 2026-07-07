Rebol [
    title: "Rosetta code: Nice primes"
    file:  %Nice_primes.r3
    url:   https://rosettacode.org/wiki/Nice_primes
]

nice-prime?: function/with [
    "Returns true if n and its iterated digit-sum are both prime"
    n [integer!]
][
    all [prime? n  prime? sum-digits n]
][
    sum-digits: function [n][
        s: 0
        foreach d (form n) [s: s + (d - #"0")]
        either s < 10 [s] [sum-digits s]
    ]
]

prin "Nice primes between 500 and 1000: "
probe new-line/skip collect [
    for n 500 1000 1 [if nice-prime? n [keep n]]
] true 10
