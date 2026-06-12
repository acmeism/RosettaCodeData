BEGIN # find numbers with prime divisor counts                         #
    INT max number            := 1 000;
    TO 2 DO
        # construct a table of the divisor counts                      #
        [ 1 : max number ]INT ndc; FOR i FROM 1 TO UPB ndc DO ndc[ i ] := 1 OD;
        FOR i FROM 2 TO UPB ndc DO
            FOR j FROM i BY i TO UPB ndc DO ndc[ j ] +:= 1 OD
        OD;
        # show the numbers with prime divisor counts                   #
        print( ( "Numbers up to ", whole( max number, 0 ), " with odd prime divisor counts:", newline ) );
        INT p count := 0;
        FOR i TO UPB ndc DO
            INT divisor count = ndc[ i ];
            IF ODD divisor count AND ndc[ divisor count ] = 2 THEN
                print( ( whole( i, -8 ) ) );
                IF ( p count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
            FI
        OD;
        print( ( newline ) );
        max number := 100 000
    OD
END
