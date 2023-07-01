begin % find the count of the divisors of the first 100 positive integers   %
    % calculates the number of divisors of v                                %
    integer procedure divisor_count( integer value v ) ; begin
        integer total, n, p;
        total := 1; n := v;
        % Deal with powers of 2 first %
        while not odd( n ) do begin
            total := total + 1;
            n     := n div 2
        end while_not_odd_n ;
        % Odd prime factors up to the square root %
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
        % If n > 1 then it is prime %
        if n > 1 then total := total * 2;
        total
    end divisor_count ;
    begin
        integer limit;
        limit := 100;
        write( i_w := 1, s_w := 0, "Count of divisors for the first ", limit, " positive integers:" );
        for n := 1 until limit do begin
            if n rem 20 = 1 then write();
            writeon( i_w := 3, s_w := 1, divisor_count( n ) )
        end for_n
    end
end.
