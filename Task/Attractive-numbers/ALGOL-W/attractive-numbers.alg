% find some attractive numbers - numbers whose prime factor count is prime   %
begin
    % implements the sieve of Eratosthenes                                   %
    %     s(i) is set to true if i is prime, false otherwise                 %
    %     algol W doesn't have a upb operator, so we pass the size of the    %
    %     array in n                                                         %
    procedure sieve( logical array s ( * ); integer value n ) ;
    begin
        % start with everything flagged as prime                             %
        for i := 1 until n do s( i ) := true;
        % sieve out the non-primes                                           %
        s( 1 ) := false;
        for i := 2 until truncate( sqrt( n ) ) do begin
            if s( i ) then for p := i * i step i until n do s( p ) := false
        end for_i ;
    end sieve ;
    % returns the count of prime factors of n, using the sieve of primes s   %
    %         n must be greater than 0                                       %
    integer procedure countPrimeFactors ( integer value n; logical array s ( * ) ) ;
    if s( n ) then 1
    else begin
        integer count, rest;
        rest  := n;
        count := 0;
        while rest rem 2 = 0 do begin
            count := count + 1;
            rest  := rest div 2
        end while_divisible_by_2 ;
        for factor := 3 step 2 until n - 1 do begin
            if s( factor ) then begin
                while rest > 1 and rest rem factor = 0 do begin
                    count := count + 1;
                    rest  := rest div factor
                end while_divisible_by_factor
            end if_prime_factor
        end for_factor ;
        count
    end countPrimeFactors ;
    % maximum number for the task                                            %
    integer maxNumber;
    maxNumber := 120;
    % show the attractive numbers                                            %
    begin
        logical array s ( 1 :: maxNumber );
        sieve( s, maxNumber );
        i_w := 2; % set output field width                                   %
        s_w := 1; % and output separator width                               %
        % find and display the attractive numbers                            %
        for i := 2 until maxNumber do if s( countPrimeFactors( i, s ) ) then writeon( i )
    end
end.
