begin
    % As algol W does not allow overloading, we have to have type-specific   %
    % sorting procedures - this coctail sorts an integer array               %
    % as there is no way for the procedure to determine the array bounds, we %
    % pass the lower and upper bounds in lb and ub                           %
    procedure coctailSortIntegers( integer array item( * )
                                 ; integer value lb
                                 ; integer value ub
                                 ) ;
    begin
        integer lower, upper;

        lower := lb;
        upper := ub - 1;

        while
            begin
                logical swapped;

                procedure swap( integer value i ) ;
                begin
                    integer val;
                    val           := item( i );
                    item( i )     := item( i + 1 );
                    item( i + 1 ) := val;
                    swapped       := true;
                end swap ;

                swapped := false;
                for i := lower until upper do if item( i ) > item( i + 1 ) then swap( i );
                if swapped
                then begin
                    % there was at least one unordered element so try a 2nd sort pass %
                    for i := upper step -1 until lower do if item( i ) > item( i + 1 ) then swap( i );
                    upper := upper - 1; lower := lower + 1;
                end if_swapped ;
                swapped
            end
        do  begin end;
    end coctailSortIntegers ;

    begin % test the sort                                                    %
        integer array data( 1 :: 10 );

        procedure writeData ;
        begin
            write( data( 1 ) );
            for i := 2 until 10 do writeon( data( i ) );
        end writeData ;

        % initialise data to unsorted values                                 %
        integer dPos;
        dPos  := 1;
        for i := 16, 2, -6, 9, 90, 14, 0, 23, 8, 9
        do begin
            data( dPos ) := i;
            dPos         := dPos + 1;
        end for_i ;

        i_w := 3; s_w := 1; % set output format %
        writeData;
        coctailSortIntegers( data, 1, 10 );
        writeData;
    end test ;
end.
