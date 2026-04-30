begin % list the first 30 numbers that are squares but not cubes  %
      % also indicate the numbers that are both squares and cubes %

    integer count, c, c3, s, sq;

    count := sq := 0;
    c := c3 := 1;

    while count < 30 do begin
        s  := s + 1;
        sq := s * s;
        while c3 < sq do begin
            c  := c + 1;
            c3 := c * c * c
        end while_c3_lt_sq ;
        writeon( i_w := 4, s_w := 0, " ", sq );
        if c3 = sq then writeon( i_w := 1, s_w := 0, " is also the cube of ", c )
                   else count := count + 1
        ;
        write()
    end while_count_lt_30
end.
