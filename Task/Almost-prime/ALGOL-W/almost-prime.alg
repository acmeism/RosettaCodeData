begin
    logical procedure kPrime( integer value nv, k ) ;
    begin
        integer p, f, n;
        n := nv;
        f := 0;
        while f <= k and not odd( n ) do begin
            n := n div 2;
            f := f + 1
        end while_not_odd_n ;
        p := 3;
        while f <= k and p * p <= n do begin
            while n rem p = 0 do begin
                n := n div p;
                f := f + 1
            end while_n_rem_p_eq_0 ;
            p := p + 2
        end while_f_le_k_and_p_is_a_factor ;
        if n > 1 then f := f + 1;
        f = k
    end kPrime ;
    begin
        for k := 1 until 5 do begin
            integer c, i;
            write( i_w := 1, s_w := 0, "k = ", k , ": " );
            c := 0;
            i := 2;
            while c < 10 do begin
                if kPrime( i, k ) then begin
                    writeon( i_w := 3, s_w := 0, " ", i );
                    c := c + 1
                end if_kPrime_i_k ;
                i := i + 1
            end while_c_lt_10
        end for_k
    end
end.
