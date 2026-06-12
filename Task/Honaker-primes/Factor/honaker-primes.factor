USING: grouping kernel lists lists.lazy math math.primes.lists
prettyprint sequences ;

: sum-digits ( n -- sum )
    0 swap [ 10 /mod rot + swap ] until-zero ;

: honaker ( -- list )
    1 lfrom lprimes lzip [ first2 [ sum-digits ] same? ] lfilter ;

50 honaker ltake list>array 5 group simple-table.
