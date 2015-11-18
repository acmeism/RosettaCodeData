begin
    % declare the three arrays                                               %
    string(1) array a, b ( 1 :: 3 );
    integer   array c    ( 1 :: 3 );
    % initialise the arrays - have to do this element by element in Algol W  %
    a(1) := "a"; a(2) := "b"; a(3) := "c";
    b(1) := "A"; b(2) := "B"; b(3) := "C";
    c(1) :=  1;  c(2) :=  2;  c(3) :=  3;
    % loop over the arrays                                                   %
    for i := 1 until 3 do write( i_w := 1, s_w := 0, a(i), b(i), c(i) );
end.
