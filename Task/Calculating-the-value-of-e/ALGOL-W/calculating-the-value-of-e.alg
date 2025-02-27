begin % calculate an approximation to e %
    long real epsilon;
    long real e0, e, f;
    integer   n;
    epsilon := 1'-14; f := 1; e := n := 2;
    while begin
        e0 := e;
        f  := f * n;
        n  := n + 1;
        e  := e + 1.0 / f;
        abs ( e - e0 ) >= epsilon
    end do begin end;
    write( I_w := 1, s_w := 0, r_format := "A", r_w := 16, r_d := 14 % <-- sets output formatting %
         , "e = ", e, " after ", n - 1, " iterations"
         )
end.
