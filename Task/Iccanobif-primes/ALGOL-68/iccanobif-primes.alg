BEGIN # show the first 10 prime Iccanobif (reversed Fibonacci) numbers       #
    # returns n with the digits reversed                                     #
    OP REVERSE = ( INT n )INT:
       BEGIN
            INT reverse := 0;
            INT v       := ABS n;
            WHILE v > 0 DO
                reverse *:= 10 +:= v MOD 10;
                v OVERAB 10
            OD;
            IF n < 0 THEN - reverse ELSE reverse FI
       END # REVERSE # ;
    # returns TRUE if n is prime, FALSE otherwise - uses trial division      #
    PROC is prime = ( LONG INT n )BOOL:
         IF   n < 3       THEN n = 2
         ELIF n MOD 3 = 0 THEN n = 3
         ELIF NOT ODD n   THEN FALSE
         ELSE
             BOOL is a prime := TRUE;
             INT  f          := 5;
             INT  f2         := 25;
             INT  to next    := 24;
             WHILE f2 <= n AND is a prime DO
                 is a prime := n MOD f /= 0;
                 f         +:= 2;
                 f2        +:= to next;
                 to next   +:= 8
             OD;
             is a prime
         FI # is prime # ;
    # task                                                                   #
    INT p count := 0;
    INT prev    := 0;
    INT curr    := 1;
    WHILE p count < 10 DO
        INT next = prev + curr;
        prev    := curr;
        curr    := next;
        INT rev := REVERSE curr;
        IF is prime( rev ) THEN
            # have a prime iccanobif number #
            p count +:= 1;
            print( ( " ", whole( rev, 0 ) ) )
        FI
    OD
END
