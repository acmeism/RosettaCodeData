begin
    % external in-place insertion sort procedure %
    procedure insertionSortI ( integer array A( * ); integer value lb, ub ) ;
        algol "ISORTI" ;

    integer array d ( 1 :: 8 );
    integer p;
    p := 1;
    for i := 34, 2, -1, 0, 0, 9, -56, 3 do begin
        d( p ) := i;
        p := p + 1
    end for_i ;
    insertionSortI( d, 1, 8 );
    write( i_w := 1, d( 1 ) );
    for i := 2 until 8 do writeon( i_w := 1, d( i ) )
end.
