BEGIN # show cyclops numbers - numbers with a 0 in the middle and no other 0 digits #
    INT max prime = 100 000;
    # sieve the primes to max prime #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE max prime;
    # returns TRUE if c is prime, FALSE otherwise #
    PROC have a prime = ( INT c )BOOL:
         IF   c < 2 THEN FALSE
         ELIF c < max prime
         THEN prime[ c ]
         ELSE # the cyclops number is too large for the sieve, use trial division #
            BOOL possibly prime := ODD c;
            FOR d FROM 3 BY 2 WHILE d * d <= c AND possibly prime DO possibly prime := c MOD d /= 0 OD;
            possibly prime
         FI # have a prime # ;
    # arrays of the cyclops numbers we must show #
    [ 1 : 50 ]INT first cyclops;                   INT cyclops count                   := 0;
    [ 1 : 50 ]INT first prime cyclops;             INT prime cyclops count             := 0;
    [ 1 : 50 ]INT first palindromic prime cyclops; INT palindromic prime cyclops count := 0;
    [ 1 : 50 ]INT first blind prime cyclops;       INT blind prime cyclops count       := 0;
    # notes c is a cyclops number, palindromic indicates whether it is palindromic or not #
    #       bc should be c c with the middle 0 removed #
    # if c is one of the first 50 of various classifications, #
    #    it is stored in the appropriate array #
    PROC have cyclops = ( INT c, BOOL palindromic, INT bc )VOID:
         BEGIN
            cyclops count +:= 1;
            IF cyclops count <= UPB first cyclops THEN first cyclops[ cyclops count ] := c FI;
            IF   prime cyclops count             < UPB first prime cyclops
            OR ( palindromic prime cyclops count < UPB first palindromic prime cyclops AND palindromic )
            OR   blind prime cyclops count       < UPB first blind prime cyclops
            THEN
                IF have a prime( c ) THEN
                    # have a prime cyclops #
                    IF prime cyclops count < UPB first prime cyclops THEN
                       first prime cyclops[ prime cyclops count +:= 1 ] := c
                    FI;
                    IF palindromic prime cyclops count < UPB first palindromic prime cyclops AND palindromic THEN
                       first palindromic prime cyclops[ palindromic prime cyclops count +:= 1 ] := c
                    FI;
                    IF blind prime cyclops count < UPB first blind prime cyclops THEN
                        IF have a prime( bc ) THEN
                            first blind prime cyclops[ blind prime cyclops count +:= 1 ] := c
                        FI
                    FI
                FI
            FI
         END # have cyclops # ;
    # prints a cyclops sequence #
    PROC print cyclops = ( []INT seq, STRING legend, INT elements per line )VOID:
         BEGIN
            print( ( "The first ", whole( ( UPB seq - LWB seq ) + 1, 0 ), " ", legend, ":", newline, "   " ) );
            FOR i FROM LWB seq TO UPB seq DO
                print( ( " ", whole( seq[ i ], -7 ) ) );
                IF i MOD elements per line = 0 THEN print( ( newline, "   " ) ) FI
            OD;
            print( ( newline ) )
         END # print cyclops # ;
    # generate the cyclops numbers #
    # 0 is the first and only cyclops number with less than three digits #
    have cyclops( 0, TRUE, 0 );
    # generate the 3 digit cyclops numbers #
    FOR f TO 9 DO
        FOR b TO 9 DO
            have cyclops( ( f * 100 ) + b
                        , f = b
                        , ( f * 10 ) + b
                        )
        OD
    OD;
    # generate the 5 digit cyclops numbers #
    FOR d1 TO 9 DO
        FOR d2 TO 9 DO
            INT d1200  = ( ( d1 * 10 ) + d2 ) * 100;
            INT d12000 = d1200 * 10;
            FOR d4 TO 9 DO
                INT d40 = d4 * 10;
                FOR d5 TO 9 DO
                    INT d45 = d40 + d5;
                    have cyclops( d12000 + d45
                                , d1 = d5 AND d2 = d4
                                , d1200 + d45
                                )
                OD
            OD
        OD
    OD;
    # generate the 7 digit cyclops numbers #
    FOR d1 TO 9 DO
        FOR d2 TO 9 DO
            FOR d3 TO 9 DO
                INT d123000  = ( ( ( ( d1 * 10 ) + d2 ) * 10 ) + d3 ) * 1000;
                INT d1230000 = d123000 * 10;
                FOR d5 TO 9 DO
                    INT d500 = d5 * 100;
                    FOR d6 TO 9 DO
                        INT d560 = d500 + ( d6 * 10 );
                        FOR d7 TO 9 DO
                            INT d567 = d560 + d7;
                            have cyclops( d1230000 + d567
                                        , d1 = d7 AND d2 = d6 AND d3 = d5
                                        , d123000 + d567
                                        )
                        OD
                    OD
                OD
            OD
        OD
    OD;
    # show parts of the sequence #
    print cyclops( first cyclops,                                     "cyclops numbers", 10 );
    print cyclops( first prime cyclops,                         "prime cyclops numbers", 10 );
    print cyclops( first blind prime cyclops,             "blind prime cyclops numbers", 10 );
    print cyclops( first palindromic prime cyclops, "palindromic prime cyclops numbers", 10 )
END
