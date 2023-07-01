begin % find the day of the week of dates using John Conway's Doomsday rule %
    % returns the day of the week (Sunday = 0, Monday = 1,...) for the date %
    %         specified by ccyy, mm and dd                                  %
    integer procedure dow ( integer value ccyy, mm, dd ) ;
    begin
        integer doomsday, anchorDay;
        logical isLeapYear;
        doomsday   := ( % Tuesday % 2
                      + ( 5 * ( ccyy rem   4 ) )
                      + ( 4 * ( ccyy rem 100 ) )
                      + ( 6 * ( ccyy rem 400 ) )
                      )
                  rem 7;
        isLeapYear := ccyy rem 4 = 0 and ( ccyy rem 100 not = 0 or ccyy rem 400 = 0 );
        anchorDay  := case mm of ( if isLeapYear then 4 else 3
                                 , if isLeapYear then 1 else 7
                                 , 7, 4, 2, 6, 4, 1, 5, 3, 7, 5
                                 );
        ( doomsday + ( dd - anchorDay ) ) rem 7
    end dow ;
    begin % task test cases %
        % prints a test date and its day of the week %
        procedure testDow ( integer value ccyy, mm, dd ) ;
            write( i_w := 1, s_w := 0
                 , ccyy
                 , "-",  mm div 10, mm rem 10
                 , "-",  dd div 10, dd rem 10
                 , ": ", dayName( dow( ccyy, mm, dd ) )
                 );
        string(9) array dayName ( 0 :: 6 );
        dayName( 0 ) := "Sunday";    dayName( 1 ) := "Monday";   dayName( 2 ) := "Tuesday";
        dayName( 3 ) := "Wednesday"; dayName( 4 ) := "Thursday"; dayName( 5 ) := "Friday";
        dayName( 6 ) := "Saturday";
        testDow( 1800,  1,  6 );
        testDow( 1875,  3, 29 );
        testDow( 1915, 12,  7 );
        testDow( 1970, 12, 23 );
        testDow( 2043,  5, 14 );
        testDow( 2077,  2, 12 );
        testDow( 2101,  4,  2 );
        testDow( 2022,  6, 19 )
    end
end.
