begin % find numbers that use the same digits in decimal and hexadecimal      %
    integer hdCount;
    integer x2, x3, x4, x5, hx2, hx3, hx4, hx5;
    hdCount := 0;
    % note 100 000 is 186A0 in hexadecimal, so we need to consider numbers    %
    % with up to 5 hexadedcimal digits                                        %
    % powers of 16 %
    x2 := 16; x3 := x2 * 16; x4 := x3 * 16; x5 := x4 * 16;
    % construct the numbers that have only 0-9 in their hex representations   %
    hx5 := 0;
    for h5 := 0 until 1 do begin
        hx4 := 0;
        for h4 := 0 until 9 do begin
            hx3 := 0;
            for h3 := 0 until 9 do begin
                hx2 := 0;
                for h2 := 0 until 9 do begin
                    for h1 := 0 until 9 do begin
                        integer n, d;
                        bits hSet, dSet;
                        n := d := hx5 + hx4 + hx3 + hx2 + h1;
                        if n > 100000 then goto endSearch;
                        d    := n;
                        dSet := if d = 0 then #1 else #0;
                        while d > 0 do begin
                            dSet := dSet or ( #1 shl ( d rem 10 ) );
                            d    := d div 10
                        end;
                        hSet := #0;
                        if 0 not = h5                then hset := hset or ( #1 shl h5 );
                        if 0 not = h5 + h4           then hset := hset or ( #1 shl h4 );
                        if 0 not = h5 + h4 + h3      then hset := hset or ( #1 shl h3 );
                        if 0 not = h5 + h4 + h3 + h2 then hset := hset or ( #1 shl h2 );
                        hset := hset or ( #1 shl h1 );
                        if dset = hset then begin
                            % the decimal and hexadecimal representations     %
                            % use the same digits                             %
                            writeon( i_w := 7, s_w := 0, " ", n );
                            hdCount := hdCount + 1;
                            if hdCount rem 10 = 0 then write()
                        end if_allSame ;
                    end for_h1 ;
                    hx2 := hx2 + x2
                end for_h2 ;
                hx3 := hx3 + x3
            end for_h3 ;
            hx4 := hx4 + x4
        end for_h4 ;
        hx5 := hx5 + x5
    end for_h5 ;
endSearch:
    write( i_w := 1, s_w := 0, "Found ", hdCount, " numbers up to 100000 " );
    writeon( "where the decimal and hexadecimal representations use the same digits" )
end.
