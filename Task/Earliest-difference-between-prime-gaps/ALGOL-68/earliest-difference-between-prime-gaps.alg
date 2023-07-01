BEGIN # find the differences between primes for each value of the gap        #
      # the prime and the next                                               #
    PR read "primes.incl.a68" PR           # include prime utilities         #
    INT max prime     = 2 000 000;         # maximum prime we will consider  #
    []BOOL prime = PRIMESIEVE max prime;   # sieve the primes to max prime   #
    [ 1 : max prime OVER 2 ]INT start prime; # index of the first prime with #
                                             # gap of subscript / 2          #
    # find the prime gaps                                                    #
    FOR i TO UPB start prime DO start prime[ i ] := 0 OD;
    INT prev prime := 3;
    FOR i FROM 5 BY 2 TO UPB prime DO
        IF prime[ i ] THEN
            INT gap = ( i - prev prime ) OVER 2;
            IF start prime[ gap ] = 0 THEN
                start prime[ gap ] := prev prime
            FI;
            prev prime := i
        FI
    OD;

    # to reiterate the task: we must find the earliest start primes where    #
    # the distance betweeen the gaps is 10, 100, 1000, 10 000 etc.           #
    # The distance is the distance between the start prime with gap g and    #
    # start prime with the a gap of g + 2, e.g. 3 has a gap of 2 as the next #
    # prime is 5, 7 has a gap of 4 as the next prime is 11, so the distance  #
    # is: 7 - 3 = 4                                                          #

    # shows a prime gap                                                      #
    PROC show gap = ( INT start pos )VOID:
         print( ( whole( start prime[ start pos ], 0 )
                , "(", whole( start pos * 2, 0 ),")"
                , whole( start prime[ start pos ] + ( start pos * 2 ), 0 )
                )
              );
    # shows a prime gap distance                                             #
    PROC show distance = ( INT gap, pos )VOID:
         BEGIN
            print( ( "First distance > ", whole( gap, 0 )
                   , " betweeen prime gaps:", newline
                   , "    ", whole( ABS ( start prime[ pos + 1 ] - start prime[ pos ] ), 0 )
                   , " between "
                   )
                 );
            show gap( pos );
            print( " and " );
            show gap( pos + 1 );
            print( ( newline ) )
         END # show distance # ;
    INT g10 := 0, g100 := 0, gt := 0, g10t := 0, g100t := 0, gm := 0;
    FOR i TO UPB start prime - 1 DO
        IF start prime[ i ] /= 0 AND start prime[ i + 1 ] /= 0 THEN
            INT  distance = ABS ( start prime[ i + 1 ] - start prime[ i ] );
            IF   distance > 10
            THEN
                 IF g10   = 0 THEN g10    := i FI
            FI;
            IF   distance > 100
            THEN
                 IF g100  = 0 THEN g100  := i FI
            FI;
            IF   distance > 1 000
            THEN
                 IF gt    = 0 THEN gt    := i FI
            FI;
            IF   distance > 10 000
            THEN
                 IF g10t  = 0 THEN g10t  := i FI
            FI;
            IF   distance > 100 000
            THEN
                 IF g100t = 0 THEN g100t := i FI
            FI;
            IF   distance > 1 000 000
            THEN
                 IF gm    = 0 THEN gm     := i FI
            FI
        FI
    OD;
    show distance(        10, g10   );
    show distance(       100, g100  );
    show distance(     1 000, gt    );
    show distance(    10 000, g10t  );
    show distance(   100 000, g100t );
    show distance( 1 000 000, gm    )
END
