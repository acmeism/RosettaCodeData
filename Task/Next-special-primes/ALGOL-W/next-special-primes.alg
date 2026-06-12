begin % find some primes where the gap between the current prime and the next is greater than  %
      % the gap between previus primes and the current                                         %
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
    integer MAX_NUMBER;
    MAX_NUMBER := 1050;
    begin
        logical array prime( 1 :: MAX_NUMBER );
        integer       pCount, pGap, thisPrime, nextPrime;
        % sieve the primes to MAX_NUMBER %
        Eratosthenes( prime, MAX_NUMBER );
        % the first gap is 1 (between 2 and 3) the gap between all other primes is even       %
        % so we treat 2-3 as a special case                                                   %
        write( "         this  next" );
        write( "element prime prime  gap" );
        pCount := pGap := 1; thisPrime := 2; nextPrime := 3;
        write( i_w := 5, s_w := 0, "  ", pCount, ":", thisPrime, " ", nextPrime, pGap );
        pGap := 0;
        while thisPrime < MAX_NUMBER do begin
            thisPrime := nextPrime;
            while begin
                pGap      := pGap + 2;
                nextPrime := thisPrime + pGap;
                nextPrime < MAX_NUMBER and not prime( nextPrime )
            end do begin end;
            if nextPrime < MAX_NUMBER then begin
                pCount := pCount + 1;
                write( i_w := 5, s_w := 0, "  ", pCount, ":", thisPrime, " ", nextPrime, pGap )
            end if_nextPrime_lt_MAX_NUMBER
        end while_thisPrime_lt_MAX_NUMBER
    end
end.
