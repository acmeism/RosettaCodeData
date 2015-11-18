begin
    % prints an integer in binary - the number must be greater than zero     %
    procedure printBinaryDigits( integer value n ) ;
    begin
        if n not = 0 then begin
            printBinaryDigits( n div 2 );
            writeon( if n rem 2 = 1 then "1" else "0" )
        end
    end binaryDigits ;

    % prints an integer in binary - the number must not be negative          %
    procedure printBinary( integer value n ) ;
    begin
        if n = 0 then writeon( "0" )
                 else printBinaryDigits( n )
    end printBinary ;

    % test the printBinaryDigits procedure                                   %
    for i := 5, 50, 9000 do begin
        write();
        printBinary( i );
    end

end.
