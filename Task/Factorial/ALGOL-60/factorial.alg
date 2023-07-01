begin
	comment factorial - algol 60;
	integer procedure factorial(n); integer n;
	begin
		integer i,fact;
		fact:=1;
		for i:=2 step 1 until n do
			fact:=fact*i;
		factorial:=fact
	end;
	integer i;
	for i:=1 step 1 until 10 do outinteger(1,factorial(i));
	outstring(1,"\n")
end
