% Quicksorts in-place the array of integers v, from lb to ub %
procedure quicksort ( integer array v( * )
                    ; integer value lb, ub
                    ) ;
if ub > lb then begin
    % more than one element, so must sort %
    integer left, right, pivot;
    left   := lb;
    right  := ub;
    % choosing the middle element of the array as the pivot %
    pivot  := v( left + ( ( right + 1 ) - left ) div 2 );
    while begin
        while left  <= ub and v( left  ) < pivot do left  := left  + 1;
        while right >= lb and v( right ) > pivot do right := right - 1;
        left <= right
    end do begin
        integer swap;
        swap       := v( left  );
        v( left  ) := v( right );
        v( right ) := swap;
        left       := left  + 1;
        right      := right - 1
    end while_left_le_right ;
    quicksort( v, lb,   right );
    quicksort( v, left, ub    )
end quicksort ;
