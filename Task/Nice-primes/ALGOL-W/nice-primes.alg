begin % find some nice primes - primes whose digital root is prime           %
    % returns the digital root of n in base 10                               %
    integer procedure digitalRoot( integer value  n ) ;
        if n = 0 then 0
        else begin
            integer root;
            root := ( abs n ) rem 9;
            if root = 0 then 9 else root
        end digitalRoot ;
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
    integer MIN_PRIME, MAX_PRIME;
    MIN_PRIME :=  501;
    MAX_PRIME :=  999;
    % find the nice primes in the exclusive range 500 < prime < 1000 %
    begin
        logical array p ( 1 :: MAX_PRIME );
        integer       nCount;
        % construct a sieve of primes up to the maximum required     %
        Eratosthenes( p, MAX_PRIME );
        % show the primes that are nice                              %
        write( i_w := 1, s_w := 0, "Nice primes from ", MIN_PRIME, " to ", MAX_PRIME );
        for i := MIN_PRIME until MAX_PRIME do begin
            if p( i ) then begin
                integer dr;
                dr := digitalRoot( i );
                if p( dr ) then begin
                    nCount := nCount + 1;
                    write( i_w := 3, s_w := 0, nCount, ":", i, "  dr(", i_w := 1, dr, ")" )
                end if_dr_p
            end if_p_i
        end for_i
    end
end.
