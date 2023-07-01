begin
	comment Magic squares of doubly even order - 10/02/2021;
    integer array pattern[1:4,1:4];
	integer n, r, c, s, m, i, b, t;
	n:=8;
	for r:=1 step 1 until 4 do
		for c:=1 step 1 until 4 do
			pattern[r,c]:=if
				((c=1 or c=4) and (r=1 or r=4)) or
				((c=2 or c=3) and (r=2 or r=3)) then 1 else 0;
	s:=n*n;  m:=n div 4;
	outstring(1,"magic square -- n ="); outinteger(1,n); outstring(1,"\n");
	i:=0;
	for r:=1 step 1 until n do begin
		for c:=1 step 1 until n do begin
			b:=pattern[(r-1) div m+1,(c-1) div m+1];
			if b=1 then t:=i+1 else t:=s-i;
			if t less 10 then outstring(1," ");
			outinteger(1,t);
			i:=i+1
		end;
		outstring(1,"\n")
	end;
	outstring(1,"magic constant ="); outinteger(1,(s+1)*n div 2)
end
