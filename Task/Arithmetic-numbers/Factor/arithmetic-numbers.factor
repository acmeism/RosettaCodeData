USING: combinators formatting grouping io kernel lists
lists.lazy math math.functions math.primes math.primes.factors
math.statistics math.text.english prettyprint sequences
tools.memory.private ;

: arith? ( n -- ? ) divisors mean integer? ;
: larith ( -- list ) 1 lfrom [ arith? ] lfilter ;
: arith ( m -- seq ) larith ltake list>array ;
: composite? ( n -- ? ) dup 1 > swap prime? not and ;
: ordinal ( n -- str ) [ commas ] keep ordinal-suffix append ;

: info. ( n -- )
    {
        [ ordinal "%s arithmetic number: " printf ]
        [ arith dup last commas print ]
        [ commas "Number of composite arithmetic numbers <= %s: " printf ]
        [ drop [ composite? ] count commas print nl ]
    } cleave ;


"First 100 arithmetic numbers:" print
100 arith 10 group simple-table. nl
{ 3 4 5 6 } [ 10^ info. ] each
