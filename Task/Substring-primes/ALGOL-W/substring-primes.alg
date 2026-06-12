begin % find primes where every substring of the digits is also priome %
    % sets p( 1 :: n ) to a sieve of primes up to n %
    procedure Eratosthenes ( logical array p( * ) ; integer value n ) ;
    begin
        p( 1 ) := false; p( 2 ) := true;
        for i := 3 step 2 until n do p( i ) := true;
        for i := 4 step 2 until n do p( i ) := false;
        for i := 3 step 2 until truncate( sqrt( n ) ) do begin
            integer ii; ii := i + i;
            if p( i ) then for s := i * i step ii until n do p( s ) := false
        end for_i ;
    end Eratosthenes ;
    % it can be shown that all the required primes are under 1000, however we will %
    % not assume this, so we will allow for 4 digit numbers                        %
    integer MAX_NUMBER, MAX_SUBSTRING;
    MAX_NUMBER    := 10000;
    MAX_SUBSTRING := 100; % assume there will be at most 100 such primes           %
    begin
        logical array prime(  1 :: MAX_NUMBER    );
        integer array sPrime( 1 :: MAX_SUBSTRING );
        integer       tCount, sCount, sPos;
        % adds a substring prime to the list %
        procedure addPrime ( integer value p ) ;
        begin
            sCount := sCount + 1;
            sPrime( sCount ) := p;
            writeon( i_w := 1, s_w := 0, " ", p )
        end addPrime ;
        % sieve the primes to MAX_NUMBER %
        Eratosthenes( prime, MAX_NUMBER );
        % clearly, the 1 digit primes are all substring primes %
        sCount := 0;
        for i := 1 until MAX_SUBSTRING do sPrime( i ) := 0;
        for i := 2, 3, 5, 7 do addPrime( i );
        % the subsequent primes can only have 3 or 7 as a final digit as they must end  %
        % with a prime digit and 2 and 5 would mean the number was divisible by 2 or 5  %
        % as all substrings on the prime must also be prime, 33 and 77 are not possible %
        % final digit pairs                                                             %
        sPos := 1;
        while sPrime( sPos ) not = 0 do begin
            integer n3, n7;
            n3 := ( sPrime( sPos ) * 10 ) + 3;
            n7 := ( sPrime( sPos ) * 10 ) + 7;
            if sPrime( sPos ) rem 10 not = 3 and prime( n3 ) then addPrime( n3 );
            if sPrime( sPos ) rem 10 not = 7 and prime( n7 ) then addPrime( n7 );
            sPos := sPos + 1
        end while_sPrime_sPos_ne_0 ;
        write( i_w := 1, s_w := 0, "Found ", sCount, " substring primes" )
    end
end.
