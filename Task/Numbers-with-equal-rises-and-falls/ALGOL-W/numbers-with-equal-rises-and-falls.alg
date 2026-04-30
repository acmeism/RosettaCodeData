begin % Find numbers with equal rises and falls between the digits                  %

    % returns true if the number of digits in n followed by a higher digit (rises)  %
    %              equals the number of digits followed by a lower digit (falls)    %
    %        false otherwise                                                        %
    logical procedure equalRisesAndFalls( integer value n ) ;
        begin
            integer rf, prev, v;
            rf   := 0;
            prev := n rem 10;
            v    := n div 10;
            while v > 0 do begin
                integer d;
                d := v rem 10;
                if      d < prev then rf := rf + 1   % rise %
                else if d > prev then rf := rf - 1   % fall %
                ;
                prev := d;
                v    := v div 10
            end while_v_gt_0 ;
            rf = 0
        end equalRisesAndFalls ;

    begin % task test cases %

        integer maxCount;
        integer count, n;

        maxCount := 10000000;
        count    := n := 0;
        write( "The first 200 numbers in the sequence are:" );write();
        while count < maxCount do begin
            n := n + 1;
            if equalRisesAndFalls( n ) then begin
                count := count + 1;
                if count <= 200 then begin
                    writeon( i_w := 4, s_w := 0, n );
                    if count rem 20 = 0 then write()
                    end
                else if count = maxCount then begin
                    write( i_w := 8, s_w := 0, "The 10 millionth number in the sequence is ", n, "." );
                    write()
                end if_count_le_200__count_eq_maxCount
            end if_equalRisesAndFalls_n
        end while_count_lt_maxCount
    end
end.
