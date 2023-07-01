program Factorial3;

{$APPTYPE CONSOLE}

function FactorialTailRecursive(aNumber: Integer): Int64;

  function FactorialHelper(aNumber: Integer; aAccumulator: Int64): Int64;
  begin
    if aNumber = 0 then
      Result := aAccumulator
    else
      Result := FactorialHelper(aNumber - 1, aNumber * aAccumulator);
    end;

begin
  if aNumber < 1 then
    Result := 1
  else
    Result := FactorialHelper(aNumber, 1);
end;

begin
  Writeln('5! = ', FactorialTailRecursive(5));
end.
