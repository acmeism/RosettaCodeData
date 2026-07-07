Rebol [
    title: "Rosetta code: Sorting algorithms/Cocktail sort"
    file:  %Sorting_algorithms-Cocktail_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Cocktail_sort
]

cocktail-sort: function/with [
    "Sort block by bidirectional bubble sort"
    items [block!]
][
    len: length? items
    while [true] [
        sorted: true
        for i 2 len 1 [   ;; forward pass
            unless try-swap items i [sorted: false]
        ]
        if sorted [break]
        for i len 2 -1 [  ;; backward pass
            unless try-swap items i [sorted: false]
        ]
        if sorted [break]
    ]
    items
][
    try-swap: func [arr [block!] i [integer!]][
        either arr/:i < arr/(i - 1) [
            ;; Swap arr[i] with arr[i-1] if out of order
            swap at arr i at arr i - 1
            false
        ][  true ]             ;; return true if already ordered
    ]
]

probe cocktail-sort [3 1 2 8 5 7 9 4 6]
