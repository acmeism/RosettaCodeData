begin
    procedure printSquare ( integer value x ) ; writeon( i_w := 1, s_w := 0, " ", x * x );
    % applys f to each element of a from lb to ub (inclusive) %
    procedure applyI ( procedure f; integer array a ( * ); integer value lb, ub ) ;
        for i := lb until ub do f( a( i ) );
    % test applyI %
    begin
        integer array a ( 1 :: 3 );
        a( 1 ) := 1; a( 2 ) := 2; a( 3 ) := 3;
        applyI( printSquare, a, 1, 3 )
    end
end.
