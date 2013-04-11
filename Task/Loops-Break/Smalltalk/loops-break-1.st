[
    |a b done|

    a := Random nextIntegerBetween:0 and:19.
    Stdout print: a; cr.
    (done := (a == 10)) ifFalse:[
        b := Random nextIntegerBetween:0 and:19.
        Stdout print:' '; print: b; cr.
    ].
    done
] whileFalse
