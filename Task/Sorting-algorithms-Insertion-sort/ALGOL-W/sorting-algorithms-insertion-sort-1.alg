% insertion sorts in-place the array A. As Algol W procedures can't find the bounds %
% of an array parameter, the lower and upper bounds must be specified in lb and ub  %
procedure insertionSortI ( integer array A ( * ); integer value lb, ub ) ;
    for i := lb + 1 until ub do begin
        integer v, j;
        v := A( i );
        j := i - 1;
        while j >= lb and A( j ) > v do begin
            A( j + 1 ) := A( j );
            j := j - 1
        end while_j_ge_0_and_Aj_gt_v ;
        A( j + 1 ) := v
    end insertionSortI ;
