begin

comment - return n mod m;
integer procedure mod(n, m);
   value n, m; integer n, m;
begin
  mod := n - entier(n/m) * m;
end;

comment - return true if n has no square divisors other than 1;
boolean procedure sqfree(n);
  value n; integer n;
begin
  integer i, sq;
  boolean sqf;
  comment - quick exit for most common square;
  if mod(n,4) = 0 then sqf := false else sqf := true;
  i := 3;
  for sq := i * i while (sq <= n) and sqf do
    begin
      if mod(n, sq) = 0 then sqf := false;
      i := i + 2;
    end;
  sqfree := sqf;
end;

comment - report number of square-free integers up to limit;
procedure report(limit);
  value limit; integer limit;
begin
  integer i, count;;
  outstring(1,"Square-free integers up to");
  outinteger(1,limit);
  outstring(1,": ");
  count := 0;
  for i := 1 step 1 until limit do
    if sqfree(i) then count := count + 1;
  outinteger(1,count);
  outstring(1,"\n");
end;

integer i, count;
count := 0;
outstring(1,"Square free integers up to 145:\n");
for i := 1 step 1 until 145 do
  if sqfree(i) then
    begin
      outinteger(1,i);
      count := count + 1;
      if mod(count, 10) = 0 then outstring(1,"\n");
    end;
outinteger(1,count);
outstring(1," were found\n");

report(100);
report(1000);
report(10000);
report(100000);

end
