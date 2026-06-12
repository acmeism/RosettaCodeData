BEGIN  # find primes (up to 999) p(i) for odd i such that the sum of primes p(j), j = 1, 3, 5, ..., i is prime #
    PR read "primes.incl.a68" PR
    INT max prime    = 999;
    []BOOL prime     = PRIMESIEVE 50 000;                                # guess that the max sum will be <= 50 000 #
    []INT  low prime = EXTRACTPRIMESUPTO max prime FROMPRIMESIEVE prime; # get a list of primes up to max prime     #
    # find the sums of the odd primes and test for primality #
    print( ( "  i p[i]    sum", newline ) );
    INT odd prime sum := 0;
    FOR i BY 2 TO UPB low prime DO
        IF   odd prime sum +:= low prime[ i ];
             IF odd prime sum <= UPB prime
             THEN
                 prime[ odd prime sum ]
             ELSE
                 print( ( "Need more primes: ", whole( odd prime sum, 0 ), newline ) );
                 FALSE
             FI
        THEN
            print( ( whole( i, -3 ), " ", whole( low prime[ i ], -4 ), " ", whole( odd prime sum, -6 ), newline ) )
        FI
    OD
END
