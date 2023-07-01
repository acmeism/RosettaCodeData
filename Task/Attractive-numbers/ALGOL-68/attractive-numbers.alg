BEGIN # find some attractive numbers - numbers whose prime factor counts are #
      #                                prime, n must be > 1                  #
    PR read "primes.incl.a68" PR
    # find the attractive numbers                                            #
    INT max number   = 120;
    []BOOL sieve     = PRIMESIEVE ENTIER sqrt( max number );
    print( ( "The attractve numbers up to ", whole( max number, 0 ), newline ) );
    INT    a count  := 0;
    FOR i FROM 2 TO max number DO
        IF  INT v       := i;
            INT f count := 0;
            WHILE NOT ODD v DO
                f count +:= 1;
                v    OVERAB 2
            OD;
            FOR j FROM 3 BY 2 TO max number WHILE v > 1 DO
                WHILE v > 1 AND v MOD j = 0 DO
                    f count +:= 1;
                    v    OVERAB j
                OD
            OD;
            f count > 0
        THEN
            IF sieve[ f count ] THEN
                print( ( " ", whole( i, -3 ) ) );
                IF ( a count +:= 1 ) MOD 20 = 0 THEN print( ( newline ) ) FI
            FI
        FI
    OD;
    print( ( newline, "Found ", whole( a count, 0 ), " attractive numbers", newline ) )
END
