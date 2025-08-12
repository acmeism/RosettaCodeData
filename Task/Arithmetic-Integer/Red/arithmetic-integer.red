Red [ "Arithmetic / Integers" ]

;-- Modulo and // in Red are Euclidean modulo, so the correct integer (Euclidean) division must satisfy:
; a = b * div(a,b) + mod(a,b)
; with 0 <= mod(a,b) < |b|
; This is a custom operator to accompany the built-in Euclidean modulo
ediv: make op! function [a b] [
    either b > 0
        [ to-integer round/floor a / b ]    ;b > 0: floor toward -inf
        [ to-integer round/ceiling a / b ]  ;b < 0: ceiling toward +inf
]
; Python-style divmod:
edivmod: make op! function [a b] [ compose [(a ediv  b) (a // b)] ]

;-- C-style truncated integer division:
quot:    make op! function [a b] [ to-integer a / b ] ;truncated toward zero
; Haskell-style quotrem:
quotrem: make op! function [a b] [ compose [(a quot b) (a % b)] ]; reduce [a quot b  a % b] ]       ; rounds -> 0

while [(s: ask "^/Enter two integer separated with space (q = quit): ") <> "q"] [
    s: load rejoin ["[" s "]"]  a: s/1  b: s/2

    print ["Sum             :" a "+" b "        = " a + b]
    print ["Difference      :" a "-" b "        = " a - b]
    print ["Product         :" a "*" b "        = " a * b]

    print "^/Red's Euclidean Division:"
    print ["eDiv            :" a "eDiv " b "  = " a eDiv b]
    print ["modulo          : modulo" a b " = " modulo a b] ;non-negative
    print ["//              :" a "//" b "     = " a // b]   ;operator form
    print ["eDivMod         :" a "eDivMod" b "= " mold a eDivMod b]
    print rejoin ["Check: ("a" eDiv " b") * "b" + ("a" // "b") = "a" ? " (a eDiv b) * b + (a // b) = a]

    print "^/Red's C-style truncated integer division:"
    print ["quot            :" a "quot" b "      = " a quot b]
    print ["remainder       : remainder" a b " = " remainder a b] ;sign as dividend
    print ["%               :" a "%" b "         = " a % b]       ;operator form
    print ["quotRem         :" a "quotRem" b "   = " mold a quotRem b]
    print rejoin ["Check: ("a" quot " b") * "b" + ("a" % "b") = "a" ? " (a quot b) * b + (a % b) = a]

    print ["^/Exponentiation  :" a "**" b "     = " a ** b]
]
