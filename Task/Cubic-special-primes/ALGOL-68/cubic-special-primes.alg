BEGIN # find a sequence of primes where the members differ by a cube #
    INT max prime = 15 000;
    # sieve the primes to max prime #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE max prime;
    # construct a table of cubes, we will need at most the cube root of max prime #
    [ 1 : ENTIER exp( ln( max prime ) / 3 ) ]INT cube;
    FOR i TO UPB cube DO cube[ i ] := i * i * i OD;
    # find the prime sequence #
    print( ( "2" ) );
    INT p := 2;
    WHILE p < max prime DO
        # find a prime that is p + a cube #
        INT q := 0;
        FOR i WHILE q := p + cube[ i ];
                    IF q > max prime THEN FALSE ELSE NOT prime[ q ] FI
        DO SKIP OD;
        IF q <= max prime THEN print( ( " ", whole( q, 0 ) ) ) FI;
        p := q
    OD;
    print( ( newline ) )
END
