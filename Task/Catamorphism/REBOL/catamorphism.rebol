Rebol [
    title: "Rosetta code: Catamorphism"
    file:  %Catamorphism.r3
    url:   https://rosettacode.org/wiki/Catamorphism
]

fold: function [
    "Reduce a series to a single value by applying a binary action to an accumulator."
    list   [series!]              "Input series to fold"
    action [block! any-function!] "Binary action: function(acc val) or block using words `acc` and `val`"
    /init acc                     "Supply an explicit initial accumulator; default uses first element"
][
    unless init [
        acc: first list  ;; seed accumulator with first element
        list: next list  ;; skip it to avoid double-counting
    ]
    either any-function? :action [
        foreach val list [acc: action acc val] ;; native function path
    ][
        f: function [acc val] action           ;; wrap block as reusable function
        foreach val list [acc: f acc val]
    ]
    acc
]

;; -- tests --
parse [
    "sum / product (basic)"
    [fold [1 2 3 4 5] :add         ]
    [fold [1 2 3 4 5] [acc * val]  ]

    "maximum / minimum without max/min native"
    [fold [3 1 4 1 5 9 2 6] [either acc > val [acc][val]]]

    "flatten a block of blocks"
    [fold [[1 2][3 4][5 6]] :append]

    "count occurrences into a map"
    [fold/init [a b a c b a] [acc/:val: 1 + any [acc/:val 0] acc] #[]]

    "build a string with separator"
    [fold/init ["foo" "bar" "baz"] [
        either empty? acc [val][rejoin [acc ", " val]]
    ] ""]

    "running max index (track which element was biggest)"
    [fold/init [3 1 4 1 5 9 2] [
        acc/i: acc/i + 1
        if val > acc/best [acc/best: val acc/at: acc/i]
        acc
    ] #[i: 0 best: -1]]
][
    any [
          set title: string! (print [lf as-yellow title])
        | set code: block! (
            print [
                mold/only code
                as-yellow "=="
                as-green mold try code
            ]
        )
        | skip
    ]
]
