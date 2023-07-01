begin % find years where Christmas day falls on a Sunday %
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
    write( "25th of December is a Sunday in" );
    for year := 2008 until 2121 do begin
        integer day;
        day := Day_of_week( 25, 12, year );
        if day = 1 then writeon( I_W := 5, S_W := 0, year );
    end for_year
end.
