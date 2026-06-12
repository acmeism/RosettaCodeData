begin
    real a;
    integer n;
    read( n );
    a := n;
    while true do begin
        a := a + 3;
        a := a * 0.86;
        write( r_format := "A", r_w := 8, r_d := 5, a )
    end
end.
