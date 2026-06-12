% show numbers that when represented in hex, have at least one a-f digit %
begin
    integer hCount;
    hCount := 0;
    for i := 1 until 500 do begin
        integer v;
        v := i;
        while v > 0 do begin
            if ( v rem 16 ) < 10
            then v := v div 16
            else begin
                % found a number that needs a-f in its hex representation %
                v := 0;
                hCOunt := hCOunt + 1;
                writeon( i_w := 3, s_w := 0, " ", i );
                if hCount rem 20 = 0 then write()
            end if_hexDigit_lt_10__
        end while_v_gt_0
    end for_i
end.
