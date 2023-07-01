BEGIN # find composite k with no single digit factors whose factors are all substrings of k #
    # returns TRUE if the string representation of f is a substring of k str, FALSE otherwise #
    PROC is substring = ( STRING k str, INT f )BOOL:
         BEGIN
            STRING f str   = whole( f, 0 );
            INT    f len   = ( UPB f str - LWB f str ) + 1;
            BOOL   result := FALSE;
            INT f end    := ( LWB k str + f len ) - 2;
            FOR f pos FROM LWB k str TO ( UPB k str + 1 ) - f len WHILE NOT result DO
                f end +:= 1;
                result := k str[ f pos : f end ] = f str
            OD;
            result
         END # is substring # ;
    # task #
    INT required numbers = 20;
    INT k count         := 0;
    # k must be odd and > 9 #
    FOR k FROM 11 BY 2 WHILE k count < required numbers DO
        IF k MOD 3 /= 0 AND k MOD 5 /= 0 AND k MOD 7 /= 0 THEN
            # no single digit odd prime factors #
            BOOL   is candidate := TRUE;
            STRING k str         = whole( k, 0 );
            INT    v            := k;
            INT    f count      := 0;
            FOR f FROM 11 BY 2 TO ENTIER sqrt( k ) + 1 WHILE v > 1 AND is candidate DO
                IF v MOD f = 0 THEN
                    # have a factor #
                    is candidate := is substring( k str, f );
                    IF is candidate THEN
                        # the digits of f ae a substring of v #
                        WHILE v OVERAB f;
                              f count +:= 1;
                              v MOD f = 0
                        DO SKIP OD
                    FI
                FI
            OD;
            IF is candidate AND ( f count > 1 OR ( v /= k AND v > 1 ) ) THEN
                # have a composite whose factors are up to the root are substrings #
                IF v > 1 THEN
                    # there was a factor > the root #
                    is candidate := is substring( k str, v )
                FI;
                IF is candidate THEN
                    print( ( " ", whole( k, -8 ) ) );
                    k count +:= 1;
                    IF k count MOD 10 = 0 THEN print( ( newline ) ) FI
                FI
            FI
        FI
    OD
END
