begin
    % This is an integer ascii Mandelbrot generator, translated from the   %
    % Compiler/AST Interpreter Task's ASCII Mandelbrot Set example program %
    integer leftEdge, rightEdge, topEdge, bottomEdge, xStep, yStep, maxIter;
    leftEdge   := -420;
    rightEdge  :=  300;
    topEdge    :=  300;
    bottomEdge := -300;
    xStep      :=    7;
    yStep      :=   15;

    maxIter    :=  200;

    for y0 := topEdge step - yStep until bottomEdge do begin
        for x0 := leftEdge step xStep until rightEdge do begin
            integer x, y, i;
            string(1) theChar;
            y := 0;
            x := 0;
            theChar := " ";
            i := 0;
            while i < maxIter do begin
                integer x_x, y_y;
                x_x := (x * x) div 200;
                y_y := (y * y) div 200;
                if x_x + y_y > 800 then begin
                    theChar := code( decode( "0" ) + i );
                    if i > 9 then theChar := "@";
                    i := maxIter
                end;
                y := x * y div 100 + y0;
                x := x_x - y_y + x0;
                i := i + 1
            end while_i_lt_maxIter ;
            writeon( theChar );
        end for_x0 ;
        write();
    end for_y0
end.
