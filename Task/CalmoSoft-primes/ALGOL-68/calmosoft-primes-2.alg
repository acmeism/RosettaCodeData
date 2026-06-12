BEGIN # find the longest sequence of primes < 50 000 000 that sums to a prime#
      # called Calmosoft primes                                              #
    PR read "primes.incl.a68" PR
    INT max prime = 50 000 000;
    # sieve, count and sum the primes to max prime and replace the sieve     #
    # with a list of primes                                                  #
    [ 1 : max prime ]INT prime;
    INT   yes = 1, no = 0;
    prime[ 1 ] := 2;                           # the first prime in the list #
    prime[ 2 ] := yes;                              # first TRUE sieve value #
    INT      p count := 1;
    LONG INT p sum   := 2;
    FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := yes OD;
    FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := no  OD;
    INT root max prime = ENTIER sqrt( UPB prime );
    FOR i FROM 3 BY 2 TO root max prime DO
         IF prime[ i ] = yes THEN
             prime[ p count +:= 1 ] := i;
             p sum   +:= i;
             FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := no OD
         FI
    OD;
    FOR i FROM root max prime + IF ODD root max prime THEN 2 ELSE 1 FI BY 2 TO max prime DO
         IF prime[ i ] = yes THEN
             prime[ p count +:= 1 ] := i;
             p sum   +:= i
         FI
    OD;
    LONG INT  seq sum   := p sum;
    # find the longest sequence that sums to a prime                         #
    INT       max start := -1;
    INT       max end   := -1;
    INT       max len   := -1;
    LONG INT  max sum   := -1;
    FOR this start TO p count - 1
    WHILE
        INT      this end   := p count;
        INT      this len   := ( this end + 1 ) - this start;
        LONG INT this sum   := seq sum;
        IF ODD this len THEN
            IF this start = 1 THEN
                # the first prime is 2, the sequence must have even length   #
                this sum -:= prime[ this end ];
                this end -:= 1;
                this len -:= 1
            FI
        ELSE
            IF this start > 1 THEN
                # the first prime isn't 2, the sequence must have odd length #
                this sum -:= prime[ this end ];
                this end -:= 1;
                this len -:= 1
            FI
        FI;
        IF this len > max len THEN
            BOOL this prime := FALSE;
            WHILE IF   this end < this start OR this len < max len
                  THEN FALSE
                  ELSE NOT ( this prime := is probably prime( this sum ) )
                  FI
            DO
                this sum -:= prime[ this end       ];
                this sum -:= prime[ this end -:= 1 ];
                this end -:= 1;
                this len -:= 2
            OD;
            IF this prime AND this len > max len THEN
                max len   := this len; # found a longer sequence             #
                max start := this start;
                max end   := this end;
                max sum   := this sum
            FI
        FI;
        ( p count - this start ) > max len
    DO
        # the start prime won't be in the next sequence                      #
        seq sum -:= prime[ this start ]
    OD;
    print( ( "Longest sequence of Calmosoft primes up to ",    whole( prime[ p count ], 0 )
           , " has sum ", whole( max sum, 0 ), " and length ", whole( max len,                      0 )
           , newline
           )
         );
    IF max len < 12 THEN
        FOR i FROM max start   TO max end       DO print( ( " ", whole( prime[ i ], 0 ) ) ) OD
    ELSE
        FOR i FROM max start   TO max start + 6 DO print( ( " ", whole( prime[ i ], 0 ) ) ) OD;
        print( ( " ... " ) );
        FOR i FROM max end - 6 TO max end       DO print( ( " ", whole( prime[ i ], 0 ) ) ) OD
    FI
END
