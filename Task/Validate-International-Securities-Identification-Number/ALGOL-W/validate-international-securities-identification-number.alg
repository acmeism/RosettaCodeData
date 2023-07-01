begin
    % external procedure that returns true if ccNumber passes the Luhn test, false otherwise %
    logical procedure LuhnTest ( string(32) value ccNumber
                               ; integer    value ccLength
                               ) ; algol "LUHN" ;

    % returns true if isin is a valid ISIN, false otherwise    %
    logical procedure isIsin ( string(32) value isin ) ;
        if isin( 12 // 20 ) not = "" then false % code is too long %
        else begin
            % the first two characters must be upper-case letters %

            % returns the digit corresponding to a character of an ISIN %
            integer procedure isinDigit ( string(1) value iChar ) ;
                if      iChar >= "0" and iChar <= "9" then ( decode( iChar ) - decode( "0" ) )
                else if iChar >= "A" and iChar <= "Z" then ( decode( iChar ) - decode( "A" ) ) + 10
                else begin % invalid digit %
                    isValid := false;
                    -1
                end isinDigit ;

            integer d1, d2;
            logical isValid;
            isValid := true;
            d1      := isinDigit( isin( 0 // 1 ) );
            d2      := isinDigit( isin( 1 // 1 ) );
            if d1 < 10 or d1 > 35 or d2 < 10 or d2 > 35 then false % invalid first two characters %
            else begin
                % ok so far - conveet from base 36 to base 10 %
                string(24) base10Isin;
                integer    b10Pos;
                base10Isin := "";
                b10Pos     := 0;
                for cPos := 0 until 10 do begin
                    integer digit;
                    digit := isinDigit( isin( cPos // 1 ) );
                    if isValid then begin
                        % valid digit %
                        if digit > 9 then begin
                            base10Isin( b10Pos // 1 ) := code( ( digit div 10 ) + decode( "0" ) );
                            b10Pos                    := b10Pos + 1;
                        end if_digit_gt_9 ;
                        base10Isin( b10Pos // 1 )     := code( ( digit rem 10 ) + decode( "0" ) );
                        b10Pos                        := b10Pos + 1
                    end if_isValid
                end for_cPos ;
                % add the check digit as is %
                base10Isin( b10Pos // 1 ) := isin( 11 // 1 );
                isValid and LuhnTest( base10Isin, b10Pos + 1 )
            end
        end isIsin ;

    % task test cases %

    procedure testIsIsin ( string(32) value isin
                         ; logical    value expected
                         ) ;
    begin
        logical isValid;
        isValid := isIsin( isin );
        write( s_w := 0
             , isin
             , if isValid then " is valid" else " is invalid"
             , if isValid = expected   then "" else " NOT as expected ??"
             )
    end testIsin ;

    testIsIsin( "US0378331005",  true  );
    testIsIsin( "US0373831005",	 false );
    testIsIsin( "U50378331005",  false );
    testIsIsin( "US03378331005", false );
    testIsIsin( "AU0000XVGZA3",	 true  );
    testIsIsin( "AU0000VXGZA3",	 true  );
    testIsIsin( "FR0000988040",	 true  );
end.
