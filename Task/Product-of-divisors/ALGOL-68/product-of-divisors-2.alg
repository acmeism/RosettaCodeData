BEGIN # find the product of the divisors of the first 100 positive integers #
    # calculates the number of divisors of v                                #
    PROC divisor count = ( INT v )INT:
         BEGIN
            INT total := 1, n := v;
            # Deal with powers of 2 first #
            WHILE NOT ODD n DO
                total +:= 1;
                n  OVERAB 2
            OD;
            # Odd prime factors up to the square root #
            INT p := 3;
            WHILE ( p * p ) <= n DO
                INT count := 1;
                WHILE n MOD p = 0 DO
                    count +:= 1;
                    n  OVERAB p
                OD;
                p +:= 2;
                total *:= count
            OD;
            # If n > 1 then it's prime #
            IF n > 1 THEN total *:= 2 FI;
            total
         END # divisor count #;
    # calculates the product of the divisors of v                            #
    PROC divisor product = ( INT v )LONG INT:
         BEGIN
            INT      count    = divisor count( v );
            LONG INT product := v ^ ( count OVER 2 );
            IF ODD count THEN product *:= ENTIER sqrt( v ) FI;
            product
         END # divisor product # ;
    BEGIN
        INT limit = 50;
        print( ( "Product of divisors for the first ", whole( limit, 0 ), " positive integers:", newline ) );
        FOR n TO limit DO
            print( ( whole( divisor product( n ), -10 ) ) );
            IF n MOD 5 = 0 THEN print( ( newline ) ) FI
        OD
    END
END
