BEGIN # find the 10001st prime #
    PR read "primes.incl.a68" PR
    # construct a sieve of primes that should be large enough to contain 10001 primes #
    INT required prime = 10 001;
    []BOOL prime = PRIMESIEVE APPROXIMATESIEVESIZEFOR required prime;
    INT p count := 1;
    FOR n FROM 3 BY 2 WHILE p count < required prime DO
        IF prime[ n ] THEN
            p count +:= 1;
            IF p count = required prime THEN
                print( ( "Prime ", whole( required prime, 0 ), " is ", whole( n, 0 ) ) )
            FI
        FI
    OD
END
