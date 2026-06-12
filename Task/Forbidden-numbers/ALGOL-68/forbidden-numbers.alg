BEGIN # find some forbidden numbers: numbers that cannot be formed by        #
      # summing fewer than four squares                                      #
    # returns TRUE if n is a Forbidden numbr, FALSE otherwise                #
    #         based on the Wren version of the example at oeis.org/A004215   #
    PROC is forbidden = ( INT n )BOOL:
         BEGIN
             INT m  := n;
             INT p4 := 1;
             WHILE m > 1 AND m MOD 4 = 0 DO
                 m OVERAB 4;
                 p4   *:= 4
             OD;
             ( n OVER p4 ) MOD 8 = 7
         END # is forbidden # ;
    # show the first 50 forbidden numbers and counts of Forbidden numbers    #
    INT f count      :=   0;
    INT next to show := 500;
    FOR i TO 50 000 000 DO
        IF is forbidden( i ) THEN
            f count +:= 1;
            IF f count <= 50 THEN
                print( ( " ", whole( i, -4 ) ) );
                IF f count MOD 10 = 0 THEN print( ( newline ) ) FI
            FI
        FI;
        IF i = next to show THEN
            print( ( "There are ", whole( f count, -8 )
                   , " Forbidden numbers up to ", whole( i, 0 )
                   , newline
                   )
                 );
            next to show *:= 10
        FI
    OD
END
