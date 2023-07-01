begin % find some additive primes - primes whose digit sum is also prime %
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
    MAX_NUMBER := 500;
    begin
        logical array prime( 1 :: MAX_NUMBER );
        integer       aCount;
        % sieve the primes to MAX_NUMBER %
        Eratosthenes( prime, MAX_NUMBER );
        % find the primes that are additive primes %
        aCount := 0;
        for i := 1 until MAX_NUMBER - 1 do begin
            if prime( i ) then begin
                integer dSum, v;
                v    := i;
                dSum := 0;
                while v > 0 do begin
                    dSum := dSum + v rem 10;
                    v    := v div 10
                end while_v_gt_0 ;
                if prime( dSum ) then begin
                    writeon( i_w := 4, s_w := 0, " ", i );
                    aCount := aCount + 1;
                    if aCount rem 20 = 0 then write()
                end if_prime_dSum
            end if_prime_i
        end for_i ;
        write( i_w := 1, s_w := 0, "Found ", aCount, " additive primes below ", MAX_NUMBER )
    end
end.
