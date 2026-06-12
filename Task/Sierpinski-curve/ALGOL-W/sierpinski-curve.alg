begin % draw sierpinski curves using ascii art %
    integer CANVAS_WIDTH;
    CANVAS_WIDTH := 200;
    begin
        % the ascii art canvas and related items %
        string(1) array canvas ( 1 :: CANVAS_WIDTH, 1 :: CANVAS_WIDTH );
        integer         heading, asciiX, asciiY, width, maxX, maxY, minX, minY;
        % draw a line using ascii art - the length is ignored and the heading determines the %
        %                               character to use                                     %
        % the position is updated                                                            %
        procedure drawLine( real value length ) ;
            begin
                % stores the min and max coordinates %
                procedure updateCoordinateRange ;
                    begin
                        if asciiX > maxX then maxX := asciiX;
                        if asciiY > maxY then maxY := asciiY;
                        if asciiX < minX then minX := asciiX;
                        if asciiY < minY then minY := asciiY
                    end updateCoordinateRange ;
                if      heading =   0 then begin
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "_";
                    asciiX := asciiX + 1
                    end
                else if heading =  45 then begin
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "/";
                    asciiY := asciiY - 1;
                    asciiX := asciiX + 1
                    end
                else if heading =  90 then begin
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "|";
                    asciiY := asciiY - 1
                    end
                else if heading = 135 then begin
                    asciiX := asciiX - 1;
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "\";
                    asciiY := asciiY - 1
                    end
                else if heading = 180 then begin
                    asciiX := asciiX - 1;
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "_"
                    end
                else if heading = 225 then begin
                    asciiX := asciiX - 1;
                    asciiY := asciiY + 1;
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "/"
                    end
                else if heading = 270 then begin
                    asciiY := asciiY + 1;
                    updateCoordinateRange;
                    canvas( asciiX - 1, asciiY ) := "|";
                    end
                else if heading = 315 then begin
                    asciiY := asciiY + 1;
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "\";
                    asciiX := asciiX + 1
                end if_various_headings
            end drawLine ;
        % changes the heading by the specified angle ( in degrees ) - angle must be +/- 45 %
        procedure turn( integer value angle ) ;
            if angle > 0
            then heading := ( heading + angle ) rem 360
            else begin
                 heading := heading + angle;
                 if heading < 0 then heading := heading + 360
            end tuen ;
        % initialises the ascii art canvas %
        procedure initArt ;
            begin
                heading :=   0;
                asciiX  :=  CANVAS_WIDTH div 2;
                asciiY  := asciiX;
                maxX    := asciiX;
                maxY    := asciiY;
                minX    := asciiX;
                minY    := asciiY;
                for x := 1 until CANVAS_WIDTH do for y := 1 until CANVAS_WIDTH do canvas( x, y ) := " "
            end initArt ;
        % shows the used parts of the canvas %
        procedure drawArt ;
            begin
                for y := minY until maxY do begin
                    write();
                    for x := minX until maxX do writeon( canvas( x, y ) )
                end for_y ;
                write()
            end drawIArt ;
        % draws a sierpinski curve of the specified order and line length %
        procedure sierpinskiCurve( integer value order ) ;
            begin
                % recursively draws a segment of the sierpinski curve %
                procedure curve( integer value order; integer value angle ) ;
                    if 0 not = order then begin
                        turn( + angle );
                        curve( order - 1, - angle );
                        turn( - angle );
                        drawline( 1 );
                        if heading rem 180 = 0 then drawline( 1 );
                        turn( - angle );
                        curve( order - 1, - angle );
                        turn( + angle );
                    end curve ;
                for Quad := 1 until 4 do begin
                    curve( order * 2, 45 );
                    turn( 45 );
                    drawline( 1 );
                    if heading rem 180 = 0 then drawline( 1 );
                    turn( 45 );
                end for_Quad
            end sierpinskiCurve ;
        % draw curves %
        i_w := 1; s_w := 0; % set output formatting %
        for order := 3 do begin
            write( "Sierpinski curve of order ", order );
            write( "===========================" );
            write();
            initArt;
            sierpinskiCurve( order );
            drawArt
        end for_order
    end
end.
