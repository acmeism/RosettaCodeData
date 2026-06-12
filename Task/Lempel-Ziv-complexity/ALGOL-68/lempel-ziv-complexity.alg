BEGIN # Lempel-Ziv complexity                                                #

    # MODE to hold the results of LZ                                         #
    MODE LZCOMPLEXITY = STRUCT( INT complexity, STRING substrings );

    # returns the LZ complexity of str and the substrings                    #
    OP   LZ = ( STRING str )LZCOMPLEXITY:
         BEGIN
            INT n           = ( UPB str - LWB str ) + 1;
            INT complexity := 0;
            STRING subs    := "";
            IF n > 0 THEN
                INT i := 0, u := 1, v := 1;
                INT vmax   := v;
                complexity := 1;
                subs := str[ 1 ];
                WHILE u + v <= n DO
                    IF str[ i + v ] = str[ u + v ] THEN
                        v +:= 1
                    ELSE
                        IF v > vmax THEN vmax := v FI;
                        i +:= 1;
                        IF i = u THEN
                            complexity +:= 1;
                            subs +:= "." + str[ u + 1 : u + vmax ];
                            u   +:= vmax;
                            i    := 0;
                            vmax := 1
                        FI;
                        v := 1
                    FI
                OD;
                IF v /= 1 THEN
                    complexity +:= 1;
                    subs +:= "." + str[ u + 1 : n ]
                FI
            FI;
            ( complexity, subs )
         END # LZ # ;

    # left pads s with blanks to w characters                                 #
    PRIO PAD = 8;
    OP   PAD = ( INT w, STRING s )STRING:
         IF   INT len = ( UPB s - LWB s ) + 1;
              len >= w
         THEN s
         ELSE ( ( w - len ) * " " ) + s
         FI # PAD # ;

    BEGIN # test cases                                                       #
        print( ( "                          String  LZ Substrings", newline ) );
        print( ( "================================ === " ) );
        print( ( "=================================================", newline ) );
        MODE TCASE = STRUCT( STRING str, INT expected );
        []TCASE tests = ( ( "AZSEDRFTGYGUJIJOKB",         16 )
                        , ( "ABCABCABCABCABCABC",          4 )
                        , ( "111011111001111011111001",    6 )
                        , ( "101001010010111110",          5 )
                        , ( "1001111011000010",            6 )
                        , ( "1010101010",                  3 )
                        , ( "1010101010101010",            3 )
                        , ( "1001111011000010000010",      7 )
                        , ( "100111101100001000001010",    8 )
                        , ( "0001101001000101",            6 )
                        , ( "1111111",                     2 )
                        , ( "0001",                        2 )
                        , ( "010",                         3 )
                        , ( "1",                           1 )
                        , ( "",                            0 )
                        , ( "01011010001101110010",        7 )
                        , ( "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26 )
                        , ( "HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!"
                          , 11
                          )
                        );

        FOR t pos FROM LWB tests TO UPB tests DO
            STRING str   =      str OF tests[ t pos ];
            INT expected = expected OF tests[ t pos ];
            LZCOMPLEXITY lzc = LZ str;
            IF complexity OF lzc /= expected THEN
                print( ( "**** expected complexity ", whole( expected, 0 ) ) );
                print( ( " for """, str, """ got ", whole( complexity OF lzc, 0 ), newline ) )
            FI;
            IF ( UPB str - LWB str ) + 1 <= 32 THEN
                print( ( 32 PAD str ) )
            ELSE
                print( ( str, newline, 32 PAD "->" ) )
            FI;
            print( ( " ",  whole( complexity OF lzc, -3 ), " ", substrings OF lzc, newline ) )
        OD
    END
END
