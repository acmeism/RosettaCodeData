BEGIN # find some incomsummate numbers: integers that cannot be expressed as #
      #      an integer divided by the sum of its digits                     #
    # table of numbers that can be formed by n / digit sum n                 #
    [ 0 : 999 999  ]BOOL consummate;
    FOR i FROM LWB consummate TO UPB consummate DO
        consummate[ i ] := FALSE
    OD;
    # calculate the maximum number we must consider to find consummate       #
    # numbers up to UPB consummate - which is 9 * the number of digits in    #
    # UPB consummate                                                         #
    INT max sum := 9;
    INT v       := UPB consummate;
    WHILE ( v OVERAB 10 ) > 0 DO max sum +:= 9 OD;
    INT max number = UPB consummate * max sum;
    # construct the digit sums of the numbers up to max number               #
    # and find the consumate numbers, we start the loop from 10 to avoid     #
    # having to deal with 0-9                                                #
    consummate[ 1 ] := TRUE;
    INT tn := 1, hn := 0, th := 0, tt := 0, ht := 0, mi := 0, tm := 0;
    FOR n FROM 10 BY 10 TO max number DO
        INT sumd := tm + mi + ht + tt + th + hn + tn;
        FOR d FROM n TO n + 9 DO
           IF d MOD sumd = 0 THEN
                # d is comsummate                                            #
                IF INT d ratio = d OVER sumd;
                   d ratio <= UPB consummate
                THEN
                    consummate[ d ratio ] := TRUE
                FI
            FI;
            sumd +:= 1
        OD;
        IF ( tn +:= 1 ) > 9 THEN
            tn := 0;
            IF ( hn +:= 1 ) > 9 THEN
                hn  := 0;
                IF ( th +:= 1 ) > 9 THEN
                    th  := 0;
                    IF ( tt +:= 1 ) > 9 THEN
                        tt  := 0;
                        IF ( ht +:= 1 ) > 9 THEN
                            ht  := 0;
                            IF ( mi +:= 1 ) > 9 THEN
                                mi  := 0;
                                tm +:= 1
                            FI
                        FI
                    FI
                FI
            FI
        FI
    OD;
    INT count := 0;
    print( ( "The first 50 inconsummate numbers:", newline ) );
    FOR i TO UPB consummate WHILE count < 100 000 DO
        IF NOT consummate[ i ] THEN
            IF ( count +:= 1 ) < 51 THEN
                print( ( whole( i, -6 ) ) );
                IF count MOD 10 = 0 THEN print( ( newline ) ) FI
            ELIF count = 1 000 OR count = 10 000 OR count = 100 000 THEN
               print( ( "Inconsummate number ", whole( count, -6 )
                      , ": ", whole( i, -8 ), newline
                      )
                    )
            FI
        FI
    OD
END
