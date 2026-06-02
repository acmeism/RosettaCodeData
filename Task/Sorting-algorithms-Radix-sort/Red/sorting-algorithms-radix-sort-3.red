radix-sort-inline-offset: function [
    "Radix sort handling negatives via inline offset calculation"
    data [block!]
    /base radix [integer!]
][
    radix: any [radix 10]
    if empty? data [return copy []]

    result: copy data
    min-val: result/1
    max-shifted: result/1

    ; Find min and max-shifted in single pass
    foreach num result [
        if num < min-val [min-val: num]
    ]

    offset: either min-val < 0 [negate min-val][0]

    ; Find max of shifted values for iteration count
    max-shifted: 0
    foreach num result [
        shifted: num + offset
        if shifted > max-shifted [max-shifted: shifted]
    ]

    exp: 1
    while [max-shifted / exp > 0][
        buckets: collect [loop radix [keep/only copy []]]

        ; Key insight: offset in calculation, store original
        foreach num result [
            digit: to-integer ((num + offset) / exp) % radix + 1
            append buckets/:digit num  ; store ORIGINAL num!
        ]

        ; Collect - no unshifting needed!
        result: make block! length? data
        repeat i radix [append result buckets/:i]

        exp: exp * radix
    ]
    result
]

random/seed 1
max: 100
dat: collect [loop max [keep (to-integer max / 2 - random max)]]

t: now/time/precise
s: radix-sort-inline-offset dat
print ["radix-sort-inline-offset: " now/time/precise - t]
print ["sorted: " s]
