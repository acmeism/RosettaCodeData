begin
    % find some sexy primes - primes that differ from another prime by 6     %
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
    % adds a prime to list of sexy/unsexy primes                             %
    procedure addPrime ( integer value p
                       ; integer array list ( * )
                       ; integer value len
                       ) ;
    begin
        % increment count, shuffle down the primes and add the new one       %
        list( 0 ) := list( 0 ) + 1;
        for i := 1 until len - 1 do list( i ) := list( i + 1 );
        list( len ) := p
    end addPrime ;
    % counts the number of pairs of sexy primes, triplets, quadruplest and   %
    % quintuplets up to n                                                    %
    % the counts of each kind are returned in the 0 element of the arrays    %
    % the last 5 ( or less if there are less than 5 ) of each type of sexy   %
    % prime is returned in the array elements 1 to 5                         %
    procedure countSexyPrimes ( logical array s ( * )
                              ; integer value n
                              ; integer array pairs, triplets, quadruplets, quintuplets ( * )
                              ) ;
    begin
        integer pos2, pos3, pos4, pos5;
        for i := 0 until 5 do pairs( i ) := triplets( i ) := quadruplets( i ) := quintuplets( i ) := 0;
        % look for pairs etc. up to n                                        %
        % 2 cannot be a sexy prime as it is the only even prime, thus:       %
        %     pairs can start at 7, triplets at 13, quadruplets at 19 and    %
        %     quintuplets at 25                                              %
        for p := 7 step 2 until 11 do begin
            if s( p ) and s( p - 6 ) then addPrime( p, pairs, 5 )
        end for_p ;
        for p := 13 step 2 until 17 do begin
            if s( p ) and s( p - 6 )                 then addPrime( p, pairs,       5 );
            if s( p ) and s( p - 6 ) and s( p - 12 ) then addPrime( p, triplets,    5 )
        end for_p ;
        for p := 19 step 2 until 23 do begin
            if s( p ) and s( p - 6 )                 then addPrime( p, pairs,       5 );
            if s( p ) and s( p - 6 ) and s( p - 12 ) then addPrime( p, triplets,    5 );
            if s( p ) and s( p - 6 ) and s( p - 12 ) and s( p - 18 )
                                                     then addPrime( p, quadruplets, 5 )
        end for_p ;
        pos5 := 1;
        pos4 := pos5 + 6;
        pos3 := pos4 + 6;
        pos2 := pos3 + 6;
        for p := pos2 + 6 step 2 until n do begin
            if s( p ) then begin
                if s( pos2 ) then begin % sexy pair                          %
                    addPrime( p, pairs, 5 );
                    if s( pos3 ) then begin % sexy triplet                   %
                        addPrime( p, triplets, 5 );
                        if s( pos4 ) then begin % sexy quadruplet            %
                            addPrime( p, quadruplets, 5 );
                            if s( pos5 ) then begin % sexy quintuplet        %
                                addPrime( p, quintuplets, 5 )
                            end if_s_pos5
                        end if_s_pos4
                    end if_s_pos3
                end if_s_pos2
            end if_s_p ;
            pos2 := pos2 + 2;
            pos3 := pos3 + 2;
            pos4 := pos4 + 2;
            pos5 := pos5 + 2
        end for_p
    end countSexyPrimes ;
    % counts the number of unsexy primes up to n                             %
    % the count is returned in the 0 element of the array                    %
    % the last 5 ( or less if there are less than 5 ) unsexy prime is        %
    % returned in the array elements 1 to 10                                 %
    procedure countUnsexyPrimes ( logical array s ( * )
                                ; integer value n
                                ; integer array unsexy ( * )
                                ) ;
    begin
        for i := 0 until 10 do unsexy( i ) := 0;
        for p := 2, 3, 5 do begin % handle primes below 7 separately         %
            if s( p ) and not s( p + 6 ) then addPrime( p, unsexy, 10 )
        end for_p ;
        for p := 7 step 2 until n do begin
            if s( p ) and not s( p - 6 ) and not s( p + 6 ) then addPrime( p, unsexy, 10 )
        end for_p
    end countUnsexyPrimes ;
    % shows sexy prime pairs                                                 %
    procedure showPrimes ( integer    value elements
                         ; integer    array primes ( * )
                         ; integer    value arrayMax
                         ; string(24) value title
                         ; integer    value maxPrime
                         ) ;
    begin
        write( i_w := 8, s_w := 0, "Found ", primes( 0 ), " ", title, " below ", maxPrime + 1
             , i_w := 2, "; last ", ( if primes( 0 ) > arrayMax then arrayMax else primes( 0 ) ), ":"
             );
        write( i_w := 1, s_w := 0, "    " );
        for p := 1 until arrayMax do begin
            if primes( p ) not = 0 then begin
                integer pn;
                if elements > 1 then writeon( "(" );
                pn := primes( p ) - ( ( elements - 1 ) * 6 );
                for i := 1 until elements do begin
                    writeon( i_w := 1, s_w := 0, " ", pn );
                    pn := pn + 6
                end for_i ;
                if elements > 1 then writeon( " ) " );
            end if_primes_p_ne_0
        end for_p
    end showPrimes ;
    integer MAX_SEXY, MAX_PRIME;
    % for the task, we need to consider primes up to 1 000 035               %
    % however we must still recognise sexy primes up that limit, so we sieve %
    % up to 1 000 035 + 6                                                    %
    MAX_SEXY  := 1000000 + 35;
    MAX_PRIME := MAX_SEXY + 6;
    begin
        logical array s ( 1 :: MAX_PRIME );
        integer array pairs, triplets, quadruplets, quintuplets ( 0 ::  5 );
        integer array unsexy                                    ( 0 :: 10 );
        sieve( s, MAX_PRIME );
        countSexyPrimes( s, MAX_SEXY, pairs, triplets, quadruplets, quintuplets );
        countUnsexyPrimes( s, MAX_SEXY, unsexy );
        showPrimes( 2, pairs,        5, "sexy prime pairs",       MAX_SEXY );
        showPrimes( 3, triplets,     5, "sexy prime triplets",    MAX_SEXY );
        showPrimes( 4, quadruplets,  5, "sexy prime quadruplets", MAX_SEXY );
        showPrimes( 5, quintuplets,  5, "sexy prime quintuplets", MAX_SEXY );
        showPrimes( 1, unsexy,      10, "unsexy primes",          MAX_SEXY )
    end
end.
