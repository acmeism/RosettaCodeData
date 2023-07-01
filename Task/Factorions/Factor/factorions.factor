USING: formatting io kernel math math.parser math.ranges memoize
prettyprint sequences ;
IN: rosetta-code.factorions

! Memoize factorial function
MEMO: factorial ( n -- n! ) [ 1 ] [ [1,b] product ] if-zero ;

: factorion? ( n base -- ? )
    dupd >base string>digits [ factorial ] map-sum = ;

: show-factorions ( limit base -- )
    dup "The factorions for base %d are:\n" printf
    [ [1,b) ] dip [ dupd factorion? [ pprint bl ] [ drop ] if ]
    curry each nl ;

1,500,000 9 12 [a,b] [ show-factorions nl ] with each
