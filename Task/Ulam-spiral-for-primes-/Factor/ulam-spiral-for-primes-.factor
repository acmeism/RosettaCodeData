USING: arrays grouping kernel math math.combinatorics
math.matrices math.primes math.ranges math.statistics
prettyprint sequences sequences.repeating ;
IN: rosetta-code.ulam-spiral

: counts ( n -- seq ) 1 [a,b] 2 repeat rest ;

: vals ( n -- seq )
    [ -1 swap neg 2dup [ neg ] bi@ 4array ] [ 2 * 1 - cycle ] bi ;

: evJKT2 ( n -- seq )
    [ counts ] [ vals ] bi [ <array> ] 2map concat ;

: spiral ( n -- matrix )
    [ evJKT2 cum-sum inverse-permutation ] [ group ] bi ;

: ulam-spiral ( n -- matrix )
    spiral dup dim first sq 1 -
    [ swap - 1 + prime? "o " "  " ? ] curry matrix-map ;

: ulam-demo ( -- ) 21 ulam-spiral simple-table. ;

MAIN: ulam-demo
