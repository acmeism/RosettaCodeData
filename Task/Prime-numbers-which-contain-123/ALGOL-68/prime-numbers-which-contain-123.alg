BEGIN  # find primes whose decimal representation contains 123 #
    INT max prime = 1 000 000;
    # sieve the primes to max prime #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE max prime;
    # find the appropriate primes #
    # as observed by the Wren sample, the primes must have a least 4 digits #
    INT show max    = 100 000;
    INT p123 count := 0;
    FOR n FROM 1001 TO UPB prime DO
        IF prime[ n ] THEN
            # have a prime #
            BOOL has 123 := FALSE;
            INT  v       := n;
            WHILE v >= 123 AND NOT ( has 123 := v MOD 1000 = 123 ) DO
                v OVERAB 10
            OD;
            IF has 123 THEN
                # the prime contains "123" #
                p123 count +:= 1;
                IF n <= show max THEN
                    print( ( whole( n, -7 ) ) );
                    IF p123 count MOD 12 = 0 THEN print( ( newline ) ) FI
                FI
            FI
        FI;
        IF n = 100 000 THEN
            print( ( newline, "Found ", whole( p123 count, 0 ), " ""123"" primes below ", whole( show max, 0 ), newline ) )
        FI
    OD;
    print( ( newline, "Found ", whole( p123 count, 0 ), " ""123"" primes below ", whole( UPB prime, 0 ), newline ) )
END
