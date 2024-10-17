begin
    % returns true if year is a leap year, false otherwise %
    % assumes year is in the Gregorian Calendar            %
    logical procedure isLeapYear ( integer value year ) ;
        year rem 400 = 0 or ( year rem 4 = 0 and year rem 100 not = 0 );

    % some test cases                                      %
    for year := 1899, 1900, 1901, 1902, 1903, 1904, 1905, 1999, 2000, 2001, 2002, 2003, 2004 do begin
        write( i_w := 1, s_w := 0
             , year
             , " is "
             , if isLeapYear( year ) then "" else "not "
             , "a leap year"
             )
    end for_year
end.
