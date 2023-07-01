USING: grouping io kernel lists lists.lazy math math.functions
math.primes math.ranges prettyprint sequences ;

: magnanimous? ( n -- ? )
    dup 10 < [ drop t ] [
        dup log10 >integer [1,b] [ 10^ /mod + prime? not ] with
        find nip >boolean not
    ] if ;

: magnanimous ( n -- seq )
    0 lfrom [ magnanimous? ] lfilter ltake list>array ;

: show ( seq from to -- ) rot subseq 15 group simple-table. nl ;

400 magnanimous
[ "First 45 magnanimous numbers" print 0 45 show ]
[ "241st through 250th magnanimous numbers" print 240 250 show ]
[ "391st through 400th magnanimous numbers" print 390 400 show ]
tri
