begin % find numbers divisible by their digits but not the product of their digits %
    % returns true if n is divisible by its digits but not the product of its      %
    %         digits, false otherwise                                              %
    logical procedure divisibleByDigitsButNotDigitProduct ( integer value n ) ;
    begin
        integer v, p;
        logical matches;
        v       := n;
        p       := 1;
        matches := v not = 0;
        while matches and v > 0 do begin
            integer d;
            d       := v rem 10;
            v       := v div 10;
            if d = 0 then matches := false else matches := n rem d = 0;
            p       := p * d
        end while_matches_and_v_gt_0 ;
        if matches then begin
            if p = 0 then matches := false else matches := n rem p not = 0
        end if_matche ;
        matches
    end divisibleByDigitsButNotDigitProduct ;
    integer count;
    % show the members of the seuence up to 1000 %
    write( "Numbers below 1000 that are divisible by their digits but not the product of their digits:" );
    write();
    count := 0;
    for i := 0 until 999 do begin
        if divisibleByDigitsButNotDigitProduct( i ) then begin
            writeon( i_w := 3, s_w := 0, " ", i );
            count := count + 1;
            if count rem 15 = 0 then write()
        end if_divisibleByDigitsButNotDigitProduct__i
    end for_i
end.
