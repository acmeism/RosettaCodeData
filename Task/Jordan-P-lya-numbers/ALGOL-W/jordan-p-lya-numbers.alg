begin % Jordan-Pólya numbers - translation of XPL0 via Agena                 %

    % returns true if m is a Jordan-Pólya number or not,                     %
    %         f must contain the first fCount factorials                     %
    logical procedure isJPNumber( integer value m
                                ; integer array f ( * )
                                ; integer value fCount
                                ) ;
    begin
        logical isJP;
        isJP := false;
        for limite := fCount step -1 until 1 do begin
            integer n, i, fac;
            logical found;
          if isJP then goto resultKnown;
            n := m; i := limite; fac := f( limite ); found := false;
            while not found do begin
                if n rem fac = 0 then begin
                    n    := n div fac;
                    isJp := n = 1
                end else begin
                    fac  := fac div i;
                    i    := i - 1
                end;
                found := i = 1 or isJP
            end
        end;
resultKnown:
        isJP
    end isJPNumber;

    % returns the next Jordan-Pólya number higher than n0                    %
    %         f must contain the first fCount factorials                     %
    integer procedure nextJP( integer value n0
                            ; integer array f ( * )
                            ; integer value fCount
                            ) ;
    begin
        integer n;
        n := n0 + 2;
        while not isJPNumber( n, f, fCount ) do n := n + 2;
        n
    end nextJp;

    integer MAX_FACTORIAL;
    MAX_FACTORIAL := 11;   % 11! is the largest factorial under 100 000 000 %

    begin
        integer n;
        integer array f ( 1 :: MAX_FACTORIAL );
        f( 1 ) := 1;
        for i := 2 until MAX_FACTORIAL do f( i ) := f( i - 1 ) * i;

        write( "1" );
        n := 0;
        for i := 1 until 49 do begin
           n := nextJP( n, f, MAX_FACTORIAL );
           writeon( i_w := 1, s_w := 0, " ", n )
        end for_i;
        n := 100000000;
        while n > 1 and not isJPNumber( n, f, MAX_FACTORIAL ) do n := n - 2;
        write();
        write( i_w := 1, s_w := 0, "The largest Jordan-Pólya number before 100 million: ", n )
    end
end.
