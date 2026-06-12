USING: grouping grouping.extras io kernel math math.primes
math.ranges math.text.utils prettyprint sequences ;

: strange+? ( n -- ? )
    dup 10 < [ drop f ]
    [ 1 digit-groups [ + ] 2 clump-map [ prime? ] all? ] if ;

"Strange plus numbers in (100, 500):" print nl
100 500 (a,b) [ strange+? ] filter dup
10 group [ [ pprint bl ] each nl ] each nl
length pprint " strange plus numbers found." print
