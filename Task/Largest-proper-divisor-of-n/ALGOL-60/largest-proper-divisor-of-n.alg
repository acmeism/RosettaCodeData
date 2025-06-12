begin

comment - return n mod m;
integer procedure mod(n, m);
  value n, m; integer n, m;
begin
  mod := n - entier(n/m) * m;
end;

comment - return the largest proper divisor of n;
integer procedure lpd(n);
  value n; integer n;
begin
  integer i;
  if n = 1 then
    lpd := 1
  else
    begin
      i := n/2;
      for i := i while mod(n,i) notequal 0 do
        i := i - 1;
      lpd := i;
    end;
end;

integer k;
for k := 1 step 1 until 100 do
  begin
    outinteger(1,lpd(k));
    if mod(k,10) = 0 then outstring(1,"\n");
  end;

end
