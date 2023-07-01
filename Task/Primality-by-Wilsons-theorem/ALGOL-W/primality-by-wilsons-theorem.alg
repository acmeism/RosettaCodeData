begin
    % find primes using Wilson's theorem:                               %
    %    p is prime if ( ( p - 1 )! + 1 ) mod p = 0                     %

    % returns true if n is a prime by Wilson's theorem, false otherwise %
    %         computes the factorial mod p at each stage, so as to      %
    %         allow numbers whose factorial won't fit in 32 bits        %
    logical procedure isWilsonPrime ( integer value n ) ;
    begin
        integer factorialModN;
        factorialModN := 1;
        for i := 2 until n - 1 do factorialModN := ( factorialModN * i ) rem n;
        factorialModN = n - 1
    end isWilsonPrime ;

    for i := 1 until 100 do if isWilsonPrime( i ) then writeon( i_w := 1, s_w := 0, " ", i );
end.
