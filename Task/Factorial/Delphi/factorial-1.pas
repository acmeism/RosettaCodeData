program Factorial1;

{$APPTYPE CONSOLE}

function FactorialIterative(aNumber: Integer): Int64;
var
  i: Integer;
begin
  Result := 1;
  for i := 1 to aNumber do
    Result := i * Result;
end;

begin
  Writeln('5! = ', FactorialIterative(5));
end.
