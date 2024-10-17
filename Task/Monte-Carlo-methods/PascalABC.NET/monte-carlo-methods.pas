##
for var i := 3 to 8 do
begin
  var n := integer(10 ** i);
  var count := 0;
  loop n do
    if random.sqr + random.sqr < 1 then count += 1;
  Writeln(n:10, 4 * count / n:12:8);
end;
