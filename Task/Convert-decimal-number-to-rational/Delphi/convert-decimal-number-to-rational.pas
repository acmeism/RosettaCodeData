program Convert_decimal_number_to_rational;

{$APPTYPE CONSOLE}

uses
  Velthuis.BigRationals,
  Velthuis.BigDecimals;

const
  Tests: TArray<string> = ['0.9054054', '0.518518', '0.75'];

var
  Rational: BigRational;
  Decimal: BigDecimal;

begin
  for var test in Tests do
  begin
    Decimal := test;
    Rational := Decimal;
    Writeln(test, ' = ', Rational.ToString);
  end;
  Readln;
end.
