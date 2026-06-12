begin % sum the divisors of the first 100 positive integers %
    % computes the sum of the divisors of n using the prime %
    % factorisation                                         %
    integer procedure divisor_sum( integer value v ) ; begin
        integer total, power, n, p;
        total := 1; power := 2; n := v;
        % Deal with powers of 2 first %
        while not odd( n ) do begin
            total := total + power;
            power := power * 2;
            n     := n div 2
        end while_not_odd_n ;
        % Odd prime factors up to the square root %
        p := 3;
        while ( p * p ) <= n do begin
            integer sum;
            sum   := 1;
            power := p;
            while n rem p = 0 do begin
                sum   := sum + power;
                power := power * p;
                n     := n div p
            end while_n_rem_p_eq_0 ;
            p     := p + 2;
            total := total * sum
        end while_p_x_p_le_n ;
        % If n > 1 then it's prime %
        if n > 1 then total := total * ( n + 1 );
        total
    end divisor_sum ;
    begin
        integer limit;
        limit := 100;
        write( i_w := 1, s_w := 0, "Sum of divisors for the first ", limit, " positive integers:" );
        for n := 1 until limit do begin
            if n rem 10 = 1 then write();
            writeon( i_w := 4, s_w := 1, divisor_sum( n ) )
        end for_n
    end
end.
