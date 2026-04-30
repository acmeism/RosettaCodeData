begin % find n and m where the sums of the first n primes and first m %
      % composites where the sums are equal                           %

    integer maxCount, count, n, m, sumP, sumC, numP, numC;

    logical procedure isPrime( integer value n ) ;
    begin
        integer i, rootN;
        logical prime;
        if      n < 3        then prime := n = 2
        else if not odd( n ) then prime := false
        else begin
            prime := true;
            i     := 3;
            rootN := entier( sqrt( n ) );
            while prime and i <= rootN do begin
                prime := n rem i not= 0;
                i := i + 2
            end while_orime_and_i_le_rootN
        end if_various_n_ ;
        prime
    end isPrime ;

    maxCount := 7;
    count    := 0;
    n        := 2;
    m        := 1;
    sumP     := 5;
    sumC     := 4;
    numP     := 3;
    numC     := 4;

    write( "           sum    primes composites" );

    while count < maxCount do begin
        if sumC > sumP then begin
            while begin numP := numP + 2; not isPrime( numP ) end do begin end;
            sumP := sumP + numP;
            n := n + 1
        end if_sumC_gt_sumP ;
        IF sumP > sumC then begin
            while begin numC := numC + 1;     isPrime( numC ) end do begin end;
            sumC := sumC + numC;
            m := m + 1
        end if_sumP_gt_sumC ;
        if sumP = sumC then begin
            write( s_w := 0, i_w := 14, sumP, i_w := 10, n, i_w := 11, m );
            count := count + 1;
            if count < 8 then begin
                while begin numC := numC + 1;     isPrime( numC ) end do begin end;
                sumC := sumC + numC;
                m := m + 1
            end if_count_lt_8
        end if_sumP_eq_sumC
    end while_count_lt_maxCount

end.
