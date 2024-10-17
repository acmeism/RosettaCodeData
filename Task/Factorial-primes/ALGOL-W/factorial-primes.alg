begin % find some factorial primes - primes that are f - 1 or f + 1           %
      % for some factorial f                                                  %

    % returns true if p is prime, false otherwise                             %
    logical procedure isPrime ( integer value p ) ;
        if p <= 1 or p rem 2 = 0 then p = 2
        else begin
            logical prime;
            integer rootP, i;
            prime := true;
            i     := 3;
            rootP := entier( sqrt( p ) );
            while i <= rootP and prime do begin
                prime := p rem i not = 0;
                i     := i + 2
            end;
            prime
        end isPrime ;

    % returns true if p is prime, false otherwise                             %
    logical procedure isPrimeLongReal ( long real value p ) ;
        if p <= MAXINTEGER then begin
            % p is small enough to test using integer arithmetic              %
            isPrime( entier( p ) )
            end
        else begin
            % p is too large for integer primality testing                    %
            logical prime;
            integer rootP, i;
            prime := true;
            i     := 2;
            rootP := entier( longsqrt( p ) );
            while i <= rootP and prime do begin
                long real pOverI;
                pOverI := p / i;
                prime  := roundToReal( pOverI ) not = pOverI;
                i      := if i < 3 then 3 else i + 2
            end;
            prime
        end isPrime ;

    begin
        long real f;
        integer   fpCount, n;
        fpCount := 0;
        n       := 0;
        f       := 1;
        while fpCount < 10 do begin
            long real fp;
            string(1) fpOp;
            n    := n + 1;
            f    := f * n;
            fpOp := "-";
            for offset := -1 step 2 until 1 do begin
                fp := f + offset;
                if fp < MAXINTEGER then begin
                    if isPrime( entier( fp ) ) then begin
                        fpCount := fpCount + 1;
                        write(   s_w := 0, i_w := 2, fpCount, ":" );
                        writeon( s_w := 0, i_w := 4, n, "! ", fpOp, " 1 = " );
                        writeon( s_w := 0, i_w := 1, entier( fp ) )
                    end if_isPrime__entier__fp
                    end
                else if isPrimeLongReal( fp ) then begin
                    fpCount := fpCount + 1;
                    write(   s_w := 0, i_w := 2, fpCount, ":" );
                    writeon( s_w := 0, i_w := 4, n, "! ", fpOp, " 1 = " );
                    writeon( r_format := "A", r_w := 1, r_d := 0, fp )
                end if_isPrime__fp__isPrimeLongReal__fp ;
                fpOp := "+"
            end for_fp
        end while_fpCount_lt_10
    end

end.
