begin % show the first 10 prime Iccanobif (reversed Fibonacci) numbers       %

    % returns n with the digits reversed                                     %
    integer procedure reverse ( integer value n ) ;
    begin
        integer rev, v;
        rev := 0;
        v   := abs n;
        while v > 0 do begin
            rev := ( rev * 10 ) + ( v rem 10 );
            v   := v div 10
        end while_v_gt_0 ;
        if n < 0 then - rev else rev
    end reverse ;

    % returns true if n is prime, false otherwise, uses trial division       %
    logical procedure isPrime ( integer value n ) ;
        if      n < 3        then n = 2
        else if n rem 3 = 0  then n = 3
        else if not odd( n ) then false
        else begin
            logical prime;
            integer f, f2, toNext;
            prime  := true;
            f      := 5;
            f2     := 25;
            toNext := 24;           % note: ( 2n + 1 )^2 - ( 2n - 1 )^2 = 8n %
            while f2 <= n and prime do begin
                prime  := n rem f not = 0;
                f      := f + 2;
                f2     := toNext;
                toNext := toNext + 8
             end while_f2_le_n_and_prime ;
             prime
        end isPrime ;

    begin % task                                                             %
        integer pCount, curr, prev, next, rev;
        pCount := 0;
        prev   := 0;
        curr   := 1;
        while pCount < 10 do begin
            next := prev + curr;
            prev := curr;
            curr := next;
            rev  := reverse( curr );
            if isPrime( rev ) then begin
                % have a prime iccanobif number                              %
                pCount := pCount + 1;
                writeon( i_w := 1, s_w := 0, " ", rev )
            end if_isPrime_rev
        end while_pCount_lt_10
    end
end.
