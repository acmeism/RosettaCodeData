begin % print the lowest square that starts with 1..49        %
    integer MAX_NUMBER;
    MAX_NUMBER := 49;
    begin
        integer array lowest( 1 :: MAX_NUMBER );
        integer       numberFound, n;
        numberFound := 0;
        for i := 1 until MAX_NUMBER do lowest( i ) := 0;
        n := 0;
        while numberFound < MAX_NUMBER do begin
            integer v, n2;
            n := n + 1;
            v := n2 := n * n;
            while v > 0 do begin
                if v <= MAX_NUMBER and lowest( v ) = 0 then begin
                    % found a square that starts with a number in the range %
                    lowest( v ) := n2;
                    numberFound := numberFOund + 1
                end if_v_le_MAX_NUMBER_and_lowest_v_eq_0 ;
                v := v div 10
            end while_v_gt_0
        end while_numberFound_lt_MAX_NUMBER ;
        % show the squares                                     %
        for i := 1 until MAX_NUMBER do begin
            writeon( i_w := 6, s_w := 0, " ", lowest( i ) );
            if i rem 10 = 0 then write()
        end for_i
    end
end.
