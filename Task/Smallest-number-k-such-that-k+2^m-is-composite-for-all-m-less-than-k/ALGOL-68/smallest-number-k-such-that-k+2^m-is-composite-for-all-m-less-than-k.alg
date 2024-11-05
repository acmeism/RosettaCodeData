BEGIN # find the smallest k such that k+2^m is composite for all 0 < m < k   #
      # this is sequence A033919 on the OEIS                                 #
    PR precision 5000 PR                # set the precision of LONG LONG INT #
    PR read "primes.incl.a68" PR                   # include prime utilities #

    PROC is a033919 = ( INT ak )BOOL:
         BEGIN
            LONG LONG INT big k   = ak;
            LONG LONG INT p2     := 2;
            BOOL          result := FALSE;
            TO ak - 1 WHILE result := NOT is probably prime( big k + p2 ) DO p2 *:= 2 OD;
            result
         END # is a033919 # ;

    INT count := 0;
    FOR k FROM 3 BY 2 WHILE count < 5 DO
        IF is a033919( k ) THEN
            print( ( whole( k, 0 ), " " ) );
            count +:= 1
        FI
    OD;
    print( ( newline ) )

END
