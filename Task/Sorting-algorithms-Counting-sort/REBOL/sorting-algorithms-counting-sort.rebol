Rebol [
    title: "Rosetta code: Sorting algorithms/Counting sort"
    file:  %Sorting_algorithms-Counting_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Counting_sort
]

counting-sort: function [
    "Sort a block of integers in-place using counting sort."
    items   [block!]   "Block of integers to sort"
    minimum [integer!] "Minimum value in the block"
    maximum [integer!] "Maximum value in the block"
][
    rng: maximum - minimum + 1
    ;; build frequency table: cnt/1 corresponds to value 'minimum'
    cnt: make block! rng
    append/dup cnt 0 rng
    ;; tally occurrences of each value
    foreach val items [
        idx: val - minimum + 1
        cnt/:idx: cnt/:idx + 1
    ]
    ;; overwrite 'items' by expanding each count back into sorted values
    z: 1
    repeat i rng [
        val: minimum + i - 1
        loop cnt/:i [
            items/:z: val
            ++ z
        ]
    ]
    items
]

print counting-sort [3 1 2 8 5 7 9 4 6] 1 9
