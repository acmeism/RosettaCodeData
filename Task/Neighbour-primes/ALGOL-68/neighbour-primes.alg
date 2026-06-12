BEGIN  # find adjacent primes p1, p2 such that p1*p2 + 2 s also prime    #
    PR read "primes.incl.a68" PR
    INT max prime = 500;
    []BOOL prime    = PRIMESIEVE ( ( max prime * max prime ) + 2 );      # sieve the primes to max prime ^ 2 + 2    #
    []INT low prime = EXTRACTPRIMESUPTO max prime FROMPRIMESIEVE prime;  # get a list of the primes up to max prime #
    # find the adjacent primes p1, p2 such that p1*p2 + 2 is prime       #
    FOR i TO UPB low prime - 1 DO
        IF   INT p1 p2 plus 2 = ( low prime[ i ] * low prime[ i + 1 ] ) + 2;
             prime[ p1 p2 plus 2 ]
        THEN print( ( "(",         whole( low prime[ i     ], -3 )
                    , " *",        whole( low prime[ i + 1 ], -3 )
                    , " ) + 2 = ", whole( p1 p2 plus 2,       -6 )
                    , newline
                    )
                  )
        FI
    OD
END
