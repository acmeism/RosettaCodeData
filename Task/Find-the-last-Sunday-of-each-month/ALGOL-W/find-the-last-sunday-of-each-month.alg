begin % find the last Sunday in each month of a year             %
    % returns true if year is a leap year, false otherwise       %
    % assumes year is in the Gregorian Calendar                  %
    logical procedure isLeapYear ( integer value year ) ;
        year rem 400 = 0 or ( year rem 4 = 0 and year rem 100 not = 0 );
    % returns the day of the week of the specified date (d/m/y)  %
    %         Sunday = 1                                         %
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
    % sets the elements of last to the day of the last Sunday   %
    % of each month in year                                     %
    procedure lastSundays ( integer value year
                          ; integer array last ( * )
                          ) ;
        begin
            integer array lastDays ( 1 :: 12 );
            integer m;
            % set ld to the day number od the last day of each  %
            % month in year                                     %
            m := 1;
            for ld := 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 do begin
                lastDays( m ) := ld;
                m             := m + 1
            end for_ld ;
            if isLeapYear( year ) then lastDays( 2 ) := 29;
            % for each month, determine the day number of the   %
            % last Sunday                                       %
            for mPos := 1 until 12 do begin
                integer dow;
                dow := Day_of_week( lastDays( mPos ), mPos, year );
                if dow = 0 % Saturday % then dow := 7;
                % calculate the offset for the previous Sunday  %
                last( mPos ) := ( lastDays( mPos ) + 1 ) - dow
            end for_mPos
        end lastSundays ;
    begin
        % test the lastSundays procedure                        %
        integer array last ( 1 :: 12 );
        integer year;
        year := 2020;
        lastSundays( year, last );
        i_w := 1; s_w := 0; % output formatting                 %
        for mPos := 1 until 12 do write( year, if mPos < 10 then "-0" else "-1", mPos rem 10, "-", last( mPos ) )
    end
end.
