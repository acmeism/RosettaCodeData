BEGIN # find some long primes - primes whose reciprocol have a period of p-1 #
    INT max number = 64 000;
    # sieve the primes to max number                                         #
    [ 1 : max number ]BOOL is prime; FOR i TO UPB is prime DO is prime[ i ] := ODD i OD;
    is prime[ 1 ] := FALSE;
    is prime[ 2 ] := TRUE;
    FOR s FROM 3 BY 2 TO ENTIER sqrt( max number ) DO
        IF is prime[ s ] THEN
            FOR p FROM s * s BY s TO UPB is prime DO is prime[ p ] := FALSE OD
        FI
    OD;

    OP   PERIOD = ( INT n )INT:  # returns the period of the reciprocal of n #
         BEGIN
            INT r := 1;
            FOR i TO n + 1 DO
                r *:= 10 MODAB n
            OD;
            INT rr = r;
            INT period := 0;
            WHILE r *:= 10 MODAB n;
                  period +:= 1;
                  r /= rr
            DO SKIP OD;
            period
         END # PERIOD # ;

    print( ( "Long primes upto 500:", newline, "    " ) );
    INT lp count := 0;
    FOR p FROM 3 TO 500 DO
        IF is prime[ p ] THEN
            IF PERIOD p = p - 1 THEN
                print( ( " ", whole( p, 0 ) ) );
                lp count +:= 1
            FI
        FI
    OD;
    print( ( newline ) );
    INT limit := 500;
    FOR p FROM 500 WHILE limit <= 64 000 DO
        IF p = limit THEN
            print( ( "Long primes up to: ", whole( p, -5 ), ": ", whole( lp count, 0 ), newline ) );
            limit *:= 2
        FI;
        IF is prime[ p ] THEN
            IF PERIOD p = p - 1 THEN
                lp count +:= 1
            FI
        FI
    OD

END
