begin % find "long years" - years which have 53 weeks %
      % this is equivalent to finding years where     %
      % 1st Jan or 31st Dec are Thursdays             %
    % finds the day of the week - Sunday = 1          %
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
    % returns true if year is a long year, false otherwise %
    logical procedure isLongYear ( integer value year );
        Day_of_week( 1, 1, year ) = 5 or Day_of_week( 31, 12, year ) = 5;
    % show long years from 2000-2099 %
    write( "long years 2000-2099:" );
    for year := 2000 until 2099 do begin
        if isLongYear( year ) then writeon( I_W := 5, S_W := 0, year )
    end for_year
end.
