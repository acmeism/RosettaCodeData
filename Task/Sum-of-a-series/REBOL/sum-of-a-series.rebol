Rebol [
    title: "Rosetta code: Sum of a series"
    file:  %Sum_of_a_series.r3
    url:   https://rosettacode.org/wiki/Sum_of_a_series
]

basel-problem: function [
    "Approximates the Basel problem sum: Σ 1/n² from 1 to n"
    "(converges to π²/6 ≈ 1.6449)"
    n [integer!] "Number of terms"
][
    s: 0.0
    repeat i n [s: s + (1.0 / i ** 2)]
]

foreach n [1 10 100 1000 10000 100000][
    printf [7 "-> "] [n basel-problem n]
]
