begin
    % use the isPrime procedure from the Primality by Trial Division task     %
    logical procedure isPrime ( integer value n ) ; algol "isPrime" ;
    % sets the elements of p to the first n primes. p must have bounds 1 :: n %
    procedure getPrimes ( integer array p ( * )
                        ; integer value n
                        ) ;
    if n > 0 then begin
        % have room for at least oe prime %
        integer pPos, possiblePrime;
        p( 1 )        := 2;
        pPos          := 2;
        possiblePrime := 3;
        while pPos <= n do begin
            if isPrime( possiblePrime ) then begin
                p( pPos )     := possiblePrime;
                pPos          := pPos + 1;
            end;
            possiblePrime := possiblePrime + 1
        end
    end getPrimes ;

    begin % test getPrimes %
        integer array p( 1 :: 100 );
        getPrimes( p, 100 );
        for i := 1 until 100 do begin
            if i rem 20 = 1 then write(   i_w := 4, s_w := 1, p( i ) )
                            else writeon( i_w := 4, s_w := 1, p( i ) )
        end for_i
    end

end.
