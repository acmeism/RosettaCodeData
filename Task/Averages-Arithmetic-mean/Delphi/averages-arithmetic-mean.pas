program AveragesArithmeticMean;

{$APPTYPE CONSOLE}

uses Types;

function ArithmeticMean(aArray: TDoubleDynArray): Double;
var
  lValue: Double;
begin
  Result := 0;

  for lValue in aArray do
    Result := Result + lValue;
  if Result > 0 then
    Result := Result / Length(aArray);
end;

begin
  Writeln(Mean(TDoubleDynArray.Create()));
  Writeln(Mean(TDoubleDynArray.Create(1,2,3,4,5)));
end.
