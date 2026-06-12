begin % cycle sort                                                                  %

    % cycle sorts a, the bounds of a must be specified in lb and ub                 %
    integer procedure cycleSort ( integer array a ( * ); integer value lb, ub ) ;
    begin
        % swaps a and b                                                             %
        procedure swap ( integer value result a, b ) ;
        begin integer t;
            t := a; a := b; b := t;
            swaps := swaps + 1
        end swap ;
        integer swaps, cycleStart, cycleEnd, val, pos;
        swaps      := 0;
        cycleStart := lb - 1;
        while cycleStart < ub do begin
            val := a( cycleStart + 1 );
            % count the number of values that are smaller than val since cycleStart %
            pos := cycleStart;
            for i := cycleStart + 1 until ub - 1 do begin
                if a( i + 1 ) < val then pos := pos + 1
            end for_i ;
            if pos not = cycleStart then begin                       % there aren't any %
                while val = a( pos + 1 ) do pos := pos + 1;
                swap( a( pos + 1 ), val );                 %  put val in final position %
                % repeat as long as we can find values to swap                      %
                % otherwise start new cycle                                         %
                while pos not = cycleStart do begin
                    pos := cycleStart;
                    for i := cycleStart + 1 until ub- 1 do begin
                        if a( i + 1 ) < val then pos := pos + 1;
                    end for_i ;
                    while val = a( pos + 1 ) do pos := pos + 1;
                    swap( a( pos + 1 ), val );
                end while_pos_ne_cycleStart
            end if_pos_ne_cycleStart ;
            cycleStart := cycleStart + 1
        end while_cycleStart_lt_ub ;
        swaps
    end cycleSort ;

    % prints the elements of a from lb to ub                                        %
    procedure writeonArray( integer array a ( * ); integer value lb, ub ) ;
    begin
        writeon( "(" );
        for i := lb until ub do writeon( i_w := 1, s_w := 0, " ", a( i ) );
        writeon( " )" )
    end writeonArray ;

    begin % tests                                                                   %
        integer array arr ( 1 :: 16 );
        integer aPos, swaps;
        aPos := 1;
        for v := 5, 0, 1, 2, 2, 3, 5, 1, 1, 0, 5, 6, 9, 8, 0, 1 do begin
            arr( aPos ) := v;
            aPos        := aPos + 1
        end for_v ;
        writeonArray(       arr, 1, 16 );
        writeon( " -> " );
        swaps := cycleSort( arr, 1, 16 );
        writeonArray(       arr, 1, 16 );
        write( i_w := 1, s_w := 0, "swaps: ", swaps )
    end
end.
