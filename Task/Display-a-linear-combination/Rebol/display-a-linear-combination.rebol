Rebol [
    title: "Rosetta code: Display a linear combination"
    file:  %Display_a_linear_combination.r3
    url:    https://rosettacode.org/wiki/Display_a_linear_combination
    needs: 3.10.0 ;; or something like that (pad/ajoin)
]

display-linear-combination: function [
    vec [block! vector!] "Vector of coefficients"
][
    terms: copy ""
    repeat i length? vec [
        coeff: vec/:i
        if coeff <> 0 [
            ;; build "c * e(k)" term
            append terms ajoin [
                unless empty? terms [" + "]
                pad coeff -2
                " * e(" i ")"
            ]
        ]
    ]
    print ajoin [
        pad mold vec -15 ;; padded input
        " -> "
        terms
    ]
]

;; Test output...
foreach v [
    [1 2 3]
    [0 1 2 3]
    [1 0 3 4]
    [1 2 0]
    [0 0 0]
    [0]
    [1 1 1]
    [-1 -1 -1]
    [-1 -2 0 -3]
    [-1]
][
    display-linear-combination v
]
