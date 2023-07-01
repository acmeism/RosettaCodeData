BEGIN # find some Sphenic numbers - numbers that are the product of three     #
      # distinct primes                                                       #
    PR read "primes.incl.A68" PR                    # include prime utilities #
    INT max sphenic   = 1 000 000;          # maximum number we will consider #
    INT max prime     = max sphenic OVER ( 2 * 3 );    # maximum prime needed #
    []BOOL prime      = PRIMESIEVE max prime;
    # construct a list of the primes up to the maximum prime to consider      #
    []INT  prime list = EXTRACTPRIMESUPTO max prime FROMPRIMESIEVE prime;
    # form a sieve of Sphenic numbers                                         #
    [ 1 : max sphenic ]BOOL sphenic;
    FOR i TO UPB sphenic DO sphenic[ i ] := FALSE OD;
    INT cube root max = ENTIER exp( ln( max sphenic ) / 3 );
    FOR i WHILE INT p1 = prime list[ i ];
                p1 < cube root max
    DO
        FOR j FROM i + 1 WHILE INT p2   = prime list[ j ];
                               INT p1p2 = p1 * p2;
                               ( p1p2 * p2 ) < max sphenic
        DO
            INT max p3 = max sphenic OVER p1p2;
            FOR k FROM j + 1 TO UPB prime list WHILE INT p3 = prime list[ k ];
                                                     p3 <= max p3
            DO
                sphenic[ p1p2 * p3 ] := TRUE
            OD
        OD
    OD;
    # show the Sphenic numbers up to 1 000 and triplets to 10 000             #
    print( ( "Sphenic numbers up to 1 000:", newline ) );
    INT s count := 0;
    FOR i TO 1 000 DO
        IF sphenic[ i ] THEN
            print( ( whole( i, -5 ) ) );
            IF ( s count +:= 1 ) MOD 15 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    print( ( newline ) );
    print( ( "Sphenic triplets up to 10 000:", newline ) );
    INT t count := 0;
    FOR i TO 10 000 - 2 DO
        IF sphenic[ i ] AND sphenic[ i + 1 ] AND sphenic[ i + 2 ] THEN
            print( ( "  (", whole( i,     -4 )
                   , ", ",  whole( i + 1, -4 )
                   , ", ",  whole( i + 2, -4 )
                   , ")"
                   )
                 );
            IF ( t count +:= 1 ) MOD 3 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    # count the Sphenic numbers and Sphenic triplets and find specific        #
    # Sphenic numbers and triplets                                            #
    s count := t count := 0;
    INT s200k := 0;
    INT t5k   := 0;
    FOR i TO UPB sphenic - 2 DO
        IF sphenic[ i ] THEN
            s count +:= 1;
            IF s count = 200 000 THEN
                # found the 200 000th Sphenic number                          #
                s200k := i
            FI;
            IF sphenic[ i + 1 ] AND sphenic[ i + 2 ] THEN
                t count +:= 1;
                IF t count = 5 000 THEN
                    # found the 5 000th Sphenic triplet                       #
                    t5k := i
                FI
            FI
        FI
    OD;
    FOR i FROM UPB sphenic - 1 TO UPB sphenic DO
        IF sphenic[ i ] THEN
            s count +:= 1
        FI
    OD;
    print( ( newline ) );
    print( ( "Number of Sphenic numbers  up to 1 000 000: ", whole( s count, -8 ), newline ) );
    print( ( "Number of Sphenic triplets up to 1 000 000: ", whole( t count, -8 ), newline ) );
    print( ( "The 200 000th Sphenic number:  ", whole( s200k, 0 ) ) );
    # factorise the 200 000th Sphenic number                                  #
    INT f count := 0;
    FOR i WHILE f count < 3 DO
        INT p = prime list[ i ];
        IF s200k MOD p = 0 THEN
            print( ( IF ( f count +:= 1 ) = 1 THEN ": " ELSE " * " FI
                   , whole( p, 0 )
                   )
                 )
        FI
    OD;
    print( ( newline ) );
    print( ( "The   5 000th Sphenic triplet: "
           , whole( t5k, 0 ), ", ", whole( t5k + 1, 0 ), ", ", whole( t5k + 2, 0 )
           , newline
           )
         )
END
