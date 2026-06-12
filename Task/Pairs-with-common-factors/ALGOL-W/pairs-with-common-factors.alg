begin % finds integers of the sequence a(n) where a(n) is number of pairs    %
      % (x,y) where 1 < x < y <= n that have at least one common prime       %
      % factor. The sequence integers can be calculated by:                  %
      % a(n) = n(n-1)/2 + 1 - sum i = 1..n of phi(i) where phi is Euler's    %
      %                                                    totient function  %

    % returns the number of integers k where 1 <= k <= n that are mutually   %
    %                                                             prime to n %
    integer procedure totient ( integer value n ) ;     % algorithm from the %
        if       n < 3 then 1   % 2nd Go Sample in the Totient function task %
        else if  n = 3 then 2
        else begin
            integer t, v, i;
            t := n;
            v := n;
            i := 2;
            while i * i <= v do begin
                if v rem i = 0 then begin
                    while v rem i = 0 do v := v div i;
                    t := t - t div i
                end if_v_ren_i_eq_0 ;
                if i = 2 then i := 1;
                i := i + 2
            end while_ii_le_v ;
            if v > 1 then t - t div v else t
        end totient ;

    integer maxNumber, totientSum, nextToShow;
    maxNumber  := 100000;                 % maximum number of terms required %
    totientSum := 0;                              % sum of the totients 1..n %
    nextToShow := 1000;                   % next power of 10 integer to show %
    for n := 1 until maxNumber do begin
        integer an;
        totientSum := totientSum + totient( n );
        an         := ( ( ( n * ( n - 1 ) ) div 2 ) + 1 ) - totientSum;
        if n <= 100 then begin
            writeon( i_w := 4, s_w := 0, " ", an );
            if n rem 10 = 0 then write()
            end
        else if n = nextToShow then begin
            write( i_w := 1, s_w := 0, "a(", n, "): ", an );
            nextToShow := nextToShow * 10
        end if_n_le_100__n_eq_nextToShow
    end for_n

end.
