USING: grouping io kernel lists lists.lazy math math.functions
math.primes prettyprint sequences tools.memory.private ;

: seed? ( n -- ? )
    { 1 2 3 4 } [ dupd ^ 1 + + prime? ] with all? ;

: quads ( -- list )
    1 lfrom [ seed? ] lfilter [ commas ] lmap-lazy ;

"First fifty quad-power prime seeds:" print
50 quads ltake list>array 10 group simple-table.
