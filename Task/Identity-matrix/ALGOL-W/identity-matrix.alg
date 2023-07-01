begin
    % set m to an identity matrix of size s                                  %
    procedure makeIdentity( real    array m ( *, * )
                          ; integer value s
                          ) ;
        for i := 1 until s do begin
            for j := 1 until s do m( i, j ) := 0.0;
            m( i, i ) := 1.0
        end makeIdentity ;

    % test the makeIdentity procedure                                        %
    begin
        real array id5( 1 :: 5, 1 :: 5 );
        makeIdentity( id5, 5 );
        r_format := "A"; r_w := 6; r_d := 1; % set output format for reals   %
        for i := 1 until 5 do begin
            write();
            for j := 1 until 5 do writeon( id5( i, j ) )
        end for_i ;
    end text

end.
