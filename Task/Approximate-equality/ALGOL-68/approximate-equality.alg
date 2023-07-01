BEGIN # test REAL values for approximate equality #
    # returns TRUE if value is approximately equal to other, FALSE otherwide #
    PROC approx equals = ( REAL value, REAL other, REAL epsilon )BOOL: ABS ( value - other ) < epsilon;
    # shows the result of testing a for approximate equality with b #
    PROC test = ( REAL a, b )VOID:
         BEGIN
            REAL epsilon = 1e-18;
            print( ( a, ", ", b, " => ", IF approx equals( a, b, epsilon ) THEN "true" ELSE "false" FI, newline ) )
         END # test # ;
    # task test cases #
    test( 100000000000000.01, 100000000000000.011 );
    test( 100.01, 100.011 );
    test( 10000000000000.001 / 10000.0, 1000000000.0000001000);
    test( 0.001, 0.0010000001 );
    test( 0.000000000000000000000101, 0.0 );
    test(   sqrt( 2 ) * sqrt( 2 ),  2.0 );
    test( - sqrt( 2 ) * sqrt( 2 ), -2.0 );
    test( 3.14159265358979323846, 3.14159265358979324 )
END
