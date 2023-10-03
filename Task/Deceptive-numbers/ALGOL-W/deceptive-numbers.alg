begin % find deceptive numbers - repunits R(n) evenly divisible by composite    %
      % numbers and n+1; see the task talk page based on the second Wren sample %

    % returns true if n is an odd prime, false otherwise, uses trial division   %
    logical procedure isOddPrime ( integer value n ) ;
        begin
            logical prime;
            integer f, f2, toNext;
            prime  := true;
            f      :=  3;
            f2     :=  9;
            toNext := 16;        % note: ( 2n + 1 )^2 - ( 2n - 1 )^2 = 8n       %
            while f2 <= n and prime do begin
                prime  := n rem f not = 0;
                f      := f + 2;
                f2     := toNext;
                toNext := toNext + 8
             end while_f2_le_n_and_prime ;
             prime
        end isOddPrime ;

    begin % -- task %
        integer n, count;
        count :=  0;
        n     := 47;
        while begin n := n + 2;
                    count < 25
              end
        do    begin
              if n rem 3 not = 0 and n rem 5 not = 0 and not isOddPrime( n ) then begin
                  integer mp;
                  mp := 10;
                  for p := 2 until n - 1 do mp := ( mp * 10 ) rem n;
                  if mp = 1 then begin
                      count := count + 1;
                      writeon( i_w := 5, s_w := 0, " ", n );
                      if count rem 10 = 0 then write()
                  end if_mp_eq_1
              end if_have_a_candidate
        end while_count_lt_50
    end task

end.
