begin % draw a Sierpinski curve using ascii art %
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
                    asciiX := asciiX + 1;
                    canvas( asciiX, asciiY ) := "_";
                    updateCoordinateRange;
                    end
                else if heading =  90 then begin
                    updateCoordinateRange;
                    canvas( asciiX, asciiY ) := "|";
                    asciiY := asciiY - 1;
                    end
                else if heading = 180 then begin
                    asciiX := asciiX - 1;
                    canvas( asciiX, asciiY ) := "_";
                    updateCoordinateRange;
                    end
                else if heading = 270 then begin
                    asciiY := asciiY + 1;
                    updateCoordinateRange;
                    canvas( asciiX - 1, asciiY ) := "|";
                end if_various_headings
            end drawLine ;
        % changes the heading by the specified angle ( in degrees ) - angle must be +/- 90 %
        % the position is updated, if necessary as the horizontal lines are at the bottom  %
        % of a character but the vertical lines are in the middle pf a character           %
        procedure turn( integer value angle ) ;
            begin
                integer prevHeading;
                prevHeading  := heading;
                heading      := heading + angle;
                while heading < 0 do heading := heading + 360;
                heading := heading rem 360;
                if      heading =   0 and prevHeading = 270 then asciiX := asciiX - 1
                else if heading =  90 then begin
                    if      prevHeading = 180 then asciiX := asciiX - 1
                    else if prevHeading =   0 then asciiX := asciiX + 1
                    end
                else if heading = 180 and prevHeading = 270 then asciiX := asciiX - 1
                else if heading = 270 and prevHeading =   0 then asciiX := asciiX + 2
            end turn ;
        % initialises the ascii art canvas %
        procedure initArt ( integer value initHeading ) ;
            begin
                heading := initHeading;;
                asciiX  := CANVAS_WIDTH div 2;
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
        % draws a sierpinski square curve of the specified order %
        procedure sierpinskiSquareCurve( integer value order ) ;
            begin
                % draw a line connecting segments %
                procedure extendedLine ;
                    if actualOrder > 4 then begin
                        % for higher orders, the segments can touch %
                        % so space the segments further apart       %
                        if heading rem 180 = 0 then drawline( 1 );
                        drawline( 1 );
                        drawline( 1 )
                    end extendedLine ;
                % draw a corner of an element of the curve %
                procedure corner ;
                    begin
                        drawline( 1 );
                        turn( - 90 );
                        drawline( 1 )
                    end corner ;
                % recursively draws a part of a sierpinski square curve %
                procedure subCurve( integer value order; logical value threeSubCurves ) ;
                    begin
                        corner;
                        turn( + 90 );
                        drawline( 1 );
                        if order < 1 then begin
                            turn( - 90 );
                            drawline( 1 );
                            turn( - 90 )
                            end
                        else begin
                            extendedLine;;
                            turn( + 90 );
                            curve( order, threeSubCurves );
                            turn( + 90 );
                            extendedLine
                        end if_order_lt_1 ;
                        drawline( 1 );
                        turn( + 90 )
                    end subCurve;
                % recursively draws a segment of the sierpinski curve %
                procedure curve( integer value order; logical value threeSubCurves ) ;
                    begin
                        subCurve( if threeSubCurves then order - 1 else 0, not threeSubCurves );
                        subCurve( order - 1, not threeSubCurves );
                        subCurve( if threeSubCurves then order - 1 else 0, not threeSubCurves );
                        corner
                    end curve ;
                integer actualOrder;
                actualOrder := order;
                if order = 1 then begin
                    for c := 1 until 4 do corner
                    end
                else if order = 2 then begin
                    for c := 1 until 4 do subCurve( 0, false )
                    end
                else begin
                    for c := 1 until 4 do subCurve( ( 2 * order ) - 5, false )
                end if_order_eq_1__2__
            end sierpinskiSquareCurve ;
        % draw curves %
        begin
            integer order;
            i_w := 1; s_w := 0; % set output formatting %
            write( "order> " );
            read( order );
            write( "Sierpinski curve of order ", order );
            write( "===========================" );
            write();
            initArt( 0 );
            sierpinskiSquareCurve( order );
            drawArt
        end
    end
end.
