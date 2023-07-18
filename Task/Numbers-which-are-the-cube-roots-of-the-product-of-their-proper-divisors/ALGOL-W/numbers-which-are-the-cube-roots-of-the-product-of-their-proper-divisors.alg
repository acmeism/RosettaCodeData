begin % find some numbers which are the cube roots of the product of their   %
      %      proper divisors                                                 %
      % the Online Encyclopedia of Integer Sequences states that these       %
      % numbers are 1 and those with eight divisors                          %
      % NB: numbers with 8 divisors have 7 proper divisors                   %

    integer MAX_NUMBER;                    % maximum number we will consider %
    MAX_NUMBER := 500000;

    begin
        % form a table of proper divisor counts - pretend the pdc of 1 is 7  %
        integer array pdc ( 1 :: MAX_NUMBER );
        integer nextToShow, cCount;
        for i := 1 until MAX_NUMBER do pdc( i ) := 1;
        pdc( 1 ) := 7;
        for i := 2 until MAX_NUMBER do begin
            for j := i + i step i until MAX_NUMBER do pdc( j ) := pdc( j ) + 1
        end;
        % show the numbers which are the cube root of their proper divisor   %
        % product - equivalent to finding the numbers with a proper divisor  %
        % count of 7 ( we have "cheated" and set the pdc of 1 to 7 )         %
        nextToShow := 500;
        cCount     := 0;
        for n := 1 until MAX_NUMBER do begin
            if pdc( n ) = 7 then begin
                % found a suitable number                                    %
                cCount := cCount + 1;
                if      cCount <= 50 then begin
                    writeon( i_w := 3, s_w := 0, " ", n );
                    if cCount rem 10 = 0 then write()
                    end
                else if cCount = nextToShow then begin
                    write( i_w := 9, s_w := 0, cCount, "th: ", i_w := 1, n );
                    nextToShow := nextToShow * 10
                end if_various_cCount_values
            end if_pdc_n_eq_7
        end for_m
    end
end.
