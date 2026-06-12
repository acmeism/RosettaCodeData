Rebol [
    title: "Rosetta code: Minimum primes"
    file:  %Minimum_primes.r3
    url:   https://rosettacode.org/wiki/Minimum_primes
]

minimum-primes: function [
    "For each column, find the column maximum then the first prime >= that maximum."
    "Returns a block of primes, one per column."
    lists [block!]
][
    primes: copy []
    cols: length? lists/1
    rows: length? lists
    repeat c cols [
        ;; track running column maximum
        m: 0 repeat r rows [ m: max m lists/:r/:c ]
        ;; find the first prime >= start by linear search
        while [not prime? m] [++ m]
        append primes m
    ]
]

probe minimum-primes [
    [ 5 45 23 21 67]
    [43 22 78 46 38]
    [ 9 98 12 54 53]
]
