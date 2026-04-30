BEGIN # Jordan-Pólya numbers - translation of XPL0 via EasyLang #

    [ 1 : 11 ]INT f; f[ 1 ] := 1; FOR i FROM 2 TO UPB f DO f[ i ] := f[ i - 1 ] * i OD;

    PROC jpnum = ( INT m )BOOL:
         BEGIN
            BOOL result := FALSE;
            FOR limite FROM UPB f BY -1 TO 1 WHILE NOT result DO
                INT n := m, i := limite, fac := f[ limite ];
                WHILE IF n MOD fac = 0 THEN
                          n  OVERAB fac;
                          result := n = 1
                      ELSE
                          fac OVERAB i;
                          i      -:= 1
                      FI;
                      i /= 1 AND NOT result
                DO SKIP OD
            OD;
            result
         END;

    PROC next = ( INT n0 )INT:
         BEGIN
            INT n := n0 + 2;
            WHILE NOT jpnum( n ) DO
                n +:= 2
            OD;
            n
         END;

    BEGIN
        print( ( "1" ) );
        INT n := 0;
        FROM 2 TO 50 DO
           n := next( n );
           print( ( " ", whole( n, 0 ) ) )
        OD;
        n := 100 000 000;
        WHILE n > 1 AND NOT jpnum( n ) DO
            n -:= 2
        OD;
        print( ( newline, "The largest Jordan-Pólya number before 100 million: ", whole( n, 0 ), newline ) )
    END
END
