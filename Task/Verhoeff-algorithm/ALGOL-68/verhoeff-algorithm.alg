BEGIN # The Verhoeff algorithm - translated from the Wren sample via FreeBASIC #

    [,]INT d   = ( ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 )
                 , ( 1, 2, 3, 4, 0, 6, 7, 8, 9, 5 )
                 , ( 2, 3, 4, 0, 1, 7, 8, 9, 5, 6 )
                 , ( 3, 4, 0, 1, 2, 8, 9, 5, 6, 7 )
                 , ( 4, 0, 1, 2, 3, 9, 5, 6, 7, 8 )
                 , ( 5, 9, 8, 7, 6, 0, 4, 3, 2, 1 )
                 , ( 6, 5, 9, 8, 7, 1, 0, 4, 3, 2 )
                 , ( 7, 6, 5, 9, 8, 2, 1, 0, 4, 3 )
                 , ( 8, 7, 6, 5, 9, 3, 2, 1, 0, 4 )
                 , ( 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 )
                 );
    [ ]INT inv = ( 0, 4, 3, 2, 1, 5, 6, 7, 8, 9 );
    [,]INT p   = ( ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 )
                 , ( 1, 5, 7, 6, 2, 8, 3, 0, 9, 4 )
                 , ( 5, 8, 0, 3, 7, 9, 6, 1, 4, 2 )
                 , ( 8, 9, 1, 6, 0, 4, 3, 5, 2, 7 )
                 , ( 9, 4, 5, 3, 1, 2, 6, 8, 7, 0 )
                 , ( 4, 2, 8, 6, 5, 7, 3, 9, 0, 1 )
                 , ( 2, 7, 9, 3, 8, 0, 6, 4, 1, 5 )
                 , ( 7, 0, 4, 6, 9, 1, 3, 2, 5, 8 )
                 );
    PROC verhoeff algorithm = ( STRING s in, BOOL validate, table )INT:
         BEGIN
            IF table THEN
                print( ( IF validate THEN "Validation" ELSE "Check digit" FI ) );
                print( ( " calculations for '", s in, "':", newline ) );
                print( ( "     i  ni  p[i,ni]  c", newline, "    ------------------", newline ) )
            FI;
            STRING s = IF validate THEN s in ELSE s in + "0" FI;
            INT c := 0;
            INT le = UPB s;
            FOR k FROM le BY -1 TO LWB s DO
                INT nidx = ABS s[ k ] - 48;
                INT pidx = p[ 1 + ( le - k ) MOD 8, 1 + nidx ];
                c := d[ c + 1, pidx + 1 ];
                IF table
                THEN print( ( "    ", whole( le - k, -2 ), "  ", whole( nidx, 0 ), "      ", whole( pidx, 0 ) ) );
                     print( ( "     ", whole( c, 0 ), newline ) )
                FI
            OD;
            IF table AND NOT validate
            THEN print( ( "    inv[", whole( c, 0 ), "] = ", whole( inv[ c + 1 ], 0 ), newline ) )
            FI;
            IF NOT validate THEN inv[ c + 1 ] ELSE c FI
         END # verhoeff algorithm # ;
    PROC verhoeff validation  = ( STRING s, BOOL table )BOOL: verhoeff algorithm( s, TRUE,  table ) = 0;
    PROC verhoeff check digit = ( STRING s, BOOL table )INT:  verhoeff algorithm( s, FALSE, table );

    BEGIN # test cases                                                       #
        MODE TCASE = STRUCT( STRING s, BOOL table );
        []TCASE sts = ( ( "236", TRUE ), ( "12345", TRUE ), ( "123456789012", FALSE ) );
        FOR i FROM LWB sts TO UPB sts DO
            STRING s = s OF sts[ i ];
            INT c = verhoeff check digit( s, table OF sts[ i ] );
            print( ( "The check digit for '", s, "' is '", whole( c, 0 ), "'", newline ) );
            []STRING stc = ( s + REPR ( c + ABS "0" ), s + "9" );
            FOR j FROM LWB stc TO UPB stc DO
                BOOL v = verhoeff validation( stc[ j ], table OF sts[ i ] );
                print( ( "Validation for '", stc[ j ], "' -> " ) );
                print( ( IF v THEN "correct" ELSE "incorrect" FI, ".", newline ) )
            OD;
            print( ( newline, newline ) )
        OD
    END
END
