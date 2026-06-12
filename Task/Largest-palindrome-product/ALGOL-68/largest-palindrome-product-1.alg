BEGIN # find the highest palindromic multiple of various sizes of numbers #
    # returns n with the digits reversed #
    PROC reverse = ( LONG INT v )LONG INT:
         BEGIN
            LONG INT r := 0 ;
            LONG INT n := v;
            WHILE n > 0 DO
                r *:= 10; r +:= n MOD 10;
                n OVERAB 10
            OD;
            r
         END # reverse # ;

    LONG INT pow := 10;
    FOR n FROM 2 TO 7 DO
        LONG INT low := pow * 9;
        pow *:= 10;
        LONG INT high := pow - 1;
        print( ( "Largest palindromic product of two ", whole( n, 0 ), "-digit integers: " ) );
        BOOL next n := FALSE;
        LONG INT i := high + 1;
        WHILE i -:= 1;
              i >= low AND NOT next n
        DO
            LONG INT j = reverse( i );
            LONG INT p = ( i * pow ) + j;
            # k can't be even nor end in 5 to produce a product ending in 9 #
            LONG INT k := high + 2;
            WHILE k -:= 2;
                  IF   k < low
                  THEN FALSE
                  ELIF k MOD 10 = 5
                  THEN TRUE
                  ELIF LONG INT l = p OVER k;
                                l > high
                  THEN FALSE
                  ELIF p MOD k = 0 THEN
                       print( ( whole( k, 0 ), " x ", whole( l, 0 ), " = ", whole( p, 0 ), newline ) );
                       next n := TRUE;
                       FALSE
                  ELSE TRUE
                  FI
            DO SKIP OD
        OD
    OD
END
