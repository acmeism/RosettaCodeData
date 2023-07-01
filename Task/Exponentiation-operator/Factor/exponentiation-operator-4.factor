: (pow) ( f n -- f' )
    [ 1 ] 2dip
    [ dup 1 = ] [
        dup even? [ [ sq ] [ 2 /i ] bi* ] [ [ [ * ] keep ] dip 1 - ] if
    ] until
    drop * ;
