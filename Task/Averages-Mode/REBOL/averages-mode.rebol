Rebol [
    title: "Rosetta code: Averages/Mode"
    file:  %Averages-Mode.r3
    url:   https://rosettacode.org/wiki/Averages/Mode
]

modes: function [
    "Returns the most frequently occurring item(s) in a series."
    data [series!] "Input series (will not be modified)"
][
    sorted: sort copy data
    cur-val: first sorted                    ;; seed with first value
    cur-count:  1                            ;; current run
    best-count: 0                            ;; highest frequency seen so far
    result: copy []

    foreach val next sorted [
        either val == cur-val [
            ++ cur-count                     ;; extend current run
        ][
            case [
                cur-count > best-count [     ;; new sole mode
                    best-count: cur-count
                    append clear result cur-val
                ]
                cur-count == best-count [    ;; tie: add to modes
                    append result cur-val
                ]
            ]
            cur-val: val                     ;; start new run
            cur-count: 1
        ]
    ]
    ;; flush the final run
    case [
        cur-count >  best-count [ reduce [cur-val] ]
        cur-count == best-count [ append result cur-val ]
        'else                   [ result ]
    ]
]

; mode tests:
num-gen: func[n][ collect [loop n [keep random n]] ]
foreach n [5 10 15 20] [
    print ["^/Numbers:" mold x: num-gen n]
    print ["Sorted: "   mold sort x]
    print ["Count:" n "Mode(s):" mold modes x]
]
