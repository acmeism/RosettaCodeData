BEGIN # sum the divisors of the first 100 positive integers                  #

    # computes the sum of the divisors of v using the prime factorisation    #
    PROC divisor sum = ( INT v )INT:
         BEGIN
            INT total := 1, power := 2, n := v;
            WHILE NOT ODD n DO                 # Deal with powers of 2 first #
                total +:= power;
                power *:= 2;
                n  OVERAB 2
            OD;
            INT p := 3;            # Odd prime factors up to the square root #
            WHILE ( p * p ) <= n DO
                INT sum := 1;
                power   := p;
                WHILE n MOD p = 0 DO
                    sum   +:= power;
                    power *:= p;
                    n  OVERAB p
                OD;
                p     +:= 2;
                total *:= sum
            OD;
            IF n > 1 THEN total *:= n + 1 FI;     # If n > 1 then it's prime #
            total
        END # divisor sum # ;
    BEGIN                                  # show the first 100 divisor sums #
        INT limit = 100;
        print( ( "Sum of divisors for the first ", whole( limit, 0 ), " positive integers:" ) );
        FOR n TO limit DO
            IF n MOD 10 = 1 THEN print( ( newline ) ) FI;
            print( ( " ", whole( divisor sum( n ), -4 ) ) )
        OD
    END
END
