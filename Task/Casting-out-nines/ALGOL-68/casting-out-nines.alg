BEGIN # casting out nines - translated from the Action! sample #
    INT base   = 10;
    INT n      =  2;
    INT count :=  0;
    INT total :=  0;
    FOR i TO base ^ n DO
        total +:= 1;
        IF i MOD ( base - 1 ) = ( i * i ) MOD ( base - 1 ) THEN
            count +:= 1;
            print( ( whole( i, 0 ), " " ) )
        FI
    OD;
    print( ( newline, newline, "Trying ", whole( count, 0 )
           , " numbers instead of ", whole( total, 0 )
           , " numbers saves ", fixed( 100 - ( ( 100 * count ) / total ), -6, 2 )
           , "%", newline
           )
         )
END
