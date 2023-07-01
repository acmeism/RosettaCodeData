begin
    % find some Magnanimous numbers - numbers where inserting a "+" between  %
    % any two of the digits and evaluating the sum results in a prime number %
    % implements the sieve of Eratosthenes                                   %
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
    % construct an array of magnanimous numbers using the isPrime sieve      %
    procedure findMagnanimous ( logical array magnanimous, isPrime ( * ) ) ;
    begin
        % 1 digit magnanimous numbers                                        %
        for i :=  0 until 9               do magnanimous( i ) := true;
        % initially, the other magnanimous numbers are unknown               %
        for i := 10 until MAGNANIMOUS_MAX do magnanimous( i ) := false;
        % 2 & 3 digit magnanimous numbers                                    %
        for d1 := 1 until 9 do begin
            for d2 := 0 until 9 do begin
                if isPrime( d1 + d2 ) then magnanimous( ( d1 * 10 ) + d2 ) := true
            end for_d2 ;
            for d23 := 0 until 99 do begin
                if isPrime( d1 + d23 ) then begin
                    integer d12, d3;
                    d3  := d23 rem 10;
                    d12 := ( d1 * 10 ) + ( d23 div 10 );
                    if isPrime( d12 + d3 ) then magnanimous( ( d12 * 10 ) + d3 ) := true
                end if_isPrime_d1_plus_d23
            end for_d23
        end for_d1 ;
        % 4 & 5 digit magnanimous numbers                                    %
        for d12 := 10 until 99 do begin
            for d34 := 0 until 99 do begin
                if isPrime( d12 + d34 ) then begin
                    integer d123, d4;
                    d123 := ( d12 * 10 ) + ( d34 div 10 );
                    d4   := d34 rem 10;
                    if isPrime( d123 + d4 ) then begin
                        integer d1, d234;
                        d1   := d12 div 10;
                        d234 := ( ( d12 rem 10 ) * 100 ) + d34;
                        if  isPrime( d1 + d234 ) then magnanimous( ( d12 * 100 ) + d34 ) := true
                    end if_isPrime_d123_plus_d4
                end if_isPrime_d12_plus_d34
            end for_d34 ;
            for d345 := 0 until 999 do begin
                if isPrime( d12 + d345 ) then begin
                    integer d123, d45;
                    d123 := ( d12 * 10 ) + ( d345 div 100 );
                    d45  := d345 rem 100;
                    if isPrime( d123 + d45 ) then begin
                        integer d1234, d5;
                        d1234 := ( d123 * 10 ) + ( d45 div 10 );
                        d5    := d45 rem 10;
                        if isPrime( d1234 + d5 ) then begin
                            integer d1, d2345;
                            d1    := d12 div 10;
                            d2345 := ( ( d12 rem 10 ) * 1000 ) + d345;
                            if isPrime( d1 + d2345 ) then magnanimous( ( d12 * 1000 ) + d345 ) := true
                        end if_isPrime_d1234_plus_d5
                    end if_isPrime_d123_plus_d45
                end if_isPrime_d12_plus_d345
            end for_d234
        end for_d12 ;
        % find 6 digit magnanimous numbers                                   %
        for d123 := 100 until 999 do begin
            for d456 := 0 until 999 do begin
                if isPrime( d123 + d456 ) then begin
                    integer d1234, d56;
                    d1234 := ( d123 * 10 ) + ( d456 div 100 );
                    d56   := d456 rem 100;
                    if isPrime( d1234 + d56 ) then begin
                        integer d12345, d6;
                        d12345 := ( d1234 * 10 ) + ( d56 div 10 );
                        d6     := d56 rem 10;
                        if isPrime( d12345 + d6 ) then begin
                            integer d12, d3456;
                            d12   := d123 div 10;
                            d3456 := ( ( d123 rem 10 ) * 1000 ) + d456;
                            if isPrime( d12 + d3456 ) then begin
                                integer d1, d23456;
                                d1     := d12 div 10;
                                d23456 := ( ( d12 rem 10 ) * 10000 ) + d3456;
                                if isPrime( d1 + d23456 ) then magnanimous( ( d123 * 1000 ) + d456 ) := true
                            end if_isPrime_d12_plus_d3456
                        end if_isPrime_d12345_plus_d6
                    end if_isPrime_d1234_plus_d56
                end if_isPrime_d123_plus_d456
            end for_d456
        end for_d123
    end findMagnanimous ;
    % we look for magnanimous numbers with up to 6 digits, so we need to     %
    % check for primes up to 99999 + 9 = 100008                              %
    integer PRIME_MAX, MAGNANIMOUS_MAX;
    PRIME_MAX       :=  100008;
    MAGNANIMOUS_MAX := 1000000;
    begin
        logical array magnanimous ( 0 :: MAGNANIMOUS_MAX );
        logical array isPrime     ( 1 :: PRIME_MAX       );
        integer mPos;
        integer lastM;
        sieve( isPrime, PRIME_MAX );
        findMagnanimous( magnanimous, isPrime );
        % show some of the magnanimous numbers                               %
        lastM := mPos  := 0;
        i_w := 3; s_w := 1; % output formatting                              %
        for i := 0 until MAGNANIMOUS_MAX do begin
            if magnanimous( i ) then begin
                mPos  := mPos + 1;
                lastM := i;
                if      mPos =   1 then begin
                    write( "Magnanimous numbers 1-45:" );
                    write( i )
                    end
                else if mPos < 46 then begin
                    if mPos rem 15 = 1 then write( i )
                                       else writeon( i )
                    end
                else if mPos = 241 then begin
                    write( "Magnanimous numbers 241-250:" );
                    write( i )
                    end
                else if mPos > 241 and mPos <= 250 then writeon( i )
                else if mPos = 391 then begin
                    write( "Magnanimous numbers 391-400:" );
                    write( i )
                    end
                else if mPos > 391 and mPos <= 400 then writeon( i )
            end if_magnanimous_i
        end for_i ;
        i_w := 1; s_w := 0;
        write( "Last magnanimous number found: ", mPos, " = ", lastM )
    end
end.
