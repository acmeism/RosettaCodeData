begin % sort a disjoint sub-set of a list                         %
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
    % Quicksorts in-place the array of integers v, using          %
    % the indxexes in unsortedIndexes which has bounds lb to ub   %
    % it is assumed all elements of unsortedIndexes are in the    %
    % range for subscripts of v                                   %
    procedure indexedQuicksort ( integer array v, unsortedIndexes ( * )
                               ; integer value lb, ub
                               ) ;
    if ub > lb then begin
        % more than one element, so must sort %
        integer array indexes ( lb :: ub );
        integer left, right, pivot, p;
        % sort the indexes %
        for i := lb until ub do indexes( i ) := unsortedIndexes( i );
        quicksort( indexes, lb, ub );
        % sort the indexed items of the v array %
        left   := lb;
        right  := ub;
        % choosing the middle element of the array as the pivot %
        p      := left + ( ( ( right + 1 ) - left ) div 2 );
        pivot  := v( indexes( p ) );
        while begin
            while left  <= ub and v( indexes( left  ) ) < pivot do left  := left  + 1;
            while right >= lb and v( indexes( right ) ) > pivot do right := right - 1;
            left <= right
        end do begin
            integer swap;
            swap                  := v( indexes( left  ) );
            v( indexes( left  ) ) := v( indexes( right ) );
            v( indexes( right ) ) := swap;
            left                  := left  + 1;
            right                 := right - 1
        end while_left_le_right ;
        indexedQuicksort( v, indexes, lb,   right );
        indexedQuicksort( v, indexes, left, ub    )
    end indexedQuicksort ;
    begin % task %
        integer array indexes ( 0 :: 2 );
        integer array values  ( 0 :: 7 );
        integer aPos;
        aPos := 0;
        for v := 7, 6, 5, 4, 3, 2, 1, 0 do begin
            values( aPos ) := v;
            aPos           := aPos + 1
        end for_v ;
        indexes( 0 ) := 6;
        indexes( 1 ) := 1;
        indexes( 2 ) := 7;
        i_w := 1; s_w := 0; % set output formatting %
        write( "[" );
        for v := 0 until 7 do writeon( " ", values( v ) );
        writeon( " ]" );
        indexedQuicksort( values, indexes, 0, 2 );
        writeon( " -> [" );
        for v := 0 until 7 do writeon( " ", values( v ) );
        writeon( " ]" )
    end
end.
