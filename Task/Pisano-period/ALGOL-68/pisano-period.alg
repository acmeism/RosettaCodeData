BEGIN # find the Pisano period of some primes and composites                 #

    INT max number = 180;                  # maximum number we will consider #
    # sieve the primes to max number                                         #
    [ 1 : max number ]BOOL is prime; FOR i TO UPB is prime DO is prime[ i ] := ODD i OD;
    is prime[ 1 ] := FALSE;
    is prime[ 2 ] := TRUE;
    FOR s FROM 3 BY 2 TO ENTIER sqrt( max number ) DO
        IF is prime[ s ] THEN
            FOR p FROM s * s BY s TO UPB is prime DO is prime[ p ] := FALSE OD
        FI
    OD;

    # returns the Pisano period of m                                         #
    PROC pisano = ( INT m )INT:
         BEGIN
            INT p := 0;
            INT c := 1;
            INT r := 0;
            FOR i FROM 0 TO m * m WHILE r = 0 DO
                INT t  = p;
                p     := c;
                c     := ( t + c ) MOD m;
                IF p = 0 AND c = 1 THEN r := i + 1 FI
            OD;
            IF r = 0 THEN 1 ELSE r FI
         END # pisano # ;

    # returns the Pisano period of p^k or 0 if p is not prime or k < 1       #
    PROC pisano prime = ( INT p, k )INT:
         IF NOT is prime[ p ] OR k < 1 THEN 0 ELSE p ^ ( k - 1 ) * pisano( p ) FI;

    print( ( "Pisano period of p^2 where p is a prime < 15:", newline ) );
    FOR p TO 15 DO
        IF is prime[ p ] THEN print( ( " ", whole( p, 0 ), ":", whole( pisano prime( p, 2 ), 0 ) ) ) FI
    OD;
    print( ( newline ) );
    print( ( "Pisano period of primes up to 180, non-primes shown as ""*"":", newline ) );
    FOR p TO 180 DO
        IF NOT is prime[ p ]
        THEN print( ( "   *" ) )
        ELSE print( ( whole( pisano prime( p, 1 ), -4 ) ) )
        FI;
        IF p MOD 10 = 0 THEN print( ( newline ) ) FI
    OD;
    print( ( newline ) );
    print( ( "Pisano period of positive integers up to 180:", newline ) );
    FOR n TO 180 DO
        print( ( whole( pisano( n ), -4 ) ) );
        IF n MOD 10 = 0 THEN print( ( newline ) ) FI
    OD

END
