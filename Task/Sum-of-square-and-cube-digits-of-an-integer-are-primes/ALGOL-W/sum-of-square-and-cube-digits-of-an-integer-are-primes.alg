begin
    integer procedure digitSum( integer value n ) ;
    begin
        integer sum, v, vOver10;
        sum := 0;
        v   := n;
        while v > 0 do begin
            vover10 := v div 10;
            sum     := sum + ( v - ( vover10 * 10 ) );
            v       := vover10
        end while_v_gt_0 ;
        sum
    end digitSum ;
    logical procedure isPrime( integer value n ) ;
        if      n < 2        then false
        else if not odd( n ) then n = 2
        else begin
            logical prime;
            integer p;
            prime := true;
            p     := 3;
            while p * p <= n and prime do begin
               prime := n rem p not = 0;
               p := p + 2;
            end while_p2_le_n_and_prime ;
            prime
        end isPrime ;
    for i := 1 until 99 do begin
        integer i2;
        i2 := i * i;
        if isPrime( digitSum( i2 ) ) then begin;
            if isPrime( digitSum( i2 * i ) ) then writeon( i_w := 1, s_w := 1, i )
        end
    end
end.
