begin

    % determnines whether the string contains an integer, real or imaginary  %
    % number. Returns true if it does, false otherwise                       %
    logical procedure isNumeric( string(32) value text ) ;
        begin

            logical ok;
            % the "number" cannot be blank                                   %
            ok := ( text not = " " );
            if ok then begin

                % there is at least one non-blank character                  %
                % must have either an integer or real/immaginary number      %
                % integer: [+|-]digit-sequence                               %
                % real:    [+|-][digit-sequence].digit-sequence['integer][L] %
                % or:      [+|-]digit-sequence[.[digit-sequence]]'integer[L] %
                % imaginary:                                                 %
                %          [+|-][digit-sequence].digit-sequence['integer][L]I%
                % or:      [+|-]digit-sequence[.[digit-sequence]]'integer[L]I%
                % The "I" at the end of an imaginary number can appear       %
                % before or after the "L" (which indicates a long number)    %
                % the "I" and "L" can be in either case                      %

                procedure nextChar ; charPos := charPos + 1;
                logical procedure have( string(1) value ch ) ;
                    ( charPos <= maxChar and text(charPos//1) = ch ) ;

                logical procedure haveDigit ;
                    ( charPos <= maxChar and text(charPos//1) >= "0" and text(charPos//1) <= "9" ) ;


                integer charPos, maxChar;
                logical hadDigits, isReal;
                charPos   :=  0;
                maxChar   := 31;
                hadDigits := false;
                isReal    := false;

                % skip trailing spaces                                       %
                while maxChar > 0 and text(maxChar//1) = " " do maxChar := maxChar - 1;
                % skip leading spacesx                                       %
                while have( " " ) do nextChar;

                % skip optional sign                                         %
                if have( "+" ) or have( "-" ) then nextChar;

                if      haveDigit then begin
                    % have a digit sequence                                  %
                    hadDigits := true;
                    while haveDigit do nextChar
                end if_have_sign ;

                if have( "." ) then begin
                    % real or imaginary number                               %
                    nextChar;
                    isReal    := true;
                    hadDigits := hadDigits or haveDigit;
                    while haveDigit do nextChar
                end if_have_point ;

                % should have had some digits                                %
                ok := hadDigits;

                if ok and have( "'" ) then begin
                    % the number has an exponent                             %
                    isReal := true;
                    nextChar;
                    % skip optional sign                                     %
                    if have( "+" ) or have( "-" ) then nextChar;
                    % must have a digit sequence                             %
                    ok := haveDigit;
                    while haveDigit do nextChar;
                end if_ok_and_have_exponent ;

                % if it is a real number, there could be L/I suffixes        %
                if ok and isReal then begin
                    integer LCount, ICount;
                    LCount := 0;
                    ICount := 0;
                    while have( "L" ) or have( "l" ) or have( "I" ) or have( "i" ) do begin
                        if have( "L" ) or have( "l" )
                        then LCount := LCount + 1
                        else ICount := ICount + 1;
                        nextChar
                    end while_have_L_or_I ;
                    % there can be at most one L and at most 1 I             %
                    ok := ( LCount < 2 and ICount < 2 )
                end if_ok_and_isReal ;

                % must now be at the end if the number                       %
                ok := ok and charPos >= maxChar

            end if_ok ;

            ok
        end isNumeric ;


    % test the isNumeric procedure                                           %
    procedure testIsNumeric( string(32) value n
                           ; logical    value expectedResult
                           ) ;
        begin
            logical actualResult;
            actualResult := isNumeric( n );
            write( s_w := 0
                 , """", n, """ is "
                 , if actualResult then "" else "not "
                 , "numeric "
                 , if actualResult = expectedResult then "" else " NOT "
                 , "as expected"
                 )
        end testIsNumeric ;


    testIsNumeric(          "", false );
    testIsNumeric(         "b", false );
    testIsNumeric(         ".", false );
    testIsNumeric(       ".'3", false );
    testIsNumeric(       "3.'", false );
    testIsNumeric(    "0.0z44", false );
    testIsNumeric(      "-1IL", false );
    testIsNumeric( "4.5'23ILL", false );

    write( "---------" );

    testIsNumeric(        "-1", true  );
    testIsNumeric(    " +.345", true  );
    testIsNumeric(   "4.5'23I", true  );
    testIsNumeric(    "-5'+3i", true  );
    testIsNumeric(    "-5'-3l", true  );
    testIsNumeric(  " -.345LI", true  );

end.
