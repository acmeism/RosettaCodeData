% returns true if ccNumber passes the Luhn test, false otherwise %
% as Algol W has fixed length strings, the length of the number  %
% must be specified in ccLength                                  %
logical procedure LuhnTest ( string(32) value ccNumber
                           ; integer    value ccLength
                           ) ;
begin
    integer checkSum;
    logical oddDigit, isValid;
    checkSum := 0;
    isValid := oddDigit := true;
    for cPos := ccLength step -1 until 1 do begin
        integer digit;
        digit := decode( ccNumber( cPos - 1 // 1 ) ) - decode( "0" );
        if digit < 0 or digit > 9 then isValid := false
        else if oddDigit
        then checkSum := checkSum + digit
        else checkSum := checkSum + ( case digit + 1 of ( 0, 2, 4, 6, 8
                                                        , 1, 3, 5, 7, 9
                                                        )
                                    );
        oddDigit := not oddDigit
    end for_cPos ;
    isValid and ( ( checkSum rem 10 ) = 0 )
end LuhnTest
