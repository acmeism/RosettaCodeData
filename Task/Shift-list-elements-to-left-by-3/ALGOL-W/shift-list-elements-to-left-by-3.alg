begin
    % increments a and returns the new value %
    integer procedure inc ( integer value result a ) ; begin a := a + 1; a end;
    % shifts in place the elements of a left by n, a must have bounds lb::ub  %
    procedure  rotateLeft ( integer array a ( * ); integer value lb, ub, n ) ;
        if n < ( ub - lb ) and n > 0 then begin
            % the amount to shift is less than the length of the array %
            integer array shifted ( 1 :: n );
            integer aPos;
            for i := 0 until n - 1 do shifted( i ) := a( lb + i );
            for i := lb until ub - n do a( i ) := a( i + n );
            aPos := ub - n;
            for i := 0 until n - 1 do a( inc( aPos ) ) := shifted( i );
        end rotateLeft ;
    % prints the elements of v from lb to ub %
    procedure printArray ( integer array v ( * ); integer value lb, ub ) ;
    begin
        writeon( s_w := 0, "[" );
        if lb <= ub then begin
            writeon( i_w := 1, s_w := 0, v( lb ) );
            for i := lb + 1 until ub do writeon( i_w := 1, s_w := 0, "," , v( i ) )
        end;
        writeon( s_w := 0, "]" )
    end printArray ;
    begin
        integer array v ( 1 :: 9 );
        for i := 1 until 9 do v( i ) := i;
        printArray( v, 1, 9 );
        writeon( " -> " );
        rotateLeft( v, 1, 9, 3 );
        printArray( v, 1, 9 );
        write()
    end
end.
