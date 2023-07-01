begin
    % As algol W does not allow overloading, we have to have type-specific   %
    % sorting procedures - this bubble sorts an integer array                %
    % as there is no way for the procedure to determine the array bounds, we %
    % pass the lower and upper bounds in lb and ub                           %
    procedure bubbleSortIntegers( integer array item( * )
                                ; integer value lb
                                ; integer value ub
                                ) ;
    begin
        integer lower, upper;

        lower := lb;
        upper := ub;

        while
            begin
                logical swapped;
                upper   := upper - 1;
                swapped := false;
                for i := lower until upper
                do begin
                    if item( i ) > item( i + 1 )
                    then begin
                        integer val;
                        val           := item( i );
                        item( i )     := item( i + 1 );
                        item( i + 1 ) := val;
                        swapped       := true;
                    end if_must_swap ;
                end for_i ;
                swapped
            end
        do  begin end;
    end bubbleSortIntegers ;

    begin % test the bubble sort                                             %
        integer array data( 1 :: 10 );

        procedure writeData ;
        begin
            write( data( 1 ) );
            for i := 2 until 10 do writeon( data( i ) );
        end writeData ;

        % initialise data to unsorted values                                 %
        integer       dPos;
        dPos  := 1;
        for i := 16, 2, -6, 9, 90, 14, 0, 23, 8, 9
        do begin
            data( dPos ) := i;
            dPos         := dPos + 1;
        end for_i ;

        i_w := 3; s_w := 1; % set output format %
        writeData;
        bubbleSortIntegers( data, 1, 10 );
        writeData;
    end test
end.
