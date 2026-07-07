Rebol [
    title: "Rosetta code: Sorting algorithms/Selection sort"
    file:  %Sorting_algorithms-Selection_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Selection_sort
]

selection-sort: function [
    "Sort block by repeatedly extracting the minimum element"
    items [block!]
][
    sorted: copy []
    tmp: copy items
    while [not empty? tmp] [
        min-idx: index? find-min tmp  ;; find position of smallest element
        append sorted tmp/:min-idx    ;; move minimum to result
        remove at tmp min-idx         ;; remove it from remaining
    ]
    sorted
]

probe selection-sort [3 1 2 8 5 7 9 4 6]
