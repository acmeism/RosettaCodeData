BEGIN # Burrows-Wheeler transform - translated from the EasyLang sample       #
    PR read "sort.incl.a68" PR                       # include sort utilities #
    CHAR stx = REPR 2, etx = REPR 3;
    OP   BWT = ( STRING s )STRING:
         BEGIN
            [ LWB s : UPB s + 2 ]STRING tbl;
            STRING ss = stx + s + etx;
            FOR i FROM LWB ss TO UPB ss DO
                STRING a = ss[ LWB ss : i ];
                STRING b = IF i >= UPB ss THEN "" ELSE ss[ i + 1 : ] FI;
                tbl[ i ] := b + a
            OD;
            QUICKSORT tbl;
            STRING r := "";
            FOR s pos FROM LWB tbl TO UPB tbl DO
                r +:= tbl[ s pos ][ UPB tbl[ s pos ] ]
            OD;
            r
         END # BWT # ;
    OP   IBWT = ( STRING r )STRING:
         BEGIN
            [ LWB r : UPB r ]STRING tbl;
            FOR j FROM LWB r TO UPB r DO tbl[ j ] := "" OD;
            FROM LWB r TO UPB r DO
                FOR k FROM LWB r TO UPB r DO
                    r[ k ] +=: tbl[ k ]
                OD;
                QUICKSORT tbl
            OD;
            STRING result := "";
            FOR r pos FROM LWB tbl TO UPB tbl WHILE result = "" DO
                STRING row = tbl[ r pos ];
                IF row[ UPB row ] = etx THEN result := row[ LWB row + 1 : UPB row - 1 ] FI
            OD;
            result
         END # IBWT # ;

    BEGIN
        OP   XTX = ( STRING s )STRING:             # make stx and etx visible #
             BEGIN
                STRING result := "";
                FOR s pos FROM LWB s TO UPB s DO
                    CHAR c = s[ s pos ];
                    result +:= IF   c = stx THEN "<stx>"
                               ELIF c = etx THEN "<etx>"
                               ELSE c
                               FI
                OD;
                result
             END # XTX # ;
        []STRING tests = ( "banana", "appellee", "dogwood"
                         , "TO BE OR NOT TO BE OR WANT TO BE OR NOT?"
                         , "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES"
                         );
        FOR t pos FROM LWB tests TO UPB tests DO
            STRING s = tests[ t pos ];
            print( ( s, newline ) );
            STRING h = BWT s;
            print( ( "    -> ", XTX h, newline ) );
            print( ( IBWT h, newline, newline ) )
        OD
    END
END
