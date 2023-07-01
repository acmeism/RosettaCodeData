BEGIN # find some self numbers numbers n such that there is no g such that g + sum of g's digits = n #
    INT max number = 1 999 999 999 + 82; # maximum n plus g we will condifer #
    # sieve the self numbers up to 1 999 999 999 #
    [ 0 : max number ]BOOL self; FOR i TO UPB self DO self[ i ] := TRUE OD;
    INT n := 0;
    FOR s0 FROM 0 TO 1 DO
        FOR d1 FROM 0 TO 9 DO
            INT s1 = s0 + d1;
            FOR d2 FROM 0 TO 9 DO
                INT s2 = s1 + d2;
                FOR d3 FROM 0 TO 9 DO
                    INT s3 = s2 + d3;
                    FOR d4 FROM 0 TO 9 DO
                        INT s4 = s3 + d4;
                        FOR d5 FROM 0 TO 9 DO
                            INT s5 = s4 + d5;
                            FOR d6 FROM 0 TO 9 DO
                                INT s6 = s5 + d6;
                                FOR d7 FROM 0 TO 9 DO
                                    INT s7 = s6 + d7;
                                    FOR d8 FROM 0 TO 9 DO
                                        INT s8 = s7 + d8;
                                        FOR d9 FROM 0 TO 9 DO
                                            INT s9 = s8 + d9;
                                            self[ s9 + n ] := FALSE;
                                            n +:= 1
                                        OD
                                    OD
                                OD
                            OD
                        OD
                    OD
                OD
            OD
        OD
    OD;
    # show the first 50 self numbers #
    INT s count := 0;
    FOR i TO UPB self WHILE s count < 50 DO
        IF self[ i ] THEN
            print( ( " ", whole( i, -3 ) ) );
            IF ( s count +:= 1 ) MOD 18 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    print( ( newline ) );
    # show the self numbers with power-of-10 indxes #
    INT s show := 1;
    s count    := 0;
    print( ( "              nth self", newline ) );
    print( ( "        n       number", newline ) );
    FOR i TO UPB self DO
        IF self[ i ] THEN
            s count +:= 1;
            IF s count = s show THEN
                print( ( whole( s show, -9 ), "  ", whole( i, -11 ), newline ) );
                s show *:= 10
            FI
        FI
    OD
END
