begin % sum the elements below the main diagonal of a matrix  %
    % returns the sum of the elements below the main diagonal %
    % of m, m must have bounds lb :: ub, lb :: ub             %
    integer procedure lowerSum ( integer array m ( *, * )
                               ; integer value lb, ub
                               ) ;
    begin
        integer sum;
        sum := 0;
        for r := lb + 1 until ub do begin
             for c := lb until r - 1 do sum := sum + m( r, c )
        end for_r;
        sum
    end lowerSum ;
    begin % task test case                                    %
        integer array m ( 1 :: 5, 1 :: 5 );
        integer r, c;
        r := 1; c := 0; for v :=  1,  3,  7,  8, 10 do begin c := c + 1; m( r, c ) := v end;
        r := 2; c := 0; for v :=  2,  4, 16, 14,  4 do begin c := c + 1; m( r, c ) := v end;
        r := 3; c := 0; for v :=  3,  1,  9, 18, 11 do begin c := c + 1; m( r, c ) := v end;
        r := 4; c := 0; for v := 12, 14, 17, 18, 20 do begin c := c + 1; m( r, c ) := v end;
        r := 5; c := 0; for v :=  7,  1,  3,  9,  5 do begin c := c + 1; m( r, c ) := v end;
        write( i_w := 1, lowerSum( m, 1, 5 ) )
    end
end.
