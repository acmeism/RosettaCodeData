begin % find squares n where n + 1 is prime                                  %

    % returns true if n is prime, false otherwise, uses trial division       %
    logical procedure isPrime ( integer value n ) ;
        if      n < 3        then n = 2
        else if n rem 3 = 0  then n = 3
        else if not odd( n ) then false
        else begin
            logical prime;
            integer f, f2, toNext;
            prime  := true;
            f      := 5;
            f2     := 25;
            toNext := 24;           % note: ( 2n + 1 )^2 - ( 2n - 1 )^2 = 8n %
            while f2 <= n and prime do begin
                prime  := n rem f not = 0;
                f      := f + 2;
                f2     := toNext;
                toNext := toNext + 8
             end while_f2_le_n_and_prime ;
             prime
        end isPrime ;

    % other than 1, the numbers must be even                                 %
    if isPrime( 2 % i.e.: ( 1 * 1 ) + 1 % ) then write( ( " 1" ) );

    begin
        integer i2, toNext;
        toNext := i2 := 4;              % note: ( 2n + 2 )^2 - 2n^2 = 8n + 4 %
        while i2 < 1000 do begin
            if isPrime( i2 + 1 ) then writeon( i_w := 1, s_w := 0, " ", i2 );
            toNext := toNext + 8;
            i2     := i2 + toNext
        end while_i2_lt_1000
    end

end.
