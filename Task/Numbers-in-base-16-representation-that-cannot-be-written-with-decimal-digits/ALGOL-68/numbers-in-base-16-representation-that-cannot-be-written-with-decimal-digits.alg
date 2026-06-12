BEGIN # find numbers whose hex representation does not contain the digits 0-9 #
    # generate and print the numbers up to 499 #
    # 499 is 1F3 in hex, so we need to find numbers up to FF #
    INT h count := 0;
    # 1 hex digit numbers #
    FOR d1 FROM 10 TO 15 DO
        print( ( " ", whole( d1, -3 ) ) );
        h count +:= 1
    OD;
    # two hex digit numbers #
    FOR d1 FROM 10 TO 15 DO
        FOR d2 FROM 10 TO 15 DO
            print( ( " ", whole( ( d1 * 16 ) + d2, -3 ) ) );
            IF ( h count +:= 1 ) MOD 12 = 0 THEN print( ( newline ) ) FI
        OD
    OD
END
