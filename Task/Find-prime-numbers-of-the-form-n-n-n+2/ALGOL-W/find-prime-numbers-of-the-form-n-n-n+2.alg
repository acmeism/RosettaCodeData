begin % Find n such that n^3 + 2 is a prime for n < 200                      %
    for n := 1 until 199 do begin
        integer candidate;
        logical isPrime;
        candidate := ( n * n * n ) + 2;
        % there will only be 199 candidates, so a primality check by trial   %
        % division should be OK                                              %
        isPrime := true;
        for f := 2 until entier( sqrt( candidate ) ) do begin
            isPrime := candidate rem f  not = 0;
            if not isPrime then goto endPrimalityCheck
        end for_f ;
endPrimalityCheck:
        if isPrime then begin
            % n^3 + 2 is prime                                               %
            write( i_w := 4, s_w := 0, n, ": ", i_w := 8, candidate )
        end if_isPrime
    end for_n
end.
