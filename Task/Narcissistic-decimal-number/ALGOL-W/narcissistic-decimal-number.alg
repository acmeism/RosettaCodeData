begin
    % print the first 25 narcissistic numbers                                 %

    integer array  power( 0 :: 9 );
    integer count, candidate, prevDigits, digits;

    power( 0 ) := 0;
    for i := 1 until 9 do power( i ) := 1;

    count      := 0;
    candidate  := 0;
    prevDigits := 0;
    digits     := 1;

    for d9 := 0 until 2 do begin
        if d9 > 0 and digits < 9 then digits := 9;
        for d8 := 0 until 9 do begin
            if d8 > 0 and digits < 8 then digits := 8;
            for d7 := 0 until 9 do begin
                if d7 > 0 and digits < 7 then digits := 7;
                for d6 := 0 until 9 do begin
                    if d6 > 0 and digits < 6 then digits := 6;
                    for d5 := 0 until 9 do begin
                        if d5 > 0 and digits < 5 then digits := 5;
                        for d4 := 0 until 9 do begin
                            if d4 > 0 and digits < 4 then digits := 4;
                            for d3 := 0 until 9 do begin
                                if d3 > 0 and digits < 3 then digits := 3;
                                for d2 := 0 until 9 do begin
                                    if d2 > 0 and digits < 2 then digits := 2;
                                    for d1 := 0 until 9 do begin
                                        integer number, sum;
                                        if prevDigits <> digits then begin
                                            % number of digits has increased %
                                            % - increase the powers          %
                                            prevDigits := digits;
                                            for i := 2 until 9 do power( i ) := power( i ) * i;
                                        end;

                                        % sum the digits'th powers of the    %
                                        % digits of candidate                %
                                        sum := power( d1 ) + power( d2 ) + power( d3 )
                                             + power( d4 ) + power( d5 ) + power( d6 )
                                             + power( d7 ) + power( d8 ) + power( d9 )
                                             ;
                                        if candidate = sum then begin
                                            % found another narcissistic    %
                                            % decimal number                %
                                            writeon( i_w := 1, s_w := 1, candidate );
                                            count := count + 1;
                                            if count >= 25 then goto done
                                        end;
                                        candidate := candidate + 1
                                    end d1;
                                end d2;
                            end d3;
                        end d4;
                    end d5;
                end d6;
            end d7;
        end d8;
    end d9;
done:
    write()

end.
