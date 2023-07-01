program sum35;

{$APPTYPE CONSOLE}

var
  sum: integer;
  i: integer;

function isMultipleOf(aNumber, aDivisor: integer): boolean;
begin
  result := aNumber mod aDivisor = 0
end;

begin
  sum := 0;
  for i := 3 to 999 do
  begin
    if isMultipleOf(i, 3) or isMultipleOf(i, 5) then
      sum := sum + i;
  end;
  writeln(sum);
end.
