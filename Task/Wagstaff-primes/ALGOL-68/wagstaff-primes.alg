BEGIN # find some Wagstaff primes: primes of the form ( 2^p + 1 ) / 3 #
      #                            where p is an odd prime            #
    INT max wagstaff = 10; # number of Wagstaff primes to find        #
    INT w count     :=  0; # numbdr of Wagstaff primes found so far   #
    # sieve the primes up to 200, hopefully enough...                 #
    [ 0 : 200 ]BOOL primes;
    primes[ 0 ] := primes[ 1 ] := FALSE;
    primes[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB primes DO primes[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB primes DO primes[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB primes ) DO
        IF primes[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB primes DO primes[ s ] := FALSE OD
        FI
    OD;
    # attempt to find the Wagstaff primes                              #
    LONG INT power of 2 := 2; # 2^1                                    #
    FOR p FROM 3 BY 2 WHILE w count < max wagstaff DO
        power of 2 *:= 4;
        IF primes[ p ] THEN
            LONG INT w := ( power of 2 + 1 ) OVER 3;
            # check w is prime - trial division                        #
            BOOL is prime := TRUE;
            LONG INT n    := 3;
            WHILE n * n <= w AND is prime DO
                is prime := w MOD n /= 0;
                n       +:= 2
            OD;
            IF is prime THEN
                # have another Wagstaff prime                          #
                w count +:= 1;
                print( ( whole( w count, -2 )
                       , ": "
                       , whole( p, -4 )
                       , ": "
                       , whole( w, 0 )
                       , newline
                       )
                     )
            FI
        FI
    OD
END
