BEGIN # test lists contain exactly 3 threes and that they are adjacent #
    []INT   list1 = ( 9, 3, 3, 3, 2, 1, 7, 8, 5 ); # task test case  #
    []INT   list2 = ( 5, 2, 9, 3, 3, 7, 8, 4, 1 ); #   "    "    "   #
    []INT   list3 = ( 1, 4, 3, 6, 7, 3, 8, 3, 2 ); #   "    "    "   #
    []INT   list4 = ( 1, 2, 3, 4, 5, 6, 7, 8, 9 ); #   "    "    "   #
    []INT   list5 = ( 4, 6, 8, 7, 2, 3, 3, 3, 1 ); #   "    "    "   #
    []INT   list6 = ( 3, 3, 3, 1, 2, 4, 5, 1, 3 ); # additional test from the Raku/Wren sample #
    []INT   list7 = ( 0, 3, 3, 3, 3, 7, 2, 2, 6 ); # additional test from the Raku/Wren sample #
    []INT   list8 = ( 3, 3, 3, 3, 3, 4, 4, 4, 4 ); # additional test from the Raku/Wren sample #
    [][]INT lists = ( list1, list2, list3, list4, list5, list6, list7, list8 );
    FOR l pos FROM LWB lists TO UPB lists DO
        []INT list       = lists[ l pos ];
        INT   threes    := 0;  # number of threes in the list #
        INT   three pos := 0;  # position of the last three in the list #
        BOOL  list ok   := FALSE;
        FOR e pos FROM LWB list TO UPB list DO
            IF list[ e pos ] = 3 THEN
                threes   +:= 1;
                three pos := e pos
            FI
        OD;
        IF threes = 3 THEN
            # exactly 3 threes - check they are adjacent #
            list ok := ( list[ three pos - 1 ] = 3 AND list[ three pos - 2 ] = 3 )
        FI;
        # show the result #
        print( ( "[" ) );
        FOR e pos FROM LWB list TO UPB list DO
            print( ( " ", whole( list[ e pos ], 0 ) ) )
        OD;
        print( ( " ] -> ", IF list ok THEN "true" ELSE "false" FI, newline ) )
    OD
END
