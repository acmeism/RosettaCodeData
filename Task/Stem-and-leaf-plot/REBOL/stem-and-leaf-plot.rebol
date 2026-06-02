Rebol [
    title: "Rosetta code: Stem-and-leaf plot"
    file:  %Stem-and-leaf_plot.r3
    url:   https://rosettacode.org/wiki/Stem-and-leaf_plot
]

stem-and-leaf-plot: function [
    "Print a stem-and-leaf plot from a block of integers."
    data [block!] "Block of integer values to plot"
][
    ;; Group leaf digits (units) by stem (tens and above), sorting as we go
    tens: make map! []
    foreach n sort data [
        key: n // 10                                    ;; stem  = everything above units
        unless blk: tens/:key [tens/:key: blk: copy []] ;; create bucket on first use
        append blk n % 10                               ;; leaf  = units digit
    ]
    ;; Print each row from stem 0 up to the largest stem found
    for i 0 key 1 [
        printf [-3 " | "][i mold/flat/only any [tens/:i []]]
    ]
]

stem-and-leaf-plot [
    12 127 28 42 39 113 42 18 44 118 44 37 113 124 37 48 127 36
    29 31 125 139 131 115 105 132 104 123 35 113 122 42 117 119
    58 109 23 105 63 27 44 105 99 41 128 121 116 125 32 61 37
    127 29 113 121 58 114 126 53 114 96 25 109 7 31 141 46 13 27
    43 117 116 27 7 68 40 31 115 124 42 128 146 52 71 118 117 38
    27 106 33 117 116 111 40 119 47 105 57 122 109 124 115 43
    120 43 27 27 18 28 48 125 107 114 34 133 45 120 30 127 31 116
]
