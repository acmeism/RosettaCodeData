begin
    % count/show some square free numbers                                           %
    % a number is square free if not divisible by any square and so not divisible   %
    % by any squared prime                                                          %
    % to satisfy the task we need to know the primes up to root 1 000 000 000 145   %
    % and the square free numbers up to 1 000 000                                   %
    long real oneTrillion;
    integer   primeMax, sfMax;
    oneTrillion := 1'6 * 1'6;
    primeMax    := entier( longsqrt( oneTrillion + 145 ) ) + 1;
    sfMax       := 1000000;
    begin
        logical array prime     ( 1 :: primeMax );
        logical array squareFree( 1 :: sfMax    );

        % returns true if n is square free, false otherwise                         %
        %         n is long real to allow for values up to 2^53                     %
        %         the values of n must be non-negative integers <= 2^53             %
        logical procedure isSquareFree ( long real value n ) ;
                if n <= sfMax then squareFree( entier( n ) )
                else begin % n is larger than the sieve - use trial division        %
                    integer maxFactor, f;
                    logical isSF;
                    maxFactor := entier( longsqrt( n ) ) + 1;
                    isSF      := true;
                    f         := 1;
                    while begin f := f + 1;
                                f <= maxFactor and isSF
                          end
                    do    begin
                              if prime( f ) then begin
                                  long real nOverFF, n10, p10;
                                  nOverFF := n / ( f * f );
                                  % as we are using long real to handle integers    %
                                  % larger than 2^32, we can't use rem              %
                                  % instead we subtract powers of ten from nOverFF  %
                                  % until nOverFF is < 1, if it is 0 then f * f     %
                                  % exactly divides n...                            %
                                  p10 :=  1;
                                  n10 := 10;
                                  while n10 < nOverFF do begin
                                      p10 := n10;
                                      n10 := n10 * 10
                                  end while_n10_lt_nOverFF ;
                                  while p10 >= 1 do begin
                                      while nOverFF >= p10 do nOverFF := nOverFF - p10;
                                      p10 := p10 / 10
                                  end while_p10_ge_1 ;
                                  isSF    := nOverFF not = 0
                              end if_isPrime__f
                    end while_isSf ;
                    isSF
                end isSquareFree ;
        % returns the count of squareFree numbers between m and n (inclusive)      %
        integer procedure countSquareFree ( integer value m, n ) ;
                begin
                    integer count;
                    count := 0;
                    for i := m until n do if squareFree( i ) then count := count + 1;
                    count
                end countSquareFree ;

        % sieve the primes                                                          %
        for i := 1 until primeMax do prime( i ) := true;
        for i := 1 until sfMax    do squareFree( i ) := true;
        for s := 2 until entier( sqrt( primeMax ) ) do begin
            if prime( s ) then begin
                for p := s * s step s until primeMax do prime( p ) := false
            end if_prime__s
        end for_s ;
        % sieve the square free integers                                            %
        for s := 2 until entier( sqrt( sfMax ) ) do begin
            if prime( s ) then begin
                integer q;
                q := s * s;
                for p := q step q until sfMax do squareFree( p ) := false
            end if_prime__s
        end for_s ;

        begin % task requirements                                                   %
            integer count, sf100, sf1000, sf10000, sf100000, sf1000000;
            % show square free numbers from 1 -> 145                                %
            write( "Square free numbers from 1 to 145:" );write();
            count := 0;
            for i := 1 until 145 do begin
                if isSquareFree( i ) then begin
                    writeon( i_w := 4, s_w := 0, i );
                    count := count + 1;
                    if count rem 20 = 0 then write()
                end if_isSquareFree__i
            end for_i ;
            write();
            % show square free numbers from 1 trillion -> one trillion + 145        %
            write( "Square free numbers from 1 000 000 000 000 to 1 000 000 000 145:" );write();
            count := 0;
            for i := 0 until 145 do begin
                if isSquareFree( oneTrillion + i ) then begin
                    writeon( r_format := "A", r_w := 14, r_d := 0, oneTrillion + i );
                    count := count + 1;
                    if count rem 5 = 0 then write()
                end if_isSquareFree__oneTrillion_plus_i
            end for_i ;
            write();
            % show counts of square free numbers                                    %
            sf100     :=            countSquareFree(      1,     100 );
            sf1000    := sf100    + countSquareFree(    101,    1000 );
            sf10000   := sf1000   + countSquareFree(   1001,   10000 );
            sf100000  := sf10000  + countSquareFree(  10001,  100000 );
            sf1000000 := sf100000 + countSquareFree( 100001, 1000000 );
            write( i_w := 6, s_w := 0, "square free numbers between 1 and     100: ", sf100     );
            write( i_w := 6, s_w := 0, "square free numbers between 1 and    1000: ", sf1000    );
            write( i_w := 6, s_w := 0, "square free numbers between 1 and   10000: ", sf10000   );
            write( i_w := 6, s_w := 0, "square free numbers between 1 and  100000: ", sf100000  );
            write( i_w := 6, s_w := 0, "square free numbers between 1 and 1000000: ", sf1000000 )
        end
    end
end.
