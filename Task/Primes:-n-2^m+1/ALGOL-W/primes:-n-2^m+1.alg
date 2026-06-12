begin % find primes of the form 1+n*2^m where m is the lowest integer >= 0   %
      % such that 1+n*2^m is prime                                           %
    integer MAX_M, MAX_PRIME;
    MAX_M     := 22;
    MAX_PRIME := 10000;
    begin
        logical array prime ( 1 :: MAX_PRIME );
        % sieve the primes to MAX_PRIME                                      %
        prime( 1 ) := false; prime( 2 ) := true;
        for i := 3 step 2 until MAX_PRIME do prime( i ) := true;
        for i := 4 step 2 until MAX_PRIME do prime( i ) := false;
        for i := 3 step 2 until truncate( sqrt( MAX_PRIME ) ) do begin
            integer ii; ii := i + i;
            if prime( i ) then for pr := i * i step ii until MAX_PRIME do prime( pr ) := false
        end for_i ;
        % find the n*2^m + 1 primes                                          %
        for n := 1 until 45 do begin
            integer m, twoToM, p;
            logical notFound;
            m        := 0;
            twoToM   := 1;
            p        := 0;
            notFound := true;
            while notFound and m <= MAX_M do begin
                p := ( n * twoToM ) + 1;
                notFound := not prime( p );
                if notFound then begin
                    twoToM := twoToM + twoToM;
                    m      := m + 1
                end if_notFound
            end while_notFound_and_m_le_MAX_M ;
            if notFound
            then writeon( i_w := 3, s_w := 0, "(", n, " not found)" )
            else writeon( i_w := 3, s_w := 0, "(", n, " ", i_w := 1, m, ": ", i_w := 4, p, "  )" );
            if n rem 5 = 0 then write()
        end for_n
    end
end.
