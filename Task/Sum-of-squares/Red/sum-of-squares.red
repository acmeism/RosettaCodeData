Red [
    date: 2021-10-25
    red-version: 0.6.4
    description: "Find the sum of squares of a numeric vector"
]

sum-squares: function [
    "Returns the sum of squares of all values in a block"
    values [any-list! vector!]
][
    result: 0
    foreach value values [result: value * value + result]
    result
]

print sum-squares []
print sum-squares [1 2 0.5]
