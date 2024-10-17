begin % compute an approximation to the Meissel-Mertens constant             %
  integer MAX_PRIME;
  MAX_PRIME := 10000000;
  begin
    logical array primes ( 0 :: MAX_PRIME );
    begin % construct a sieve of odd primes                                  %
        integer i, ip;
        for i := 1 until MAX_PRIME do primes( i ) := true;
        ip := 3;
        i  := 1;
        while i + ip <= MAX_PRIME do begin
            if primes( i ) then begin
                for s := i + ip step ip until MAX_PRIME do primes( s ) := false
            end if_primes__i ;
            ip := ip + 2;
            i  := i + 1
        end while_i_plus_ip_le_MAX_PRIME
    end;
    begin % sum the reciprocals of the primes                                %
        integer   pCount, lastP, p, p10;
        long real sum, eulersConstant;
        procedure showProgress ;
            write( s_w := 0, i_w := 8
                 , r_format := "A", r_w := 14, r_d := 12
                 , "after ", pCount, " primes, the approximation is: "
                 , ( sum + eulersConstant ), ", last prime considered: "
                 , i_w := 1
                 , lastP
                 );
        pCount := 1;
        lastP  := 0;
        sum    := longLn( 0.5 ) + 0.5;
        p      := 1;
        p10    := 10;
        % Euler's constant from the wikipedia, truncated for long real       %
        eulersConstant := 0.5772156649015328606 % 0651209008240243104215933593992 %;
        for i := 1 until MAX_PRIME do begin
            p := p + 2;
            if primes( i ) then begin
                long real rp;
                rp      := 1 / long p;
                sum     := sum + longLn( 1 - rp ) + rp;
                pCount  := pCount + 1;
                lastP   := p;
                if pCount = p10 then begin
                    showProgress;
                    p10 := if p10 < 1000000 THEN p10 * 10 else p10 + 1000000
                end if_pCount_eq_p10
            end if_primes__i
        end for_i ;
        showProgress
    end
  end
end.
