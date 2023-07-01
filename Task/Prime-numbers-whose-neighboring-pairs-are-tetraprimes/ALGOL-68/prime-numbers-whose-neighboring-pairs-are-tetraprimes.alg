BEGIN # find primes whose neighbouring pairs are tetraprimes - i.e. have 4   #
      # distinct prime factors                                               #

    PR read "rows.incl.a68" PR     # include row utilities, including MEDIAN #
    INT max prime = 10 000 000;     # the largest possible prime to comsider #
    # construct table of prime factor counts                                 #
    # numbers with non-distinct prime factors will have negative counts      #
    [ 0 : max prime + 2 ]INT pfc;
    FOR i FROM LWB pfc TO UPB pfc DO pfc[ i ] := 0 OD;
    FOR n FROM 2 TO UPB pfc OVER 2 DO
        IF pfc[ n ] = 0 THEN                                    # i is prime #
            INT power      := 1;
            INT n to power := n;
            INT start      := n + n;
            WHILE FOR j FROM start BY n to power TO UPB pfc DO
                      IF pfc[ j ] >= 0 THEN
                          # no duplicate factors yet                         #
                          pfc[ j ] +:= 1
                      ELSE
                          # already have a duplicate factor                  #
                          pfc[ j ] +:= -1
                      FI;
                      IF power > 1 THEN
                          IF pfc[ j ] > 0 THEN pfc[ j ] := - pfc[ j ] FI
                      FI
                  OD;
                  power +:= 1;
                  LONG INT long n to power := LENG n to power * n;
                  long n to power <= UPB pfc
            DO
                start := n to power := SHORTEN long n to power
            OD
        FI
    OD;

    # show the statistics and optionally the primes with a tetraprime pair   #
    #                     at offset 1 and offset 2 from the prime            #
    PROC show neighbour pairs = ( INT max n, BOOL show primes, INT offset 1, offset 2 )VOID:
         BEGIN
            # array of prime gaps, used to find the median gap               #
            # should be large enough for the stretch task                    #
            [ 1 : 12 000 ]INT gaps; FOR i TO UPB gaps DO gaps[ i ] := 0 OD;
            INT t count := 0, f7 count := 0;
            INT prev prime := 0;
            INT min gap := max int, max gap := 0, gap pos := 0;
            # note the lowest tetraprime is 210                              #
            FOR i FROM 211 BY 2 TO max n DO
                IF pfc[ i ] = 0 THEN
                    # have a prime                                           #
                    IF pfc[ i + offset 1 ] = 4 AND pfc[ i + offset 2 ] = 4 THEN
                        # the previous pair are tetraprimes                  #
                        IF prev prime > 0 THEN
                            INT this gap = i - prev prime;
                            IF min gap > this gap THEN min gap := this gap FI;
                            IF max gap < this gap THEN max gap := this gap FI;
                            gaps[ gap pos +:= 1 ] := this gap
                        FI;
                        prev prime := i;
                        IF ( i + offset 1 ) MOD 7 = 0 OR ( i + offset 2 ) MOD 7 = 0 THEN
                            f7 count +:= 1
                        FI;
                        t count +:= 1;
                        IF show primes THEN
                            print( ( " ", whole( i, -5 ) ) );
                            IF t count MOD 10 = 0 THEN print( ( newline ) ) FI
                        FI
                    FI
                FI
            OD;
            IF show primes THEN print( ( newline ) ) ELSE print( ( "       " ) ) FI;
            print( ( "Found ", whole( t count, 0 ), " such primes", " of which " ) );
            print( ( whole( f7 count, 0 ), " have 7 as a factor of one of the pair", newline ) );
            IF NOT show primes THEN print( ( "       " ) ) FI;
            print( ( "      gaps between the primes: min: ", whole( min gap, 0 ) ) );
            print( ( ", average: ", whole( ROUND AVERAGE gaps[ : gap pos ], 0 ) ) );
            print( ( ", median: ",  whole( ROUND MEDIAN  gaps[ : gap pos ], 0 ) ) );
            print( ( ", max: ", whole( max gap, 0 ), newline, newline ) )
        END # show neighbour paris # ;

    # show some tetraprimes and statistics about them                        #
    PROC show tetraprime neighbours = ( INT max n, BOOL show primes )VOID:
         BEGIN
            print( ( "Primes below ", whole( max n, 0 ) ) );
            print( ( " preceded by a tetraprime pair:", newline ) );
            show neighbour pairs( max n, show primes, -1, -2 );
            print( ( "Primes below ", whole( max n, 0 ) ) );
            print( ( " followed by a tetraprime pair:", newline ) );
            show neighbour pairs( max n, show primes,  1,  2 )
         END # show tetraprime pairs # ;

    # task                                                                   #
    show tetraprime neighbours(    100 000, TRUE  );
    show tetraprime neighbours(  1 000 000, FALSE );
    show tetraprime neighbours( 10 000 000, FALSE )

END
