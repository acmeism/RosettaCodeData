begin
    % calculates n!/k!                                                       %
    integer procedure factorialOverFactorial( integer value n, k ) ;
        if      k > n then 0
        else if k = n then 1
        else %  k < n %    begin
            integer f;
            f := 1;
            for i := k + 1 until n do f := f * i;
            f
        end factorialOverFactorial ;

    % calculates n!                                                          %
    integer procedure factorial( integer value n ) ;
        begin
            integer f;
            f := 1;
            for i := 2 until n do f := f * i;
            f
        end factorial ;

    % calculates the binomial coefficient of (n k)                           %
    % uses the factorialOverFactorial procedure for a slight optimisation    %
    integer procedure binomialCoefficient( integer value n, k ) ;
        if ( n - k ) > k
        then factorialOverFactorial( n, n - k ) div factorial(   k   )
        else factorialOverFactorial( n,   k   ) div factorial( n - k );

    % display the binomial coefficient of (5 3)                              %
    write( binomialCoefficient( 5, 3 ) )

end.
