begin
    % find some abundant odd numbers - numbers where the sum of the proper    %
    %                                  divisors is bigger than the number     %
    %                                  itself                                 %

    % computes the sum of the divisors of v using the prime                   %
    % factorisation                                                           %
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
    % returns the sum of the proper divisors of v                             %
    integer procedure divisorSum( integer value v ) ;
        if v < 2 then 0 else divisor_sum( v ) - v;
    % find numbers required by the task                                       %
    begin
        integer aCount, oddNumber, dSum;
        logical foundOddAn;
        % first 25 odd abundant numbers                                       %
        oddNumber := 1;
        aCount    := 0;
        write( "The first 25 abundant odd numbers:" );
        while aCount < 25 do begin
            dSum := divisorSum( oddNumber );
            if dSum > oddNumber then begin
                aCount := aCount + 1;
                write( i_w := 6, oddNumber, " proper divisor sum: ", dSum )
            end if_dSum_gt_oddNumber ;
            oddNumber := oddNumber + 2
        end while_aCount_lt_1000 ;
        % 1000th odd abundant number                                          %
        while aCount < 1000 do begin
            dSum := divisorSum( oddNumber );
            if dSum > oddNumber then aCount := aCount + 1;
            oddNumber := oddNumber + 2
        end while_aCount_lt_1000 ;
        write( "1000th abundant odd number: " );
        write( oddNumber - 2, " proper divisor sum: ", dSum );
        % first odd abundant number > one billion                             %
        oddNumber  := 1000000001;
        foundOddAn := false;
        while not foundOddAn do begin
            dSum := divisorSum( oddNumber );
            if dSum > oddNumber then begin
                foundOddAn := true;
                write( "First abundant odd number > 1000000000: " );
                write( oddNumber, " proper divisor sum: ", dSum )
            end if_dSum_gt_oddNumber ;
            oddNumber := oddNumber + 2
        end while_not_foundOddAn ;
    end
end.
