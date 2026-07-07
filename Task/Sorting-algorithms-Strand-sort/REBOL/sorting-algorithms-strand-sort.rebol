Rebol [
    title: "Rosetta code: Sorting algorithms/Strand sort"
    file:  %Sorting_algorithms-Strand_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Strand_sort
]

merge-list: function [
    "Merge two sorted blocks into one sorted block"
    a [block!] b [block!]
][
    out: copy []
    while [all [not empty? a not empty? b]] [
        ;; take smaller head from a or b
        append out take either a/1 < b/1 [a][b]
    ]
    append append out a b         ;; append remaining elements
]

strand: function [
    "Extract increasing subsequence from front of block (modifies input)"
    a [block!]
][
    s: take/part a 1              ;; start strand with first element
    i: 1
    while [i <= length? a] [
        either a/:i > last s [
            append s take at a i  ;; extend strand, don't advance i
        ][
            ++ i
        ]
    ]
    s
]

strand-sort: function [
    "Sort block by repeatedly extracting sorted strands and merging"
    items [block!]
][
    items: copy items
    out: strand items
    while [not empty? items] [
        out: merge-list out strand items  ;; merge next strand into result
    ]
    out
]

probe strand-sort [3 1 2 8 5 7 9 4 6]
