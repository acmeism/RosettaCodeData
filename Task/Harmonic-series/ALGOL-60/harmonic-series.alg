begin

real i, h, n, limit;

limit := 20;
h := 0;
outstring(1,"First");
outreal(1,limit);
outstring(1,"numbers in the harmonic series\n");
for i := 1, i + 1 while i <= limit do
  begin
    h := h + 1 / i;
    outreal(1,i);
    outreal(1,h);
    outstring(1,"\n");
  end;

for i := 1, i + 1 while i <= 5 do
  begin
    h := 1;
    for n := 2, n + 1 while h <= i do
      begin
        h := h + 1 / n;
      end;
    outstring(1,"First harmonic number >");
    outreal(1,i);
    outstring(1,"is at position");
    outreal(1,n-1);
    outstring(1,"\n");
  end;

end
