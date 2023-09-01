begin % show numbers and their prime factors                                 %
    % shows nand its prime factors                                           %
    procedure showFactors ( integer value n ) ;
        if n <= 3 then write( i_w := 1, s_w := 0, n, ": ", n )
        else begin
            integer v, f; logical first;
            first := true;
            v     := n;
            write( i_w := 1, s_w := 0, n, ": " );
            while not odd( v ) and v > 1 do begin
                if not first then writeon( s_w := 0, " x " );
                writeon( i_w := 1, s_w := 0, 2 );
                v     := v div 2;
                first := false
            end while_not_odd_v ;
            f := 1;
            while v > 1 do begin
                f := f + 2;
                while v rem f = 0 do begin
                    if not first then writeon( s_w := 0, " x " );
                    writeon( i_w := 1, s_w := 0, f );
                    v         := v div f;
                    first := false
                end while_v_rem_f_eq_0
            end while_v_gt_0_and_f_le_v
        end showFactors ;

    % show the factors of various ranges - same as Wren                      %
    for i :=    1 until    9 do showFactors( i );
    write( "... " );
    for i := 2144 until 2154 do showFactors( i );
    write( "... " );
    for i := 9987 until 9999 do showFactors( i )
end.
