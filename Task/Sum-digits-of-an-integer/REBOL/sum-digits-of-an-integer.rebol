Rebol [
    title: "Rosetta code: Sum digits of an integer"
    file:  %Sum_digits_of_an_integer.r3
    url:   https://rosettacode.org/wiki/Sum_digits_of_an_integer
]

sum-digits: function [
    "Returns the sum of digits of n in the given base"
    n    [integer!]
    base [integer!]
][
    result: 0
    while [n > 0] [
        result: result + (n % base)  ;; add current last digit
        n: n // base                 ;; drop last digit
    ]
    result
]

print sum-digits 1       10
print sum-digits 12345   10
print sum-digits 123045  10
print sum-digits 0#FE    16
print sum-digits 0#F0E   16
print sum-digits 2#1011  2
