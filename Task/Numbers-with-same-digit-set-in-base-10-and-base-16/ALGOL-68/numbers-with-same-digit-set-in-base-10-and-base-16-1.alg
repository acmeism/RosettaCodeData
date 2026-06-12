BEGIN # find numbers that use the same digits in decimal and hexadecimal      #
      # translation of the Algol W sample                                     #
    INT max number = 100 000;
    # note 100 000 is 186A0 in hexadecimal, so we need to consider numbers    #
    # with up to 5 hexadedcimal digits                                        #
    # powers of 16 #
    INT x2 = 16; INT x3 = x2 * 16; INT x4 = x3 * 16; INT x5 = x4 * 16;
    # construct the numbers that have only 0-9 in their hex representations   #
    INT hd count := 0;
    INT n        := 0;
    INT hx5      := 0;
    FOR h5 FROM 0 TO 1 WHILE n < max number DO
        INT hx4 := 0;
        FOR h4 FROM 0 TO 9 WHILE n < max number DO
            INT hx3 := 0;
            FOR h3 FROM 0 TO 9 WHILE n < max number DO
                INT hx2 := 0;
                FOR h2 FROM 0 TO 9 WHILE n < max number DO
                    FOR h1 FROM 0 TO 9 WHILE ( n := hx5 + hx4 + hx3 + hx2 + h1 ) < max number DO
                        INT  d    := n;
                        BITS dset := IF d = 0 THEN 16r1 ELSE 16r0 FI;
                        WHILE d > 0 DO
                            dset  := dset OR ( 16r1 SHL ( d MOD 10 ) );
                            d OVERAB 10
                        OD;
                        BITS hset := 16r0;
                        IF 0 /= h5                THEN hset := hset OR ( 16r1 SHL h5 ) FI;
                        IF 0 /= h5 + h4           THEN hset := hset OR ( 16r1 SHL h4 ) FI;
                        IF 0 /= h5 + h4 + h3      THEN hset := hset OR ( 16r1 SHL h3 ) FI;
                        IF 0 /= h5 + h4 + h3 + h2 THEN hset := hset OR ( 16r1 SHL h2 ) FI;
                        hset := hset OR ( 16r1 SHL h1 );
                        IF dset = hset THEN
                            # the decimal and hexadecimal representations     #
                            # use the same digits                             #
                            print( ( " ", whole( n, -7 ) ) );
                            IF ( hd count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
                        FI
                    OD;
                    hx2 +:= x2
                OD;
                hx3 +:= x3
            OD;
            hx4 +:= x4
        OD;
        hx5 +:= x5
    OD;
    print( ( newline ) );
    print( ( "Found ", whole( hd count, 0 ), " numbers up to ", whole( max number, 0 ) ) );
    print( ( " where the decimal and hexadecimal representations use the same digits", newline ) )
END
