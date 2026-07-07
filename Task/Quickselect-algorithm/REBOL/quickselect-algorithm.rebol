Rebol [
    title: "Rosetta code: Quickselect algorithm"
    file:  %Quickselect_algorithm.r3
    url:   https://rosettacode.org/wiki/Quickselect_algorithm
]

quickselect: function [
    "Returns the nth smallest value in list (1-based, modifies list in place)"
    list [block!] left [integer!] right [integer!] n [integer!]
][
    forever [
        if left = right [return list/:left]
        ;; partition around a random pivot
        pivot: left + random (right - left)
        pivot-val: list/:pivot
        swap at list pivot at list right     ;; move pivot to end
        store: left
        for i left right 1 [
            if list/:i < pivot-val [
                swap at list store at list i ;; push smaller values left
                ++ store
            ]
        ]
        swap at list right at list store     ;; place pivot in final position
        pivot: store
        case [
            n = pivot [return list/:n  ]
            n < pivot [right: pivot - 1]
            n > pivot [left:  pivot + 1]
        ]
    ]
]

vec: [9 8 7 6 5 0 1 2 3 4]
repeat i 10 [
    print [pad i -2 "vec:" mold vec "=" quickselect vec 1 length? vec i]
]
