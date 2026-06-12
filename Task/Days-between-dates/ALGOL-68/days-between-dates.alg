BEGIN # calculate the number of days between a pair of dates                 #
      # based on a translation of the FreeBASIC sample                       #

    [,]STRING test cases
        = ( ( "1902-01-01", "1968-12-25" )
          , ( "2019-01-01", "2019-01-02" ), ( "2019-01-02", "2019-01-01" )
          , ( "2019-01-01", "2019-03-01" ), ( "2020-01-01", "2020-03-01" )
          , ( "1995-11-21", "1995-11-21" ), ( "2090-01-01", "2098-12-25" )
          );

    PROC gregorian = ( INT y, m, d )INT:
         BEGIN
             INT n = ( m + 9 ) - ( ( ( m + 9 ) OVER 12 ) * 12 );
             INT w = y - ( n OVER 10 );
             ( 365 * w ) + ( w OVER 4 ) - ( w OVER 100 ) + ( w OVER 400 )
                         + ( ( ( n * 306 ) + 5 ) OVER 10 ) + ( d - 1 )
         END # gregorian # ;

    OP TOINT = ( STRING s )INT:
       BEGIN
           INT v := 0;
           FOR s pos FROM LWB s TO UPB s DO
               v *:= 10 +:= ( ABS s[ s pos ] - ABS "0" )
           OD;
           v
       END # TOINT #;

    FOR n FROM LWB test cases TO UPB test cases DO
        STRING from date = test cases[ n, 1 ];
        STRING to date   = test cases[ n, 2 ];
        INT from g = gregorian( TOINT from date[ 1 :  4 ]
                              , TOINT from date[ 6 :  7 ]
                              , TOINT from date[ 9 : 10 ]
                              );
        INT to g   = gregorian( TOINT   to date[ 1 :  4 ]
                              , TOINT   to date[ 6 :  7 ]
                              , TOINT   to date[ 9 : 10 ]
                              );
        print( ( "Days between ", from date, " and ", to date, " is " ) );
        print( ( whole( to g - from g, -5 ), " days", newline ) )
    OD
END
