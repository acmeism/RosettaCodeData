BEGIN # find some pierpoint primes of the first kind (2^u3^v + 1)             #
      #                              and second kind (2^u3^v - 1)             #
    # construct a sieve of primes up to 10 000                                #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 10 000;
    # returns the minimum of a and b                                          #
    PROC min = ( INT a, b )INT: IF a < b THEN a ELSE b FI;
    # returns TRUE if p is prime, FALSE otherwise                             #
    PROC is prime = ( INT p )BOOL:
         IF   NOT ODD p
         THEN p = 2
         ELIF p <= UPB prime
         THEN prime[ p ] # small enough to use the sieve                      #
         ELSE            # use trial division by the sieved primes            #
            BOOL probably prime := TRUE;
            FOR d FROM 3 BY 2 WHILE d * d <= p AND probably prime DO
                IF prime[ d ] THEN probably prime := p MOD d /= 0 FI
            OD;
            probably prime
         FI; # is prime #
    # sets the elements of pp1 to the first UPB pp1 Pierpoint primes of the   #
    #       first kind and pp2 to the first UPB pp2 Pierpoint primes of the   #
    #      second kind                                                        #
    PROC find pierpoint = ( REF[]INT pp1, pp2 )VOID:
         BEGIN
            # saved 3-smooth values                                           #
            # - only the currently active part of the seuence is kept         #
            INT three smooth limit = 33;
            [ 1 : three smooth limit * 3 ]INT s3s; FOR i TO UPB s3s DO s3s[ i ] := 0 OD;
            INT pp1 pos := LWB pp1 - 1, pp2 pos := LWB pp2 - 1;
            INT pp1 max  = UPB pp1;
            INT pp2 max  = UPB pp2;
            INT p2, p3, last2, last3;
            INT s pos := s3s[ 1 ] := last2 := last3 := p2 := p3 := 1;
            FOR n FROM 2 WHILE pp1 pos < pp1 max OR pp2 pos < pp2 max DO
                # the next 3-smooth number is the lowest of the next          #
                #     multiples of 2 and 3                                    #
                INT m = min( p2, p3 );
                IF pp1 pos < pp1 max THEN
                    IF  INT first = m + 1;
                        is prime( first )
                    THEN # have a Pierpoint prime of the first kind           #
                        pp1[ pp1 pos +:= 1 ] := first
                    FI
                FI;
                IF pp2 pos < pp2 max THEN
                    IF  INT second = m - 1;
                        is prime( second )
                    THEN # have a Pierpoint prime of the second kind          #
                        pp2[ pp2 pos +:= 1 ] := second
                    FI
                FI;
                s3s[ s pos +:= 1 ] := m;
                IF m = p2 THEN p2 := 2 * s3s[ last2 +:= 1 ] FI;
                IF m = p3 THEN p3 := 3 * s3s[ last3 +:= 1 ] FI;
                INT last min = IF last2 > last3 THEN last3 ELSE last2 FI;
                IF last min > three smooth limit THEN
                    # shuffle the sequence down, over the now unused bits     #
                    INT new pos := 0;
                    FOR pos FROM last min TO s pos DO
                        s3s[ new pos +:= 1 ] := s3s[ pos ]
                    OD;
                    INT diff := last min - 1;
                    last2   -:= diff;
                    last3   -:= diff;
                    s pos   -:= diff
                FI
            OD
         END; # find pierpoint #
    # prints a table of Pierpoint primes of the specified kind                #
    PROC print pierpoint = ( []INT primes, STRING kind )VOID:
         BEGIN
            print( ( "The first "
                   , whole( ( UPB primes + 1 ) - LWB primes, 0 )
                   , " Pierpoint primes of the "
                   , kind
                   , " kind:"
                   , newline
                   )
                 );
            INT p count := 0;
            FOR i FROM LWB primes TO UPB primes DO
                print( ( " ", whole( primes[ i ], -8 ) ) );
                IF ( p count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
            OD;
            print( ( newline ) )
         END; # print pierpoint #
    # find the first 50 Pierpoint primes of the first and second kinds        #
    INT max pierpoint    = 50;
    [ 1 : max pierpoint ]INT pfirst;
    [ 1 : max pierpoint ]INT psecond;
    find pierpoint( pfirst, psecond );
    # show the Pierpoint primes                                               #
    print pierpoint( pfirst,  "First"  );
    print pierpoint( psecond, "Second" )
END
