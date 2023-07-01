begin
    % calculate the Multiplicative Digital Root (mdr) and Multiplicative Persistence (mp) of n %
    procedure getMDR ( integer value  n
                     ; integer result mdr, mp
                     ) ;
    begin
        mp  := 0;
        mdr := abs n;
        while mdr > 9 do begin
           integer v;
           v   := mdr;
           mdr := 1;
           while begin
               mdr := mdr * ( v rem 10 );
               v   := v div 10;
               v > 0
           end do begin end;
           mp := mp + 1;
        end while_mdr_gt_9 ;
    end getMDR ;

    % task test cases %
    write( "       N MDR MP" );
    for n := 123321, 7739, 893, 899998 do begin
        integer mdr, mp;
        getMDR( n, mdr, mp );
        write( s_w := 1, i_w := 8, n, i_w := 3, mdr, i_w := 2, mp )
    end for_n ;

    begin % find the first 5 numbers with each possible MDR %
        integer requiredMdrs;
        requiredMdrs := 5;
        begin
            integer array firstFew ( 0 :: 9, 1 :: requiredMdrs );
            integer array mdrFOund ( 0 :: 9 );
            integer       totalFound, requiredTotal, n;
            for i := 0 until 9 do mdrFound( i ) := 0;
            totalFound    := 0;
            requiredTotal := 10 * requiredMdrs;
            n             := -1;
            while totalFound < requiredTotal do begin
                integer mdr, mp;
                n := n + 1;
                getMDR( n, mdr, mp );
                if mdrFound( mdr ) < requiredMdrs then begin
                    % found another number with this MDR and haven't found enough yet %
                    totalFound                       := totalFound + 1;
                    mdrFound( mdr )                  := mdrFound( mdr ) + 1;
                    firstFew( mdr, mdrFound( mdr ) ) := n
                end if_found_another_MDR
            end while_totalFound_lt_requiredTotal ;
            % print the table of MDRs andnumbers %
            write( "MDR: [n0..n4]" );
            write( "===  ========" );
            for v := 0 until 9 do begin
                write( i_w := 3, s_w := 0, v, ": [" );
                for foundPos := 1 until requiredMdrs do begin
                    if foundPos > 1 then writeon( s_w := 0, ", " );
                    writeon( i_w := 1, s_w := 0, firstFew( v, foundPos ) )
                end for_foundPos ;
                writeon( s_w := 0, "]" )
            end for_v
        end
    end

end.
