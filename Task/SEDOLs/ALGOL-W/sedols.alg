begin
    % returns the check digit for the specified SEDOL %
    string(1) procedure sedolCheckDigit ( string(6) value sedol ) ;
    begin
        integer       checkSum, checkDigit;
        checkSum := 0;
        for cPos := 0 until 5 do begin
            string(1) c;
            integer   digit;
            c := sedol( cPos // 1 );
            if c >= "0" and c <= "9"
            then digit :=        decode( c ) - decode( "0" )
            else digit := 10 + ( decode( c ) - decode( "A" ) );
            checkSum := checkSum + ( ( case cPos + 1 of ( 1, 3, 1, 7, 3, 9 ) ) * digit )
        end for_cPos ;
        checkDigit := ( 10 - ( checkSum rem 10 ) ) rem 10;
        if checkDigit < 10
        then code( decode( "0" ) +   checkDigit        )
        else code( decode( "A" ) + ( checkDigit - 10 ) )
    end sedolCheckDigit ;

    % task test cases %

    procedure testCheckDigit ( string(6) value sedol; string(1) value expectedCheckDigit ) ;
    begin
        string(1) checkDigit;
        checkDigit := sedolCheckDigit( sedol );
        write( s_w := 0, sedol, checkDigit );
        if checkDigit not = expectedCheckDigit then writeon( " ?? expected: ", expectedCheckDigit )
    end testCheckDigit ;

    testCheckDigit( "710889", "9" );
    testCheckDigit( "B0YBKJ", "7" );
    testCheckDigit( "406566", "3" );
    testCheckDigit( "B0YBLH", "2" );
    testCheckDigit( "228276", "5" );
    testCheckDigit( "B0YBKL", "9" );
    testCheckDigit( "557910", "7" );
    testCheckDigit( "B0YBKR", "5" );
    testCheckDigit( "585284", "2" );
    testCheckDigit( "B0YBKT", "7" );
    testCheckDigit( "B00030", "0" )
end.
