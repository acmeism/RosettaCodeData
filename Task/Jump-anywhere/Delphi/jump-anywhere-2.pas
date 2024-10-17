label
  inloop, outloop;

begin
  x := 2;
  if x > 0 then
    goto inloop;

  for x := -10 to 10 do
  begin
inloop:
    Writeln(x);
    if x = 8 then
      goto outloop;
  end;
outloop:
  readln;
end.
