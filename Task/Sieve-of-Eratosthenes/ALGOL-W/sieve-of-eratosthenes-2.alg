begin
    % implements the sieve of Eratosthenes                                   %
    % only odd numbers appear in the sieve, which starts at 3                %
    % s( i ) is set to true if ( i * 2 ) + 1 is prime                        %
    procedure sieve2( logical array s ( * ); integer value n ) ;
    begin
        % start with everything flagged as prime                             %
        for i := 1 until n do s( i ) := true;
        % sieve out the non-primes                                           %
        % the subscripts of s are  1  2  3  4  5  6  7  8  9 10 11 12 13...  %
        %      which correspond to 3  5  7  9 11 13 15 17 19 21 23 25 27...  %
        for i := 1 until truncate( sqrt( n ) ) do begin
            if s( i ) then begin
                integer ip;
                ip := ( i * 2 ) + 1;
                for p := i + ip step ip until n do s( p ) := false
            end if_s_i
        end for_i ;
    end sieve2 ;
    % test the sieve2 procedure                                              %
    integer primeMax, arrayMax;
    primeMax := 100;
    arrayMax := ( primeMax div 2 ) - 1;
    begin
        logical array s ( 1 :: arrayMax);
        i_w := 2; % set output field width                                   %
        s_w := 1; % and output separator width                               %
        % find and display the primes                                        %
        sieve2( s, arrayMax );
        write( 2 );
        for i := 1 until arrayMax do if s( i ) then writeon( ( i * 2 ) + 1 );
    end
end.
