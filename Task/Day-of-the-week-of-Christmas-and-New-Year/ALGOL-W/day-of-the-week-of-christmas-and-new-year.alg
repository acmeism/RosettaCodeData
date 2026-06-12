begin % find the day of the week 25/12/2021 and 01/01/2022 fall on %
    string(10) array dayName( 0 :: 6 );
    integer procedure Day_of_week ( integer value d, m, y );
        begin
            integer j, k, mm, yy;
            mm := m;
            yy := y;
            if mm <= 2 then begin
                mm := mm + 12;
                yy := yy - 1;
            end if_m_le_2;
            j := yy div 100;
            k := yy rem 100;
            (d + ( ( mm + 1 ) * 26 ) div 10 + k + k div 4 + j div 4 + 5 * j ) rem 7
        end Day_of_week;
    dayName( 0 ) := "Saturday"; dayName( 1 ) := "Sunday";    dayName( 2 ) := "Monday";
    dayName( 3 ) := "Tuesday";  dayName( 4 ) := "Wednesday"; dayName( 5 ) := "Thursday";
    dayName( 6 ) := "Friday";
    write( "25th of December 2021 is a ", dayName( Day_of_week( 25, 12, 2021 ) ) );
    write( " 1st of January  2022 is a ", dayName( Day_of_week(  1,  1, 2022 ) ) )
end.
