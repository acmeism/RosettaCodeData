BEGIN # find the smallest m where mn = digit sum of n, n in 1 .. 70 #
    # returns the digit sum of n, n must be >= 0 #
    OP   DIGITSUM = ( INT n )INT:
         IF  n < 10 THEN n
         ELSE
            INT result := n MOD  10;
            INT v      := n OVER 10;
            WHILE v > 0 DO
                result +:= v MOD  10;
                v       := v OVER 10
            OD;
            result
         FI # DIGITSUM # ;
    # show the minimum multiples of n where the digit sum of the multiple is n #
    FOR n TO 70 DO
        BOOL found multiple := FALSE;
        FOR m WHILE NOT found multiple DO
            IF DIGITSUM ( m * n ) = n THEN
                found multiple := TRUE;
                print( ( " ", whole( m, -8 ) ) );
                IF n MOD 10 = 0 THEN print( ( newline ) ) FI
            FI
        OD
    OD
END
