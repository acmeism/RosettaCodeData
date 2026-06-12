begin % find some De Polignac numbers - positive odd numbers that can't be    %
      % written as p + 2^n for some prime p and integer n                     %
    integer MAX_NUMBER;                     % maximum number we will consider %
    integer MAX_POWER;                      % maximum powerOf2 < MAX_NUMBER   %
    MAX_NUMBER := 500000;
    MAX_POWER  :=     20;
    begin
        logical array prime      ( 0 :: MAX_NUMBER );
        integer array powersOf2  ( 1 :: MAX_POWER  );
        integer dpCount;
        % sieve the primes to MAX_NUMBER                                      %
        begin
            integer rootMaxNumber;
            rootMaxNumber:= entier( sqrt( MAX_NUMBER ) );
            prime( 0 ) := prime( 1 ) := false;
            prime( 2 ) := true;
            for i := 3 step 2 until MAX_NUMBER do prime( i ) := true;
            for i := 4 step 2 until MAX_NUMBER do prime( i ) := false;
            for i := 3 step 2 until rootMaxNumber do begin
                if prime( i ) then begin
                    integer i2;
                    i2 := i + i;
                    for s := i * i step i2 until MAX_NUMBER do prime( s ) := false
                end if_prime_i_and_i_lt_rootMaxNumber
            end for_i
        end;
        % table of powers of 2 greater than 2^0 ( up to around 2 000 000 )    %
        %       increase the table size if MAX_NUMBER > 2 000 000             %
        begin
            integer p2;
            p2 := 1;
            for i := 1 until MAX_POWER do begin
                p2             := p2 * 2;
                powersOf2( i ) := p2
            end for_i
        end;
        % the numbers must be odd and not of the form p + 2^n                 %
        % either p is odd and 2^n is even and hence n > 0 and p > 2           %
        %     or 2^n is odd and p is even and hence n = 0 and p = 2           %
        % n = 0, p = 2 - the only possibility is 3                            %
        dpCount := 0;
        for i := 1 step 2 until 3 do begin
            integer p;
            p := 2;
            if p + 1 not = i then begin
                dpCount := dpCount + 1;
                writeon( i_w := 5, i )
            end if_p_plus_1_ne_i
        end for_i ;
        % n > 0, p > 2                                                        %
        for i := 5 step 2 until MAX_NUMBER do begin
            logical found;
            integer p;
            found := false;
            p := 1;
            while p <= MAX_POWER and not found and i > powersOf2( p ) do begin
                found := prime( i - powersOf2( p ) );
                p     := p + 1
            end while_not_found_and_have_a_suitable_power ;
            if not found then begin
                dpCount := dpCount + 1;
                if dpCount <= 50 then begin
                    writeon( i_w := 5, i );
                    if dpCount rem 10 = 0 then write()
                    end
                else if dpCount = 1000 or dpCount = 10000 then begin
                    write( i_w := 5, s_w := 0, "The ", dpCount
                         , "th De Polignac number is ", i
                         )
                end if_various_DePolignac_numbers
            end if_not_found
        end for_i;
        write( i_w := 1, s_w := 0
             , "Found ", dpCount, " De Polignac numbers up to ", MAX_NUMBER
             )
    end
end.
