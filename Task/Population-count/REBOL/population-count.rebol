Rebol [
    title: "Rosetta code: Population count"
    file:  %Population_count.r3
    url:   https://rosettacode.org/wiki/Population_count
]

pop-count: func [
    "Count number of 1-bits in integer"
    num [integer!]
][
    count: 0
    while [num > 0] [
        count: count + (num % 2)
        num: num // 2
    ]
    count
]

print "Population count for the first thirty powers of 3:"
print collect [for i 0 29 1 [keep pop-count to integer! 3 ** i]]

print "First thirty evil numbers:"
print copy/part collect [for i 0 299 1 [if even? pop-count i [keep i]]] 30

print "First thirty odious numbers:"
print copy/part collect [for i 0 299 1 [if odd?  pop-count i [keep i]]] 30
