begin
    % find extra primes - numbers whose digits are prime and whose   %
    % digit sum is prime                                             %
    % the digits can only be 2, 3, 5, 7                              %
    % as we are looking for extra primes below 10 000, the maximum   %
    % number to consider is 7 777, whose digit sum is 28             %
    integer MAX_PRIME;
    MAX_PRIME := 7777;
    begin
        logical array isPrime ( 1 :: MAX_PRIME );
        integer numberCount;
        % sieve the primes up to MAX_PRIME                           %
        for i := 1 until MAX_PRIME do isPrime ( i ) := true;
        isPrime( 1 ) := false;
        for i := 2 until truncate( sqrt( MAX_PRIME ) ) do begin
            if isPrime ( i ) then for p := i * i step i until MAX_PRIME do isPrime( p ) := false
        end for_i ;
        % find the extra primes                                      %
        numberCount := 0;
        write();
        for d1 := 0, 2, 3, 5, 7 do begin
            for d2 := 0, 2, 3, 5, 7 do begin
                if d2 not = 0 or d1 = 0 then begin
                    for d3 := 0, 2, 3, 5, 7 do begin
                        if d3 not = 0 or ( d1 = 0 and d2 = 0 ) then begin
                            for d4 := 2, 3, 5, 7 do begin
                                integer sum, n;
                                n := 0;
                                for d := d1, d2, d3, d4 do n := ( n * 10 ) + d;
                                sum := d1 + d2 + d3 + d4;
                                if isPrime( sum ) and isPrime( n ) then begin
                                    % found a prime whose prime      %
                                    % digits sum to a prime          %
                                    writeon( i_w := 5, s_w := 1, n );
                                    numberCount := numberCount + 1;
                                    if numberCount rem 12 = 0 then write()
                                end if_isPrime_sum
                            end for_d4
                        end if_d3_ne_0_or_d1_eq_0_and_d2_e_0
                    end for_d3
                end if_d2_ne_0_or_d1_eq_0
            end for_d2
        end for_d1
    end
end.
