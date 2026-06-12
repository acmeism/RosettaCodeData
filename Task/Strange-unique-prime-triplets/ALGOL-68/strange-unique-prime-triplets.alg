BEGIN # find some strange unique primes - triplets of primes n, m, p        #
      # where n + m + p is also prime and n =/= m =/= p                     #
    # we need to find the strange unique prime triplets below 1000          #
    # so the maximum triplet sum could be roughly 3000                      #
    INT max number = 1000;
    # sieve the primes to the maximum reuired prime #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE ( max number * 3 );
    # we need to find the strange unique prime triplets below 1000          #
    INT s count := 0, c30 := 0;
    # 2 cannot be one of the primes as the sum would be even otherwise      #
    FOR n FROM 3 BY 2 TO max number - 5 DO
        IF prime[ n ] THEN
            FOR m FROM n + 2 BY 2 TO max number- 3 DO
                IF prime[ m ] THEN
                    FOR p FROM m + 2 BY 2 TO max number DO
                        IF prime[ p ] THEN
                            IF INT s = n + m + p;
                               prime[ s ]
                            THEN
                                # have 3 unique primes whose sum is prime   #
                                s count +:= 1;
                                IF p <= 30 AND m <= 30 AND n <= 30 THEN
                                    c30 +:= 1;
                                    print( ( whole( c30, -3 ), ": "
                                           , whole( n,   -3 ), " + "
                                           , whole( m,   -3 ), " + "
                                           , whole( p,   -3 ), " = "
                                           , whole( s,   -3 ), newline
                                           )
                                         )
                                FI
                            FI
                        FI
                    OD # p #
                FI
            OD # m #
        FI
    OD # n # ;
    print( ( "Found ", whole( c30,     -6 ), " strange unique prime triplets up to   30", newline ) );
    print( ( "Found ", whole( s count, -6 ), " strange unique prime triplets up to 1000", newline ) )
END
