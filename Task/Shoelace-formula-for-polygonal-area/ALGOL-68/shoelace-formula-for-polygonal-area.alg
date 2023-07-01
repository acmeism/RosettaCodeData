BEGIN
    # returns the area of the polygon defined by the points p using the Shoelace formula #
    OP  AREA = ( [,]REAL p )REAL:
        BEGIN
            [,]REAL points = p[ AT 1, AT 1 ]; # normalise array bounds to start at 1 #
            IF 2 UPB points /= 2 THEN
                # the points do not have 2 coordinates #
                -1
            ELSE
                REAL   result := 0;
                INT    n       = 1 UPB points;
                IF n > 1 THEN
                    # there at least two points #
                    []REAL x   = points[ :, 1 ];
                    []REAL y   = points[ :, 2 ];
                    FOR i TO 1 UPB points - 1 DO
                        result +:= x[ i     ] * y[ i + 1 ];
                        result -:= x[ i + 1 ] * y[ i     ]
                    OD;
                    result     +:= x[ n ] * y[ 1 ];
                    result     -:= x[ 1 ] * y[ n ]
                FI;
                ( ABS result ) / 2
            FI
        END # AREA # ;

    # test case as per the task #
    print( ( fixed( AREA [,]REAL( ( 3.0, 4.0 ), ( 5.0, 11.0 ), ( 12.0, 8.0 ), ( 9.0, 5.0 ), ( 5.0, 6.0 ) ), -6, 2 ), newline ) )
END
