begin % show the minimum number of cells above, below, before and after each %
      % cell in a square matrix                                              %

    integer procedure min4( integer value a, b, c, d ) ;
    begin
        integer m;
        m := a;
        if b < m then m := b;
        if c < m then m := c;
        if d < m then m := d;
        m
    end min4 ;

    procedure printMinCells ( integer value n ) ;
    begin
        integer w, v;
        w := 1; v := ( ( n - ( if odd( n ) then 1 else 0 ) ) div 2 );
        while v > 9 do begin v := v div 10; w := w + 1 end;
        write( i_w := 1, s_w := 0, "Minimum number of cells after, before, above and below ", n, " x ", n, " square:" );
        write();
        for r := 0 until n - 1 do begin
            for c := 0 until n - 1 do writeon( i_w := w, s_w := 1, min4( n-r-1, r, c, n-c-1 ) );
            write()
        end for_r
    end printMinCells ;

    for n := 10, 9, 2, 1 do printMinCells( n )

end.
