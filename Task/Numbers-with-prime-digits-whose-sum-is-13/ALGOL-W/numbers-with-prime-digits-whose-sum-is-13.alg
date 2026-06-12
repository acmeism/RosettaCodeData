begin
    % find numbers whose digits are prime and whose digit sum is 13  %
    % as noted by the Wren sample, the digits can only be 2, 3, 5, 7 %
    % and there can only be 3, 4, 5 or 6 digits                      %
    integer numberCount;
    numberCount := 0;
    write();
    for d1 := 0, 2, 3, 5, 7 do begin
        for d2 := 0, 2, 3, 5, 7 do begin
            if d2 not = 0 or d1 = 0 then begin
                for d3 := 0, 2, 3, 5, 7 do begin
                    if d3 not = 0 or ( d1 = 0 and d2 = 0 ) then begin
                        for d4 := 2, 3, 5, 7 do begin
                            for d5 := 2, 3, 5, 7 do begin
                                for d6 := 2, 3, 5, 7 do begin
                                    integer sum;
                                    sum := d1 + d2 + d3 + d4 + d5 + d6;
                                    if sum = 13 then begin
                                        % found a number whose prime digits sum to 13 %
                                        integer n;
                                        n := 0;
                                        for d := d1, d2, d3, d4, d5, d6 do n := ( n * 10 ) + d;
                                        writeon( i_w := 6, s_w := 1, n );
                                        numberCount := numberCount + 1;
                                        if numberCount rem 12 = 0 then write()
                                    end if_sum_eq_13
                                end for_d6
                            end for_d5
                        end for_d4
                    end if_d3_ne_0_or_d1_eq_0_and_d2_e_0
                end for_d3
            end if_d2_ne_0_or_d1_eq_0
        end for_d2
    end for_d1
end.
