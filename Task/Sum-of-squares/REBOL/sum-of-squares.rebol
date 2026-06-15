Rebol [
    title: "Rosetta code: Sum of squares"
    file:  %Sum_of_squares.r3
    url:   https://rosettacode.org/wiki/Sum_of_squares
]

sum-squares: function [
    "Returns the sum of squares of all values in a block"
    values [any-block! vector!]
][
    result: 0
    foreach value values [result: value * value + result]
    result
]

foreach test [
    []
    [1 2 0.5]
    [1 2 3 4]
][
    printf [10 "= "] [mold test sum-squares test]
]
