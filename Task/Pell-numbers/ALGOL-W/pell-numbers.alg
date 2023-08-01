begin % find some Pell numbers - trans FreeBasic ( which is trans Phix )     %

    % returns true if n is prime, false otherwise, uses trial division       %
    logical procedure isPrime ( integer value n ) ;
        if      n < 3        then n = 2
        else if n rem 3 = 0  then n = 3
        else if not odd( n ) then false
        else begin
            logical prime;
            integer f, f2, toNext;
            prime  := true;
            f      := 5;
            f2     := 25;
            toNext := 24;           % note: ( 2n + 1 )^2 - ( 2n - 1 )^2 = 8n %
            while f2 <= n and prime do begin
                prime  := n rem f not = 0;
                f      := f + 2;
                f2     := toNext;
                toNext := toNext + 8
             end while_f2_le_n_and_prime ;
             prime
        end isPrime ;

    integer MAX_P;
    MAX_P := 9;
    begin
        integer array p, pl ( 0 :: 20 );    % need more than 10 Pell numbers %
        integer c, pdx;                       % to find the fifth Pell prime %

        p(  0 ) := 0; p(  1 ) := 1;
        pl( 0 ) := 2; pl( 1 ) := 2;
        for n := 2 until 20 do begin
            p(  n ) := 2 * p(  n - 1 ) + p(  n - 2 );
            pl( n ) := 2 * pl( n - 1 ) + pl( n - 2 )
        end for_n ;

        write( "First 10 Pell numbers:" );
        for n := 0 until MAX_P do begin writeon( i_w := 1, s_w := 0, " ", p( n ) ) end;
        write();write( "First 10 Pell-Lucas numbers:" );
        for n := 0 until MAX_P do begin
            writeon( i_w := 1, s_w := 0, " ", pl( n ) )
        end for_n ;

        write( s_w := 0, "First 10 rational approximations of sqrt(2) (" );
        writeon( s_w := 0, r_format := "A", r_w := 8, r_d := 6, sqrt( 2 ), "):" );
        for n := 1 until MAX_P do begin
            integer j;
            j := pl( n ) div 2;
            write( i_w := 1, s_w := 0, " ", j, "/", p( n ), " ~= "
                 , r_format := "A", r_w := 8, r_d := 6, j / p( n )
                 )
        end for_n;

        write();write( "First 5 Pell primes:" ); write( "index Pell prime" );
        c := 0;
        pdx := 2;
        while c < 5 do begin
            if isPrime( p( pdx ) ) then begin
                write( i_w := 5, s_w := 0, pdx, " ", i_w := 1, p( pdx ) );
                c := c + 1
            end if_isPrime_p_pdx ;
            pdx := pdx + 1
        end while_c_lt_5 ;

        write(); write( "First 10 Newman-Shank-Williams numbers:" );write();
        for n := 0 until MAX_P do begin
            integer nsw;
            nsw := p( 2 * n ) + p( 2 * n + 1 );
            writeon( i_w := 1, s_w := 0, " ", nsw )
        end for_n;

        write();write( "First 10 near isosceles right triangles:" );
        begin
            integer i, i0, i1, i2, t, found;
            i0 := 0; i1 := 1; t := 1; found := 0;
            i := 1;
            while found < 10 do begin
                i  := i + 1;
                i2 := i1*2 + i0;
                if odd( i ) then begin
                    write( i_w := 1, s_w := 0, " [", t, ", ", t + 1, ", ", i2, "]" );
                    found := found + 1
                end if_odd_i ;
                t := t + i2; i0 := i1; i1 := i2
            end while_found_lt_10
        end

    end

end.
