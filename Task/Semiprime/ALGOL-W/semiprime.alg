begin % find some semi-primes - numbers with exactly 2 prime factors %
    logical procedure isSemiPrime( integer value v ) ;
    begin
        integer a, b, c;
        a := 2; b := 0; c := v;
        while b < 3 and c > 1 do begin
            if c rem a = 0 then begin
                c := c div a;
                b := b + 1
                end
            else a := a + 1;
        end while_b_lt_3_and_c_ne_1 ;
        b = 2
    end isSemiPrime ;

    for x := 2 until 99 do begin
        if isSemiPrime( x ) then writeon( i_w := 1, s_w := 0, x, " " )
    end for_x
end.
