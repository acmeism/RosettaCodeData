USING: combinators.short-circuit grouping kernel math
math.functions math.ranges math.text.utils prettyprint sequences ;

: needle? ( n -- ? )
    dup 1 digit-groups dup product
    {
        [ 2nip zero? not ]
        [ nip divisor? not ]
        [ drop [ divisor? ] with all? ]
    } 3&& ;

1000 [1..b] [ needle? ] filter 9 group simple-table.
