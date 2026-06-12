begin % product of divisors - transaltion of the Fortran sample %
    integer array divis ( 1 :: 50 );
    for i := 1 until 50 do divis( i ) := 1;
    for i := 2 until 50 do begin
        for j := i step i until 50 do divis( j ) := divis( j ) * i
    end for_i;
    for i := 1 until 50 do begin
        writeon( i_w := 10, s_w := 0, divis( i ) );
        if i rem 5 = 0 then write()
    end for_i
end.
