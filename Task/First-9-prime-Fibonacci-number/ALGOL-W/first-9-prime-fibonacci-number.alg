begin % -- show the first 9 prime fibonacci numbers %

    % -- returns true if n is prime, false otherwise - uses trial division %
    logical procedure isPrime ( integer value n ) ;
        if      n < 3        then n = 2
        else if not odd( n ) then false
        else begin
            logical prime;
            prime := true;
            for i := 3 step 2 until entier( sqrt( n ) ) do begin
                prime := n rem i not = 0;
                if not prime then goto endTest;
            end for_i;
endTest:    prime
        end isPrime ;

    begin % -- task %
        integer pCount, prev, curr, next;
        pCount := 0;
        prev   := 0;
        curr   := 1;
        while pCount < 9 do begin
            next := prev + curr;
            prev := curr;
            curr := next;
            if isPrime( curr ) then begin
                pCount := pCount + 1;
                writeon( i_w := 1, s_w := 0, " ", curr )
            end if_isPrime__curr
        end while_pCount_lt_9
    end task
end.
