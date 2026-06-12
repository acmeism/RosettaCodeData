begin % find numbers n, where the sum of the digits is a substring of n %
    % returns true if the digits of s contains the digits of t, false otherwise %
    logical procedure containsDigits( integer value s, t ) ;
    if s = t then true
    else begin
        integer tPower, v, u;
        logical isContained;
        % find the lowest power of 10 that is greater then t %
        tPower := 10;
        v      := abs t;
        while v > 9 do begin
            tPower := tPower * 10;
            v      := v div 10
        end while_v_gt_9 ;
        isContained := false;
        v           := abs t;
        u           := abs s;
        while not isContained and u > 0 do begin
            isContained := ( u rem tPower ) = v;
            u           := u div 10
        end while_not_isContained_and_u_gt_0 ;
        isContained
    end containsDigits ;
    % find and show the matching numbers up to 1000 %
    integer nCount;
    nCount    := 0;
    for n := 0 until 999 do begin
        integer dSum, v;
        dSum := 0;
        v    := n;
        while v > 0 do begin
            dSum := dSum + ( v rem 10 );
            v    := v div 10
        end while_v_gt_0 ;
        if containsDigits( n, dSum ) then begin
            writeon( i_w := 5, s_w := 0, n );
            nCount := nCount + 1;
            if nCount rem 8 = 0 then write()
        end if_n_contains_dSum
    end for_n
end.
