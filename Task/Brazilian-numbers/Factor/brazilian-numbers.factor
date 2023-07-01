USING: combinators grouping io kernel lists lists.lazy math
math.parser math.primes.lists math.ranges namespaces prettyprint
prettyprint.config sequences ;

: (brazilian?) ( n -- ? )
    2 over 2 - [a,b] [ >base all-equal? ] with find nip >boolean ;

: brazilian? ( n -- ? )
    {
        { [ dup 7 < ] [ drop f ] }
        { [ dup even? ] [ drop t ] }
        [ (brazilian?) ]
    } cond ;

: .20-brazilians ( list -- )
    [ 20 ] dip [ brazilian? ] lfilter ltake list>array . ;

100 margin set
1 lfrom "First 20 Brazilian numbers:"
1 [ 2 + ] lfrom-by "First 20 odd Brazilian numbers:"
lprimes "First 20 prime Brazilian numbers:"
[ print .20-brazilians nl ] 2tri@
