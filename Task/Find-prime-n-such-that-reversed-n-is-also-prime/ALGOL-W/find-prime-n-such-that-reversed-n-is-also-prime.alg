begin % find some primes whose digits reversed is also prime %
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
    integer MAX_NUMBER, maxPrime;
    MAX_NUMBER := 500;
    % approximate the largest prime we need to consider ( 10 ^ number of digits in MAX_NUMBER ) %
    begin
        integer v;
        v        := MAX_NUMBER;
        maxPrime := 1;
        while v > 0 do begin
            v := v div 10;
            maxPrime := maxPrime * 10
        end while_v_gt_0
    end;
    begin
        logical array prime( 1 :: maxPrime);
        integer       pCount;
        % sieve the primes to maxPrime %
        Eratosthenes( prime, maxPrime );
        % find the primes that are reversable %
        pCount := 0;
        for i := 1 until MAX_NUMBER - 1 do begin
            if prime( i ) then begin
                integer pReversed, v;
                v         := i;
                pReversed := 0;
                while v > 0 do begin
                    pReversed := ( pReversed * 10 ) + v rem 10;
                    v         := v div 10
                end while_v_gt_0 ;
                if prime( pReversed ) then begin
                    writeon( i_w := 4, s_w := 0, " ", i );
                    pCount := pCount + 1;
                    if pCount rem 20 = 0 then write()
                end if_prime_pReversed
            end if_prime_i
        end for_i ;
        write( i_w := 1, s_w := 0, "Found ", pCount, " reversable primes below ", MAX_NUMBER )
    end
end.
