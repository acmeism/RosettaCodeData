Rebol [
    title: "Rosetta code: Sorting algorithms/Radix sort"
    file:  %Sorting_algorithms-Radix_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms-Radix_sort
]

radix-sort: function [
    "Sorts a block of integers using radix sort (LSD)"
    data [block!] "Block of integers to sort"
    /base radix [integer!] "Number base (default 10)"
][
    if empty? data [return copy []]

    max-val: -1e300
    min-val:  1e300
    foreach num data [
        unless integer? num [
            do make error! "Invalid input. Radix-sort expects integers!"
        ]
        if max-val < num [max-val: num]
        if min-val > num [min-val: num]
    ]
    if min-val < 0 [
        max-val: max-val - min-val
        data: map-each v data [v - min-val]
    ]

    radix: any [radix 10]
    exp: 1 ;; current digit position (1, radix, radix^2, ...)

    ;; pre-allocate one bucket per digit
    buckets: clear []
    loop radix [append/only buckets copy []]

    while [max-val / exp >= 1][
        ;; clear buckets from previous pass
        forall buckets [clear buckets/1]

        ;; distribute: each number goes into the bucket for its current digit
        foreach num data [
            digit: 1 + to integer! (num / exp) % radix
            append buckets/:digit num
        ]

        ;; collect buckets back into data in order
        clear data
        forall buckets [append data buckets/1]

        exp: exp * radix  ;; advance to next digit position
    ]
    if min-val < 0 [data: map-each v data [v + min-val]]
    data
]

probe radix-sort [-3 1 -2 8 5 7 9 4 6 3 -1 2 8 5 7 9 4 6]
