USING: formatting grouping io kernel lists lists.lazy math
math.functions math.primes sequences ;

: under ( list n -- list' ) '[ _ < ] lwhile ;

: (surrounded) ( n -- list )
    [ 1list 1 lfrom ] keep dup dup
    '[ 10^ _ * _ + [ [ 10 + ] lfrom-by ] keep dup _ / + 10 - under ]
    lmap-lazy lconcat lappend-lazy ;

: surrounded ( n upto -- list )
    [ (surrounded) ] [ under ] bi* [ prime? ] lfilter ;

: surrounded. ( n -- )
    dup "Primes under 10,000 beginning and ending with %d:\n" printf
    10,000 surrounded list>array 10 group
    [ [ "%6d" printf ] each nl ] each nl ;

{ 1 3 5 7 9 } [ surrounded. ] each

3 1,000,000 surrounded llength
"Found %d primes beginning and ending with 3 under 1,000,000.\n" printf
