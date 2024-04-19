begin % show some Stirling numbers of the second kind                         %
    integer MAX_STIRLING;
    MAX_STIRLING := 12;
    begin
        % construct a matrix of Stirling numbers up to max n, max n           %
        integer array s2 ( 0 :: MAX_STIRLING, 0 :: MAX_STIRLING );
        for n := 0 until MAX_STIRLING do begin
            for k := 0 until MAX_STIRLING do s2( n, k ) := 0
        end for_n ;
        for n := 0 until MAX_STIRLING do s2( n, n ) := 1;
        for n := 0 until MAX_STIRLING - 1 do begin
            for k := 1 until n do begin
                s2( n + 1, k ) := k * s2( n, k ) + s2( n, k - 1 );
            end for_k
        end for_n ;
        % print the Stirling numbers                                          %
        write( "Stirling numbers of the second kind:" );
        write( " k" );
        for k := 0 until MAX_STIRLING do writeon( i_w := 8, s_w := 0, k );
        write( " n" );
        for n := 0 until MAX_STIRLING do begin
            write( i_w := 2, s_w := 0, n );
            for k := 0 until n do writeon( i_w := 8, s_w := 0, s2( n, k ) );
        end for_n
    end
end.
