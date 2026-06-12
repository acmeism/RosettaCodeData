begin % find numbers palendromic in bases 2, 4, and 16                             %

    % returns true if n is palendromic in the specified base, false otherwide      %
    logical procedure palendromic( integer value n, base ) ;
    begin
        integer array digit( 1 :: 32 );
        integer dPos, v, lPos, rPos;
        logical isPalendromic;
        dPos := 0;
        v    := n;
        while v > 0 do begin
            dPos          := dPos + 1;
            digit( dPos ) := v rem base;
            v             := v div base
        end while_v_gt_0 ;
        isPalendromic := true;
        lPos          := 1;
        rPos          := dPos;
        while rPos > lPos and isPalendromic do begin
            isPalendromic := digit( lPos ) = digit( rPos );
            lPos          := lPos + 1;
            rPos          := rPos - 1
        end while_rPos_gt_lPos_and_isPalendromic ;
        isPalendromic
    end palendromic ;
    % as noted by the REXX sample, all even numbers end in 0 in base 2             %
    % so 0 is the only possible even number, note 0 is palendromic in all bases    %
    write( " 0" );
    for n := 1 step 2 until 24999 do begin
        if palendromic( n, 16 ) then begin
            if palendromic( n, 4 ) then begin
                if palendromic( n, 2 ) then begin
                    writeon( i_w := 1, s_w := 0, " ", n )
                end if_palendromic__n_2
            end if_palendromic__n_4
        end if_palendromic__n_16
    end for_n
end.
