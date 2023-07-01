begin
    % prints a Floyd's Triangle with n lines                                  %
    procedure floydsTriangle ( integer value n ) ;
    begin
        % the triangle should be left aligned with the individual numbers     %
        % right-aligned with only one space before the number in the final    %
        % row                                                                 %
        % calculate the highest number that will be printed                   %
        % ( the sum of the integeregers 1, 2, ... n )                         %
        integer array widths( 1 :: n );
        integer maxNumber, number;
        maxNumber := ( n * ( n + 1 ) ) div 2;
        % determine the widths required to print the numbers of the final row %
        number := maxNumber;
        for col := n step -1 until 1 do begin
            integer v, w;
            w      := 0;
            v      := number;
            number := number - 1;
            while v > 0 do begin
                w  := w + 1;
                v  := v div 10
            end while_v_gt_0 ;
            widths( col ) := w
        end for_col;
        % print the triangle                                                  %
        number := 0;
        for row := 1 until n do begin
            for col := 1 until row do begin
                number := number + 1;
                writeon( i_w := widths( col ), s_w := 0, " ", number )
            end for_col ;
            write()
        end for_row
    end; % floyds triangle %

    floydsTriangle(  5 );
    write();
    floydsTriangle( 14 )

end.
