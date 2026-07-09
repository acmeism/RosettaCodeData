Rebol [
    title: "Rosetta code: Find first missing positive"
    file:  %Find_first_missing_positive.r3
    url:   https://rosettacode.org/wiki/Find_first_missing_positive
]

first-missing-positive: function [nums [block!]][
    i: 0
    until [not find nums i: i + 1]  ;; increment until i is not in nums
    i
]
foreach nums [
    [1 2 0]
    [3 4 -1 1]
    [7 8 9 11 12]
][
    print [first-missing-positive nums "is missing from" mold nums]
]
