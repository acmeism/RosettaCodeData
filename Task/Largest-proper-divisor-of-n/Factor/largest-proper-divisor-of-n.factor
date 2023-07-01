USING: grouping kernel math math.bitwise math.functions
math.ranges prettyprint sequences ;

: odd ( m -- n )
    dup 3 /i 1 - next-odd 1 -2 <range>
    [ divisor? ] with find nip ;

: largest ( m -- n ) dup odd? [ odd ] [ 2/ ] if ;

100 [1,b] [ largest ] map 10 group simple-table.
