begin % -- find some fermat pseudo primes: x is a fermat pseudoprime in       %
      % -- base a if a^(x-1) - 1 is divisible by x and x is not prime         %
  integer MAX_PRIME;
  MAX_PRIME := 50000;
  begin
    logical array prime ( 0 :: MAX_PRIME );
    begin % -- sieve the primes                                               %
        prime( 0 ) := prime( 1 ) := false;
        prime( 2 ) := true;
        for i := 3 step 2 until MAX_PRIME do prime( i ) := true;
        for i := 4 step 2 until MAX_PRIME DO prime( i ) := false;
        for i := 3 step 2 until entier( sqrt( MAX_PRIME ) ) do begin
            if prime( i ) then begin
                for s := i * i step i + i until MAX_PRIME do begin
                    prime( s ) := false;
                end for_s
            end if_prime_i
        end for_i
    end sieve_the_primes ;
    for base := 1 until 20 do begin
        integer array fp ( 1 :: 20 );
        integer count;
        count := 0;
        % -- x from 3 as 1 is neither composite nor prime and 2 is prime      %
        if base = 1 then begin
            % -- 1^(x-1) is 1 for all x, so all composites are                %
            % -- fermat pseudo primes in base 1                               %
            for x := 3 until MAX_PRIME do begin
                if not prime( x ) then begin
                    count := count + 1;
                    if count <= 20 THEN fp( count ) := x
                end if_not_prime_x
            end for_x
            end
        else begin
            % -- must test base^(x-1) mod x                                   %
            % -- iterative Greatest Common Divisor routine                    %
            integer stepSize;
            integer procedure gcd ( integer value m, n ) ;
            begin
                integer a, b, newA;
                a := abs( m );
                b := abs( n );
                while b not = 0 do begin
                    newA := b;
                    b    := a rem b;
                    a    := newA;
                end while_b_ne_0 ;
                a
            end gcd ;
            stepSize := ( if odd( base ) then 1 else 2 );
            for x := 3 step stepSize until MAX_PRIME
            do begin
                if not prime( x ) and gcd( x, base ) = 1 then begin
                    % -- have a composite x co-prime to the base              %
                    integer baseToXMinus1ModX, p;
                    logical looking;
                    baseToXMinus1ModX := p := 1;
                    looking           := true;
                    while p < x and looking do begin
                        baseToXMinus1ModX := ( baseToXMinus1ModX * base ) rem x;
                        if basetoXMinus1Modx = 1 then begin
                            % -- the power is now 1 mod x,                    %
                            % -- if the power divides x - 1 then base^(x-1)   %
                            % -- will be 1 mod otherwise it won't be          %
                            if ( x - 1 ) rem p not = 0 then begin
                                baseToXMinus1ModX := 0
                            end if_p_doesnt_divide_x_minus_1 ;
                            looking := false
                        end if_basetoXMinus1Modx_eq_1 ;
                        p := p + 1
                    end while_p_lt_x_and_lookiing ;
                    if baseToXMinus1ModX = 1 then begin
                        % -- have a composite x that divides base^(x-1)-1     %
                        count := count + 1;
                        if count <= 20 then fp( count ) := x
                    end if_baseToXMinus1ModX_eq_1
                end if_not_prime_x
            end for_x
        end if_base_eq_1__ ;
        write( i_w := 2, s_w := 0, "base ", base, " to ", MAX_PRIME, " total: ", i_w := 1, count );
        write( "     first:" );
        for f := 1 until ( if count < 20 then count else 20 ) do begin
            writeon( i_w := 1, s_w := 0, " ", fp( f ) )
        end for_f;
    end for_base
  end
end.
