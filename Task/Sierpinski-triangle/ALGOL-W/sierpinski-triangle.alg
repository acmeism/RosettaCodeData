begin
    integer SIZE;
    SIZE := 16;
    for y := SIZE - 1 step - 1 until 0 do begin
        integer x;
        for i := 0 until y - 1 do writeon( " " );
        x := 0;
        while x + y < SIZE do begin
            writeon( if number( bitstring( x ) and bitstring( y ) ) not = 0 then "  " else "* " );
            x := x + 1
        end while_x_plus_y_lt_SIZE ;
        write();
    end for_y
end.
