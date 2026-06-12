begin % draw a "mosaic matrix" - one with a 1 in the top-left and then  %
      % alternating with another character vertically and horizontally  %

    % draws a mosaic matrix with height and width = n using "1" and "." %
    procedure drawMosaic ( integer value n ) ;
        for i := 1 until n do begin
            logical one;
            one := odd( i );
            for j := 1 until n do begin
                writeon( s_w := 0, if one then " 1" else " ." );
                one := not one
            end for_j ;
            write()
        end drawMosaic ;

    % test the draw mosaic procedure %
    drawMosaic( 6 );
    write();
    drawMosaic( 7 )
end.
