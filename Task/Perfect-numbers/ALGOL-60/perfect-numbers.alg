begin

comment - return p mod q;
integer procedure mod(p, q);
  value p, q; integer p, q;
begin
  mod := p - q * entier(p / q);
end;

comment - return true if n is perfect, otherwise false;
boolean procedure isperfect(n);
  value n; integer n;
begin
  integer sum, f1, f2;
  sum := 1;
  f1 := 1;
  for f1 := f1 + 1 while (f1 * f1) <= n do
    begin
      if mod(n, f1) = 0 then
        begin
           sum := sum + f1;
           f2 := n / f1;
           if f2 > f1 then sum := sum + f2;
        end;
    end;
  isperfect := (sum = n);
end;

comment - exercise the procedure;
integer i, found;
outstring(1,"Searching up to 10000 for perfect numbers\n");
found := 0;
for i := 2 step 1 until 10000 do
  if isperfect(i) then
    begin
      outinteger(1,i);
      found := found + 1;
    end;
outstring(1,"\n");
outinteger(1,found);
outstring(1,"perfect numbers were found");

end
