Red [
   title: "Radix Sort"
   author: "hinjolicious"
   resources: "Red Sensei, Rosetta Code, etc."
]

max-of: func [s [series!] /local m][
    m: first s
    foreach v s [if v > m [m: v]]
    m
]

radix-sort: function [
    "Sorts a block of non-negative integers using radix sort (LSD)"
    data [block!] "Block of integers to sort"
    /base radix [integer!] "Number base (default 10)"
][
    radix: any [radix 10]
    if empty? data [return copy []]

    result: copy data
    max-val: max-of result

    ; Process each digit position
    exp: 1
    while [max-val / exp >= 1][
        ; Counting sort for current digit
        buckets: collect [loop radix [keep/only copy []]]

        ; Distribute elements into buckets
        foreach num result [
            digit: to-integer (num / exp) // radix + 1  ; +1 for 1-based indexing
            append buckets/:digit num
        ]

        ; Collect elements back
        clear result
        repeat i radix [
            append result buckets/:i
        ]

        exp: exp * radix
    ]
    result
]

random/seed 1
max: 10000
dat: collect [loop max [keep random max]]

t: now/time/precise
s: radix-sort dat
print ["radix-sort: " now/time/precise - t]
print ["sorted: " s]
