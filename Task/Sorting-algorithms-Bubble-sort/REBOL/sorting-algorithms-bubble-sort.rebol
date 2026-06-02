Rebol [
    title: "Rosetta code: Sorting algorithms/Bubble sort"
    file:  %Sorting_algorithms-Bubble_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms-Bubble_sort
]

bubble-sort: function [
    "Sort a series in ascending order in-place using bubble sort."
    items [series!] "Series of values to sort"
][
    n: length? items
    while [n > 1] [
        swapped: false
        repeat i n - 1 [
            j: i + 1
            if items/:i > items/:j [
                swap at items i  at items j
                swapped: true
            ]
        ]
        unless swapped [return items]
        -- n
    ]
    items
]

probe bubble-sort [3 1 2 8 5 7 9 4 6]
probe bubble-sort "Hello Rosetta"
