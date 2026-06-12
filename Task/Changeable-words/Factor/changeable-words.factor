USING: assocs combinators.short-circuit formatting
io.encodings.ascii io.files kernel math math.combinatorics
math.distances sequences ;

: changeable? ( str str -- ? )
    { [ [ length ] bi@ = ] [ hamming-distance 1 = ] } 2&& ;

"unixdict.txt" ascii file-lines
[ length 11 > ] filter
2 [ first2 changeable? ] filter-combinations
[ "%s <-> %s\n" printf ] assoc-each
