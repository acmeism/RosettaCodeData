BEGIN # find some self-contained numbers: odd numbers whose Collatz sequence #
      #      contains an even multiple of the number itself                  #

    INT sc count := 0;
    FOR n FROM 3 BY 2 WHILE sc count < 7 DO
        LONG INT v := n;
        WHILE v /= 1 DO
            v := ( 3 * v ) + 1;
            WHILE NOT ODD v DO v OVERAB 2 OD;
            IF v MOD n = 0 THEN
                sc count +:= 1;
                print( ( " ", whole( n, 0 ) ) );
                v := 1
            FI
        OD
    OD
END
