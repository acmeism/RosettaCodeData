BEGIN # round-robin tournament schedule - translation of XPL0 #
    INT n = 12;            # number of players (must be even) #
    [ 1 : n ]INT player;
    FOR i TO n DO player[ i ] := i OD;
    FOR round TO n - 1 DO
        print( ( whole( round, 0 ), ":" ) );
        FOR i TO n OVER 2 DO
            print( ( REPR 9, whole( player[ i ], 0 ) ) )
        OD;
        print( ( newline ) );
        FOR i FROM n BY -1 TO ( n OVER 2 ) + 1 DO
            print( ( REPR 9, whole( player[ i ], 0 ) ) )
        OD;
        print( ( newline, newline ) );
        INT nth player   = player[ n ];
        player[ 3 : n ] := player[ 2 : n - 1 ];
        player[ 2     ] := nth player
    OD
END
