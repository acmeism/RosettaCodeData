BEGIN # find some "Calmo" numbers: numbers n such that they have 3k divisors  #
      # (other than 1 and n) for some k > 0 and the sum of their divisors     #
      # taken three at a time is a prime                                      #
    PR read "primes.incl.a68" PR      # include prime utilities               #
    INT max number = 1 000;           # largest number we will consider       #
    # construct a sieve of (hopefully) enough primes - as we are going to sum #
    # the divisors in groups of three, it should be (more than) large enough  #
    []BOOL prime = PRIMESIEVE ( max number * 3 );
    # construct tables of the divisor counts and divisor sums and check for   #
    # the numbers as we do it                                                 #
    # as we are ignoring 1 and n, the initial counts and sums will be 0       #
    # but we should ignore primes                                             #
    [ 1 : max number ]INT dsum;
    [ 1 : max number ]INT dcount;
    FOR i TO UPB dcount DO
        dsum[ i ] := dcount[ i ] := IF prime[ i ] THEN -1 ELSE 0 FI
    OD;
    FOR i FROM 2 TO UPB dsum
        DO FOR j FROM i + i BY i TO UPB dsum DO
            # have another proper divisor                                     #
            IF dsum[ j ] >= 0 THEN
                # this number is still a candidate                            #
                dsum[   j ] +:= i;
                dcount[ j ] +:= 1;
                IF dcount[ j ] = 3 THEN
                    # the divisor count is currently 3                        #
                    dsum[ j ] := dcount[ j ] :=
                        IF NOT prime[ dsum[ j ] ] THEN
                            # divisor sum isn't prime, ignore it in future    #
                            -1
                        ELSE
                            # divisor sum is prime, reset the sum and count   #
                            0
                        FI
                FI
            FI
        OD
    OD;
    # show the numbers                                                        #
    FOR i FROM 2 TO UPB dcount DO
        IF dcount[ i ] = 0 THEN
            # have a number                                                   #
            print( ( " ", whole( i, 0 ) ) )
        FI
    OD;
    print( ( newline ) )
END
