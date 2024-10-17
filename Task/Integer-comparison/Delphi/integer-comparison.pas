program IntegerCompare;

{$APPTYPE CONSOLE}

var
  a, b: Integer;
begin
  Readln(a, b);
  if a < b then Writeln(a, ' is less than ', b);
  if a = b then Writeln(a, ' is equal to ', b);
  if a > b then Writeln(a, ' is greater than ', b);
end.
