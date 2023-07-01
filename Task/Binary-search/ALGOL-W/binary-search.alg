begin % binary search %
    % recursive binary search, left most insertion point %
    integer procedure binarySearchLR ( integer array A ( * )
                                     ; integer value find, Low, high
                                     ) ;
        if high < low then low
        else begin
            integer mid;
            mid := ( low + high ) div 2;
            if A( mid ) >= find then binarySearchLR( A, find, low,     mid - 1 )
            else                     binarySearchLR( A, find, mid + 1, high    )
        end binarySearchR ;
    % iteratve binary search leftmost insertion point %
    integer procedure binarySearchLI ( integer array A ( * )
                                     ; integer value find, lowInit, highInit
                                     ) ;
        begin
            integer low, high;
            low  := lowInit;
            high := highInit;
            while low <= high do begin
                integer mid;
                mid := ( low + high ) div 2;
                if A( mid ) >= find then high := mid - 1
                else                     low  := mid + 1
            end while_low_le_high ;
            low
        end binarySearchLI ;
    % tests %
    begin
        integer array t ( 1 :: 10 );
        integer tPos;
        tPos := 1;
        for tValue := 1, 4, 9, 16, 25, 36, 49, 64, 81, 100 do begin
            t( tPos ) := tValue;
            tPos      := tPOs + 1
        end for_tValue ;
        for s := 0 step 8 until 24 do begin
            integer pos;
            pos := binarySearchLR( t, s, 1, 10 );
            if t( pos ) = s then write( I_W := 3, S_W := 0, "recursive search finds           ", s, " at ", pos )
            else                 write( I_W := 3, S_W := 0, "recursive search suggests insert ", s, " at ", pos )
            ;
            pos := binarySearchLI( t, s, 1, 10 );
            if t( pos ) = s then write( I_W := 3, S_W := 0, "iterative search finds           ", s, " at ", pos )
            else                 write( I_W := 3, S_W := 0, "iterative search suggests insert ", s, " at ", pos )
        end for_s
    end
end.
