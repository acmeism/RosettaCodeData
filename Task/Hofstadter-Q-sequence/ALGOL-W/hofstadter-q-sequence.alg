begin % find elements of the Hofstader Q sequence Q(1) = Q(2) = 1             %
      % Q(n) = Q( n - Q( n - 1 ) ) + Q( n - Q( n - 2 ) ) for n > 2            %
    integer MAX_Q;
    max_Q := 100000;
    begin
        integer array Q ( 1 :: MAX_Q );
        integer array xQ ( 1 :: 10 );
        integer ltCount;
        logical valuesOk;
        % expected values of the first 10 elements                            %
        xQ( 1 ) := xQ( 2 ) := 1;
        xQ( 3 ) := 2; xQ( 4 ) := xQ( 5 ) := 3; xQ( 6 ) := 4;
        xQ( 7 ) := xQ( 8 ) := 5; xQ( 9 ) := xQ( 10 ) := 6;
        % calculate the sequence and count how often Q( n ) < Q( n - 1 )      %
        ltCount := 0;
        Q( 1 ) := Q( 2 ) := 1;
        for n := 3 until MAX_Q do begin
            Q( n ) := Q( n - Q( n - 1 ) ) + Q( n - Q( n - 2 ) );
            if Q( n ) < Q( n - 1 ) then ltCount := ltCount + 1
        end for_n ;
        valuesOk := true;
        write( "The first 10 terms of the Hofstader Q sequence:" );
        for i := 1 until 10 do begin
            writeon( i_w := 1, s_w := 0, " ", Q( i ) );
            if Q( i ) not = xQ( i ) then begin
                writeon( i_w := 1, s_w := 0, "-EXPECTED-", xQ( i ) );
                valuesOk := false
            end if_Q_i_ne_xQ_i
        end for_i ;
        write( i_w := 1, s_w := 0, "The 1000th term is: ", Q( 1000 ) );
        if Q( 1000 ) not = 502 then begin
            writeon( "-EXPECTED-502" );
            valuesOk := false
        end if_Q_100_ne_502 ;
        if valuesOk then write( "    (Computed values are as expected)" )
                    else write( "Values NOT as expected" );
        write( i_w := 1, s_w := 0, "Q(n) < Q(n-1) ", ltCount," times for n up to ", MAX_Q )
    end
end.
