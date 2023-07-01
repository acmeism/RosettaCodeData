BEGIN # Multiplicative Digital Roots                                              #
    # structure to hold the results of calculating the digital root & persistence #
    MODE DR = STRUCT( INT root, INT persistence );
    # returns the product of the digits of number                                 #
    OP DIGITPRODUCT = ( INT number )INT:
       BEGIN
            INT    result := 1;
            INT    rest   := number;
            WHILE result TIMESAB ( rest MOD 10 );
                  rest   OVERAB  10;
                  rest > 0
            DO SKIP OD;
            result
       END; # DIGITPRODUCT #
    # calculates the multiplicative digital root and persistence of number        #
    OP MDROOT = ( INT number )DR:
       BEGIN
            INT mp  := 0;
            INT mdr := ABS number;
            WHILE mdr > 9 DO
                mp +:= 1;
                mdr := DIGITPRODUCT mdr
            OD;
            ( mdr, mp )
       END; # MDROOT #
    # prints a number and its MDR and MP                                          #
    PROC print md root = ( INT number )VOID:
         BEGIN
            DR mdr = MDROOT( number );
            print( ( whole( number, -6 ), ": MDR: ", whole( root OF mdr, 0 ), ", MP: ",  whole( persistence OF mdr, -2 ), newline ) )
         END; # print md root #
    # prints the first few numbers with each possible Multiplicative Digital      #
    # Root. The number of values to print is specified as a parameter             #
    PROC tabulate mdr = ( INT number of values )VOID:
         BEGIN
            [ 0 : 9, 1 : number of values ]INT mdr values;
            [ 0 : 9                       ]INT mdr counts;
            mdr counts[ AT 1 ] := ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
            # find the first few numbers with each possible mdr                   #
            INT values found    := 0;
            INT required values := 10 * number of values;
            FOR value FROM 0 WHILE values found < required values DO
                DR mdr = MDROOT value;
                IF mdr counts[ root OF mdr ] < number of values THEN
                    # need more values with this multiplicative digital root      #
                    values found              +:= 1;
                    mdr counts[ root OF mdr ] +:= 1;
                    mdr values[ root OF mdr, mdr counts[ root OF mdr ] ] := value
                FI
            OD;
            # print the values #
            print( ( "MDR: [n0..n" + whole( number of values - 1, 0 ) + "]", newline ) );
            print( ( "===  ========", newline ) );
            FOR mdr pos FROM 1 LWB mdr values TO 1 UPB mdr values DO
                STRING separator := ": [";
                print( ( whole( mdr pos, -3 ) ) );
                FOR val pos FROM 2 LWB mdr values TO 2 UPB mdr values DO
                    print( ( separator + whole( mdr values[ mdr pos, val pos ], 0 ) ) );
                    separator := ", "
                OD;
                print( ( "]", newline ) )
            OD
         END; # tabulate mdr #
    # task test cases #
    print md root( 123321 );
    print md root(   7739 );
    print md root(    893 );
    print md root( 899998 );
    tabulate mdr( 5 )
END
