BEGIN # find the product of the min and max prime factors of some numbers #
    INT max number = 100; # maximum number we will consider               #
    # sieve the primes to max number                                      #
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
    # construct tables of the minimum and maximum prime factors of        #
    # numbers up to max number                                            #
    [ 1 : max number ]INT min pf; FOR i TO UPB min pf DO min pf[ i ] := 0 OD;
    [ 1 : max number ]INT max pf; FOR i TO UPB min pf DO max pf[ i ] := 0 OD;
    min pf[ 1 ] := 1;
    max pf[ 1 ] := 1;
    FOR i TO max number DO
        IF prime[ i ] THEN
            FOR j FROM i BY i TO UPB min pf DO
                IF min pf[ j ] = 0 THEN min pf[ j ] := i FI;
                max pf[ j ] := i
            OD
        FI
    OD;
    # print the products of the min and max prime factors                 #
    FOR i TO max number DO
        print( ( whole( min pf[ i ] * max pf[ i ], -5 ) ) );
        IF i MOD 10 = 0 THEN print( ( newline ) ) FI
    OD
END
