begin
    % returns the minimum of a and b                    %
    integer procedure min ( integer value a, b ) ; if a < b then a else b;
    % find and print Hamming Numbers                        %
    % Algol W only supports 32-bit integers so we just find %
    % the 1691 32-bit Hamming Numbers                       %
    integer MAX_HAMMING;
    MAX_HAMMING := 1691;
    begin
        integer array H( 1 :: MAX_HAMMING );
        integer p2, p3, p5, last2, last3, last5;
        H( 1 ) := 1;
        last2  := last3 := last5 := 1;
        p2     := 2;
        p3     := 3;
        p5     := 5;
        for hPos := 2 until MAX_HAMMING do begin
            integer m;
            % the next Hamming number is the lowest of the next multiple of 2, 3, and 5 %
            m := min( min( p2, p3 ), p5 );
            H( hPos ) := m;
            if m = p2 then begin
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
        end for_hPos ;
        i_w := 1;
        s_w := 1;
        write( H( 1 ) );
        for i := 2 until 20 do writeon( H( i ) );
        write( H( MAX_HAMMING ) )
    end
end.
