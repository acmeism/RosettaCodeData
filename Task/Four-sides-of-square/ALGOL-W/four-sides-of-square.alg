begin % draw a matrix with 1s on the edges and 0s elsewhere             %
    % draws a matrix with height and width = n with 1s on the edges     %
    procedure drawSquare ( integer value n ) ;
        for i := 1 until n do begin
            for j := 1 until n do begin
                writeon( s_w := 0, if i = 1 or i = n or j = 1 or j = n then " 1" else " 0" )
            end for_j ;
            write()
        end drawSquare ;
    % test the draw square procedure %
    drawSquare( 6 );
    write();
    drawSquare( 7 )
end.
