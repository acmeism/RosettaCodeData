BEGIN # Prime numbers of measurement - translated from the EasyLang sample #
    [ 1 : 1000 ]INT prmeas;
    prmeas[ 1 ] := 1;
    INT prind   := 1;
    FOR next FROM 2 WHILE prind < UPB prmeas DO
        INT sum := 0;
        FOR i TO prind WHILE sum /= next DO
            sum := 0;
            FOR j FROM i TO prind WHILE sum < next DO
                sum +:= prmeas[ j ]
            OD
        OD;
        IF sum /= next THEN prmeas[ prind +:= 1 ] := next FI
    OD;
    print( ( "First 100:", newline ) );
    FOR n TO 100 DO
        print( ( " ", whole( prmeas[ n ], -5 ) ) );
        IF n MOD 10 = 0 THEN print( ( newline ) ) FI
    OD;
    print( ( "One Thousandth: ", whole( prmeas[ 1000 ], 0 ) ) )
END
