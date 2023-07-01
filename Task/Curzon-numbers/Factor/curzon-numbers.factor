USING: grouping interpolate io kernel make math math.functions
prettyprint ranges sequences ;

: curzon? ( k n -- ? ) [ ^ 1 + ] 2keep * 1 + divisor? ;

: next ( k n -- k n' ) [ 2dup curzon? ] [ 1 + ] do until ;

: curzon ( k -- seq )
    1 [ 50 [ dup , next ] times ] { } make 2nip ;

: curzon. ( k -- )
    dup [I Curzon numbers with base ${}:I] nl
    curzon 10 group simple-table. ;

2 10 2 <range> [ curzon. nl ] each
