begin
    % returns with numberInBase set to the number n converted to a string in %
    % the specified base. Number must be non-negative and base must be in    %
    % range 2 to 36                                                          %
    procedure convertToBase( integer    value  n
                           ; integer    value  base
                           ; string(32) result numberInBase
                           ) ;
    begin
        string(36) baseDigits;
        integer    val, strPos;

        assert( n >= 0 and base >= 2 and base <= 36 );

        baseDigits    := "0123456789abcdefghijklmnopqrstuvwxyz";
        numberInBase  := " ";
        val           := n;
        strPos        := 31;
        while
            begin
                % a(b//c) is the substring of a starting at b with length c. %
                % The first character is at position 0. The length must be   %
                % an integer literal so it is known at compile time.         %
                numberInBase( strPos // 1 ) := baseDigits( val rem base // 1 );
                val    := val div base;
                strPos := strPos - 1;
                val > 0
            end
        do begin end
    end convertToBase ;

    % returns the string numberInBase converted to an integer assuming       %
    % numberInBase ia a string in the specified base                         %
    % base must be in range 2 to 36, invalid digits will cause the program   %
    % to crash, spaces are ignored                                           %
    integer procedure convertFromBase( string(32) value numberInBase
                                     ; integer    value base
                                     ) ;
    begin
        string(36) baseDigits;
        integer    val, cPos;

        assert( base >= 2 and base <= 36 );

        baseDigits    := "0123456789abcdefghijklmnopqrstuvwxyz";
        val           := 0;
        for strPos := 0 until 31 do begin
            string(1) c;
            c := numberInBase( strPos // 1 );
            if c not = " " then begin
                cPos := 0;
                while baseDigits( cPos // 1 ) not = c do cPos := cPos + 1;
                val  := ( val * base ) + cPos;
            end
        end;
        val
    end convertFromBase ;

    % test the procedures                                                    %
    string(32) baseNumber;
    i_w := 3; % set integer output width                                     %
    for i := 2 until 36 do begin
        convertToBase( 35, i, baseNumber );
        write( 35, i, baseNumber, " ", convertFromBase( baseNumber, i ) );
    end
end.
