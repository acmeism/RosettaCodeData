Rebol [
    title: "Rosetta code: Sorting algorithms/Stooge sort"
    file:  %Sorting_algorithms-Stooge_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms-Stooge_sort
]

stooge-sort: function/with [
    "Recursively sort a block in-place using the Stooge Sort algorithm"
    data [block!] "The block to sort"
][
    ;; Public entry point: delegate to the private helper with full index range
    stoogesort data 1 length? data
][
    ;; --- private context: defined once, shared across all calls to stooge-sort ---
    stoogesort: function [
        L [block!  ]  ;; The block to sort
        i [integer!]  ;; Start index (1-based)
        j [integer!]  ;; End index (1-based)
    ][
        ;; Swap endpoints if out of order
        if L/:j < L/:i [ swap at L j at L i ]
        ;; Recurse only if the subrange contains more than 2 elements
        if j - i > 1 [
            ;; Divide the range into thirds; integer-truncate to get whole steps
            t: to integer! ((j - i + 1) / 3)
            stoogesort L  i      j - t      ;; Sort first two-thirds
            stoogesort L  i + t  j          ;; Sort last  two-thirds
            stoogesort L  i      j - t      ;; Sort first two-thirds again
        ]
        L ;; Return the (now sorted) block
    ]
]

; --- example usage ---
print ["Input: " mold data: [1 4 5 3 -6 3 7 10 -2 -5 7 5 9 -3 7]]
print ["Sorted:" mold stooge-sort data]
