BEGIN # find Erdős primes - primes p where p-k! is composite for all 1<=k!<p #
    # returns TRUE if p is an Erdős prime #
    PROC is erdos prime = ( INT p )BOOL:
         IF NOT prime[ p ]
         THEN FALSE
         ELSE
            BOOL result := TRUE;
            FOR k WHILE factorial[ k ] < p AND result DO
                result := NOT prime[ p - factorial[ k ] ]
            OD;
            result
         FI # is erdos prime # ;
    INT max prime = 1 000 000;             # maximum number we will consider #
    INT max erdos =     7 875;                 # maximum Erdős prime to find #
    # construct a table of factorials large enough for max prime             #
    [ 1 : 12 ]INT factorial;
    factorial[ 1 ] := 1;
    FOR f FROM 2 TO UPB factorial DO
        factorial[ f ] := factorial[ f - 1 ] * f
    OD;
    PR read "primes.incl.a68" PR                   # include prime utilities #
    []BOOL prime = PRIMESIEVE max prime;     # sieve the primes to max prime #
    INT max show = 2 500;
    # find the Erdős primes, showing the ones up to max show                 #
    INT e count := 0;
    IF is erdos prime( 2 ) THEN
        print( ( " 2" ) );
        e count +:= 1
    FI;
    INT last erdos := 0;
    FOR p FROM 3 BY 2 TO max show DO
        IF is erdos prime( p ) THEN
            print( ( " ", whole( p, 0 ) ) );
            last erdos := p;
            e count   +:= 1
        FI
    OD;
    print( ( newline, "Found ", whole( e count, 0 )
           , " Erdos primes up to ", whole( max show, 0 ), newline ) );
    # find the max erdos'th Erdős prime #
    FOR p FROM max show WHILE e count < max erdos DO
        IF is erdos prime( p ) THEN
            last erdos := p;
            e count   +:= 1
        FI
    OD;
    print( ( whole( last erdos, 0 ), " is Erdos prime ", whole( e count, 0 ), newline ) )
END
