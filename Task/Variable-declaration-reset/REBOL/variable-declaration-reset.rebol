Rebol [
    title: "Rosetta code: Variable declaration reset"
    file:  %Variable_declaration_reset.r3
    url:   https://rosettacode.org/wiki/Variable_declaration_reset
]

s: [1 2 2 3 4 4 5]
repeat i length? s [
    curr: s/:i
    ;; print index if current element equals the previous one
    if all [i > 1 curr = prev][ print i ]
    prev: curr
]
