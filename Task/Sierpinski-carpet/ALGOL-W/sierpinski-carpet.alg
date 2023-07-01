begin
    for depth := 3 do begin
        integer dim;
        dim   := 1;
        for i := 0 until depth - 1 do dim := dim * 3;
        for i     := 0 until   dim - 1 do begin
            for j := 0 until   dim - 1 do begin
                integer d;
                d := dim div 3;
                while d not = 0
                  and not ( ( i rem ( d * 3 ) ) div d = 1 and ( j rem ( d * 3 ) ) div d = 1 )
                do d := d div 3;
                writeon( if d not = 0 then "  " else "##" )
            end for_j;
            write()
        end for_i;
        write()
    end for_depth
end.
