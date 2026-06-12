BEGIN # find numbers where the digit 1 occurs twice, up to 999 #
    [ 1 : 999 ]BOOL double 1; FOR i TO UPB double 1 DO double 1[ i ] := FALSE OD;
    # generte the numbers                                      #
    FOR i FROM 0 TO 9 DO
        IF i /= 1 THEN
            double 1[ 110 + i ] := TRUE;
            double 1[ 101 + ( i * 10 ) ] := TRUE;
            double 1[ ( i * 100 ) + 11 ] := TRUE
        FI
    OD;
    # print the numbers in order                               #
    INT double 1 count := 0;
    FOR i TO UPB double 1 DO
        IF double 1[ i ] THEN
            print( ( " ", whole( i, -3 ) ) );
            IF ( double 1 count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
        FI
    OD
END
