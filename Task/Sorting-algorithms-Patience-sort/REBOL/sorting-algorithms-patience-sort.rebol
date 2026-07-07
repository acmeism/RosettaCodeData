Rebol [
    title: "Rosetta code: Sorting algorithms/Patience sort"
    file:  %Sorting_algorithms-Patience_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Patience_sort
]

patience-sort: function [
    "Sort block using patience sorting algorithm"
    items [block!] "(modified)"
][
    if 2 > length? items [return items]

    piles: copy []                    ;; list of piles (each pile is a block)

    foreach elem items [
        repend piles [reduce [elem]]  ;; start a new pile for each element
    ]

    repeat i length? items [
        min-p:   last piles/1         ;; find pile with smallest top card
        min-idx: 1
        if 2 <= length? piles [
            for j 2 length? piles 1 [
                if min-p > last piles/:j [
                    min-p: last piles/:j
                    min-idx: j
                ]
            ]
        ]
        items/:i: min-p               ;; place smallest into items
        pile: piles/:min-idx
        take/last pile                ;; pop top of winning pile
        if empty? pile [
            remove at piles min-idx   ;; remove exhausted pile
        ]
    ]
    items
]

probe patience-sort [3 1 2 8 5 7 9 4 6]
