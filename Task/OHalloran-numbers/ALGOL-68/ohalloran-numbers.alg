BEGIN # find O'Halloran numbers - numbers that cannot be the surface area of  #
      #                           a cuboid with integer dimensions            #
    INT count        := 0;
    INT max area      = 1 000;
    INT half max area = max area OVER 2;
    FOR n FROM 8 BY 2 TO max area DO
        BOOL ohalloran := TRUE;
        FOR l TO half max area WHILE ohalloran DO
            FOR b FROM l TO half max area WHILE INT lb = l * b;
                                                lb < n AND ohalloran
            DO
                FOR h FROM b TO half max area WHILE INT bh = b * h, lh = l * h;
                                                    INT sum = 2 * ( lb + bh + lh );
                                                    sum <= n AND ( ohalloran := sum /= n )
                DO SKIP OD
            OD
        OD;
        IF ohalloran THEN
            print( ( " ", whole( n, 0 ) ) );
            count +:= 1
        FI
    OD
END
