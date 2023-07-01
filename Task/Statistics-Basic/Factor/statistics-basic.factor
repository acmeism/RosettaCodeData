USING: assocs formatting grouping io kernel literals math
math.functions math.order math.statistics prettyprint random
sequences sequences.deep sequences.repeating ;
IN: rosetta-code.statistics-basic

CONSTANT: granularity
    $[ 11 iota [ 10 /f ] map 2 clump ]

: mean/std ( seq -- a b )
    [ mean ] [ population-std ] bi ;

: .mean/std ( seq -- )
    mean/std [ "Mean: " write . ] [ "STD:  " write . ] bi* ;

: count-between ( seq a b -- n )
    [ between? ] 2curry count ;

: histo ( seq -- seq )
    granularity [ first2 count-between ] with map ;

: bar ( n -- str )
    [ dup 50 < ] [ 10 / ] until 2 * >integer "*" swap repeat ;

: (.histo) ( seq -- seq' )
    [ bar ] map granularity swap zip flatten 3 group ;

: .histo ( seq -- )
    (.histo) [ "%.1f - %.1f %s\n" vprintf ] each ;

: stats ( n -- )
    dup "Statistics %d:\n" printf
    random-units [ histo .histo ] [ .mean/std nl ] bi ;

: main ( -- )
    { 100 1,000 10,000 } [ stats ] each ;

MAIN: main
