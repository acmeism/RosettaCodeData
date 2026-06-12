BEGIN # find squares n where n + 1 is prime #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 1 000; # construct a sieve of primes up to 1000 #
    # find the squares 1 less than a prime                                    #
    # other than 1, the numbers must be even                                  #
    IF prime[ 2 # i.e.: ( 1 * 1 ) + 1 # ] THEN print( ( " 1" ) ) FI;
    FOR i FROM 2 BY 2 TO ENTIER sqrt( UPB prime ) DO
        IF INT i2 = i * i; prime[ i2 + 1 ] THEN
            print( ( " ", whole( i2, 0 ) ) )
        FI
    OD
END
