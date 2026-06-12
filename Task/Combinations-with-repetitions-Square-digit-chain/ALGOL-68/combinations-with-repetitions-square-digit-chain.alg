BEGIN # Combinations with repetitions: Square digit chain #
      # translated from the Kotlin sample                 #

    PROC ends with one = ( INT n )BOOL:
         IF   n = 0
         THEN FALSE
         ELSE INT  sum     := ABS n;
              WHILE INT nn := sum;
                    sum := 0;
                    WHILE nn > 0 DO
                        INT digit = nn MOD 10;
                        sum +:= digit * digit;
                        nn  OVERAB 10
                    OD;
                    sum /= 1 AND sum /= 89
              DO SKIP OD;
              sum = 1
         FI # ends with one # ;

    BEGIN
        []INT ks = ( 7, 8, 11, 14, 17 );
        FOR k pos FROM LWB ks TO UPB ks DO
           INT k = ks[ k pos ];
           [ 0 : k * 81 + 1 ]LONG INT sums;
           sums[ 0 ] := 1; FOR i FROM 1 TO UPB sums DO sums[ i ] := 0 OD;
           FOR n TO k DO
               FOR i FROM n * 81 BY -1 TO 1 DO
                    FOR j TO 9 WHILE INT s = j * j; s <= i
                    DO sums[ i ] +:= sums[ i - s ]
                    OD
               OD
           OD;
           LONG INT count1 := 0;
           FOR i TO k * 81 DO IF ends with one( i ) THEN count1 +:= sums[ i ] FI OD;
           LONG INT limit = ( LENG 10 ) ^ k - 1;
           print( ( "For k = ", whole( k, -2 ), " in the range 1 to ", whole( limit, 0 ), newline ) );
           print( ( whole( count1, 0 ), " numbers produce 1 and " ) );
           print( ( whole( limit - count1, 0 ), " numbers produce 89", newline, newline ) )
        OD
    END
END
