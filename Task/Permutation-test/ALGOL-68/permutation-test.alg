BEGIN # Permutation test - translated from the C sample #

    PROC pick = ( INT at, remain, accu, treat, []INT data )INT:
         IF   remain < 1
         THEN IF accu > treat THEN 1 ELSE 0 FI
         ELSE pick( at - 1, remain - 1, accu + data[ at - 1 ], treat, data )
            + IF at > remain THEN pick( at - 1, remain, accu, treat, data ) ELSE 0 FI
         FI # pick # ;

    PROC permutation test = ( []INT data, REF INT le, gt, REF REAL total )VOID:
         IF   LWB data /= 0
         THEN print( ( "LWB data is not 0", newline ) ); stop
         ELSE INT  treat := 0;
              INT  mid    = UPB data OVER 2;

              total := 1;
              FOR i FROM LWB data TO mid - 1 DO treat +:= data[ i ] OD;
              FOR i FROM UPB data + 1 BY -1 TO mid + 2      DO total *:= i OD;
              FOR i FROM mid          BY -1 TO LWB data + 1 DO total /:= i OD;

              gt := pick( UPB data + 1, mid, LWB data, treat, data );
              le := ENTIER ( total - gt )
         FI # permutation test # ;

    BEGIN
        REAL total := 0;
        INT  gt    := -1, le := -1;
        permutation test( []INT( 85, 88, 75, 66, 25, 29, 83, 39, 97
                               , 68, 41, 10, 49, 16, 65, 32, 92, 28, 98
                               )[ AT 0 ]
                        , le, gt, total
                        );
        print( ( "<= : ", fixed( 100 * le / total, -9, 6 ), "%  ", whole( le, 0 ), newline ) );
        print( ( " > : ", fixed( 100 * gt / total, -9, 6 ), "%  ", whole( gt, 0 ), newline ) )
    END
END
