count-jewels: function [
    "Returns the count of 'jewels' in the 'stones'"
    stones "The values to search for jewels"
    jewels "The values to count in the stones"
][
    count: 0
    jewel: charset jewels
    parse/case stones [any [jewel (++ count) | skip]]
    count
]

print count-jewels "aAAbbbb" "aA"
print count-jewels "ZZ" "z"
