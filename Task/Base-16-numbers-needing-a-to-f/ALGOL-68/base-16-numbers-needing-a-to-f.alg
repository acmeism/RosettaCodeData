BEGIN # show numbers that when represented in hex, have at least one a-f digit #
    INT h count := 0;
    FOR i TO 500 DO
        BITS v := BIN i;
        WHILE v /= 16r0 DO
            IF ABS ( v AND 16rf ) < 10
            THEN v := v SHR 4
            ELSE
                v := 16r0;
                print( ( " ", whole( i, -3 ) ) );
                IF ( h count +:= 1 ) MOD 20 = 0 THEN print( ( newline ) ) FI
            FI
        OD
    OD
END
