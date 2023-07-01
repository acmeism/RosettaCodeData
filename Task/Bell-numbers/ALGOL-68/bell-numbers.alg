BEGIN # show some Bell numbers #
    PROC show bell = ( INT n, LONG LONG INT bell number )VOID:
         print( ( whole( n, -2 ), ": ", whole( bell number, 0 ), newline ) );
    INT max bell = 50;
    [ 0 : max bell - 2 ]LONG LONG INT a; FOR i TO UPB a DO a[ i ] := 0 OD;
    a[ 0 ] := 1;
    show bell( 1, a[ 0 ] );
    FOR n FROM 0 TO UPB a DO
        # replace a with the next line of the triangle #
        a[ n ] := a[ 0 ];
        FOR j FROM n BY -1 TO 1 DO
            a[ j - 1 ] +:= a[ j ]
        OD;
        IF   n < 14       THEN
            show bell( n + 2, a[ 0 ] )
        ELIF n = UPB a THEN
            print( ( "...", newline ) );
            show bell( n + 2, a[ 0 ] )
        FI
    OD
END
