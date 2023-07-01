begin % find some Disarium numbers - numbers whose digit position-power sums  %
      % are equal to the number, e.g. 135 = 1^1 + 3^2 + 5^3                   %
    integer array power ( 1 :: 9, 0 :: 9 );
    integer MAX_DISARIUM;
    integer count, powerOfTen, length, n;
    % compute the nth powers of 0-9                                           %
    for d := 0 until 9 do power( 1, d ) := d;
    for n := 2 until 9 do begin
        power( n, 0 ) := 0;
        for d := 1 until 9 do power( n, d ) := power( n - 1, d ) * d
    end for_n;
    % print the first few Disarium numbers                                    %
    MAX_DISARIUM := 19;
    count        :=  0;
    powerOfTen   := 10;
    length       :=  1;
    n            :=  0;
    while count < MAX_DISARIUM do begin
        integer v, dps;
        if n = powerOfTen then begin
            % the number of digits just increased                             %
            powerOfTen := powerOfTen * 10;
            length     := length     +  1
        end if_m_eq_powerOfTen ;
        % form the digit power sum                                            %
        v   := n;
        dps := 0;
        for p := length step -1 until 1 do begin
            dps := dps + power( p, v rem 10 );
            v   := v div 10;
        end FOR_P;
        if dps = n then begin
            % n is Disarium                                                   %
            count := count + 1;
            writeon( i_w := 1, s_w := 0, " ", n )
        end if_dps_eq_n ;
        n := n + 1
    end
end.
