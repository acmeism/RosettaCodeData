begin % find a sequence of primes where the members differ by a cube %
    integer MAX_PRIME, MAX_CUBE;
    MAX_PRIME := 15000;
    MAX_CUBE  := entier( exp( ln( MAX_PRIME ) / 3 ) );
    begin
        logical array prime ( 1 :: MAX_PRIME );
        integer array cube  ( 1 :: MAX_CUBE  );
        integer p, q, c;
        % sieve the primes to MAX_PRIME %
        prime( 1 ) := false; prime( 2 ) := true;
        for i := 3 step 2 until MAX_PRIME do prime( i ) := true;
        for i := 4 step 2 until MAX_PRIME do prime( i ) := false;
        for i := 3 step 2 until entier( sqrt( MAX_PRIME ) ) do begin
            integer ii; ii := i + i;
            if prime( i ) then for s := i * i step ii until MAX_PRIME do prime( s ) := false
        end for_i;
        % construct a table of cubes, we will need at most the cube root of max prime %
        for i := 1 until MAX_CUBE do cube( i ) := i * i * i;
        % find the prime sequence %
        writeon( "2" );
        p := 2;
        while p < MAX_PRIME do begin
            % find a prime that is p + a cube %
            c := 1;
            q := p + cube( c );
            while q <= MAX_PRIME and not prime( q ) do begin
                c := c + 1;
                q := p + cube( c )
            end while_not_prime_q ;
            if q <= MAX_PRIME then writeon( i_w := 1, s_w := 0, " ", q );
            p := q
        end while_p_lt_MAX_PRIME
    end;
    write()
end.
