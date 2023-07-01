USING: assocs.extras grouping io kernel lists lists.lazy math
math.primes.factors prettyprint ranges sequences ;

: pair-same? ( ... n quot: ( ... m -- ... n ) -- ... ? )
    [ dup 1 + ] dip same? ; inline

: RA-f? ( n -- ? ) [ factors sum ] pair-same? ;
: RA-d? ( n -- ? ) [ group-factors sum-keys ] pair-same? ;
: filter-naturals ( quot -- list ) 1 lfrom swap lfilter ; inline
: RA-f ( -- list ) [ RA-f? ] filter-naturals ;
: RA-d ( -- list ) [ RA-d? ] filter-naturals ;

: list. ( list -- )
    30 swap ltake list>array 10 group simple-table. ;

"First 30 Ruth-Aaron numbers (factors):" print
RA-f list. nl

"First 30 Ruth-Aaron numbers (divisors):" print
RA-d list.
