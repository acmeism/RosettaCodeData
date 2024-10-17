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

    wCount     := 0;
    % find the Wagstaff primes using long reals to hold the numbers, which   %
    % accurately represent integers up to 2^53, so only consider primes < 53 %
    for p := 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47 do begin
        if wCount < 10 then begin
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
                writeon( r_format := "A", r_w := 14, r_d := 0, s_w := 0, w )
            end if_isPrime
        end if_wCount_lt_10
    end for_p ;
end.
