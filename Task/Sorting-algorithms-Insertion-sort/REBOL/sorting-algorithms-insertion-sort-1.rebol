Rebol [
    title: "Rosetta code: Sorting algorithms/Insertion sort"
    file:  %Sorting_algorithms-Insertion_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Insertion_sort
]

insertion-sort: function [
    "Sort a block in ascending order in-place using insertion sort."
    block [block!] "The block to sort"
][
    i: 2
    n: length? block

    while [i <= n][
        j: i value: block/:i  ;; pick the element to be inserted
        ;; shift elements right until the correct position is found
        while [all [1 < j  value < block/(j - 1)]][
            block/:j: block/(j - 1)
            -- j
        ]
        block/:j: value  ;; drop value into its sorted position
        ++ i
    ]

    block
]
probe insertion-sort [4 2 1 6 9 3 8 7]
probe insertion-sort [
  "---Monday's Child Is Fair of Face (by Mother Goose)---"
  "Monday's child is fair of face;"
  "Tuesday's child is full of grace;"
  "Wednesday's child is full of woe;"
  "Thursday's child has far to go;"
  "Friday's child is loving and giving;"
  "Saturday's child works hard for a living;"
  "But the child that is born on the Sabbath day"
  "Is blithe and bonny, good and gay."
]
;; just by adding the date! type to the local variable value the same function can sort dates.
probe insertion-sort [12-Jan-2015 11-Jan-2015 11-Jan-2016 12-Jan-2014]
