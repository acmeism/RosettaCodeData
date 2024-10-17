program ReturnMultipleValues;

{$APPTYPE CONSOLE}

procedure GetTwoValues(var aParam1, aParam2: Integer);
begin
  aParam1 := 100;
  aParam2 := 200;
end;

var
  x, y: Integer;
begin
  GetTwoValues(x, y);
  Writeln(x);
  Writeln(y);
end.
