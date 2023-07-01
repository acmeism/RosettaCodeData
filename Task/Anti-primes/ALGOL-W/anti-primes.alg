begin
    % find some anti-primes - numbers with more factors than the numbers    %
    % smaller than them                                                     %
    % calculates the number of divisors of v                                %
    integer procedure divisor_count( integer value v ) ; begin
        integer total, n, p;
        total := 1; n := v;
        while not odd( n ) do begin
            total := total + 1;
            n     := n div 2
        end while_not_odd_n ;
        p := 3;
        while ( p * p ) <= n do begin
            integer count;
            count := 1;
            while n rem p = 0 do begin
                count := count + 1;
                n     := n div p
            end while_n_rem_p_eq_0 ;
            p     := p + 2;
            total := total * count
        end while_p_x_p_le_n ;
        if n > 1 then total := total * 2;
        total
    end divisor_count ;
    begin
        integer maxAntiPrime, antiPrimeCount, maxDivisors, n;
        maxAntiPrime := 20;
        n := maxDivisors := antiPrimeCount := 0;
        while antiPrimeCount < maxAntiPrime do begin
            integer divisors;
            n := n + 1;
            divisors := divisor_count( n );
            if divisors > maxDivisors then begin
                writeon( i_w := 1, s_w := 0, " ", n );
                maxDivisors    := divisors;
                antiPrimeCount := antiPrimeCount + 1
            end if_have_an_anti_prime
        end while_antiPrimeCoiunt_lt_maxAntiPrime
    end
end.
