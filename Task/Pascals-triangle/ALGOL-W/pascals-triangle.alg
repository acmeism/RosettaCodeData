begin
    % prints the first n lines of Pascal's triangle lines %
    % if n is <= 0, no output is produced                 %
    procedure printPascalTriangle( integer value n ) ;
        if n > 0 then begin
            integer array pascalLine ( 1 :: n );
            pascalLine( 1 ) := 1;
            for line := 1 until n do begin
                for i := line - 1 step - 1 until 2 do pascalLine( i ) := pascalLine( i - 1 ) + pascalLine( i );
                pascalLine( line ) := 1;
                write( s_w := 0, " " );
                for i := line until n do writeon( s_w := 0, "   " );
                for i := 1 until line do writeon( i_w := 6, s_w := 0, pascalLine( i ) )
            end for_line ;
        end printPascalTriangle ;

    printPascalTriangle( 8 )

end.
