BEGIN
    # returns TRUE if the number of digits in n followed by a higher digit (rises)  #
    #              equals the number of digits followed by a lower digit (falls)    #
    #        FALSE otherwise                                                        #
    PROC rises equals falls = ( INT n )BOOL:
         BEGIN
            INT rf   := 0;
            INT prev := n MOD 10;
            INT v    := n OVER 10;
            WHILE v > 0 DO
                INT d = v MOD 10;
                IF d < prev THEN
                    rf +:= 1    # rise                                              #
                ELIF d > prev THEN
                    rf -:= 1    # fall                                              #
                FI;
                prev := d;
                v OVERAB 10
            OD;
            rf = 0
        END; # rises equals falls #
    # task tests                                                                    #
    print( ( "The first 200 numbers in the sequence are:", newline ) );
    INT count    := 0;
    INT max count = 10 000 000;
    FOR n WHILE count < max count DO
        IF rises equals falls( n ) THEN
            count +:= 1;
            IF count <= 200 THEN
                print( ( whole( n, -4 ) ) );
                IF count MOD 20 = 0 THEN print( ( newline ) ) FI
            ELIF count = max count THEN
                print( ( newline, "The 10 millionth number in the sequence is ", whole( n, -8 ), ".", newline ) )
            FI
        FI
    OD
END
