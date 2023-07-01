BEGIN # find repunit (all digits are 1 ) primes in various bases #
    INT max base           = 16;
    INT max repunit digits = 1000;
    PR precision 3000 PR        # set precision of LONG LONG INT #
    # 16^1000 has ~1200 digits but the primality test needs more #
    PR read "primes.incl.a68" PR       # include prime utilities #
    []BOOL prime = PRIMESIEVE max repunit digits;
    FOR base FROM 2 TO max base DO
        LONG LONG INT repunit := 1;
        print( ( whole( base, -2 ), ":" ) );
        FOR digits TO max repunit digits DO
            IF prime[ digits ] THEN
                IF is probably prime( repunit ) THEN
                    # found a prime repunit in the current base #
                    print( ( " ", whole( digits, 0 ) ) )
                FI
            FI;
            repunit *:= base +:= 1
        OD;
        print( ( newline ) )
    OD
END
