BEGIN # find additive primes - primes whose digit sum is also prime #
    # sieve the primes to max prime #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 499;
    # find the additive primes #
    INT additive count := 0;
    FOR n TO UPB prime DO
        IF prime[ n ] THEN
            # have a prime #
            INT digit sum := 0;
            INT v         := n;
            WHILE v > 0 DO
                digit sum +:= v MOD 10;
                v OVERAB 10
            OD;
            IF prime( digit sum ) THEN
                # the digit sum is prime #
                print( ( " ", whole( n, -3 ) ) );
                IF ( additive count +:= 1 ) MOD 20 = 0 THEN print( ( newline ) ) FI
            FI
        FI
    OD;
    print( ( newline, "Found ", whole( additive count, 0 ), " additive primes below ", whole( UPB prime + 1, 0 ), newline ) )
END
