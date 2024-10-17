var
  i : Integer;
begin
  i := 1024;

  while i > 0 do
  begin
    Writeln(i);
    i := i div 2;
  end;
end;
