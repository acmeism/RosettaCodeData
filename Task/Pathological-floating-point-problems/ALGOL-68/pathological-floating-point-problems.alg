BEGIN

    # show the sizes of REAL, LONG REAL and LONG LONG real #
    print( ( "Approximate sizes of real numbers available: " ) );
    print( ( "REAL: ",                         whole(           real width, 0 ) ) );
    print( ( ", LONG REAL: ",                  whole(      long real width, 0 ) ) );
    print( ( ", default for LONG LONG REAL: ", whole( long long real width, 0 ) ) );
    print( ( newline, newline ) );

    # task 1 #
    BEGIN
        print( ( whole( long real width, -4 ), " digit REAL numbers", newline ) );
        [ 1 : 100 ]LONG REAL v;
        v[ 1 ] := 2;
        v[ 2 ] := -4;
        FOR n FROM 3 TO UPB v DO v[ n ] := 111 - ( 1130 / v[ n - 1 ] ) + ( 3000 / ( v[ n - 1 ] * v[ n - 2 ] ) ) OD;
        FOR n FROM  3 TO  8       DO print( ( "n = ", whole( n, 3 ), " ", fixed( v[ n ], -22, 16 ), newline ) ) OD;
        FOR n FROM 20 BY 10 TO 50 DO print( ( "n = ", whole( n, 3 ), " ", fixed( v[ n ], -22, 16 ), newline ) ) OD;
        print( ( "n = 100 ", fixed( v[ 100 ], -22, 16 ), newline ) )
    END;
    BEGIN
        print( ( whole( long long real width, -4 ), " digit REAL numbers", newline ) );
        [ 1 : 100 ]LONG LONG REAL v;
        v[ 1 ] := 2;
        v[ 2 ] := -4;
        FOR n FROM 3 TO UPB v DO v[ n ] := 111 - ( 1130 / v[ n - 1 ] ) + ( 3000 / ( v[ n - 1 ] * v[ n - 2 ] ) ) OD;
        print( ( "n = 100 ", fixed( v[ 100 ], -22, 16 ), newline ) )
    END;
    print( ( newline ) );
    # task 2 #
    BEGIN
        print( ( "standard precision REAL numbers...", newline ) );
        REAL chaotic balance := exp( 1 ) - 1;
        print( ( "           initial chaotic balance: ", fixed( chaotic balance, -22, 16 ), newline ) );
        FOR i FROM 1 TO 25 DO ( chaotic balance *:= i ) -:= 1 OD;
        print( ( "           25 year chaotic balance: ", fixed( chaotic balance, -22, 16 ), newline ) )
    END;
    BEGIN
        print( ( "double precision LONG REAL numbers...", newline ) );
        LONG REAL chaotic balance := long exp( 1 ) - 1;
        print( ( "           initial chaotic balance: ", fixed( chaotic balance, -22, 16 ), newline ) );
        FOR i FROM 1 TO 25 DO ( chaotic balance *:= i ) -:= 1 OD;
        print( ( "           25 year chaotic balance: ", fixed( chaotic balance, -22, 16 ), newline ) )
    END;
    BEGIN
        print( ( whole( long long real width, -10 ), " digit LONG LONG REAL numbers...", newline ) );
        LONG LONG REAL chaotic balance := long long exp( 1 ) - 1;
        print( ( "           initial chaotic balance: ", fixed( chaotic balance, -22, 16 ), newline ) );
        FOR i FROM 1 TO 25 DO ( chaotic balance *:= i ) -:= 1 OD;
        print( ( "           25 year chaotic balance: ", fixed( chaotic balance, -22, 16 ), newline ) )
    END
END
