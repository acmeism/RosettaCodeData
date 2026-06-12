BEGIN # find some sub-unit squares: squares which are still squares when 1 #
      # is subtracted from each of their digits                            #
      # the sub-unit squares must end in 36 (see task discussion) and so   #
      # the square formed by subtracting 1 from each digit must end in 25  #
      # so, as with the J sample, we start with the "25" square and test   #
      # the incremented square                                             #
    # find the sub unit squares - note that 1 is a special case            #
    print( ( "1" ) );
    INT      su count    :=  1;
    LONG INT add ones    :=  1;
    LONG INT power of 10 := 10;
    FOR n FROM 5 BY 10 WHILE su count < 7 DO
        LONG INT sq = ( LENG n ) * ( LENG n );
        WHILE sq > power of 10 DO
            # the square has more digits than the previous one             #
            power of 10 *:= 10;
            add ones    *:= 10 +:= 1
        OD;
        IF  LONG INT add unit sq = sq + add ones;
            add unit sq < power of 10
        THEN
            # squaring the number with one added to the digits has the     #
            # same number of digits as the original square                 #
            IF  LONG INT root        = ENTIER long sqrt( add unit sq );
                root * root = add unit sq
            THEN
                # the add unit square is actually a square                 #
                # make sure there are no 0s in the add unit square as they #
                # can't be decremented to a positive digit                 #
                IF  BOOL no zeros := TRUE;
                    LONG INT v    := add unit sq;
                    WHILE v > 0 AND no zeros DO
                        no zeros := v MOD 10 /= 0;
                        v OVERAB 10
                    OD;
                    no zeros
                THEN
                    print( ( " ", whole( add unit sq, 0 ) ) );
                    su count +:= 1
                FI
            FI
        FI
    OD
END
