begin % find numbers where the digit 1 occurs twice, up to 999 %
    integer double1Count;
    integer array double1 ( 1 :: 100 ); % assume there will be at most 100 numbers %
    % Quicksorts in-place the array of integers v, from lb to ub - external %
    procedure quicksort ( integer array v( * )
                        ; integer value lb, ub
                        ) ; algol "sortingAlgorithms_Quicksort" ;
    % increments n by 1 and returns its new value %
    integer procedure inc ( integer value result n ) ; begin n := n + 1; n end inc ;
    % generate the numbers %
    double1Count := 0;
    for i := 0 until 9 do begin
        if i not = 1 then begin
            double1( inc( double1Count ) ) := 110 + i;
            double1( inc( double1Count ) ) := 101 + ( i * 10 );
            double1( inc( double1Count ) ) := ( i * 100 ) + 11
        end if_i_ne_1
    end for_i ;
    % sort the numbers %
    quickSort( double1, 1, double1Count );
    % print the numbers %
    for i := 1 until double1Count do writeon( i_w := 1, s_w := 1, double1( i ) );
    write();
    write( i_w := 1, s_w := 0, "Found ", double1Count, " numbers" )
end.
