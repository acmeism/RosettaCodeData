begin % find numbers n such that n + n+1 is prime                            %

    % sets s to a sieve of primes, using the sieve of Eratosthenes           %
    procedure sieve( logical array s ( * ); integer value n ) ;
    begin
        % start with everything flagged as prime                             %
        for i := 1 until n do s( i ) := true;
        % sieve out the non-primes                                           %
        s( 1 ) := false;
        for i := 2 until truncate( sqrt( n ) )
        do begin
            if s( i )
            then begin
                for p := i * i step i until n do s( p ) := false
            end if_s_i
        end for_i ;
    end sieve ;

    integer sieveMax;
    sieveMax := 200;
    begin
        logical array prime ( 1 :: sieveMax );
        integer count, n, n1;
        i_w := 2; % set output integer field width                           %
        s_w := 1; % and output separator width                               %

        % find and display the numbers                                       %
        sieve( prime, sieveMax );
        count := 0;
        n1    := 1;
        while count < 20 do begin
            n  := n1;
            n1 := n1 + 1;
            if prime( n + n1 ) then begin
                count := count + 1;
                write( count, ": ", n, " + ", n1, " = ", n + n1 )
            end if_prime__n_plus_n1
        end while_count_lt_20
    end

end.
