BEGIN # Kempner numbers - translation of XPL0 #

    [ 1 : 20 ]LONG INT fa;                  # will hold the factors found by PROC prime factors #
    [ 1 : 20 ]INT      ex;                # will hold the exponents found by PROC prime factors #
    PROC prime factors = ( LONG INT m )INT:    # Factorize n into primes and store in fa and ex #
         BEGIN                                                # Returns number of prime factors #
            LONG INT n := m;
            INT      c := 0;
            IF NOT ODD n THEN
                c := 1;
                fa[ 1 ] := 2;
                ex[ 1 ] := 1;
                WHILE NOT ODD ( n OVERAB 2 ) DO
                    ex[ 1 ] +:= 1
                OD
            FI;
            LONG INT p := 3;
            WHILE n > 1 AND p * p <= n DO
                IF n MOD p = 0 THEN
                    c +:= 1;
                    fa[ c ] := p;
                    ex[ c ] := 1;
                    WHILE ( n OVERAB p ) MOD p = 0 DO
                        ex[ c ] +:= 1
                    OD
                FI;
                p +:= 2
            OD;
            IF n /= 1 THEN
                c +:= 1;
                fa[ c ] := n;
                ex[ c ] := 1
            FI;
            c
         END # prime factors # ;

    PROC valp = ( LONG INT m, p )LONG INT:                  # Compute exponent of prime p in m! #
         BEGIN
            LONG INT n := m, s := 0;
            WHILE n /= 0 DO
                n OVERAB p;
                s    +:= n
            OD;
            s
         END  # valp # ;

    PROC k = ( LONG INT p, e )LONG INT:           # Find smallest t such that valp( t, p ) >= e #
         IF e <= p THEN
            e * p
         ELSE
            LONG INT t := e * ( p - 1 ) OVER p * p;
            WHILE valp( t, p ) < e DO t +:= p OD;
            t
         FI # k # ;

    PROC kempner = ( LONG INT m )LONG INT:             # Compute least t such that m divides t! #
         IF m = 1 THEN
            1
         ELSE
            LONG INT max := 0;
            FOR i TO prime factors( m ) DO
                LONG INT t := k( fa[ i ], ex[ i ] );
                IF t > max THEN max := t FI
            OD;
            max
         FI # kempner # ;

    BEGIN

        print( ( "The first 50 Kempner numbers are:", newline ) );
        FOR kn TO 50 DO
            print( ( whole( kempner( kn ), -3 ) ) );
            IF kn MOD 10 = 0 THEN print( ( newline ) ) FI
        OD;

        LONG INT kfrom = 77135679311, kto = 77135679321;
        print( ( newline, "Kempner numbers for the range " ) );
        print( ( whole( kfrom, 0 ), " to ", whole( kto, 0 ), ":", newline ) );
        LONG INT n := kfrom - 1;   # FOR loop counters have to be INT so need a WHILE loop here #
        WHILE ( n +:= 1 ) <= kto DO
            print( ( "S(", whole( n, 0 ), ") = ", whole( kempner( n ), 0 ), newline ) )
        OD

    END
END
