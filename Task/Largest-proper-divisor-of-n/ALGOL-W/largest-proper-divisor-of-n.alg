for n := 1 until 100 do begin % show the largest proper divisors for n = 1..100 %
    for j := n div 2 step -1 until 2 do begin
        if n rem j = 0 then begin
            writeon( i_w := 3, s_w := 0, j );
            goto foundLargestProperDivisor
        end if_n_rem_j_eq_0
    end for_j;
    writeon( i_w := 3, s_w := 0, 1 );
foundLargestProperDivisor:
    if n rem 10 = 0 then write()
end for_n.
