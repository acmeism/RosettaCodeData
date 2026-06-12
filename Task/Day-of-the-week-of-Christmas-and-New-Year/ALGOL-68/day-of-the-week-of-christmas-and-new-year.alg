BEGIN # find the day of the week 25/12/2021 and 01/01/2022 fall on #
    []STRING day name =
        []STRING( "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday" )[ AT 0 ];
    PROC day of week = ( INT d, m, y )INT:
         BEGIN
            INT mm := m;
            INT yy := y;
            IF mm <= 2 THEN
                mm +:= 12;
                yy -:= 1
            FI;
            INT j = yy OVER 100;
            INT k = yy MOD  100;
            ( d + ( ( mm + 1 ) * 26 ) OVER 10 + k + k OVER 4 + j OVER 4 + 5 * j ) MOD 7
         END # day of week # ;
    print( ( "25th of December 2021 is a ", day name[ day of week( 25, 12, 2021 ) ], newline ) );
    print( ( " 1st of January  2022 is a ", day name[ day of week(  1,  1, 2022 ) ], newline ) )
END
