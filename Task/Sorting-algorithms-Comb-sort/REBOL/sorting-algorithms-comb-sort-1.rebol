Rebol [
    title: "Rosetta code: Sorting algorithms/Comb sort"
    file:  %Sorting_algorithms-Comb_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Comb_sort
    needs: 3.21.16 ;; because of the integer-divide op: //
]

comb-sort: function [
    "Sort a series in ascending order using comb sort."
    items [series!] "Values to sort"
][
    gap: len: length? items
    swapped: true
    while [any [gap > 1  swapped]][
        ;; shrink gap by factor of 1.3, with the '11 fix' for known bad gaps
        gap: gap * 10 // 13
        case [
            any [gap = 9  gap = 10] [gap: 11]
            gap < 1                 [gap: 1 ]
        ]
        swapped: false
        i: 1
        ;; compare each pair separated by 'gap', swap if out of order
        loop len - gap [
            j: i + gap
            if items/:i > items/:j [
                swap at items i at items j
                swapped: true
            ]
            ++ i
        ]
    ]
    items
]

probe comb-sort [3 1 2 8 5 7 9 4 6]
probe comb-sort "Hello Rosetta"
