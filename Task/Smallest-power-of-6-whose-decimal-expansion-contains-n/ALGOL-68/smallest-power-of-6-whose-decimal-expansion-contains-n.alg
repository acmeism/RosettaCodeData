BEGIN # find the smallest k such that the decimal representation of 6^k contains n for 0 <= n <= 21 #
    # returns s blank-padded on the right to at least len characters #
    PROC right pad = ( STRING s, INT len )STRING:
         BEGIN
            INT s len = ( UPB s - LWB s ) + 1;
            IF s len >= len THEN s ELSE s + ( len - s len ) * " " FI
         END # right pad # ;
    # returns s blank-padded on the left to at least len characters #
    PROC left pad = ( STRING s, INT len )STRING:
         BEGIN
            INT s len = ( UPB s - LWB s ) + 1;
            IF s len >= len THEN s ELSE ( ( len - s len ) * " " ) + s FI
         END # left pad # ;
    # returns a string representation of unformatted with space separators                    #
    PROC space separate = ( STRING unformatted )STRING:
         BEGIN
            STRING result      := "";
            INT    ch count    := 0;
            FOR c FROM UPB unformatted BY -1 TO LWB unformatted DO
                IF   ch count <= 2 THEN ch count +:= 1
                ELSE                    ch count  := 1; " " +=: result
                FI;
                unformatted[ c ] +=: result
            OD;
            result
         END # space separate # ;
    # start with powers up to 6^12, if this proves insufficient, the kk array will be extended #
    FLEX[ 0 : 12 ]STRING kk;
    FOR k FROM LWB kk TO UPB kk DO kk[ k ] := whole( LONG LONG INT( 6 ) ^ k, 0 ) OD;
    # find the numbers #
    FOR i FROM 0 TO 21 DO
        STRING n      = whole( i, 0 );
        BOOL try again := TRUE;
        WHILE try again DO
            try again := FALSE;
            BOOL   found := FALSE;
            FOR k FROM LWB kk TO UPB kk WHILE NOT found DO
                IF string in string( n, NIL, kk[ k ] ) THEN
                    found := TRUE;
                    print( ( whole( i, -2 ), right pad( ": 6^" + whole( k, 0 ), 8 ), " " ) );
                    print( ( left pad( space separate( kk[ k ] ), 30 ), newline ) )
                FI
            OD;
            IF NOT found THEN
                # haven't got enough k^k values - get some more #
                kk := HEAP[ 1 : UPB kk * 2 ]STRING;
                FOR k FROM LWB kk TO UPB kk DO kk[ k ] := whole( LONG LONG INT( 6 ) ^ k, 0 ) OD;
                try again := TRUE
            FI
        OD
    OD
END
