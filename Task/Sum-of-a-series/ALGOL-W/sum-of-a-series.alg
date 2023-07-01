begin % compute the sum of 1/k^2 for k = 1..1000 %
    integer k;
    % computes the sum of a series from lo to hi using Jensen's Device %
    real procedure sum  ( integer %name% k; integer value lo, hi; real procedure term );
    begin
        real temp;
        temp := 0;
        k := lo;
        while k <= hi do begin
            temp := temp + term;
            k := k + 1
        end while_k_le_temp;
        temp
    end;
    write( r_format := "A", r_w := 8, r_d := 5, sum( k, 1, 1000, 1 / ( k * k ) ) )
end.
