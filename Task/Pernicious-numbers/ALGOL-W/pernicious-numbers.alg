begin % find some pernicious numbers: numbers with a prime population count %
    % returns the population count of n                                     %
    integer procedure populationCount( integer value  n ) ;
    begin
        integer v, count;
        count := 0;
        v     := abs n;
        while v > 0 do begin
            if odd( v ) then count := count + 1;
            v := v div 2
        end while_v_gt_0 ;
        count
    end populationCount ;
    % sets p( 1 :: n ) to a sieve of primes up to n                         %
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
    % returns true if p is pernicious, false otherwise, s must be a sieve   %
    %         of primes upto 32                                             %
    logical procedure isPernicious ( integer value p; logical array s ( * ) ) ; p > 0 and s( populationCount( p ) );
    % find the pernicious numbers %
    begin
        % as we are dealing with 32 bit numbers, the maximum possible       %
        % population is 32                                                  %
        logical array isPrime ( 1 :: 32 );
        integer       p, pCount;
        Eratosthenes( isPrime, 32 );
        % show the first 25 pernicious numbers                              %
        pCount := 0;
        p      := 2; % 0 and 1 aren't pernicious, so start at 2             %
        while pCount < 25 do begin
            if isPernicious( p, isPrime ) then begin
                % have a pernicious number                                  %
                pCount := pCount + 1;
                writeon( i_w := 1, s_w := 0, " ", p )
            end if_pernicious_p ;
            p := P + 1
        end for_p ;
        write();
        % find the pernicious numbers between 888 888 877 and 888 888 888   %
        for p := 888888877 until 888888888 do begin
            if isPernicious( p, isPrime ) then writeon( i_w := 1, s_w := 0, " ", p )
        end for_p ;
        write();
    end
end.
