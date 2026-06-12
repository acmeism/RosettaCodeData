begin % find "strange numbers" - numbers where digits differ from the next %
      % by a prime                                                         %
    % returns true if n is strange, false otherwise                        %
    logical procedure isStrange( integer value n ) ;
    begin
        integer rest, d0;
        logical strange;
        rest    := abs( n );
        strange := true;
        d0      := rest rem 10;
        rest    := rest div 10;
        while strange and rest > 0 do begin
            integer d1, diff;
            d1      := rest rem 10;
            rest    := rest div 10;
            diff    := abs( d1 - d0 );
            strange := diff = 2 or diff = 3 or diff = 5 or diff = 7;
            d0      := d1
        end while_strange_and_rest_gt_0 ;
        strange
    end isStrange ;
    % test the isStrange procedure on values 101-499                       %
    begin
        integer strangeCount;
        strangeCount := 0;
        for n := 101 until 499 do begin;
            if isStrange( n ) then begin
                strangeCount := strangeCount + 1;
                if strangeCount rem 20 = 1
                then write(   i_w := 4, s_w := 0, n )
                else writeon( i_w := 4, s_w := 0, n )
            end if_isStrange_n
        end for_n
    end
end.
