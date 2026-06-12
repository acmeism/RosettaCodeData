begin % find the product of the divisors of the first 100 positive integers %
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
        % If n > 1 then it's prime %
        if n > 1 then total := total * 2;
        total
    end divisor_count ;
    % calculates the product of the divisors of v                            %
    integer procedure divisor_product( integer value v ) ; begin
        integer count, product;
        count := divisor_count( v );
        product := 1;
        for i := 1 until count div 2 do product := product * v;
        if odd( count ) then product := product * entier( sqrt( v ) );
        product
    end divisor_product ;
    begin
        integer limit;
        limit := 50;
        write( i_w := 1, s_w := 0, "Product of divisors for the first ", limit, " positive integers:" );
        for n := 1 until limit do begin
            if n rem 5 = 1 then write();
            writeon( i_w := 10, s_w := 1, divisor_product( n ) )
        end for_n
    end
end.
