BEGIN # find all primes with strictly decreasing digits                      #
    PR read "primes.incl.a68" PR                   # include prime utilities #
    PR read "rows.incl.a68"   PR                   # include array utilities #
    [ 1 : 512 ]INT primes;         # there will be at most 512 (2^9) primes  #
    INT p count := 0;                        # number of primes found so far #
    FOR d1 FROM 0 TO 1 DO
        INT n1 = IF d1 = 1 THEN 9 ELSE 0 FI;
        FOR d2 FROM 0 TO 1 DO
            INT n2 = IF d2 = 1 THEN ( n1 * 10 ) + 8 ELSE n1 FI;
            FOR d3 FROM 0 TO 1 DO
                INT n3 = IF d3 = 1 THEN ( n2 * 10 ) + 7 ELSE n2 FI;
                FOR d4 FROM 0 TO 1 DO
                    INT n4 = IF d4 = 1 THEN ( n3 * 10 ) + 6 ELSE n3 FI;
                    FOR d5 FROM 0 TO 1 DO
                        INT n5 = IF d5 = 1 THEN ( n4 * 10 ) + 5 ELSE n4 FI;
                        FOR d6 FROM 0 TO 1 DO
                            INT n6 = IF d6 = 1 THEN ( n5 * 10 ) + 4 ELSE n5 FI;
                            FOR d7 FROM 0 TO 1 DO
                                INT n7 = IF d7 = 1 THEN ( n6 * 10 ) + 3 ELSE n6 FI;
                                FOR d8 FROM 0 TO 1 DO
                                    INT n8 = IF d8 = 1 THEN ( n7 * 10 ) + 2 ELSE n7 FI;
                                    FOR d9 FROM 0 TO 1 DO
                                        INT n9 = IF d9 = 1 THEN ( n8 * 10 ) + 1 ELSE n8 FI;
                                        IF n9 > 0 THEN
                                            IF is probably prime( n9 ) THEN
                                                # have a prime with strictly descending digits #
                                                primes[ p count +:= 1 ] := n9
                                            FI
                                        FI
                                    OD
                                OD
                            OD
                        OD
                    OD
                OD
            OD
        OD
    OD;
    QUICKSORT primes FROMELEMENT 1 TOELEMENT p count;     # sort the primes #
    # display the primes                                                    #
    FOR i TO p count DO
        print( ( "  ", whole( primes[ i ], -8 ) ) );
        IF i MOD 10 = 0 THEN print( ( newline ) ) FI
    OD
END
