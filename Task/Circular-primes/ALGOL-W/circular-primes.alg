begin % find circular primes - primes where all cyclic permutations  %
      % of the digits are also prime                                 %
    % sets p( 1 :: n ) to a sieve of primes up to n %
    procedure Eratosthenes ( logical array p( * ) ; integer value n ) ;
    begin
        p( 1 ) := false; p( 2 ) := true;
        for i := 3 step 2 until n do p( i ) := true;
        for i := 4 step 2 until n do p( i ) := false;
        for i := 3 step 2 until truncate( sqrt( n ) ) do begin
            integer ii; ii := i + i;
            if p( i ) then for pr := i * i step ii until n do p( pr ) := false
        end for_i ;
    end Eratosthenes ;
    % find circular primes in p in the range lo to hi, if they are circular, flag the %
    % permutations as non-prime so we do not consider them again                      %
    % non-circular primes are also flageed as non-prime                               %
    % lo must be a power of ten and hi must be at most ( lo * 10 ) - 1                %
    procedure keepCircular ( logical array p ( * ); integer value lo, hi ) ;
        for n := lo until hi do begin
            if p( n ) then begin
                % have a prime %
                integer       c, pCount;
                logical       isCircular;
                integer array permutations ( 1 :: 10 );
                c          := n;
                isCircular := true;
                pCount     := 0;
                % cyclically permute c until we get back to p or find a non-prime value for c %
                while begin
                    integer first, rest;
                    first      := c div lo;
                    rest       := c rem lo;
                    c          := ( rest * 10 ) + first;
                    isCircular := p( c );
                    c not = n and isCircular
                end do begin
                    pCount := pCount + 1;
                    permutations( pCount ) := c
                end while_have_another_prime_permutation ;
                if not isCircular
                then p( n ) := false
                else begin
                    % have a circular prime - flag the permutations as non-prime %
                    for i := 1 until pCount do p( permutations( i ) ) := false
                end if_not_isCircular__
            end if_p_n
        end keepCircular ;
    integer       cCount;
    % sieve the primes up to 999999 %
    logical array p ( 1 ::   999999 );
    Eratosthenes( p,         999999 );
    % remove non-circular primes from the sieve %
    % the single digit primes are all circular so we start at 10 %
    keepCircular( p,     10,     99 );
    keepCircular( p,    100,    999 );
    keepCircular( p,   1000,   9999 );
    keepCircular( p,  10000,  99999 );
    keepCircular( p, 100000, 200000 );
    % print the first 19 circular primes %
    cCount := 0;
    write( "First 19 circular primes: " );
    for i := 1 until 200000 do begin
        if p( i ) then begin
            writeon( i_w := 1, s_w := 1, i );
            cCount := cCount + 1;
            if cCount = 19 then goto end_circular
        end if_p_i
    end for_i ;
end_circular:
end.
