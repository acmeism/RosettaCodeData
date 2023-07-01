begin % find some Giuga numbers, composites n such that all their distinct   %
      %                        prime factors f exactly divide ( n / f ) - 1  %

    % find the first four Giuga numbers                                      %
    % each prime factor must appear only once, e.g.: for 2:                  %
    % [ ( n / 2 ) - 1 ] mod 2 = 0  => n / 2 is odd => n isn't divisible by 4 %
    % similarly for other primes                                             %

    integer gCount, n;
    gCount :=  0;
    n      := -2;
    while begin n := n + 4;
                gCount < 4
          end
    do begin    % assume the numbers are all even                            %
        integer v, f, fCount;
        logical isGiuga;
        v       := n div 2;
        isGiuga := TRUE;
        fCount  := 1;
        f       := 1;
        while begin f := f + 2;
                    f <= v and isGiuga
              end
        do begin
            if v rem f = 0 then begin
                % have a prime factor                                        %
                fCount  := fCount + 1;
                isGiuga := ( ( n div f ) - 1 ) rem f = 0;
                v := v div f
            end if_v_rem_f_eq_0
        end while_f_le_v_and_isGiuga ;
        if isGiuga then begin
            % n is still a candidate, check it is not prime                  %
            if fCount > 1 then begin
                gCount := gCount + 1;
                writeon( i_w := 1, s_w := 0, " ", n )
            end if_fCount_gt_1
        end if_isGiuga
    end while_gCount_lt_4
end.
