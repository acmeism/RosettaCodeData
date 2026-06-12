BEGIN  # find primes that are palindromic in base 10                         #
    INT max prime = 999;
    # sieve the primes to max prime                                          #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE max prime;
    # print the palendromic primes in the base 10                            #
    # all 1 digit primes are palindromic                                     #
    # the only palindromic 2 digit numbers are multiples of 11               #
    # so 11 is the only possible 2 digit palindromic prime                   #
    FOR n TO 11 DO IF prime[ n ] THEN print( ( " ", whole( n, 0 ) ) ) FI OD;
    # three digit numbers, the first and last digits must be odd             #
    # and cannot be 5 (as the number would be divisible by 5)                #
    FOR fl BY 2 TO 9 DO
        IF fl /= 5 THEN
            FOR m FROM 0 TO 9 DO
                INT n = ( ( ( fl * 10 ) + m ) * 10 ) + fl;
                IF prime[ n ] THEN
                    # have a palindromic prime #
                    print( ( " ", whole( n, 0 ) ) )
                FI
            OD
        FI
    OD;
    print( ( newline ) )
END
