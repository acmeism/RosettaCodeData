USING: assocs grouping grouping.extras io kernel literals math
math.combinatorics math.ranges prettyprint project-euler.common
sequences sequences.extras sets ;

CONSTANT: digits $[ 2 9 [a..b] ]

: (colorful?) ( seq -- ? )
    all-subseqs [ product ] map all-unique? ;

: colorful? ( n -- ? )
    [ t ] [ number>digits (colorful?) ] if-zero ;

: table. ( seq cols -- )
    [ "" pad-groups ] keep group simple-table. ;

: (oom-count) ( n -- count )
    digits swap <k-permutations> [ (colorful?) ] count ;

: oom-count ( n -- count )
    dup 1 = [ drop 10 ] [ (oom-count) ] if ;

"Colorful numbers under 100:" print
100 <iota> [ colorful? ] filter 10 table. nl

"Largest colorful number:" print
digits <permutations> [ (colorful?) ] find-last nip digits>number . nl

"Count of colorful numbers by number of digits:" print
8 [1..b] [ oom-count ] zip-with dup .
"Total: " write values sum .
