begin
    % external procedure that returns true if ccNumber passes the Luhn test, false otherwise %
    logical procedure LuhnTest ( string(32) value ccNumber
                               ; integer    value ccLength
                               ) ; algol "LUHN" ;


    % task test cases %

    procedure testLuhnTest ( string(32) value ccNumber
                           ; integer    value ccLength
                           ) ;
        write( s_w := 0, ccNumber, if LuhnTest( ccNumber, ccLength ) then " is valid" else " is invalid" );

    testLuhnTest( "49927398716",      11 );
    testLuhnTest( "49927398717",      11 );
    testLuhnTest( "1234567812345678", 16 );
    testLuhnTest( "1234567812345670", 16 )

end.
