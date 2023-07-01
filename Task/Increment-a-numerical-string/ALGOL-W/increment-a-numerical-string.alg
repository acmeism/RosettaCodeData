begin
    % returns a string representing the number in s incremented     %
    % As strings are fixed length, the significant length of s must %
    % be specified in length                                        %
    % s must contain an unsigned integer                            %
    % If the string is invalid or the result would require more     %
    % than 256 characters (the maximum string length), "error"      %
    % is returned                                                   %
    string(256) procedure increment( string(256) value s
                                   ; integer     value length
                                   ) ;
    begin
        logical isValid;
        integer rPos, sPos, carry;
        string(256) iValue;
        string(1) c;
        isValid := true;
        iValue  := " ";
        rPos    := 256;
        sPos    := length - 1;
        carry   := 1; % ensure the first digit is incremented       %
        while isValid and sPos >= 0 and rPos >= 0 do begin
            c      := s( sPos // 1 );
            sPos   := sPos - 1;
            if c not = " " then begin
                isValid := ( c >= "0" and c <= "9" );
                if isValid then begin
                    integer d;
                    d                   := ( decode( c ) - decode( "0" ) ) + carry;
                    carry               := d div 10;
                    rPos                := rPos - 1;
                    iValue( rPos // 1 ) := code( decode( "0" ) + d rem 10 )
                end if_isValid
            end if_c_ne_space
        end while_isValid_and_sPos_ge_0_and_rPOs_ge_0 ;
        if isValid then begin
            % the number was incremented successfully                                     %
            if carry not = 0 then begin
                % need an extra digit                                                     %
                if rPos <= 0
                then isValid := false % no room for an extra digit                        %
                else begin
                    % have space for an extra digit                                       %
                    rPos                := rPos - 1;
                    iValue( rPos // 1 ) := code( decode( "0" ) + carry )
                end if_rPos_lt_0__
            end if_carry_gt_0
        end if_isValid ;
        if not isValid then begin
            % s is not a numeric string or the result would be longer than 256 characters %
            iValue := "error"
            end
        else begin
            % the string could be incremented                                             %
            string(256) rightJustifiedValue;
            rightJustifiedValue := iValue;
            iValue              := " ";
            for iPos := 0 until 255 - rPos do iValue( iPos // 1 ) := rightJustifiedValue( rPos + iPos // 1 )
        end if_not_isValid_or_carry_ne_0__ ;
        iValue
    end increment ;
    % writes the string s, up to the first blank                                          %
    procedure writeonToBlank ( string(256) value s ) ;
    begin
        integer sPos;
        sPos := 0;
        while sPos < 256 and s( sPos // 1 ) not = " " do begin
            writeon( s_w := 0, s( sPos // 1 ) );
            sPos := sPos + 1
        end while_spos_lt_256_and_s_Spos_ne_space
    end writeonToBlank ;
    % test increment                                                                      %
    write( "                   0 + 1: " ); writeonToBlank( increment( "0",                     1 ) );
    write( "                   9 + 1: " ); writeonToBlank( increment( "9",                     1 ) );
    write( "           123456789 + 1: " ); writeonToBlank( increment( "123456789",             9 ) );
    write( "99999999999999999999 + 1: " ); writeonToBlank( increment( "99999999999999999999", 20 ) )
end.
