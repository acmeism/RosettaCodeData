BEGIN # find some De Polignac Numbers - positive odd numbers that can't be    #
      # written as p + 2^n for some prime p and integer n                     #
    INT max number = 500 000; # maximum number we will consider               #
    # sieve the primes to max number                                          #
    [ 0 : max number ]BOOL prime;
    prime[ 0 ] := prime[ 1 ] := FALSE;
    prime[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB prime ) DO
        IF prime[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := FALSE OD
        FI
    OD;
    # table of powers of 2 greater than 2^0 ( up to around 2 000 000 )        #
    #       increase the table size if max number > 2 000 000                 #
    [ 1 : 20 ]INT powers of 2;
    BEGIN
        INT p2 := 1;
        FOR i TO UPB powers of 2 DO
            powers of 2[ i ] := ( p2 *:= 2 )
        OD
    END;
    # the numbers must be odd and not of the form p + 2^n                     #
    # either p is odd and 2^n is even and hence n > 0 and p > 2               #
    #     or 2^n is odd and p is even and hence n = 0 and p = 2               #
    INT dp count := 0;
    # n = 0, p = 2 - the only possibility is 3                                #
    FOR i BY 2 TO 3 DO
        INT p = 2;
        IF p + 1 /= i THEN
            print( ( whole( i, -5 ) ) );
            dp count +:= 1
        FI
    OD;
    # n > 0, p > 2                                                            #
    FOR i FROM 5 BY 2 TO max number DO
        BOOL found := FALSE;
        FOR p TO UPB powers of 2 WHILE NOT found AND i > powers of 2[ p ] DO
            found := prime[ i - powers of 2[ p ] ]
        OD;
        IF NOT found THEN
            IF ( dp count +:= 1 ) <= 50 THEN
                print( ( whole( i, -5 ) ) );
                IF dp count MOD 10 = 0 THEN print( ( newline ) ) FI
            ELIF dp count = 1 000 OR dp count = 10 000 THEN
                print( ( "The ", whole( dp count, -5 )
                       , "th De Polignac number is ", whole( i, -7 )
                       , newline
                       )
                     )
            FI
        FI
    OD;
    print( ( "Found ", whole( dp count, 0 )
           , " De Polignac numbers up to ", whole( max number, 0 )
           , newline
           )
         )
END
