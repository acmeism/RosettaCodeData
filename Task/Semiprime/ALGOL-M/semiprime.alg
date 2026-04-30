begin

comment - return a mod b;
integer function mod(a, b);
  integer a, b;
begin
  mod := a - (a/b) * b;
end;

comment - return 1 if n is semi-prime, otherwise 0;
integer function semiprime(n);
  integer n;
begin
  integer i, count;
  count := 1;
  i := 2;
  while (i * i) <= n do
    begin
      if mod(n, i) = 0 then
        begin
          count := count + 1;
          n := n / i;
        end
      else
        i := i + 1;
    end;
  semiprime := (if count = 2 then 1 else 0);
end;

integer i, limit, found;
limit := 100;
found := 0;
for i := 3 step 1 until limit do
  begin
    if semiprime(i) = 1 then
      begin
        writeon(i);
        found := found + 1;
        if mod(found, 10) = 0 then write("");
      end;
  end;
write(found, " were found");

end
