BEGIN # find some n-smooth numbers - numbers with no prime factors above n    #

    # primes needed for the task                                              #
    []INT prime = ( 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 );

    # mode that can hold the largest required n-smooth number - we assume     #
    # LONG LONG INT with the default precision will be sufficient             #
    MODE SINT = LONG LONG INT;

    # returns the minimum value in an array of smooth numbers                 #
    OP   MIN = ( []SINT a )SINT:
         IF UPB a < LWB a THEN 0
         ELSE
            SINT result := a[ LWB a ];
            FOR i FROM LWB a + 1 TO UPB a DO IF result > a[ i ] THEN result := a[ i ] FI OD;
            result
         FI # MIN # ;

    # returns the first count n-smooth numbers                                #
    PRIO SMOOTH = 9;
    OP   SMOOTH = ( INT n, INT count )[]SINT:
         IF n > prime[ UPB prime ] THEN
            print( ( "Can't find ", whole( n, 0 ), "-smooth numbers", newline ) );
            stop
         ELSE
            # find n in the list of primes                                    #
            INT p pos := 0;
            FOR pos FROM LWB prime TO UPB prime WHILE p pos = 0 DO
                IF prime[ pos ] = n THEN p pos := pos FI
            OD;
            IF p pos = 0 THEN
                print( ( "There are no """, whole( n, 0 ), "-smooth"" numbers", newline ) );
                stop
            ELSE
                # n is a prime we can handle                                   #
                [ 1 : p pos ]SINT p;    FOR i TO UPB p DO p[ i ] := prime[ i ] OD;
                [ 1 : p pos ]INT  last; FOR i TO UPB last DO last[ i ] := 1 OD;
                [ 1 : count ]SINT seq;
                # 1 is the first n-smooth number for any n: 2^0 * 3^0 * ...    #
                IF count > 0 THEN
                    # the caller does want some numbers...                     #
                    seq[ 1 ]    := 1;
                    FOR s pos FROM 2 TO count DO
                        # the next number is the lowest of the next multiples  #
                        #  of 2, 3, 5, ...                                     #
                        SINT m = MIN p;
                        seq[ s pos ] := m;
                        FOR i TO UPB p DO
                            IF m = p[ i ] THEN p[ i ] := prime[ i ] * seq[ last[ i ] +:= 1 ] FI
                        OD
                    OD
                FI;
                seq
            FI
         FI # SMOOTH # ;

    # show the n-smooth numbers in positions f pos to t pos                    #
    #      with n starting at the p posth prime                                #
    PROC show smooth = ( INT p pos, f pos, t pos )VOID:
         FOR n pos FROM p pos TO UPB prime DO
            INT n = prime[ n pos ];
            []SINT n smooth = n SMOOTH t pos;
            print( ( "    ", whole( n, 0 ), "-smooth numbers are: ", newline, "       " ) );
            FOR i FROM f pos TO t pos DO
                print( ( " ", whole( n smooth[ i ], 0 ) ) )
            OD;
            print( ( newline ) )
         OD # show smooth # ;


    print( ( "The first", newline ) );
    show smooth( 1, 1, 25 );
    print( ( newline ) );

    print( ( "The 3000th, 3001st and 3002nd", newline ) );
    show smooth( 2, 3000, 3002 )

END
