BEGIN # Eban numbers - translated from the Lua and Phix samples               #

    MODE INTERVAL = STRUCT( INT start, end, BOOL print );

    []INTERVAL intervals = ( (    2,       1000, TRUE  )
                           , ( 1000,       4000, TRUE  )
                           , (    2,      10000, FALSE )
                           , (    2,    1000000, FALSE )
                           , (    2,   10000000, FALSE )
                           , (    2,  100000000, FALSE )
                           , (    2, 1000000000, FALSE )
                           );
    FOR intp FROM LWB intervals TO UPB intervals DO
        INTERVAL intv = intervals[ intp ];
        IF start OF intv = 2 THEN
            print( ( "eban numbers up to and including ", whole( end OF intv, 0 ), ":" ) )
        ELSE
            print( ( "eban numbers between ", whole( start OF intv, 0 )
                   , " and ", whole( end OF intv, 0 ), " (inclusive)"
                   )
                 )
        FI;
        print( ( newline ) );

        IF NOT print OF intv THEN
            # calculate the count, as in the Phix sample                      #
            # end OF intv must be a power of 10                               #
            INT p10 := 0;
            INT v   := end OF intv;
            WHILE v > p10 DO
                p10  +:=  1;
                v OVERAB 10
            OD;
            INT n  = p10 - ( p10 OVER 3 );
            INT p5 = n OVER 2;
            INT p4 = ( n + 1 ) OVER 2;
            print( ( "count = ", whole( ( ( 5 ^ p5 ) * ( 4 ^ p4 ) ) - 1, 0 ), newline ) )
        ELSE
            # enumerate the eban numbers, as in the Lua and other samples    #
            INT count := 0;
            FOR i FROM start OF intv BY 2 TO end OF intv DO
                INT b  = i OVER 1 000 000 000;
                INT r := i MOD  1 000 000 000;
                INT m := r OVER     1 000 000;
                r     := i MOD      1 000 000;
                INT t := r OVER         1 000;
                r     := r MOD          1 000;
                IF m >= 30 AND m <= 66 THEN m MODAB 10 FI;
                IF t >= 30 AND t <= 66 THEN t MODAB 10 FI;
                IF r >= 30 AND r <= 66 THEN r MODAB 10 FI;
                IF b = 0 OR b = 2 OR b = 4 OR b = 6 THEN
                    IF m = 0 OR m = 2 OR m = 4 OR m = 6 THEN
                        IF t = 0 OR t = 2 OR t = 4 OR t = 6 THEN
                            IF r = 0 OR r = 2 OR r = 4 OR r = 6 THEN
                                print( ( whole( i, 0 ), " " ) );
                                count +:= 1
                            FI
                        FI
                    FI
                FI
            OD;
            print( ( newline, "count = ", whole( count, 0 ), newline ) )
        FI;
        print( ( newline ) )
    OD
END
