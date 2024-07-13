begin
  for var i:=1 to 10 do
  begin
    Write(i);
    if i mod 5 = 0 then
    begin
      Writeln;
      continue
    end;
    Write(', ');
  end;
end.
