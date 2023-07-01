BEGIN # find the count of the divisors of the first 100 positive integers   #
    # calculates the number of divisors of v                                #
    PROC divisor count = ( INT v )INT:
         BEGIN
            INT total := 1, n := v;
            # Deal with powers of 2 first #
            WHILE NOT ODD n DO
                total +:= 1;
                n OVERAB 2
            OD;
            # Odd prime factors up to the square root #
            FOR p FROM 3 BY 2 WHILE ( p * p ) <= n DO
                INT count := 1;
                WHILE n MOD p = 0 DO
                    count +:= 1;
                    n OVERAB p
                OD;
                total *:= count
            OD;
            # If n > 1 then it's prime #
            IF n > 1 THEN total *:= 2 FI;
            total
         END # divisor_count # ;
    BEGIN
        INT limit = 100;
        print( ( "Count of divisors for the first ", whole( limit, 0 ), " positive integers:" ) );
        FOR n TO limit DO
            IF n MOD 20 = 1 THEN print( ( newline ) ) FI;
            print( ( whole( divisor count( n ), -4 ) ) )
        OD
    END
END
