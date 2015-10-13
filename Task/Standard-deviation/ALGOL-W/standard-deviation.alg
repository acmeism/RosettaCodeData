begin

    long real sum, sum2;
    integer   n;

    long real procedure sd (long real value x) ;
    begin
        sum  := sum  + x;
        sum2 := sum2 + (x*x);
        n    := n    + 1;
        if n = 0 then 0 else longsqrt(sum2/n - sum*sum/n/n)
    end sd;

    sum := sum2 := n := 0;

    r_format := "A"; r_w := 14; r_d := 6; % set output to fixed point format %

    for i := 2,4,4,4,5,5,7,9
    do begin
        long real val;
        val := i;
        write(val, sd(val))
    end for_i

end.
