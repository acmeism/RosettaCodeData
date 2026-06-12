begin % find some "Calmo" numbers: numbers n such that they have 3k divisors   %
      % (other than 1 and n) for some k > 0 and the sum of their divisors      %
      % taken three at a time is a prime                                       %

    integer MAX_NUMBER, MAX_PRIME;
    MAX_NUMBER := 1000;                      % largest number we will consider %
    MAX_PRIME  := MAX_NUMBER * 3;          % largest prime we need to consider %
                         % as we are going to sum divisors in groups of three, %
                                       % it should be (more than) large enough %

    begin
        logical array prime ( 1 :: MAX_PRIME );
        integer array dsum, dcount ( 1 :: MAX_NUMBER );
        % sieve the primes to MAX_PRIME                                        %
        for i := 1 until MAX_PRIME do prime( i ) := true;
        prime( 1 ) := false;
        for i := 2 until truncate( sqrt( MAX_PRIME ) ) do begin
            if prime( i ) then begin
                for p := i * i step i until MAX_PRIME do prime( p ) := false
            end if_prime_i
        end for_i ;
        % construct tables of the divisor counts and divisor sums and check    %
        % for the numbers as we do it                                          %
        % as we are ignoring 1 and n, the initial counts and sums will be 0    %
        % but we should ignore primes                                          %
        for i := 1 until MAX_NUMBER do begin
            dsum( i ) := dcount( i ) := if prime( i ) then -1 else 0
        end for_i ;
        for i := 2 until MAX_NUMBER do begin
            for j := i + i step i until MAX_NUMBER do begin
                % have another proper divisor                                  %
                if dsum( j ) >= 0 then begin
                    % this number is still a candidate                         %
                    dsum(   j ) := dsum(   j ) + i;
                    dcount( j ) := dcount( j ) + 1;
                    if dcount( j ) = 3 then begin
                        % the divisor count is currently 3                     %
                        % if then divisor sum isn't prime, ignore it in future %
                        % if the divisor sum is prime, reset the sum and count %
                        dsum( j ) := dcount( j ) :=
                            if NOT prime( dsum( j ) ) then - 1 else 0
                    end if_dcount_j_eq_3
                end if_dsum_j_ge_0
            end for_j
        end for_i ;
        % show the numbers                                                    %
        for i := 2 until MAX_NUMBER do begin
            if dcount( i ) = 0 then writeon( i_w := 1, s_w := 0, " ", i )
        end for_i ;
    end
end.
