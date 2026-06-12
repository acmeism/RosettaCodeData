begin % find some Mersenne Primrs - primes of the form 2^n - 1, n must be prime %
    % integers are 32 bit in Algol W, so there won't be many numbers to check   %
    % we handle 2 as a special case and then the odd numbers starting at 3      %

    % simplified primality by trial division test - no need to check for even   %
    % numbers as 2^n - 1 is always odd for n >= 2                               %
    logical procedure oddOnlyPrimalityTest ( integer value n ) ;
    begin
        logical isPrime;
        isPrime := true;
        for i := 3 step 2 until entier( sqrt( n ) ) do begin;
            isPrime := n rem i not = 0;

            if not isPrime then goto endPrimalityTest
        end for_i;
endPrimalityTest: isPrime
    end oddOnlyPrimalityTest ;

    integer p2, n;
    n  := 1;
    p2 := 2;
    while
        begin
            if n < 3 then begin
                n  := n  + 1;
                p2 := p2 * 2
                end
            else begin
                n  := n  + 2;
                p2 := p2 * 4
            end if_n_le_3__ ;;
            if oddOnlyPrimalityTest( p2 - 1 ) then writeon( i_w := 1, s_w := 0, " ", n );
            n < 29
        end
    do begin end ;
    % MAXINTEGER is 2**31 - 1                                                   %
    if oddOnlyPrimalityTest( MAXINTEGER ) then writeon( i_w := 1, s_w := 0, " ", 31 );
end.
