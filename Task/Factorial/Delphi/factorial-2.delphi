program Factorial2;

{$APPTYPE CONSOLE}

function FactorialRecursive(aNumber: Integer): Int64;
begin
  if aNumber < 1 then
    Result := 1
  else
    Result := aNumber * FactorialRecursive(aNumber - 1);
end;

begin
  Writeln('5! = ', FactorialRecursive(5));
end.
