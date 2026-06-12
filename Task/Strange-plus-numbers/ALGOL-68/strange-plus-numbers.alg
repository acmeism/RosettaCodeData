BEGIN # find numbers where the sum of the first 2 digits is prime and also   #
      #                    the sum of the second 2 digits is prime           #
      # considers numbers n where 100 < n < 500                              #
    PROC small prime = ( INT n )BOOL: n = 2 OR ( ODD n AND n /= 1 AND n /= 9 AND n /= 15 );
    INT s count := 0;
    FOR n FROM 101 TO 499 DO
        INT v := n;
        INT d1 = v MOD 10; v OVERAB 10;
        INT d2 = v MOD 10; v OVERAB 10;
        INT d3 = v;
        IF small prime( d1 + d2 ) AND small prime( d2 + d3 ) THEN
            print( ( " ", whole( n, -3 ) ) );
            IF ( s count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
        FI
    OD
END
