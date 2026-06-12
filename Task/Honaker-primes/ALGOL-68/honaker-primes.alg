BEGIN # find some Honaker primes: primes whose digit-sum equals the   #
      # digit-sum of the index of the prime in the list of primes     #
      # e.g.: prime 32 (dsum 5) = 131 (dsum 5)                        #
    INT h count    :=  0; # number of Honaker primes found so far     #
    # sieve the primes up to 5 000 000, hopefully enough...           #
    [ 0 : 5 000 000 ]BOOL prime;
    prime[ 0 ] := prime[ 1 ] := FALSE;
    prime[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB prime ) DO
        IF prime[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := FALSE OD
        FI
    OD;
    # returns the digit sum of n                                       #
    PROC dsum = ( INT n )INT:
         BEGIN
            INT    sum := 0;
            STRING s    = whole( n, 0 );
            FOR s pos FROM LWB s TO UPB s DO
                sum +:= ABS s[ s pos ] - ABS "0"
            OD;
            sum
         END # digit sum # ;
    # attempt to find the Honaker primes                               #
    INT p count := 0;
    FOR n FROM LWB prime TO UPB prime DO
        IF prime[ n ] THEN
            # have the p count'th prime                                #
            p count +:= 1;
            IF dsum( n ) = dsum( p count ) THEN
                # have a Honaker prime                                 #
                IF ( h count +:= 1 ) < 51 THEN
                    print( ( "(",  whole( h count, -2 )
                           , ": ", whole( p count, -3 )
                           , " ",  whole( n,       -4 )
                           , ") "
                           )
                         );
                    IF h count MOD 5 = 0 THEN print( ( newline ) ) FI
                ELIF h count = 10 000 THEN
                    print( ( newline
                           , "Honaker prime ", whole( h count, 0 )
                           , " is prime ",     whole( p count, 0 )
                           , ": ",             whole( n,       0 )
                           , newline
                           )
                         )
                FI
            FI
        FI
    OD
END
