BEGIN  # find nice primes - primes whose digital root is also prime #
    INT min prime = 501;
    INT max prime = 999;
    # sieve the primes to max prime #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE max prime;
    # find the nice primes #
    INT nice count := 0;
    FOR n FROM min prime TO max prime DO
        IF prime[ n ] THEN
            # have a prime #
            INT digit sum := 0;
            INT v         := n;
            WHILE digit sum := 0;
                  WHILE v > 0 DO
                      digit sum +:= v MOD 10;
                      v OVERAB 10
                  OD;
                  digit sum > 9
            DO
                v := digit sum
            OD;
            IF prime( digit sum ) THEN
                # the digital root is prime #
                nice count +:= 1;
                print( ( " ", whole( n, -3 ), "(", whole( digit sum, 0 ), ")" ) );
                IF nice count MOD 12 = 0 THEN print( ( newline ) ) FI
            FI
        FI
    OD
END
