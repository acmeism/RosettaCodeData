BEGIN # find "long years" - years which have 53 weeks this is equivalent to #
      # finding years where 1st Jan or 31st Dec are Thursdays               #
    # returns the day of the week of the specified date (d/m/y), Sunday = 1 #
    PROC day of week = ( INT d, m, y )INT:
         BEGIN
            INT mm := m;
            INT yy := y;
            IF mm <= 2 THEN
                mm := mm + 12;
                yy := yy - 1
            FI;
            INT j = yy OVER 100;
            INT k = yy MOD  100;
            (d + ( ( mm + 1 ) * 26 ) OVER 10 + k + k OVER 4 + j OVER 4 + 5 * j ) MOD 7
         END # day of week # ;
    # returns TRUE if year is a long year, FALSE otherwise                  #
    PROC is long year = ( INT year )BOOL:
        day of week( 1, 1, year ) = 5 OR day of week( 31, 12, year ) = 5;
    # show long years from 2000-2099                                        #
    print( ( "long years 2000-2099:" ) );
    FOR year FROM 2000 TO 2099 DO
        IF is long year( year ) THEN print( ( " ", whole( year, 0 ) ) ) FI
    OD
END
