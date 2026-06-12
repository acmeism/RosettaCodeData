begin % show the sums of the cubes of n for 0 <= n < 50 %
    integer cubeSum;
    cubeSum := 0;
    for n := 0 until 49 do begin
        cubeSum := cubeSum + ( n * n * n );
        writeon( i_w := 8, s_w := 0, cubeSum );
        if n rem 10 = 9 then write()
    end for_n
end.
