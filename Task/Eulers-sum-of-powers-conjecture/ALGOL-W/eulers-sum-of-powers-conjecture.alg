begin
    % find a, b, c, d, e such that a^5 + b^5 + c^5 + d^5 = e^5                              %
    %                        where 1 <= a <= b <= c <= d <= e <= 250                        %
    % we solve this using the equivalent equation a^5 + b^5 + c^5 = e^5 - d^5               %
    % 250^5 is 976 562 500 000 - too large for a 32 bit number so we will use pairs of      %
    % integers and constrain their values to be in 0..1 000 000                             %
    % Note only positive numbers are needed                                                 %
    integer MAX_NUMBER, MAX_V;
    MAX_NUMBER := 250;
    MAX_V      := 1000000;
    begin
        % quick sorts the fifth power differences table                                     %
        procedure quickSort5 ( integer value lb, ub ) ;
            if ub > lb then begin
                % more than one element, so must sort                                       %
                integer left, right, pivot, pivotLo, pivotHi;
                left    := lb;
                right   := ub;
                % choosing the middle element of the array as the pivot %
                pivot   := left + ( ( ( right + 1 ) - left ) div 2 );
                pivotLo := loD( pivot );
                pivotHi := hiD( pivot );
                while begin
                    while left  <= ub
                      and begin integer cmp;
                                cmp := hiD( left ) - pivotHi;
                                if cmp = 0 then cmp := loD( left ) - pivotLo;
                                cmp < 0
                          end
                    do left := left + 1;
                    while right >= lb
                      and begin integer cmp;
                                cmp := hiD( right ) - pivotHi;
                                if cmp = 0 then cmp := loD( right ) - pivotLo;
                                cmp > 0
                          end
                    do right := right - 1;
                    left <= right
                end do begin
                    integer swapLo, swapHi, swapD, swapE;
                    swapLo       := loD( left  );
                    swapHi       := hiD( left  );
                    swapD        := Dd(  left  );
                    swapE        := De(  left  );
                    loD( left  ) := loD( right );
                    hiD( left  ) := hiD( right );
                    Dd(  left  ) := Dd(  right );
                    De(  left  ) := De(  right );
                    loD( right ) := swapLo;
                    hiD( right ) := swapHi;
                    Dd(  right ) := swapD;
                    De(  right ) := swapE;
                    left         := left  + 1;
                    right        := right - 1
                end while_left_le_right ;
                quickSort5( lb,   right );
                quickSort5( left, ub    )
            end quickSort5 ;
        % table of fifth powers                                                             %
        integer array lo5, hi5         ( 1 :: MAX_NUMBER );
        % table if differences between fifth powers                                         %
        integer array loD, hiD, De, Dd ( 1 :: MAX_NUMBER * MAX_NUMBER );
        integer dUsed, dPos;
        % compute fifth powers                                                              %
        for i := 1 until MAX_NUMBER do begin
            lo5( i ) := i * i; hi5( i ) := 0;
            for p := 3 until 5 do begin
                integer carry;
                lo5( i ) := lo5( i ) * i;
                carry    := lo5( i ) div MAX_V;
                lo5( i ) := lo5( i ) rem MAX_V;
                hi5( i ) := hi5( i ) * i;
                hi5( i ) := hi5( i ) + carry
            end for_p
        end for_i ;
        % compute the differences between fifth powers e^5 - d^5, 1 <= d < e <= MAX_NUMBER  %
        dUsed := 0;
        for e := 2 until MAX_NUMBER do begin
            for d := 1 until e - 1  do begin
                dUsed := dUsed + 1;
                De(  dUsed ) := e;
                Dd(  dUsed ) := d;
                loD( dUsed ) := lo5( e ) - lo5( d );
                hiD( dUsed ) := hi5( e ) - hi5( d );
                if loD( dUsed ) < 0 then begin
                    loD( dUsed ) := loD( dUsed ) + MAX_V;
                    hiD( dUsed ) := hiD( dUsed ) - 1
                end if_need_to_borrow
            end for_d
        end for_e;
        % sort the fifth power differences                                                  %
        quickSort5( 1, dUsed );
        % attempt to find a^5 + b^5 + c^5 = e^5 - d^5                                       %
        for a := 1 until MAX_NUMBER do begin
            integer loA, hiA;
            loA := lo5( a ); hiA := hi5( a );
            for b := a until MAX_NUMBER do begin
                integer loB, hiB;
                loB := lo5( b ); hiB := hi5( b );
                for c := b until MAX_NUMBER do begin
                    integer low, high, loSum, hiSum;
                    loSum :=                       loA + loB + lo5( c );
                    hiSum := ( loSum div MAX_V ) + hiA + hiB + hi5( c );
                    loSum :=   loSum rem MAX_V;
                    % look for hiSum,loSum in hiD,loD                                       %
                    low   := 1;
                    high  := dUsed;
                    while low < high do begin
                        integer mid, cmp;
                        mid := ( low + high ) div 2;
                        cmp := hiD( mid ) - hiSum;
                        if cmp = 0 then cmp := loD( mid ) - loSum;
                        if cmp = 0 then begin
                            % the value at mid is the difference of two fifth powers        %
                            write( i_w := 1, s_w := 0
                                 , a, "^5 + ", b, "^5 + ", c, "^5 + "
                                 , Dd( mid ), "^5 = ", De( mid ), "^5"
                                 );
                            go to found
                            end
                        else if cmp > 0 then high := mid - 1
                        else                 low  := mid + 1
                    end while_low_lt_high
                end for_c
            end for_b
        end for_a ;
found :
    end
end.
