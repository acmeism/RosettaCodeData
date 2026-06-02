Rebol [
    title: "Rosetta code: Sorting algorithms/Quicksort"
    file:  %Sorting_algorithms-Quicksort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms-Quicksort
]

quick-sort: function/with [
    "Sort a series in ascending order using quicksort."
    items [series!] "Series of values to sort"
][
    qsort items 1 length? items
    items
][
    qsort: function [
        ;; Sort a subrange of a block in-place using Hoare partition scheme.
        a     [series!]  ;; Series to sort in-place
        start [integer!] ;; Start index of subrange (inclusive)
        stop  [integer!] ;; Stop index of subrange (inclusive)
    ][
        if stop - start <= 0 [exit]

        ;; median-of-three: sort start/mid/stop and use median as pivot
        mid: (start + stop) >> 1
        if a/:start > a/:mid  [swap at a start at a mid ]
        if a/:start > a/:stop [swap at a start at a stop]
        if a/:mid   > a/:stop [swap at a mid   at a stop]

        ;; initialise pivot and left/right cursors
        pivot: a/:start
        left:  start
        right: stop

        while [left <= right][
            while [a/:left  < pivot] [++ left]
            while [a/:right > pivot] [-- right]
            if left <= right [
                swap at a left  at a right
                ++ left
                -- right
            ]
        ]
        ;; recursively sort the two partitions
        qsort a start right
        qsort a left  stop
    ]
]

probe quick-sort [1 2 3 4 5 6 7 8 9]
probe quick-sort [3 1 2 8 5 7 9 4 6]
probe quick-sort "Hello Rosetta"
