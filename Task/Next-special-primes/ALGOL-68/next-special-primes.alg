BEGIN # find some primes where the gap between the current prime and the     #
      # next is greater than the gap between previus primes and the current  #
    PR read "primes.incl.a68" PR                   # include prime utilities #
    INT max number = 1050;                 # largest number we will consider #
    []BOOL prime = PRIMESIEVE max number;
    print( ( "         this  next",      newline ) );
    print( ( "element prime prime  gap", newline ) );
    INT p count := 1, this prime := 2, next prime := 3;
    PROC show prime = ( INT gap )VOID:
    BEGIN
        print( ( "  ", whole( p count, - 5), ":", whole( this prime, - 5 ) ) );
        print( ( " ", whole( next prime, - 5 ), whole( gap, - 5 ) ) );
        print( ( newline ) )
    END # show prime # ;
    # the first gap is 1 (between 2 and 3) the gap between all other primes  #
    # is even so we treat 2-3 as a special case                              #
    show prime( 1 );
    INT p gap := 0;
    WHILE this prime < max number DO
        this prime := next prime;
        WHILE   p gap      +:= 2;
                next prime  := this prime + p gap;
                IF next prime > max number
                THEN FALSE
                ELSE NOT prime[ next prime ]
                FI
        DO SKIP OD;
        IF next prime < max number THEN
                p count +:= 1;
                show prime( p gap )
        FI
    OD
END
