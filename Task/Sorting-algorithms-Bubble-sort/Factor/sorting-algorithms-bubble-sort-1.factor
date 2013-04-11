USING: fry kernel locals math math.order sequences
sequences.private ;
IN: rosetta.bubble

<PRIVATE

:: ?exchange ( i seq quot -- ? )
    i i 1 + [ seq nth-unsafe ] bi@ quot call +gt+ = :> doit?
    doit? [ i i 1 + seq exchange ] when
    doit? ; inline

: 1pass ( seq quot -- ? )
    [ [ length 1 - iota ] keep ] dip
    '[ _ _ ?exchange ] [ or ] map-reduce ; inline

PRIVATE>

: sort! ( seq quot -- )
    over empty?
    [ 2drop ] [ '[ _ _ 1pass ] loop ] if ; inline

: natural-sort! ( seq -- )
    [ <=> ] sort! ;
