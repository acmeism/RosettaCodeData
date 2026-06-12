% find the Pythagorian triplet a, b, c where a + b + c = 1000 %
for a := 1 until 1000 div 3 do begin
    integer a2, b;
    a2 := a * a;
    for b := a + 1 until 1000 do begin
        integer c;
        c := 1000 - ( a + b );
        if c <= b then goto endB;
        if a2 + b*b = c*c then begin
            write( i_w := 1, s_w := 0, "a = ", a, ", b = ", b, ", c = ", c );
            write( i_w := 1, s_w := 0, "a + b + c = ", a + b + c );
            write( i_w := 1, s_w := 0, "a * b * c = ", a * b * c )
        end if_a2_plus_b2_e_c2 ;
        b := b + 1
    end for_b ;
endB:
end for_a .
