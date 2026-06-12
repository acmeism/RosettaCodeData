begin % show the minimum elements of three lists %
    integer array numbers1, numbers2, numbers3 ( 1 :: 5 );
    integer pos;
    pos := 1; for v :=  5, 45, 23, 21, 67 do begin numbers1( pos ) := v; pos := pos + 1 end;
    pos := 1; for v := 43, 22, 78, 46, 38 do begin numbers2( pos ) := v; pos := pos + 1 end;
    pos := 1; for v :=  9, 98, 12, 98, 53 do begin numbers3( pos ) := v; pos := pos + 1 end;
    for i := 1 until 5 do begin
        integer m;
        m := numbers1( i );
        if numbers2( i ) < m then m := numbers2( i );
        if numbers3( i ) < m then m := numbers3( i );
        writeon( i_w := 1, s_w := 0, " ", m )
    end for_i;
end.
