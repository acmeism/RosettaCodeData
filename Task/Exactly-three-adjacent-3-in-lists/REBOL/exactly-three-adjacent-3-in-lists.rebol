Rebol [
    title: "Rosetta code: Exactly three adjacent 3 in lists"
    file:  %Exactly_three_adjacent_3_in_lists.r3
    url:   https://rosettacode.org/wiki/Exactly_three_adjacent_3_in_lists
]
n-consecutive: func [
    "Returns true if the value n appears exactly n times in a row in 'list'"
    n [integer!] list [block!]
    /local pos
][
    to logic! all [
        list: find list n                 ;; find the first occurrence of n
        loop n [                          ;; verify the next n items are all n
            if list/1 <> n [return false] ;; fail early if any item in the run differs
            list: next list               ;; advance to the next position
        ]
        none? find list n  ;; ensure the run is exactly n long (no extra n immediately after)
    ]
]

repeat n 4 [
    print ajoin ["Exactly " n " " n "s, and they are consecutive:"]
    foreach list [
        [9 3 3 3 2 1 7 8 5]
        [5 2 9 3 3 7 8 4 1]
        [1 4 3 6 7 3 8 3 2]
        [1 2 3 4 5 6 7 8 9]
        [4 6 8 7 2 3 3 3 1]
        [3 3 3 1 2 4 5 1 3]
        [0 3 3 3 3 7 2 2 6]
        [3 3 3 3 3 4 4 4 4]
    ][
        print ["  " mold list "->" n-consecutive n list]
    ]
]
