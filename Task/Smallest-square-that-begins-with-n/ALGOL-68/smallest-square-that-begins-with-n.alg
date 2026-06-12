BEGIN # find the smallest square that begins with n for n in 1..49 #
    INT max number = 49;
    [ max number ]INT square; FOR i TO max number DO square[ i ] := 0 OD;
    INT number found := 0;
    FOR i WHILE number found < max number DO
        INT sq = i * i;
        INT v := sq;
        WHILE v > 0 DO
            IF v <= max number THEN
                IF square[ v ] = 0 THEN
                    # found the first square that starts with v #
                    square[ v ]   := sq;
                    number found +:= 1
                FI
            FI;
            v OVERAB 10
        OD
    OD;
    # show the squares #
    FOR i TO max number DO
        print( ( " ", whole( square[ i ], -6 ) ) );
        IF i MOD 10 = 0 THEN print( ( newline ) ) FI
    OD
END
