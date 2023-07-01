begin % find some Brazilian numbers - numbers N whose representation in some %
      % base B ( 1 < B < N-1 ) has all the same digits                       %
    % set b( 1 :: n ) to a sieve of Brazilian numbers where b( i ) is true   %
    % if i is Brazilian and false otherwise - n must be at least 8           %
    procedure BrazilianSieve ( logical array b ( * ) ; integer value n ) ;
    begin
        logical isEven;
        % start with even numbers flagged as Brazilian and odd numbers as    %
        % non-Brazilian                                              %
        isEven := false;
        for i := 1 until n do begin
            b( i ) := isEven;
            isEven := not isEven
        end for_i ;
        % numbers below 7 are not Brazilian (see task notes)                 %
        for i := 1 until 6 do b( i ) := false;
        % flag all 33, 55, etc. numbers in each base as Brazilian            %
        % No Brazilian number can have a representation of 11 in any base B  %
        %    as that would mean B + 1 = N, which contradicts B < N - 1       %
        % also, no need to consider even digits as we know even numbers > 6  %
        %    are all Brazilian                                               %
        for base := 2 until n div 2 do begin
            integer b11, bnn;
            b11 := base + 1;
            bnn := b11;
            for digit := 3 step 2 until base - 1 do begin
                bnn := bnn + b11 + b11;
                if bnn <= n
                then b( bnn ) := true
                else goto end_for_digits
            end for_digits ;
end_for_digits:
        end for_base ;
        % handle 111, 1111, 11111, ..., 333, 3333, ..., etc.                 %
        for base := 2 until truncate( sqrt( n ) ) do begin
            integer powerMax;
            powerMax := MAXINTEGER div base;              % avoid 32 bit     %
            if powerMax > n then powerMax := n;           % integer overflow %
            for digit := 1 step 2 until base - 1 do begin
                integer bPower, bN;
                bPower := base * base;
                bN     := digit * ( bPower + base + 1 ); % ddd               %
                while bN <= n and bPower <= powerMax do begin
                    if bN <= n then begin
                        b( bN ) := true
                    end if_bN_le_n ;
                    bPower := bPower * base;
                    bN     := bN + ( digit * bPower )
                end while_bStart_le_n
            end for_digit
        end for_base ;
    end BrazilianSieve ;
    % sets p( 1 :: n ) to a sieve of primes up to n                          %
    procedure Eratosthenes ( logical array p( * ) ; integer value n ) ;
    begin
        p( 1 ) := false; p( 2 ) := true;
        for i := 3 step 2 until n do p( i ) := true;
        for i := 4 step 2 until n do p( i ) := false;
        for i := 2 until truncate( sqrt( n ) ) do begin
            integer ii; ii := i + i;
            if p( i ) then for pr := i * i step ii until n do p( pr ) := false
        end for_i ;
    end Eratosthenes ;

    integer MAX_NUMBER;
    MAX_NUMBER := 2000000;
    begin
        logical array b ( 1 :: MAX_NUMBER );
        logical array p ( 1 :: MAX_NUMBER );
        integer bCount;
        BrazilianSieve( b, MAX_NUMBER );
        write( "The first 20 Brazilian numbers:" );write();
        bCount := 0;
        for bPos := 1 until MAX_NUMBER do begin
            if b( bPos ) then begin
                bCount := bCount + 1;
                writeon( i_w := 1, s_w := 0, " ", bPos );
                if bCount >= 20 then goto end_first_20
            end if_b_bPos
        end for_bPos ;
end_first_20:
        write();write( "The first 20 odd Brazilian numbers:" );write();
        bCount := 0;
        for bPos := 1 step 2 until MAX_NUMBER do begin
            if b( bPos ) then begin
                bCount := bCount + 1;
                writeon( i_w := 1, s_w := 0, " ", bPos );
                if bCount >= 20 then goto end_first_20_odd
            end if_b_bPos
        end for_bPos ;
end_first_20_odd:
        write();write( "The first 20 prime Brazilian numbers:" );write();
        Eratosthenes( p, MAX_NUMBER );
        bCount := 0;
        for bPos := 1 until MAX_NUMBER do begin
            if b( bPos ) and p( bPos ) then begin
                bCount := bCount + 1;
                writeon( i_w := 1, s_w := 0, " ", bPos );
                if bCount >= 20 then goto end_first_20_prime
            end if_b_bPos
        end for_bPos ;
end_first_20_prime:
        write();write( "Various Brazilian numbers:" );
        bCount := 0;
        for bPos := 1 until MAX_NUMBER do begin
            if b( bPos ) then begin
                bCount := bCount + 1;
                if   bCount  =     100
                or   bCount  =    1000
                or   bCount  =   10000
                or   bCount  =  100000
                or   bCount  = 1000000
                then write( s_w := 0, bCount, "th Brazilian number: ", bPos );
                if   bCount >= 1000000 then goto end_1000000
            end if_b_bPos
        end for_bPos ;
end_1000000:
    end
end.
