begin % find some happy numbers: numbers whose digit-square sums become 1    %
      % when repeatedly applied                                              %
    % returns true if n is happy, false otherwise                            %
    logical procedure isHappy ( integer value n ) ;
    begin
        % in base ten, numbers either reach 1 or loop around a sequence      %
        % containing 4 (see the Wikipedia article)                           %
        integer v, dSum, d;
        v := abs n;
        if v > 1 then begin
            while begin
                dSum := 0;
                while v not = 0 do begin
                    d    := v rem 10;
                    v    := v div 10;
                    dSum := dSum + ( d * d )
                end while_v_ne_0 ;
                v := dSum;
                v not = 1 and v not = 4
            end do begin end
        end if_v_ne_0 ;
        v = 1
    end isHappy ;
    begin % find the first 8 happy numbers                                   %
        integer n, hCount;
        hCount := 0;
        n      := 1;
        while hCount < 8 do begin
            if isHappy( n ) then begin
                writeon( i_w := 1, s_w := 0, " ", n );
                hCount := hCount + 1
            end if_isHappy__n ;
            n := n + 1
        end while_hCount_lt_10
    end
end.
