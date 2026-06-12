BEGIN # find the longest sequence of primes < 100 that sums to a prime       #
      # called Calmosoft primes                                              #
    []INT prime = (  2,  3,  5,  7, 11, 13, 17, 19, 23, 29, 31, 37
                  , 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
                  ); # primes up to 100                                      #
    # returns TRUE if n is prime, FALSE otherwise - uses trial division      #
    PROC is prime = ( INT n )BOOL:
         IF   n < 3       THEN n = 2
         ELIF n MOD 3 = 0 THEN n = 3
         ELIF NOT ODD n   THEN FALSE
         ELSE
             BOOL is a prime := TRUE;
             FOR f FROM 5 BY 2 WHILE f * f <= n AND is a prime DO
                 is a prime := n MOD f /= 0
             OD;
             is a prime
         FI # is prime # ;
    # calculate the sum of all the primes                                    #
    INT seq sum := 0; FOR i FROM LWB prime TO UPB prime DO seq sum +:= prime[ i ] OD;
    # find the longest sequence that sums to a prime                         #
    INT  max start := -1;
    INT  max end   := -1;
    INT  max len   := -1;
    INT  max sum   := -1;
    FOR this start FROM LWB prime TO UPB prime - 1
    WHILE
        INT  this end   := UPB prime;
        INT  this len   := ( this end + 1 ) - this start;
        IF this len > max len THEN
            INT  this sum   := seq sum;
            BOOL this prime := FALSE;
            WHILE this end >= this start
              AND NOT ( this prime := is prime( this sum ) )
              AND this len > max len
            DO
                this sum -:= prime[ this end ];
                this end -:= 1;
                this len -:= 1
            OD;
            IF this prime AND this len > max len THEN
                max len   := this len; # found a longer sequence             #
                max start := this start;
                max end   := this end;
                max sum   := this sum
            FI
        FI;
        ( UPB prime - this start ) > max len
    DO
        # the start prime won't be in the next sequence                      #
        seq sum -:= prime[ this start ]
    OD;
    print( ( "Longest sequence of Calmosoft primes up to ",    whole( prime[ UPB prime ], 0 )
           , " has sum ", whole( max sum, 0 ), " and length ", whole( max len,            0 )
           , newline
           )
         );
    FOR i FROM max start TO max end DO print( ( " ", whole( prime[ i ], 0 ) ) ) OD
END
