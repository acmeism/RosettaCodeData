begin
    integer max, next, i;

    integer procedure countDivisors ( Integer value n ) ;
    begin
        integer count, i, i2;
        count := 0;
        i     := 1;
        while  begin i2 := i * i;
                     i2 < n
        end do begin
            if n rem i = 0 then count := count + 2;
            i := i + 1
        end;
        if i2 = n then count + 1 else count
    end countDivisors ;

    max := 15;
    write( i_w := 1, s_w := 0, "The first ", max, " terms of the sequence are: " );
    i := next := 1;
    while next <= max do begin
        if next = countDivisors( i ) then begin
            writeon( i_w := 1, s_w := 0, " ", i );
            next := next +  1
        end;
        i := i + 1
    end;
    write()
end.
