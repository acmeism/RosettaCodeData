BEGIN # find some Super-Poulet numbers                                       #
    PR read "primes.incl.a68" PR                   # include prime utilities #
    []BOOL is prime = PRIMESIEVE 1 200 000; # sieve primes up to 1.2 million #

    # returns a in ^ b in MOD m                                              #
    PROC powmod = ( INT a in, b in, m )INT:
         BEGIN
            LONG INT r := 1, a := a in, b := b in;
            WHILE b >= 1 DO
                IF ODD b THEN r *:= a MODAB m FI;
                b OVERAB 2;
                a *:= a MODAB m
            OD;
            SHORTEN r
         END # powmod # ;

    [ 1 : UPB is prime ]INT powmod2dd;         # cached powmod(2,d,d) values #
    FOR d TO UPB powmod2dd DO powmod2dd[ d ] := -1 OD;

    # returns powmod( 2, d, d ) using/storing the cache                      #
    PROC cached powmod 2dd = ( INT d )INT:
         BEGIN
            IF powmod2dd[ d ] < 0 THEN powmod2dd[ d ] := powmod( 2, d, d ) FI;
            powmod2dd[ d ]
         END # cached powmod 2dd # ;

    # returns TRUE if n is a Super Poulet number, FALSE otherwise            #
    PROC is super poulet = ( INT n )BOOL:
         IF   is prime[ n ] THEN FALSE
         ELIF NOT ODD n     THEN FALSE
         ELSE
            BOOL result := powmod( 2, n - 1, n ) = 1;
            FOR d FROM 3 BY 2 WHILE d * d <= n AND result DO
                IF n MOD d = 0 THEN
                    IF result := cached powmod 2dd( d ) = 2 THEN
                        INT q = n OVER d;
                        IF q /= d THEN
                           result := cached powmod 2dd( q ) = 2
                        FI
                    FI
                FI
            OD;
            result
         FI # is super poulet # ;

    INT  count     := 0;
    BOOL searching := TRUE;
    FOR pn FROM 3 BY 2 WHILE searching DO
        IF is super poulet( pn ) THEN
            IF   ( count +:= 1 ) <= 20 THEN
                print( ( " ", whole( pn, -5 ) ) );
                IF count MOD 10 = 0 THEN print( ( newline ) ) FI
            ELIF pn > 1 000 000 THEN
                print( ( newline, "Super-Poulet number ", whole( count, 0 ) ) );
                print( ( " (", whole( pn, 0 ), ") is the first over 1 000 000", newline ) );
                searching := FALSE
            FI
        FI
    OD
END
