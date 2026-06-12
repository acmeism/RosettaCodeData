BEGIN # Find n such that the divisor sum of n = the divisor sum of n + 1   #
    INT max number         = 1 000 000;  # maximum number we will consider #
    [ 1 : max number ]INT ds;                  # table of the divisor sums #
    ds[ 1 ] := 0;
    FOR k FROM 2 TO UPB ds DO ds[ k ] := k + 1 OD;
    FOR k FROM 2 TO UPB ds DO
        FOR j FROM k + k BY k TO UPB ds DO ds[ j ] +:= k OD
    OD;
    INT count := 0;                                     # find the numbers #
    FOR k TO UPB ds - 1 DO
        IF ds[ k ] = ds[ k + 1 ] THEN
            print( ( " ", whole( k, -6 ) ) );
            IF ( count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
        FI
    OD
END
