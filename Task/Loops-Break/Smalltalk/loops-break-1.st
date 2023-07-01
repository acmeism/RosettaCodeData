[
    |first second done|

    first := Random nextIntegerBetween:0 and:19.
    Stdout print:first; cr.
    (done := (first == 10)) ifFalse:[
        second := Random nextIntegerBetween:0 and:19.
        Stdout print:' '; print:second; cr.
    ].
    done
] whileFalse
