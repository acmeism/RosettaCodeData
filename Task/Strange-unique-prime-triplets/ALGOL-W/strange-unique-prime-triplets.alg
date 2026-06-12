begin % find some strange unique primes - triplets of primes n, m, p %
      % where n + m + p is also prime and n =/= m =/= p              %
    % sets p( 1 :: n ) to a sieve of primes up to n %
    procedure Eratosthenes ( logical array p( * ) ; integer value n ) ;
    begin
        p( 1 ) := false; p( 2 ) := true;
        for i := 3 step 2 until n do p( i ) := true;
        for i := 4 step 2 until n do p( i ) := false;
        for i := 3 step 2 until truncate( sqrt( n ) ) do begin
            integer ii; ii := i + i;
            if p( i ) then for pr := i * i step ii until n do p( pr ) := false
        end for_i ;
    end Eratosthenes ;
    % we need to find the strange unique prime triplets below 1000 %
    integer MAX_PRIME;
    MAX_PRIME := 1000;
    begin
        % the sum of the triplets could be (roughly) 3 x the largest prime %
        logical array p ( 1 :: MAX_PRIME * 3 );
        integer sCount, c30;
        % construct a sieve of primes up to MAX_PRIME * 3                  %
        Eratosthenes( p, MAX_PRIME * 3 );
        % count the strange prime triplets whose members are < 1000 and    %
        % whose sum is prime                                               %
        sCount := c30 := 0;
        % 2 cannot be one of the primes as the sum would be even otherwise %
        for n := 3 step 2 until MAX_PRIME - 5 do begin
            if p( n ) then begin
                for m := n + 2 step 2 until MAX_PRIME - 3 do begin
                    if p( m ) then begin
                        for l := m + 2 step 2 until MAX_PRIME do begin
                            if p( l ) then begin
                                integer s;
                                s := n + m + l;
                                if p( s ) then begin
                                    sCount := sCount + 1;
                                    if l <= 30 and m <= 30 and n <= 30 then begin
                                        c30 := c30 + 1;
                                        write( i_w := 3, s_w := 0, c30, ": ", n, " + ", m, " + ", l, " = ", s )
                                    end if_l_m_n_le_30
                                end if_p_s
                            end if_p_l
                        end for_l
                    end if_p_m
                end for_m
            end if_p_n
        end for_n ;
        write( i_w := 3, s_w := 0, "Found ", c30,    " strange unique prime triplets up to   30" );
        write( i_w := 3, s_w := 0, "Found ", sCount, " strange unique prime triplets up to 1000" );
    end
end.
