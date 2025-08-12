# find elements of the Smarandache prime-digital sequence - primes whose    #
# digits are all primes                                                     #
# Uses the observations that the final digit of 2 or more digit Smarandache #
# primes must be 3 or 7 and the only prime digits are 2, 3, 5 and 7         #
# Needs --heap 256m for Algol 68G                                           #
BEGIN
    # construct a sieve of primes up to 10 000 000                          #
    INT prime max = 10 000 000;
    [ prime max ]BOOL prime; FOR i TO UPB prime DO prime[ i ] := TRUE OD;
    FOR s FROM 2 TO ENTIER sqrt( prime max ) DO
        IF prime[ s ] THEN
            FOR p FROM s * s BY s TO prime max DO prime[ p ] := FALSE OD
        FI
    OD;
    # consruct the Smarandache primes up to 10 000 000                      #
    [ prime max ]BOOL smarandache; FOR i TO UPB prime DO smarandache[ i ] := FALSE OD;
    [   ]INT prime digits = ( 2, 3, 5, 7 );
    [ 7 ]INT digits      := ( 0, 0, 0, 0, 0, 0, 0 );
    # tests whether the current digits form a Smarandache prime             #
    PROC try smarandache = VOID:
         BEGIN
            INT possible prime := 0;
            FOR i TO UPB digits DO
                possible prime *:= 10 +:= digits[ i ]
            OD;
            smarandache[ possible prime ] := prime[ possible prime ]
         END # try smarandache # ;
    # tests whether the current digits plus 3 or 7 form a Smarandache prime #
    PROC try smarandache 3 or 7 = VOID:
         BEGIN
            digits[ UPB digits ] := 3;
            try smarandache;
            digits[ UPB digits ] := 7;
            try smarandache
         END # try smarandache 3 or 7 # ;
    # the 1 digit primes are all Smarandache primes                         #
    FOR d7 TO UPB prime digits DO smarandache[ prime digits[ d7 ] ] := TRUE OD;
    # try the possible 2, 3, etc. digit numbers composed of prime digits    #
    FOR d6 TO UPB prime digits DO
        digits[ 6 ] := prime digits[ d6 ];
        try smarandache 3 or 7;
        FOR d5 TO UPB prime digits DO
            digits[ 5 ] := prime digits[ d5 ];
            try smarandache 3 or 7;
            FOR d4 TO UPB prime digits DO
                digits[ 4 ] := prime digits[ d4 ];
                try smarandache 3 or 7;
                FOR d3 TO UPB prime digits DO
                    digits[ 3 ] := prime digits[ d3 ];
                    try smarandache 3 or 7;
                    FOR d2 TO UPB prime digits DO
                        digits[ 2 ] := prime digits[ d2 ];
                        try smarandache 3 or 7;
                        FOR d1 TO UPB prime digits DO
                            digits[ 1 ] := prime digits[ d1 ];
                            try smarandache 3 or 7
                        OD;
                        digits[ 1 ] := 0
                    OD;
                    digits[ 2 ] := 0
                OD;
                digits[ 3 ] := 0
            OD;
            digits[ 4 ] := 0
        OD;
        digits[ 5 ] := 0
    OD;
    # print some Smarandache primes                                           #
    INT count  := 0;
    INT s100   := 0;
    INT s1000  := 0;
    INT s last := 0;
    INT p last := 0;
    print( ( "First 25 Smarandache primes:", newline ) );
    FOR i TO UPB smarandache DO
        IF smarandache[ i ] THEN
            count +:= 1;
            s last := i;
            p last := count;
            IF count <= 25 THEN
                print( ( " ", whole( i, 0 ) ) )
            ELIF count = 100 THEN
                s100  := i
            ELIF count = 1000 THEN
                s1000 := i
            FI
        FI
    OD;
    print( ( newline ) );
    print( ( "  100th Smarandache prime: ", whole( s100,  0 ), newline ) );
    print( ( " 1000th Smarandache prime: ", whole( s1000, 0 ), newline ) );
    print( ( "Largest Smarandache prime under ", whole( prime max, 0 ) ) );
    print( ( ": ", whole( s last, 0 ), " (Smarandache prime ", whole( p last, 0 ), ")", newline ) )
END
