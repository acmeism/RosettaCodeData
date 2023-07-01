USING: assocs fry kernel make math namespaces prettyprint
sequences ;

: van-eck ( n -- seq )
    [
        0 , 1 - H{ } clone '[
            building get [ length 1 - ] [ last ] bi _ 3dup
            2dup key? [ at - ] [ 3drop 0 ] if , set-at
        ] times
    ] { } make ;

1000 van-eck 10 [ head ] [ tail* ] 2bi [ . ] bi@
