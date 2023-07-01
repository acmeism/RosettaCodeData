begin % cocktail sort with shifting bounds                                   %

    % sorts in-place a using a cocktail sort with shifting bounds            %
    % the bounds of a must be specified in lb and ub                         %
    procedure cocktailSortWithShiftingBounds ( integer array a ( * )
                                             ; integer value lb, ub
                                             );
    begin
        % `beginIdx` and `endIdx` marks the first and last index to check. %
        integer beginIdx, endIdx;
        beginIdx := lb;
        endIdx   := ub - 1;

        while beginIdx <= endIdx do begin
            integer newBeginIdx, newEndIdx;
            newBeginIdx := endIdx;
            newEndIdx   := beginIdx;
            for ii := beginIdx until endIdx do begin
                integer aii;
                if a( ii ) > a( ii + 1 ) then begin
                    integer aii;
                    aii         := a( ii     );
                    a( ii     ) := a( ii + 1 );
                    a( ii + 1 ) := aii;
                    newEndIdx := ii
                end
            end for_ii ;

            % decreases `endIdx` because the elements after `newEndIdx` are in correct order %
            endIdx := newEndIdx - 1;

            for ii := endIdx step -1 until beginIdx do begin
                if a( ii ) > a( ii + 1 ) then begin
                    integer aii;
                    aii         := a( ii     );
                    a( ii     ) := a( ii + 1 );
                    a( ii + 1 ) := aii;
                    newBeginIdx := ii
                end
            end for_ii ;

            % increases `beginIdx` because the elements before `newBeginIdx` are in correct order. %
            beginIdx := newBeginIdx + 1

        end while_beginIdx_le_endIdx

    end coctailSortWithShiftingBounds ;

    % test the cocktailSortWithShiftingBounds procedure                      %
    begin

        integer procedure inc ( integer value result i ) ;
        begin
            i := i + 1;
            i
        end inc ;

        procedure testCocktailSortWithShiftingBounds( integer array data ( * )
                                                    ; integer value lb, ub
                                                    );
        begin
            i_w := 1; s_w := 0; % set formatting                             %
            write( "[" );
            for i := lb until ub do writeon( " ", data( i ) );
            writeon( " ]" );
            cocktailSortWithShiftingBounds( data, lb, ub );
            write( "    -> [" );
            for i := lb until ub do writeon( " ", data( i ) );
            writeon( " ]" )
        end testCocktailSortWithShiftingBounds ;

        integer array t ( 1 :: 32 );
        integer tPos;

        % test cases from the Action! sample                                 %
        tPos := 0;
        for d := 1, 4, -1, 0, 3, 7, 4, 8, 20, -6 do t( inc( tPos ) ) := d;
        testCocktailSortWithShiftingBounds( t, 1, tPos );
        tPos := 0;
        for d := 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
               , -1, -2, -3, -4, -5, -6, -7, -8, -9, -10
              do t( inc( tPos ) ) := d;
        testCocktailSortWithShiftingBounds( t, 1, tPos );
        tPos := 0;
        for d := 101, 102, 103, 104, 105, 106, 107, 108 do t( inc( tPos ) ) := d;
        testCocktailSortWithShiftingBounds( t, 1, tPos );
        tPos := 0;
        for d :=  1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1 do t( inc( tPos ) ) := d;
        testCocktailSortWithShiftingBounds( t, 1, tPos );
        % additional test cases                                              %
        tPos := 0;
        for d :=  1, 1, 1, 1, 1, 1 do t( inc( tPos ) ) := d;
        testCocktailSortWithShiftingBounds( t, 1, tPos );
        tPos := 0;
        for d := 0 do t( inc( tPos ) ) := d;
        testCocktailSortWithShiftingBounds( t, 1, tPos );
        tPos := 0;
        testCocktailSortWithShiftingBounds( t, 1, tPos );
    end
end.
