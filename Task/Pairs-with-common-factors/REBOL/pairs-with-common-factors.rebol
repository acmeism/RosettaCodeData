Rebol [
    title: "Rosetta code: Pairs with common factors"
    file:  %Pairs_with_common_factors.r3
    url:   https://rosettacode.org/wiki/Pairs_with_common_factors
]

list-totients: function [
    "Sieve to compute Euler's totient for all numbers up to limit"
    limit [integer!]
][
    totients: make vector! compose [uint64! (limit + 1)]
    repeat n limit + 1 [totients/:n: n - 1]
    i: 2
    while [i <= limit] [
        if i = totients/(i + 1) [
            totients/(i + 1): i - 1
            j: i * 2
            while [j <= limit] [
                totients/(j + 1): (totients/(j + 1) / i) * (i - 1)
                j: j + i
            ]
        ]
        ++ i
    ]
    totients
]

limit: 1000000

print "Computing totients..."
totients: list-totients limit

pairs-count: make vector! compose [uint64! (limit + 1)]
totient-sum: 0

print "Computing pairs..."
repeat number limit [
    totient-sum: totient-sum + totients/(number + 1)
    pairs-count/(number + 1): either prime? number [
        pairs-count/:number
    ][
        (number * (number - 1) / 2) - totient-sum + 1
    ]
]

print "The first one hundred terms of the number of pairs with common factors:"
repeat number 100 [
    prin ajoin [
        pad pairs-count/(number + 1) -5
        either zero? number % 10 [LF][SP]
    ]
]
print ""

;; Print at powers of 10
term: 1 while [term <= limit] [
    label: ajoin ["Term " term ":"]
    print [pad label 13 pairs-count/(term + 1)]
    term: term * 10
]
