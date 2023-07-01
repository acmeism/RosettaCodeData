program RomanNumeralsEncode;

{$APPTYPE CONSOLE}

function IntegerToRoman(aValue: Integer): string;
var
  i: Integer;
const
  WEIGHTS: array[0..12] of Integer = (1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1);
  SYMBOLS: array[0..12] of string = ('M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I');
begin
  for i := Low(WEIGHTS) to High(WEIGHTS) do
  begin
    while aValue >= WEIGHTS[i] do
    begin
      Result := Result + SYMBOLS[i];
      aValue := aValue - WEIGHTS[i];
    end;
    if aValue = 0 then
      Break;
  end;
end;

begin
  Writeln(IntegerToRoman(1990)); // MCMXC
  Writeln(IntegerToRoman(2008)); // MMVIII
  Writeln(IntegerToRoman(1666)); // MDCLXVI
end.
