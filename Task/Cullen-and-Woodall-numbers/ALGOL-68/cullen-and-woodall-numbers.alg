BEGIN # find Cullen and Woodall numbers and determine which are prime #
      # a Cullen number n is n2^2 + 1, Woodall number is n2^n - 1     #
    PR read "primes.incl.a68" PR                  # include prime utilities #
    PR precision 800 PR # set number of digits for Algol 68G LONG LONG INT #
    # returns the nth Cullen number #
    OP CULLEN = ( INT n )LONG LONG INT: n * LONG LONG INT(2)^n + 1;
    # returns the nth Woodall number #
    OP WOODALL = ( INT n )LONG LONG INT: CULLEN n - 2;

    # show the first 20 Cullen numbers #
    print( ( "1st 20 Cullen numbers:" ) );
    FOR n TO 20 DO
        print( ( " ", whole( CULLEN n, 0 ) ) )
    OD;
    print( ( newline ) );
    # show the first 20 Woodall numbers #
    print( ( "1st 20 Woodall numbers:" ) );
    FOR n TO 20 DO
        print( ( " ", whole( WOODALL n, 0 ) ) )
    OD;
    print( ( newline ) );
    BEGIN # first 2 Cullen primes #
        print( ( "Index of the 1st 2 Cullen primes:" ) );
        LONG LONG INT power of 2 := 1;
        INT prime count := 0;
        FOR n WHILE prime count < 2 DO
            power of 2 *:= 2;
            LONG LONG INT c n = ( n * power of 2 ) + 1;
            IF is probably prime( c n ) THEN
                prime count +:= 1;
                print( ( " ", whole( n, 0 ) ) )
            FI
        OD;
        print( ( newline ) )
    END;
    BEGIN # first 12 Woodall primes #
        print( ( "Index of the 1st 12 Woodall primes:" ) );
        LONG LONG INT power of 2 := 1;
        INT prime count := 0;
        FOR n WHILE prime count < 12 DO
            power of 2 *:= 2;
            LONG LONG INT w n = ( n * power of 2 ) - 1;
            IF is probably prime( w n ) THEN
                prime count +:= 1;
                print( ( " ", whole( n, 0 ) ) )
            FI
        OD;
        print( ( newline ) )
    END
END
