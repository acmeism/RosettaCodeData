begin % find numbers where the sum of the first 2 digits is prime and also   %
      %                    the sum of the second 2 digits is prime           %
      % considers numbers n where 100 < n < 500                              %
    logical procedure isSmallPrime ( integer value n ); n = 2 or ( odd( n ) and n not = 1 and n not = 9 and n not = 15 );
    procedure divideBy ( integer value result n; integer value d ) ; n := n div d;
    integer procedure inc ( integer value result n ); begin n := n + 1; n end;
    integer sCount;
    sCount := 0;
    for n := 101 until 499 do begin
        integer v, d1, d2, d3;
        v  := n;
        d1 := v rem 10; divideBy( v, 10 );
        d2 := v rem 10; divideBy( v, 10 );
        d3 := v;
        if isSmallPrime( d1 + d2 ) and isSmallPrime( d2 + d3 ) then begin
            writeon( i_w := 3, s_w := 0, " ", n );
            if inc( sCount ) rem 10 = 0 then write()
        end if_small_primes
    end for_n
end.
