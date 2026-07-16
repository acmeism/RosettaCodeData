Rebol [
    title: "Rosetta code: Sorting algorithms/Circle sort"
    file:  %Sorting_algorithms-Circle_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms-Circle_sort
]

circle-sort: function/with [
    "Sorts a series using the circle sort algorithm; returns a sorted copy."
    data [series!]
][
    arr: copy data
    while [0 < circlesort 0 (length? arr) - 1 0] []
    arr
][
    arr: _
    circlesort: function/extern [
        "Recursively sorts a subrange [lo..hi] in-place; returns total swap count."
        lo [integer!] hi [integer!] swaps [integer!]
    ][
        if lo == hi [return swaps]    ;; single element - nothing to do
        high: hi
        low:  lo
        mid:  (hi - lo) // 2          ;; midpoint of current range
        ;; mirror pass: swap outermost pair, walk inward
        while [lo < hi] [
            if arr/(lo + 1) > arr/(hi + 1) [
                swap at arr (lo + 1) at arr (hi + 1)
                ++ swaps
            ]
            ++ lo
            -- hi
        ]
        ;; when lo and hi meet at the same index, check centre against right neighbour
        if lo == hi [
            if arr/(lo + 1) > arr/(hi + 2) [
                swap at arr (lo + 1) at arr (hi + 2)
                ++ swaps
            ]
        ]
        ;; recurse on left and right halves
        swaps: circlesort low (low + mid) swaps
        swaps: circlesort (low + mid + 1) high swaps
        swaps
    ][  arr ]
]

; Usage:
probe circle-sort [6 7 8 9 2 5 3 4 1]
probe circle-sort "Hello Rosetta!"
