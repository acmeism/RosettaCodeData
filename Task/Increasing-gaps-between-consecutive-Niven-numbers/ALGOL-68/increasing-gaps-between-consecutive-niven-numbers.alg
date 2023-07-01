BEGIN # show where the gaps increase in the series of Niven numbers #
      # ( numbers divisible by the sum of their digits ) #
    INT n count := 0;
    INT g count := 0;
    INT n gap   := 0;
    INT this n  := 1;
    print( ( "  Gap   Gap    Niven     Niven Next",         newline ) );
    print( ( "Index Value    Index    Number Niven Number", newline ) );
    print( ( "----- ----- -------- --------- ------------", newline ) );
    INT t8 := 0;
    FOR d0 FROM 0 TO 9 DO
        FOR d1 FROM 0 TO 9 DO
            INT s1  = d0 + d1;
            FOR d2 FROM 0 TO 9 DO
                INT s2  = s1 + d2;
                FOR d3 FROM 0 TO 9 DO
                    INT s3  = s2 + d3;
                    FOR d4 FROM 0 TO 9 DO
                        INT s4  = s3 + d4;
                        FOR d5 FROM 0 TO 9 DO
                            INT s5  = s4 + d5;
                            FOR d6 FROM 0 TO 9 DO
                                INT s6  = s5 + d6;
                                FOR d7 FROM 0 TO 9 DO
                                    INT s7  = s6 + d7;
                                    FOR d8 FROM 0 TO 9 DO
                                        INT s8  = s7 + d8;
                                        IF s8 /= 0 THEN
                                            t8 +:= 1;
                                            IF t8 MOD s8 = 0 THEN
                                                # have a Niven number #
                                                INT this gap = t8 - this n;
                                                IF this gap > n gap THEN
                                                    # found a larger gap #
                                                    g count +:= 1;
                                                    n gap    := this gap;
                                                    print( ( whole( g count, -5 )
                                                           , whole( n gap,   -6 )
                                                           , whole( n count, -9 )
                                                           , whole( this n, -10 )
                                                           , " "
                                                           , whole( t8,       0 )
                                                           , newline
                                                           )
                                                         )
                                                FI;
                                                n count +:= 1;
                                                this n   := t8
                                            FI
                                        FI
                                    OD # d8 #
                                OD # d7 #
                            OD # d6 #
                        OD # d5 #
                    OD # d4 #
                OD # d3 #
            OD # d2 #
        OD # d1 #
    OD # d0 #
END
