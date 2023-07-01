begin    % returns true if cusip is a valid CUSIP code %
    logical procedure isCusip ( string(9) value cusip ) ;
    begin
        % returns the base 39 digit corresponding to a character of a CUSIP code %
        integer procedure cusipDigit( string(1) value cChar ) ;
            if      cChar >= "0" and cChar <= "9" then ( decode( cChar ) - decode( "0" ) )
            else if cChar >= "A" and cChar <= "Z" then ( decode( cChar ) - decode( "A" ) ) + 10
            else if cChar  = "*"                  then   36
            else if cChar  = "@"                  then   37
            else if cChar  = "#"                  then   38
            else    % invalid digit %                  -999 ;

        integer checkDigit, sum;
        checkDigit := cusipDigit( cusip( 8 // 1 ) );
        for cPos := 1 until 8 do begin
            integer   digit;
            digit := cusipDigit( cusip( ( cPos - 1 ) // 1 ) );
            if not odd( cPos ) then digit := digit * 2;
            sum := sum + ( digit div 10 ) + ( digit rem 10 )
        end for_cPos ;
        ( ( 10 - ( sum rem 10 ) ) rem 10 ) = checkDigit
    end isCusip ;

    begin % task test cases %
        procedure testCusip ( string(9) value cusip ) ;
            write( s_w := 0, cusip, if isCusip( cusip ) then " valid" else " invalid" );

        testCusip( "037833100" );
        testCusip( "17275R102" );
        testCusip( "38259P508" );
        testCusip( "594918104" );
        testCusip( "68389X106" );
        testCusip( "68389X105" )
    end testCases
end.
