begin

comment - return n mod m;
integer procedure mod(n, m);
  value n, m; integer n, m;
begin
  mod := n - entier(n / m) * m;
end;

integer i, sq;
i := 1;
for sq := i*i while sq <= 1000 do
  begin
    if sq >= 100 and mod(sq,2) notequal 0 then
       outinteger(1, sq);
    i := i + 1;
  end;

end
