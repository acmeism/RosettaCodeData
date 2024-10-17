BEGIN
    # count/show some square free numbers                                           #
    # a number is square free if not divisible by any square and so not divisible   #
    # by any squared prime                                                          #
    # to satisfy the task we need to know the primes up to root 1 000 000 000 145   #
    # and the square free numbers up to 1 000 000                                   #
    # sieve the primes                                                              #
    LONG INT one trillion = LENG 1 000 000 * LENG 1 000 000;
    INT prime max = ENTIER SHORTEN long sqrt( one trillion + 145 ) + 1;
    [ prime max ]BOOL prime; FOR i TO UPB prime DO prime[ i ] := TRUE OD;
    FOR s FROM 2 TO ENTIER sqrt( prime max ) DO
        IF prime[ s ] THEN
            FOR p FROM s * s BY s TO prime max DO prime[ p ] := FALSE OD
        FI
    OD;
    # sieve the square free integers                                                #
    INT sf max = 1 000 000;
    [ sf max ]BOOL square free;FOR i TO UPB square free DO square free[ i ] := TRUE OD;
    FOR s FROM 2 TO ENTIER sqrt( sf max ) DO
        IF prime[ s ] THEN
            INT q = s * s;
            FOR p FROM q BY q TO sf max DO square free[ p ] := FALSE OD
        FI
    OD;
    # returns TRUE if n is square free, FALSE otherwise                             #
    PROC is square free = ( LONG INT n )BOOL:
         IF n <= sf max THEN square free[ SHORTEN n ]
         ELSE
            # n is larger than the sieve - use trial division                       #
            INT max factor  = ENTIER SHORTEN long sqrt( n ) + 1;
            BOOL result    := TRUE;
            FOR f FROM 2 TO max factor WHILE result DO
                IF prime[ f ] THEN
                    # have a prime                                                  #
                    result := ( n MOD ( LENG f * LENG f ) /= 0 )
                FI
            OD;
            result
         FI # is square free # ;
    # returns the count of square free numbers between m and n (inclusive)          #
    PROC count square free = ( INT m, n )INT:
         BEGIN
            INT count := 0;
            FOR i FROM m TO n DO IF square free[ i ] THEN count +:= 1 FI OD;
            count
         END # count square free # ;

    BEGIN # task requirements                                                       #
        # show square free numbers from 1 -> 145                                    #
        print( ( "Square free numbers from 1 to 145", newline ) );
        INT    count := 0;
        FOR i TO 145 DO
            IF is square free( i ) THEN
                print( ( whole( i, -4 ) ) );
                count +:= 1;
                IF count MOD 20 = 0 THEN print( ( newline ) ) FI
            FI
        OD;
        print( ( newline ) );
        # show square free numbers from 1 trillion -> one trillion + 145            #
        print( ( "Square free numbers from 1 000 000 000 000 to 1 000 000 000 145", newline ) );
        count := 0;
        FOR i FROM 0 TO 145 DO
            IF is square free( one trillion + i ) THEN
                print( ( whole( one trillion + i, -14 ) ) );
                count +:= 1;
                IF count MOD 5 = 0 THEN print( ( newline ) ) FI
            FI
        OD;
        print( ( newline ) );
        # show counts of square free numbers                                        #
        INT sf       100 :=              count square free(       1,       100 );
        print( ( "square free numbers between 1 and       100: ", whole( sf       100, -6 ), newline ) );
        INT sf     1 000 := sf     100 + count square free(     101,     1 000 );
        print( ( "square free numbers between 1 and     1 000: ", whole( sf     1 000, -6 ), newline ) );
        INT sf    10 000 := sf   1 000 + count square free(   1 001,    10 000 );
        print( ( "square free numbers between 1 and    10 000: ", whole( sf    10 000, -6 ), newline ) );
        INT sf   100 000 := sf  10 000 + count square free(  10 001,   100 000 );
        print( ( "square free numbers between 1 and   100 000: ", whole( sf   100 000, -6 ), newline ) );
        INT sf 1 000 000 := sf 100 000 + count square free( 100 001, 1 000 000 );
        print( ( "square free numbers between 1 and 1 000 000: ", whole( sf 1 000 000, -6 ), newline ) )
    END
END
