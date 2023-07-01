USING: assocs formatting grouping io kernel lists lists.lazy
math math.functions math.primes.factors prettyprint
project-euler.common sequences ;

MEMO: brilliant? ( n -- ? )
    factors [ length 2 = ] keep
    [ number-length ] map all-eq? and ;

: lbrilliant ( -- list )
    2 lfrom [ brilliant? ] lfilter 1 lfrom lzip ;

: first> ( m -- n )
    lbrilliant swap '[ first _ >= ] lfilter car ;

: .first> ( n -- )
    dup first> first2
    "First brilliant number >= %7d: %7d at position %5d\n"
    printf ;

100 lbrilliant ltake list>array keys 10 group simple-table. nl
{ 1 2 3 4 5 6 } [ 10^ .first> ] each
