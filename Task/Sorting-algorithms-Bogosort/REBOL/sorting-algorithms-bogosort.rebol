Rebol [
    title: "Rosetta code: Sorting algorithms/Bogosort"
    file:  %Sorting_algorithms-Bogosort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Bogosort
]

sorted?: function [
    "Return true if block is in non-descending order"
    items [block!]
][
    repeat i (length? items) - 1 [
        if items/:i > items/(i + 1) [
            return false ;; found out-of-order pair
        ]
    ]
    true
]

bogo-sort: function [
    "Sort block by random shuffling until sorted"
    items [block!]
][
    ;; shuffle until lucky
    while [not sorted? items][ random items ]
    items
]

probe bogo-sort [3 1 2 8 5 7 9 4 6]
