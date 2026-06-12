BEGIN # find idoneal numbers - numbers that cannot be written as ab + bc + ac #
      #                        where 0 < a < b < c                            #
      # there are 65 known idoneal numbers                                    #
    INT count    :=  0;
    INT max count = 65;
    FOR n WHILE count < max count DO
        BOOL idoneal := TRUE;
        FOR a TO n OVER 2 WHILE idoneal DO
            FOR b FROM a + 1 TO n - 1
            WHILE INT ab = a * b;
                  INT c   = ( n - ab ) OVER ( a + b );
                  INT sum = ab + ( c * ( b + a ) );
                  sum <= n
              AND b < c
              AND ( idoneal := c <= b OR sum /= n )
            DO SKIP OD
        OD;
        IF idoneal THEN
            print( ( " ", whole( n, -4 ) ) );
            IF ( count +:= 1 ) MOD 13 = 0 THEN print( ( newline ) ) FI
        FI
    OD
END
