USING: formatting kernel math math.ranges random sequences ;
IN: rosetta-code.unbias

: randN ( n -- m ) random zero? 1 0 ? ;

: unbiased ( n -- m )
    dup [ randN ] dup bi 2dup = not
    [ drop nip ] [ 2drop unbiased ] if ;

: test-generator ( quot -- x )
    [ 1,000,000 dup ] dip replicate sum 100 * swap / ; inline

: main ( -- )
    3 6 [a,b] [
        dup [ randN ] [ unbiased ] bi-curry
        [ test-generator ] bi@ "%d: %.2f%%  %.2f%%\n" printf
    ] each ;

MAIN: main
