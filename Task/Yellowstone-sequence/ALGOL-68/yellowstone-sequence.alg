BEGIN # find members of the yellowstone sequence: starting from 1, 2, 3 the   #
      # subsequent members are the lowest number coprime to the previous one  #
      # and not coprime to the one before that, that haven't appeared in the  #
      # sequence yet                                                          #
    # iterative Greatest Common Divisor routine, returns the gcd of m and n   #
    PROC gcd = ( INT m, n )INT:
         BEGIN
            INT a := ABS m, b := ABS n;
            WHILE b /= 0 DO
                INT new a = b;
                b        := a MOD b;
                a        := new a
            OD;
            a
         END # gcd # ;
    # returns an array of the Yellowstone seuence up to n                     #
    OP   YELLOWSTONE = ( INT n )[]INT:
         BEGIN
            [ 1 : n ]INT result;
            IF n > 0 THEN
                result[ 1 ] := 1;
                IF n > 1 THEN
                    result[ 2 ] := 2;
                    IF n > 2 THEN
                        result[ 3 ] := 3;
                        # guess the maximum element will be n, if it is larger, used will be enlarged #
                        REF[]BOOL used := HEAP[ 1 : n ]BOOL;
                        used[ 1 ] := used[ 2 ] := used[ 3 ] := TRUE;
                        FOR i FROM 4 TO UPB used DO used[ i ] := FALSE OD;
                        FOR i FROM 4 TO UPB result DO
                            INT p1      = result[ i - 1 ];
                            INT p2      = result[ i - 2 ];
                            BOOL found := FALSE;
                            FOR j WHILE NOT found DO
                                IF j > UPB used THEN
                                    # not enough elements in used - enlarge it #
                                    REF[]BOOL new used := HEAP[ 1 : 2 * UPB used ]BOOL;
                                    new used[ 1 : UPB used ] := used;
                                    FOR k FROM UPB used + 1 TO UPB new used DO new used[ k ] := FALSE OD;
                                    used := new used
                                FI;
                                IF NOT used[ j ] THEN
                                    IF found := gcd( j, p1 ) = 1 AND gcd( j, p2 ) /= 1
                                    THEN
                                        result[ i ] := j;
                                        used[   j ] := TRUE
                                    FI
                                FI
                            OD
                        OD
                    FI
                FI
            FI;
            result
         END # YELLOWSTONE # ;
    []INT ys = YELLOWSTONE 30;
    FOR i TO UPB ys DO
        print( ( " ", whole( ys[ i ], 0 ) ) )
    OD
END
