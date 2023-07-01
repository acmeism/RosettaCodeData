begin % find some Humble numbers - numbers with no prime factors above 7 %
    % returns the minimum of a and b                                     %
    integer procedure min ( integer value a, b ) ; if a < b then a else b;
    % find and print Humble Numbers                                      %
    integer MAX_HUMBLE;
    MAX_HUMBLE := 2048;
    begin
        integer array H( 1 :: MAX_HUMBLE );
        integer p2, p3, p5, p7, last2, last3, last5, last7, h1, h2, h3, h4, h5, h6;
        i_w := 1; s_w := 1; % output formatting                                         %
        % 1 is the first Humble number                                                  %
        H( 1 ) := 1;
        h1     := h2    := h3    := h4    := h5 := h6 := 0;
        last2  := last3 := last5 := last7 := 1;
        p2     := 2;
        p3     := 3;
        p5     := 5;
        p7     := 7;
        for hPos := 2 until MAX_HUMBLE do begin
            integer m;
            % the next Humble number is the lowest of the next multiple of 2, 3, 5, 7  %
            m := min( min( min( p2, p3 ), p5 ), p7 );
            H( hPos ) := m;
            if m = p2 then begin
                % the Humble number was the next multiple of 2                          %
                % the next multiple of 2 will now be twice the Humble number following  %
                % the previous multple of 2                                             %
                last2 := last2 + 1;
                p2    := 2 * H( last2 )
            end if_used_power_of_2 ;
            if m = p3 then begin
                last3 := last3 + 1;
                p3    := 3 * H( last3 )
            end if_used_power_of_3 ;
            if m = p5 then begin
                last5 := last5 + 1;
                p5    := 5 * H( last5 )
            end if_used_power_of_5 ;
            if m = p7 then begin
                last7 := last7 + 1;
                p7    := 7 * H( last7 )
            end if_used_power_of_5 ;
        end for_hPos ;
        i_w := 1; s_w := 1; % output formatting %
        write( H( 1 ) );
        for hPos := 2 until 50 do writeon( H( hPos ) );
        for hPos := 1 until MAX_HUMBLE do begin
            integer m;
            m := H( hPos );
            if      m <      10 then h1 := h1 + 1
            else if m <     100 then h2 := h2 + 1
            else if m <    1000 then h3 := h3 + 1
            else if m <   10000 then h4 := h4 + 1
            else if m <  100000 then h5 := h5 + 1
            else if m < 1000000 then h6 := h6 + 1
        end for_hPos ;
        i_w := 5; s_w := 0;
        write( "there are", h1, " Humble numbers with 1 digit"  );
        write( "there are", h2, " Humble numbers with 2 digits" );
        write( "there are", h3, " Humble numbers with 3 digits" );
        write( "there are", h4, " Humble numbers with 4 digits" );
        write( "there are", h5, " Humble numbers with 5 digits" );
        write( "there are", h6, " Humble numbers with 6 digits" )
   end
end.
