; Handling negative numbers using offset by a wrapper function
radix-sort-signed: function [
    "Sorts integers (including negatives) using radix sort"
    data [block!]
    /base radix [integer!]
][
    if empty? data [return copy []]

    min-val: data/1
    foreach n data [if n < min-val [min-val: n]]

    offset: negate min-val  ; shift amount to make all non-negative

    ; Shift, sort, unshift
    shifted: collect [foreach n data [keep n + offset]]
    sorted: either base [radix-sort/base shifted radix][radix-sort shifted]
    collect [foreach n sorted [keep n - offset]]
]

random/seed 1
max: 100
dat: collect [loop max [keep (to-integer max / 2 - random max)]]

t: now/time/precise
s: radix-sort-signed dat
print ["radix-sort-signed: " now/time/precise - t]
print ["sorted: " s]
