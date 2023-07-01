BEGIN # find colourful numbers: numbers where the product of every sub-group #
      # of digits is uniue ( non-negative numbers only )                     #
      # note that (as stated in the task) for multi-digit numbers, the       #
      # digits 0 and 1 cannot appear                                         #

      # returns TRUE if n is colourful, FALSE otherswise                     #
      PROC is colourful = ( INT n )BOOL:
           IF   n <  0 THEN FALSE
           ELIF n < 10 THEN TRUE
           ELSE
               # more than 1 digit - must teat the digits and digit groups   #
               INT v     := n;
               # table to hold the digits and groups, as 0 and 1 can't       #
               # appear, there will be at most 8 digits so at most 36 groups #
               [ 1 : 46 ]INT dg;
               # split and count the digits                                  #
               [ 0 :  9 ]INT d count;
               INT s end := 0; # position of the last single digit in dg     #
               FOR i FROM LWB d count TO UPB d count DO d count[ i ] := 0 OD;
               BOOL unique := TRUE;
               WHILE v > 0 AND unique DO
                   INT d              = v MOD 10;
                   dg[ s end +:= 1 ] := d;
                   unique            := 1 = ( d count[ d ] +:= 1 );
                   v OVERAB 10
               OD;
               IF unique THEN unique := d count[ 0 ] + d count[ 1 ] = 0 FI;
               # form the group products, stopping if one is non-unique      #
               INT dg pos := s end;
               FOR group width FROM 2 TO s end WHILE unique DO
                   FOR group start TO ( s end + 1 ) - group width WHILE unique DO
                       INT product := 1;
                       INT g pos   := group start - 1;
                       FOR i TO group width DO product *:= dg[ g pos +:= 1 ] OD;
                       dg[ dg pos +:= 1 ] := product;
                       FOR i TO dg pos - 1 WHILE unique DO
                           unique := dg[ i ] /= dg[ dg pos ]
                       OD
                   OD
               OD;
               unique
           FI # is colourful # ;

    # show the colourful numbers under 100                                   #
    print( ( "Colourful numbers less than 100:", newline ) );
    INT c count := 0;
    FOR i FROM 0 TO 99 DO
        IF is colourful( i ) THEN
            print( ( whole( i, -3 ) ) );
            IF ( c count +:= 1 ) MOD 11 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    print( ( newline ) );
    # find the largest colourful number                                      #
    INT max colourful := 0;
    FOR i FROM 98765432 BY -1 WHILE max colourful = 0 DO
        IF is colourful( i ) THEN
            max colourful := i
        FI
    OD;
    print( ( "The largest colourful number is: ", whole( max colourful, 0 ), newline ) );
    # show the number of colourful numbers by order of magnitude             #
    INT p10     := 10;
    c count     :=  0;
    INT t count :=  0;
    FOR i FROM 0 TO max colourful DO
        IF i = p10 THEN
            print( ( "Colourful numbers below ", whole( p10, -10 ), ": ", whole( c count, 0 ), newline ) );
            t count +:= c count;
            c count  := 0;
            p10     *:= 10
        FI;
        IF is colourful( i ) THEN
            c count +:= 1
        FI
    OD;
    print( ( "Colourful numbers below ", whole( p10, -10 ), ": ", whole( c count, 0 ), newline ) );
    print( ( "Total number of colourful numbers : ", whole( t count + c count, 0 ), newline ) )
END
