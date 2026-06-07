Rebol [
    title: "Rosetta code: Chinese remainder theorem"
    file:  %Chinese_remainder_theorem.r3
    url:   https://rosettacode.org/wiki/Chinese_remainder_theorem
]

mul-inv: function [
    "Modular multiplicative inverse of a modulo b (extended Euclidean algorithm)."
    a [integer!]
    b [integer!]
][
    if b = 1 [return 1]
    b0: b                 ;; keep original b to adjust negative result at the end
    x0: 0 x1: 1
    while [a > 1] [
        q: a // b
        b: a % a: b                       ;; swap: a,b <- b, a mod b
        x0: x1 - (q * x1: x0)             ;; update Bezout coefficients
    ]
    either x1 < 0 [ x1 + b0 ][ x1 ]       ;; ensure positive result
]

chinese-remainder: function [
    "Solve system of congruences by Chinese Remainder Theorem."
    moduli     [block!]
    remainders [block!]
][
    prod: 1
    forall moduli [prod: prod * moduli/1] ;; product of all moduli
    sum:  0
    repeat i length? moduli [
        p:  prod / moduli/:i              ;; partial product excluding moduli/:i
        sum: sum + (remainders/:i * (mul-inv p moduli/:i) * p)
    ]
    sum % prod                            ;; reduce final sum
]

print chinese-remainder [3 5 7] [2 3 2]
