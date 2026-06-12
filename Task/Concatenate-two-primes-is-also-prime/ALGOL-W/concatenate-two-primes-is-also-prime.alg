begin % find primes whose decimal representation is the concatenation of 2 primes %
    integer MAX_PRIME;
    MAX_PRIME := 99 * 99;
    begin
        logical array isPrime     ( 1 :: MAX_PRIME );
        logical array concatPrime ( 1 :: MAX_PRIME );
        integer cCount;
        % sieve the primes to MAX_PRIME                                           %
        isPrime( 1 ) := false; isPrime( 2 ) := true;
        for i := 3 step 2 until MAX_PRIME do isPrime( i ) := true;
        for i := 4 step 2 until MAX_PRIME do isPrime( i ) := false;
        for i := 3 step 2 until truncate( sqrt( MAX_PRIME ) ) do begin
            integer ii; ii := i + i;
            if isPrime( i ) then for pr := i * i step ii until MAX_PRIME do isPrime( pr ) := false
        end for_i ;
        % find the concatenated primes, note their final digit can't be 2 or 5    %
        for i := 1 until MAX_PRIME do concatPrime( i ) := false;
        cCount := 0;
        for     p1 :=  2,  3,  5,  7, 11, 13, 17, 19, 23, 29, 31, 37
                    , 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97 do begin
            for p2 :=      3,      7, 11, 13, 17, 19, 23, 29, 31, 37
                    , 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97 do begin
                integer pc;
                pc := ( p1 * ( if p2 < 10 then 10 else 100 ) ) + p2;
                concatPrime( pc ) := isPrime( pc )
            end for_p2
        end for_p1;
        % print the concatenated primes                                           %
        cCount := 0;
        for i := 1 until MAX_PRIME do begin
            if concatPrime( i ) then begin
                writeon( i_w := 5, s_w := 0, i );
                cCount := cCount + 1;
                if cCount rem 10 = 0 then write()
            end if_concatPrime_i
        end for_i;
        write();write( i_w := 1, s_w := 0, "Found ", cCount, " concat primes" )
    end
end.
