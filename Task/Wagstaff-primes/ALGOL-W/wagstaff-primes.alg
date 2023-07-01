begin % find some Wagstaff primes: primes of the form ( 2^p + 1 ) / 3        %
      %                            where p is an odd prime                   %

    integer   wCount;

    % returns true if d exactly divides v, false otherwise                   %
    logical procedure divides( long real value d, v ) ;
    begin
        long real q, p10;
        q := v / d;
        p10 := 1;
        while p10 * 10 < q do begin
            p10 := p10 * 10
        end while_p10_lt_q ;
        while p10 >= 1 do begin
            while q >= p10 do q := q - p10;
            p10 := p10 / 10
        end while_p10_ge_1 ;
        q = 0
    end divides ;

    % prints v as a 14 digit integer number                                  %
    procedure printI14( long real value v ) ;
    begin
        integer   iv;
        long real r;
        r := abs( v );
        if v < 0 then writeon( s_w := 0, "-" );
        iv := truncate( r / 1000000 );
        if iv < 1 then begin
            writeon( i_w := 8, s_w := 0, "      ", truncate( r ) )
            end
        else begin
            string(6) sValue;
            writeon( i_w := 8, s_w := 0, iv );
            iv := truncate( abs( r ) - ( iv * 1000000.0 ) );
            for sPos := 5 step -1 until 0 do begin
                sValue( sPos // 1 ) := code( ( iv rem 10 ) + decode( "0" ) );
                iv := iv div 10
            end for_sPos;
            writeon( s_w := 0, sValue )
        end if_iv_lt_1__
    end printI ;

    wCount     := 0;
    % find the Wagstaff primes using long reals to hold the numbers, which   %
    % accurately represent integers up to 2^53, so only consider primes < 53 %
    for p := 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47 do begin
        long real w, powerOfTwo;
        logical   isPrime;
        powerOfTwo := 1;
        for i := 1 until p do powerOfTwo := powerOfTwo * 2;
        w := ( powerOfTwo + 1 ) / 3;
        isPrime := not divides( 2, w );
        if isPrime then begin
            integer   f, toNext;
            long real f2;
            f      := 3;
            f2     := 9;
            toNext := 16;
            while isPrime and f2 <= w do begin
                isPrime := not divides( f, w );
                f       := f  + 2;
                f2      := f2 + toNext;
                toNext  := toNext + 8
            end while_isPrime_and_f2_le_x
        end if_isPrime ;
        if isPrime then begin
            wCount := wCount + 1;
            write( i_w := 3, s_w := 0, wCount, ": ", p, "    " );
            if p >= 32 then printI14( w )
            else begin
                integer iw;
                iw := truncate( w );
                writeon( i_w := 14, s_w := 0, iw )
            end of_p_ge_32__ ;
            if wCount >= 10 then goto done % stop at 10 Wagstaff primes       %
        end if_isPrime
    end for_p ;
done:
end.
