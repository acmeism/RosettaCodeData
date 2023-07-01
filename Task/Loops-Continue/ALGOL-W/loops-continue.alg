begin
    i_w := 1; s_w := 0; % set output format %
    for i := 1 until 10 do begin
        writeon( i );
        if i rem 5 = 0
        then write()
        else writeon( ", " )
    end for_i
end.
