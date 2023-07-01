BEGIN
    # show the first 199 values of the moebius function                 #
    INT sq root = 1 000;
    INT mu max  = sq root * sq root;
    [ 1 : mu max ]INT mu;
    FOR i FROM LWB mu TO UPB mu DO mu[ i ] := 1 OD;
    FOR i FROM 2 TO sq root DO
        IF mu[ i ] = 1 THEN
            # for each factor found, swap + and -                       #
            FOR j FROM i     BY i     TO UPB mu DO mu[ j ] *:= -i OD;
            FOR j FROM i * i BY i * i TO UPB mu DO mu[ j ]  :=  0 OD
        FI
    OD;
    FOR i FROM 2 TO UPB mu DO
        IF   mu[ i ] =  i THEN mu[ i ] :=  1
        ELIF mu[ i ] = -i THEN mu[ i ] := -1
        ELIF mu[ i ] <  0 THEN mu[ i ] :=  1
        ELIF mu[ i ] >  0 THEN mu[ i ] := -1
      # ELSE mu[ i ] =  0 so no change #
        FI
    OD;
    print( ( "First 199 terms of the möbius function are as follows:", newline, "    " ) );
    FOR i TO 199 DO
        print( ( whole( mu[ i ], -4 ) ) );
        IF ( i + 1 ) MOD 20 = 0 THEN print( ( newline ) ) FI
    OD
END
