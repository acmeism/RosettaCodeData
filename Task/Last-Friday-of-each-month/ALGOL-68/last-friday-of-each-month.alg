BEGIN # find the last Friday in each month of a year             #
    # returns true if year is a leap year, false otherwise       #
    # assumes year is in the Gregorian Calendar                  #
    PROC is leap year = ( INT year )BOOL:
         year MOD 400 = 0 OR ( year MOD 4 = 0 AND year MOD 100 /= 0 );
    # returns the day of the week of the specified date (d/m/y)  #
    #         Sunday = 1                                         #
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
    # returns an array of the last Friday of each month in year  #
    PROC last fridays = ( INT year )[]INT:
         BEGIN
            [ 1 : 12 ]INT last days := ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );
            IF is leap year( year ) THEN last days[ 2 ] := 29 FI;
            # for each month, determine the day number of the    #
            # last Friday                                        #
            [ 1 : 12 ]INT last;
            FOR m pos TO 12 DO
                INT dow := day of week( last days[ m pos ], m pos, year );
                # dow     = 1 Sun, 2 Mon, ... , 6 Fri, 0 Sat     #
                # change to 2 Sun, 3 Mon, ... , 0 Fri, 1 Sat     #
                dow := ( dow + 1 ) MOD 7;
                # offset the last day to the last Friday         #
                last[ m pos ] := last days[ m pos ] - dow
            OD;
            last
         END # last fridays # ;
    BEGIN # test the last fridays procedure                      #
        INT   year = 2021;
        []INT last = last fridays( year );
        FOR m pos TO 12 DO
            print( ( whole( year, 0 )
                   , IF m pos < 10 THEN "-0" ELSE "-1" FI
                   , whole( m pos MOD 10, 0 )
                   , "-"
                   , whole( last[ m pos ], 0 )
                   , newline
                   )
                 )
        OD
    END
END
