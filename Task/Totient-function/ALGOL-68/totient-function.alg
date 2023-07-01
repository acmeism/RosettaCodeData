BEGIN
    # returns the number of integers k where 1 <= k <= n that are mutually prime to n #
    PROC totient = ( INT n )INT:
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
    # show the totient function values for the first 25 integers #
    print( ( " n  phi(n) remarks", newline ) );
    FOR n TO 25 DO
        INT tn = totient( n );
        print( ( whole( n, -2 ), ": ", whole( tn, -5 ), IF tn = n - 1 AND tn /= 0 THEN "  n is prime" ELSE "" FI, newline ) )
    OD;
    # use the totient function to count primes #
    INT n100 := 0, n1000 := 0, n10000 := 0, n100000 := 0;
    FOR n TO 100 000 DO
        IF totient( n ) = n - 1 THEN
            IF n <=     100 THEN    n100 +:= 1 FI;
            IF n <=   1 000 THEN   n1000 +:= 1 FI;
            IF n <=  10 000 THEN  n10000 +:= 1 FI;
            IF n <= 100 000 THEN n100000 +:= 1 FI
        FI
    OD;
    print( ( "There are ", whole(    n100, -6 ), " primes below      100", newline ) );
    print( ( "There are ", whole(   n1000, -6 ), " primes below    1 000", newline ) );
    print( ( "There are ", whole(  n10000, -6 ), " primes below   10 000", newline ) );
    print( ( "There are ", whole( n100000, -6 ), " primes below  100 000", newline ) )
END
