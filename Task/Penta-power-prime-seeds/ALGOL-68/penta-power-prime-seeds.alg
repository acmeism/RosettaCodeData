BEGIN # find some Penta power prime seeds, numbers n such that:               #
      #      n^p + n + 1 is prime for p = 0. 1, 2, 3, 4                       #
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
    # attempt to find the numbers, note n^0 + n + 1 = n + 2 so n must be odd  #
    BOOL finished       := FALSE;
    INT  count          := 0;
    INT  next limit     := 1 000 000;
    INT  limit increment = next limit;
    [ 10 ]INT first, limit, index;
    INT  l count        := 0;
    print( ( "First 30 Penta power prime seeds:", newline ) );
    FOR n BY 2 WHILE NOT finished DO
        IF prime[ n + 2 ] THEN
            IF  INT n1 = n + 1;
                prime[ n + n1 ]
            THEN
                # n^0 + n + 1 and n^1 + n + 1 are prime                       #
                LONG INT np := LENG n * LENG n;
                IF is prime( np + n1 ) THEN
                    # n^2 + n + 1 is prime                                    #
                    IF is prime( ( np *:= n ) + n1 ) THEN
                        # n^3 + n + 1 is prime                                #
                        IF is prime( ( np * n ) + n1 ) THEN
                            # n^4 + n + 1 is prime - have a suitable number   #
                            count +:= 1;
                            IF n > next limit THEN
                                # found the first element over the next limit #
                                first[ l count +:= 1 ] := n;
                                limit[ l count       ] := next limit;
                                index[ l count       ] := count;
                                next limit            +:= limit increment;
                                finished               := l count >= UPB first
                            FI;
                            IF count <= 30 THEN
                                # found one of the first 30 numbers           #
                                print( ( " ", whole( n, -8 ) ) );
                                IF count MOD 10 = 0 THEN print( ( newline ) ) FI
                            FI
                        FI
                    FI
                FI
            FI
        FI
    OD;
    print( ( newline ) );
    FOR i TO UPB first DO
        print( ( "First element over ", whole( limit[ i ], -10 )
               , ": ",                  whole( first[ i ], -10 )
               , ", index: ",           whole( index[ i ],  -6 )
               , newline
               )
             )
    OD
END
