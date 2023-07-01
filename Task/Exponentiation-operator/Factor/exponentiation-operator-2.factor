: pow ( f n -- f' )
    {
        { [ dup 0 < ] [ abs pow recip ] }
        { [ dup 0 = ] [ 2drop 1 ] }
        [ [ 2 mod 1 = swap 1 ? ] [ [ sq ] [ 2 /i ] bi* pow ] 2bi * ]
    } cond ;
