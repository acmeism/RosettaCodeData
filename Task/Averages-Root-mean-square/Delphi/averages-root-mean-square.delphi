program AveragesMeanSquare;

{$APPTYPE CONSOLE}

uses Types;

function MeanSquare(aArray: TDoubleDynArray): Double;
var
  lValue: Double;
begin
  Result := 0;

  for lValue in aArray do
    Result := Result + (lValue * lValue);
  if Result > 0 then
    Result := Sqrt(Result / Length(aArray));
end;

begin
  Writeln(MeanSquare(TDoubleDynArray.Create()));
  Writeln(MeanSquare(TDoubleDynArray.Create(1,2,3,4,5,6,7,8,9,10)));
end.
