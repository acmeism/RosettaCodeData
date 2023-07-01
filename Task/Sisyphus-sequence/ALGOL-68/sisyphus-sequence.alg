BEGIN # generate elements of the Sysiphus Sequence: see OEIS A350877         #

    # returns the largest element in a                                       #
    OP   MAX = ( []INT a )INT:
         IF LWB a >UPB a THEN 0
         ELSE
            INT result := a[ LWB a ];
            FOR i FROM LWB a + 1 TO UPB a DO
                IF result < a[ i ] THEN result := a[ i ] FI
            OD;
            result
         FI # MAX # ;
    # sieve the primes                                                       #
    INT sieve max = 1 000 000 000; ### CHANGE TO E.G.: 100 000 000 FOR ALGOL 68G ###
    BOOL is odd  := TRUE;
    [ sieve max ]BOOL sieve; FOR i TO UPB sieve DO sieve[ i ] := is odd; is odd := NOT is odd OD;
    sieve[ 1 ] := FALSE;
    sieve[ 2 ] := TRUE;
    FOR s FROM 3 BY 2 TO ENTIER sqrt( sieve max ) DO
        IF sieve[ s ] THEN
            FOR p FROM s * s BY s TO sieve max DO sieve[ p ] := FALSE OD
        FI
    OD;
    [ 1 : 250 ]INT pos;                # positions of 1..250 in the sequence #
    [ 1 : 250 ]INT occurs;            # occurances of 1..250 in the sequence #
    FOR i TO UPB pos DO pos[ i ] := occurs[ i ] := 0 OD;
    INT max count = sieve max OVER 10;            # highest element required #
    INT s               := 1;            # the first element is defined as 1 #
    INT count           := 1;               # count of elements found so far #
    print( ( "Sysiphus sequence - first 100 elements:", newline ) );
    print( ( whole( s, -4 ) ) );
    pos[ s ]            := count;
    INT next to show    := 1000;          # next power-of-10 element to show #
    INT last used prime := 0;                   # latest prime from the list #
    INT p pos           := 0;                # current position in the sieve #
    WHILE count < max count DO
        # calculate the next element                                         #
        IF NOT ODD s THEN
            # the previous element was even - halve it                       #
            s OVERAB 2
        ELSE
            # the previous element was odd: add the next prime from the list #
            WHILE p pos +:= 1;
                  NOT sieve[ p pos ]
            DO SKIP OD;
            s +:= ( last used prime := p pos )
        FI;
        count +:= 1;
        IF count <= 100 THEN            # have one of the first 100 elements #
            print( ( whole( s, -4 ) ) );
            IF count MOD 10 = 0 THEN print( ( newline ) ) FI;
            IF count = 100      THEN print( ( newline ) ) FI
        ELIF count = next to show THEN
            # reached a power of ten count                                   #
            print( ( "sequence element ", whole( count, -10 )
                   , " is ", whole( s, -10 )
                   , ", highest used prime is ", whole( last used prime, -10 )
                   , newline
                   )
                 );
            next to show *:= 10
        FI;
        IF s < UPB pos THEN
            IF pos[ s ] = 0 THEN
                # have the first appearence of s in the sequence             #
                pos[ s ] := count
            FI;
            occurs[ s ] +:= 1
        FI
    OD;
    print( ( newline ) );
    print( ( "Integers in 1..", whole( UPB pos, 0 )
           , " not found in the sequence up to element ", whole( max count, 0 )
           , ":", newline
           )
         );
    FOR i TO UPB pos DO
        IF pos[ i ] = 0 THEN print( ( " ", whole( i, 0 ) ) ) FI
    OD;
    print( ( newline ) );
    INT max occurs = MAX occurs;
    print( ( "Integers in 1..", whole( UPB pos, 0 )
           , " that occur most often ( ", whole( max occurs, 0 )
           , " times ) up to element ", whole( max count, 0 )
           , ":", newline
           )
         );
    FOR i TO UPB occurs DO
        IF occurs[ i ] = max occurs THEN print( ( " ", whole( i, 0 ) ) ) FI
    OD;
    print( ( newline, newline ) );
    print( ( "Position in the sequence of 1..100 up to element ", whole( max count, 0 )
           , ":", newline
           )
         );
    FOR i TO 100 DO
        print( ( IF pos[ i ] = 0 THEN " unknown" ELSE whole( pos[ i ], -8 ) FI ) );
        IF i MOD 8 = 0 THEN print( ( newline ) ) FI
    OD
END
