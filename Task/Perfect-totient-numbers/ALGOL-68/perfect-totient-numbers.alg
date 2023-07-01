BEGIN # find the first 20 perfect totient numbers #
    # returns the number of integers k where 1 <= k <= n that are mutually prime to n #
    PROC totient = ( INT n )INT: # algorithm from the second Go sample #
        IF   n < 3 THEN 1
        ELIF n = 3 THEN 2
        ELSE
            INT result := n;
            INT v      := n;
            INT i      := 2;
            WHILE i * i <= v DO
                IF v MOD i = 0 THEN
                    WHILE v MOD i = 0 DO v OVERAB i OD;
                    result -:= result OVER i
                FI;
                IF i = 2 THEN
                   i := 1
                FI;
                i +:= 2
            OD;
            IF v > 1 THEN result -:= result OVER v FI;
            result
         FI # totient # ;
    # find the first 20 perfect totient numbers #
    INT p count := 0;
    FOR i FROM 2 WHILE p count < 20 DO
        INT t   := totient( i );
        INT sum := t;
        WHILE t /= 1 DO
            t    := totient( t );
            sum +:= t
        OD;
        IF sum = i THEN
            # have a perfect totient #
            p count +:= 1;
            print( ( " ", whole( i, 0 ) ) )
        FI
    OD;
    print( ( newline ) )
END
