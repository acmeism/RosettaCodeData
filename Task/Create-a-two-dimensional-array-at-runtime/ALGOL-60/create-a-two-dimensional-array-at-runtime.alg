 begin
    comment Create a two-dimensional array at runtime - Algol 60;
    integer n,m;
    ininteger(0,m);
    ininteger(0,n);
    begin
        integer array a[1:m,1:n];
        a[m,n] := 99;
        outinteger(1,a[m,n]);
		outstring(1,"\n")
    end;
    comment array a : out of scope;
end
