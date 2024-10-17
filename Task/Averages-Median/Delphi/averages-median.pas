program AveragesMedian;

{$APPTYPE CONSOLE}

uses Generics.Collections, Types;

function Median(aArray: TDoubleDynArray): Double;
var
  lMiddleIndex: Integer;
begin
  TArray.Sort<Double>(aArray);

  lMiddleIndex := Length(aArray) div 2;
  if Odd(Length(aArray)) then
    Result := aArray[lMiddleIndex]
  else
    Result := (aArray[lMiddleIndex - 1] + aArray[lMiddleIndex]) / 2;
end;

begin
  Writeln(Median(TDoubleDynArray.Create(4.1, 5.6, 7.2, 1.7, 9.3, 4.4, 3.2)));
  Writeln(Median(TDoubleDynArray.Create(4.1, 7.2, 1.7, 9.3, 4.4, 3.2)));
end.
