program Arithmetic_Rational;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Boost.Rational;

var
  sum: TFraction;
  max: Integer = 1 shl 19;
  candidate, max2, factor: Integer;

begin
  for candidate := 2 to max - 1 do
  begin
    sum := Fraction(1, candidate);
    max2 := Trunc(Sqrt(candidate));
    for factor := 2 to max2 do
    begin
      if (candidate mod factor) = 0 then
      begin
        sum := sum + Fraction(1, factor);
        sum := sum + Fraction(1, candidate div factor);
      end;
    end;
    if sum = Fraction(1) then
      Writeln(candidate, ' is perfect');
  end;
  Readln;
end.
