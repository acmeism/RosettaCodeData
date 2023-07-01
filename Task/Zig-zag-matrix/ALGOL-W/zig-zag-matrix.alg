begin % zig-zag matrix %
    % z is returned holding a zig-zag matrix of order n, z must be at least n x n %
    procedure makeZigZag ( integer value n
                         ; integer array z( *, * )
                         ) ;
    begin
        procedure move ;
        begin
            if   y = n then begin
                upRight := not upRight;
                x := x + 1
                end
            else if x = 1 then begin
                upRight := not upRight;
                y := y + 1
                end
            else begin
                x := x - 1;
                y := y + 1
            end
        end move ;
        procedure swapXY ;
        begin
            integer swap;
            swap := x;
            x    := y;
            y    := swap;
        end swapXY ;
        integer x, y;
        logical upRight;
        % initialise the n x n matrix in z %
        for i := 1 until n do for j := 1 until n do z( i, j ) := 0;
        % fill in the zig-zag matrix %
        x := y := 1;
        upRight := true;
        for i := 1 until n * n do begin
            z( x, y ) := i - 1;
            if upRight then move
            else begin
                swapXY;
                move;
                swapXY
            end;
        end;
    end makeZigZap ;

    begin
        integer array zigZag( 1 :: 10, 1 :: 10 );
        for n := 5 do begin
            makeZigZag( n, zigZag );
            for i := 1 until n do begin
                 write( i_w := 4, s_w := 1, zigZag( i, 1 ) );
                for j := 2 until n do writeon( i_w := 4, s_w := 1, zigZag( i, j ) );
            end
        end
    end

end.
