BEGIN # Knapsack problem: Continuous - based on the EasyLang sample #

    MODE ITEM  = STRUCT( STRING name, REAL weight, value );
    PRIO SWAP  = 1;
    OP   SWAP  = ( REF ITEM a, b )VOID: BEGIN ITEM t = a; a := b; b := t END;
    OP   PRICE = ( ITEM a )REAL: value OF a / weight OF a;
    []ITEM possible items
         = ( ( "beef",    3.8, 36 ), ( "pork",  5.4, 43 ), ( "ham",  3.6, 90 ), ( "greaves",  2.4, 45 )
           , ( "flitch",  4.0, 30 ), ( "brawn", 2.5, 56 ), ( "welt", 3.7, 67 ), ( "salami",   3.0, 95 )
           , ( "sausage", 5.9, 98 )
           );
    [ LWB possible items : UPB possible items ]ITEM sack items := possible items;
    FOR p FROM LWB sack items TO UPB sack items - 1 DO
        FOR q FROM p + 1 TO UPB sack items DO
            IF PRICE sack items[ q ] > PRICE sack items[ p ] THEN sack items[ p ] SWAP sack items[ q ] FI
        OD
    OD;
    REAL max weight := 15;
    FOR p FROM LWB sack items TO UPB sack items - 1 WHILE max weight > 0 DO
        REAL w = IF weight OF sack items[ p ] > max weight THEN max weight ELSE weight OF sack items[ p ] FI;
        print( ( fixed( w, -6, 2 ), " kg ", name OF sack items[ p ], newline ) );
        max weight -:= w
    OD
END
