begin % draw sierpinski arrowhead curves using ascii art %
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
                else if heading =  60 then begin
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "/";
                    asciiY := asciiY - 1;
                    asciiX := asciiX + 1
                    end
                else if heading = 120 then begin
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
                else if heading = 240 then begin
                    asciiX := asciiX - 1;
                    asciiY := asciiY + 1;
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "/"
                    end
                else if heading = 300 then begin
                    asciiY := asciiY + 1;
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "\";
                    asciiX := asciiX + 1
                end if_various_headings
            end drawLine ;
        % changes the heading by the specified angle ( in degrees ) - angle must be +/- 60 %
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
        % draws a sierpinski arrowhead curve of the specified order and line length %
        procedure sierpinskiArrowheadCurve( integer value order; real value length ) ;
            begin
                % recursively draws a segment of the sierpinski arrowhead curve %
                procedure curve( integer value order; real value length; integer value angle ) ;
                if 0 = order then drawline( length )
                else begin
                    curve( order - 1, length / 2, - angle );
                    turn(  angle );
                    curve( order - 1, length / 2,   angle );
                    turn(  angle );
                    curve( order - 1, length / 2, - angle )
                end curve ;
                if not odd( order ) then begin % order is even, we can just draw the curve. %
                    curve( order, length, +60 );
                    end
                else begin % order is odd %
                    turn( +60 );
                    curve( order, length, -60 )
                end if_not_odd_order__
            end sierpinskiArrowheadCurve ;
        % draw curves %
        i_w := 1; s_w := 0; % set output formatting %
        for order := 5 do begin
            write( "Sierpinski arrowhead curve of order ", order );
            write( "=====================================" );
            write();
            initArt;
            sierpinskiArrowheadCurve( order, 1 );
            drawArt
        end for_order
    end
end.
