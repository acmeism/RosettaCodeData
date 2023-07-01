begin % sum the primes below n and report the sums that are prime             %
    integer MAX_NUMBER;
    MAX_NUMBER := 999;
    begin
        logical array prime( 1 :: MAX_NUMBER );
        integer       primeCount, primeSum, primeSumCount;
        % sieve the primes to MAX_NUMBER                                      %
        prime( 1 ) := false; prime( 2 ) := true;
        for i := 3 step 2 until MAX_NUMBER do prime( i ) := true;
        for i := 4 step 2 until MAX_NUMBER do prime( i ) := false;
        for i := 3 step 2 until truncate( sqrt( MAX_NUMBER ) ) do begin
            integer ii; ii := i + i;
            if prime( i ) then begin
                for p := i * i step ii until MAX_NUMBER do prime( p ) := false
            end if_prime_i
        end for_i ;
        % find the prime sums that are prime                                  %
        primeCount := primeSum := primeSumCount := 0;
        write( "prime  prime" );
        write( "count    sum" );
        for i := 1 until MAX_NUMBER do begin
            if prime( i ) then begin
                % have another prime                                          %
                logical isPrime;
                primeSum   := primeSum + i;
                primeCount := primeCount + 1;
                % check whether the prime sum is also prime                   %
                isPrime := true;
                for p := 1 until i div 2 do begin
                    if prime( p ) then begin
                        isPrime := primeSum rem p not = 0;
                        if not isPrime then goto endPrimeCheck
                    end if_prime_p
                end for_p ;
endPrimeCheck:
                if isPrime then begin
                    % the prime sum is also prime                             %
                    primeSumCount := primeSumCount + 1;
                    write( i_w := 5, s_w := 0
                         , primeCount
                         , " "
                         , i_w := 6
                         , primeSum
                         )
                end if_isPrime
            end if_prime_i
        end for_i ;
        write();
        write( i_w := 1, s_w := 0
             , "Found "
             , primeSumCount
             , " prime sums of primes below "
             , MAX_NUMBER + 1
             )
    end
end.
