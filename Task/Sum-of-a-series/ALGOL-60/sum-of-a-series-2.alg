begin
	
comment - return the nth term of the sequence;
real procedure fterm (n); real n;
begin
    fterm := 1.0 / (n*n);
end;
	
comment - display the nth value of the series,
    i.e., the sum of the first n terms of the
    sequence defined by f;
procedure showsum (n, f);
    value n; integer n; real procedure f;
begin
    real x, sum;
    sum := 0;
    for x := 1 step 1 until n do
	sum := sum + f(x);
    outreal(1, sum); outstring(1,"\n");
end;
		
showsum(1000, fterm);

end
