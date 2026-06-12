BEGIN # find the lowest positive integer not present in various arrays #
    # returns the lowest positive integer not present in r #
    PROC min missing positive = ( []INT r )INT:
         BEGIN
            []INT a = r[ AT 1 ]; # a is r wih lower bound 1 #
            # as noted in the J sample, the maximum possible minimum #
            # missing positive integer is one more than the length of the array #
            # note the values between 1 and UPB a present in a #
            [ 1 : UPB a ]BOOL present;
            FOR i TO UPB a DO present[ i ] := FALSE OD;
            FOR i TO UPB a DO
                INT ai = a[ i ];
                IF ai >= 1 AND ai <= UPB a THEN
                    present[ ai ] := TRUE
                FI
            OD;
            # find the lowest value not in present #
            INT result := UPB a + 1;
            BOOL found := FALSE;
            FOR i TO UPB a WHILE NOT found DO
                IF NOT present[ i ] THEN
                    found  := TRUE;
                    result := i
                FI
            OD;
            result
         END # min missing positive # ;
     print( ( " ", whole( min missing positive( ( 1, 2,  0         ) ), 0 ) ) );
     print( ( " ", whole( min missing positive( ( 3, 4, -1,  1     ) ), 0 ) ) );
     print( ( " ", whole( min missing positive( ( 7, 8,  9, 11, 12 ) ), 0 ) ) )
END
