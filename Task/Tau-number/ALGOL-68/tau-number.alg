BEGIN # find tau numbers - numbers divisible by the count of theoir divisors #
    # calculates the number of divisors of v                                 #
    PROC divisor count = ( INT v )INT:
         BEGIN
            INT total := 1, n := v;
            # Deal with powers of 2 first #
            WHILE NOT ODD n DO
                total +:= 1;
                n  OVERAB 2
            OD;
            # Odd prime factors up to the square root #
            INT p := 1;
            WHILE  p +:= 2;
                   ( p * p ) <= n
            DO
                INT count := 1;
                WHILE n MOD p = 0 DO
                    count +:= 1;
                    n  OVERAB p
                OD;
                total *:= count
            OD;
            # If n > 1 then it's prime #
            IF n > 1 THEN total *:= 2 FI;
            total
         END # divisor count #;
    BEGIN
        INT tau limit  = 100;
        INT tau count := 0;
        print( ( "The first ", whole( tau limit, 0 ), " tau numbers:", newline ) );
        FOR n WHILE tau count < tau limit DO
            IF n MOD divisor count( n ) = 0 THEN
                tau count +:= 1;
                print( ( whole( n, -6 ) ) );
                IF tau count MOD 10 = 0 THEN print( ( newline ) ) FI
            FI
        OD
    END
END
