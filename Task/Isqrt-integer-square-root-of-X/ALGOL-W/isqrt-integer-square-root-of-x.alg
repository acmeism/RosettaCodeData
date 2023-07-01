begin % Integer square roots by quadratic residue                            %
    % returns the integer square root of x - x must be >= 0                  %
    integer procedure iSqrt ( integer value x ) ;
        if      x < 0 then begin assert x >= 0; 0 end
        else if x < 2 then x
        else begin
            % x is greater than 1                                            %
            integer q, r, t, z;
            % find a power of 4 that's greater than x                        %
            q := 1;
            while q <= x do q := q * 4;
            % find the root                                                  %
            z := x;
            r := 0;
            while q > 1 do begin
                q := q div 4;
                t := z - r - q;
                r := r div 2;
                if t >= 0 then begin
                    z := t;
                    r := r + q
                end if_t_ge_0
            end while_q_gt_1 ;
            r
         end isqrt;
    % writes n in 14 character positions with separator commas               %
    procedure writeonWithCommas ( integer value n ) ;
    begin
        string(10) decDigits;
        string(14) r;
        integer    v, cPos, dCount;
        decDigits    := "0123456789";
        v            := abs n;
        r            := " ";
        r( 13 // 1 ) := decDigits( v rem 10 // 1 );
        v            := v div 10;
        cPos         := 12;
        dCount       := 1;
        while cPos > 0 and v > 0 do begin
            r( cPos // 1 ) := decDigits( v rem 10 // 1 );
            v      :=  v div 10;
            cPos   := cPos - 1;
            dCount := dCount + 1;
            if v not = 0 and dCount = 3 then begin
                r( cPos // 1 ) := ",";
                cPos   := cPos - 1;
                dCount := 0
            end if_v_ne_0_and_dCount_eq_3
        end for_cPos;
        r( cPos // 1 ) := if n < 0 then "-" else " ";
        writeon( s_w := 0, r )
    end writeonWithCommas ;
    begin % task test cases                                                  %
        integer prevI, prevR, root, p7;
        write( "Integer square roots of 0..65 (values the same as the previous one not shown):" );
        write();
        prevR := prevI := -1;
        for i := 0 until 65 do begin
            root := iSqrt( i );
            if root not = prevR then begin
                prevR := root;
                prevI := i;
                writeon( i_w := 1, s_w := 0, " ", i, ":", root )
                end
            else if prevI = i - 1 then writeon( "..." );
        end for_i ;
        write();
        % integer square roots of odd powers of 7                            %
        write( "Integer square roots of 7^n, odd n" );
        write( " n|           7^n|    isqrt(7^n)" );
        write( " -+--------------+--------------" );
        p7 := 7;
        for p := 1 step 2 until 9 do begin
            write( i_w := 2, s_w := 0, p );
            writeon( s_w := 0, "|" ); writeonWithCommas(        p7   );
            writeon( s_w := 0, "|" ); writeonWithCommas( iSqrt( p7 ) );
            p7 := p7 * 49
        end for_p
    end task_test_cases
end.
