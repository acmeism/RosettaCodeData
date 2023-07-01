begin % comb sort %
    % comb-sorts in-place the array of integers input with bounds lb :: ub %
    procedure combSort ( integer array input ( * )
                       ; integer value lb, ub
                       ) ;
    begin
        integer inputSize, gap, i;
        inputSize := ( ub - lb ) + 1;
        if inputSize > 1 then begin
            % more than one element, so must sort %
            logical swapped;
            gap     := inputSize; % initial gap is the whole array size %
            swapped := true;
            while gap not = 1 or swapped do begin
                % update the gap value for a next comb %
                gap := entier( gap / 1.25 );
                if gap < 1 then begin
                    % ensure the gap is at least 1 %
                    gap := 1
                end if_gap_lt_1 ;
                swapped := false;
                % a single "comb" over the input list %
                i := lb;
                while i + gap <= ub do begin
                    integer t, iGap;
                    t    := input( i );
                    iGap := i + gap;
                    if t > input( iGap ) then begin
                        % need to swap out-of-order items %
                        input( i    ) := input( iGap );
                        input( iGap ) := t;
                        swapped := true % Flag a swap has occurred, so the list is not guaranteed sorted yet %
                    end if_t_gt_input__iGap ;
                    i := i + 1
                end while_i_plus_gap_le_ub
            end while_gap_ne_1_or_swapped
        end if_inputSize_gt_1
    end combSort ;
    begin % test %
        integer array data ( 1 :: 7 );
        integer       dPos;
        dPos := 0;
        for v := 9, -4, 0, 2, 3, 77, 1 do begin dPos := dPos + 1; data( dPos ) := v end;
        for i := 1 until 7 do writeon( i_w := 1, s_w := 0, " ", data( i ) );
        combSort( data, 1, 7 );
        writeon( ( " -> " ) );
        for i := 1 until 7 do writeon( i_w := 1, s_w := 0, " ", data( i ) )
    end
end.
