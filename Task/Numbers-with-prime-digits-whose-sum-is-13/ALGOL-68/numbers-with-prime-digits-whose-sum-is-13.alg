BEGIN
    # find numbers whose digits are prime and whose digit sum is 13   #
    # as noted by the Wren sample, the digits can only be 2, 3, 5, 7  #
    # and there can only be 3, 4, 5 or 6 digits                       #
    []INT possible digits = []INT( 0, 2, 3, 5, 7 )[ AT 0 ];
    INT number count := 0;
    INT zero          = ABS "0"; # integer value of the character "0" #
    print( ( newline ) );
    FOR d1 index FROM 0 TO UPB possible digits DO
        INT  d1 = possible digits[ d1 index ];
        CHAR c1 = IF d1 /= 0 THEN REPR ( d1 + zero ) ELSE " " FI;
        FOR d2 index FROM 0 TO UPB possible digits DO
            INT  d2 = possible digits[ d2 index ];
            IF d2 /= 0 OR d1 = 0 THEN
                CHAR c2 = IF ( d1 + d2 ) /= 0 THEN REPR ( d2 + zero ) ELSE " " FI;
                FOR d3 index FROM 0 TO UPB possible digits DO
                    INT  d3 = possible digits[ d3 index ];
                    IF d3 /= 0 OR ( d1 + d2 ) = 0 THEN
                        CHAR c3 = IF ( d1 + d2 + d3 ) /= 0 THEN REPR ( d3 + zero ) ELSE " " FI;
                        FOR d4 index FROM 1 TO UPB possible digits DO
                            INT  d4 = possible digits[ d4 index ];
                            CHAR c4 = REPR ( d4 + zero );
                            FOR d5 index FROM 1 TO UPB possible digits DO
                                INT  d5 = possible digits[ d5 index ];
                                CHAR c5 = REPR ( d5 + zero );
                                FOR d6 index FROM 1 TO UPB possible digits DO
                                    INT d6  = possible digits[ d6 index ];
                                    IF ( d1 + d2 + d3 + d4 + d5 + d6 ) = 13 THEN
                                        # found a number whose prime digits sum to 13 #
                                        CHAR c6 = REPR ( d6 + zero );
                                        print( ( " ", c1, c2, c3, c4, c5, c6 ) );
                                        number count := number count + 1;
                                        IF ( number count +:= 1 ) MOD 12 = 0 THEN print( ( newline ) ) FI
                                    FI
                                OD # d6 #
                            OD # d5 #
                        OD # d4 #
                    FI
                OD # d3 #
            FI
        OD # d2 #
    OD # d1 #
END
