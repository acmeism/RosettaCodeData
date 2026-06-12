BEGIN # find some Riordan numbers #
    # returns a table of the Riordan numbers 0 .. n #
    OP   RIORDAN = ( INT n )[]LONG INT:
         BEGIN
            [ 0 : n ]LONG INT a;
            IF n >= 0 THEN
                a[ 0 ] := 1;
                IF n >= 1 THEN
                    a[ 1 ] := 0;
                    FOR i FROM 2 TO UPB a DO
                        a[ i ] := ( ( i - 1 )
                                  * ( ( 2 * a[ i - 1 ] )
                                    + ( 3 * a[ i - 2 ] )
                                    )
                                  )
                             OVER ( i + 1 )
                    OD
                FI
            FI;
            a
         END # RIORDAN # ;
    # returns a string representation of n with commas                       #
    PROC commatise = ( STRING unformatted )STRING:
         BEGIN
            STRING result      := "";
            INT    ch count    := 0;
            FOR c FROM UPB unformatted BY -1 TO LWB unformatted DO
                IF  ch count <= 2 THEN
                    ch count +:= 1
                ELSE
                    ch count  := 1;
                    IF unformatted[ c ] = " " THEN " " ELSE "," FI +=: result
                FI;
                unformatted[ c ] +=: result
            OD;
            result
         END; # commatise #
    # returns the length of s                                                #
    OP LENGTH = ( STRING s )INT: ( UPB s - LWB s ) + 1;
    BEGIN # show some Riordann numbers                                       #
        []LONG INT r = RIORDAN 31;
        INT shown := 0;
        FOR i FROM LWB r TO UPB r DO
            print( ( commatise( whole( r[ i ], -15 ) ) ) );
            IF ( shown +:= 1 ) = 4 THEN
                print( ( newline ) );
                shown := 0
            FI
        OD
    END;
    BEGIN # calculate the length of the 1 000th and 10 000th Riordan numbers #
        PR precision 5000 PR # allow up to 5 000 digits for LONG LONG INT    #
        LONG LONG INT r2 := -1, r1 := 1, r := 0;
        print( ( newline ) );
        FOR i FROM 2 TO 9 999 DO
            r2 := r1;
            r1 := r;
            r := ( ( i - 1 )
                 * ( ( 2 * r1 )
                   + ( 3 * r2 )
                   )
                 )
              OVER ( i + 1 );
            IF i = 999 OR i = 9 999 THEN
                STRING rs = whole( r, 0 )[ @ 1 ];
                print( ( "The ", whole( i + 1, -6 ), "th number is: "
                       , rs[ 1 : 20 ], "...", rs[ LENGTH rs - 19 : ]
                       , " with ", whole( LENGTH rs, -5 ), " digits"
                       , newline
                       )
                     )
            FI
        OD
    END
END
