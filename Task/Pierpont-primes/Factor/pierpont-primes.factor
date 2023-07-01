USING: fry grouping io kernel locals make math math.functions
math.primes prettyprint sequences sorting ;

: pierpont ( ulim vlim quot -- seq )
    '[
        _ <iota> _ <iota> [
            [ 2 ] [ 3 ] bi* [ swap ^ ] 2bi@ * 1 @
            dup prime? [ , ] [ drop ] if
        ] cartesian-each
    ] { } make natural-sort ; inline

: .fifty ( seq -- ) 50 head 10 group simple-table. nl ;

[let
    [ + ] [ - ] [ [ 120 80 ] dip pierpont ] bi@
    :> ( first second )

    "First 50 Pierpont primes of the first kind:" print
    first .fifty

    "First 50 Pierpont primes of the second kind:" print
    second .fifty

    "250th Pierpont prime of the first kind: " write
    249 first nth . nl

    "250th Pierpont prime of the second kind: " write
    249 second nth .
]
