BEGIN # find numbers where reverse(d) divides reverse(n) for all divisors d #
      # of n                                                                #
    # returns n with the digits reversed                                    #
    OP REVERSE = ( INT n )INT:
       BEGIN
            INT reverse := 0;
            INT v       := ABS n;
            WHILE v > 0 DO
                reverse *:= 10 +:= v MOD 10;
                v OVERAB 10
            OD;
            reverse * SIGN n
       END # REVERSE # ;
    # find the numbers up to 200                                            #
    INT rd count := 0;
    FOR n TO 199 DO
        INT  reverse n        = REVERSE n;
        BOOL reverse divisor := TRUE;
        FOR d FROM 2 TO n OVER 2 WHILE reverse divisor DO
            IF n MOD d = 0 THEN
                # have a divisor of n                                       #
                reverse divisor := reverse n MOD REVERSE d = 0
            FI
        OD;
        IF reverse divisor THEN
            # all the divisors of n reversed divide n reversed              #
            print( ( " ", whole( n, -3 ) ) );
            IF ( rd count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    print( ( newline, "Found ", whole( rd count, 0 ), " ""special divisors"" below 200", newline ) )
END
