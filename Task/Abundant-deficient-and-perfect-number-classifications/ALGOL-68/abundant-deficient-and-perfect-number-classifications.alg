BEGIN # classify the numbers 1 : 20 000 as abudant, deficient or perfect #
    INT abundant count    := 0;
    INT deficient count   := 0;
    INT perfect count     := 0;
    INT abundant example  := 0;
    INT deficient example := 0;
    INT perfect example   := 0;
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
        IF     INT pd sum = pds[ n ];
               pd sum < n
        THEN
            # have a deficient number                              #
            deficient count    +:= 1;
            deficient example   := n
        ELIF   pd sum = n
        THEN
            # have a perfect number                                #
            perfect count      +:= 1;
            perfect example     := n
        ELSE # pd sum > n #
            # have an abundant number                              #
            abundant count     +:= 1;
            abundant example    := n
        FI
    OD;
    # displays the classification, count and example                   #
    PROC show result = ( STRING classification, INT count, example )VOID:
         print( ( "There are "
                , whole( count, -8 )
                , " "
                , classification
                , " numbers up to "
                , whole( max number, 0 )
                , " e.g.: "
                , whole( example, 0 )
                , newline
                )
              );

    # show how many of each type of number there are and an example    #
    show result( "abundant ",  abundant count,  abundant example  );
    show result( "deficient", deficient count, deficient example );
    show result( "perfect  ",   perfect count,   perfect example   )
END
