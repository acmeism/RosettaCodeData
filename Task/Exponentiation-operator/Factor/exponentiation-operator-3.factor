USING: combinators kernel math ;
IN: test

: (pow) ( f n -- f' )
    [ dup even? ] [ [ sq ] [ 2 /i ] bi* ] while
    dup 1 = [ drop ] [ dupd 1 - (pow) * ] if ;

: pow ( f n -- f' )
    {
        { [ dup 0 < ] [ abs (pow) recip ] }
        { [ dup 0 = ] [ 2drop 1 ] }
        [ (pow) ]
    } cond ;
