BEGIN # Cheryl's birthday puzzle                                       #

    [ 1 : 4, 1 : 6 ]INT   dates   # non-zero indicates a possible date #
                       := ( (  0, 15, 16,  0,  0, 19 )    # may        #
                          , (  0,  0,  0, 17, 18,  0 )    # june       #
                          , ( 14,  0, 16,  0,  0,  0 )    # july       #
                          , ( 14, 15,  0, 17,  0,  0 )    # august     #
                          );
    []STRING month name = ( "May", "June", "July", "August" );
    print( ( "Cheryl tells Albert the month and Bernard the day", newline ) );
    print( ( "Albert doesn't know the date and knows Bernard doesn't either", newline ) );
    FOR d TO 2 UPB dates DO     # elimiate the months with unique days #
        INT day count := 0;
        INT day       := 0;
        INT month     := 0;
        FOR m TO 1 UPB dates DO
            IF dates[ m, d ] /= 0 THEN
                day count +:= 1;
                day        := dates[ m, d ];
                month      := m
            FI
        OD;
        IF day count = 1 THEN
            print( ( "  Eliminating ", month name[ month ], ", ", whole( day, 0 ), "th is unique", newline ) );
            FOR p TO 2 UPB dates DO dates[ month, p ] := 0 OD
        FI
    OD;
    print( ( "Bernard now knows the date", newline ) );
    FOR d TO 2 UPB dates DO    # eliminate the days that aren't unique #
        INT day count := 0;
        INT day       := 0;
        INT month     := 0;
        FOR m TO 1 UPB dates DO
            IF dates[ m, d ] /= 0 THEN
                day count +:= 1;
                day        := dates[ m, d ];
                month      := m
            FI
        OD;
        IF day count > 1 THEN
            print( ( "  Eliminating ", whole( day, 0 ), "th, it is non-unique", newline ) );
            FOR p TO 1 UPB dates DO dates[ p, d ] := 0 OD
        FI
    OD;
    print( ( "Albert now knows the date", newline ) );
    FOR m TO 1 UPB dates DO    # eliminate months with non-unique days #
        INT day count := 0;
        INT day       := 0;
        INT month     := 0;
        FOR d TO 2 UPB dates DO
            IF dates[ m, d ] /= 0 THEN
                day count +:= 1;
                day        := dates[ m, d ];
                month      := m
            FI
        OD;
        IF day count > 1 THEN
            print( ( "  Eliminating ", month name[ m ], ", it has multiple days", newline ) );
            FOR p TO 2 UPB dates DO dates[ m, p ] := 0 OD
        FI
    OD;
    print( ( "Cheryl's birthday: " ) );         # show the solution(s) #
    FOR m TO 1 UPB dates DO
        FOR d TO 2 UPB dates DO
            IF dates[ m, d ] /= 0 THEN
                print( ( " ", month name[ m ], " ", whole( dates[ m, d ], 0 ), "th" ) )
            FI
        OD
    OD;
    print( ( newline ) )
END
