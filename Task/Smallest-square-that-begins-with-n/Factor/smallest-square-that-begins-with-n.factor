USING: arrays combinators.short-circuit.smart formatting io
kernel math sequences ;

[let
    50 :> lim
    lim 0 <array> :> res
    1 0 :> ( n! found! )
    [ found lim 1 - < ] [
        n dup * :> n2!
        [ n2 zero? ] [
            { [ n2 lim < ] [ n2 res nth zero? ] } &&
            [ found 1 + found! n n2 res set-nth ] when
            n2 10 /i n2!
        ] until
        n 1 + n!
    ] while
    res rest
]

"Smallest square that begins with..." print
[ 1 + swap [ sq ] keep "%2d: %5d (%3d^2)\n" printf ]
each-index
