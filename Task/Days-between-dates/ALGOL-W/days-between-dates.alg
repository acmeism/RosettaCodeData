begin % calculate the number of days between a pair of dates                 %
      % based on a translation of the FreeBASIC sample                       %

    integer procedure gregorian ( integer value y, m, d ) ;
    begin
        integer n, w;
        n := ( m + 9 ) - ( ( ( m + 9 ) div 12 ) * 12 );
        w := y - ( n div 10 );
        ( 365 * w ) + ( w div 4 ) - ( w div 100 ) + ( w div 400 )
                    + ( ( ( n * 306 ) + 5 ) div 10 ) + ( d - 1 )
    end gregorian ;

    integer procedure toInt( string(4) value s ) ;
    begin
        integer v;
        v := 0;
        for sPos := 0 until 3 do begin
            string(1) c;
            c := s( sPos // 1 );
            if c not = " " then v := ( v * 10 ) + ( decode( c ) - decode( "0" ) )
        end;
        v
    end toInt ;

    procedure testGregorian ( string(10) value fromDate, toDate ) ;
    begin
        integer fromG, toG;
        fromG := gregorian( toInt( fromDate( 0 // 4 ) )
                          , toInt( fromDate( 5 // 2 ) )
                          , toInt( fromDate( 8 // 2 ) )
                          );
        toG   := gregorian( toInt(   toDate( 0 // 4 ) )
                          , toInt(   toDate( 5 // 2 ) )
                          , toInt(   toDate( 8 // 2 ) )
                          );
        writeon( s_w := 0, "Days between ", fromDate, " and ", toDate, " is " );
        writeon( i_w := 5, s_w := 0, toG - fromG, " days" );
        write();
    end testGregorian ;

    testGregorian( "1902-01-01", "1968-12-25" );testGregorian( "2019-01-01", "2019-01-02" );
    testGregorian( "2019-01-02", "2019-01-01" );testGregorian( "2019-01-01", "2019-03-01" );
    testGregorian( "2020-01-01", "2020-03-01" );testGregorian( "1995-11-21", "1995-11-21" );
    testGregorian( "2090-01-01", "2098-12-25" )

end.
