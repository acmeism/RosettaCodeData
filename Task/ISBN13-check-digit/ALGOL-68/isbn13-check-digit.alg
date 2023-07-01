BEGIN # Check some IsBN13 check digits                                         #
    # returns TRUE if the alledged isbn13 has the correct check sum,           #
    #         FALSE otherwise                                                  #
    #         non-digit characters are ignored and there must be 13 digits     #
    PROC check isbn13 = ( STRING isbn13 )BOOL:
         BEGIN
            INT sum          := 0;
            INT digits       := 0;
            BOOL other digit := FALSE;
            FOR pos FROM LWB isbn13 TO UPB isbn13 DO
                IF CHAR c = isbn13[ pos ];
                   c >= "0" AND c <= "9"
                THEN
                    # have another digit                                       #
                    digits +:= 1;
                    sum    +:= ( ABS c - ABS "0" ) * IF other digit THEN 3 ELSE 1 FI;
                    other digit := NOT other digit
                FI
            OD;
            digits = 13 AND sum MOD 10 = 0
         END; # check isbn13 #
    # task test cases #
    []STRING tests    = ( "978-1734314502", "978-1734314509", "978-1788399081", "978-1788399083" );
    []BOOL   expected = (             TRUE,            FALSE,             TRUE,            FALSE );
    FOR pos FROM LWB tests TO UPB tests DO
        BOOL result = check isbn13( tests[ pos ] );
        print( ( tests[ pos ]
               , ": "
               , IF result THEN "good" ELSE "bad" FI
               , IF result = expected[ pos ] THEN "" ELSE " NOT AS EXPECTED" FI
               , newline
               )
             )
    OD
END
