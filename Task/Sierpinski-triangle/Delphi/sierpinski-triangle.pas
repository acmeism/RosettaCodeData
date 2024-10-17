program SierpinskiTriangle;

{$APPTYPE CONSOLE}

procedure PrintSierpinski(order: Integer);
var
  x, y, size: Integer;
begin
  size := (1 shl order) - 1;
  for y := size downto 0 do
  begin
    Write(StringOfChar(' ', y));
    for x := 0 to size - y do
    begin
      if (x and y) = 0 then
        Write('* ')
      else
        Write('  ');
    end;
    Writeln;
  end;
end;

begin
  PrintSierpinski(4);
end.
