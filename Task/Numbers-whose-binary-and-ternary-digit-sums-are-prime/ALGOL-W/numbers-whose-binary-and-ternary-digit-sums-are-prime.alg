begin % find numbers whose binary and ternary digit sums are prime %
    % returns the digit sum of n in base b %
    integer procedure digitSum( integer value n, base ) ;
    begin
        integer v, dSum;
        v    := abs n;
        dSum := 0;
        while v > 0 do begin
            dSum := dSum + v rem base;
            v    :=        v div base
        end while_v_gt_0 ;
        dSum
    end digitSum ;
    integer MAX_PRIME, MAX_NUMBER;
    MAX_PRIME := 199;
    begin
        logical array prime( 1 :: MAX_PRIME );
        integer       nCount;
        % sieve the primes to MAX_PRIME %
        prime( 1 ) := false; prime( 2 ) := true;
        for i := 3 step 2 until MAX_PRIME do prime( i ) := true;
        for i := 4 step 2 until MAX_PRIME do prime( i ) := false;
        for i := 3 step 2 until truncate( sqrt( MAX_PRIME ) ) do begin
            integer ii; ii := i + i;
            if prime( i ) then for np := i * i step ii until MAX_PRIME do prime( np ) := false
        end for_i ;
        % find the numbers %
        nCount := 0;
        for i := 1 until MAX_PRIME do begin
            if prime( digitSum( i, 2 ) ) and prime( digitSum( i, 3 ) ) then begin
                % have another matching number %
                writeon( i_w := 3, s_w := 0, " ", i );
                nCount := nCount + 1;
                if nCount rem 14 = 0 then write()
            end if_have_a_suitable_number
        end for_i ;
        write( i_w := 1, s_w := 0, "Found ", nCount, " numbers with prime binary and ternary digit sums up to ", MAX_PRIME )
    end
end.
