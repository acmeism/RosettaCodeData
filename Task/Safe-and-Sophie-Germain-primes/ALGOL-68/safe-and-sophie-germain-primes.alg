BEGIN # find some Sophie Germain primes: primes p such that 2p + 1 is prime   #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 10 000;              # hopefully, enough primes #
    INT sg count := 0;
    FOR p WHILE sg count < 50 DO    # find the first 50 Sophie Germain primes #
        IF prime[ p ] THEN
            IF prime[ p + p + 1 ] THEN
                print( ( " ", whole( p, -6 ) ) );
                IF ( sg count +:= 1 ) MOD 12 = 0 THEN print( ( newline ) ) FI
            FI
        FI
    OD
END
