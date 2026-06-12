BEGIN  # find adjacent primes p1, p2 such that p1 + p2 - 1 is also prime #
    PR read "primes.incl.a68" PR
    INT max prime = 100;
    []BOOL prime    = PRIMESIEVE ( max prime * 2 );                      # sieve the primes to max prime * 2        #
    []INT low prime = EXTRACTPRIMESUPTO max prime FROMPRIMESIEVE prime;  # get a list of the primes up to max prime #
    # find the adjacent primes p1, p2 such that p1 + p2 - 1 is prime #
    FOR i TO UPB low prime - 1 DO
        IF   INT p1 plus p2 minus 1 = ( low prime[ i ] + low prime[ i + 1 ] ) - 1;
             prime[ p1 plus p2 minus 1 ]
        THEN print( ( "(",         whole( low prime[ i     ], -3 )
                    , " +",        whole( low prime[ i + 1 ], -3 )
                    , " ) - 1 = ", whole( p1 plus p2 minus 1, -3 )
                    , newline
                    )
                  )
        FI
    OD
END
