begin % find numbers where reverse(d) divides reverse(n) for all divisors d %
      % of n                                                                %
    % returns n with the digits reversed                                    %
    integer procedure reverse ( integer value n ) ;
    begin
        integer r, v;
        r := 0;
        v := abs n;
        while v > 0 do begin
            r := ( r * 10 ) + ( v rem 10 );
            v := v div 10
        end while_v_gt_0 ;
        if n < 0 then - r else r
    end reverse ;
    % find the numbers up to 200                                            %
    integer rdCount;
    rdCount := 0;
    for n := 1 until 199 do begin
        integer reverseN, d, maxD;
        logical reverseDivisor;
        reverseN       := reverse( n );
        reverseDivisor := true;
        d              := 1;
        maxD           := n div 2;
        while begin
                  d := d + 1;
                  d <= maxD and reverseDivisor
              end
        do begin
            if n rem d = 0 then begin
                % have a divisor of n                                       %
                reverseDivisor := reverseN rem reverse( d ) = 0
            end if_n_rem_d_eq_0
        end while_d_le_maxD_and_reverseDivisor ;
        if reverseDivisor then begin
            % all the divisors of n reversed divide n reversed              %
            writeon( i_w := 3, s_w := 0, " ", n );
            rdCount := rdCount + 1;
            if rdCount rem 10 = 0 then write()
        end if_reverseDivisor
    end for_n ;
    write( i_w := 1, s_w := 0, "Found ", rdCount, " ""special divisors"" below 200" )
end.
