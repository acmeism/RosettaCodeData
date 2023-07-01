BEGIN # find repunits (all digits are 1 ) such that R(n-1) is divisible by n and n is not prime #
      # R(n) is the nth repunit, so has n 1s                                                    #
    PR precision 8000 PR             # set precision of LONG LONG INT, enough for up to R(8000) #
    PR read "primes.incl.a68" PR                                      # include prime utilities #
    []BOOL prime = PRIMESIEVE 8000;
    LONG LONG INT repunit := 111 111;   # n must be odd as all repunits are odd, the lowest odd #
    INT           r count := 0;          # non-prime is 9, so we start with repunit set to R(6) #
    FOR n FROM 9 BY 2 WHILE r count < 15 DO
        repunit *:= 100 +:= 11;                                       # gets R(n-1) from R(n-3) #
        IF NOT prime[ n ] THEN
            IF repunit MOD n = 0 THEN
                # found non-prime n which divides R(n-1) #
                print( ( " ", whole( n, 0 ) ) );
                r count +:= 1
            FI
        FI
    OD
END
