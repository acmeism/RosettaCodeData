BEGIN # find n where the sum of the digits is a substring of the representaton of n #
    INT max number = 1 000;
    INT n count   := 0;
    FOR n FROM 0 TO max number - 1 DO
        INT d sum := 0;
        INT v     := n;
        WHILE v > 0 DO
            d sum +:= v MOD 10;
            v  OVERAB 10
        OD;
        IF string in string( whole( d sum, 0 ), NIL, whole( n, 0 ) ) THEN
            # the string representaton of the digit sum is contained in the representation of n #
            print( ( " ", whole( n, -4 ) ) );
            n count +:= 1;
            IF n count MOD 8 = 0 THEN print( ( newline ) ) FI
        FI
    OD
END
