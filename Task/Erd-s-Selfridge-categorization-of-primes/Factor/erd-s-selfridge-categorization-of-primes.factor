USING: assocs combinators formatting grouping grouping.extras io
kernel math math.primes math.primes.factors math.statistics
prettyprint sequences sequences.deep ;

PREDICATE: >3 < integer 3 > ;

GENERIC: depth ( seq -- n )

M: sequence depth
    0 swap [ flatten1 [ 1 + ] dip ] to-fixed-point drop ;

M: integer depth drop 1 ;

MEMO: pfactors ( n -- seq ) 1 + factors ;

: category ( m -- n )
    [ dup >3? [ pfactors ] when ] deep-map depth ;

: categories ( n -- assoc ) nprimes [ category ] collect-by ;

: table. ( seq n -- )
    [ "" pad-groups ] keep group simple-table. ;

: categories... ( assoc -- )
    [ [ "Category %d:\n" printf ] dip 15 table. ] assoc-each ;

: row. ( category first last count -- )
    "Category %d: first->%d last->%d count->%d\n" printf ;

: categories. ( assoc -- )
    [ [ minmax ] keep length row. ] assoc-each ;

200 categories categories... nl
1,000,000 categories categories.
