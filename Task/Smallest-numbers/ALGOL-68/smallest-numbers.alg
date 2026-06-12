BEGIN # find the smallest k such that the decimal representation of k^k contains n for 0 <= n <= 50 #
    # start with powers up to 20^20, if this proves insufficient, the kk array will be extended #
    FLEX[ 1 : 20 ]STRING kk;
    FOR k TO UPB kk DO kk[ k ] := whole( LONG LONG INT( k ) ^ k, 0 ) OD;
    # find the numbers #
    FOR i FROM 0 TO 50 DO
        STRING n      = whole( i, 0 );
        BOOL try again := TRUE;
        WHILE try again DO
            try again := FALSE;
            BOOL   found := FALSE;
            FOR k FROM LWB kk TO UPB kk WHILE NOT found DO
                IF string in string( n, NIL, kk[ k ] ) THEN
                    found := TRUE;
                    print( ( " ", whole( k, -3 ) ) )
                FI
            OD;
            IF NOT found THEN
                # haven't got enough k^k values - get some more #
                kk := HEAP[ 1 : UPB kk * 2 ]STRING;
                FOR k TO UPB kk DO kk[ k ] := whole( LONG LONG INT( k ) ^ k, 0 ) OD;
                try again := TRUE
            FI
        OD;
        IF i MOD 10 = 9 THEN print( ( newline ) ) FI
    OD
END
