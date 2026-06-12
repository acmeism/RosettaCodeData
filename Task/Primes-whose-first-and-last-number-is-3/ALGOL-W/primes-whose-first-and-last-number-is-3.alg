begin % find some primes whose first and last digits are 3                   %
    integer MAX_PRIME;
    MAX_PRIME := 4000;
    begin
        logical array isPrime ( 1 :: MAX_PRIME );
        integer p3Count;
        % increments n by 1                                                  %
        integer procedure inc( integer value result n ) ; begin n := n + 1; n end;
        % prints n, if it is prime, handles newlines                         %
        procedure p ( integer value n ) ;
            if isPrime( n ) then begin writeon( i_w := 4, s_w := 0, " ", n ); if inc( p3Count ) rem 12 = 0 then write() end;
        % sieve the primes to MAX_PRIME                                      %
        isPrime( 1 ) := false; isPrime( 2 ) := true;
        for i := 3 step 2 until MAX_PRIME do isPrime( i ) := true;
        for i := 4 step 2 until MAX_PRIME do isPrime( i ) := false;
        for i := 3 step 2 until truncate( sqrt( MAX_PRIME ) ) do begin
            integer ii; ii := i + i;
            if isPrime( i ) then for pr := i * i step ii until MAX_PRIME do isPrime( pr ) := false
        end for_i ;
        % find the 3x3 primes                                                %
        p3Count := 0;
        % 1, 2 and 3 digit 3x3 primes                                        %
        p( 3 ); p( 33 ); for i := 0 step 10 until 90 do p( 303 + i );
        % 4 digit 3x3 primes                                                 %
        for i := 0 step 10 until 990 do p( 3003 + i );
    end
end.
