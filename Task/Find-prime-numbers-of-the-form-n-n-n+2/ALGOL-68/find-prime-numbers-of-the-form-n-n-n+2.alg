BEGIN # Find n such that n^3 + 2 is a prime for n < 200                      #
    FOR n TO 199 DO
        INT candidate = ( n * n * n ) + 2;
        # there will only be 199 candidates, so a primality check by trial   #
        # division should be OK                                              #
        BOOL is prime := TRUE;
        FOR f FROM 2 TO ENTIER sqrt( candidate )
        WHILE is prime := candidate MOD f /= 0
        DO SKIP OD;
        IF is prime THEN
            # n^3 + 2 is prime                                               #
            print( ( whole( n, -4 ), ": ", whole( candidate, -8 ), newline ) )
        FI
    OD
END
