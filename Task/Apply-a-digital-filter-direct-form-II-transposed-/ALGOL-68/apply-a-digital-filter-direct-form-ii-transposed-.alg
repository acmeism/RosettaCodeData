BEGIN # apply a digital filter #
    PROC filter = ( []REAL a, b, signal, REF[]REAL result )VOID:
         IF LWB a /= LWB b OR LWB a /= LWB signal OR LWB a /= LWB result THEN
            print( ( "Array lower bounds must be equal for filter", newline ) );
            stop
         ELSE
            FOR i FROM LWB result TO UPB result DO result[ i ] := 0 OD;
            FOR i FROM LWB signal TO UPB signal DO
                REAL tmp := 0;
                FOR j FROM LWB b TO IF i > UPB b THEN UPB b ELSE i FI DO
                    tmp +:= b[ j ] * signal[ LWB signal + ( i - j ) ]
                OD;
                FOR j FROM LWB a + 1 TO IF i > UPB a THEN UPB a ELSE i FI DO
                    tmp -:= a[ j ] * result[ LWB result + ( i - j ) ]
                OD;
                result[ i ] := tmp / a[ LWB a ]
            OD
         FI # filter # ;
    BEGIN
        [  4 ]REAL a := []REAL( 1, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17 );
        [  4 ]REAL b := []REAL( 0.16666667, 0.5, 0.5, 0.16666667 );
        [ 20 ]REAL signal
                     := []REAL( -0.917843918645,  0.141984778794, 1.20536903482,   0.190286794412
                              , -0.662370894973, -1.00700480494, -0.404707073677,  0.800482325044
                              ,  0.743500089861,  1.01090520172,  0.741527555207,  0.277841675195
                              ,  0.400833448236, -0.2085993586,  -0.172842103641, -0.134316096293
                              ,  0.0259303398477, 0.490105989562, 0.549391221511,  0.9047198589
                              );
        [ 20 ]REAL result;
        filter( a, b, signal, result );
        FOR i FROM LWB result TO UPB result DO
            print( ( " ", fixed( result[ i ], -9, 6 ) ) );
            IF i MOD 5 /= 0 THEN print( ( ", " ) ) ELSE print( ( newline ) ) FI
        OD
    END
END
