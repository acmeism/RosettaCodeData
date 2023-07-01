USING: arrays grouping io kernel math math.combinatorics
math.ranges math.statistics prettyprint sequences
sequences.repeating ;
IN: rosetta-code.spiral-matrix

: counts ( n -- seq ) 1 [a,b] 2 repeat rest ;

: vals ( n -- seq )
    [ 1 swap 2dup [ neg ] bi@ 4array ] [ 2 * 1 - cycle ] bi ;

: evJKT2 ( n -- seq )
    [ counts ] [ vals ] bi [ <array> ] 2map concat ;

: spiral ( n -- matrix )
    [ evJKT2 cum-sum inverse-permutation ] [ group ] bi ;

: spiral-demo ( -- ) 5 9 [ spiral simple-table. nl ] bi@ ;

MAIN: spiral-demo
