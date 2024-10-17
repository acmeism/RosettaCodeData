program LoopFor;

{$APPTYPE CONSOLE}

var
  i, j: Integer;
begin
  for i := 1 to 5 do
  begin
    for j := 1 to i do
      Write('*');
    Writeln;
  end;
end.
