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
        for i := 2 until truncate( sqrt( n ) )
        do begin
            if s( i )
            then begin
                for p := i * i step i until n do s( p ) := false
            end if_s_i
        end for_i ;

    end sieve ;

    % test the sieve procedure                                               %

    integer sieveMax;

    sieveMax := 100;
    begin

        logical array s ( 1 :: sieveMax );

        i_w := 2; % set output field width                                   %
        s_w := 1; % and output separator width                               %

        % find and display the primes                                        %
        sieve( s, sieveMax );
        for i := 1 until sieveMax do if s( i ) then writeon( i );

    end

end.
