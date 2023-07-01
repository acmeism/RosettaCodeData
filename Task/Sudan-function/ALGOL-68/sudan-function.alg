BEGIN # compute some values of the Sudan function                          #
    PROC sudan = ( INT n, x, y )INT:
         IF   n = 0 THEN x + y
         ELIF y = 0 THEN x
         ELSE
             INT s = sudan( n, x, y - 1 );
             sudan( n - 1, s, s + y )
         FI # sudan # ;
    FOR n FROM 0 TO 1 DO
        print( ( "Values of F(", whole( n, 0 ), ", x, y):", newline ) );
        print( ( "y/x    0   1   2   3   4   5",            newline ) );
        print( ( "----------------------------",            newline ) );
        FOR y FROM 0 TO 6 DO
            print( ( whole( y, 0 ), "  |" ) );
            FOR x FROM 0 TO 5 DO
                print( ( whole( sudan( n, x, y ), -4 ) ) )
            OD;
            print( ( newline ) )
        OD;
        print( ( newline ) )
    OD;
    print( ( newline ) );
    print( ( "F(2, 1, 1) = ", whole( sudan( 2, 1, 1 ), 0 ), newline ) );
    print( ( "F(3, 1, 1) = ", whole( sudan( 3, 1, 1 ), 0 ), newline ) );
    print( ( "F(2, 2, 1) = ", whole( sudan( 2, 2, 1 ), 0 ), newline ) )
END
