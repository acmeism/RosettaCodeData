begin % show some Bell numbers %
    integer MAX_BELL;
    MAX_BELL := 15;
    begin
        procedure showBell ( integer value n, bellNumber ) ;
            write( i_w := 2, s_w := 0, n, ": ", i_w := 1, bellNumber );
        integer array a ( 0 :: MAX_BELL - 2 );
        for i := 1 until MAX_BELL - 2 do a( i ) := 0;
        a( 0 ) := 1;
        showBell( 1, a( 0 ) );
        for n := 0 until MAX_BELL - 2 do begin
            % replace a with the next line of the triangle %
            a( n ) := a( 0 );
            for j := n step -1 until 1 do a( j - 1 ) := a( j - 1 ) + a( j );
            showBell( n + 2, a( 0 ) )
        end for_n
    end
end.
