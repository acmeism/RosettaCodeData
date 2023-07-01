BEGIN # find some magnanimous numbers - numbers where inserting a + between any #
      # digits ab=nd evaluatinf the sum results in a prime in all cases         #
    # returns the first n magnanimous numbers                                   #
    #         uses global sieve prime which must include 0 and be large enough  #
    #         for all possible sub-sequences of digits                          #
    OP MAGNANIMOUS = ( INT n )[]INT:
       BEGIN
            [ 1 : n ]INT result;
            INT          m count := 0;
            FOR i FROM 0 WHILE m count < n DO
                # split the number into pairs of digit seuences and check the sums of the pairs are all prime #
                INT  divisor   := 1;
                BOOL all prime := TRUE;
                WHILE divisor *:= 10;
                      IF   INT front = i OVER divisor;
                           front = 0
                      THEN FALSE
                      ELSE all prime := prime[ front + ( i MOD divisor ) ]
                      FI
                DO SKIP OD;
                IF all prime THEN result[ m count +:= 1 ] := i FI
            OD;
            result
       END; # MAGNANIMPUS #
    # prints part of a seuence of magnanimous numbers #
    PROC print magnanimous = ( []INT m, INT first, INT last, STRING legend )VOID:
         BEGIN
             print( ( legend, ":", newline ) );
             FOR i FROM first TO last DO print( ( " ", whole( m[ i ], 0 ) ) ) OD;
             print( ( newline ) )
         END ; # print magnanimous #
    # we assume the first 400 magnanimous numbers will be in 0 .. 1 000 000 #
    # so we will need a sieve of 0 up to 99 999 + 9 #
    [ 0 : 99 999 + 9 ]BOOL prime;
    prime[ 0 ] := prime[ 1 ] := FALSE; prime[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB prime ) DO
        IF prime[ i ] THEN FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := FALSE OD FI
    OD;
    # construct the sequence of magnanimous numbers #
    []INT m = MAGNANIMOUS 400;
    print magnanimous( m,   1,  45, "First 45 magnanimous numbers" );
    print magnanimous( m, 241, 250, "Magnanimous numbers 241-250"  );
    print magnanimous( m, 391, 400, "Magnanimous numbers 391-400"  )
END
