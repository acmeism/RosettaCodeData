begin
  integer i; real y; real array a[0:10];
  real procedure f(t); value t; real t;
    f:=sqrt(abs(t))+5*t^3;
  for i:=0 step 1 until 10 do inreal(0, a[i]);
  for i:=10 step -1 until 0 do
    begin
       y:=f(a[i]);
       if y > 400 then outstring(1, "TOO LARGE")
                  else outreal(1,y);
       outchar(1, "\n", 1)
    end
end
