begin % find all primes with strictly ascending digits - translation of Lua  %

    % quicksorts v, the bounds of v must be specified in lb and ub           %
    procedure quicksort ( integer array v( * )
                        ; integer value lb, ub
                        ) ;
        if ub > lb then begin
            % more than one element, so must sort %
            integer left, right, pivot;
            left   := lb;
            right  := ub;
            % choosing the middle element of the array as the pivot %
            pivot  := v( left + ( ( right + 1 ) - left ) div 2 );
            while begin
                while left  <= ub and v( left  ) < pivot do left  := left  + 1;
                while right >= lb and v( right ) > pivot do right := right - 1;
                left <= right
            end do begin
                integer swap;
                swap       := v( left  );
                v( left  ) := v( right );
                v( right ) := swap;
                left       := left  + 1;
                right      := right - 1
            end while_left_le_right ;
            quicksort( v, lb,   right );
            quicksort( v, left, ub    )
        end quicksort ;

    % returns true if n is prime, false otherwise                            %
    logical procedure is_prime( integer value n ) ;
        if      n  <  2     then false
        else if n rem 2 = 0 then n = 2
        else if n rem 3 = 0 then n = 3
        else begin
            logical prime; prime := true;
            for f := 5 step 6 until entier( sqrt( n ) ) do begin
                if n rem f = 0 or n rem ( f + 2 ) = 0 then begin
                    prime := false;
                    goto done
                end if_n_rem_f_eq_0_or_n_rem_f_plus_2_eq_0
            end for_f;
done:       prime
        end is_prime ;

    % increments n and also returns its new value                            %
    integer procedure inc ( integer value result n ) ; begin n := n + 1; n end;

    % sets primes to the list of ascending primes and lenPrimes to the       %
    % number of ascending primes - primes must be big enough, e.g. have 511  %
    % elements                                                               %
    procedure ascending_primes ( integer array primes ( * )
                               ; integer result lenPrimes
                               ) ;
    begin
        integer array digits     ( 1 ::    9 );
        integer array candidates ( 1 :: 6000 );
        integer lenCandidates;
        candidates( 1 ) := 0;
        lenCandidates   := 1;
        lenPrimes       := 0;
        for i := 1 until 9 do digits( i ) := i;
        for i := 1 until 9 do begin
            for j := 1 until lenCandidates do begin
                integer cValue; cValue := candidates( j ) * 10 + digits( i );
                if is_prime( cValue ) then primes( inc( lenPrimes ) ) := cValue;
                candidates( inc( lenCandidates ) ) := cValue
            end for_j
        end for_i ;
        quickSort( primes, 1, lenPrimes );
    end ascending_primes ;

    begin % find the ascending primes and print them                         %
        integer array primes ( 1 :: 512 );
        integer lenPrimes;
        ascending_primes( primes, lenPrimes );
        for i := 1 until lenPrimes do begin
            writeon( i_w := 8, s_w := 0, " ", primes( i ) );
            if i rem 10 = 0 then write()
        end for_i
    end
end.
