BEGIN # bead sort - translation of the Java code in the Wikipedia article     #

    PROC bead sort = ( REF[]INT a )VOID:
         BEGIN
            # Find the maximum element                                        #
            INT max := a[ LWB a ];
            FOR i FROM LWB a + 1 TO UPB a DO
                IF a[ i ] > max THEN max := a[ i ] FI
            OD;

            # allocating memory                                               #
            [ LWB a : UPB a, 0 : max - 1 ]INT beads;

            # mark the beads                                                  #
            FOR i FROM LWB a TO UPB a DO
                FOR j FROM 0 TO a[ i ] - 1 DO
                    beads[ i, j ] := 1
                OD;
                FOR j FROM a[ i ] TO max - 1 DO
                    beads[ i, j ] := 0
                OD
            OD;

            # move down the beads                                             #
            FOR j FROM 0 TO max - 1 DO
                INT sum := 0;
                FOR i FROM LWB a TO UPB a DO
                    sum          +:= beads[ i, j ];
                    beads[ i, j ] := 0
                OD;

                FOR i FROM UPB a BY -1 WHILE i >= UPB a + 1 - sum DO
                    a[ i ] := j + 1
                OD
            OD
         END # bead sort # ;

    BEGIN
        [ 1 : 10 ]INT data := ( 909, 8, 7, 6, 1, 3, 5, 12346, 4, 2 );
        bead sort( data );
        FOR i FROM LWB data TO UPB data DO print( ( " ", whole( data[ i ], 0 ) ) ) OD;
        print( ( newline ) )
    END

END
