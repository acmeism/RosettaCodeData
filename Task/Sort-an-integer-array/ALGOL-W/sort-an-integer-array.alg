begin
    % use the quicksort procedure from the Sorting_Algorithms/Quicksort task %
    % Quicksorts in-place the array of integers v, from lb to ub - external  %
    procedure quicksort ( integer array v( * )
                        ; integer value lb, ub
                        ) ; algol "sortingAlgorithms_Quicksort" ;
    % sort an integer array with the quicksort routine                       %
    begin
        integer array t ( 1 :: 5 );
        integer p;
        p := 1;
        for v := 2, 3, 1, 9, -2 do begin t( p ) := v; p := p + 1; end;
        quicksort( t, 1, 5 );
        for i := 1 until 5 do writeon( i_w := 1, s_w := 1, t( i ) )
    end
end.
