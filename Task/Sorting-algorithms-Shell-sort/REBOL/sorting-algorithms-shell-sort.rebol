Rebol [
    title: "Rosetta code: Sorting algorithms/Shell sort"
    file:  %Sorting_algorithms-Shell_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms-Shell_sort
]

shell-sort: function [
    "Sorts a block in place using Shell sort algorithm"
    a [block!]
][
    n: length? a
    g: n >> 1                   ;; initial gap = half the length
    while [g > 0][
        i: g + 1
        while [n >= j: i][
            e: a/:i             ;; element to insert
            ;; shift elements right while they are larger than e
            while [all [j > g  e < a/(j - g)]][
                a/:j: a/(j - g)
                j: j - g
            ]
            a/:j: e             ;; place e in its sorted position
            ++ i
        ]
        g: g >> 1               ;; shrink gap
    ]
    a
]

random/seed 1
data: make block! max: 10000
loop max [append data random max]

time: delta-time [ shell-sort data ]
print ["shell-sort time:" time]
print ["sorted:^/" copy/part data 30 "^/...^/" skip tail data -16]
