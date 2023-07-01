BEGIN # sum the primes below n and report the sums that are prime             #
    # sieve the primes to 999 #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 999;
    # sum the primes and test the sum                                         #
    INT prime sum       := 0;
    INT prime count     := 0;
    INT prime sum count := 0;
    print( ( "prime         prime", newline ) );
    print( ( "count  prime    sum", newline ) );
    FOR i TO UPB prime DO
        IF prime[ i ] THEN
            # have another prime                                              #
            prime count  +:= 1;
            prime sum    +:= i;
            # check whether the prime sum is prime or not                     #
            BOOL is prime := TRUE;
            FOR p TO i OVER 2 WHILE is prime DO
                IF prime[ p ] THEN is prime := prime sum MOD p /= 0 FI
            OD;
            IF is prime THEN
                # the prime sum is also prime                                 #
                prime sum count +:= 1;
                print( ( whole( prime count, -5 )
                       , " "
                       , whole( i,           -6 )
                       , " "
                       , whole( prime sum,   -6 )
                       , newline
                       )
                     )
            FI
        FI
    OD;
    print( ( newline
           , "Found "
           , whole( prime sum count, 0 )
           , " prime sums of primes below "
           , whole( UPB prime + 1, 0 )
           , newline
           )
         )
END
