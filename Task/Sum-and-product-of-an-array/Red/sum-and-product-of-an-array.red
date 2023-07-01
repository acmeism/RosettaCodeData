Red [
    red-version: 0.6.4
    description: "Find the sum and product of an array of numbers."
]

product: function [
    "Returns the product of all values in a block."
    values [any-list! vector!]
][
    result: 1
    foreach value values [result: result * value]
    result
]

a: [1 2 3 4 5 6 7 8 9 10]
print a
print ["Sum:" sum a]
print ["Product:" product a]
