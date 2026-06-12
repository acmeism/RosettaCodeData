begin % find numbers whose hex representation does not contain the digits 0-9 %

    % generate and print the numbers up to 499                                %
    % 499 is 1F3 in hex, so we need to find numbers up to FF                  %

    integer hCount;

    hCount := 0;

    % 1 hex digit numbers                                                     %
    for d1 := 10 until 15 do begin
        writeon( i_w := 3, s_w := 0, " ", d1 );
        hCount := hCount + 1;
    end for_d1 ;

    % two hex digit numbers                                                   %
    for d1 := 10 until 15 do begin
        for d2 := 10 until 15 do begin
            writeon( i_w := 3, s_w := 0, " ", ( d1 * 16 ) + d2 );
            hCount := hCount + 1;
            if hCount rem 12 = 0 then write()
        end for_d2
    end for_d1
end.
