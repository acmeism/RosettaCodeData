begin
    % find some happy numbers                                      %
    % returns true if n is happy, false otherwise; n must be >= 0  %
    logical procedure isHappy( integer value n ) ;
        if n < 2 then true
        else begin
            % seen is used to hold the values of the cycle of the  %
            % digit square sums, as noted in the Batch File        %
            % version, we do not need a large array. The digit     %
            % square sum of 9 999 999 999 is 810...                %
            integer array seen( 0 :: 32 );
            integer number, trys;
            number             := n;
            trys               := -1;
            while begin
                logical terminated;
                integer tPos;
                terminated     := false;
                tPos           := 0;
                while not terminated and tPos <= trys do begin
                    terminated := seen( tPos ) = number;
                    tPos       := tPos + 1
                end while_not_terminated_and_tPos_lt_trys ;
                number > 1 and not terminated
            end do begin
                integer sum;
                trys           := trys + 1;
                seen( trys )   := number;
                sum            := 0;
                while number > 0 do begin
                    integer digit;
                    digit      := number rem 10;
                    number     := number div 10;
                    sum        := sum + ( digit * digit )
                end while_number_gt_0 ;
                number         := sum
            end while_number_gt_1_and_not_terminated ;
            number = 1
        end isHappy ;
    % print the first 8 happy numbers                               %
    begin
        integer       happyCount, n;
        happyCount := 0;
        n          := 1;
        write( "first 8 happy numbers: " );
        while happyCount < 8 do begin
            if isHappy( n ) then begin
                writeon( i_w := 1, " ", n );
                happyCount := happyCount + 1
            end if_isHappy_n ;
            n := n + 1
        end while_happyCount_lt_8
    end
end.
