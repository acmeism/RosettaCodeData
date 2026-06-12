BEGIN # find primes whose digits sum to 25 #
    # show all sum25 primes below 5000                                           #
    PR read "primes.incl.a68" PR
    []BOOL prime       = PRIMESIEVE 4999;
    INT    p25 count  := 0;
    FOR n TO UPB prime DO
        IF prime[ n ] THEN
            # have a prime, check for a sum25 prime                              #
            INT digit sum := 0;
            INT v         := n;
            WHILE v > 0 DO
                INT digit   = v MOD 10;
                digit sum +:= digit;
                v      OVERAB 10
            OD;
            IF digit sum = 25 THEN
                print( ( " ", whole( n, 0 ) ) );
                p25 count +:= 1
            FI
        FI
    OD;
    print( ( newline, "Found ", whole( p25 count, 0 ), " sum25 primes below ", whole( UPB prime + 1, 0 ), newline ) )
END
