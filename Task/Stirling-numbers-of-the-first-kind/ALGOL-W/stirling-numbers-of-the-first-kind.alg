begin % show some (unsigned) Stirling numbers of the first kind              %
    integer MAX_STIRLING;
    MAX_STIRLING := 12;
    begin
        % construct a matrix of Stirling numbers up to max n, max n           %
        integer array s1 ( 0 :: MAX_STIRLING, 0 :: MAX_STIRLING );
        for n := 0 until MAX_STIRLING do begin
            for k := 0 until MAX_STIRLING do s1( n, k ) := 0
        end for_n ;
        s1( 0, 0 ) := 1;
        for n := 1 until MAX_STIRLING do s1( n, 0 ) := 0;
        for n := 1 until MAX_STIRLING do begin
            for k := 1 until n do begin
                integer s1Term;
                s1Term := ( ( n - 1 ) * s1( n - 1, k ) );
                s1( n, k ) := s1( n - 1, k - 1 ) + s1Term
            end for_k
        end for_n ;
        % print the Stirling numbers up to n, k = 12                          %
        write( "Unsigned Stirling numbers of the first kind:" );
        write( " k" );
        for k := 0 until MAX_STIRLING do writeon( i_w := 10, s_w := 0, k );
        write( " n" );
        for n := 0 until MAX_STIRLING do begin
            write( i_w := 2, s_w := 0, n );
            for k := 0 until n do begin
                writeon( i_w := 10, s_w := 0, s1( n, k ) )
            end for_k
        end for_n
    end
end.
