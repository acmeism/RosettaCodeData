begin % find idoneal numbers - numbers that cannot be written as ab + bc + ac %
      %                        where 0 < a < b < c                            %
      % there are 65 known idoneal numbers                                    %

    integer count, MAX_COUNT, n;
    MAX_COUNT := 65;
    count     :=  0;
    n         :=  0;
    while count < MAX_COUNT do begin
        logical idoneal;
        integer a;
        n       := n + 1;
        idoneal := true;
        a       := 1;
        while idoneal and ( a + 2 ) < n do begin
            integer b, ab, sum;
            b   := a + 1;
            ab  := a * b;
            sum := 0;
            while idoneal and sum <= n and ab < n do begin
                integer c;
                c   := ( n - ab ) div ( a + b );
                sum := ab + ( c * ( b + a ) );
                if c > b and sum = n then idoneal := false
                else begin
                    b  := b + 1;
                    ab := a * b
                end
            end;
            a := a + 1
        end;
        if idoneal then begin
            count := count + 1;
            writeon( i_w := 4, s_w := 0, " ", n );
            if count rem 13 = 0 then write()
        end if_idoneal
    end while_count_lt_MAX_COUNT
end.
