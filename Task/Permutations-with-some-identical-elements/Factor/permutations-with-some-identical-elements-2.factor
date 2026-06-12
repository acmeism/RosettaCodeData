USING: arrays io kernel locals math math.ranges sequences ;
IN: rosetta-code.distinct-permutations

: should-swap? ( start curr seq -- ? )
    [ nipd nth ] [ <slice> member? not ] 3bi ;

:: .find-permutations ( seq index n -- )
    index n >= [ seq write bl ] [
        index n [a,b) [
            :> i
            index i seq should-swap? [
                index i seq exchange
                seq index 1 + n .find-permutations
                index i seq exchange
            ] when
        ] each
    ] if ;

: first-permutation ( nums charset -- seq )
    [ <array> ] 2map "" concat-as ;

: .distinct-permutations ( nums charset -- )
    first-permutation 0 over length .find-permutations nl ;

: main ( -- )
    { 2 1 } "12"
    { 2 3 1 } "123"
    { 2 3 1 } "ABC"
    [ .distinct-permutations ] 2tri@ ;

MAIN: main
