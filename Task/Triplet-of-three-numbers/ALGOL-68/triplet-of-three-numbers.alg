BEGIN # find numbers n where n-1, n+3 and n+5 are prime                    #
    # sieve the primes up to the maximum number for the task #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 6000;
    # returns a string represention of n #
    OP TOSTRING = ( INT n )STRING: whole( n, 0 );
    # look for suitable numbers #
    # 2 is clearly not a member of the required numbers, so we start at 3 #
    INT n count := 0;
    FOR n FROM 3 TO UPB prime - 5 DO
        IF prime[ n - 1 ] AND prime[ n + 3 ] AND prime[ n + 5 ] THEN
            print( ( " (", TOSTRING n, " | ", TOSTRING ( n - 1 ), ", ", TOSTRING ( n + 3 ), ", ", TOSTRING ( n + 5 ), ")" ) );
            n count +:= 1;
            IF n count MOD 4 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    print( ( newline, "Found ", TOSTRING n count, " triplets", newline ) )
END
