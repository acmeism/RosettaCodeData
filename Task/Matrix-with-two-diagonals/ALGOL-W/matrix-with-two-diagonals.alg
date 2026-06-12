begin % draw a matrix with 1s on the diagonals and 0s elsewhere         %
    % draws a matrix with height and width = n with 1s on the diagonals %
    procedure draw2Diagonals ( integer value n ) ;
    begin
        integer lPos, rPos;
        lPos := 1;
        rPos := n;
        for i := 1 until n do begin
            for j := 1 until n do writeon( s_w := 0, if j = lPos or j = rPos then " 1" else " 0" );
            write();
            lPos := lPos + 1;
            rPos := rPos - 1
        end for_i
    end draw2Diagonals ;
    % test the draw 2 diagonals procedure                               %
    draw2Diagonals( 10 );
    write();
    draw2Diagonals( 11 )
end.
