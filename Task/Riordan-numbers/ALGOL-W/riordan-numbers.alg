begin % -- find some Riordan numbers                                          %
    % -- sets a to the Riordan numbers 0 .. n - a must have bounds 0 :: n     %
    procedure riordan ( integer value n; integer array a ( * ) ) ;
        if n >= 0 then begin
            a( 0 ) := 1;
            if n >= 1 then begin
                a( 1 ) := 0;
                for i := 2 until n do begin
                    a( i ) := ( ( i - 1 )
                              * ( ( 2 * a( i - 1 ) )
                                + ( 3 * a( i - 2 ) )
                                )
                              )
                          div ( i + 1 )
                end for_i
            end if_n_ge_1
        end riordan ;
    begin % -- show some Riordann numbers                                     %
        integer array r ( 0 :: 21 );
        integer shown;
        riordan( 21, r );
        shown := 0;
        for i := 0 until 21 do begin
            writeon( i_w := 9, s_w := 0, " ", r( i ) );
            shown := shown + 1;
            if shown = 4 then begin
                write();
                shown := 0
            end if_shown_eq_4
        end for_i
    end;
end.
