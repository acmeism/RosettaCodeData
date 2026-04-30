Rebol [
    title: "Rosetta code: Loops/With multiple ranges"
    file: %Loops-With_multiple_ranges.r3
    url: https://rosettacode.org/wiki/Loops/With_multiple_ranges
    needs: 3.0.0
    note: {Based on Rosetta Code Red language task solution}
]
;; Define a function that iterates over multiple ranges
for-ranges: function/with ['word ranges body][
    ;; Clear temporary buffer
    inp: clear []
    ;; Bind ranges dialect to context of this function
    bind ranges self
    foreach c reduce ranges [append inp c]
    foreach i inp [set word i do body]
] context [
    inp: copy []
    ;; Define a custom operator 'to' that creates a range from start to end
    ;- Note: `to` function redefinition!
    to: make op! function [start end][
        res: copy []
        repeat n 1 + absolute to-integer end - start [
            append res start + either start > end [1 - n][n - 1]
        ]
    ]
    ;; Define a custom operator 'by' that extracts every nth element from a series
    by: make op! function [s w] [extract s absolute w]
]

;; Initialize variables
 prod:  1
  sum:  0
    x: +5
    y: -5
    z: -2
  one:  1
three:  3
seven:  7

;; Execute for-ranges with variable 'j' over multiple range expressions
for-ranges j [
    0 - three to (3 ** 3)   by three
    0 - seven to seven      by x
        555   to (550 - y)
        22    to -28        by (0 - three)
        1927  to 1939
        x     to y          by z
    11 ** x   to (11 ** x + one)
][
    ;; Body of the loop executed for each value of j
    ;; Add absolute value of j to sum
    sum: to-integer sum + absolute j
    ;; Multiply prod by j if conditions are met:
    ;; - absolute value of prod is less than 2^27 (134,217,728)
    ;; - j is not zero (to avoid making prod zero)
    if all [(absolute prod) < power 2 27 j <> 0] [prod: prod * j]
]
;; Print the final results
print ["sum: " sum "^/prod:" prod]
