USING: grouping io kernel lists lists.lazy math math.functions
math.primes prettyprint tools.memory.private ;

: seed? ( n -- ? )
    5 [ dupd ^ 1 + + prime? ] with all-integers? ;

: pentas ( -- list )
    1 lfrom [ seed? ] lfilter [ commas ] lmap-lazy ;

"First thirty penta-power prime seeds:" print
30 pentas ltake list>array 5 group simple-table.
