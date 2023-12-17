BEGIN # find the radicals of some integers - the radical of n is the product #
      # of thr the distinct prime factors of n, the radical of 1 is 1        #

    INT max number = 1 000 000;         # maximum number we will consider    #
    [ 1 : max number ]INT upfc;         # unique prime factor counts         #
    [ 1 : max number ]INT radical;      # table of radicals                  #
    FOR i TO UPB upfc DO upfc[ i ] := 0; radical[ i ] := 1 OD;
    FOR i FROM 2 TO UPB upfc DO
        IF upfc[ i ] = 0 THEN
            radical[ i ] := i;
            upfc[    i ] := 1;
            FOR j FROM i + i BY i TO UPB upfc DO
                upfc[    j ] +:= 1;
                radical[ j ] *:= i
            OD
        FI
    OD;
    # show the radicals of the first 50 positive integers                    #
    print( ( "Radicals of 1 to 50:", newline ) );
    FOR i TO 50 DO
        print( ( whole( radical[ i ], -5 ) ) );
        IF i MOD 10 = 0 THEN print( ( newline ) ) FI
    OD;
    # radicals of some specific numbers                                      #
    print( ( newline ) );
    print( ( "Radical of  99999: ", whole( radical[  99999 ], 0 ), newline ) );
    print( ( "Radical of 499999: ", whole( radical[ 499999 ], 0 ), newline ) );
    print( ( "Radical of 999999: ", whole( radical[ 999999 ], 0 ), newline ) );
    print( ( newline ) );
    # find the maximum number of unique prime factors                        #
    INT max upfc := 0;
    # show the distribution of the unique prime factor counts                #
    FOR i TO UPB upfc DO IF upfc[ i ] > max upfc THEN max upfc := upfc[ i ] FI OD;
    [ 0 : max upfc ]INT dpfc; FOR i FROM LWB dpfc TO UPB dpfc DO dpfc[ i ] := 0 OD;
    FOR i TO UPB upfc DO
        dpfc[ upfc[ i ] ] +:= 1
    OD;
    print( ( "Distribution of radicals:", newline ) );
    FOR i FROM LWB dpfc TO UPB dpfc DO
        print( ( whole( i, -2 ), ": ", whole( dpfc[ i ], 0 ), newline ) )
    OD
END
