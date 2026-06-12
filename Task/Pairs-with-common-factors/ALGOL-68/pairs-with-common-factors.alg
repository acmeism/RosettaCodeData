BEGIN # finds elements of the sequence a(n) where a(n) is number of pairs    #
      # (x,y) where 1 < x < y <= n that have at least one common prime       #
      # factor. The sequence elements can be calculated by:                  #
      # a(n) = n(n-1)/2 + 1 - sum i = 1..n of phi(i) where phi is Euler's    #
      #                                                    totient function  #

    MODE ELEMENT = LONG INT;   # integral type large enough for a(1 000 000) #

    # returns the number of integers k where 1 <= k <= n that are mutually   #
    #                                                             prime to n #
    PROC totient = ( ELEMENT n )ELEMENT:         # algorithm from the second #
        IF   n < 3 THEN 1           # Go Sample in the Totient function task #
        ELIF n = 3 THEN 2
        ELSE
            ELEMENT result := n;
            ELEMENT v      := n;
            ELEMENT i      := 2;
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

    BEGIN
        INT     max number    = 1 000 000;  # maximum number of terms to use #
        ELEMENT totient sum  := 0;                # sum of the totients 1..n #
        INT     next to show := 1 000;    # next power of 10 element to show #
        ELEMENT n            := 0;
        TO max number DO
            n           +:= 1;
            totient sum +:= totient( n );
            ELEMENT an    = ( ( ( n * ( n - 1 ) ) OVER 2 ) + 1 ) - totient sum;
            IF n <= 100 THEN
                print( ( " ", whole( an, -4 ) ) );
                IF n MOD 10 = 0 THEN print( ( newline ) ) FI
            ELIF n = next to show THEN
                print( ( "a(", whole( n, 0 ), "): ", whole( an, 0 ), newline ) );
                next to show *:= 10
            FI
        OD
    END
END
