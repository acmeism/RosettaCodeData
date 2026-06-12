begin % find some cousin primes: primes p where p + 4 is also a prime %
    integer MAX_PRIME;
    MAX_PRIME := 1000;
    begin
        logical array prime( 1 :: MAX_PRIME );
        integer       cCount;
        % sieve the primes to MAX_PRIME %
        prime( 1 ) := false; prime( 2 ) := true;
        for i := 3 step 2 until MAX_PRIME do prime( i ) := true;
        for i := 4 step 2 until MAX_PRIME do prime( i ) := false;
        for i := 3 step 2 until truncate( sqrt( MAX_PRIME ) ) do begin
            integer ii; ii := i + i;
            if prime( i ) then for np := i * i step ii until MAX_PRIME do prime( np ) := false
        end for_i ;
        % find the cousin primes %
        cCount := 0;
        % two is not a cousin prime so we can start at 3 %
        for i := 3 step 2 until MAX_PRIME - 4 do begin
            if prime( i ) and prime( i + 4 ) then begin
                % have another cousin prime pair %
                writeon( i_w := 1, s_w := 0, " (", i, " ", i + 4, ")" );
                cCount := cCount + 1;
                if cCount rem 10 = 0 then write()
            end if_have_a_cousin_prime_pair
        end for_i ;
        write( i_w := 1, s_w := 0, "Found ", cCount, " cousin prime pairs up to ", MAX_PRIME )
    end
end.
