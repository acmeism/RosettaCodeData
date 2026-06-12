begin % find some primes where ( p*q ) + 2 is also a prime ( where p and q are adjacent primes ) %
    % sets p( 1 :: n ) to a sieve of primes up to n %
    procedure sieve ( logical array p( * ) ; integer value n ) ;
    begin
        p( 1 ) := false; p( 2 ) := true;
        for i := 3 step 2 until n do p( i ) := true;
        for i := 4 step 2 until n do p( i ) := false;
        for i := 3 step 2 until truncate( sqrt( n ) ) do begin
            integer ii; ii := i + i;
            if p( i ) then for np := i * i step ii until n do p( np ) := false
        end for_i ;
    end sieve ;
    integer MAX_NUMBER, MAX_PRIME;
    MAX_NUMBER := 500;
    MAX_PRIME  := MAX_NUMBER * MAX_NUMBER;
    begin
        logical array prime( 1 :: MAX_PRIME );
        integer       pCount, thisPrime, nextPrime;
        % sieve the primes to MAX_PRIME %
        sieve( prime, MAX_PRIME );
        % find the neighbour primes %
        pCount    := 0;
        thisPrime := 2; % 2 is the lowest prime %
        while thisPrime > 0 do begin
            % find the next prime after this one %
            nextPrime := thisPrime + 1;
            while nextPrime <= MAX_NUMBER and not prime( nextPrime ) do nextPrime := nextPrime + 1;
            if nextPrime > MAX_NUMBER then thisPrime := 0
            else begin
                if prime( ( thisPrime * nextPrime ) + 2 ) then begin
                    % have another neighbour prime %
                    writeon( i_w := 1, s_w := 0, " ", thisPrime );
                    pCount := pCount + 1
                end if_prime__thisPrime_x_nextPrime_plus_2 ;
                thisPrime := nextPrime
            end if_nextPrime_gt_MAX_NUMBER__
        end while_thisPrime_gt_0 ;
        write( i_w := 1, s_w := 0, "Found ", pCount, " neighbour primes up to 500" )
    end
end.
