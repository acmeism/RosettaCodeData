BEGIN # Super-d numbers - translation of the FreeBASIC sample #

    []STRING rd = ( "1", "22", "333", "4444", "55555", "666666", "7777777", "88888888", "999999999" );

    FOR n FROM 2 TO 7 DO
        INT sd count := 0;

        print( ( "super-", whole( n, 0 ), " numbers: " ) );
        LONG LONG INT j := 3;
        WHILE sd count < 10 DO
            IF string in string( rd[ n ], REF INT(NIL), whole( n * ( j ^ n ), 0 ) ) THEN
                sd count +:= 1;
                print( ( " ", whole( j, 0 ) ) )
            FI;
            j +:= 1
        OD;
        print( ( newline ) )
    OD
END
