Red [
    title: "Jewels and stones"
    red-version: 0.6.4
]

count: function [
    "Returns the number of values in a block for which a function returns true"
    values [any-list! string!] "The values from which to count"
    fn [function!] "A function that returns true or false"
][
    count: 0
    foreach value values [if fn value [count: count + 1]]
    count
]

count-jewels: function [
    "Returns the count of 'jewels' in the 'stones'"
    stones "The values to search for jewels"
    jewels "The values to count in the stones"
][
    result: 0
    foreach jewel jewels [
        result: result + count stones function [stone][stone = jewel]
    ]
]

print count-jewels "aAAbbbb" "aA"
print count-jewels "ZZ" "z"
