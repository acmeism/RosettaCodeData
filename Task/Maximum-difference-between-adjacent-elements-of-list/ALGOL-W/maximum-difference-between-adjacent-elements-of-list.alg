begin % find the maximum difference between consecutive list elements         %
    % returns the maximum difference between pairs of elements of list        %
    %         the lower and upper bounds of list must be specified in lb & ub %
    real procedure maxDelta ( real    array list ( * )
                            ; integer value lb, ub
                            ) ;
    begin
        real maxDiff;
        maxDiff := 0;
        for i := lb until ub - 1 do begin
            real delta;
            delta := abs ( list( i ) - list( i + 1 ) );
            if delta > maxDiff then maxDiff := delta % found a higher difference %
        end for_i;
        maxDiff
    end maxDelta;
    % test the maxDelta procedure                                             %
    procedure testMaxDelta ( real    array list ( * )
                           ; integer value lb, ub, rw, dp
                           ) ;
    begin
        real maxDiff;
        maxDiff := maxDelta( list, lb, ub );
        write( s_w := 0, "Max difference [" );
        for i := lb until ub do begin
            writeon( r_format := "A", r_w := rw, r_d := dp, s_w := 0, " ", list( i ) );
        end for_i;
        writeon( r_format := "A", r_w := rw, r_d := dp, s_w := 0, " ] is ", maxDiff, ":" );
        for i := lb until ub - 1 do begin
            real diff;
            diff := abs ( list( i ) - list( i + 1 ) );
            if diff = maxDiff then begin
                write( r_format := "A", r_w := rw, r_d := dp, s_w := 0, "    ", list( i ), ", ", list( i + 1 ), " ==> ", diff );
            end if_diff_eq_maxDiff
         end for_i
    end testMaxDelta;
    begin % task test case                                                    %
        integer tPos;
        real array tc( 1 :: 17 );
        tPos := 0;
        for i := 1, 8, 2, -3, 0, 1, 1, -23, 0, 55, 8, 6, 2, 9, 11, 10, 3 do begin
            tPos       := tPos + 1;
            tc( tPos ) := i
        end for_i;
        tc( 8 ) := -2.3; tc( 10 ) := 5.5;
        testMaxDelta( tc, 1, 17, 4, 1 )
    end;
    begin % additional test cases                                             %
        integer tPos;
        real array tc( 1 :: 3 );
        tc( 1 ) := -1.1; tc( 2 ) := -1.2; testMaxDelta( tc, 1, 2, 4, 1  );
        for i := 1 until 3 do tc( i ) := pi;
        testMaxDelta( tc, 1, 3, 6, 4 );
        testMaxDelta( tc, 1, 0, 3, 1 );
        tc( 1 ) := 776.591;
        testMaxDelta( tc, 1, 1, 6, 3 )
    end
end.
