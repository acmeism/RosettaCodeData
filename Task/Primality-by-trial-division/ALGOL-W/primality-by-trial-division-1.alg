% returns true if n is prime, false otherwise %
% uses trial division                         %
logical procedure isPrime ( integer value n ) ;
    if n < 3 or not odd( n ) then n = 2
    else begin
        % odd number > 2 %
        integer f, rootN;
        logical havePrime;
        f         := 3;
        rootN     := entier( sqrt( n ) );
        havePrime := true;
        while f <= rootN and havePrime do begin
            havePrime := ( n rem f ) not = 0;
            f         := f + 2
        end;
        havePrime
    end isPrime ;
