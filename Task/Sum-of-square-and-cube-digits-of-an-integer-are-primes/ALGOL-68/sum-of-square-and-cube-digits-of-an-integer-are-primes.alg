BEGIN # find numbers where the digit sums of the square and cube are prime #
    INT max number = 99; # maximum number to consider #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE ( INT d sum := 9; # calculate the largest possible digit sum #
                                INT n     := max number * max number * max number;
                                WHILE ( n OVERAB 10 ) > 0 DO
                                    d sum +:= 9
                                OD;
                                d sum
                              );
    # returns the sum of the digits of n #
    OP  DIGITSUM = ( INT n )INT:
        BEGIN
            INT v      := ABS n;
            INT result := v MOD 10;
            WHILE ( v OVERAB 10 ) > 0 DO
                result +:= v MOD 10
            OD;
            result
        END # DIGITSUM # ;
    FOR i TO max number DO
        INT i2 = i * i;
        IF prime[ DIGITSUM i2 ] THEN
            IF prime[ DIGITSUM ( i * i2 ) ] THEN
                print( ( " ", whole( i, 0 ) ) )
            FI
        FI
    OD
END
