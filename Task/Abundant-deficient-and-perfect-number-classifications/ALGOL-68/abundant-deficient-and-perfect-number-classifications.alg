BEGIN # classify the numbers 1 : 20 000 as abudant, deficient or perfect #
    INT abundant count    := 0;
    INT deficient count   := 0;
    INT perfect count     := 0;
    INT max number         = 20 000;
    # construct a table of the proper divisor sums                 #
    [ 1 : max number ]INT pds;
    pds[ 1 ] := 0;
    FOR i FROM 2 TO UPB pds DO pds[ i ] := 1 OD;
    FOR i FROM 2 TO UPB pds DO
        FOR j FROM i + i BY i TO UPB pds DO pds[ j ] +:= i OD
    OD;
    # classify the numbers                                         #
    FOR n TO max number DO
        INT pd sum = pds[ n ];
        IF     pd sum < n THEN
            deficient count +:= 1
        ELIF   pd sum = n THEN
            perfect count   +:= 1
        ELSE # pd sum > n #
            abundant count  +:= 1
        FI
    OD;
    print( ( "abundant  ", whole(  abundant count, 0 ), newline ) );
    print( ( "deficient ", whole( deficient count, 0 ), newline ) );
    print( ( "perfect   ", whole(   perfect count, 0 ), newline ) )
END
