Rebol [
    title: "Rosetta code: Almost prime"
    file:  %Almost_prime.r3
    url:   https://rosettacode.org/wiki/Almost_prime
]

;- Prime Factorisation --------------------------------------------------
prime-factors: function [
    "Returns a block of prime factors for N (with repetition)."
    n [integer!]
][
    factors: clear []
    d: 2
    while [(d * d) <= n][
        while [zero? n % d][
            append factors d
            n: n / d
        ]
        ++ d
    ]
    if n > 1 [append factors n]
    factors
]
;- Almost-Prime Filter --------------------------------------------------
almost-prime: function [
    "Returns first list-len integers with exactly k prime factors"
    k [integer!]  list-len [integer!]
][
    result: copy []
    n: 2
    while [list-len > length? result][
        if k = length? prime-factors n [append result n]
        ++ n
    ]
    result
]

;- Main -----------------------------------------------------------------
;; Print the first 10 K-almost-primes for K = 1 through 5.
repeat k 5 [
    prin rejoin ["k: " k " => "]
    print almost-prime k 10
]
