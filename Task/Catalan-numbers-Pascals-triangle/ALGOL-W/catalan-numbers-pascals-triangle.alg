begin
    % print the first 15 Catalan numbers from Pascal's triangle %
    integer n;
    n := 15;
    begin
        integer array pascalLine ( 1 :: n + 1 );
        % the Catalan numbers are the differences between the middle and middle - 1 numbers of the odd %
        % lines of Pascal's triangle (lines with 3 or more numbers)                                    %
        % note - we only need to calculate the left side of the triangle                               %
        pascalLine( 1 ) := 1;
        for c := 2 until n + 1 do begin
            % even line %
            for i := c - 1 step -1 until 2 do pascalLine( i ) := pascalLine( i - 1 ) + pascalLine( i );
            pascalLine( c ) := pascalLine( c - 1 );
            % odd line %
            for i := c     step -1 until 2 do pascalLine( i ) := pascalLine( i - 1 ) + pascalLine( i );
            writeon( i_w := 1, s_w := 0, " ", pascalLine( c ) - pascalLine( c - 1 ) )
        end for_c
    end
end.
