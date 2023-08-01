begin % find elements of the Euclid-Mullin sequence: starting from 2,    %
      % the next element is the smallest prime factor of 1 + the product %
      % of the previous elements                                         %
    integer product;
    write( "2" );
    product := 2;
    for i := 2 until 8 do begin
        integer nextV, p;
        logical found;
        nextV := product + 1;
        % find the first prime factor of nextV                           %
        p     := 3;
        found := false;
        while p * p <= nextV and not found do begin
            found := nextV rem p = 0;
            if not found then p := p + 2
        end while_p_squared_le_nextV_and_not_found ;
        if found then nextV := p;
        writeon( i_w := 1, s_w := 0, " ", nextV );
        product := product * nextV
    end for_i
end.
