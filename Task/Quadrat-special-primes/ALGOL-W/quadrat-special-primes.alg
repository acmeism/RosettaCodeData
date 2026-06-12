begin % find some primes where the gap between the current prime and the next is a square %
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
    % sets s( 1 :: n ) to the squares %
    procedure getSquares ( integer array s ( * ) ; integer value n ) ;
        for i := 1 until n do s( i ) := i * i;
    integer MAX_NUMBER;
    MAX_NUMBER := 16000;
    begin
        logical array prime(  1 :: MAX_NUMBER );
        integer array square( 1 :: MAX_NUMBER );
        integer       pCount, thisPrime, nextPrime;
        % sieve the primes to MAX_NUMBER %
        Eratosthenes( prime, MAX_NUMBER );
        % calculate the squares to MAX_NUMBER %
        getSquares( square, MAX_NUMBER );
        % the first gap is 1 (between 2 and 3) the gap between all other primes is even %
        % so we treat 2-3 as a special case                                             %
        pCount := 1; thisPrime := 2; nextPrime := 3;
        write( i_w := 6, s_w := 0, " ", thisPrime );
        while nextPrime < MAX_NUMBER do begin
            integer sqPos;
            thisPrime := nextPrime;
            pCount := pCount + 1;
            writeon( i_w := 6, s_w := 0, " ", thisPrime );
            if pCount rem 12 = 0 then write();
            sqPos := 2;
            while begin
                nextPrime := thisPrime + square( sqPos );
                nextPrime < MAX_NUMBER and not prime( nextPrime )
            end do sqPos := sqPos + 2;
        end while_thisPrime_lt_MAX_NUMBER
    end
end.
