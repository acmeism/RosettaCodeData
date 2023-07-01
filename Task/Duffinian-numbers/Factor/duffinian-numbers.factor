USING: combinators.short-circuit.smart grouping io kernel lists
lists.lazy math math.primes math.primes.factors math.statistics
prettyprint sequences sequences.deep ;

: duffinian? ( n -- ? )
    { [ prime? not ] [ dup divisors sum simple-gcd 1 = ] } && ;

: duffinians ( -- list ) 3 lfrom [ duffinian? ] lfilter ;

: triples ( -- list )
    duffinians dup cdr dup cdr lzip lzip [ flatten ] lmap-lazy
    [ differences { 1 1 } = ] lfilter ;

"First 50 Duffinian numbers:" print
50 duffinians ltake list>array 10 group simple-table. nl

"First 15 Duffinian triplets:" print
15 triples ltake list>array simple-table.
