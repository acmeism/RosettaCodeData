BEGIN # display a string representation of some linear combinations              #
    # returns a string representing the sum of the terms of a linear combination #
    #         whose coefficients are the elements of coeffs                      #
    PROC linear combination = ( []INT coeffs )STRING:
         BEGIN
            []INT  cf          = coeffs[ AT 1 ]; # ensure the lower bound is 1   #
            STRING result     := "";
            BOOL   first term := TRUE;
            FOR i FROM LWB cf TO UPB cf DO
                IF INT c = cf[ i ];
                   c /= 0
                THEN                                          # non-null element #
                    IF first term THEN
                        # first term - only add the operator if it is "-"        #
                        IF c < 0 THEN result +:= "-" FI;
                        first term := FALSE
                    ELSE
                        # second or subsequent term - separate from the previous #
                        #                            and always add the operator #
                        result +:= " " + IF c < 0 THEN "-" ELSE "+" FI + " "
                    FI;
                    # add the coefficient, unless it is one                      #
                    IF ABS c /= 1 THEN
                        result +:= whole( ABS c, 0 )
                    FI;
                    # add the vector                                             #
                    result +:= "e(" + whole( i, 0 ) + ")"
                FI
            OD;
            IF result = "" THEN "0" ELSE result FI
         END # linear combination # ;

    # test cases #
    [][]INT tests = ( (  1,  2,  3  )
                    , (  0,  1,  2,  3  )
                    , (  1,  0,  3,  4  )
                    , (  1,  2,  0  )
                    , (  0,  0,  0  )
                    , (  0  )
                    , (  1,  1,  1  )
                    , ( -1, -1, -1  )
                    , ( -1, -2,  0, -3  )
                    , ( -1  )
                    );
    FOR i FROM LWB tests TO UPB tests DO
        print( ( linear combination( tests[ i ] ), newline ) )
    OD
END
