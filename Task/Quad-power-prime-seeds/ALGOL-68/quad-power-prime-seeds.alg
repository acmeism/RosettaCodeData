BEGIN # find some Quad power prime seeds, numbers n such that:                #
      #      n^p + n + 1 is prime for p = 1, 2, 3, 4                          #
    PR read "primes.incl.a68" PR # include prime utilities                    #
    INT max prime         = 22 000 000;
    # sieve the primes to max prime - 22 000 000 should be enough to allow    #
    # checking primality of 2n+1 up to a little under 11 000 000 which should #
    # be enough for the task                                                  #
    [ 0 : max prime ]BOOL prime;
    FOR i FROM LWB prime TO UPB prime DO prime[ i ] := FALSE OD;
    prime[ 0 ] := prime[ 1 ] := FALSE;
    prime[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB prime ) DO
        IF prime[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := FALSE OD
        FI
    OD;
    # returns TRUE if p is (probably) prime, FALSE otherwise                  #
    #         uses the sieve if possible, Miller Rabin otherwise              #
    PROC is prime = ( LONG INT p )BOOL:
         IF p <= max prime
         THEN prime[ SHORTEN p ]
         ELSE is probably prime( p )
         FI;
    # attempt to find the numbers                                             #
    BOOL finished       := FALSE;
    INT  count          := 0;
    INT  next limit     :=  1 000 000;
    INT  last limit      = 10 000 000;
    INT  limit increment = next limit;
    print( ( "First 50 Quad power prime seeds:", newline ) );
    FOR n WHILE NOT finished DO
        IF  INT n1 = n + 1;
            prime[ n + n1 ]
        THEN
            # n^1 + n + 1 is prime                                            #
            LONG INT np := LENG n * LENG n;
            IF is prime( np + n1 ) THEN
                # n^2 + n + 1 is prime                                        #
                IF is prime( ( np *:= n ) + n1 ) THEN
                    # n^3 + n + 1 is prime                                    #
                    IF is prime( ( np * n ) + n1 ) THEN
                        # n^4 + n + 1 is prime - have a suitable number       #
                        count +:= 1;
                        IF n > next limit THEN
                            # found the first element over the next limit     #
                            print( ( newline
                                   , "First element over ", whole( next limit, -10 )
                                   , ": ",                  whole( n,          -10 )
                                   , ", index: ",           whole( count,      -6 )
                                   )
                                 );
                            next limit +:= limit increment;
                            finished    := next limit > last limit
                        FI;
                        IF count <= 50 THEN
                            # found one of the first 30 numbers               #
                            print( ( " ", whole( n, -8 ) ) );
                            IF count MOD 10 = 0 THEN print( ( newline ) ) FI
                        FI
                    FI
                FI
            FI
        FI
    OD
END
