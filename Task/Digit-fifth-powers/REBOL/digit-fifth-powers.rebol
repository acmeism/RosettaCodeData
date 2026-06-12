Rebol [
    title: "Rosetta code: Digit fifth powers"
    file:  %Digit_fifth_powers.r3
    url:   https://rosettacode.org/wiki/Digit_fifth_powers
]

fifth-digit-sum?: function [
    "Return true if number equals the sum of its digits each raised to the 5th power."
    num [integer!]
][
    sum: 0
    foreach c form num [sum: sum + ((c - #"0") ** 5)]
    num = sum
]

result: 0
for n 2 1000000 1 [
    if fifth-digit-sum? n [
        if result > 0 [prin " + "]
        prin n
        result: result + n
    ]
]
print [" =" result]
