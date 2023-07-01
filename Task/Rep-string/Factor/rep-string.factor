USING: formatting grouping kernel math math.ranges qw sequences ;
IN: rosetta-code.rep-string

: (find-rep-string) ( str -- str )
    dup dup length 2/ [1,b]
    [ <groups> [ head? ] monotonic? ] with find nip dup
    [ head ] [ 2drop "N/A" ] if ;

: find-rep-string ( str -- str )
    dup length 1 <= [ drop "N/A" ] [ (find-rep-string) ] if ;

qw{ 1001110011 1110111011 0010010010 1010101010 1111111111
    0100101101 0100100 101 11 00 1 }
"Shortest cycle:\n\n" printf
[ dup find-rep-string "%-10s -> %s\n" printf ] each
