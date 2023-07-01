BEGIN
    # list the first 30 numbers that are squares but not cubes and also #
    # show the numbers that are both squares and cubes                  #
    INT count := 0;
    INT c     := 1;
    INT c3    := 1;
    FOR s WHILE count < 30 DO
        INT sq = s * s;
        WHILE c3 < sq DO
            c  +:= 1;
            c3  := c * c * c
        OD;
        print( ( whole( sq, -5 ) ) );
        IF c3 = sq THEN
            # the square is also a cube                                 #
            print( ( " is also the cube of ", whole( c, -5 ) ) )
        ELSE
            # square only                                               #
            count +:= 1
        FI;
        print( ( newline ) )
    OD
END
