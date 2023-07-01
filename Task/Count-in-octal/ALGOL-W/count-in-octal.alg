begin
    string(12) r;
    string(8)  octDigits;
    integer    number;
    octDigits := "01234567";
    number    := -1;
    while number < MAXINTEGER do begin
        integer    v, cPos;
        number := number + 1;
        v      := number;
        % build a string of octal digits in r, representing number %
        % Algol W uses 32 bit integers, so r should be big enough  %
        % the most significant digit is on the right               %
        cPos   := 0;
        while begin
            r( cPos // 1 ) := octDigits( v rem 8 // 1 );
            v :=  v div 8;
            ( v > 0 )
        end do begin
            cPos := cPos + 1
        end while_v_gt_0;
        % show most significant digit on a newline %
        write( r( cPos // 1 ) );
        % continue the line with the remaining digits (if any) %
        for c := cPos - 1 step -1 until 0 do writeon( r( c // 1 ) )
    end while_r_lt_MAXINTEGER
end.
