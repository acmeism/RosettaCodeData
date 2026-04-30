Rebol [
    title: "Rosetta code: Sorting algorithms/Gnome sort"
    file:  %Sorting_algorithms-Gnome_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Gnome_sort
]

gnome-sort: function [
    "In-place gnome sort: steps forward when order is correct, swaps and steps back when not"
    items [series!]
][
    n: length? items
    i: 2                                      ;; start at second element, comparing i-1 and i
    while [i <= n][
        either items/(i - 1) <= items/:i [    ;; pair is in order
            ++ i                              ;; advance
        ][                                    ;; pair is out of order
            swap at items (i - 1) at items i  ;; swap
            if i > 2 [-- i]                   ;; and step back if not already at start
        ]
    ]
    items
]

probe gnome-sort [3 1 2 8 5 7 9 4 6]
probe gnome-sort "Hello Gnome"
