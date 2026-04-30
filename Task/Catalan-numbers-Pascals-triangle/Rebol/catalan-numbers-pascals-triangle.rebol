Rebol [
    title: "Rosetta code: Catalan numbers/Pascal's triangle"
    file:  %Catalan_numbers-Pascal's_triangle.r3
    url:   https://rosettacode.org/wiki/Catalan_numbers/Pascal's_triangle
]

catalan-number: function [
    "Compute the nth Catalan number using the product formula:"
    "C(n) = product((n+k)/k) for k in 2..n"
    n [integer!]
][
    nm: dm: 1.0     ;; accumulate numerator and denominator as decimals to avoid integer overflow
    repeat k n [
        if k >= 2 [ ;; product starts at k=2; k=1 contributes (n+1)/1 which is handled by nm/dm=1
            nm: nm * (n + k) ;; multiply numerator by (n+k)
            dm: dm * k       ;; multiply denominator by k
        ]
    ]
    to integer! nm / dm      ;; divide and convert back to integer (result is always whole)
]

;; Build a block of the first 15 Catalan numbers using collect/keep
probe result: collect [ repeat n 15 [keep catalan-number n] ]
