program DoLoop(output);
var
  i: integer;
begin
  for i := 1 to 10 do
  begin
    write(i);
    if i mod 5 = 0 then
    begin
      writeln;
      continue;
    end;
    write(', ');
  end;
end.
