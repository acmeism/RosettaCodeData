USING: formatting grouping io kernel lists lists.lazy math
math.parser math.primes math.primes.factors prettyprint ranges
sequences sequences.extras ;

: rhonda? ( n base -- ? )
    [ [ >base 1 group ] keep '[ _ base> ] map-product ]
    [ swap factors sum * ] 2bi = ;

: rhonda ( base -- list ) 1 lfrom swap '[ _ rhonda? ] lfilter ;

: list. ( list base -- ) '[ _ >base write bl ] leach nl ;

:: rhonda. ( base -- )
    15 base rhonda ltake :> r
    base "First 15 Rhonda numbers to base %d:\n" printf
    "In base 10: " write r 10 list.
    base "In base %d: " printf r base list. ;

2 36 [a..b] [ prime? not ] filter [ rhonda. nl ] each
